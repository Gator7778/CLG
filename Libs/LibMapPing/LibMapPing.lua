local LIB_IDENTIFIER = "LibMapPing"
local lib = _G.LibStub:NewLibrary(LIB_IDENTIFIER, 7)
local EVENT_MANAGER = _G.EVENT_MANAGER

if not lib then
    return
end

local function Log(message, ...)
    _G.df("[%s] %s", LIB_IDENTIFIER, message:format(...))
end

local DEFAULT_MODIFIER = 2.15
local COMBAT_MODIFIER = 39
local FILL_RATE = 0.512
local BUCKET_SIZE = 100
local SAFETY_THRESHOLD = 10
local TIME_FRAME = 3
local RESOLUTION = 10

local ZO_Object = _G.ZO_Object
local RollingAverage = ZO_Object:Subclass()
local GetMapRallyPoint = _G.GetMapRallyPoint

local PING_EVENT_ADDED = _G.PING_EVENT_ADDED
local PING_EVENT_REMOVED = _G.PING_EVENT_REMOVED
local EVENT_MAP_PING = _G.EVENT_MAP_PING
local PingMap = _G.PingMap
local GetMapPing = _G.etMapPing
local GetGameTimeMilliseconds = _G.GetGameTimeMilliseconds

local PlaySound = _G.PlaySound
local SOUNDS = _G.SOUNDS

local GetCurrentMapZoneIndex = _G.GetCurrentMapZoneIndex
local GetMapPlayerWaypoint = _G.GetMapPlayerWaypoint
local RemovePlayerWaypoint = _G.RemovePlayerWaypoint
local RemoveRallyPoint = _G.RemoveRallyPoint

local EVENT_ADD_ON_LOADED = _G.EVENT_ADD_ON_LOADED

local ZO_WorldMapPins = _G.ZO_WorldMapPins

function RollingAverage:New(...)
    local obj = ZO_Object.New(self)
    obj:Initialize(...)
    return obj
end

function RollingAverage:Initialize(timeframe, resolution)
    self.timeframe = timeframe
    self.resolution = resolution
    self.count = timeframe * resolution
    self.sumList = {}
    self.lastIndex = self:GetCurrentIndex()

    for i = 1, self.count do
        self.sumList[i] = 0
    end
end

function RollingAverage:GetCurrentIndex()
    return math.floor(self.resolution * GetGameTimeMilliseconds() / 1000) % self.count
end

function RollingAverage:Increment()
    local index = self:GetCurrentIndex()
    while self.lastIndex ~= index do
        self.lastIndex = (self.lastIndex + 1) % self.count
        self.sumList[self.lastIndex] = 0
    end
    self.sumList[index] = self.sumList[index] + 1
end

function RollingAverage:GetAverage()
    local index = self:GetCurrentIndex()
    local average = 0
    for i = 1, self.count do
        if(i ~= index) then
            average = average + self.sumList[i]
        end
    end
    return math.floor(average / (self.count - 1) * self.resolution)
end


local LeakyBucket = ZO_Object:Subclass()

function LeakyBucket:New(...)
    local obj = ZO_Object.New(self)
    obj:Initialize(...)
    return obj
end

function LeakyBucket:Initialize()
    self.average = RollingAverage:New(TIME_FRAME, RESOLUTION)
    self.size = BUCKET_SIZE
    self.generatedTokens = 1 / FILL_RATE
    self.safetyThreshold = SAFETY_THRESHOLD

    self.left = self.size
    self.lastCheck = GetGameTimeMilliseconds()
end

function LeakyBucket:GetTokensLeft()
    local now = GetGameTimeMilliseconds()
    local average = self.average:GetAverage()
    local modifier = _G.IsUnitInCombat("player") and COMBAT_MODIFIER or DEFAULT_MODIFIER
    local burstRate = average * modifier

    local delta = (now - self.lastCheck) / 1000
    self.left = math.min(self.left + delta * self.generatedTokens, self.size);
    self.lastCheck = now
    return self.left
end

function LeakyBucket:HasTokensLeft()
    return self:GetTokensLeft() > self.safetyThreshold
end

function LeakyBucket:Take()
    if(self:HasTokensLeft()) then
        self.left = self.left - 1
        self.average:Increment()
        return true
    end
    return false
end


local MAP_PIN_TYPE_PLAYER_WAYPOINT = _G.MAP_PIN_TYPE_PLAYER_WAYPOINT
local MAP_PIN_TYPE_PING = _G.MAP_PIN_TYPE_PING
local MAP_PIN_TYPE_RALLY_POINT = _G.MAP_PIN_TYPE_RALLY_POINT

