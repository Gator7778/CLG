-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local ZGV = _G.ZGV
local Data = {}
local Travel

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

Travel = ZGV.Travel
Travel.Data = Data

-----------------------------------------
-- MAP DATA
-----------------------------------------

--[[
	\s*(\[.*\]) = ([0-9]*),\n  	->	\t\1 = \2,\n
	\t(\[.*\]) = ([0-9]*)		->	\t\2##\1 = \2
	\t[0-9]*##			->	\t
--]]


Data.MapIdsByName = {
	["Clean Test"]                     	= 1,
	["Glenumbra"]                      	= 2,
	["Vaults of Madness"]              	= 3,
	["Stormhaven"]                     	= 4,
	["Rivenspire"]                     	= 5,
	["Volenfell"]                      	= 6,
	["Selene's Web"]                   	= 7,
	["Blackheart Haven"]               	= 8,
	["Stonefalls"]                     	= 9,
	["Deshaan"]                        	= 10,
	["Malabal Tor"]                    	= 11,
	["Darkshade Caverns"]              	= 12,
	["Blessed Crucible"]               	= 13,
	["Bangkorai"]                      	= 14,
	["Eastmarch"]                      	= 15,
	["The Rift"]                       	= 16,
	["Alik'r Desert"]                  	= 17,
	["Greenshade"]                     	= 18,
	["Shadowfen"]                      	= 19,
	["Root Sunder Ruins"]              	= 20,
	["Elden Hollow"]                   	= 21,
	["Crypt of Hearts"]                	= 22,
	["Tempest Island"]                 	= 23,
	["Sanguine's Demesne"]             	= 24,
	["Rulanyil's Fall"]                	= 25,
	["Crimson Cove"]                   	= 26,
	["Bonesnap Ruins"]                 	= 27,
	["Spindleclutch"]                  	= 28,
	["Wayrest Sewers"]                 	= 29,
	["Arx Corinium"]                   	= 30,
	["Emeric's Dream"]                 	= 31,
	["Obsidian Scar"]                  	= 32,
	["Cath Bedraud"]                   	= 33,
	["Bisnensel"]                      	= 34,
	["Razak's Wheel"]                  	= 35,
	["City of Ash"]                    	= 36,
	["Cyrodiil"]                       	= 37,
	["Loriasel"]                       	= 38,
	["The Apothecarium"]               	= 39,
	["Tribunal Temple"]                	= 40,
	["Reservoir of Souls"]             	= 41,
	["Ash Mountain"]                   	= 42,
	["Virak Keep"]                     	= 43,
	["Tormented Spire"]                	= 44,
	["The Harborage"]                  	= 45,
	["The Foundry of Woe"]             	= 46,
	["Castle of the Worm"]             	= 47,
	["Cheesemonger's Hollow"]          	= 48,
	["Mzeneldt"]                       	= 49,
	["Halls of Submission"]            	= 51,
	["Mournhold Sewers"]               	= 52,
	["Sunscale Ruins"]                 	= 53,
	["Lair of the Skin Stealer"]       	= 54,
	["Vision of the Hist"]             	= 55,
	["Crow's Wood"]                    	= 56,
	["The Halls of Torment"]           	= 57,
	["Circus of Cheerful Slaughter"]   	= 58,
	["Chateau of the Ravenous Rodent"] 	= 59,
	["Dresan Keep"]                    	= 60,
	["Tomb of Lost Kings"]             	= 61,
	["Breagha-Fin"]                    	= 62,
	["The Sunken Road"]                	= 63,
	["Nilata Ruins"]                   	= 65,
	["Hall of Heroes"]                 	= 66,
	["Silyanorn Ruins"]                	= 67,
	["Ruins of Ten-Maur-Wolk"]         	= 68,
	["Odious Chapel"]                  	= 69,
	["Temple of Sul"]                  	= 70,
	["White Rose Prison Dungeon"]      	= 71,
	["Impervious Vault"]               	= 72,
	["Salas En"]                       	= 73,
	["Kulati Mines"]                   	= 74,
	["House Indoril Crypt"]            	= 75,
	["Fort Arand Dungeons"]            	= 76,
	["Coral Heart Chamber"]            	= 77,
	["Heimlyn Keep Reliquary"]         	= 78,
	["Iliath Temple Mines"]            	= 79,
	["House Dres Crypts"]              	= 80,
	["Mzithumz"]                       	= 81,
	["Tal'Deic Crypts"]                	= 82,
	["Narsis Ruins"]                   	= 83,
	["The Hollow Cave"]                	= 84,
	["Shad Astula Underhalls"]         	= 85,
	["Deepcrag Den"]                   	= 86,
	["Bthanual"]                       	= 87,
	["Crosswych Mine"]                 	= 88,
	["Vaults of Vernim"]               	= 89,
	["Arcwind Point"]                  	= 90,
	["Trolhetta"]                      	= 91,
	["Lost Knife Cave"]                	= 92,
	["Bonestrewn Barrow"]              	= 93,
	["Wittestadr Crypts"]              	= 94,
	["Mistwatch Crevasse"]             	= 95,
	["Fort Morvunskar"]                	= 96,
	["Mzulft"]                         	= 97,
	["Cragwallow"]                     	= 98,
	["Eyevea"]                         	= 99,
	["Stormwarden Undercroft"]         	= 100,
	["Abamath Ruins"]                  	= 101,
	["Shrine of the Black Maw"]        	= 102,
	["Broken Tusk"]                    	= 103,
	["Atanaz Ruins"]                   	= 104,
	["Chid-Moska Ruins"]               	= 105,
	["Onkobra Kwama Mine"]             	= 106,
	["Gandranen Ruins"]                	= 107,
	["Pregame"]                        	= 108,
	["Bleakrock Isle"]                 	= 109,
	["Bal Foyen"]                      	= 110,
	["Fungal Grotto"]                  	= 111,
	["Bad Man's Hallows"]              	= 112,
	["Inner Sea Armature"]             	= 113,
	["Mephala's Nest"]                 	= 114,
	["Softloam Cavern"]                	= 115,
	["Hightide Hollow"]                	= 116,
	["Sheogorath's Tongue"]            	= 117,
	["Emberflint Mine"]                	= 118,
	["Forgotten Crypts"]               	= 119,
	["Lost City of the Na-Totambu"]    	= 120,
	["Ilessan Tower"]                  	= 121,
	["Silumm"]                         	= 122,
	["The Mines of Khuras"]            	= 123,
	["Enduum"]                         	= 124,
	["Ebon Crypt"]                     	= 125,
	["Cryptwatch Fort"]                	= 126,
	["Portdun Watch"]                  	= 127,
	["Koeglin Mine"]                   	= 128,
	["Pariah Catacombs"]               	= 129,
	["Farangel's Delve"]               	= 130,
	["Bearclaw Mine"]                  	= 131,
	["Norvulk Ruins"]                  	= 132,
	["Crestshade Mine"]                	= 133,
	["Flyleaf Catacombs"]              	= 134,
	["Tribulation Crypt"]              	= 135,
	["Orc's Finger Ruins"]             	= 136,
	["Erokii Ruins"]                   	= 137,
	["Hildune's Secret Refuge"]        	= 138,
	["Santaki"]                        	= 139,
	["Divad's Chagrin Mine"]           	= 140,
	["Aldunz"]                         	= 141,
	["Coldrock Diggings"]              	= 142,
	["Sandblown Mine"]                 	= 143,
	["Yldzuun"]                        	= 144,
	["Torog's Spite"]                  	= 145,
	["Troll's Toothpick"]              	= 146,
	["Viridian Watch"]                 	= 147,
	["Crypt of the Exiles"]            	= 148,
	["Klathzgar"]                      	= 149,
	["Rubble Butte"]                   	= 150,
	["Hall of the Dead"]               	= 151,
	["The Lion's Den"]                 	= 152,
	["Skuldafn"]                       	= 153,
	["Coldharbour"]                    	= 154,
	["Hall of Trials"]                 	= 155,
	["Cradlecrush Arena"]              	= 156,
	["The Chill Hollow"]               	= 157,
	["Icehammer's Vault"]              	= 158,
	["Old Sord's Cave"]                	= 159,
	["The Frigid Grotto"]              	= 160,
	["Stormcrag Crypt"]                	= 161,
	["The Bastard's Tomb"]             	= 162,
	["Library of Dusk"]                	= 163,
	["Lightless Oubliette"]            	= 164,
	["Lightless Cell"]                 	= 165,
	["The Black Forge"]                	= 166,
	["The Vile Laboratory"]            	= 167,
	["Reaver Citadel Pyramid"]         	= 168,
	["The Mooring"]                    	= 169,
	["Manor of Revelry"]               	= 170,
	["The Endless Stair"]              	= 171,
	["Chapel of Light"]                	= 172,
	["Grunda's Gatehouse"]             	= 173,
	["Dra'Bul"]                        	= 174,
	["Shrine of Mauloch"]              	= 175,
	["Silvenar's Audience Hall"]       	= 176,
	["The Banished Cells"]             	= 177,
	["Auridon"]                        	= 178,
	["Reaper's March"]                 	= 179,
	["Grahtwood"]                      	= 180,
	["Ragnthar"]                       	= 181,
	["Fort Virak Ruin"]                	= 182,
	["Tower of the Vale"]              	= 183,
	["Phaer Catacombs"]                	= 184,
	["Reliquary Ruins"]                	= 185,
	["The Veiled Keep"]                	= 186,
	["The Vault of Exile"]             	= 187,
	["Saltspray Cave"]                 	= 188,
	["Ezduiin Undercroft"]             	= 189,
	["The Refuge of Dread"]            	= 190,
	["Ondil"]                          	= 191,
	["Del's Claim"]                    	= 192,
	["Entila's Folly"]                 	= 193,
	["Wansalen"]                       	= 194,
	["Mehrunes' Spite"]                	= 195,
	["Bewan"]                          	= 196,
	["Shor's Stone Mine"]              	= 197,
	["Northwind Mine"]                 	= 198,
	["Fallowstone Vault"]              	= 199,
	["Lady Llarel's Shelter"]          	= 200,
	["Lower Bthanual"]                 	= 201,
	["The Triple Circle Mine"]         	= 202,
	["Taleon's Crag"]                  	= 203,
	["Knife Ear Grotto"]               	= 204,
	["The Corpse Garden"]              	= 205,
	["Avanchnzel"]                     	= 208,
	["Pinepeak Cavern"]                	= 209,
	["Trolhetta Cave"]                 	= 210,
	["Inner Tanzelwil"]                	= 211,
	["Aba-Loria"]                      	= 212,
	["The Vault of Haman Forgefire"]   	= 213,
	["The Grotto of Depravity"]        	= 214,
	["Cave of Trophies"]               	= 215,
	["Mal Sorra's Tomb"]               	= 216,
	["The Wailing Maw"]                	= 217,
	["Camlorn Keep"]                   	= 218,
	["Daggerfall Castle"]              	= 219,
	["Angof's Sanctum"]                	= 220,
	["Glenumbra Moors Cave"]           	= 221,
	["Aphren's Tomb"]                  	= 222,
	["Taarengrav Barrow"]              	= 223,
	["Nairume's Prison"]               	= 224,
	["The Orrery"]                     	= 225,
	["Cathedral of the Golden Path"]   	= 226,
	["Reliquary Vault"]                	= 227,
	["Laeloria Ruins"]                 	= 228,
	["Cave of Broken Sails"]           	= 229,
	["Ossuary of Telacar"]             	= 230,
	["Haven Sewers"]                   	= 231,
	["Ne Salas"]                       	= 232,
	["Burroot Kwama Mine"]             	= 233,
	["Mobar Mine"]                     	= 234,
	["Direfrost Keep"]                 	= 235,
	["Senelana"]                       	= 236,
	["Temple to the Divines"]          	= 237,
	["Halls of Ichor"]                 	= 238,
	["Do'Krin Temple"]                 	= 239,
	["Rawl'kha Temple"]                	= 240,
	["Five Finger Dance"]              	= 241,
	["Moonmont Temple"]                	= 242,
	["Fort Sphinxmoth"]                	= 243,
	["Thizzrini Arena"]                	= 244,
	["The Demi-Plane of Jode"]         	= 245,
	["Den of Lorkhaj"]                 	= 246,
	["Thibaut's Cairn"]                	= 247,
	["Kuna's Delve"]                   	= 248,
	["Fardir's Folly"]                 	= 249,
	["Claw's Strike"]                  	= 250,
	["Weeping Wind Cave"]              	= 251,
	["Jode's Light"]                   	= 252,
	["Dead Man's Drop"]                	= 253,
	["Tomb of Apostates"]              	= 254,
	["Hoarvor Pit"]                    	= 255,
	["Belarata"]                        = 256,
	["Shael Ruins"]                    	= 257,
	["Roots of Silvenar"]              	= 258,
	["Black Vine Ruins"]               	= 259,
	["The Scuttle Pit"]                	= 260,
	["Vinedeath Cave"]                 	= 261,
	["Wormroot Depths"]                	= 262,
	["Snapleg Cave"]                   	= 263,
	["Fort Greenwall"]                 	= 264,
	["Shroud Hearth Barrow"]           	= 265,
	["Faldar's Tooth"]                 	= 266,
	["Broken Helm Hollow"]             	= 267,
	["Toothmaul Gully"]                	= 268,
	["The Vile Manse"]                 	= 269,
	["Tormented Spire Summit"]         	= 270,
	["Breakneck Cave"]                 	= 271,
	["Capstone Cave"]                  	= 272,
	["Cracked Wood Cave"]              	= 273,
	["Echo Cave"]                      	= 274,
	["Haynote Cave"]                   	= 275,
	["Kingscrest Cavern"]              	= 276,
	["Lipsand Tarn"]                   	= 277,
	["Muck Valley Cavern"]             	= 278,
	["Newt Cave"]                      	= 279,
	["Nisin Cave"]                     	= 280,
	["Pothole Caverns"]                	= 281,
	["Quickwater Cave"]                	= 282,
	["Red Ruby Cave"]                  	= 283,
	["Serpent Hollow Cave"]            	= 284,
	["Bloodmayne Cave"]                	= 285,
	["Greenhill Catacombs"]            	= 286,
	["Sancre Tor"]                     	= 287,
	["Eyevea Mages Guild"]             	= 288,
	["Haj Uxith Corridors"]            	= 289,
	["Toadstool Hollow"]               	= 290,
	["Vahtacen"]                       	= 291,
	["Underpall Cave"]                 	= 292,
	["Stros M'Kai"]                    	= 293,
	["Betnikh"]                        	= 294,
	["Khenarthi's Roost"]              	= 295,
	["Ayleid Sanctuary"]               	= 296,
	["Glade of the Divines"]           	= 297,
	["Buraniim"]                       	= 298,
	["Dourstone Vault"]                	= 299,
	["Stonefang Cavern"]               	= 300,
	["Alcaire Keep"]                   	= 301,
	["Wayrest Castle"]                 	= 302,
	["Shrouded Hollow"]                	= 303,
	["Silatar"]                        	= 304,
	["The Middens"]                    	= 305,
	["Imperial Underground"]           	= 306,
	["Shademist Enclave"]              	= 307,
	["Ilmyris"]                        	= 308,
	["Serpent's Grotto"]               	= 309,
	["Abecean Sea"]                    	= 310,
	["Nereid Temple Cave"]             	= 311,
	["Village of the Lost"]            	= 312,
	["Hectahame Grotto"]               	= 313,
	["Valenheart"]                     	= 314,
	["Nimalten Barrow"]                	= 315,
	["Isles of Torment"]               	= 316,
	["Khaj Rawlith"]                   	= 317,
	["Ren-dro Caverns"]                	= 318,
	["Heart of the Wyrd Tree"]         	= 319,
	["The Hunting Grounds"]            	= 320,
	["Hircine's Hunting Ground"]       	= 321,
	["Ash'abah Pass"]                  	= 322,
	["Tu'whacca's Sanctum"]            	= 323,
	["Suturah's Crypt"]                	= 324,
	["Stirk"]                          	= 325,
	["The Worm's Retreat"]             	= 326,
	["The Valley of Blades"]           	= 327,
	["Carac Dena"]                     	= 328,
	["Gurzag's Mine"]                  	= 329,
	["The Underroot"]                  	= 330,
	["Naril Nagaia"]                   	= 331,
	["Harridan's Lair"]                	= 332,
	["Barrow Trench"]                  	= 333,
	["Heart's Grief"]                  	= 334,
	["Temple of Auri-El"]              	= 335,
	["Nchu Duabthar Threshold"]        	= 336,
	["The Wailing Prison"]             	= 337,
	["Fevered Mews"]                   	= 338,
	["Northpoint"]                     	= 339,
	["Edrald Undercroft"]              	= 340,
	["Lorkrata Ruins"]                 	= 341,
	["Shadowfate Cavern"]              	= 342,
	["Bangkorai Garrison"]             	= 343,
	["The Far Shores"]                 	= 344,
	["Abagarlas"]                      	= 345,
	["Blood Matron's Crypt"]           	= 347,
	["The Colored Rooms"]              	= 348,
	["Elden Root"]                     	= 349,
	["Mournhold"]                      	= 350,
	["Wayrest"]                        	= 351,
	["Craglorn"]                       	= 352,
	["Craglorn_DD_001"]                	= 353,
	["Craglorn_DD_002"]                	= 354,
	["Craglorn_DD_003"]                	= 355,
	["Craglorn_DD_004"]                	= 356,
	["Craglorn_DD_005"]                	= 357,
	["Craglorn_DD_006"]                	= 358,
	["zTest_AnchorProtoSmall"]         	= 359,
	["zTest_AnchorProtoLarger"]        	= 360,
	["Craglorn_DD_007"]                	= 361,
	["Craglorn_DD_008"]                	= 362,
	["Craglorn_DD_009"]                	= 363,
	["Craglorn_DD_010"]                	= 364,
	["Craglorn_DD_011"]                	= 365,
	["Craglorn_DD_012"]                	= 366,
	["Craglorn_DD_013"]                	= 367,
	["Craglorn_DD_014"]                	= 368,
	["Craglorn_DD_015"]                	= 369,
	["Craglorn_DD_016"]                	= 370,
	["Craglorn_DD_017"]                	= 371,
	["Craglorn_DD_018"]                	= 372,
	["Rahni'Za School"]                	= 373,
	["Craglorn_Story_reg3"]            	= 374,
	["Doomcrag"]                       	= 375,
	["Broodmother"]                    	= 376,
	["Shadowstar"]                     	= 377,
	["Graduation Instance #1"]         	= 378,
	["Guardian's Domain"]              	= 379,
	["Dragonstar Arena"]               	= 380,
	["Hel Ra Citadel"]                 	= 381,
	["Quarantine Serk Catacombs"]      	= 382,
	["The Mage Raid"]                  	= 383,
	["The Serpent Raid"]               	= 384,
	["Godrun's Dream"]                 	= 385,
	["Themond Mine"]                   	= 386,
	["The Earth Forge"]                	= 387,

	-- SUMMERSET
	["Summerset"]                      	= 388,
	["Alinor"]                         	= 389,
	["Cloudrest"]                      	= 390,
	["Crystal Tower"]                  	= 391,
	["Lillandril"]                     	= 392,
	["Rellenthil"]                     	= 393,
	["Shimmerene"]                     	= 394,
	["Sunhold"]                        	= 395,
	["Monastery Of Serene Harmony"]    	= 396,
	["Shimmerene Waterworks"]          	= 397,
	["Tor-Hame-Khard"]                 	= 398,
	["Archon's Grove"]                 	= 399,
	["Artaeum"]                        	= 400,
	["Ceporah Tower"]                  	= 401,
	["Red Temple Catacombs"]           	= 402,
	["Rellenthil Sinkhole"]            	= 403,
	["Cey-Tarn Keep"]                  	= 404,
	["The Vaults of Heinarwe"]         	= 405,
	["Wasten Coraldale"]               	= 406,
	["Alinor Royal Palace"]            	= 407,
	["Eldbur Ruins"]                   	= 408,
	["College of Psijics Ruins"]       	= 409,
	["Psijic Relic Vaults"]            	= 410,
	["K'Tora's Mindscape"]             	= 411,
	["Cairnar's Mind Trap"]            	= 412,
	["Miriya's Mind Trap"]             	= 413,
	["Oriandra's Mind Trap"]           	= 414,
	["Direnni Acropolis"]              	= 415,
	["King's Haven Pass"]              	= 416,
	["Coral-Splitter Caves"]           	= 417,
	["Ebon Sanctum"]                   	= 418,
	["Illumination Academy Stacks"]    	= 419,
	["Sea Keep"]                       	= 420,
	["College of Sapiarchs Labyrinth"] 	= 421,
	["Saltbreeze Cave"]                	= 422,
	["The Dreaming Cave"]              	= 423,
	["Eton Nir Grotto"]                	= 424,
	["The Spiral Skein"]               	= 425,
	["Traitor's Vault"]                	= 426,
	["Evergloam"]                      	= 427,
	["Corgrad Wastes"]                 	= 428,
	["Karnwasten"]                     	= 429,
	["Cathedral of Webs"]              	= 430,
	["Crystal Tower"]                  	= 431,
	["Altar Room"]                      = 478,
	["The Gorge - Cey-Tarn Keep"]		= 479,

	-- MURKMIRE
	["Lilmoth"]                         = 432,
	["Murkmire"]                        = 433,
	["Ixtaxh Xanmeer"]                  = 434,
	["Bright-Throat Village"]           = 435,
	["Blight Bog Sump"]                 = 436,
	["Wither-Vault"]                    = 437,
	["Swallowed Grove"]                 = 438,
	["Dead-Water Village"]              = 439,
	["Tomb of Many Spears"]             = 440,
	["The Dreaming Nest"]               = 441,
	["The Mists"]                       = 442,
	["Xul-Thuxis"]                      = 443,
	["Root-Whisper Village"]            = 444,
	["Vakka-Bok Village"]               = 445,
	["Deep-Root"]                       = 446,
	["Remnant of Argon"]                = 447,

	-- NORTHERN ELSWEYR
	["Elsweyr"]                         = 448,
	["Rimmen"]                          = 449,
	["Riverhold"]                       = 450,
	["Adobe of Ignominy"]               = 451,
	["Tomb of the Serpents"]            = 452,
	["Smuggler's Hideout"]              = 453,
	["The Stitches"]                    = 454,
	["Sleepy Senche Mine"]              = 455,
	["Cicatrice Caverns"]               = 456,
	["Meirvale Keep Dungeons"]          = 457,
	["Meirvale Keep Courtyard"]         = 458,
	["Meirvale Keep Palace"]            = 459,
	["Meirvale Keep Dugout"]            = 460,
	["Rimmen Palace Recesses"]          = 461,
	["Desert Wind Caverns"]             = 462,
	["Riverhold"]                       = 463,
	["Hakoshae Tombs"]                  = 464,
	["Merryvale Sugar Farm Caves"]      = 465,
	["Skooma Cat's Cloister"]           = 466,
	["Rimmen Palace Crypts"]            = 467,
	["Rimmen Palace"]                   = 468,
	["Rimmen Palace Courtyard"]         = 469,
	["Dov-Vahl Shrine"]                 = 470,
	["Sepulcher of Mischance"]          = 471,
	["Shadow Dance Temple"]             = 472,
	["Vault of Heavenly Scourge"]       = 473,
	["Moon Gate of Anequina"]           = 474,
	["Jode's Core"]                     = 475,
	["Darkpool Mine"]                   = 476,
	["The Tangle"]                      = 477,

	-- WESTERN SKYRIM
	["Riften Ratway"]                   = 478,
	["Riften Ratway"]                   = 479,
	["Blackreach: Mzark Cavern"]        = 480,
	["Palace of Kings"]                 = 481,
	["Palace of Kings"]                 = 482,
	["Palace of Kings"]                 = 483,
	["Western Skyrim"]                  = 484,
	["Solitude"]                        = 485,
	["Kilkreath"]                       = 486,
	["Shadowgreen"]                     = 487,
	["Shadowgreen"]                     = 488,
	["Dragon Bridge Smuggler Caves"]    = 489,
	["Dragonhome"]                      = 490,
	["Mor Khazgur Mine"]                = 491,
	["Chillwind Depths"]                = 482,
	["Bleakridge Barrow"]               = 493,
	["Red Eagle Ridge"]                 = 494,
	["Blackreach: Greymoor Caverns"]    = 495,
	["Kagnthamz"]                       = 496,
	["Verglas Hollow"]                  = 497,
	["Verglas Hollow Boss"]             = 498,
	["Frozen Coast"]                    = 499,
	["Morthal Barrow"]                  = 500,
	["Tzinghalis's Tower"]              = 501,
	["Lightless Hollow Mine"]           = 502,
	["Bthang Outpost"]                  = 503,
	["Dark Moon Grotto Refuge"]         = 504,
	["The Scraps"]                      = 505,
	["Midnight Barrow"]                 = 506,
	["The Undergrove"]                  = 507,
	["Greymoor Keep: West Wing"]        = 508,
	["Greymoor Keep: West Wing"]        = 509,
	["Greymoor Keep: West Wing"]        = 510,
	["Greymoor Keep"]                   = 511,
	["Greymoor Keep"]                   = 512,
	["Greymoor Keep"]                   = 513,
	["Gray Host Tunnels"]               = 514,

	-- THE REACH
	["Gray Host Sanctuary"]             = 515,
	["Grayhome"]                        = 516,
	["Castle Grayhome"]                 = 517,
	["Castle Grayhome"]                 = 518,
	["Castle Grayhome"]                 = 519,
	["Castle Grayhome"]                 = 520,
	["Grayhome Ritual Chamber"]         = 521,
	["The Reach"]                       = 522,
	["Markarth"]                        = 523,
	["Understone Keep"]                 = 524,
	["Valthume"]                        = 525,
	["Reachwind Depths"]                = 526,
	["Reachwind Depths"]                = 527,
	["Reachwind Depths"]                = 528,
	["Reachwind Depths"]                = 529,
	["Reachwind Depths"]                = 530,
	["Reachwind Depths"]                = 531,
	["Briar Rock Ruins"]                = 532,
	["Briar Rock Crypts"]               = 533,
	["Dead Crone Tower"]                = 534,
	["Sanuarach Mine"]                  = 535,
	["Bthar-Zel"]                       = 536,
	["Bthar-Zel Bank"]                  = 537,
	["Bthar-Zel Vault"]                 = 538,
	["Blackreach: Arkthzand Cavern"]    = 539,
	["Halls of Arkthzand"]              = 540,
	["Arkthzand Orrery"]                = 541,
	["Gloomreach"]                      = 542,
	["Gloomreach"]                      = 543,
	["Gloomreach"]                      = 544,
	["Gloomreach"]                      = 545,
	["Gloomreach"]                      = 546,
	["Gloomreach"]                      = 547,
	["Gloomreach"]                      = 548,
	["Lost Valley Redoubt"]             = 549,
	["The Dark Descent"]                = 550,
	["Nighthollow Keep"]                = 551,
	["Nighthollow Keep"]                = 552,
	["Nighthallow Keep"]                = 553,
	["Chamber of the Dark Heart"]       = 554,
	["Nchuand-Zel"]                     = 555,
	["Nchuand-Zel Map"]                 = 556,
	["Nchuand-Zel Map"]                 = 557,
	["Nchuand-Zel Map"]                 = 558,
	["Arkthzand Orrery"]                = 559,
	["Halls of Akthzand"]               = 560,
	["Halls of Akthzand"]               = 561,
	["Halls of Akthzand"]               = 562,
	["Chamber of the Dark Heart"]       = 563,
	["Grayhaven"]                       = 564,
	["Understone Keep"]                 = 565,
	["Bthar-Zel Repository"]            = 566,

}

-----------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------

function Data:CollectMapIds()
	local sv = ZGV.sv.profile
	sv.mapids = {}

	for i = 0,1000 do
		local loczone, _ = _G.GetZoneInfo(i)
		sv.mapids[loczone] = i
	end
end
