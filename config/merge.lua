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
--    desc,        [string] - A short, helpful qualifier (1-2 words)
--  )
--    Creates a merge settings entry for a spell.
-- =====================================================
local function CreateMergeSpellEntry(class, interval, desc, prep)
  return {
         class = class      or "ITEM",
      interval = interval   or 3,
          prep = prep       or 0,
          desc = desc,
    }
end

-- Filter These Spells Remove
-- [1949] - Damage to Self

-- List of Spells that need to be merged
addon.merges = {

-- items (legendary cloaks)
  [147891] = CreateMergeSpellEntry("ITEM", 3.5, "Legedary Cloak for Melee"),    -- Legedary Cloak (Melee - dmg over 3s)
  [148008] = CreateMergeSpellEntry("ITEM", 3.5, "Legedary Cloak for Casters"),  -- Legedary Cloak (Caster - dmg over 3s)
  [148009] = CreateMergeSpellEntry("ITEM", 5,   "Legedary Cloak for Healers"),  -- Legedary Cloak (Healer - heal over 10s)
  [149276] = CreateMergeSpellEntry("ITEM", 3.5, "Legedary Cloak for Hunters"),  -- Legedary Cloak (Hunter - dmg over 3s)
  
  -- Trinket: Kardris' Toxic Totem (Based on class and spec)
  [146061] = CreateMergeSpellEntry("ITEM", 5, "Physical Damage (Melee)"),            -- Multi-Strike (Physical, Melee)
  [146063] = CreateMergeSpellEntry("ITEM", 5, "Holy Damage"),                        -- Multi-Strike (Holy Dmg, ?????)
  [146064] = CreateMergeSpellEntry("ITEM", 5, "Arcane Damage (Balance Druids)"),     -- Multi-Strike (Arcane Boomkin)
  [146065] = CreateMergeSpellEntry("ITEM", 5, "Shadow Damage (Priests, Warlocks)"),  -- Multi-Strike (Shadow, Lock/Priest)
  [146067] = CreateMergeSpellEntry("ITEM", 5, "Fire, Frost Damage (Mages)"),         -- Multi-Strike (Fire, Frost Mage)
  [146069] = CreateMergeSpellEntry("ITEM", 5, "Physical Damage (Hunters)"),          -- Multi-Strike (Physical, Hunter)
  [146071] = CreateMergeSpellEntry("ITEM", 5, "Nature Damage (Elemental Shamans)"),  -- Multi-Strike (Nature, Ele Shaman)
  [146070] = CreateMergeSpellEntry("ITEM", 5, "Arcane Damage (Mages)"),              -- Multi-Strike (Arcane Mage)
  [146075] = CreateMergeSpellEntry("ITEM", 5, "Nature Damage (Windwalker Monks)"),   -- Multi-Strike (Nature, Monk)
  [146177] = CreateMergeSpellEntry("ITEM", 5, "Holy Healing (Priest, Paladin)"),     -- Multi-Strike (Holy, Healing)
  [146178] = CreateMergeSpellEntry("ITEM", 5, "Nature Healing (Druid, Monk)"),       -- Multi-Strike (Nature, Healing)
  
  -- Trinket: Thok's Acid-Grooved Tooth (Based on class and spec)
  [146137] = CreateMergeSpellEntry("ITEM", .5, "Physical Damage (Melee)"),           -- Cleave (Physical, Melee)
  [146157] = CreateMergeSpellEntry("ITEM", .5, "Holy Damage"),                       -- Cleave (Holy Dmg, ?????)
  [146158] = CreateMergeSpellEntry("ITEM", .5, "Arcane Damage (Balance Druids)"),    -- Cleave (Arcane Boomkin)
  [146159] = CreateMergeSpellEntry("ITEM", .5, "Shadow Damage (Priests, Warlocks)"), -- Cleave (Shadow, Lock/Priest)
  [146160] = CreateMergeSpellEntry("ITEM", .5, "Fire, Frost Damage (Mages)"),        -- Cleave (Fire, Frost Mage)
  [146162] = CreateMergeSpellEntry("ITEM", .5, "Physical Damage (Hunters)"),         -- Cleave (Physical, Hunter)
  [146166] = CreateMergeSpellEntry("ITEM", .5, "Arcane Damage (Mages)"),             -- Cleave (Arcane Mage)
  [146171] = CreateMergeSpellEntry("ITEM", .5, "Nature Damage (Elemental Shamans)"), -- Cleave (Nature, Ele)
  [148234] = CreateMergeSpellEntry("ITEM", .5, "Holy Healing (Priests, Paladins)"),  -- Cleave (Holy, Healing)
  [148235] = CreateMergeSpellEntry("ITEM", .5, "Nature Healing (Monks, Druids)"),    -- Cleave (Nature, Healing)



-- death knight (damage)
  [55078]  = CreateMergeSpellEntry("DEATHKNIGHT"),      -- Blood Plague
  [48721]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Blood Boil                                 (INSTANT)
  [91776]  = CreateMergeSpellEntry("DEATHKNIGHT", 4),   -- Claw (Army of the Dead)
  [52212]  = CreateMergeSpellEntry("DEATHKNIGHT"),      -- Death and Decay
  [55095]  = CreateMergeSpellEntry("DEATHKNIGHT"),      -- Frost Fever
  [55050]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Heart Strike                               (INSTANT)
  [49184]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Howling Blast                              (INSTANT)

-- death knight (healing) 
  [81280]  = CreateMergeSpellEntry("DEATHKNIGHT", .5),  -- Blood Burst                                (INSTANT)
  [119980] = CreateMergeSpellEntry("DEATHKNIGHT", 4),   -- Conversion
  [53365]  = CreateMergeSpellEntry("DEATHKNIGHT", 4),   -- Unholy Strength

-- druid (damage)
  [106998] = CreateMergeSpellEntry("DRUID"),            -- Astral Storm                               (Every 1s for 10s)
  [42231]  = CreateMergeSpellEntry("DRUID"),            -- Hurricane
  [5570]   = CreateMergeSpellEntry("DRUID"),            -- Insect Swarm
  [33745]  = CreateMergeSpellEntry("DRUID"),            -- Lacerate
  [8921]   = CreateMergeSpellEntry("DRUID"),            -- Moonfire
  [1822]   = CreateMergeSpellEntry("DRUID"),            -- Rake
  [1079]   = CreateMergeSpellEntry("DRUID", 2),         -- Rip
  [50288]  = CreateMergeSpellEntry("DRUID"),            -- Starfall
  [93402]  = CreateMergeSpellEntry("DRUID"),            -- Sunfire
  [62078]  = CreateMergeSpellEntry("DRUID", .5),        -- Swipe (Cat)                                (INSTANT)
  [779]    = CreateMergeSpellEntry("DRUID", .5),        -- Swipe (Bear)                               (INSTANT)
  [106830] = CreateMergeSpellEntry("DRUID", 4),         -- Thrash (Cat)
  [77758]  = CreateMergeSpellEntry("DRUID", 4),         -- Thrash (Bear)
  [61391]  = CreateMergeSpellEntry("DRUID", .5),        -- Typhoon                                    (INSTANT)
  [78777]  = CreateMergeSpellEntry("DRUID", 0.5),       -- Wild Mushroom: Detonate                    (INSTANT)

-- druid (healing)
  [33763]  = CreateMergeSpellEntry("DRUID"),            -- Lifebloom
  [8936]   = CreateMergeSpellEntry("DRUID"),            -- Regrowth
  [774]    = CreateMergeSpellEntry("DRUID"),            -- Rejuvenation
  [81269]  = CreateMergeSpellEntry("DRUID"),            -- Swiftmend (Efflorescence)
  [44203]  = CreateMergeSpellEntry("DRUID"),            -- Tranquility
  [48438]  = CreateMergeSpellEntry("DRUID"),            -- Wild Growth
  [102792] = CreateMergeSpellEntry("DRUID", .5),        -- Wild Mushroom: Bloom                       (INSTANT)

-- hunter
  [131900] = CreateMergeSpellEntry("HUNTER", 6),        -- A Murder of Crows                          (Over 30s)
  [120361] = CreateMergeSpellEntry("HUNTER", 4),        -- Barrage                                    (Channeled over 3s) 4 to be safe :P
  [118459] = CreateMergeSpellEntry("HUNTER", .5),       -- Beast Cleave                               (INSTANT)
  [3674]   = CreateMergeSpellEntry("HUNTER", 4),        -- Black Arrow                                (Every 2s for 20s)
  [13812]  = CreateMergeSpellEntry("HUNTER"),           -- Explosive Trap
  [53301]  = CreateMergeSpellEntry("HUNTER"),           -- Explosive Shot (3 ticks merged as one)
  [121414] = CreateMergeSpellEntry("HUNTER", 6),        -- Glaive Toss (Initial Damage)               (Merged with DoT)
  [120699] = CreateMergeSpellEntry("HUNTER", 4),        -- Lynx Rush                                  (9x over 4s)
  [2643]   = CreateMergeSpellEntry("HUNTER", .5),       -- Multi-Shot                                 (INSTANT)
  [63468]  = CreateMergeSpellEntry("HUNTER"),           -- Piercing Shots
  [83077]  = CreateMergeSpellEntry("HUNTER"),           -- Serpent Sting (Instant Serpent Spread)     (Merged with Tick)

-- mage
  [1449]   = CreateMergeSpellEntry("MAGE", .5),         -- Arcane Explosion                           (INSTANT)
  [11113]  = CreateMergeSpellEntry("MAGE"),             -- Blast Wave
  [42208]  = CreateMergeSpellEntry("MAGE"),             -- Blizzard
  [83853]  = CreateMergeSpellEntry("MAGE"),             -- Combustion
  [120]    = CreateMergeSpellEntry("MAGE"),             -- Cone of Cold
  [31661]  = CreateMergeSpellEntry("MAGE", .5),         -- Dragon's Breath                            (INSTANT)
  [83619]  = CreateMergeSpellEntry("MAGE", .5),         -- Flame Orb                                  (INSTANT)
  [2120]   = CreateMergeSpellEntry("MAGE", 4),          -- Flamestrike                                (Over 4 seconds)
  [122]    = CreateMergeSpellEntry("MAGE", .5),         -- Frost Nova                                 (INSTANT)
  [44461]  = CreateMergeSpellEntry("MAGE"),             -- Living Bomb                                (Merged w/ DoT)
  [148022] = CreateMergeSpellEntry("MAGE", 4),          -- Icicle (Frost Mastery)                     (Could not find an actual time)
  [12654]  = CreateMergeSpellEntry("MAGE"),             -- Ignite
  [114954] = CreateMergeSpellEntry("MAGE"),             -- Nether Tempest                             (Merged w/ Secondary Spell)
  [11366]  = CreateMergeSpellEntry("MAGE"),             -- Pyroblast
  
-- monk (damage)
  [128531] = CreateMergeSpellEntry("MONK", 4),          -- Blackout Kick (DoT)                        (Every 1s for 4s)
  [115181] = CreateMergeSpellEntry("MONK", .5),         -- Breath of Fire                             (INSTANT)
  [148135] = CreateMergeSpellEntry("MONK", 3),          -- Chi Burst (Damage)
  [132467] = CreateMergeSpellEntry("MONK", 6),          -- Chi Wave (Damage)
  [113656] = CreateMergeSpellEntry("MONK", 4),          -- Fists of Fury                              (Merged w/ Secondary Spell)
  [121253] = CreateMergeSpellEntry("MONK", .5),         -- Keg Smash                                  (INSTANT)
  [148187] = CreateMergeSpellEntry("MONK", 2.5),        -- Rushing Jade Wind (Damage)                 (Duplicated SCK healing interval)
  [107270] = CreateMergeSpellEntry("MONK", 2.5),        -- Spinning Crane Kick                        (Over 2s)
  [124255] = CreateMergeSpellEntry("MONK", 6),          -- Stagger/Staffelung
  [124098] = CreateMergeSpellEntry("MONK", 6),          -- Zen Sphere (Damage)                        (Merged w/ Detonate)

-- monk (healing)
  [128591] = CreateMergeSpellEntry("MONK", 3),          -- Blackout Kick (Heal??)
  [130654] = CreateMergeSpellEntry("MONK", 3),          -- Chi Burst
  [124040] = CreateMergeSpellEntry("MONK", 5),          -- Chi Torpedo                                (INSTANT)
  [132463] = CreateMergeSpellEntry("MONK", 6),          -- Chi Wave (Heal)
  [117895] = CreateMergeSpellEntry("MONK", 3),          -- Eminence                                   (Merged w/ Statue)
  [132120] = CreateMergeSpellEntry("MONK", 6),          -- Enveloping Mist                            (Every 1s for 6s)
  [119611] = CreateMergeSpellEntry("MONK", 6),          -- Renewing Mist                              (Every 3s for 18s)
  [115310] = CreateMergeSpellEntry("MONK"),             -- Revival
  [127722] = CreateMergeSpellEntry("MONK", 3),          -- Serpent's Zeal
  [115175] = CreateMergeSpellEntry("MONK", 4.5),        -- Soothing Mist                              (Every 1s for 8s)
  [117640] = CreateMergeSpellEntry("MONK", 2.5),        -- Spinning Crane Kick (Heal)                 (Over 2s)
  [116670] = CreateMergeSpellEntry("MONK", .5),         -- Uplift                                     (INSTANT)
  [124081] = CreateMergeSpellEntry("MONK", 6),          -- Zen Sphere (Heal)                          (Merged w/ Detonate)

-- paladin (damage)
  [86704]  = CreateMergeSpellEntry("PALADIN", .5),      -- Ancient Fury                               (INSTANT)
  [114919] = CreateMergeSpellEntry("PALADIN", 6.5),     -- Arcing Light (Damage)
  [31935]  = CreateMergeSpellEntry("PALADIN"),          -- Avenger's Shield
  [31803]  = CreateMergeSpellEntry("PALADIN", 6),       -- Censure
  [81297]  = CreateMergeSpellEntry("PALADIN"),          -- Consecration
  [53385]  = CreateMergeSpellEntry("PALADIN"),          -- Divine Storm
  [122032] = CreateMergeSpellEntry("PALADIN"),          -- Glyph of Mass Exorcism
  [88263]  = CreateMergeSpellEntry("PALADIN"),          -- Hammer of Righteous
  [119072] = CreateMergeSpellEntry("PALADIN", .5),      -- Holy Wrath                                 (INSTANT)
  [114852] = CreateMergeSpellEntry("PALADIN", .5),      -- Holy Prism (Healing on Target, Damage AoE) (INSTANT)
  [96172]  = CreateMergeSpellEntry("PALADIN", .5),      -- Mastery: Hand of Light
  [42463]  = CreateMergeSpellEntry("PALADIN"),          -- Seal of Truth
  [101423] = CreateMergeSpellEntry("PALADIN"),          -- Seal of Righteousness

-- paladin (healing)
  [119952] = CreateMergeSpellEntry("PALADIN", 6.5),     -- Arcing Light (Heal)                        (Every 2s for 17.5s)
  [53652]  = CreateMergeSpellEntry("PALADIN"),          -- Beacon of Light
  [121129] = CreateMergeSpellEntry("PALADIN", .5),      -- Daybreak                                   (INSTANT)
  [114163] = CreateMergeSpellEntry("PALADIN", 5),       -- Eternal Flame                              (Every 3s for 30s)
  [114871] = CreateMergeSpellEntry("PALADIN", .5),      -- Holy Prism (Damage on Target, Healing AoE) (ISNTANT)
  [82327]  = CreateMergeSpellEntry("PALADIN"),          -- Holy Radiance
  [85222]  = CreateMergeSpellEntry("PALADIN"),          -- Light of Dawn
  [86678]  = CreateMergeSpellEntry("PALADIN"),          -- Light of the Ancient kings
  [94289]  = CreateMergeSpellEntry("PALADIN"),          -- Protector of the Innocent
  [20167]  = CreateMergeSpellEntry("PALADIN"),          -- Seal of Insight (Heal)

-- priest (damage)
  [127628] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade (Damage)
  [2944]   = CreateMergeSpellEntry("PRIEST"),           -- Devouring Plague
  [122128] = CreateMergeSpellEntry("PRIEST", 3),        -- Divine Star (Shadow)                       (INSTANT... over 3ish)
  [120696] = CreateMergeSpellEntry("PRIEST", 5),        -- Halo (Damage)                              (INSTANT... over 5ish)
  [14914]  = CreateMergeSpellEntry("PRIEST"),           -- Holy Fire
  [132157] = CreateMergeSpellEntry("PRIEST", .5),       -- Holy Nova (Damage Effect)                  (INSTANT)
  [15407]  = CreateMergeSpellEntry("PRIEST"),           -- Mind Flay
  [49821]  = CreateMergeSpellEntry("PRIEST"),           -- Mind Sear                                  (Merged w/ Secondary Spell)
  [47666]  = CreateMergeSpellEntry("PRIEST"),           -- Penance (Damage Effect)
  [129250] = CreateMergeSpellEntry("PRIEST", 4),        -- Power Word: Solace
  [33619]  = CreateMergeSpellEntry("PRIEST", 3),        -- Reflective Shield
  [589]    = CreateMergeSpellEntry("PRIEST", 6),        -- Shadow Word: Pain
  [87532]  = CreateMergeSpellEntry("PRIEST"),           -- Shadowy Apparition
  [34914]  = CreateMergeSpellEntry("PRIEST", 6),        -- Vampiric Touch 

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
  [110745] = CreateMergeSpellEntry("PRIEST", 3),        -- Divine Star (Holy, Disc)                   (INSTANT... over 3ish)
  [120692] = CreateMergeSpellEntry("PRIEST", 3),        -- Halo                                       (INSTANT... over 3ish)
  [7001]   = CreateMergeSpellEntry("PRIEST", 4),        -- Light Well                                 (every 2s for 6s)
  [127626] = CreateMergeSpellEntry("PRIEST", 6.5),      -- Devouring Plague (Heal)
  [81751]  = CreateMergeSpellEntry("PRIEST", 6),        -- Atonement (Healing you do through damage)
  [126154] = CreateMergeSpellEntry("PRIEST", 3),        -- Lightspring Renew
  [120785] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade (Heal & Damage ??)
  [127629] = CreateMergeSpellEntry("PRIEST", 3),        -- Cascade (Heal - Shadow Spec)
  [15290]  = CreateMergeSpellEntry("PRIEST", 5),        -- Vampiric Embrace...........................(Over 15s)

-- rogue
  [22482]  = CreateMergeSpellEntry("ROGUE", .5),        -- Blade Flurry                               (INSTANT)
  [113780] = CreateMergeSpellEntry("ROGUE"),            -- Deadly Poison                              (Merged with DoT)
  [121411] = CreateMergeSpellEntry("ROGUE"),            -- Crimson Tempest                            (Merged with DoT)
  [51723]  = CreateMergeSpellEntry("ROGUE", .5),        -- Fan of Knives                              (INSTANT)
  [112974] = CreateMergeSpellEntry("ROGUE"),            -- Leeching Poison
  [8680]   = CreateMergeSpellEntry("ROGUE"),            -- Wound Poison

-- shaman (damage)
  [421]    = CreateMergeSpellEntry("SHAMAN", .5),       -- Chain Lightning                            (Merged with Mastery, INSTANT)
  [77478]  = CreateMergeSpellEntry("SHAMAN"),           -- Earthquake
  [8349]   = CreateMergeSpellEntry("SHAMAN"),           -- Fire Nova
  [8050]   = CreateMergeSpellEntry("SHAMAN"),           -- Flame Shock
  [10444]  = CreateMergeSpellEntry("SHAMAN"),           -- Flametongue Attack
  [114074] = CreateMergeSpellEntry("SHAMAN", .5),       -- Lava Beam                                  (Merged with Mastery, INSTANT)
  [26364]  = CreateMergeSpellEntry("SHAMAN"),           -- Lightning Shield (Static Shock)
  [8187]   = CreateMergeSpellEntry("SHAMAN"),           -- Magma Totem
  [58879]  = CreateMergeSpellEntry("SHAMAN"),           -- Spirit Hunt (Spirit Wolves)
  [120687] = CreateMergeSpellEntry("SHAMAN"),           -- Stormlash (Stormlash Totem)
  [51490]  = CreateMergeSpellEntry("SHAMAN"),           -- Thunderstorm
  [25504]  = CreateMergeSpellEntry("SHAMAN", .5),       -- Windfury Attack                            (INSTANT)

-- shaman (healing)
  [114911] = CreateMergeSpellEntry("SHAMAN", 5),        -- Ancestral Guidance                         (INSTANT)
  [1064]   = CreateMergeSpellEntry("SHAMAN", .5),       -- Chain Heal                                 (INSTANT)
  [51945]  = CreateMergeSpellEntry("SHAMAN"),           -- Earthliving
  [73921]  = CreateMergeSpellEntry("SHAMAN"),           -- Healing Rain
  [52042]  = CreateMergeSpellEntry("SHAMAN"),           -- Healing Stream Totem
  [114942] = CreateMergeSpellEntry("SHAMAN", 4),        -- Healing Tide Totem
  [114083] = CreateMergeSpellEntry("SHAMAN"),           -- Restorative Mists (Ascendance)
  [61295]  = CreateMergeSpellEntry("SHAMAN"),           -- Riptide
  [115360] = CreateMergeSpellEntry("SHAMAN"),           -- Stormblast                                 (Merged w/ Off-Hand)
  [32176]  = CreateMergeSpellEntry("SHAMAN"),           -- Stormstrike                                (Merged w/ Off-Hand)
  [114093] = CreateMergeSpellEntry("SHAMAN"),           -- Wind Lash (Ascendance)                     (Merged w/ Off-Hand)

-- warlock (damage)
  [980]    = CreateMergeSpellEntry("WARLOCK"),          -- Agony                                      (Merged with Malefic Grasp)
  [103967] = CreateMergeSpellEntry("WARLOCK", .5),      -- Carrion Swarm                              (INSTANT)
  [124915] = CreateMergeSpellEntry("WARLOCK", .5),      -- Chaos Wave                                 (INSTANT)
  [108685] = CreateMergeSpellEntry("WARLOCK", .5),      -- Conflagrate                                (INSTANT)
  [172]    = CreateMergeSpellEntry("WARLOCK"),          -- Corruption                                 (Merged with Malefic Grasp)
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
  [27243]  = CreateMergeSpellEntry("WARLOCK"),          -- Seed of Corruption                         (Merged w/ Explosion & Soulburned)
  [47960]  = CreateMergeSpellEntry("WARLOCK"),          -- Shadowflame (DOT)
  [108451] = CreateMergeSpellEntry("WARLOCK"),          -- Soul Link
  [30108]  = CreateMergeSpellEntry("WARLOCK"),          -- Unstable Affliction                        (Merged with Malefic Grasp)

-- warlock (healing)
  [89653]  = CreateMergeSpellEntry("WARLOCK"),          -- Drain Life
  [125314] = CreateMergeSpellEntry("WARLOCK"),          -- Harvest Life
  [63106]  = CreateMergeSpellEntry("WARLOCK"),          -- Siphon Life
  [108366] = CreateMergeSpellEntry("WARLOCK"),          -- Soul Leech
  [108447] = CreateMergeSpellEntry("WARLOCK"),          -- Soul Link

-- warrior
  [50622]  = CreateMergeSpellEntry("WARRIOR"),          -- Bladestorm                                 (Merged with Offhand)
  [113344] = CreateMergeSpellEntry("WARRIOR"),          -- Bloodbath
  [845]    = CreateMergeSpellEntry("WARRIOR", .5),      -- Cleave                                     (INSTANT)
  [115767] = CreateMergeSpellEntry("WARRIOR", 3),       -- Deep Wounds
  [52174]  = CreateMergeSpellEntry("WARRIOR", .5),      -- Heroic Leap                                (INSTANT)
  [96103]  = CreateMergeSpellEntry("WARRIOR"),          -- Raging Blow                                (Merged w/ Off-Hand)
  [6572]   = CreateMergeSpellEntry("WARRIOR", .5),      -- Revenge                                    (INSTANT)
  [46968]  = CreateMergeSpellEntry("WARRIOR", .5),      -- Shockwave                                  (INSTANT)
  [6343]   = CreateMergeSpellEntry("WARRIOR", .5),      -- Thunder Clap                               (INSTANT)
  [1680]   = CreateMergeSpellEntry("WARRIOR"),          -- Whirlwind                                  (Merged with Offhand)
}