local MAP_PIN_TAG_PLAYER_WAYPOINT = "waypoint"
local MAP_PIN_TAG_RALLY_POINT = "rally"
local PING_CATEGORY = "pings"

local PING_EVENT_WATCHDOG_TIME = 400

local MAP_PIN_TAG = {
    [MAP_PIN_TYPE_PLAYER_WAYPOINT] = MAP_PIN_TAG_PLAYER_WAYPOINT,
    [MAP_PIN_TYPE_RALLY_POINT] = MAP_PIN_TAG_RALLY_POINT,
}

local originalPingMap, originalRemovePlayerWaypoint, originalRemoveRallyPoint
local GET_MAP_PING_FUNCTION = {}
local REMOVE_MAP_PING_FUNCTION = {}


lib.MAP_PING_NOT_SET = 0
lib.MAP_PING_NOT_SET_PENDING = 1
lib.MAP_PING_SET_PENDING = 2
lib.MAP_PING_SET = 3

lib.mutePing = lib.mutePing or {}
lib.suppressPing = lib.suppressPing or {}
lib.pingState = lib.pingState or {}
lib.pendingPing = lib.pendingPing or {}
lib.cm = lib.cm or _G.ZO_CallbackObject:New()
lib.bucket = LeakyBucket:New()
local g_mapPinManager = lib.mapPinManager

local function GetPingTagFromType(pingType)
	local GetGroupUnitTagByIndex = _G.GetGroupUnitTagByIndex
	local GetGroupIndexByUnitTag = _G.GetGroupIndexByUnitTag
    return MAP_PIN_TAG[pingType] or GetGroupUnitTagByIndex(GetGroupIndexByUnitTag("player")) or ""
end

local function GetKey(pingType, pingTag)
    pingTag = pingTag or GetPingTagFromType(pingType)
    return string.format("%d_%s", pingType, pingTag)
end

local function HandleMapPing(eventCode, pingEventType, pingType, pingTag, x, y, isPingOwner)
    local key = GetKey(pingType, pingTag)
    local data = lib.pendingPing[key]
    if data and data[1] == pingEventType then
        lib.pendingPing[key] = nil
    end
    if(pingEventType == PING_EVENT_ADDED) then
        lib.cm:FireCallbacks("BeforePingAdded", pingType, pingTag, x, y, isPingOwner)
        lib.pingState[key] = lib.MAP_PING_SET
        g_mapPinManager:RemovePins(PING_CATEGORY, pingType, pingTag)
        if(not lib:IsPingSuppressed(pingType, pingTag)) then
            g_mapPinManager:CreatePin(pingType, pingTag, x, y)
            if(isPingOwner and not lib:IsPingMuted(pingType, pingTag)) then
                PlaySound(SOUNDS.MAP_PING)
            end
        end
        lib.cm:FireCallbacks("AfterPingAdded", pingType, pingTag, x, y, isPingOwner)
    elseif(pingEventType == PING_EVENT_REMOVED) then
        lib.cm:FireCallbacks("BeforePingRemoved", pingType, pingTag, x, y, isPingOwner)
        lib.pingState[key] = lib.MAP_PING_NOT_SET
        g_mapPinManager:RemovePins(PING_CATEGORY, pingType, pingTag)
        if (isPingOwner and not lib:IsPingSuppressed(pingType, pingTag) and not lib:IsPingMuted(pingType, pingTag)) then
            PlaySound(SOUNDS.MAP_PING_REMOVE)
        end
        lib.cm:FireCallbacks("AfterPingRemoved", pingType, pingTag, x, y, isPingOwner)
    end
end

local function HandleMapPingEventNotFired()
    EVENT_MANAGER:UnregisterForUpdate(LIB_IDENTIFIER)
    for key, data in pairs(lib.pendingPing) do
        local pingEventType, pingType, x, y, zoneIndex = unpack(data)
        local pingTag = GetPingTagFromType(pingType)
        if GetCurrentMapZoneIndex() ~= zoneIndex then
            lib:SuppressPing(pingType, pingTag)
        end
        HandleMapPing(0, pingEventType, pingType, pingTag, x, y, true)
        lib.pendingPing[key] = nil
        lib.mutePing[key] = 0
        lib.suppressPing[key] = 0
    end
end

