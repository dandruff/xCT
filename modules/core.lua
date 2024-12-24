--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2024. All Rights Reserved.        ]
 [====================================]]

-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

-- This allows us to create our config dialog
local AceGUI = LibStub("AceGUI-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

-- compares a tables values
local function tableCompare(t1, t2)
    local equal = true

    -- nil check
    if not t1 or not t2 then
        if not t1 and not t2 then
            return true
        else
            return false
        end
    end

    for i, v in pairs(t1) do
        if t2[i] ~= v then
            equal = false
            break
        end
    end
    return equal
end

-- Local Handle to the Engine
local x = addon.engine

-- Profile Updated, need to refresh important stuff
local function RefreshConfig()
    -- Clean up the Profile
    x:CompatibilityLogic(true)

    x:UpdateFrames()
    x:UpdateSpamSpells()

    -- Will this fix the profile issue?
    x.GenerateSpellSchoolColors()
    x.GenerateColorOptions()

    -- Update combat text engine CVars
    x.cvar_update(true)

    collectgarbage()
end

local function ProfileReset()
    -- Clean up the Profile
    x:CompatibilityLogic(false)

    x:UpdateFrames()
    x:UpdateSpamSpells()

    collectgarbage()
end

local function CheckExistingProfile()
    local key = UnitName("player") .. " - " .. GetRealmName()
    return xCTSavedDB
        and xCTSavedDB.profileKeys
        and xCTSavedDB.profileKeys[key]
        and xCTSavedDB.profiles[xCTSavedDB.profileKeys[key]]
end

-- Handle Addon Initialized
function x:OnInitialize()
    if xCT or ct and ct.myname and ct.myclass then
        print("|cffFF0000WARNING:|r xCT+ cannot load. Please disable xCT in order to use xCT+.")
        return
    end

    -- Initialize the options
    x:InitOptionsTable()

    -- Check for new installs
    self.existingProfile = CheckExistingProfile()

    -- Generate Dynamic Merge Entries
    addon.GenerateDefaultSpamSpells()

    -- Clean Up Colors in the DB
    addon.LoadDefaultColors()

    -- Load the Data Base
    self.db = LibStub("AceDB-3.0"):New("xCTSavedDB", addon.defaults)

    -- Add the profile options to my dialog config
    addon.optionsTable.args["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- Had to pass the explicit method into here, not sure why
    self.db.RegisterCallback(self, "OnProfileChanged", RefreshConfig)
    self.db.RegisterCallback(self, "OnProfileCopied", RefreshConfig)
    self.db.RegisterCallback(self, "OnProfileReset", ProfileReset)

    -- Clean up the Profile
    local success = x:CompatibilityLogic(self.existingProfile)
    if not success then
        x:UpdateCombatTextEvents(false)
        return
    end

    -- A cache of infos about the player
    x.player = {
        unit = "player",
        guid = UnitGUID("player"),
        class = select(2, UnitClass("player")),
        name = UnitName("player"),
        spec = -1,
    }
    x:UpdatePlayer()

    -- Delay updating frames until all other addons are loaded!
    x:UpdateCombatTextEvents(true)
    x:UpdateSpamSpells()
    x:UpdateAuraSpellFilter()
    x.GenerateColorOptions()
    x.GenerateSpellSchoolColors()

    -- Update combat text engine CVars
    x.cvar_update()

    -- Register Slash Commands
    x:RegisterChatCommand("xct", "OpenxCTCommand")

    x:EnableLibSinkSupport()

    -- Register addon to the new compartment frame see https://wowpedia.fandom.com/wiki/Addon_compartment
    AddonCompartmentFrame:RegisterAddon({
        text = AddonName,
        registerForAnyClick = true,
        notCheckable = true,
        func = function()
            x.ToggleConfigTool()
        end,
    })

    -- Register the Options
    ACD:SetDefaultSize(AddonName, 803, 560)
    AC:RegisterOptionsTable(AddonName, addon.optionsTable)

    --[=====================================================[
     Holds cached spells, buffs, and debuffs
    --]=====================================================]
    x.spellCache = {
        buffs = {},
        debuffs = {},
        spells = {},
        procs = {},
        items = {},
        damage = {},
        healing = {},
    }

    -- Everything got Initialized, show Startup Text
    if self.db.profile.showStartupText then
        print("Loaded |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r. To configure, type: |cffFF0000/xct|r")
    end
end

-- Need to create a handle to update frames when every other addon is done.
local frameUpdate = CreateFrame("FRAME")
frameUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
frameUpdate:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    x:UpdateFrames()
    x.cvar_update()
    --x.UpdateBlizzardOptions()
end)

-- Version Compare Helpers... Yeah!
local function VersionToTable(version)
    local major, minor, iteration, releaseMsg = string.match(string.lower(version), "(%d+)%.(%d+)%.(%d+)(.*)")
    major, minor, iteration = tonumber(major) or 0, tonumber(minor) or 0, tonumber(iteration) or 0
    local isAlpha, isBeta =
        string.find(releaseMsg, "alpha") and true or false, string.find(releaseMsg, "beta") and true or false
    local t = {}
    t.major = major
    t.minor = minor
    t.iteration = iteration
    t.isAlpha = isAlpha
    t.isBeta = isBeta
    t.isRelease = not (isAlpha or isBeta)

    if not t.isReleased then
        t.devBuild = tonumber(string.match(releaseMsg, "(%d+)")) or 1
    end
    return t
end

local function CompareVersions(a, b, debug)
    if debug then
        print("First Build:")
        for i, v in pairs(a) do
            print("    " .. i .. " = " .. tostring(v))
        end
        print("Second Build:")
        for i, v in pairs(b) do
            print("    " .. i .. " = " .. tostring(v))
        end
    end

    -- Compare Major numbers
    if a.major > b.major then
        return 1
    elseif a.major < b.major then
        return -1
    end

    -- Compare Minor numbers
    if a.minor > b.minor then
        return 1
    elseif a.minor < b.minor then
        return -1
    end

    -- Compare Iteration numbers
    if a.iteration > b.iteration then
        return 1
    elseif a.iteration < b.iteration then
        return -1
    end

    -- Compare Beta to Release then Alpha
    if not a.isBeta and b.isBeta then
        if a.isAlpha then
            return -1
        else
            return 1
        end
    elseif a.isBeta and not b.isBeta then
        if b.isAlpha then
            return 1
        else
            return -1
        end
    end

    -- Compare Beta Build Versions
    if a.isBeta and b.isBeta then
        if a.devBuild > b.devBuild then
            return 1
        elseif a.devBuild < b.devBuild then
            return -1
        end
        return 0
    end

    -- Compare Alpha to Release
    if not a.isAlpha and b.isAlpha then
        return 1
    elseif a.isAlpha and not b.isAlpha then
        return -1
    end

    -- Compare Alpha Build Versions
    if a.isAlpha and b.isAlpha then
        if a.devBuild > b.devBuild then
            return 1
        elseif a.devBuild < b.devBuild then
            return -1
        end
        return 0
    end

    return 0
end

do
    local cleanUpShown = false
    function x.MigratePrint(msg)
        if not cleanUpShown then
            print("|cffFF0000x|rCT|cffFFFF00+|r: |cffFF8000Clean Up - Migrated Settings|r")
            cleanUpShown = true
        end
        print("    " .. msg)
    end
end

-- This function was created as the central location for crappy code
function x:CompatibilityLogic(existing)
    local addonVersionString = C_AddOns.GetAddOnMetadata("xCT+", "Version")
    local currentVersion = VersionToTable(addonVersionString)
    local previousVersion = VersionToTable(self.db.profile.dbVersion or "4.3.0 Beta 2")

    if not currentVersion.devBuild and UnitName("player") == "Dandraffbal" then
        currentVersion.devBuild = 1
    end

    if existing then
        -- Pre-Legion Requires Complete Reset
        if CompareVersions(VersionToTable("4.2.9"), previousVersion) > 0 then
            StaticPopup_Show("XCT_PLUS_DB_CLEANUP_2")
            return false -- Do not continue loading addon
        end

        -- 4.3.0 Beta 3 -> Removes Spell School Colors from Outgoing fraame settings
        if CompareVersions(VersionToTable("4.3.0 Beta 3"), previousVersion) > 0 then
            if currentVersion.devBuild then
                x.MigratePrint(
                    "|cff798BDDSpell School Colors|r (|cffFFFF00From: Config Tool->Frames->Outgoing|r | |cff00FF00To: Config Tool->Spell School Colors|r)"
                )
            end
            if x.db.profile.frames.outgoing.colors.spellSchools then
                local oldDB = x.db.profile.frames.outgoing.colors.spellSchools.colors
                local newDB = x.db.profile.SpellColors
                local keys = {
                    ["SpellSchool_Physical"] = "1",
                    ["SpellSchool_Holy"] = "2",
                    ["SpellSchool_Fire"] = "4",
                    ["SpellSchool_Nature"] = "8",
                    ["SpellSchool_Frost"] = "16",
                    ["SpellSchool_Shadow"] = "32",
                    ["SpellSchool_Arcane"] = "64",
                }
                for oldKey, newKey in pairs(keys) do
                    if oldDB[oldKey] then
                        newDB[newKey].enabled = oldDB[oldKey].enabled
                        newDB[newKey].color = oldDB[oldKey].color
                    end
                end
                x.db.profile.frames.outgoing.colors.spellSchools = nil
            end
        end

        -- 4.3.0 Beta 4 -> Remove redundent Merge Entries from the Config
        if CompareVersions(VersionToTable("4.3.0 Beta 5"), previousVersion) > 0 then
            if currentVersion.devBuild then
                x.MigratePrint("|cff798BDDMerge Entries:|r (|cffFFFF00Optimizing SavedVars|r)")
            end
            local merge = x.db.profile.spells.merge
            for id, entry in pairs(merge) do
                merge[id] = nil
                if not entry.enabled and addon.merges[id] then
                    merge[id] = { enabled = false }
                end
            end
        end

        -- Clean up colors names in the database
        if CompareVersions(VersionToTable("4.3.3 Beta 1"), previousVersion) > 0 then
            if currentVersion.devBuild then --currentVersion.devBuild then
                x.MigratePrint(
                    "|cff798BDDCustom Colors|r (|cffFFFF00From: Config Tool->Frames-> All Frames ->Colors|r) Removing old options."
                )
            end
            for name, settings in pairs(x.db.profile.frames) do
                if settings.colors then
                    for exists in pairs(settings.colors) do
                        if
                            addon.defaults.profile.frames[name]
                            and not addon.defaults.profile.frames[name].colors[exists]
                        then
                            settings.colors[exists] = nil
                        end
                    end
                end
            end
        end

        -- Clean up class frame from database
        if CompareVersions(VersionToTable("4.5.1-beta5"), previousVersion) > 0 then
            if currentVersion.devBuild then --currentVersion.devBuild then
                x.MigratePrint("|cffFFFF00Cleaning Frame DB (Removing Class)|r")
            end
            self.db.profile.frames.class = nil
        end
    else
        -- Created New: Dont need to do anything right now
    end
    self.db.profile.dbVersion = addonVersionString

    return true
end

function x:CleanUpForLegion()
    local key = xCTSavedDB.profileKeys[UnitName("player") .. " - " .. GetRealmName()]
    xCTSavedDB.profiles[key] = {}
    ReloadUI()
end

-- Spammy Spell Get/Set Functions
local function SpamMergerGetSpellInterval(info)
    local spellId = tonumber(info[#info])
    return x.db.profile.spells.merge[spellId].interval or addon.merges[spellId].interval or 0
end

local function SpamMergerSetSpellInterval(info, value)
    local spellId = tonumber(info[#info])
    local db = x.db.profile.spells.merge[spellId] or {}
    db.interval = value
    x.db.profile.spells.merge[spellId] = db
end

local CLASS_NAMES = {
    ["DEATHKNIGHT"] = {
        [0] = 0, -- All Specs
        [250] = 1, -- Blood
        [251] = 2, -- Frost
        [252] = 3, -- Unholy
    },
    ["DEMONHUNTER"] = {
        [0] = 0, -- All Specs
        [577] = 1, -- Havoc
        [581] = 2, -- Vengeance
    },
    ["DRUID"] = {
        [0] = 0, -- All Specs
        [102] = 1, -- Balance
        [103] = 2, -- Feral
        [104] = 3, -- Guardian
        [105] = 4, -- Restoration
    },
    ["EVOKER"] = {
        [0] = 0, -- All Specs
        [1467] = 1, -- Devastation
        [1468] = 2, -- Preservation
        [1473] = 3, -- Augmentation
    },
    ["HUNTER"] = {
        [0] = 0, -- All Specs
        [253] = 1, -- Beast Mastery
        [254] = 2, -- Marksmanship
        [255] = 3, -- Survival
    },
    ["MAGE"] = {
        [0] = 0, -- All Specs
        [62] = 1, -- Arcane
        [63] = 2, -- Fire
        [64] = 3, -- Frost
    },
    ["MONK"] = {
        [0] = 0, -- All Specs
        [268] = 1, -- Brewmaster
        [269] = 2, -- Windwalker
        [270] = 3, -- Mistweaver
    },
    ["PALADIN"] = {
        [0] = 0, -- All Specs
        [65] = 1, -- Holy
        [66] = 2, -- Protection
        [70] = 3, -- Retribution
    },
    ["PRIEST"] = {
        [0] = 0, -- All Specs
        [256] = 1, -- Discipline
        [257] = 2, -- Holy
        [258] = 3, -- Shadow
    },
    ["ROGUE"] = {
        [0] = 0, -- All Specs
        [259] = 1, -- Assassination
        [260] = 2, -- Combat
        [261] = 3, -- Subtlety
    },
    ["SHAMAN"] = {
        [0] = 0, -- All Specs
        [262] = 1, -- Elemental
        [263] = 2, -- Enhancement
        [264] = 3, -- Restoration
    },
    ["WARLOCK"] = {
        [0] = 0, -- All Specs
        [265] = 1, -- Affliction
        [266] = 2, -- Demonology
        [267] = 3, -- Destruction
    },
    ["WARRIOR"] = {
        [0] = 0, -- All Specs
        [71] = 1, -- Arms
        [72] = 2, -- Fury
        [73] = 3, -- Protection
    },
}

local function cleanColors(colorTable)
    for _, color in pairs(colorTable) do
        if color.colors then
            cleanColors(color.colors)
        else
            color.color = { color.default[1], color.default[2], color.default[3] }
        end
    end
end

function addon.LoadDefaultColors()
    for _, settings in pairs(addon.defaults.profile.frames) do
        if settings.colors then
            cleanColors(settings.colors)
        end
    end
    cleanColors(addon.defaults.profile.SpellColors)
end

-- Gets spammy spells from the database and creates options
function x:UpdateSpamSpells()
    --[[ Update our saved DB
  for id, item in pairs(addon.merges) do
    if not self.db.profile.spells.merge[id] then
        self.db.profile.spells.merge[id] = { interval = item.interval }
    else
        -- update merge setting in case they are outdated
        self.db.profile.spells.merge[id].interval = item.interval
        self.db.profile.spells.merge[id].desc = item.desc
        self.db.profile.spells.merge[id].class = item.class
    end
  end]]

    local spells = addon.optionsTable.args.spells.args.classList.args
    local global = addon.optionsTable.args.spells.args.globalList.args
    local racetab = addon.optionsTable.args.spells.args.raceList.args

    for class, specs in pairs(CLASS_NAMES) do
        spells[class].args = {}
        for spec, index in pairs(specs) do
            local name, _ = "All Specializations"
            if index ~= 0 then
                _, name = GetSpecializationInfoByID(spec)
            end

            spells[class].args["specHeader" .. index] = {
                type = "header",
                order = index * 2,
                name = name,
            }
        end
    end

    -- Create a list of the categories (to be sorted)
    local spamMergerGlobalSpellCategories = {}
    local spamMergerRacialSpellCategories = {}
    for _, entry in pairs(addon.merges) do
        if not CLASS_NAMES[entry.category] then
            if entry.desc == "Racial Spell" then
                table.insert(
                    spamMergerRacialSpellCategories,
                    {category = entry.category, order = entry.categoryOrder}
                )
            else
                table.insert(
                    spamMergerGlobalSpellCategories,
                    {category = entry.category, order = entry.categoryOrder}
                )
            end
        end
    end

    -- Show Categories in insert order
    local function sortTableByOrder(a, b)
        return a.order < b.order
    end
    table.sort(spamMergerGlobalSpellCategories, sortTableByOrder)
    table.sort(spamMergerRacialSpellCategories, sortTableByOrder)

    -- Assume less than 1000 entries per category ;)
    local spamMergerGlobalSpellOrders = {}
    for i, category in pairs(spamMergerGlobalSpellCategories) do
        local currentIndex = i * 1000

        -- Create the Category Header
        global[category.category] = {
            type = "header",
            order = currentIndex,
            name = category.category,
        }
        spamMergerGlobalSpellOrders[category.category] = currentIndex + 1
    end

    local spamMergerRacialSpellOrders = {}
    for i, rcategory in pairs(spamMergerRacialSpellCategories) do
        local rcurrentIndex = i * 1000

        -- Create the Category Header
        racetab[rcategory.category] = {
            type = "header",
            order = rcurrentIndex,
            name = rcategory.category,
        }
        spamMergerRacialSpellOrders[rcategory.category] = rcurrentIndex + 1
    end

    ------------------------------------------------------

    -- Update the UI
    for spellID, entry in pairs(addon.merges) do
        local name = C_Spell.GetSpellName(spellID)
        if name then
            --TODO better code when i understand more the code
            -- Create a useful description for the spell
            local spellDesc = C_Spell.GetSpellDescription(spellID) or "No Description"
            local desc = ""
            if entry.desc and not CLASS_NAMES[entry.category] then
                desc = "|cff9F3ED5" .. entry.desc .. "|r\n\n"
            end
            desc = desc .. spellDesc .. "\n\n|cffFF0000ID|r |cff798BDD" .. spellID .. "|r"

            local firstSecondaryIdFound = true
            for originalSpellId, replaceSpellId in pairs(addon.replaceSpellId) do
                if replaceSpellId == spellID then
                    if firstSecondaryIdFound then
                        desc = desc .. "\n|cffFF0000Secondary ID(s)|r |cff798BDD" .. originalSpellId
                        firstSecondaryIdFound = false
                    else
                        desc = desc .. ", " .. originalSpellId
                    end
                end
            end
            if not firstSecondaryIdFound then
                desc = desc .. "|r"
            end
            -- TODO replacement spells without explicit merging entries are not displayed here

            -- Add the spell to the UI
            if CLASS_NAMES[entry.category] then
                local index = CLASS_NAMES[entry.category][tonumber(entry.desc) or 0]
                spells[entry.category].args[tostring(spellID)] = {
                    order = index * 2 + 1,
                    name = name,
                    desc = desc,
                    type = "range",
                    min = 0,
                    max = 5,
                    step = 0.1,
                    get = SpamMergerGetSpellInterval,
                    set = SpamMergerSetSpellInterval,
                }
            elseif entry.desc == "Racial Spell" then
                racetab[tostring(spellID)] = {
                    order = spamMergerRacialSpellOrders[entry.category],
                    name = name,
                    desc = desc,
                    type = "range",
                    min = 0,
                    max = 5,
                    step = 0.1,
                    get = SpamMergerGetSpellInterval,
                    set = SpamMergerSetSpellInterval,
                }
                spamMergerRacialSpellOrders[entry.category] = spamMergerRacialSpellOrders[entry.category] + 1
            else
                global[tostring(spellID)] = {
                    order = spamMergerGlobalSpellOrders[entry.category],
                    name = name,
                    desc = desc,
                    type = "range",
                    min = 0,
                    max = 5,
                    step = 0.1,
                    get = SpamMergerGetSpellInterval,
                    set = SpamMergerSetSpellInterval,
                }
                spamMergerGlobalSpellOrders[entry.category] = spamMergerGlobalSpellOrders[entry.category] + 1
            end
        end
    end
end

local function getCP_1(info)
    return x.db.profile.spells.combo[x.player.class][info[#info]]
end
local function setCP_1(info, value)
    x.db.profile.spells.combo[x.player.class][info[#info]] = value
end

local function getCP_2(info)
    local spec, index = string.match(info[#info], "(%d+),(.+)")
    local value = x.db.profile.spells.combo[x.player.class][tonumber(spec)][tonumber(index) or index]
    if type(value) == "table" then
        return value.enabled
    else
        return value
    end
end
local function setCP_2(info, value)
    local spec, index = string.match(info[#info], "(%d+),(.+)")

    if value == true then
        for key, entry in pairs(x.db.profile.spells.combo[x.player.class][tonumber(spec)]) do
            if type(entry) == "table" then
                entry.enabled = false
            else
                x.db.profile.spells.combo[x.player.class][tonumber(spec)][key] = false
            end
        end
    end

    if tonumber(index) then -- it is a spell ID
        x.db.profile.spells.combo[x.player.class][tonumber(spec)][tonumber(index)].enabled = value
    else -- it is a unit's power
        x.db.profile.spells.combo[x.player.class][tonumber(spec)][index] = value
    end

    -- Update tracker
    x:UpdateComboTracker()
end

-- Update the combo point list
function x:UpdateComboPointOptions(force)
    if x.LOADED_COMBO_POINTS_OPTIONS and not force then
        return
    end

    local myClass, offset = x.player.class, 2

    local comboSpells = {
        order = 100,
        name = "Misc",
        type = "group",
        args = {
            specialTweaks = {
                type = "description",
                order = 0,
                name = "|cff798BDDMiscellaneous Settings|r:",
                fontSize = "large",
            },
            specialTweaksDesc = {
                type = "description",
                order = 1,
                name = "|cffFFFFFF(Choose one per specialization)|r\n",
                fontSize = "small",
            },
        },
    }

    -- Add "All Specializations" Entries
    for name in pairs(x.db.profile.spells.combo[myClass]) do
        if not tonumber(name) then
            if not comboSpells.args["allSpecsHeader"] then
                comboSpells.args["allSpecsHeader"] = {
                    order = 2,
                    type = "header",
                    name = "All Specializations",
                    width = "full",
                }
            end
            comboSpells.args[name] = {
                order = offset,
                type = "toggle",
                name = name,
                get = getCP_1,
                set = setCP_1,
            }
            offset = offset + 1
        end
    end

    -- Add the each spec
    for spec in ipairs(x.db.profile.spells.combo[myClass]) do
        local haveSpec = false
        for index, entry in pairs(x.db.profile.spells.combo[myClass][spec] or {}) do
            if not haveSpec then
                haveSpec = true
                local mySpecName = select(2, GetSpecializationInfo(spec)) or "Tree " .. spec

                comboSpells.args["title" .. tostring(spec)] = {
                    order = offset,
                    type = "header",
                    name = "Specialization: |cff798BDD" .. mySpecName .. "|r",
                    width = "full",
                }
                offset = offset + 1
            end

            if tonumber(index) then
                -- Class Combo Points ( UNIT_AURA Tracking)
                comboSpells.args[tostring(spec) .. "," .. tostring(index)] = {
                    order = offset,
                    type = "toggle",
                    name = C_Spell.GetSpellName(entry.id),
                    desc = "Unit to track: |cffFF0000" .. entry.unit .. "|r\nSpell ID: |cffFF0000" .. entry.id .. "|r",
                    get = getCP_2,
                    set = setCP_2,
                }
            else
                -- Special Combo Point ( Unit Power )
                comboSpells.args[tostring(spec) .. "," .. tostring(index)] = {
                    order = offset,
                    type = "toggle",
                    name = index,
                    desc = "Unit Power",
                    get = getCP_2,
                    set = setCP_2,
                }
            end

            offset = offset + 1
        end
    end

    addon.optionsTable.args["Frames"].args["class"].args["tracker"] = comboSpells

    x.LOADED_COMBO_POINTS_OPTIONS = true

    x:UpdateComboTracker()
end

function x:UpdateComboTracker()
    local myClass, mySpec = x.player.class, x.player.spec
    x.TrackingEntry = nil

    if not mySpec or mySpec < 1 or mySpec > 4 then
        return
    end -- under Level 10 return 5

    for _, entry in pairs(x.db.profile.spells.combo[myClass][mySpec]) do
        if type(entry) == "table" and entry.enabled then
            x.TrackingEntry = entry
        end
    end

    x:QuickClassFrameUpdate()
end

-- Get and set methods for the spell filter
local function getSF(info)
    return x.db.profile.spellFilter[info[#info - 2]][info[#info]]
end
local function setSF(info, value)
    x.db.profile.spellFilter[info[#info - 2]][info[#info]] = value
end

-- Update the Buff, Debuff and Spell filter list
function x:UpdateAuraSpellFilter(specific)
    local i = 10

    if not specific or specific == "buffs" then
        -- Redo all the list
        addon.optionsTable.args.spellFilter.args.listBuffs.args.list = {
            name = "Filtered Buffs |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local buffs = addon.optionsTable.args.spellFilter.args.listBuffs.args.list.args
        local updated = false

        -- Update buffs
        for name in pairs(x.db.profile.spellFilter.listBuffs) do
            updated = true
            buffs[name] = {
                order = i,
                name = name,
                type = "toggle",
                get = getSF,
                set = setSF,
            }
        end

        if not updated then
            buffs["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update debuffs
    if not specific or specific == "debuffs" then
        i = 10
        addon.optionsTable.args.spellFilter.args.listDebuffs.args.list = {
            name = "Filtered Debuffs |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local debuffs = addon.optionsTable.args.spellFilter.args.listDebuffs.args.list.args
        local updated = false

        for name in pairs(x.db.profile.spellFilter.listDebuffs) do
            updated = true
            debuffs[name] = {
                order = i,
                name = name,
                type = "toggle",
                get = getSF,
                set = setSF,
            }
        end

        if not updated then
            debuffs["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update procs
    if not specific or specific == "procs" then
        i = 10
        addon.optionsTable.args.spellFilter.args.listProcs.args.list = {
            name = "Filtered Procs |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local procs = addon.optionsTable.args.spellFilter.args.listProcs.args.list.args
        local updated = false

        for name in pairs(x.db.profile.spellFilter.listProcs) do
            updated = true
            procs[name] = {
                order = i,
                name = name,
                type = "toggle",
                get = getSF,
                set = setSF,
            }
        end

        if not updated then
            procs["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update spells
    if not specific or specific == "spells" then
        i = 10
        addon.optionsTable.args.spellFilter.args.listSpells.args.list = {
            name = "Filtered Spells |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local spells = addon.optionsTable.args.spellFilter.args.listSpells.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listSpells) do
            local spellID = tonumber(string.match(id, "%d+"))
            local spellName = C_Spell.GetSpellName(spellID)
            if spellName then
                updated = true
                spells[id] = {
                    order = i,
                    name = spellName,
                    desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                    type = "toggle",
                    get = getSF,
                    set = setSF,
                }
            else
                x.db.profile.spellFilter.listSpells[id] = nil
            end
        end

        if not updated then
            spells["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update spells
    if not specific or specific == "items" then
        i = 10
        addon.optionsTable.args.spellFilter.args.listItems.args.list = {
            name = "Filtered Items |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local spells = addon.optionsTable.args.spellFilter.args.listItems.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listItems) do
            local spellID = tonumber(string.match(id, "%d+"))
            local name = C_Item.GetItemNameByID(spellID or id)
            local texture = C_Item.GetItemIconByID(spellID or id)
            name = name or "Unknown Item"
            updated = true
            spells[id] = {
                order = i,
                name = string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", texture or x.BLANK_ICON, 16, 16, name),
                desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                type = "toggle",
                get = getSF,
                set = setSF,
            }
        end

        if not updated then
            spells["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    if not specific or specific == "damage" then
        i = 10
        addon.optionsTable.args.spellFilter.args.listDamage.args.list = {
            name = "Filtered Incoming Damage |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local spells = addon.optionsTable.args.spellFilter.args.listDamage.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listDamage) do
            local spellID = tonumber(string.match(id, "%d+"))
            local spellName = C_Spell.GetSpellName(spellID or id)
            if spellName then
                updated = true
                spells[id] = {
                    order = i,
                    name = spellName,
                    desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                    type = "toggle",
                    get = getSF,
                    set = setSF,
                }
            else
                x.db.profile.spellFilter.listDamage[id] = nil
            end
        end

        if not updated then
            spells["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    if not specific or specific == "healing" then
        i = 10
        addon.optionsTable.args.spellFilter.args.listHealing.args.list = {
            name = "Filtered Incoming Healing |cff798BDD(Uncheck to Disable)|r",
            type = "group",
            guiInline = true,
            order = 11,
            args = {},
        }

        local spells = addon.optionsTable.args.spellFilter.args.listHealing.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listHealing) do
            local spellID = tonumber(string.match(id, "%d+"))
            local spellName = C_Spell.GetSpellName(spellID or id)
            if spellName then
                updated = true
                spells[id] = {
                    order = i,
                    name = spellName,
                    desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                    type = "toggle",
                    get = getSF,
                    set = setSF,
                }
            else
                x.db.profile.spellFilter.listHealing[id] = nil
            end
        end

        if not updated then
            spells["noSpells"] = {
                order = 1,
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end
end

-- Add and remove Buffs, debuffs, and spells from the filter
function x.AddFilteredSpell(name, category)
    if category == "listBuffs" then
        x.db.profile.spellFilter.listBuffs[name] = true
        x:UpdateAuraSpellFilter("buffs")
    elseif category == "listDebuffs" then
        x.db.profile.spellFilter.listDebuffs[name] = true
        x:UpdateAuraSpellFilter("debuffs")
    elseif category == "listSpells" then
        local spellID = tonumber(string.match(name, "%d+"))
        if spellID and C_Spell.GetSpellName(spellID) then
            x.db.profile.spellFilter.listSpells[name] = true
            x:UpdateAuraSpellFilter("spells")
        else
            print("|cffFF0000x|r|cffFFFF00CT+|r  Could not add invalid Spell ID: |cff798BDD" .. name .. "|r")
        end
    elseif category == "listProcs" then
        x.db.profile.spellFilter.listProcs[name] = true
        x:UpdateAuraSpellFilter("procs")
    elseif category == "listItems" then
        x.db.profile.spellFilter.listItems[name] = true
        x:UpdateAuraSpellFilter("items")
    elseif category == "listDamage" then
        x.db.profile.spellFilter.listDamage[name] = true
        x:UpdateAuraSpellFilter("damage")
    elseif category == "listHealing" then
        x.db.profile.spellFilter.listHealing[name] = true
        x:UpdateAuraSpellFilter("healing")
    else
        print("|cffFF0000x|r|cffFFFF00CT+|r  |cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
    end
end

function x.RemoveFilteredSpell(name, category)
    if category == "listBuffs" then
        x.db.profile.spellFilter.listBuffs[name] = nil
        x:UpdateAuraSpellFilter("buffs")
    elseif category == "listDebuffs" then
        x.db.profile.spellFilter.listDebuffs[name] = nil
        x:UpdateAuraSpellFilter("debuffs")
    elseif category == "listSpells" then
        local spellID = tonumber(string.match(name, "%d+"))
        if spellID and C_Spell.GetSpellName(spellID) then
            x.db.profile.spellFilter.listSpells[name] = nil
            x:UpdateAuraSpellFilter("spells")
        else
            print("|cffFF0000x|r|cffFFFF00CT+|r  Could not remove invalid Spell ID: |cff798BDD" .. name .. "|r")
        end
        x:UpdateAuraSpellFilter("spells")
    elseif category == "listProcs" then
        x.db.profile.spellFilter.listProcs[name] = nil
        x:UpdateAuraSpellFilter("procs")
    elseif category == "listItems" then
        x.db.profile.spellFilter.listItems[name] = nil
        x:UpdateAuraSpellFilter("items")
    elseif category == "listDamage" then
        x.db.profile.spellFilter.listDamage[name] = nil
        x:UpdateAuraSpellFilter("damage")
    elseif category == "listHealing" then
        x.db.profile.spellFilter.listHealing[name] = nil
        x:UpdateAuraSpellFilter("healing")
    else
        print("|cffFF0000x|r|cffFFFF00CT+|r  |cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
    end
end

local colorNameDB = {}

-- Returns the color and if it was enabled
function x.LookupColorByName(name)
    if colorNameDB[name] then
        if colorNameDB[name].enabled then
            return colorNameDB[name].color or colorNameDB[name].default, true
        end
        return colorNameDB[name].default, false
    else
        return
    end
end

local getColorDB = function(info)
    local enabled = string.match(info[#info], "(.*)_enabled")
    local color = string.match(info[#info], "(.*)_color")

    if info[#info - 1] == "fontColors" then
        if enabled then
            return x.db.profile.frames[info[#info - 2]].colors[enabled].enabled
        elseif color then
            return unpack(
                x.db.profile.frames[info[#info - 2]].colors[color].color
                    or x.db.profile.frames[info[#info - 2]].colors[color].default
            )
        end
    elseif info[#info - 2] == "fontColors" then
        if enabled then
            return x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[enabled].enabled
        elseif color then
            return unpack(
                x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].color
                    or x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].default
            )
        end
    elseif info[#info - 3] == "fontColors" then
        if enabled then
            return x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[enabled].enabled
        elseif color then
            return unpack(
                x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].color
                    or x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].default
            )
        end
    elseif info[#info - 1] == "SpellSchools" then
        if enabled then
            return x.db.profile.SpellColors[enabled].enabled
        elseif color then
            return unpack(x.db.profile.SpellColors[color].color or x.db.profile.SpellColors[color].default)
        end
    end
end

local setColorDB = function(info, r, g, b)
    local enabled = string.match(info[#info], "(.*)_enabled")
    local color = string.match(info[#info], "(.*)_color")
    if info[#info - 1] == "fontColors" then
        if enabled then
            x.db.profile.frames[info[#info - 2]].colors[enabled].enabled = r
        elseif color then
            x.db.profile.frames[info[#info - 2]].colors[color].color = { r, g, b }
        end
    elseif info[#info - 2] == "fontColors" then
        if enabled then
            x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[enabled].enabled = r
        elseif color then
            x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].color = { r, g, b }
        end
    elseif info[#info - 3] == "fontColors" then
        if enabled then
            x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[enabled].enabled =
                r
        elseif color then
            x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].color =
                { r, g, b }
        end
    elseif info[#info - 1] == "SpellSchools" then
        if enabled then
            x.db.profile.SpellColors[enabled].enabled = r
        elseif color then
            x.db.profile.SpellColors[color].color = { r, g, b }
        end
    end
end

local funcColorReset = function(info)
    local color = string.match(info[#info], "(.*)_reset")
    if info[#info - 1] == "fontColors" then
        x.db.profile.frames[info[#info - 2]].colors[color].color =
            x.db.profile.frames[info[#info - 2]].colors[color].default
    elseif info[#info - 2] == "fontColors" then
        x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].color =
            x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].default
    elseif info[#info - 3] == "fontColors" then
        x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].color =
            x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].default
    elseif info[#info - 1] == "SpellSchools" then
        x.db.profile.SpellColors[color].color = x.db.profile.SpellColors[color].default
    end
end

local funcColorHidden = function(info)
    local color = string.match(info[#info], "(.*)_color")
    if info[#info - 1] == "fontColors" then
        return not x.db.profile.frames[info[#info - 2]].colors[color].enabled
    elseif info[#info - 2] == "fontColors" then
        return not x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].enabled
    elseif info[#info - 3] == "fontColors" then
        return not x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].enabled
    elseif info[#info - 1] == "SpellSchools" then
        return not x.db.profile.SpellColors[color].enabled
    end
end

local funcColorResetHidden = function(info)
    local color = string.match(info[#info], "(.*)_reset")
    if info[#info - 1] == "fontColors" then
        return not x.db.profile.frames[info[#info - 2]].colors[color].enabled
            or tableCompare(
                x.db.profile.frames[info[#info - 2]].colors[color].color,
                x.db.profile.frames[info[#info - 2]].colors[color].default
            )
    elseif info[#info - 2] == "fontColors" then
        return not x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].enabled
            or tableCompare(
                x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].color,
                x.db.profile.frames[info[#info - 3]].colors[info[#info - 1]].colors[color].default
            )
    elseif info[#info - 3] == "fontColors" then
        return not x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].enabled
            or tableCompare(
                x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].color,
                x.db.profile.frames[info[#info - 4]].colors[info[#info - 2]].colors[info[#info - 1]].colors[color].default
            )
    elseif info[#info - 1] == "SpellSchools" then
        return not x.db.profile.SpellColors[color].enabled
            or tableCompare(x.db.profile.SpellColors[color].color, x.db.profile.SpellColors[color].default)
    end
end

local funcColorDisabled = function(info)
    if info[#info - 1] == "fontColors" then
        return x.db.profile.frames[info[#info - 2]].customColor
    elseif info[#info - 2] == "fontColors" then
        return x.db.profile.frames[info[#info - 3]].customColor
    elseif info[#info - 3] == "fontColors" then
        return x.db.profile.frames[info[#info - 4]].customColor
    end
end

local function GenerateColorOptionsTable_Entry(colorName, settings, options, index)
    -- Clean the DB of any old/removed values
    if not settings.desc then
        return
    end

    -- Check for nil colors and set them to the default
    if not settings.color or not unpack(settings.color) then
        -- This needs to be a new table apperently
        settings.color = { unpack(settings.default) }
    end

    -- Cache this color into a quick lookup
    colorNameDB[colorName] = settings
    options[colorName .. "_enabled"] = {
        order = index,
        type = "toggle",
        name = settings.desc,
        get = getColorDB,
        set = setColorDB,
        desc = "Enable a custom color for |cff798BDD" .. settings.desc .. "|r.",
        disabled = funcColorDisabled,
    }
    options[colorName .. "_color"] = {
        order = index + 1,
        type = "color",
        name = "Color",
        get = getColorDB,
        set = setColorDB,
        desc = "Change the color for |cff798BDD" .. settings.desc .. "|r.",
        hidden = funcColorHidden,
        disabled = funcColorDisabled,
    }
    options[colorName .. "_reset"] = {
        type = "execute",
        order = index + 2,
        name = "Reset",
        width = "half",
        func = funcColorReset,
        desc = "Resets |cff798BDD" .. settings.desc .. "|r back to the default color.",
        hidden = funcColorResetHidden,
        disabled = funcColorDisabled,
    }
    options["spacer" .. index] = {
        order = index + 3,
        type = "description",
        fontSize = "small",
        width = "full",
        name = "",
    }
end

local function GenerateColorOptionsTable(colorName, settings, options, index)
    if settings.colors then
        -- Multiple Layers of colors on the inside
        --[[options['spacer'..index] = {
      type = 'description',
      order = index,
      name = '\n',
      fontSize = 'small',
    }]]
        options[colorName] = {
            order = index + 1,
            type = "group",
            guiInline = true,
            name = settings.desc,
            args = {},
        }
        index = index + 1

        -- Sort the Colors Alphabetical
        local sortedList = {}
        for currentColorName in pairs(settings.colors) do
            table.insert(sortedList, currentColorName)
        end

        table.sort(sortedList)

        local currentColorSettings
        for _, currentColorName in ipairs(sortedList) do
            currentColorSettings = settings.colors[currentColorName]
            GenerateColorOptionsTable_Entry(currentColorName, currentColorSettings, options[colorName].args, index)
            index = index + 4
        end
    else
        -- Just this color
        GenerateColorOptionsTable_Entry(colorName, settings, options, index)
        index = index + 4
    end
    return index
end

-- Generate Colors for each Frame
function x.GenerateColorOptions()
    for name, settings in pairs(x.db.profile.frames) do
        local options = addon.optionsTable.args.Frames.args[name]
        if settings.colors then
            local index = 10

            -- Sort the Colors Alphabetical
            local sortedList = {}
            for colorName in pairs(settings.colors) do
                table.insert(sortedList, colorName)
            end

            table.sort(sortedList)

            local colorSettings
            -- Do Single Colors First
            for _, colorName in ipairs(sortedList) do
                colorSettings = settings.colors[colorName]
                if not colorSettings.colors then
                    index = GenerateColorOptionsTable(colorName, colorSettings, options.args.fontColors.args, index) + 1
                end
            end

            -- Then Do Color Groups with multiple settings
            for _, colorName in ipairs(sortedList) do
                colorSettings = settings.colors[colorName]
                if colorSettings.colors then
                    index = GenerateColorOptionsTable(colorName, colorSettings, options.args.fontColors.args, index) + 1
                end
            end
        end
    end
end

function x.GenerateSpellSchoolColors()
    local options = addon.optionsTable.args.SpellSchools.args
    local settings = x.db.profile.SpellColors
    local index = 10

    local sortedList = {}
    for n in pairs(settings) do
        sortedList[#sortedList + 1] = tonumber(n)
    end

    table.sort(sortedList)

    local color
    for _, mask in ipairs(sortedList) do
        mask = tostring(mask)
        color = settings[mask]
        index = GenerateColorOptionsTable(mask, color, options, index) + 1
    end
end

do
    local cache = {
        [1] = "1",
        [2] = "2",
        [3] = "3",
        [4] = "4",
        [5] = "5",
        [6] = "6",
        [8] = "8",
        [9] = "9",
        [10] = "10",
        [12] = "12",
        [16] = "16",
        [17] = "17",
        [18] = "18",
        [20] = "20",
        [24] = "24",
        [28] = "28",
        [32] = "32",
        [33] = "33",
        [34] = "34",
        [36] = "36",
        [40] = "40",
        [48] = "48",
        [64] = "64",
        [65] = "65",
        [66] = "66",
        [68] = "68",
        [72] = "72",
        [80] = "80",
        [96] = "96",
        [124] = "124",
        [126] = "126",
        [127] = "127",
    }

    function x.GetSpellSchoolColor(spellSchool, override)
        -- See if the override name is enabled
        if override then
            local newColor, enabled = x.LookupColorByName(override)
            if enabled then
                return newColor
            end
        end

        -- Fast String lookup (faster than tostring)
        local stringIndex = cache[spellSchool or 1] or "1"
        local entry = x.db.profile.SpellColors[stringIndex]
        return entry.enabled and entry.color or entry.default
    end
end

-- Add LibSink Support ... if some other addon has loaded it and there would be using it!
function x:EnableLibSinkSupport()
    -- Were wrapping this in pcall() because getting the lib can fail.
    -- This way no error will be logged and all will be happy.
    pcall(
        function()
            local frames, color, LibSink = {}, {}, LibStub("LibSink-2.0")

            for name, title in pairs(x.FrameTitles) do
                if name ~= "class" then
                    frames[title] = name
                end
            end

            -- shortName, name, desc, func, scrollAreaFunc, hasSticky
            LibSink:RegisterSink(
                "xCT_Plus",
                "xCT+",
                "Created for optimal performance in the toughest fights, this rugged combat text add-on is ready to be put to the test!",

                -- The Sink Function
                function(sinkAddon, text, r, g, b, font, size, outline, sticky, location, icon)
                    local settings = x.db.profile.frames[location or "general"]
                    if settings.iconsEnabled and icon then
                        if settings.fontJustify == "LEFT" then
                            text = string.format(
                                "%s %s",
                                string.format(" |T%s:%d:%d:0:0:64:64:5:59:5:59|t", icon, settings.iconSize, settings.iconSize),
                                text
                            )
                        else
                            text = string.format(
                                "%s%s",
                                text,
                                string.format(" |T%s:%d:%d:0:0:64:64:5:59:5:59|t", icon, settings.iconSize, settings.iconSize)
                            )
                        end
                    end
                    color[1] = r
                    color[2] = g
                    color[3] = b
                    x:AddMessage(location or "general", text, color)
                end,

                -- List Active Scrolling Areas
                function()
                    local tmp = {}
                    for name in pairs(frames) do
                        table.insert(tmp, name)
                    end
                    return tmp
                end,
                false
            )
        end
    )
end

-- A helpful set of tips
local tips = {
    "On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options.",
    "If you want to |cff798BDDCombine Frame Outputs|r, disable one of the frames and use the |cffFFFF00Secondary Frame|r option on that frame.",
    "Only the |cffFFFF00General|r, |cffFF8000Outgoing|r, |cffFFFF00Outgoing (Crits)|r, |cffFF8000Incoming Damage|r and |cffFFFF00Healing|r, and |cffFF8000Class Power|r frames can be abbreviated.",
    "The |cffFFFF00Hide Config in Combat|r option was added to prevent |cffFFFF00xCT+|r from tainting your UI. It is highly recommended left enabled.",
    "|cffFFFF00xCT+|r has several different ways it will merge critical hits. You can check them out in the |cffFFFF00Spam Merger|r section.",
    "Each frame has a |cffFFFF00Misc|r section; select a frame and select the drop-down box to find it.",
    "If there is a certain |cff798BDDSpell|r, |cff798BDDBuff|r, or |cff798BDDDebuff|r that you don't want to see, consider adding it to a |cff798BDDFilter|r.",
    "You can change how |cffFFFF00xCT+|r shows you names in the |cffFFFF00Names|r section of most frames.",
}

local helpfulList = {}
local function GetNextTip()
    if #helpfulList == 0 then
        local used = {}

        local num
        while #used ~= #tips do
            num = random(1, #tips)
            if not used[num] then
                used[num] = true
                table.insert(helpfulList, tips[num])
            end
        end
    end

    local currentItem = helpfulList[1]
    table.remove(helpfulList, 1)

    return currentItem
end

-- Unused for now
function x:OnEnable() end
function x:OnDisable() end

-- Close Config when entering combat
local lastConfigState, shownWarning = false, false
function x:CombatStateChanged()
    if x.db.profile.hideConfig then
        if self.inCombat then
            if x.myContainer then
                if x.myContainer:IsShown() then
                    lastConfigState = true
                    x:HideConfigTool()
                end
            end
        else
            if lastConfigState then
                x:ShowConfigTool()
            end
            lastConfigState = false
            shownWarning = false
        end
    end

    for framename, settings in pairs(x.db.profile.frames) do
        if settings.enableScrollable and settings.scrollableInCombat then
            if x.inCombat then
                x:DisableFrameScrolling(framename)
            else
                x:EnableFrameScrolling(framename)
            end
        end
    end
end

-- Force Config Page to refresh
function x:RefreshConfig()
    if ACD.OpenFrames[AddonName] then
        ACR:NotifyChange(AddonName)
    end
end

local helpfulLastUpdate = GetTime()
function x:OnAddonConfigRefreshed()
    if GetTime() - helpfulLastUpdate > 15 then
        helpfulLastUpdate = GetTime()
        addon.optionsTable.args.helpfulTip.name = GetNextTip()
        x:RefreshConfig()
    end
end

-- Process the slash command ('input' contains whatever follows the slash command)
function x:OpenxCTCommand(input)
    input = string.lower(input)

    local lock = input == "lock"
    local save = input == "save"
    if lock or save then
        if not x.configuring and save then
            return
        end

        if x.configuring then
            x:SaveAllFrames()
            x:EndConfigMode()
            x:Print("Frames have been saved. Please fasten your seat belts.")
            StaticPopup_Hide("XCT_PLUS_CONFIGURING")
        else
            x.ToggleConfigMode()

            x:Print("You are now free to move about the cabin.")
            x:Print("/xct lock   - Saves the current frame positions.")
            x:Print("/xct cancel - Resets the frame positions.")
        end

        -- return before you can do anything else
        return
    end

    if input == "cancel" then
        if x.configuring then
            x:UpdateFrames()
            x:EndConfigMode()
            x:Print("Reset the frame positions.")
        end

        return
    end

    if input == "help" then
        x:Print("Slash Commands:")
        x:Print("/xct lock - Locks and unlocks the frame movers.")
        x:Print("/xct test - Attempts to emulate combat.")
        return
    end

    if input == "test" then
        x.ToggleTestMode(true)
        return
    end

    if not x.configuring then
        x:ToggleConfigTool()
    end
end

local function myContainer_OnRelease(self)
    AceGUI:Release(x.myContainer)
    x.myContainer = nil

    x.isConfigToolOpen = false
end

function x:ToggleConfigTool()
    if x.isConfigToolOpen then
        x:HideConfigTool()
    else
        x:ShowConfigTool()
    end
end

function x:ShowConfigTool(...)
    if x.isConfigToolOpen then
        return
    end

    if x.inCombat and x.db.profile.hideConfig then
        if not shownWarning then
            print("|cffFF0000x|r|cffFFFF00CT+|r will open the |cff798BDDConfiguration Tool|r after combat.")
            shownWarning = true
            lastConfigState = true
        end
        return
    end

    x.isConfigToolOpen = true

    if x.myContainer then
        x.myContainer:Hide()
    end

    -- Register my AddOn for Escape keypresses
    x.myContainer = AceGUI:Create("Frame")
    x.myContainer.frame:SetScript("OnHide", function(self)
        x:HideConfigTool()
    end)
    _G["xCT_PlusConfigFrame"] = x.myContainer.frame
    table.insert(UISpecialFrames, "xCT_PlusConfigFrame")

    -- Properly dispose of this frame
    x.myContainer:SetCallback("OnClose", myContainer_OnRelease)

    -- Last minute settings and SHOW
    --x.myContainer.content:GetParent():SetMinResize(803, 300)

    -- Go through and select all the groups that are relevant to the player
    if not x.selectDefaultGroups then
        x.selectDefaultGroups = true

        -- Select the player's class, then go back to home
        ACD:SelectGroup(AddonName, "spells", "classList", x.player.class)
        ACD:SelectGroup(AddonName, "spells", "mergeOptions")
        ACD:SelectGroup(AddonName, "Frames")
    end

    -- If we get a specific path we need to be at
    if select("#", ...) > 0 then
        ACD:SelectGroup(AddonName, ...)
    end

    ACD:Open(AddonName, x.myContainer)
end

local function HideConfigTool_OnUpdate(self, e)
    x.waiterHideConfig:SetScript("OnUpdate", nil)
    x.isConfigToolOpen = false

    if x.myContainer then
        x.myContainer:Hide()
    end
end

function x:HideConfigTool(wait)
    -- If the item that is call needs the frame for another unit of time
    if wait then
        if not x.waiterHideConfig then
            x.waiterHideConfig = CreateFrame("FRAME")
        end

        x.waiterHideConfig:SetScript("OnUpdate", HideConfigTool_OnUpdate)
        return
    end

    -- This is if we don't wait
    x.isConfigToolOpen = false

    if x.myContainer then
        x.myContainer:Hide()
    end

    -- MORE!
    GameTooltip:Hide()
end
