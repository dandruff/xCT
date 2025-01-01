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

local AddonName, optionsAddon = ...
optionsAddon.engine = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceTimer-3.0")
-- TODO AceConsole?

local x = optionsAddon.engine

-- Make the main Addon globally accessible
xCT_Plus_Options = optionsAddon

-- This allows us to create our config dialog
local AceGUI = LibStub("AceGUI-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

-- Gets called directly after the addon is fully loaded.
function x:OnInitialize()
    if not xCT_Plus then
        self:Print('xCT not found. Please load it first.')
    end

    -- Initialize the options
    xCT_Plus.engine:InitOptionsTable()

    -- Add the profile options to my dialog config
    optionsAddon.optionsTable.args["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(xCT_Plus.engine.db)

    -- Register the Options
    ACD:SetDefaultSize(AddonName, 803, 560)
    AC:RegisterOptionsTable(AddonName, optionsAddon.optionsTable)
end

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

-- Gets called during the PLAYER_LOGIN event, when most of the data provided by the game is already present.
function x:OnEnable()
    local function ProfileReset()
        -- Clean up the Profile
        xCT_Plus.engine:CompatibilityLogic(false)

        xCT_Plus.engine:UpdateFrames()

        collectgarbage()
    end

    -- Had to pass the explicit method into here, not sure why
    xCT_Plus.engine.db.RegisterCallback(self, "OnProfileChanged", RefreshConfig)
    xCT_Plus.engine.db.RegisterCallback(self, "OnProfileCopied", RefreshConfig)
    xCT_Plus.engine.db.RegisterCallback(self, "OnProfileReset", ProfileReset)

end

-- Gets only called when your addon is manually being disabled.
function x:OnDisable()

end

function x:ToggleConfigTool()
    if x.isConfigToolOpen then
        x:HideConfigTool()
    else
        x:ShowConfigTool()
    end
end

local function myContainer_OnRelease()
    AceGUI:Release(x.optionsFrame)
    x.optionsFrame = nil

    x.isConfigToolOpen = false
end

function x:ShowConfigTool(...)
    if x.isConfigToolOpen then
        -- Already open
        return
    end

    if xCT_Plus.engine.inCombat and xCT_Plus.engine.db.profile.hideConfig then
        self:Print("Will open the |cff798BDDConfiguration Tool|r after combat.")
        xCT_Plus.engine.openConfigAfterCombat = true
        return
    end

    x.isConfigToolOpen = true

    if x.optionsFrame then
        x.optionsFrame:Hide()
    end

    -- Register my AddOn for Escape keypresses
    x.optionsFrame = AceGUI:Create("Frame")
    x.optionsFrame.frame:SetScript(
        "OnHide",
        function()
            x:HideConfigTool()
        end
    )

    _G.xCT_PlusConfigFrame = x.optionsFrame.frame
    table.insert(UISpecialFrames, "xCT_PlusConfigFrame")

    -- Properly dispose of this frame
    x.optionsFrame:SetCallback("OnClose", myContainer_OnRelease)

    -- Last minute settings and SHOW
    --x.optionsFrame.content:GetParent():SetMinResize(803, 300)

    -- Go through and select all the groups that are relevant to the player
    if not x.selectDefaultGroups then
        x.selectDefaultGroups = true

        -- Select the player's class, then go back to home
        ACD:SelectGroup(AddonName, "spells", "classList", xCT_Plus.engine.player.class)
        ACD:SelectGroup(AddonName, "spells", "mergeOptions")
        ACD:SelectGroup(AddonName, "Frames")
    end

    -- If we get a specific path we need to be at
    if select("#", ...) > 0 then
        ACD:SelectGroup(AddonName, ...)
    end

    ACD:Open(AddonName, x.optionsFrame)
end

function x:HideConfigTool(wait)
    -- If the caller says we need to wait a bit, we'll wait!
    if wait then
        x:ScheduleTimer("HideConfigTool", 0.1)
        return
    end

    x.isConfigToolOpen = false

    if x.optionsFrame then
        x.optionsFrame:Hide()
    end

    -- MORE!
    GameTooltip:Hide()
end

-- Close Config when entering combat
function x:CombatStateChanged()
    if xCT_Plus.engine.db.profile.hideConfig then
        if xCT_Plus.engine.inCombat then
            if x.optionsFrame then
                if x.optionsFrame:IsShown() then
                    x.openConfigAfterCombat = true
                    x:HideConfigTool()
                end
            end
        else
            if x.openConfigAfterCombat then
                x:ShowConfigTool()
            end
            x.openConfigAfterCombat = false
        end
    end

    for framename, settings in pairs(xCT_Plus.engine.db.profile.frames) do
        if settings.enableScrollable and settings.scrollableInCombat then
            if xCT_Plus.engine.inCombat then
                xCT_Plus.engine:DisableFrameScrolling(framename)
            else
                xCT_Plus.engine:EnableFrameScrolling(framename)
            end
        end
    end
end