local function ResetEventWatchdog(key, ...)
    lib.pendingPing[key] = {...}
    EVENT_MANAGER:UnregisterForUpdate(LIB_IDENTIFIER)
    EVENT_MANAGER:RegisterForUpdate(LIB_IDENTIFIER, PING_EVENT_WATCHDOG_TIME, HandleMapPingEventNotFired)
end

local function CustomPingMap(pingType, mapType, x, y)
    if(pingType == MAP_PIN_TYPE_PING and not _G.IsUnitGrouped("player")) then return end
    if(pingType == MAP_PIN_TYPE_PLAYER_WAYPOINT or lib.bucket:Take()) then
        local key = GetKey(pingType)
        lib.pingState[key] = lib.MAP_PING_SET_PENDING
        ResetEventWatchdog(key, PING_EVENT_ADDED, pingType, x, y, GetCurrentMapZoneIndex())
        return originalPingMap(pingType, mapType, x, y)
    end
end

local function CustomGetMapPlayerWaypoint()
    if(lib:IsPingSuppressed(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_PIN_TAG_PLAYER_WAYPOINT)) then
        return 0, 0
    end
    return GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_PLAYER_WAYPOINT]()
end

local function CustomGetMapPing(pingTag)
    if(lib:IsPingSuppressed(MAP_PIN_TYPE_PING, pingTag)) then
        return 0, 0
    end
    return GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_PING](pingTag)
end

local function CustomGetMapRallyPoint()
    if(lib:IsPingSuppressed(MAP_PIN_TYPE_RALLY_POINT, MAP_PIN_TAG_RALLY_POINT)) then
        return 0, 0
    end
    return GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_RALLY_POINT]()
end

local function CustomRemovePlayerWaypoint()
    local key = GetKey(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_PIN_TAG_PLAYER_WAYPOINT)
    lib.pingState[key] = lib.MAP_PING_NOT_SET_PENDING
    ResetEventWatchdog(key, PING_EVENT_REMOVED, MAP_PIN_TYPE_PLAYER_WAYPOINT, 0, 0, GetCurrentMapZoneIndex())
    return originalRemovePlayerWaypoint()
end

local function CustomRemoveMapPing()
    PingMap(MAP_PIN_TYPE_PING, _G.MAP_TYPE_LOCATION_CENTERED, 0, 0)
end

local function CustomRemoveRallyPoint()
    local key = GetKey(MAP_PIN_TYPE_RALLY_POINT, MAP_PIN_TAG_RALLY_POINT)
    lib.pingState[key] = lib.MAP_PING_NOT_SET_PENDING
    ResetEventWatchdog(key, PING_EVENT_REMOVED, MAP_PIN_TYPE_RALLY_POINT, 0, 0)
    originalRemoveRallyPoint()
end

function lib:SetMapPing(pingType, mapType, x, y)
    PingMap(pingType, mapType, x, y)
end

function lib:RemoveMapPing(pingType)
    if(REMOVE_MAP_PING_FUNCTION[pingType]) then
        REMOVE_MAP_PING_FUNCTION[pingType]()
    end
end

function lib:GetMapPing(pingType, pingTag)
    local x, y = 0, 0
    if(GET_MAP_PING_FUNCTION[pingType]) then
        x, y = GET_MAP_PING_FUNCTION[pingType](pingTag or GetPingTagFromType(pingType))
    end
    return x, y
end

