--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandruff @ Whisperwind-US  ]
 [  xCT+ Version 3.x.x                 ]
 [  ©2012. All Rights Reserved.        ]
 [====================================]]
 
local ADDON_NAME, addon = ...

-- =====================================================
-- CreateMergeSpellEntry(
--    class,       [string] - class name that spell belongs to
--    interval,       [int] - How often to update merged data (in seconds)
--    prep,           [int] - The minimum time to wait to update merged data (NOT USED YET)
--  )
--    Creates a merge settings entry for a spell.
-- =====================================================
local function CreateMergeSpellEntry(class, interval, prep)
  return {
         class = class      or "ITEM",
      interval = interval   or 3,
          prep = prep       or 0,
    }
end

-- Filter These Spells Remove
-- [1949] - Damage to Self

-- List of Spells that need to be merged
addon.merges = {
-- death knight (damage)
  [55095]  = CreateMergeSpellEntry("DEATHKNIGHT"),      -- Frost Fever
  [55078]  = CreateMergeSpellEntry("DEATHKNIGHT"),      -- Blood Plague
  [48721]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Blood Boil                                 (INSTANT)
  [49184]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Howling Blast                              (INSTANT)
  [52212]  = CreateMergeSpellEntry("DEATHKNIGHT"),      -- Death and Decay
  [55050]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Heart Strike                               (INSTANT)
  [91776]  = CreateMergeSpellEntry("DEATHKNIGHT", 4),   -- Claw (Army of the Dead's Auto-Attack)      (http://www.wowhead.com/spell=42650#comments:id=989522)
  
-- death knight (healing) 
  [53365]  = CreateMergeSpellEntry("DEATHKNIGHT", 4),   -- Unholy Strength
  [81280]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Blood Burst                                (INSTANT)
  [119980] = CreateMergeSpellEntry("DEATHKNIGHT", 4),   -- Conversion
  
-- druid (damage)
  [8921]   = CreateMergeSpellEntry("DRUID"),            -- Moonfire
  [93402]  = CreateMergeSpellEntry("DRUID"),            -- Sunfire
  [5570]   = CreateMergeSpellEntry("DRUID"),            -- Insect Swarm
  [42231]  = CreateMergeSpellEntry("DRUID"),            -- Hurricane
  [50288]  = CreateMergeSpellEntry("DRUID"),            -- Starfall
  [78777]  = CreateMergeSpellEntry("DRUID"),            -- Wild Mushroom: Detonate	
  [61391]  = CreateMergeSpellEntry("DRUID", .5),        -- Typhoon                                    (INSTANT)
  [1822]   = CreateMergeSpellEntry("DRUID"),            -- Rake
  [62078]  = CreateMergeSpellEntry("DRUID", .5),        -- Swipe (Cat)                                (INSTANT)
  [779]    = CreateMergeSpellEntry("DRUID", .5),        -- Swipe (Bear)                               (INSTANT)
  [33745]  = CreateMergeSpellEntry("DRUID"),            -- Lacerate
  [1079]   = CreateMergeSpellEntry("DRUID", 2),         -- Rip
  [106830] = CreateMergeSpellEntry("DRUID", 4),         -- Thrash (Cat)
  [77758]  = CreateMergeSpellEntry("DRUID", 4),         -- Thrash (Bear)
  [106998] = CreateMergeSpellEntry("DRUID"),            -- Astral Storm                               (Every 1s for 10s)

-- druid (healing)
  [774]    = CreateMergeSpellEntry("DRUID"),            -- Rejuvenation
  [48438]  = CreateMergeSpellEntry("DRUID"),            -- Wild Growth
  [8936]   = CreateMergeSpellEntry("DRUID"),            -- Regrowth
  [33763]  = CreateMergeSpellEntry("DRUID"),            -- Lifebloom
  [44203]  = CreateMergeSpellEntry("DRUID"),            -- Tranquility
  [81269]  = CreateMergeSpellEntry("DRUID"),            -- Swiftmend (Efflorescence)

-- hunter
  [2643]   = CreateMergeSpellEntry("HUNTER", .5),       -- Multi-Shot                                 (INSTANT)
  [118459] = CreateMergeSpellEntry("HUNTER", .5),       -- Beast Cleave                               (INSTANT)
  [83077]  = CreateMergeSpellEntry("HUNTER", .5),       -- Serpent Sting (Instant Serpent Spread)     (INSTANT)
  [118253] = CreateMergeSpellEntry("HUNTER"),           -- Serpent Sting (Tick)
  [13812]  = CreateMergeSpellEntry("HUNTER"),           -- Explosive Trap
  [53301]  = CreateMergeSpellEntry("HUNTER"),           -- Explosive Shot (3 ticks merged as one)
  [63468]  = CreateMergeSpellEntry("HUNTER"),           -- Piercing Shots
  [3674]   = CreateMergeSpellEntry("HUNTER", 4),        -- Black Arrow                                (Every 2s for 20s)
  [131900] = CreateMergeSpellEntry("HUNTER", 6),        -- A Murder of Crows                          (Over 30s)
  [120699] = CreateMergeSpellEntry("HUNTER", 4),        -- Lynx Rush                                  (9x over 4s)
  [120361] = CreateMergeSpellEntry("HUNTER", 4),        -- Barrage                                    (Channeled over 3s) 4 to be safe :P
	[121414] = CreateMergeSpellEntry("HUNTER"),        		-- Glaive Toss
  [120761] = CreateMergeSpellEntry("HUNTER"),						-- Glaive Toss (2)
	
-- mage
  [44461]  = CreateMergeSpellEntry("MAGE", .5),         -- Living Bomb                                (INSTANT)
  [44457]  = CreateMergeSpellEntry("MAGE", 4),          -- Living Bomb (DOT)                          (over 8 seconds)
  [2120]   = CreateMergeSpellEntry("MAGE", 4),          -- Flamestrike                                (Over 4 seconds)
  [12654]  = CreateMergeSpellEntry("MAGE"),             -- Ignite
  [11366]  = CreateMergeSpellEntry("MAGE"),             -- Pyroblast
  [31661]  = CreateMergeSpellEntry("MAGE", .5),         -- Dragon's Breath                            (INSTANT)
  [42208]  = CreateMergeSpellEntry("MAGE"),             -- Blizzard
  [122]    = CreateMergeSpellEntry("MAGE", .5),         -- Frost Nova                                 (INSTANT)
  [1449]   = CreateMergeSpellEntry("MAGE", .5),         -- Arcane Explosion                           (INSTANT)
  [83853]  = CreateMergeSpellEntry("MAGE"),             -- Combustion
  [11113]  = CreateMergeSpellEntry("MAGE"),             -- Blast Wave
  [83619]  = CreateMergeSpellEntry("MAGE", .5),         -- Flame Orb                                  (INSTANT)
  [120]    = CreateMergeSpellEntry("MAGE"),             -- Cone of Cold
  [114954] = CreateMergeSpellEntry("MAGE"),             -- Nether Tempest                             (Every 1s for 12s)
  [114923] = CreateMergeSpellEntry("MAGE"),             -- Nether Tempest (50% to random player)      (Every 1s for 12s)
  
-- monk (damage)
  [113656] = CreateMergeSpellEntry("MONK"),             -- Fists of Fury                              (Instant w/ every 1s for 4s)
  [107270] = CreateMergeSpellEntry("MONK", 2.5),        -- Spinning Crane Kick                        (Over 2s)
  [128531] = CreateMergeSpellEntry("MONK", 4),          -- Blackout Kick (DoT)                        (Every 1s for 4s)
  [117418] = CreateMergeSpellEntry("MONK", 4),          -- Fists of Fury                              (Every 1s for 4s)
  [121253] = CreateMergeSpellEntry("MONK", .5),         -- Keg Smash                                  (INSTANT)
  [115181] = CreateMergeSpellEntry("MONK", .5),         -- Breath of Fire                             (INSTANT)
  [124098] = CreateMergeSpellEntry("MONK", 6),          -- Zen Sphere (Damage)                        (2 sec for 16 sec)
  [125033] = CreateMergeSpellEntry("MONK", .5),         -- Zen Sphere: Detonate (Damage)              (INSTANT)
  [132467] = CreateMergeSpellEntry("MONK", 6),          -- Chi Wave (Damage)
  
-- monk (healing)
  [117640] = CreateMergeSpellEntry("MONK", 2.5),        -- Spinning Crane Kick (Heal)                 (Over 2s)
  [119611] = CreateMergeSpellEntry("MONK", 6),          -- Renewing Mist                              (Every 3s for 18s)
  [115175] = CreateMergeSpellEntry("MONK", 4.5),        -- Soothing Mist                              (Every 1s for 8s)
  [125953] = CreateMergeSpellEntry("MONK", 4.5),        -- Soothing Mist (Statue)                     (Every 1s for 8s)
  [132120] = CreateMergeSpellEntry("MONK", 6),          -- Enveloping Mist                            (Every 1s for 6s)
  [116670] = CreateMergeSpellEntry("MONK", .5),         -- Uplift                                     (INSTANT)
  [117895] = CreateMergeSpellEntry("MONK", 3),          -- Eminence (Monk)
  [126890] = CreateMergeSpellEntry("MONK", 3),          -- Eminence (Statue)
  [127722] = CreateMergeSpellEntry("MONK", 3),          -- Serpent's Zeal
  [128591] = CreateMergeSpellEntry("MONK", 3),          -- Blackout Kick (Heal??)
  [124040] = CreateMergeSpellEntry("MONK", 5),          -- Chi Torpedo                                (INSTANT)
  [130654] = CreateMergeSpellEntry("MONK", 3),          -- Chi Burst
  [115310] = CreateMergeSpellEntry("MONK"),             -- Revival
  [124081] = CreateMergeSpellEntry("MONK", 6),          -- Zen Sphere (Heal)                          (2 sec for 16 sec)
  [124101] = CreateMergeSpellEntry("MONK", .5),         -- Zen Sphere: Detonate (Heal)                (INSTANT)
  [132463] = CreateMergeSpellEntry("MONK", 6),          -- Chi Wave (Heal)
  
-- paladin (damage)
  [122032] = CreateMergeSpellEntry("PALADIN"),          -- Glyph of Mass Exorcism
  [96172]  = CreateMergeSpellEntry("PALADIN"),          -- Mastery: Hand of Light
  [81297]  = CreateMergeSpellEntry("PALADIN"),          -- Consecration
  [53385]  = CreateMergeSpellEntry("PALADIN"),          -- Divine Storm
  [31803]  = CreateMergeSpellEntry("PALADIN", 6),       -- Censure
  [42463]  = CreateMergeSpellEntry("PALADIN"),          -- Seal of Truth
  [88263]  = CreateMergeSpellEntry("PALADIN"),          -- Hammer of Righteous
  [101423] = CreateMergeSpellEntry("PALADIN"),          -- Seal of Righteousness
  [31935]  = CreateMergeSpellEntry("PALADIN"),          -- Avenger's Shield
  [114919] = CreateMergeSpellEntry("PALADIN", 6.5),     -- Arcing Light (Damage)
  [119072] = CreateMergeSpellEntry("PALADIN", .5),      -- Holy Wrath                                 (INSTANT)
  [86704]  = CreateMergeSpellEntry("PALADIN", .5),      -- Ancient Fury                               (INSTANT)

-- paladin (healing)
  [94289]  = CreateMergeSpellEntry("PALADIN"),          -- Protector of the Innocent
  [53652]  = CreateMergeSpellEntry("PALADIN"),          -- Beacon of Light
  [85222]  = CreateMergeSpellEntry("PALADIN"),          -- Light of Dawn
  [82327]  = CreateMergeSpellEntry("PALADIN"),          -- Holy Radiance
  [20167]  = CreateMergeSpellEntry("PALADIN"),          -- Seal of Insight (Heal)
  [121129] = CreateMergeSpellEntry("PALADIN", .5),      -- Daybreak                                   (INSTANT)
  [119952] = CreateMergeSpellEntry("PALADIN", 6.5),     -- Arcing Light (Heal)                        (Every 2s for 17.5s)
  [114163] = CreateMergeSpellEntry("PALADIN", 5),       -- Eternal Flame				                      (Every 3s for 30s)
  [86678]  = CreateMergeSpellEntry("PALADIN"),          -- Light of the Ancient kings
  
-- priest (damage)
  [47666]  = CreateMergeSpellEntry("PRIEST"),           -- Penance (Damage Effect)
  [132157] = CreateMergeSpellEntry("PRIEST", .5),       -- Holy Nova (Damage Effect)                  (INSTANT)
  [589]    = CreateMergeSpellEntry("PRIEST", 6),        -- Shadow Word: Pain
  [34914]  = CreateMergeSpellEntry("PRIEST", 6),        -- Vampiric Touch 
  [2944]   = CreateMergeSpellEntry("PRIEST"),           -- Devouring Plague
  [15407]  = CreateMergeSpellEntry("PRIEST"),           -- Mind Flay
  [49821]  = CreateMergeSpellEntry("PRIEST"),           -- Mind Seer (From Derap: first one is the cast)
  [124469] = CreateMergeSpellEntry("PRIEST"),           -- Mind Seer (the second one is the debuff that is applied to your target which lets you clip your mind sears like mind flay)
  [87532]  = CreateMergeSpellEntry("PRIEST"),           -- Shadowy Apparition
  [14914]  = CreateMergeSpellEntry("PRIEST"),           -- Holy Fire
  [129250] = CreateMergeSpellEntry("PRIEST", 4),        -- Power Word: Solace
	[120696] = CreateMergeSpellEntry("PRIEST", 5),        -- Halo (Damage)                              (INSTANT... over 5ish)
  [15290]  = CreateMergeSpellEntry("PRIEST", 5),        -- Vampiric Embrace (Damage repeated as heals)(over 15s)
  [122128] = CreateMergeSpellEntry("PRIEST", 3),				-- Divine Star (Heal)                         (INSTANT... over 3ish)
	[33619]  = CreateMergeSpellEntry("PRIEST", 3),        -- Reflective Shield
	[127628] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade (Damage)
	
  -- Merge Together:
  -- 49821 & 124469 - Mind Seer
  
-- priest (healing)
  [47750]  = CreateMergeSpellEntry("PRIEST"),           -- Penance (Heal)
  [139]    = CreateMergeSpellEntry("PRIEST"),           -- Renew
  [596]    = CreateMergeSpellEntry("PRIEST", .5),       -- Prayer of Healing                          (INSTANT)
  [64844]  = CreateMergeSpellEntry("PRIEST"),           -- Divine Hymn
  [32546]  = CreateMergeSpellEntry("PRIEST"),           -- Binding Heal
  [77489]  = CreateMergeSpellEntry("PRIEST"),           -- Echo of Light
  [34861]  = CreateMergeSpellEntry("PRIEST", .5),       -- Circle of Healing                          (INSTANT)
  [23455]  = CreateMergeSpellEntry("PRIEST", .5),       -- Holy Nova (Healing)                        (INSTANT)
  [33110]  = CreateMergeSpellEntry("PRIEST"),           -- Prayer of Mending
  [63544]  = CreateMergeSpellEntry("PRIEST"),           -- Rapid Renewal
  [88686]  = CreateMergeSpellEntry("PRIEST", 6),        -- Holy Word: Sanctuary                       (every 2 sec for 30 sec)
  [121148] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade                                    (INSTANT... over 3ish)
  [110745] = CreateMergeSpellEntry("PRIEST", 3),        -- Divine Star (Heal)                         (INSTANT... over 3ish)
  [120692] = CreateMergeSpellEntry("PRIEST", 3),        -- Halo                                       (INSTANT... over 3ish)
  [7001]   = CreateMergeSpellEntry("PRIEST", 4),        -- Light Well                                 (every 2s for 6s)
  [127626] = CreateMergeSpellEntry("PRIEST", 6.5),      -- Devouring Plague (Heal)
  [81751]  = CreateMergeSpellEntry("PRIEST", 6),        -- Atonement (Healing you do through damage)
	[126154] = CreateMergeSpellEntry("PRIEST", 3),        -- Lightspring Renew
	[120785] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade (Heal & Damage ??)
	[127629] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade (Heal - Shadow Spec)
	
-- rogue
  [51723]  = CreateMergeSpellEntry("ROGUE", .5),        -- Fan of Knives                              (INSTANT)
  [113780] = CreateMergeSpellEntry("ROGUE", .5),        -- Deadly Poison                              (INSTANT)
  [2818]   = CreateMergeSpellEntry("ROGUE"),            -- Deadly Poison (DoT)
  [8680]   = CreateMergeSpellEntry("ROGUE"),            -- Wound Poison
  [112974] = CreateMergeSpellEntry("ROGUE"),            -- Leeching Poison
  [121411] = CreateMergeSpellEntry("ROGUE", .5),        -- Crimson Tempest                            (INSTANT)
  [122233] = CreateMergeSpellEntry("ROGUE"),            -- Crimson Tempest (DoT)
  [22482]  = CreateMergeSpellEntry("ROGUE", .5),        -- Blade Flurry                               (INSTANT)
  
-- shaman (damage)
  [421]    = CreateMergeSpellEntry("SHAMAN", .5),       -- Chain Lightning                            (INSTANT)
  [8349]   = CreateMergeSpellEntry("SHAMAN"),           -- Fire Nova
  [77478]  = CreateMergeSpellEntry("SHAMAN"),           -- Earthquake
  [51490]  = CreateMergeSpellEntry("SHAMAN"),           -- Thunderstorm
  [8187]   = CreateMergeSpellEntry("SHAMAN"),           -- Magma Totem
  [8050]   = CreateMergeSpellEntry("SHAMAN"),           -- Flame Shock
  [25504]  = CreateMergeSpellEntry("SHAMAN", .5),       -- Windfury Attack                            (INSTANT)
  [120687] = CreateMergeSpellEntry("SHAMAN"),           -- Stormlash (Stormlash Totem)
  [10444]  = CreateMergeSpellEntry("SHAMAN"),           -- Flametongue Attack
  [58879]  = CreateMergeSpellEntry("SHAMAN"),           -- Spirit Hunt (Spirit Wolves)
  [26364]  = CreateMergeSpellEntry("SHAMAN"),           -- Lightning Shield (Static Shock)
  [114074] = CreateMergeSpellEntry("SHAMAN", .5),       -- Lava Beam                                  (INSTANT)
  [114738] = CreateMergeSpellEntry("SHAMAN", .5),       -- Lava Beam (Mastery)                        (INSTANT)
  [45297]  = CreateMergeSpellEntry("SHAMAN", .5),       -- Chain Lightning (Mastery)                  (INSTANT)
	
-- shaman (healing)
  [73921]  = CreateMergeSpellEntry("SHAMAN"),           -- Healing Rain
  [1064]   = CreateMergeSpellEntry("SHAMAN", .5),       -- Chain Heal                                 (INSTANT)
  [52042]  = CreateMergeSpellEntry("SHAMAN"),           -- Healing Stream Totem
  [51945]  = CreateMergeSpellEntry("SHAMAN"),           -- Earthliving
  [61295]  = CreateMergeSpellEntry("SHAMAN"),           -- Riptide
  [114083] = CreateMergeSpellEntry("SHAMAN"),           -- Restorative Mists (Ascendance)
  [114911] = CreateMergeSpellEntry("SHAMAN", .5),       -- Ancestral Guidance                         (INSTANT)
  
-- shaman (special)
  -- 32175 & 32176 Stormstrike (Merge Two Hits Together)
  -- 115357 & 115360 Stormblast (Merge together)
  -- 114089 & 114093 Wind Lash (Ascendance)
  
-- warlock (damage)
  [980]    = CreateMergeSpellEntry("WARLOCK"),          -- Agony
  [131737] = CreateMergeSpellEntry("WARLOCK"),          -- Agony (Malefic Grasp)
  [103967] = CreateMergeSpellEntry("WARLOCK", .5),      -- Carrion Swarm                              (INSTANT)
  [124915] = CreateMergeSpellEntry("WARLOCK", .5),      -- Chaos Wave                                 (INSTANT)
  [108685] = CreateMergeSpellEntry("WARLOCK", .5),      -- Conflagrate                                (INSTANT)
  [172]    = CreateMergeSpellEntry("WARLOCK"),          -- Corruption
  [87389]  = CreateMergeSpellEntry("WARLOCK"),          -- Corruption (Soulburn: Seed of Corruption)
  [131740] = CreateMergeSpellEntry("WARLOCK"),          -- Corruption (Malefic Grasp)
  [689]    = CreateMergeSpellEntry("WARLOCK"),          -- Drain Life
  [89753]  = CreateMergeSpellEntry("WARLOCK"),          -- Felstorm (Felguard)
  [104318] = CreateMergeSpellEntry("WARLOCK"),          -- Firebolt (Wild Imps)
  [86040]  = CreateMergeSpellEntry("WARLOCK"),          -- Hand of Gul'dan (Shadowflame)
  [108371] = CreateMergeSpellEntry("WARLOCK"),          -- Harvest Life
  [5857]   = CreateMergeSpellEntry("WARLOCK"),          -- Hellfire
  [348]    = CreateMergeSpellEntry("WARLOCK"),          -- Immolate
  [108686] = CreateMergeSpellEntry("WARLOCK"),          -- Immolate (Malefic Grasp)
  [20153]  = CreateMergeSpellEntry("WARLOCK"),          -- Immolation (Infrenal)
  [129476] = CreateMergeSpellEntry("WARLOCK"),          -- Immolation Aura
  [114654] = CreateMergeSpellEntry("WARLOCK", .5),      -- Incinerate                                 (INSTANT)
  [30213]  = CreateMergeSpellEntry("WARLOCK", .5),      -- Legion Strike (Felguard)                   (INSTANT)
  [103103] = CreateMergeSpellEntry("WARLOCK", 4),       -- Malefic Grasp                              (Every 1s for 4s)
  [103988] = CreateMergeSpellEntry("WARLOCK"),          -- Melee (Auto-Attack for Metamorphosis)
  [42223]  = CreateMergeSpellEntry("WARLOCK", 4),       -- Rain of Fire (Affliction)                  (Every 1s for 8s)
  [104233] = CreateMergeSpellEntry("WARLOCK", 4),       -- Rain of Fire (Destruction)                 (Every 1s for 8s)
  [27243]  = CreateMergeSpellEntry("WARLOCK"),          -- Seed of Corruption (DoT)
  [27285]  = CreateMergeSpellEntry("WARLOCK", .5),      -- Seed of Corruption (Explosion)             (INSTANT)
  [87385]  = CreateMergeSpellEntry("WARLOCK", .5),      -- Seed of Corruption (Explosion Soulburned)  (INSTANT)
  [47960]  = CreateMergeSpellEntry("WARLOCK"),          -- Shadowflame (DOT)
  [108451] = CreateMergeSpellEntry("WARLOCK"),          -- Soul Link
  [30108]  = CreateMergeSpellEntry("WARLOCK"),          -- Unstable Affliction
  [131736] = CreateMergeSpellEntry("WARLOCK"),          -- Unstable Affliction (Malefic Grasp)

-- warlock (healing)
  [89653]  = CreateMergeSpellEntry("WARLOCK"),          -- Drain Life
  [125314] = CreateMergeSpellEntry("WARLOCK"),          -- Harvest Life
  [63106]  = CreateMergeSpellEntry("WARLOCK"),          -- Siphon Life
  [108366] = CreateMergeSpellEntry("WARLOCK"),          -- Soul Leech
  [108447] = CreateMergeSpellEntry("WARLOCK"),          -- Soul Link
  
-- warrior
  [845]    = CreateMergeSpellEntry("WARRIOR", .5),      -- Cleave                                     (INSTANT)
  [46968]  = CreateMergeSpellEntry("WARRIOR", .5),      -- Shockwave                                  (INSTANT)
  [6343]   = CreateMergeSpellEntry("WARRIOR", .5),      -- Thunder Clap                               (INSTANT)
  [6572]   = CreateMergeSpellEntry("WARRIOR", .5),      -- Revenge                                    (INSTANT)
  [115767] = CreateMergeSpellEntry("WARRIOR", 3),       -- Deep Wounds
  [1680]   = CreateMergeSpellEntry("WARRIOR"),          -- Whirlwind
  [44949]  = CreateMergeSpellEntry("WARRIOR"),          -- Whirlwind Offhand
  [50622]  = CreateMergeSpellEntry("WARRIOR"),          -- Bladestorm
  [113344] = CreateMergeSpellEntry("WARRIOR"),          -- Bloodbath
  [52174]  = CreateMergeSpellEntry("WARRIOR", .5),      -- Heroic Leap                                (INSTANT)
  
  -- Merge Main/Offhand together
  --[96103]  = CreateMergeSpellEntry("WARRIOR", .5),      -- Raging Blow
  --[85384]  = CreateMergeSpellEntry("WARRIOR", .5),      -- Raging Blow (Offhand)
  
-- spammy items (old) ITEM CLASS CURRENTLY DOES NOTHING
  [109858] = CreateMergeSpellEntry("ITEM", 2.5),        -- Speaking of Rage - proc'd by: Vishanka, Jaws of the Earth (Heroic)
}

-- This is just a list that conatins a whole bunch of valid spells for test mode icons
addon.valid = { 671, 672, 673, 674, 676, 686, 688, 689, 691, 697, 698, 700, 703, 710, 712, 720, 724, 731, 740,
	746, 747, 750, 755, 759, 768, 770, 774, 779, 781, 783, 785, 799, 800, 802, 804, 806, 812, 813, 814, 815, 816,
	817, 818, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 833, 835, 836, 845, 851, 853, 871, 879, 883, 898,
	921, 932, 952, 974, 980, 982, 1022, 1038, 1044, 1050, 1064, 1066, 1079, 1090, 1098, 1120, 1121, 1122, 1126,
	1127, 1129, 1130, 1131, 1132, 1133, 1135, 1137, 1138, 1139, 1159, 1160, 1178, 1180, 1234, 1329, 1330, 1364,
	1373, 1386, 1446, 1449, 1454, 1459, 1462, 1463, 1464, 1485, 1490, 1494, 1499, 1513, 1515, 1516, 1522, 1528,
	1535, 1536, 1538, 1539, 1543, 1557, 1588, 1604, 1609, 1645, 1650, 1664, 1665, 1666, 1669, 1680, 1706, 1715,
	1719, 1725, 1742, 1752, 1766, 1776, 1784, 1795, 1796, 1797, 1798, 1800, 1804, 1809, 1810, 1822, 1825, 1833,
	1834, 1842, 1843, 1844, 1848, 1850, 1852, 1856, 1860, 1881, 1906, 1936, 1940, 1943, 1949, 1950, 1953, 1966,
	1978, 2000, 2006, 2008, 2018, 2020, 2021, 2023, 2024, 2050, 2060, 2061, 2062, 2075, 2094, 2096, 2098, 2108,
	2110, 2118, 2119, 2120, 2123, 2136, 2139, 2140, 2147, 2148, 2149, 2152, 2153, 2154, 2155, 2156, 2157, 2158,
	2159, 2160, 2161, 2162, 2163, 2164, 2165, 2166, 2167, 2168, 2169, 2259, 2275, 2280, 2313, 2329, 2330, 2331,
	2332, 2333, 2334, 2335, 2337, 2366, 2367, 2368, 2369, 2370, 2371, 2372, 2373, 2374, 2378, 2379, 2380, 2381,
	2382, 2383, 2385, 2386, 2387, 2389, 2392, 2393, 2394, 2395, 2396, 2397, 2399, 2400, 2401, 2402, 2403, 2406,
	2425, 2426, 2442, 2443, 2444, 2446, 2457, 2458, 2479, 2481, 2484, 2538, 2539, 2540, 2541, 2542, 2543, 2544,
	2545, 2546, 2547, 2548, 2549, 2550, 2551, 2565, 2567, 2575, 2576, 2580, 2581, 2582, 2584, 2585, 2596, 2597,
	2598, 2599, 2600, 2601, 2602, 2606, 2607, 2608, 2609, 2610, 2629, 2630, 2633, 2634, 2636, 2637, 2639, 2641,
	2643, 2645, 2649, 2650, 2656, 2657, 2658, 2659, 2660, 2661, 2662, 2663, 2664, 2665, 2666, 2667, 2668, 2670,
	2671, 2672, 2673, 2674, 2675, 2676, 2691, 2737, 2738, 2739, 2740, 2741, 2742, 2764, 2782, 2795, 2812, 2818,
	2823, 2825, 2828, 2829, 2830, 2831, 2832, 2833, 2834, 2836, 2871, 2880, 2881, 2894, 2908, 2912, 2944, 2948,
	2950, 2963, 2964, 2969, 2983, 3007, 3011, 3018, 3019, 3025, 3026, 3044, 3045, 3050, 3052, 3053, 3054, 3055,
	3100, 3101, 3102, 3104, 3105, 3106, 3107, 3108, 3109, 3110, 3112, 3113, 3114, 3115, 3116, 3117, 3120, 3121,
	3127, 3129, 3130, 3131, 3132, 3136, 3143, 3145, 3146, 3147, 3148, 3149, 3150, 3151, 3160, 3164, 3166, 3169,
	3170, 3171, 3173, 3174, 3175, 3176, 3177, 3188, 3204, 3205, 3206, 3207, 3219, 3220, 3222, 3223, 3229, 3230,
	3233, 3234, 3235, 3237, 3238, 3240, 3242, 3243, 3245, 3246, 3247, 3248, 3252, 3256, 3258, 3260, 3261, 3263,
	3264, 3267, 3268, 3269, 3271, 3273, 3274, 3275, 3276, 3277, 3278, 3279, 3280, 3284, 3286, 3287, 3288, 3292,
	3293, 3294, 3295, 3296, 3297, 3304, 3307, 3308, 3319, 3320, 3321, 3322, 3323, 3324, 3325, 3326, 3328, 3329,
	3330, 3331, 3332, 3333, 3334, 3335, 3336, 3337, 3338, 3339, 3355, 3356, 3358, 3359, 3360, 3361, 3363, 3365,
	3366, 3368, 3369, 3370, 3371, 3372, 3373, 3376, 3377, 3385, 3387, 3388, 3389, 3390, 3391, 3393, 3394, 3396,
	3397, 3398, 3399, 3400, 3405, 3407, 3408, 3409, 3411, 3412, 3413, 3416, 3417, 3418, 3419, 3424, 3427, 3428,
	3429, 3436, 3439, 3440, 3442, 3443, 3446, 3447, 3448, 3449, 3450, 3451, 3452, 3453, 3454, 3464, 3465, 3477,
	78641, 78644, 78645, 78646, 78650, 78667, 78668, 78670, 78674, 78677, 78678, 78679, 78683, 78686, 78688, 78689,
	78694, 78697, 78698, 78699, 78703, 78706, 78707, 78708, 78712, 78715, 78716, 78717, 78722, 78726, 78729, 78730,
	78739, 78742, 78743, 78744, 78748, 78751, 78752, 78753, 78759, 78764, 78766, 78767, 78772, 78775, 78776, 78777,
	78782, 78787, 78794, 78799, 78804, 78807, 78808, 78810, 78820, 78825, 78826, 78827, 78832, 78835, 78836, 78837,
	78841, 78844, 78846, 78847, 78851, 78854, 78855, 78856, 78860, 78863, 78864, 78865, 78874, 78894, 78895, 78896,
	78900, 78903, 78904, 78905, 78911, 78914, 78915, 78916, 78922, 78925, 78926, 78928, 78932, 78935, 78936, 78937,
	78943, 78946, 78947, 78948, 78954, 78957, 78958, 78959, 78963, 78966, 78967, 78968, 78972, 78975, 78977, 78978,
	78982, 78985, 78986, 78987, 78991, 78994, 78995, 78996, 79000, 79008, 79009, 79010, 79014, 79020, 79021, 79023,
	79035, 79041, 79042, 79043, 79047, 79050, 79051, 79053, 79064, 79084, 79085, 79086, 79092, 79096, 79103, 79109,
	79116, 79127, 79129, 79130, 79138, 79142, 79143, 79144, 79152, 79156, 79157, 79158, 79162, 79166, 79167, 79168,
	79172, 79175, 79176, 79177, 79181, 79184, 79185, 79186, 79191, 79194, 79196, 79197, 79202, 79206, 79212, 79213,
	79226, 79229, 79230, 79231, 79235, 79238, 79239, 79240, 79245, 79248, 79249, 79250, 79262, 79266, 79267, 79269,
	79274, 79277, 79278, 79279, 79283, 79286, 79287, 79288, 79292, 79295, 79296, 79297, 79301, 79304, 79305, 79306,
	79310, 79313, 79314, 79315, 79320, 79324, 79325, 79327, 79331, 79335, 79336, 79337, 79343, 79346, 79347, 79348,
	79353, 79356, 79357, 79358, 79362, 79365, 79366, 79367, 79372, 79375, 79376, 79377, 79381, 79384, 79391, 79392,
	79397, 79400, 79401, 79402, 79409, 79412, 79413, 79414, 79418, 79421, 79422, 79423, 79427, 79430, 79431, 79432,
	79436, 79441, 79442, 79443, 79447, 79450, 79451, 79452, 79457, 79465, 79466, 79467, 79471, 79474, 79475, 79476,
	79480, 79483, 79484, 79485, 79489, 79492, 79493, 79494, 79498, 79501, 79502, 79503, 79507, 79510, 79511, 79512,
	79516, 79519, 79520, 79521, 79526, 79531, 79532, 79533, 79537, 79540, 79541, 79542, 79547, 79550, 79551, 79552,
	79556, 79559, 79560, 79561, 79563, 79564, 79565, 79566, 79567, 79568, 79569, 79570, 79571, 79572, 79573, 79575,
	79576, 79577, 59409, 59411, 59412, 59417, 59419, 59424, 59425, 59427, 59431, 59432, 59438, 59439, 59440, 59444,
	59446, 59452, 59453, 59454, 59458, 59460, 59465, 59466, 59467, 59471, 59472, 59477, 59478, 59479, 59483, 59484,
	59490, 59491, 59493, 59497, 59498, 59507, 59508, 59509, 59514, 59515, 59521, 59522, 59523, 59527, 59528, 59533,
	59534, 59535, 59539, 59540, 59545, 59546, 59547, 59551, 59552, 59558, 59559, 59560, 59564, 59565, 59571, 59572,
	59573, 59578, 59579, 59585, 59586, 59587, 59591, 59592, 59601, 59603, 59604, 59608, 59609, 59616, 59617, 59618,
	59622, 59623, 59628, 59629, 59630, 59635, 59636, 59642, 59643, 59645, 59649, 59650, 59656, 59657, 59658, 59663,
	59664, 59670, 59675, 59676, 59682, 59683, 59688, 59689, 59691, 59695, 59696, 59702, 59703, 59704, 59708, 59709,
	59714, 59715, 59716, 59720, 59721, 59727, 59728, 59729, 59733, 59734, 59743, 59744, 59745, 59749, 59750, 59756,
	59757, 59759, 59763, 59764, 59771, 59772, 59773, 59778, 59779, 59784, 59785, 59787, 59791, 59792, 59798, 59799,
	59800, 59804, 59805, 59814, 59815, 59816, 59821, 59823, 59828, 59829, 59830, 59834, 59835, 59840, 59841, 59842,
	59846, 59847, 59853, 59854, 59855, 59860, 59861, 59866, 59867, 59868, 59872, 59873, 59878, 59879, 59880, 59894,
	59897, 59907, 59908, 59909, 59914, 59915, 59921, 59922, 59923, 59927, 59928, 59934, 59935, 59936, 59940, 59941,
	59946, 59947, 59948, 59953, 59954, 59959, 59960, 59961, 59965, 59966, 59971, 59972, 59973, 59977, 59978, 59985,
	59986, 59987, 59991, 59992, 59997, 59998, 59999, 60005, 60006, 60012, 60013, 60014, 60018, 60019, 60024, 60025,
	60027, 60032, 60034, 60040, 60041, 60042, 60047, 60054, 60060, 60061, 60062, 60066, 60067, 60073, 60074, 60075,
	60079, 60080, 60091, 60094, 60095, 60103, 60104, 60109, 60111, 60112, 60117, 60118, 60123, 60124, 60125, 60129,
	60130, 60136, 60137, 60138, 60142, 60143, 60148, 60149, 60150, 60154, 60155, 60161, 60162, 60163, 60167, 60168,
	60174, 60175, 60176, 60181, 60182, 60190, 60191, 60192, 60197, 60200, 60205, 60206, 60207, 60212, 60213, 60223,
	60224, 60225, 60230, 60231, 60236, 60237, 60238, 60243, 60244, 60249, 60250, 60251, 60257, 60258, 60263, 60264,
	60265, 60271, 60272, 60278, 60279, 60280, 60284, 60285, 60290, 60291, 60292, 60296, 60297, 60302, 60303, 60304,
	60309, 60310, 60315, 60316, 60317, 60321, 60322, 60327, 60328, 60329, 60333, 60334, 60340, 60341, 60342, 60347,
	60348, 60353, 60354, 60355, 60359, 60360, 60365, 60366, 60367, 60371, 60372, 60377, 60378, 60379, 60383, 60384,
	60389, 60390, 60391, 60395, 60396, 60401, 60402, 60403, 60408, 60409, 60414, 60415, 60416, 60420, 60421, 60427,
	60428, 60429, 60438, 60439, 60444, 60446, 60447, 60452, 60453, 60463, 60464, 60469, 60473, 60474, 60481, 60482,
	60483, 60487, 60488, 60493, 60494, 60495, 60499, 60500, 60505, 60506, 60507, 60511, 60512, 60517, 60518, 60519,
	60523, 60524, 60529, 60530, 60531, 60535, 60536, 60541, 60542, 60545, 60579, 60580, 60587, 60588, 60590, 60595,
	60596, 60601, 60602, 60603, 60607, 60608, 60614, 60616, 60617, 60623, 60624, 60629, 60630, 60631, 60642, 60643,
	60651, 60652, 60653, 60658, 60660, 60668, 60669, 60670, 60678, 60679, 60684, 60689, 60691, 60699, 60702, 60707,
	60708, 60709, 60714, 60715, 60723, 60725, 60727, 60731, 60732, 60743, 60744, 60745, 60749, 60750, 60755, 60756,
	60757, 60761, 60763, 60781, 60782, 60783, 60790, 60791, 60802, 60805, 60807, 60811, 60812, 60820, 60822, 60823,
	60831, 60832, 60838, 60839, 60840, 60845, 60846, 60851, 60852, 60853, 60857, 60859, 60865, 60866, 60867, 60871,
	60872, 60878, 60880, 60881, 60887, 60888, 60897, 60898, 60899, 60903, 60904, 60909, 60912, 60913, 60918, 60919,
	60924, 60925, 60926, 60932, 60934, 60940, 60941, 60942, 60947, 60948, 60953, 60954, 60957, 60961, 60962, 60967,
	60968, 60969, 60977, 60978, 60983, 60984, 60985, 60990, 60991, 60998, 60999, 61000, 61004, 61007, 61012, 61014,
	61015, 61022, 61023, 61029, 61031, 61032, 61036, 61037, 61042, 61043, 61044, 61048, 61050, 61055, 61056, 61057,
	61063, 61064, 61070, 61071, 61072, 61076, 61077, 61082, 61083, 61084, 61088, 61089, 61095, 61097, 61098, 61103,
	61108, 61113, 61114, 61115, 61119, 61120, 61125, 61126, 61127, 61131, 61132, 61138, 61139, 61140, 61146, 61147
}
