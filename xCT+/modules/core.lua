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
 [  ©2010-2025 All Rights Reserved.    ]
 [====================================]]

-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

-- Local Handle to the Engine
local x = addon.engine

function x:CheckExistingProfile()
    local key = self.player.name .. " - " .. GetRealmName()
    return xCTSavedDB
        and xCTSavedDB.profileKeys
        and xCTSavedDB.profileKeys[key]
        and xCTSavedDB.profiles[xCTSavedDB.profileKeys[key]]
end

-- Gets called directly after the addon is fully loaded.
function x:OnInitialize()
    if xCT or ct and ct.myname and ct.myclass then
        print("|cffFF0000WARNING:|r xCT+ cannot load. Please disable xCT in order to use xCT+.")
        return
    end

    -- Clean Up Colors in the default profile
    -- TODO is this really necessary?
    self:LoadDefaultColors()

    -- Load the user configs
    self.db = LibStub("AceDB-3.0"):New("xCTSavedDB", addon.defaults)

    -- Holds cached spells, buffs, and debuffs
    x.spellCache = {
        buffs = {},
        debuffs = {},
        spells = {},
        procs = {},
        items = {},
        damage = {},
        healing = {},
    }

    x.framesByName = {}

    x.framesById = {
        [1] = "general",
        [2] = "outgoing",
        [3] = "critical",
        [4] = "damage",
        [5] = "healing",
        [6] = "power",
        [7] = "procs",
        [8] = "loot",
        --[9] = "class",    -- this is not used by redirection
        [10] = "outgoing_healing"
    }

    x.frameTitles = {
        ["general"] = "General",
        ["outgoing"] = "Outgoing Damage",
        ["critical"] = "Outgoing Criticals (Damage & Healing)",
        ["damage"] = "Incoming Damage",
        ["healing"] = "Incoming Healing",
        ["power"] = "Class Power",
        --["class"]        = "Combo",
        ["procs"] = "Special Effects (Procs)",
        ["loot"] = "Loot & Money",
        ["outgoing_healing"] = "Outgoing Healing"
    }

    x.spamMergerHeap, x.spamMergerStack = {}, {}
    for _, frameName in pairs(x.framesById) do
        x.spamMergerHeap[frameName] = {}
        x.spamMergerStack[frameName] = {}
    end
end

-- Gets called during the PLAYER_LOGIN event, when most of the data provided by the game is already present.
function x:OnEnable()
    -- A cache of infos about the player
    self.player = {
        unit = "player",
        guid = UnitGUID("player"),
        class = select(2, UnitClass("player")),
        name = UnitName("player"),
        spec = -1,
    }
    self:UpdatePlayer()

    -- Clean up the Profile
    local success = x:CompatibilityLogic(x:CheckExistingProfile())
    if not success then
        return
    end

    -- Delay updating frames until all other addons are loaded!
    self:RegisterCombatEvents()

    self:UpdateCVar()
    self:RegisterChatCommand("xct", "OpenxCTCommand")
    self:CacheColors()
    self:EnableLibSinkSupport()

    -- Register addon to the new compartment frame see https://wowpedia.fandom.com/wiki/Addon_compartment
    AddonCompartmentFrame:RegisterAddon({
        text = AddonName,
        registerForAnyClick = true,
        notCheckable = true,
        func = function()
            x:ToggleConfigTool()
        end,
    })

    x:UpdateFrames()
    x:UpdateCVar()

    self:Print("Version 4.9.0 added a new Frame: 'Outgoing Healing'. The default is set to merge with 'Outgoing Damage' but you may want to change that!")
end

-- Gets only called when your addon is manually being disabled.
function x:OnDisable()

end


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

        -- 4.3.0 Beta 4 -> Remove redundant Merge Entries from the Config
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
            local newColor, enabled = x:LookupColorByName(override)
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