addon.merge2h = {
  -- Hunter (Damage)
  [118253] = 83077,    -- Serpent Sting (Tick)
  [120761] = 121414,   -- Glaive Toss
  
  -- Mage (Damage)
  [44457]  = 44461,    -- Living Bomb (DOT)
  [114923] = 114954,   -- Nether Tempest (50% to random player)
  
  -- Monk (Damage)
  [117418] = 113656,   -- Fists of Fury
  [125033] = 124098,   -- Zen Sphere: Detonate (Damage)
  
  -- Monk (Healing)
  [126890] = 117895,   -- Eminence (Statue)
  [125953] = 115175,   -- Soothing Mist (Statue)
  [124101] = 124081,   -- Zen Sphere: Detonate (Heal)
  
  -- Priest (Damage)
  [124469] = 49821,    -- Mind Sear
  
  -- Rogue (Damage)
  [122233] = 121411,   -- Crimson Tempest (DoT)
  [2818]   = 113780,   -- Deadly Poison (DoT)

  -- Shaman (damage)
  [45297]  = 421,      -- Chain Lightning (Mastery)
  [114738] = 114074,   -- Lava Beam (Mastery)
  [32176]  = 32175,    -- Stormstrike
  [115360] = 115357,   -- Stormblast
  [114093] = 114089,   -- Wind Lash (Ascendance)
  
  -- Warlock (Damage)
  [131737] = 980,      -- Agony (Malefic Grasp)
  [131740] = 172,      -- Corruption (Malefic Grasp)
  [131736] = 30108,    -- Unstable Affliction (Malefic Grasp)
  [27285]  = 27243,    -- Seed of Corruption (Explosion)
  [87385]  = 27243,    -- Seed of Corruption (Explosion Soulburned)
  
  -- Warrior
  [85384]  = 96103,    -- Raging Blow
  [44949]  = 1680,     -- Whirlwind (Offhand)
  [95738] = 50622,     -- Bladestorm (Offhand)
}
