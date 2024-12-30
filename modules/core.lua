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


-- Local Handle to the Engine
local x = addon.engine

-- Profile Updated, need to refresh important stuff
local function RefreshConfig()
    -- Clean up the Profile
    x:CompatibilityLogic(true)

    x:UpdateFrames()

    -- Will this fix the profile issue?
    x:GenerateSpellSchoolColors()
    x:GenerateColorOptions()

    -- Update combat text engine CVars
    x:UpdateCVar(true)

    collectgarbage()
end

local function ProfileReset()
    -- Clean up the Profile
    x:CompatibilityLogic(false)

    x:UpdateFrames()

    collectgarbage()
end

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

    -- Initialize the options
    self:InitOptionsTable()

    -- Add the profile options to my dialog config
    addon.optionsTable.args["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

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
end

-- Gets called during the PLAYER_LOGIN event, when most of the data provided by the game is already present.
function x:OnEnable()
    -- Had to pass the explicit method into here, not sure why
    self.db.RegisterCallback(self, "OnProfileChanged", RefreshConfig)
    self.db.RegisterCallback(self, "OnProfileCopied", RefreshConfig)
    self.db.RegisterCallback(self, "OnProfileReset", ProfileReset)

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
        x:UpdateCombatTextEvents(false)
        return
    end

    -- Delay updating frames until all other addons are loaded!
    self:UpdateCombatTextEvents(true)

    -- Update combat text engine CVars
    self:UpdateCVar()

    -- Register Slash Commands
    self:RegisterChatCommand("xct", "OpenxCTCommand")

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

    -- Register the Options
    ACD:SetDefaultSize(AddonName, 803, 560)
    AC:RegisterOptionsTable(AddonName, addon.optionsTable)

    self:Print("Version 4.9.0 added a new Frame: 'Outgoing Healing'. The default is set to merge with 'Outgoing Damage' but you may want to change that!")
end

-- Gets only called when your addon is manually being disabled.
function x:OnDisable()

end

-- Need to create a handle to update frames when every other addon is done.
local frameUpdate = CreateFrame("FRAME")
frameUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
frameUpdate:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    x:UpdateFrames()
    x:UpdateCVar()
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

    local frames, color = {}, {}

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

local function myContainer_OnRelease()
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
    x.myContainer.frame:SetScript(
        "OnHide",
        function()
            x:HideConfigTool()
        end
    )

    _G.xCT_PlusConfigFrame = x.myContainer.frame
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

local function HideConfigTool_OnUpdate()
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