-- Possibly add LibSink Support
function x:EnableLibSinkSupport()
    local LibSink = LibStub("LibSink-2.0", true)
    if not LibSink then
        -- No other addon has loaded LibSink ... so no point for us to register as a Sink.
        return
    end

    local frames = {}

    for name, title in pairs(x.frameTitles) do
        if name ~= "class" then
            frames[title] = name
        end
    end

    -- shortName, name, desc, func, scrollAreaFunc, hasSticky
    LibSink:RegisterSink(
        "xCT_Plus",
        "xCT+",
        "Created for optimal performance in the toughest fights, this rugged combat text add-on is ready to be put to the test!",

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
            x:AddMessage(location or "general", text, { r, g, b })
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

function x:LoadDefaultColors()
    -- TODO idk what this does tbh
    local function cleanColors(colorTable)
        for _, color in pairs(colorTable) do
            if color.colors then
                cleanColors(color.colors)
            else
                color.color = { color.default[1], color.default[2], color.default[3] }
            end
        end
    end

    for _, settings in pairs(addon.defaults.profile.frames) do
        if settings.colors then
            cleanColors(settings.colors)
        end
    end

    cleanColors(addon.defaults.profile.SpellColors)
end

-- Cache colors for a fast lookup
function x:CacheColors()
    self.colorNameDB = {}

    -- pre 4.9.0 format!
    for frameName, frameSettings in pairs(x.db.profile.frames) do
        if frameSettings.colors then
            for colorName, colorSettings in pairs(frameSettings.colors) do
                if colorSettings.colors then
                    for currentColorName, currentColorSettings in pairs(colorSettings.colors) do
                        -- if there is a valid color here, migrate it to the new version
                        if currentColorSettings.color and unpack(currentColorSettings.color) then
                            x.db.profile.Colors[currentColorName].enabled = currentColorSettings.enabled
                            x.db.profile.Colors[currentColorName].color = currentColorSettings.color
                            self:Print("Migrating color", currentColorName, "to new format.")
                        end
                    end
                else
                    -- if there is a valid color here, migrate it to the new version
                    if colorSettings.color and unpack(colorSettings.color) then
                        x.db.profile.Colors[colorName].enabled = colorSettings.enabled
                        x.db.profile.Colors[colorName].color = colorSettings.color
                        self:Print("Migrating color", colorName, "to new format.")
                    end
                end
            end

            -- delete it from the old format
            x.db.profile.frames[frameName].colors = nil
        end
    end

    -- new 4.9.0 format
    for colorName, colorSettings in pairs(x.db.profile.Colors) do
        -- Check for nil colors and set them to the default
        if not colorSettings.color or not unpack(colorSettings.color) then
            -- This needs to be a new table apparently
            colorSettings.color = { unpack(colorSettings.default) }
        end

        self.colorNameDB[colorName] = colorSettings
    end

    for colorName, colorSettings in pairs(x.db.profile.SpellColors) do
        colorName = tostring(colorName)

        -- Check for nil colors and set them to the default
        if not colorSettings.color or not unpack(colorSettings.color) then
            -- This needs to be a new table apparently
            colorSettings.color = { unpack(colorSettings.default) }
        end

        -- Cache this color into a quick lookup
        self.colorNameDB[colorName] = colorSettings
    end
end

function x:UpdateCVar(force)
    -- Store Localized Strings
    -- To remove: "Changed Target!"
    local XCT_CT_DEC_0, XCT_CT_DEC_1, XCT_CT_DEC_2 =
        COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2
    local XCT_CT_INC_1, XCT_CT_INC_3 = COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3

    -- Floating Combat Text: Threat Changes
    if not x.db.profile.blizzardFCT.CombatThreatChanges then
        COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2 = "", "", ""
        COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3 = "", ""
    elseif COMBAT_THREAT_DECREASE_0 == "" then
        -- only overwrite Blizzard constants if they were previously changed
        COMBAT_THREAT_DECREASE_0, COMBAT_THREAT_DECREASE_1, COMBAT_THREAT_DECREASE_2 =
            XCT_CT_DEC_0, XCT_CT_DEC_1, XCT_CT_DEC_2
        COMBAT_THREAT_INCREASE_1, COMBAT_THREAT_INCREASE_3 = XCT_CT_INC_1, XCT_CT_INC_3
    end

    if x:CVar_BypassCVars() then
        if force then
            StaticPopup_Show("XCT_PLUS_FORCE_CVAR_UPDATE")
        else
            return
        end
    end

    if x.db.profile.blizzardFCT.enableFloatingCombatText then
        SetCVar("enableFloatingCombatText", 1)
    else
        SetCVar("enableFloatingCombatText", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextAllSpellMechanics then
        SetCVar("floatingCombatTextAllSpellMechanics", 1)
    else
        SetCVar("floatingCombatTextAllSpellMechanics", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextAuras then
        SetCVar("floatingCombatTextAuras", 1)
    else
        SetCVar("floatingCombatTextAuras", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatDamage then
        SetCVar("floatingCombatTextCombatDamage", 1)
    else
        SetCVar("floatingCombatTextCombatDamage", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatDamageAllAutos then
        SetCVar("floatingCombatTextCombatDamageAllAutos", 1)
    else
        SetCVar("floatingCombatTextCombatDamageAllAutos", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatHealing then
        SetCVar("floatingCombatTextCombatHealing", 1)
    else
        SetCVar("floatingCombatTextCombatHealing", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatHealingAbsorbSelf then
        SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 1)
    else
        SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatHealingAbsorbTarget then
        SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 1)
    else
        SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatLogPeriodicSpells then
        SetCVar("floatingCombatTextCombatLogPeriodicSpells", 1)
    else
        SetCVar("floatingCombatTextCombatLogPeriodicSpells", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextCombatState then
        SetCVar("floatingCombatTextCombatState", 1)
    else
        SetCVar("floatingCombatTextCombatState", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextComboPoints then
        SetCVar("floatingCombatTextComboPoints", 1)
    else
        SetCVar("floatingCombatTextComboPoints", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextDamageReduction then
        SetCVar("floatingCombatTextDamageReduction", 1)
    else
        SetCVar("floatingCombatTextDamageReduction", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextDodgeParryMiss then
        SetCVar("floatingCombatTextDodgeParryMiss", 1)
    else
        SetCVar("floatingCombatTextDodgeParryMiss", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextEnergyGains then
        SetCVar("floatingCombatTextEnergyGains", 1)
    else
        SetCVar("floatingCombatTextEnergyGains", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextFloatMode then
        SetCVar("floatingCombatTextFloatMode", 1)
    else
        SetCVar("floatingCombatTextFloatMode", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextFriendlyHealers then
        SetCVar("floatingCombatTextFriendlyHealers", 1)
    else
        SetCVar("floatingCombatTextFriendlyHealers", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextHonorGains then
        SetCVar("floatingCombatTextHonorGains", 1)
    else
        SetCVar("floatingCombatTextHonorGains", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextLowManaHealth then
        SetCVar("floatingCombatTextLowManaHealth", 1)
    else
        SetCVar("floatingCombatTextLowManaHealth", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextPeriodicEnergyGains then
        SetCVar("floatingCombatTextPeriodicEnergyGains", 1)
    else
        SetCVar("floatingCombatTextPeriodicEnergyGains", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextPetMeleeDamage then
        SetCVar("floatingCombatTextPetMeleeDamage", 1)
    else
        SetCVar("floatingCombatTextPetMeleeDamage", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextPetSpellDamage then
        SetCVar("floatingCombatTextPetSpellDamage", 1)
    else
        SetCVar("floatingCombatTextPetSpellDamage", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextReactives then
        SetCVar("floatingCombatTextReactives", 1)
    else
        SetCVar("floatingCombatTextReactives", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextRepChanges then
        SetCVar("floatingCombatTextRepChanges", 1)
    else
        SetCVar("floatingCombatTextRepChanges", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextSpellMechanics then
        SetCVar("floatingCombatTextSpellMechanics", 1)
    else
        SetCVar("floatingCombatTextSpellMechanics", 0)
    end

    if x.db.profile.blizzardFCT.floatingCombatTextSpellMechanicsOther then
        SetCVar("floatingCombatTextSpellMechanicsOther", 1)
    else
        SetCVar("floatingCombatTextSpellMechanicsOther", 0)
    end

    SetCVar(
        "floatingCombatTextCombatDamageDirectionalOffset",
        x.db.profile.blizzardFCT.floatingCombatTextCombatDamageDirectionalOffset
    )
    SetCVar(
        "floatingCombatTextCombatDamageDirectionalScale",
        x.db.profile.blizzardFCT.floatingCombatTextCombatDamageDirectionalScale
    )
end

-- Process the slash command ('input' contains whatever follows the slash command)
function x:OpenxCTCommand(input)
    input = string.lower(input)

    if input == "lock" or input == "save" then
        if not x.configuring and input == "save" then
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

-- Load xCT+Options on demand
function x:LoadOptionsAddon()
    if not x.isOptionsAddonLoaded then
        -- Funnily enough, this works in combat!
        local loaded = C_AddOns.LoadAddOn("xCT+Options")
        if not loaded then
            self:Print("Options could not be loaded. Did you have the 'xCT+Options' folder in your Addons-folder?")
            return
        end
        x.isOptionsAddonLoaded = true
    end
end

function x:ToggleConfigTool()
    self:LoadOptionsAddon()

    xCT_Plus_Options.engine:ToggleConfigTool()
end

function x:ShowConfigTool(...)
    self:LoadOptionsAddon()

    xCT_Plus_Options.engine:ShowConfigTool(...)
end

function x:HideConfigTool(wait)
    if x.isOptionsAddonLoaded then
        xCT_Plus_Options.engine:HideConfigTool(wait)
    end
end

-- DB for the colors
-- Returns the color and if it was enabled
function x:LookupColorByName(colorName)
    if self.colorNameDB[colorName] then
        if self.colorNameDB[colorName].enabled then
            return self.colorNameDB[colorName].color or self.colorNameDB[colorName].default, true
        end
        return self.colorNameDB[colorName].default, false
    else
        return
    end
end