function lib:GetMapPingState(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    local state = lib.pingState[key]
    if state == nil then
        local x, y = lib:GetMapPing(pingType, pingTag)
        state = (x ~= 0 or y ~= 0) and lib.MAP_PING_SET or lib.MAP_PING_NOT_SET
        lib.pingState[key] = state
    end
    return lib.pingState[key]
end

function lib:HasMapPing(pingType, pingTag)
    local state = lib:GetMapPingState(pingType, pingTag)
    return state == lib.MAP_PING_SET_PENDING or state == lib.MAP_PING_SET
end

function lib:RefreshMapPin(pingType, pingTag)
    if(not g_mapPinManager) then
        Log("PinManager not available. Using ZO_WorldMap_UpdateMap instead.")
        _G.ZO_WorldMap_UpdateMap()
        return true
    end

    pingTag = pingTag or GetPingTagFromType(pingType)
    g_mapPinManager:RemovePins(PING_CATEGORY, pingType, pingTag)

    local x, y = lib:GetMapPing(pingType, pingTag)
    if(lib:IsPositionOnMap(x, y)) then
        g_mapPinManager:CreatePin(pingType, pingTag, x, y)
        return true
    end
    return false
end

function lib:IsPositionOnMap(x, y)
    return not (x < 0 or y < 0 or x > 1 or y > 1 or (x == 0 and y == 0))
end

function lib:MutePing(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    local mute = lib.mutePing[key] or 0
    lib.mutePing[key] = mute + 1
end

function lib:UnmutePing(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    local mute = (lib.mutePing[key] or 0) - 1
    if(mute < 0) then mute = 0 end
    lib.mutePing[key] = mute
end

function lib:IsPingMuted(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    return lib.mutePing[key] and lib.mutePing[key] > 0
end

function lib:SuppressPing(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    local suppress = lib.suppressPing[key] or 0
    lib.suppressPing[key] = suppress + 1
end

function lib:UnsuppressPing(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    local suppress = (lib.suppressPing[key] or 0) - 1
    if(suppress < 0) then suppress = 0 end
    lib.suppressPing[key] = suppress
end

function lib:IsPingSuppressed(pingType, pingTag)
    local key = GetKey(pingType, pingTag)
    return lib.suppressPing[key] and lib.suppressPing[key] > 0
end

local function InterceptMapPinManager()
    if (g_mapPinManager) then return end
    local orgRefreshCustomPins = ZO_WorldMapPins.RefreshCustomPins
    function ZO_WorldMapPins:RefreshCustomPins()
        g_mapPinManager = self
        lib.mapPinManager = self
    end
    _G.ZO_WorldMap_RefreshCustomPinsOfType()
    ZO_WorldMapPins.RefreshCustomPins = orgRefreshCustomPins
end

function lib:RegisterCallback(eventName, callback)
    lib.cm:RegisterCallback(eventName, callback)
end

function lib:UnregisterCallback(eventName, callback)
    lib.cm:UnregisterCallback(eventName, callback)
end

local function Unload()
    EVENT_MANAGER:UnregisterForEvent(LIB_IDENTIFIER, EVENT_ADD_ON_LOADED)
    EVENT_MANAGER:UnregisterForEvent(LIB_IDENTIFIER, EVENT_MAP_PING)
    PingMap = originalPingMap
    GetMapPlayerWaypoint = GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_PLAYER_WAYPOINT]
    GetMapPing = GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_PING]
    GetMapRallyPoint = GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_RALLY_POINT]
    RemovePlayerWaypoint = originalRemovePlayerWaypoint
    RemoveRallyPoint = originalRemoveRallyPoint
end

local function Load()
    InterceptMapPinManager()

    originalPingMap = PingMap
    PingMap = CustomPingMap

    GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_PLAYER_WAYPOINT] = GetMapPlayerWaypoint
    GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_PING] = GetMapPing
    GET_MAP_PING_FUNCTION[MAP_PIN_TYPE_RALLY_POINT] = GetMapRallyPoint
    GetMapPlayerWaypoint = CustomGetMapPlayerWaypoint
    GetMapPing = CustomGetMapPing
    GetMapRallyPoint = CustomGetMapRallyPoint

    originalRemovePlayerWaypoint = RemovePlayerWaypoint
    originalRemoveRallyPoint = RemoveRallyPoint
    RemovePlayerWaypoint = CustomRemovePlayerWaypoint
    RemoveRallyPoint = CustomRemoveRallyPoint
    REMOVE_MAP_PING_FUNCTION[MAP_PIN_TYPE_PLAYER_WAYPOINT] = CustomRemovePlayerWaypoint
    REMOVE_MAP_PING_FUNCTION[MAP_PIN_TYPE_PING] = CustomRemoveMapPing
    REMOVE_MAP_PING_FUNCTION[MAP_PIN_TYPE_RALLY_POINT] = CustomRemoveRallyPoint

    EVENT_MANAGER:RegisterForEvent(LIB_IDENTIFIER, EVENT_ADD_ON_LOADED, function(_, addonName)
        if(addonName == "ZO_Ingame") then
            EVENT_MANAGER:UnregisterForEvent(LIB_IDENTIFIER, EVENT_ADD_ON_LOADED)
            EVENT_MANAGER:UnregisterForEvent("ZO_WorldMap", EVENT_MAP_PING)
            EVENT_MANAGER:RegisterForEvent(LIB_IDENTIFIER, EVENT_MAP_PING, HandleMapPing)
        end
    end)

    lib.Unload = Unload
end

if(lib.Unload) then lib.Unload() end
Load()
