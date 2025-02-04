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

local AddonName, optionsAddon = ...
optionsAddon.engine = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local xo = optionsAddon.engine

-- Make the main Addon globally accessible
xCT_Plus_Options = optionsAddon

-- This allows us to create our config dialog
local AceGUI = LibStub("AceGUI-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

-- Gets called directly after the addon is fully loaded.
function xo:OnInitialize()
    if not xCT_Plus then
        self:Print("xCT not found. Please load it first.")
    end

    self.CLASS_NAMES = {
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

    -- Initialize the options
    xCT_Plus.engine:InitOptionsTable()

    -- Add the profile options to my dialog config
    optionsAddon.optionsTable.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(xCT_Plus.engine.db)

    -- Register the Options
    ACD:SetDefaultSize(AddonName, 803, 560)
    AC:RegisterOptionsTable(AddonName, optionsAddon.optionsTable)
end

-- Profile Updated, need to refresh important stuff
local function RefreshConfig()
    -- Clean up the Profile
    xCT_Plus.engine:CompatibilityLogic(true)
    xCT_Plus.engine:CacheColors()
    xCT_Plus.engine:UpdateFrames()

    -- Will this fix the profile issue?
    xo:GenerateSpellSchoolColors()
    xo:GenerateColorOptions()

    -- Update combat text engine CVars
    xCT_Plus.engine:UpdateCVar(true)

    collectgarbage()
end

local function ProfileReset()
    -- Clean up the Profile
    xCT_Plus.engine:CompatibilityLogic(false)
    xCT_Plus.engine:CacheColors()
    xCT_Plus.engine:UpdateFrames()

    collectgarbage()
end

-- Gets called during the PLAYER_LOGIN event, when most of the data provided by the game is already present.
function xo:OnEnable()
    -- Had to pass the explicit method into here, not sure why
    xCT_Plus.engine.db.RegisterCallback(self, "OnProfileChanged", RefreshConfig)
    xCT_Plus.engine.db.RegisterCallback(self, "OnProfileCopied", RefreshConfig)
    xCT_Plus.engine.db.RegisterCallback(self, "OnProfileReset", ProfileReset)

    self:RegisterEvent("PLAYER_REGEN_DISABLED", "onEnteringCombat")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "onLeavingCombat")

    self.openConfigAfterCombat = false
end

function xo:ToggleConfigTool()
    if self.isConfigToolOpen then
        xo:HideConfigTool()
    else
        xo:ShowConfigTool()
    end
end

local function myContainer_OnRelease()
    AceGUI:Release(self.optionsFrame)
    self.optionsFrame = nil

    self.isConfigToolOpen = false
end

function xo:ShowConfigTool(...)
    if self.isConfigToolOpen then
        -- Already open
        return
    end

    if InCombatLockdown() and xCT_Plus.engine.db.profile.hideConfig then
        self:Print("Will open the |cff798BDDConfiguration Tool|r after combat.")
        self.openConfigAfterCombat = true
        return
    end

    self.isConfigToolOpen = true

    if self.optionsFrame then
        self.optionsFrame:Hide()
    end

    -- Register my AddOn for Escape keypresses
    self.optionsFrame = AceGUI:Create("Frame")
    self.optionsFrame.frame:SetScript("OnHide", function()
        xo:HideConfigTool()
    end)

    _G.xCT_PlusConfigFrame = self.optionsFrame.frame
    table.insert(UISpecialFrames, "xCT_PlusConfigFrame")

    -- Properly dispose of this frame
    self.optionsFrame:SetCallback("OnClose", myContainer_OnRelease)

    -- Go through and select all the groups that are relevant to the player
    if not xo.selectDefaultGroups then
        xo.selectDefaultGroups = true

        -- Select the player's class, then go back to home
        ACD:SelectGroup(AddonName, "spells", "classList", xCT_Plus.engine.player.class)
        ACD:SelectGroup(AddonName, "spells", "mergeOptions")
        ACD:SelectGroup(AddonName, "Frames")
    end

    -- If we get a specific path we need to be at
    if select("#", ...) > 0 then
        ACD:SelectGroup(AddonName, ...)
    end

    ACD:Open(AddonName, self.optionsFrame)
end

function xo:HideConfigTool(wait)
    -- If the caller says we need to wait a bit, we'll wait!
    if wait then
        self:ScheduleTimer("HideConfigTool", 0.1)
        return
    end

    self.isConfigToolOpen = false

    if self.optionsFrame then
        self.optionsFrame:Hide()
    end

    GameTooltip:Hide()
end

function xo:onEnteringCombat()
    if xCT_Plus.engine.db.profile.hideConfig and self.isConfigToolOpen then
        self.openConfigAfterCombat = true
        xo:HideConfigTool()
    end
end

function xo:onLeavingCombat()
    if self.openConfigAfterCombat then
        xo:ShowConfigTool()
    end

    self.openConfigAfterCombat = false
end
