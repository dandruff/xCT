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

local _, optionsAddon = ...
local x = xCT_Plus.engine

-- This allows us to create our config dialog
local AceGUI = LibStub("AceGUI-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

function x:InitOptionsTable()
    -- Create the options table for AceConfig
    optionsAddon.optionsTable = {
        -- Add a place for the user to grab
        name = "                                                      Version: " .. (C_AddOns.GetAddOnMetadata(
            "xCT+",
            "Version"
        ) or "Unknown") .. "                                                      ",
        handler = x,
        type = "group",
        args = {
            xCT_Title = {
                order = 0,
                type = "description",
                fontSize = "large",
                name = "|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n",
                width = "double",
            },

            spacer0 = {
                order = 1,
                type = "description",
                name = "|cffFFFF00Helpful Tips:|r\n\n",
                width = "half",
            },

            helpfulTip = {
                order = 2,
                type = "description",
                fontSize = "medium",
                name = "On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options.",
                width = "double",
            },

            space1 = {
                order = 10,
                type = "description",
                name = "\n",
                width = "full",
            },

            hideConfig = {
                order = 12,
                type = "toggle",
                name = "Hide Config in Combat",
                desc = "This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r",
                get = function()
                    return x.db.profile.hideConfig
                end,
                set = function(_, value)
                    x.db.profile.hideConfig = value
                    if not value then
                        StaticPopup_Show("XCT_PLUS_HIDE_IN_COMBAT")
                    end
                end,
            },
            --[==[RestoreDefaults = {
          order = 3,
          type = 'execute',
          name = "Restore Defaults",
          func = x.RestoreAllDefaults,
        },]==]
            space2 = {
                order = 20,
                type = "description",
                name = " ",
                width = "half",
            },
            space3 = {
                order = 30,
                type = "description",
                name = " ",
                width = "half",
            },
            space4 = {
                order = 30,
                type = "description",
                name = " ",
                width = "half",
            },
            ToggleTestMode = {
                order = 31,
                type = "execute",
                name = "Test",
                desc = "Allows you to preview xCT+ in order to tweak settings outside of combat.\n\nYou can also type: '|cffFF0000/xct test|r'",
                width = "half",
                func = x.ToggleTestMode,
            },
            ToggleFrames = {
                order = 32,
                type = "execute",
                name = "Move",
                desc = "Allows you to adjust the position of all the xCT+ frames on your screen.\n\nYou can also type: '|cffFF0000/xct lock|r'",
                width = "half",
                func = x.ToggleConfigMode,
            },

            hiddenObjectShhhhhh = {
                order = 9001,
                type = "description",
                name = function()
                    x:OnAddonConfigRefreshed()
                    return ""
                end,
            },
        },
    }

    -- Generic Get/Set methods
    local function get0(info)
        return x.db.profile[info[#info - 1]][info[#info]]
    end
    local function set0(info, value)
        x.db.profile[info[#info - 1]][info[#info]] = value
        x:UpdateCVar()
    end
    local function set0_update(info, value)
        x.db.profile[info[#info - 1]][info[#info]] = value
        x:UpdateFrames()
        x:UpdateCVar()
    end
    local function get0_1(info)
        return x.db.profile[info[#info - 2]][info[#info]]
    end
    local function set0_1(info, value)
        x.db.profile[info[#info - 2]][info[#info]] = value
        x:UpdateCVar()
    end
    local function getColor0_1(info)
        return unpack(x.db.profile[info[#info - 2]][info[#info]] or {})
    end
    local function setColor0_1(info, r, g, b)
        x.db.profile[info[#info - 2]][info[#info]] = { r, g, b }
    end
    local function getTextIn0(info)
        return string.gsub(x.db.profile[info[#info - 1]][info[#info]], "|", "||")
    end
    local function setTextIn0(info, value)
        x.db.profile[info[#info - 1]][info[#info]] = string.gsub(value, "||", "|")
        x:UpdateCVar()
    end
    local function get2(info)
        return x.db.profile.frames[info[#info - 2]][info[#info]]
    end
    local function set2(info, value)
        x.db.profile.frames[info[#info - 2]][info[#info]] = value
        x:UpdateCVar()
    end
    local function set2_update(info, value)
        set2(info, value)
        x:UpdateFrames(info[#info - 2])
        x:UpdateCVar()
    end
    local function getColor2(info)
        return unpack(x.db.profile.frames[info[#info - 2]][info[#info]] or {})
    end
    local function setColor2(info, r, g, b)
        x.db.profile.frames[info[#info - 2]][info[#info]] = { r, g, b }
    end
    local function setColor2_alpha(info, r, g, b, a)
        x.db.profile.frames[info[#info - 2]][info[#info]] = { r, g, b, a }
    end
    local function getTextIn2(info)
        return string.gsub(x.db.profile.frames[info[#info - 2]][info[#info]], "|", "||")
    end
    local function setTextIn2(info, value)
        x.db.profile.frames[info[#info - 2]][info[#info]] = string.gsub(value, "||", "|")
    end
    local function setNumber2(info, value)
        if tonumber(value) then
            x.db.profile[info[#info - 2]][info[#info]] = tonumber(value)
        end
    end

    -- Man this is soooo getting out of hand D:
    local function getNameFormat(info)
        return x.db.profile.frames[info[#info - 3]].names[info[#info - 1]][info[#info]]
    end
    local function setNameFormat(info, value)
        x.db.profile.frames[info[#info - 3]].names[info[#info - 1]][info[#info]] = value
    end
    local function getNameFormatColor(info)
        return unpack(x.db.profile.frames[info[#info - 3]].names[info[#info - 1]][info[#info]] or {})
    end
    local function setNameFormatColor(info, r, g, b)
        x.db.profile.frames[info[#info - 3]].names[info[#info - 1]][info[#info]] = { r, g, b }
    end
    local function getNameFormatText(info)
        return string.gsub(x.db.profile.frames[info[#info - 2]].names[info[#info]], "|", "||")
    end
    local function setNameFormatText(info, value)
        x.db.profile.frames[info[#info - 2]].names[info[#info]] = string.gsub(value, "||", "|")
    end

    local function isFrameItemDisabled(info)
        local frameName = info[#info - 2]
        if x.db.profile.frames[frameName].enabledFrame then
            return false
        end

        return x.db.profile.frames[frameName].secondaryFrame == 0
    end
    local function isFrameNotScrollable(info)
        return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info - 2]].enableScrollable
    end
    local function isFrameUseCustomFade(info)
        return not x.db.profile.frames[info[#info - 2]].enableCustomFade or isFrameItemDisabled(info)
    end
    local function isFrameFadingDisabled(info)
        return isFrameUseCustomFade(info) or not x.db.profile.frames[info[#info - 2]].enableFade
    end
    local function isFrameIconDisabled(info)
        return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info - 2]].iconsEnabled
    end
    local function isFrameIconSpacerDisabled(info)
        return x.db.profile.frames[info[#info - 2]].iconsEnabled
    end
    local function isFrameFontShadowDisabled(info)
        return isFrameItemDisabled(info) or not x.db.profile.frames[info[#info - 2]].enableFontShadow
    end
    local function isFrameCustomColorDisabled(info)
        return not x.db.profile.frames[info[#info - 2]].customColor
    end
    -- This is TEMP
    local function isFrameItemEnabled(info)
        return x.db.profile.frames[info[#info - 2]].enabledFrame
    end

    local function setSpecialCriticalOptions(info)
        x.db.profile[info[#info - 2]].mergeCriticalsWithOutgoing = false
        x.db.profile[info[#info - 2]].mergeCriticalsByThemselves = false
        x.db.profile[info[#info - 2]].mergeDontMergeCriticals = false
        x.db.profile[info[#info - 2]].mergeHideMergedCriticals = false

        x.db.profile[info[#info - 2]][info[#info]] = true
    end

    local function setFormatting(info)
        x.db.profile.spells.formatAbbreviate = false
        x.db.profile.spells.formatGroups = false

        x.db.profile.spells[info[#info]] = true
    end

    local function getDBSpells(info)
        return x.db.profile.spells[info[#info]]
    end

    -- Apply to All variables
    local miscFont, miscFontOutline, miscEnableCustomFade

    optionsAddon.optionsTable.args.spells = {
        name = "Spam Merger",
        type = "group",
        childGroups = "tab",
        order = 2,
        args = {
            explanation = {
                type = "description",
                order = 1,
                name = "Normally all damage / heal events of a spell will result in one message each.\n"
                    .. "So AE spells like Rain of Fire or Spinning Crane Kick will spam a lot of messages into the xCT frames.\n"
                    .. "If the spam merger is enabled, then the damage events in a configured interval of X seconds of each spell will be merged into one message.\n"
                    .. "|cffFF0000Drawback|r: the (merged) message will be delayed by the configured interval!!\n"
                    .. "Use an interval of 0 to disable the specific merge.",
            },

            mergeOptions = {
                name = "Merge Options",
                type = "group",
                order = 11,
                args = {
                    enableMerger = {
                        order = 2,
                        type = "toggle",
                        name = "Enable Spam Merger",
                        get = "Options_SpamMerger_EnableSpamMerger",
                        set = set0_1,
                    },
                    enableMergerDebug = {
                        order = 3,
                        type = "toggle",
                        name = "Enable Debugging",
                        desc = "Adds the spell ID to each message for this session only.",
                        get = function()
                            return x.enableMergerDebug or false
                        end,
                        set = function(_, value)
                            x.enableMergerDebug = value
                        end,
                    },

                    outgoingHeader = {
                        type = "header",
                        order = 10,
                        name = "Outgoing Damage / Healing",
                    },

                    outgoingExplanation = {
                        type = "description",
                        order = 11,
                        name = "The merge interval for a lot of spells can be set via the 'Class Spells', 'Global Spells/Items' and 'Racial Spells' tabs.",
                    },

                    mergeOutgoingDamageMissesInterval = {
                        order = 23,
                        name = "Merge-Interval Incoming Misses",
                        desc = "The interval (seconds) in which outgoing full misses, dodges and parries will be merged. Different messages will still be displayed for different types of miss. Use 0 to disable.",
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_OutgoingDamageMissesInterval",
                        set = set0_1,
                    },

                    mergeEverythingInterval = {
                        order = 12,
                        name = "Merge-Interval for other spells",
                        desc = "The interval (seconds) in which all other spells will be merged. Certain spells have other intervals, see the tabs for them. Use 0 to disable.",
                        type = "range",
                        min = 0.1,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_FallbackInterval",
                        set = set0_1,
                    },

                    incomingHeader = {
                        type = "header",
                        order = 20,
                        name = "Incoming Damage / Healing",
                    },

                    mergeIncomingHealingInterval = {
                        order = 21,
                        name = "Merge-Interval Incoming Healing",
                        desc = "The interval (seconds) in which incoming healing will be merged. All healing done by the same person will be merged together! Use 0 to disable.",
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_IncomingHealingInterval",
                        set = set0_1,
                    },

                    mergeIncomingDamageInterval = {
                        order = 22,
                        name = "Merge-Interval Incoming Damage",
                        desc = "The interval (seconds) in which incoming damage will be merged. Different messages will still be displayed for different spells. Use 0 to disable.",
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_IncomingDamageInterval",
                        set = set0_1,
                    },

                    mergeIncomingMissesInterval = {
                        order = 23,
                        name = "Merge-Interval Incoming Misses",
                        desc = "The interval (seconds) in which incoming full misses, dodges and parries will be merged. Different messages will still be displayed for different types of miss. Use 0 to disable.",
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_IncomingMissesInterval",
                        set = set0_1,
                    },

                    dispellHeader = {
                        type = "header",
                        order = 30,
                        name = "Dispells",
                    },

                    mergeDispellInterval = {
                        order = 31,
                        name = "Merge-Interval for Dispells",
                        desc = "The interval (seconds) in which dispells are merged together. Only dispells for the same aura (by name) will be merged. Use 0 to disable.",
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_DispellInterval",
                        set = set0_1,
                    },

                    petAttacksHeader = {
                        type = "header",
                        order = 40,
                        name = "Pet Attacks",
                    },

                    mergePetInterval = {
                        order = 41,
                        name = "Merge-Interval for ALL Pet Abilities",
                        desc = "The interval (seconds) in which ALL pet damage will be merged. It will use your pet's icon instead of an spell icon. Use 0 to disable.",
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_PetAttackInterval",
                        set = set0_1,
                    },

                    mergePetColor = {
                        order = 42,
                        type = "color",
                        name = "Pet Color",
                        desc = "Which color do you want the merged pet messages to be?",
                        get = getColor0_1,
                        set = setColor0_1,
                    },

                    --[[
            spacer1 = {
              type = "description",
              order = 37,
              name = "",
              width = 'full',
            },

            mergeVehicle = {
              order = 38,
              type = 'toggle',
              name = "Merge Vehicle Abilities",
              desc = "Merges all of your vehicle abilities together.",
              get = get0_1,
              set = set0_1,
            },

            mergeVehicleColor = {
              order = 39,
              type = 'color',
              name = "Vehicle Color",
              get = getColor0_1,
              set = setColor0_1,
            },
            ]]

                    criticalHitsHeader = {
                        type = "header",
                        order = 50,
                        name = "Critical Hits",
                    },

                    criticalHitsExplanation = {
                        type = "description",
                        order = 51,
                        name = "Please choose one:",
                    },

                    mergeDontMergeCriticals = {
                        order = 52,
                        type = "toggle",
                        name = "Don't Merge Critical Hits Together",
                        desc = "Crits will not get merged in the critical frame, but they will be included in the outgoing total. |cffFFFF00(Default)|r",
                        get = "Options_SpamMerger_DontMergeCriticals",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    mergeCriticalsWithOutgoing = {
                        order = 53,
                        type = "toggle",
                        name = "Merge Critical Hits with Outgoing",
                        desc = "Crits will be merged, but the total merged amount in the outgoing frame includes crits.",
                        get = "Options_SpamMerger_MergeCriticalsWithOutgoing",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    mergeCriticalsByThemselves = {
                        order = 54,
                        type = "toggle",
                        name = "Merge Critical Hits by Themselves",
                        desc = "Crits will be merged and the total merged amount in the outgoing frame |cffFF0000DOES NOT|r include crits.",
                        get = "Options_SpamMerger_MergeCriticalsByThemselves",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    mergeHideMergedCriticals = {
                        order = 55,
                        type = "toggle",
                        name = "Hide Merged Criticals",
                        desc = "Criticals that have been merged with the Outgoing frame will not be shown in the Critical frame",
                        get = "Options_SpamMerger_HideMergedCriticals",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },
                },
            },

            classList = {
                name = "Class Spells",
                type = "group",
                order = 21,
                childGroups = "select",
                args = {
                    -- TODO: Add Check all and uncheck all buttons

                    ["DEATHKNIGHT"] = { type = "group", order = 1, name = "|cffC41F3BDeath Knight|r" },
                    ["DEMONHUNTER"] = { type = "group", order = 2, name = "|cffA330C9Demon Hunter|r" },
                    ["DRUID"] = { type = "group", order = 3, name = "|cffFF7D0ADruid|r" },
                    ["EVOKER"] = { type = "group", order = 4, name = "|cff33937FEvoker|r" },
                    ["HUNTER"] = { type = "group", order = 5, name = "|cffABD473Hunter|r" },
                    ["MAGE"] = { type = "group", order = 6, name = "|cff69CCF0Mage|r" },
                    ["MONK"] = { type = "group", order = 7, name = "|cff00FF96Monk|r" },
                    ["PALADIN"] = { type = "group", order = 8, name = "|cffF58CBAPaladin|r" },
                    ["PRIEST"] = { type = "group", order = 9, name = "|cffFFFFFFPriest|r" },
                    ["ROGUE"] = { type = "group", order = 10, name = "|cffFFF569Rogue|r" },
                    ["SHAMAN"] = { type = "group", order = 11, name = "|cff0070DEShaman|r" },
                    ["WARLOCK"] = { type = "group", order = 12, name = "|cff9482C9Warlock|r" },
                    ["WARRIOR"] = { type = "group", order = 13, name = "|cffC79C6EWarrior|r" },
                },
            },

            globalList = {
                name = "Global Spells / Items",
                type = "group",
                order = 22,
                args = {},
            },

            raceList = {
                name = "Racial Spells",
                type = "group",
                order = 23,
                args = {},
            },
        },
    }

    local function IsTrackSpellsDisabled()
        return not x.db.profile.spellFilter.trackSpells
    end

    local function GetBuffHistory()
        local result = {}

        for i in pairs(x.spellCache.buffs) do
            result[i] = i
        end

        return result
    end

    local function GetDebuffHistory()
        local result = {}

        for i in pairs(x.spellCache.debuffs) do
            result[i] = i
        end

        return result
    end

    local function GetSpellHistory()
        local result = {}

        for i in pairs(x.spellCache.spells) do
            result[tostring(i)] = string.format(
                "|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s |cff798BDD(%d)|r",
                C_Spell.GetSpellTexture(i) or 0,
                16,
                16,
                 C_Spell.GetSpellName(i) or UNKNOWN,
                i
            )
        end

        return result
    end

    local function GetProcHistory()
        local result = {}

        for i in pairs(x.spellCache.procs) do
            result[i] = i
        end

        return result
    end

    local function GetItemHistory()
        local result = {}

        for i in pairs(x.spellCache.items) do
            result[i] = string.format(
                "|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s",
                C_Item.GetItemIconByID(i),
                16,
                16,
                C_Item.GetItemNameByID(i)
            )
        end

        return result
    end

    local function GetDamageIncomingHistory()
        local result = {}

        for i in pairs(x.spellCache.damage) do
            result[tostring(i)] = string.format(
                "|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s (|cff798BDD%d)",
                C_Spell.GetSpellTexture(i) or 0,
                16,
                16,
                C_Spell.GetSpellName(i) or UNKNOWN,
                i
            )
        end

        return result
    end

    local function GetHealingIncomingHistory()
        local result = {}

        for i in pairs(x.spellCache.healing) do
            result[tostring(i)] = string.format(
                "|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s (|cff798BDD%d)",
                C_Spell.GetSpellTexture(i) or 0,
                16,
                16,
                C_Spell.GetSpellName(i) or UNKNOWN,
                i
            )
        end

        return result
    end

    local function getFilteredSpells(info)
        local category = info[#info - 1]
        local result = {}

        for id in pairs(x.db.profile.spellFilter[category]) do
            local spellID = tonumber(id)
            if spellID then
                local spellName = C_Spell.GetSpellName(spellID)
                if spellName then
                    result[id] = spellName .. " (" .. spellID .. ")"
                end
            else
                result[id] = id
            end
        end

        return result
    end

    local function AddFilteredSpell(info, value)
        local category = info[#info - 1]

        x.db.profile.spellFilter[category][value] = true

        if category == "listBuffs" then
            optionsAddon.engine:UpdateAuraSpellFilter("buffs")
        elseif category == "listDebuffs" then
            optionsAddon.engine:UpdateAuraSpellFilter("debuffs")
        elseif category == "listSpells" then
            optionsAddon.engine:UpdateAuraSpellFilter("spells")
        elseif category == "listProcs" then
            optionsAddon.engine:UpdateAuraSpellFilter("procs")
        elseif category == "listItems" then
            optionsAddon.engine:UpdateAuraSpellFilter("items")
        elseif category == "listDamage" then
            optionsAddon.engine:UpdateAuraSpellFilter("damage")
        elseif category == "listHealing" then
            optionsAddon.engine:UpdateAuraSpellFilter("healing")
        else
            x:Print("|cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
        end
    end

    local function removeFilteredSpell(info, value)
        local category = info[#info - 1]

        x.db.profile.spellFilter[category][value] = nil

        if category == "listBuffs" then
            optionsAddon.engine:UpdateAuraSpellFilter("buffs")
        elseif category == "listDebuffs" then
            optionsAddon.engine:UpdateAuraSpellFilter("debuffs")
        elseif category == "listSpells" then
            optionsAddon.engine:UpdateAuraSpellFilter("spells")
        elseif category == "listProcs" then
            optionsAddon.engine:UpdateAuraSpellFilter("procs")
        elseif category == "listItems" then
            optionsAddon.engine:UpdateAuraSpellFilter("items")
        elseif category == "listDamage" then
            optionsAddon.engine:UpdateAuraSpellFilter("damage")
        elseif category == "listHealing" then
            optionsAddon.engine:UpdateAuraSpellFilter("healing")
        else
            x:Print("|cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
        end
    end

    optionsAddon.optionsTable.args.spellFilter = {
        name = "Filters",
        type = "group",
        order = 3,
        args = {
            filterValues = {
                name = "Minimal Value Thresholds",
                type = "group",
                order = 10,
                guiInline = true,
                args = {
                    headerPlayerPower = {
                        order = 0,
                        type = "header",
                        name = "Incoming Player Power Threshold (Mana, Rage, Energy, etc.)",
                    },
                    filterPowerValue = {
                        order = 1,
                        type = "input",
                        name = "Minimum Threshold",
                        desc = "The minimal amount of player's power required in order for it to be displayed.",
                        get = "Options_Filter_PlayerPowerMinimumThreshold",
                        set = setNumber2,
                    },

                    headerOutgoingDamage = {
                        order = 10,
                        type = "header",
                        name = "Outgoing Damage",
                    },
                    filterOutgoingDamageValue = {
                        order = 11,
                        type = "input",
                        name = "Minimum Threshold",
                        desc = "The minimal amount of damage required in order for it to be displayed.",
                        get = "Options_Filter_OutgoingDamage_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterOutgoingDamageCritEnabled = {
                        order = 12,
                        type = "toggle",
                        name = "Use other threshold for Crits",
                        desc = "Enable a different threshold for outgoing damage criticals.",
                        get = "Options_Filter_OutgoingDamage_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterOutgoingDamageCritValue = {
                        order = 13,
                        type = "input",
                        name = "Minimum Threshold for Crits",
                        desc = "The minimal amount of damage required for a critical in order for it to be displayed.",
                        get = "Options_Filter_OutgoingDamage_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_OutgoingDamage_Critical_UseOwnThreshold()
                        end,
                    },

                    headerOutgoingHealing = {
                        order = 20,
                        type = "header",
                        name = "Outgoing Healing",
                    },
                    filterOutgoingHealingValue = {
                        order = 21,
                        type = "input",
                        name = "Minimum Threshold",
                        desc = "The minimal amount of healing required in order for it to be displayed.",
                        get = "Options_Filter_OutgoingHealing_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterOutgoingHealingCritEnabled = {
                        order = 22,
                        type = "toggle",
                        name = "Use other threshold for Crits",
                        desc = "Enable a different threshold for outgoing healing criticals.",
                        get = "Options_Filter_OutgoingHealing_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterOutgoingHealingCritValue = {
                        order = 23,
                        type = "input",
                        name = "Minimum Threshold for Crits",
                        desc = "The minimal amount of healing required for a critical in order for it to be displayed.",
                        get = "Options_Filter_OutgoingHealing_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_OutgoingHealing_Critical_UseOwnThreshold()
                        end,
                    },

                    headerIncomingDamage = {
                        order = 30,
                        type = "header",
                        name = "Incoming Damage",
                    },
                    filterIncomingDamageValue = {
                        order = 31,
                        type = "input",
                        name = "Minimum Threshold",
                        desc = "The minimal amount of damage required in order for it to be displayed.",
                        get = "Options_Filter_IncomingDamage_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterIncomingDamageCritEnabled = {
                        order = 32,
                        type = "toggle",
                        name = "Use other threshold for Crits",
                        desc = "Enable a different threshold for incoming damage criticals.",
                        get = "Options_Filter_IncomingDamage_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterIncomingDamageCritValue = {
                        order = 33,
                        type = "input",
                        name = "Minimum Threshold for Crits",
                        desc = "The minimal amount of damage required for a critical in order for it to be displayed.",
                        get = "Options_Filter_IncomingDamage_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_IncomingDamage_Critical_UseOwnThreshold()
                        end,
                    },

                    headerIncomingHealing = {
                        order = 40,
                        type = "header",
                        name = "Incoming Healing",
                    },
                    filterIncomingHealingValue = {
                        order = 41,
                        type = "input",
                        name = "Minimum Threshold",
                        desc = "The minimal amount of healing required in order for it to be displayed.",
                        get = "Options_Filter_IncomingHealing_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterIncomingHealingCritEnabled = {
                        order = 42,
                        type = "toggle",
                        name = "Use other threshold for Crits",
                        desc = "Enable a different threshold for incoming healing criticals.",
                        get = "Options_Filter_IncomingHealing_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterIncomingHealingCritValue = {
                        order = 43,
                        type = "input",
                        name = "Minimum Threshold for Crits",
                        desc = "The minimal amount of healing required for a critical in order for it to be displayed.",
                        get = "Options_Filter_IncomingHealing_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_IncomingHealing_Critical_UseOwnThreshold()
                        end,
                    },

                    headerSpellTracker = {
                        order = 50,
                        type = "header",
                        name = "Spell History",
                    },
                    trackSpells = {
                        order = 51,
                        type = "toggle",
                        name = "Track all Spells",
                        desc = "Track all the spells that you've seen. This will make filtering them out easier.",
                        get = "Options_Filter_TrackSpells",
                        set = set0_1,
                    },
                },
            },

            listBuffs = {
                name = "|cffFFFFFFFilter:|r |cff798BDDBuffs|r",
                type = "group",
                order = 20,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter out |cff1AFF1ABuff|r auras that your player gains or loses.",
                    },
                    whitelistBuffs = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Filtered auras gains and fades that are |cff1AFF1ABuffs|r will be on a whitelist (opposed to a blacklist).",
                        get = "Options_Filter_BuffWhitelist",
                        set = set0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Buff to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via Name",
                        desc = "The full, case-sensitive name of the |cff1AFF1ABuff|r you want to filter (e.g. 'Power Word: Fortitude').",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff1AFF1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetBuffHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Buff from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered Buff",
                        desc = "Remove the Buff from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listDebuffs = {
                name = "|cffFFFFFFFilter:|r |cff798BDDDebuffs|r",
                type = "group",
                order = 30,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter out |cffFF1A1ADebuff|r auras that your player gains or loses.",
                    },
                    whitelistDebuffs = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Filtered auras gains and fades that are |cffFF1A1ADebuffs|r will be on a whitelist (opposed to a blacklist).",
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Debuff to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via Name",
                        desc = "The full, case-sensitive name of the |cff1AFF1ABuff|r you want to filter (e.g. 'Shadow Word: Pain').",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff1AFF1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetDebuffHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Debuff from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered Debuff",
                        desc = "Remove the Debuff from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listProcs = {
                name = "|cffFFFFFFFilter:|r |cff798BDDProcs|r",
                type = "group",
                order = 40,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter out spell |cffFFFF00Procs|r that your player triggers.",
                    },
                    whitelistProcs = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Check for whitelist, uncheck for blacklist.",
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Proc to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via Name",
                        desc = "The full, case-sensitive name of the |cff1AFF1AProc|r you want to filter (e.g. 'Power Word: Fortitude').",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff1AFF1AProcs|r that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetProcHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Proc from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered proc",
                        desc = "Remove the proc from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listSpells = {
                name = "|cffFFFFFFFilter:|r |cff798BDDOutgoing Spells|r",
                type = "group",
                order = 50,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter |cff71d5ffOutgoing Spells|r that your player does.",
                    },
                    whitelistSpells = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Filtered |cff71d5ffOutgoing Spells|r will be on a whitelist (opposed to a blacklist).",
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Spell to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via ID",
                        desc = "The spell ID of the |cff71d5ffOutgoing Spell|r you want to filter.",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff71d5ffOutgoing Spell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetSpellHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Spell from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered spell",
                        desc = "Remove the spell ID from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listItems = {
                name = "|cffFFFFFFFilter:|r |cff798BDDItems|r",
                type = "group",
                order = 60,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter out |cff8020FFItems|r that your player collects.",
                    },
                    whitelistItems = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Filtered |cff798BDDItems|r will be on a whitelist (opposed to a blacklist).",
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Item to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via ID",
                        desc = "The ID of the |cff798BDDItem|r you want to filter.",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff798BDDItem|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetItemHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Item from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered Item",
                        desc = "Remove the Item from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listDamage = {
                name = "|cffFFFFFFFilter:|r |cff798BDDIncoming Damage|r",
                type = "group",
                order = 70,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter out certain |cffFFFF00Spell ID|rs from |cff798BDDIncoming Damage|r to your character.",
                    },
                    whitelistDamage = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Filtered |cff71d5ffIncoming Damage Spells|r will be on a whitelist (opposed to a blacklist).",
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Spells to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via ID",
                        desc = "The Spell ID of the |cff798BDDSpell|r you want to filter.",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff798BDDSpell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetDamageIncomingHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Spell from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered spell",
                        desc = "Remove the spell ID from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listHealing = {
                name = "|cffFFFFFFFilter:|r |cff798BDDIncoming Healing|r",
                type = "group",
                order = 80,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = "These options allow you to filter out certain |cffFFFF00Spell ID|rs from |cff798BDDIncoming Healing|r to your character.",
                    },
                    whitelistHealing = {
                        order = 1,
                        type = "toggle",
                        name = "Whitelist",
                        desc = "Filtered |cff71d5ffIncoming Healing Spells|r will be on a whitelist (opposed to a blacklist).",
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = "Add new Spell to filter",
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = "Add via ID",
                        desc = "The Spell ID of the |cff798BDDSpell|r you want to filter.",
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = "Add via History",
                        desc = "A list of |cff798BDDSpell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r",
                        disabled = IsTrackSpellsDisabled,
                        values = GetHealingIncomingHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = "Remove Spell from filter",
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = "Remove filtered spell",
                        desc = "Remove the spell ID from the config all together.",
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },
        },
    }

    optionsAddon.optionsTable.args.Credits = {
        name = "Credits",
        type = "group",
        order = 6,
        args = {
            title = {
                type = "header",
                order = 0,
                name = "Credits",
            },
            specialThanksTitle = {
                type = "description",
                order = 1,
                name = "|cffFFFF00Special Thanks|r",
                fontSize = "large",
            },
            specialThanksList = {
                type = "description",
                order = 2,
                fontSize = "medium",
                name = "  |cffAA0000Tukz|r, |cffAA0000Elv|r, |cffFFFF00Affli|r, |cffFF8000BuG|r, |cff8080FFShestak|r, |cffAAAAFFToludin|r, Nidra, gnangnan, NitZo, Naughtia, Derap, sortokk, ckaotik, Cecile.",
            },
            testerTitleSpace1 = {
                type = "description",
                order = 3,
                name = " ",
            },

            testerTitle = {
                type = "description",
                order = 10,
                name = "|cffFFFF00Beta Testers - Version 3.0.0|r",
                fontSize = "large",
            },
            userName1 = {
                type = "description",
                order = 11,
                fontSize = "medium",
                name = " |cffAAAAFF Alex|r,|cff8080EE BuG|r,|cffAAAAFF Kkthnxbye|r,|cff8080EE Azilroka|r,|cffAAAAFF Prizma|r,|cff8080EE schmeebs|r,|cffAAAAFF Pat|r,|cff8080EE hgwells|r,|cffAAAAFF Jaron|r,|cff8080EE Fitzbattleaxe|r,|cffAAAAFF Nihan|r,|cff8080EE Jaxo|r,|cffAAAAFF Schaduw|r,|cff8080EE sylenced|r,|cffAAAAFF kaleidoscope|r,|cff8080EE Killatones|r,|cffAAAAFF Trokko|r,|cff8080EE Yperia|r,|cffAAAAFF Edoc|r,|cff8080EE Cazart|r,|cffAAAAFF Nevah|r,|cff8080EE Refrakt|r,|cffAAAAFF Thakah|r,|cff8080EE johnis007|r,|cffAAAAFF Sgt|r,|cff8080EE NitZo|r,|cffAAAAFF cptblackgb|r,|cff8080EE pollyzoid|r.",
            },

            testerTitleSpace2 = {
                type = "description",
                order = 20,
                name = " ",
            },
            curseTitle = {
                type = "description",
                order = 21,
                name = "|cffFFFF00Beta Testers - Version 4.0.0 (Curse)|r",
                fontSize = "large",
            },
            userName2 = {
                type = "description",
                order = 22,
                fontSize = "medium",
                name = " |cffAAAAFF CadjieBOOM|r,|cff8080EE Mokal|r,|cffAAAAFF ShadoFall|r,|cff8080EE alloman|r,|cffAAAAFF chhld|r,|cff8080EE chizzlestick|r,|cffAAAAFF egreym|r,|cff8080EE nukme|r,|cffAAAAFF razrwolf|r,|cff8080EE star182|r,|cffAAAAFF zacheklund|r",
            },

            testerTitleSpace3 = {
                type = "description",
                order = 30,
                name = " ",
            },
            tukuiTitle = {
                type = "description",
                order = 31,
                name = "|cffFFFF00Beta Testers - Version 4.0.0 (Tukui)|r",
                fontSize = "large",
            },
            userName3 = {
                type = "description",
                order = 32,
                fontSize = "medium",
                name = " |cffAAAAFF Affiniti|r,|cff8080EE Badinfluence|r,|cffAAAAFF Badinfluence|r,|cff8080EE BuG|r,|cffAAAAFF Curdi|r,|cff8080EE Dorkie|r,|cffAAAAFF Galadeon|r,|cff8080EE HarryDotter|r,|cffAAAAFF Joebacsi21|r,|cff8080EE Kuron|r,|cffAAAAFF Mabb22|r,|cff8080EE Narlya|r,|cffAAAAFF Nihan|r,|cff8080EE Verdell|r,|cffAAAAFF arzelia|r,|cff8080EE blessed|r,|cffAAAAFF djouga|r,|cff8080EE fakemessiah|r,|cffAAAAFF faze|r,|cff8080EE firewall|r,|cffAAAAFF jatha86|r,|cff8080EE jaydogg10|r,|cffAAAAFF jlor|r,|cff8080EE lunariongames|r,|cffAAAAFF stoankold|r",
            },

            testerTitleSpace3Legion = {
                type = "description",
                order = 33,
                name = " ",
            },
            tukuiTitleLegion = {
                type = "description",
                order = 34,
                name = "|cffFFFF00Beta Testers - Version 4.3.0+ (Legion)|r",
                fontSize = "large",
            },
            userName3Legion = {
                type = "description",
                order = 35,
                fontSize = "medium",
                name = " |cffAAAAFF Azazu|r,|cff8080EE Broni|r,|cffAAAAFF CursedBunny|r,|cff8080EE Daemios|r,|cffAAAAFF Dajova|r,|cff8080EE Delerionn|r,|cffAAAAFF dunger|r,|cff8080EE feetss|r,|cffAAAAFF gesuntight|r,|cff8080EE Homaxz|r,|cffAAAAFF karamei|r,|cff8080EE Merathilis|r,|cffAAAAFF re1jo|r,|cff8080EE sammael666|r,|cffAAAAFF scathee|r,|cff8080EE Tonyleila|r,|cffAAAAFF Torch|r,|cff8080EE WetU|r,|cffAAAAFF Znuff|r,|cff8080EE Zylos|r\n",
            },

            testerTitleSpace3BFA = {
                type = "description",
                order = 36,
                name = " ",
            },
            tukuiTitleBfA = {
                type = "description",
                order = 37,
                name = "|cffFFFF00Beta Testers - Version 4.4.0+ (Battle for Azeroth)|r",
                fontSize = "large",
            },

            userName3BfA = {
                type = "description",
                order = 38,
                fontSize = "medium",
                name = " |cffAAAAFF Toludin|r",
            },

            testerTitleSpace_SL = {
                type = "description",
                order = 40,
                name = " ",
            },
            githubTitleSL = {
                type = "description",
                order = 41,
                name = "|cffFFFF00Github Contributors|r",
                fontSize = "large",
            },
            userNameSL = {
                type = "description",
                order = 42,
                fontSize = "medium",
                name = " |cff1AAD59 RedAces|r,|cff22FF80 oBusk|r,|cff1AAD59 BourgeoisM|r,|cff22FF80 Witnesscm|r",
            },

            testerTitleSpace4 = {
                type = "description",
                order = 45,
                name = " ",
            },

            githubTitle = {
                type = "description",
                order = 46,
                name = "|cffFFFF00Thank You Github Contributors!|r",
                fontSize = "large",
            },
            userName4 = {
                type = "description",
                order = 47,
                fontSize = "medium",
                name = " |cff22FF80 Tonyleila|r,|cff1AAD59 ckaotik|r,|cff22FF80 Stanzilla|r,|cff1AAD59 Torch (behub)|r,|cff22FF80 vforge|r,|cff1AAD59 Toludin (BfA Update!)|r",
            },

            testerTitleSpace5 = {
                type = "description",
                order = 50,
                name = " ",
            },

            contactTitle = {
                type = "description",
                order = 51,
                name = "|cffFFFF00Contact Me|r",
                fontSize = "large",
            },

            contactStep1 = {
                type = "description",
                order = 52,
                name = "1. GitHub: |cff22FF80https://github.com/dandruff/xCT|r\n\n2. Send a PM to |cffFF8000Dandruff|r at |cff6495EDhttp://tukui.org/|r",
            },
        },
    }

    optionsAddon.optionsTable.args.FloatingCombatText = {
        name = "Floating Combat Text",
        type = "group",
        order = 1,
        childGroups = "tab",
        args = {
            title2 = {
                order = 0,
                type = "description",
                name = "The following settings allow you to tweak Blizzard's Floating Combat Text.",
            },

            blizzardFCT = {
                name = "General",
                type = "group",
                order = 1,
                disabled = "CVar_BypassCVars",
                args = {
                    enableFloatingCombatText = {
                        order = 1,
                        name = "Enable Scrolling Combat Text (Self)",
                        type = "toggle",
                        desc = "Shows incoming damage and healing done to you. It is also required for a lot of the other events to work (as noted in their descriptions).\n\n|cffFF0000Changing this requires a UI Reload!|r",
                        width = "double",
                        get = get0,
                        set = set0_update,
                    },

                    enableFCT_Header = {
                        type = "description",
                        order = 2,
                        name = "|CffFF0000Requires:|r |cff00FF33/reload|r after change",
                        fontSize = "small",
                        width = "normal",
                    },

                    enableFCT_Spacer = {
                        type = "description",
                        order = 3,
                        name = "\n",
                        fontSize = "small",
                        width = "normal",
                    },

                    headerAppearance = {
                        type = "header",
                        order = 4,
                        name = "Appearance",
                    },

                    floatingCombatTextCombatDamageDirectionalOffset = {
                        order = 5,
                        name = "Direction Offset",
                        desc = "The amount to offset the vertical origin of the directional damage numbers when they appear. (e.g. move them up and down)\n\n0 = Default",
                        type = "range",
                        min = -20,
                        max = 20,
                        step = 0.1,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatDamageDirectionalScale = {
                        order = 6,
                        name = "Direction Scale",
                        desc = "The amount to scale the distance that directional damage numbers will move as they appear. Damage numbers will just scroll up if this is disabled.\n\n0 = Disabled\n1 = Default\n3.6 = Recommended",
                        type = "range",
                        min = -5,
                        max = 5,
                        step = 0.1,
                        get = get0,
                        set = set0_update,
                    },

                    -- Damage
                    headerDamage = {
                        type = "header",
                        order = 10,
                        name = "Damage",
                    },

                    floatingCombatTextCombatDamage = {
                        order = 11,
                        name = "Show Damage",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_DAMAGE,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatLogPeriodicSpells = {
                        order = 12,
                        name = "Show DoTs",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatDamageAllAutos = {
                        order = 13,
                        name = "Show Auto Attacks",
                        type = "toggle",
                        desc = "Enable this option if you want to see all auto-attacks.",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextPetMeleeDamage = {
                        order = 14,
                        name = "Show Pet Melee",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextPetSpellDamage = {
                        order = 15,
                        name = "Show Pet Spells",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
                        get = get0,
                        set = set0_update,
                    },

                    -- Healing and Absorbs
                    headerHealingAbsorbs = {
                        type = "header",
                        order = 20,
                        name = "Healing and Absorbs",
                    },

                    floatingCombatTextCombatHealing = {
                        order = 21,
                        name = "Show Healing",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextFriendlyHealers = {
                        order = 22,
                        name = "Show Friendly Healers",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_FRIENDLY_NAMES
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatHealingAbsorbSelf = {
                        order = 23,
                        name = "Show Absorbs (Self)",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_SELF
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatHealingAbsorbTarget = {
                        order = 24,
                        name = "Show Absorbs (Target)",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextDamageReduction = {
                        order = 25,
                        name = "Show Damage Reduction",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_RESISTANCES
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    -- Gains
                    headerGains = {
                        type = "header",
                        order = 30,
                        name = "Player Gains",
                    },

                    floatingCombatTextEnergyGains = {
                        order = 31,
                        name = "Show Energy",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_ENERGIZE
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextPeriodicEnergyGains = {
                        order = 31,
                        name = "Show Energy (Periodic)",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextComboPoints = {
                        order = 32,
                        name = "Show Combo Points",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBO_POINTS
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextHonorGains = {
                        order = 33,
                        name = "Show Honor",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_HONOR_GAINED
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextRepChanges = {
                        order = 34,
                        name = "Show Rep Changes",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REPUTATION
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    -- Status Effects
                    headerStatusEffects = {
                        type = "header",
                        order = 40,
                        name = "Status Effects",
                    },

                    floatingCombatTextDodgeParryMiss = {
                        order = 41,
                        name = "Show Miss Types",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_DODGE_PARRY_MISS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextAuras = {
                        order = 42,
                        name = "Show Auras",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_AURAS
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextSpellMechanics = {
                        order = 43,
                        name = "Show Effects (Mine)",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_TARGET_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextSpellMechanicsOther = {
                        order = 44,
                        name = "Show Effects (Group)",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextAllSpellMechanics = {
                        order = 45,
                        name = "Show Effects (All)",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    CombatThreatChanges = {
                        order = 46,
                        type = "toggle",
                        name = "Show Threat Changes",
                        desc = "Enable this option if you want to see threat changes.",
                        get = get0,
                        set = set0_update,
                    },

                    -- Player's Status
                    headerPlayerStatus = {
                        type = "header",
                        order = 50,
                        name = "Player Status",
                    },

                    floatingCombatTextCombatState = {
                        order = 52,
                        name = "Show Combat State",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextLowManaHealth = {
                        order = 53,
                        name = "Show Low HP/Mana",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_LOW_HEALTH_MANA
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextReactives = {
                        order = 54,
                        name = "Show Reactives",
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REACTIVES
                            .. "\n\n|cffFF0000Requires Self Scrolling Combat Text|r",
                        get = get0,
                        set = set0_update,
                    },
                },
            },

            advancedSettings = {
                name = "Advanced",
                type = "group",
                order = 2,
                args = {
                    bypassCVARUpdates = {
                        order = 4,
                        type = "toggle",
                        name = "Bypass CVar Updates (requires |cffFF0000/reload|r)",
                        desc = "Allows you to bypass xCT+'s CVar engine. This option might help if you have FCT enabled, but it disappears after awhile. Once you set your FCT options, enable this.\n\n|cffFF0000Changing this requires a UI Reload!|r",
                        width = "double",
                        get = function()
                            return x.db.profile.bypassCVars
                        end,
                        set = function(_, value)
                            x.db.profile.bypassCVars = value
                        end,
                    },

                    enableFCT_Header = {
                        type = "description",
                        order = 5,
                        name = "|CffFF0000Requires:|r |cff00FF33/reload|r after change",
                        fontSize = "small",
                        width = "normal",
                    },
                },
            },
        },
    }

    optionsAddon.optionsTable.args.SpellSchools = {
        name = "Spell School Colors",
        type = "group",
        order = 5,
        args = {
            title = {
                type = "description",
                order = 0,
                name = "|cff798BDDCustomize Spell School Colors|r:\n",
                fontSize = "large",
            },
        },
    }

    optionsAddon.optionsTable.args.Frames = {
        name = "Frames",
        type = "group",
        order = 0,
        args = {
            frameSettings = {
                order = 1,
                name = "Frame Settings ",
                type = "group",
                guiInline = true,
                args = {
                    frameStrata = {
                        order = 1,
                        type = "select",
                        name = "Frame Strata",
                        desc = "The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata.",
                        values = {
                            --["1PARENT"]             = "Parent |cffFF0000(Lowest)|r",
                            ["2BACKGROUND"] = "Background |cffFF0000(Lowest)|r",
                            ["3LOW"] = "Low",
                            ["4MEDIUM"] = "Medium",
                            ["5HIGH"] = "High |cffFFFF00(Default)|r",
                            ["6DIALOG"] = "Dialog",
                            ["7FULLSCREEN"] = "Fullscreen",
                            ["8FULLSCREEN_DIALOG"] = "Fullscreen Dialog",
                            ["9TOOLTIP"] = "ToolTip |cffAAFF80(Highest)|r",
                        },
                        get = get0,
                        set = set0_update,
                    },
                    clearLeavingCombat = {
                        order = 2,
                        type = "toggle",
                        name = "Clear Frames when leaving combat",
                        desc = "Enable this option if you have problems with 'floating' icons.",
                        width = "full",
                        get = get0,
                        set = set0,
                    },

                    whenMovingFrames = {
                        order = 10,
                        type = "header",
                        name = "When moving the Frames",
                    },
                    showGrid = {
                        order = 11,
                        type = "toggle",
                        name = "Show Align Grid",
                        desc = "Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better.",
                        get = get0,
                        set = set0,
                    },
                    showPositions = {
                        order = 12,
                        type = "toggle",
                        name = "Show Positions",
                        desc = "Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better.",
                        get = get0,
                        set = set0,
                    },
                },
            },

            spacer1 = {
                type = "description",
                name = "\n",
                order = 2,
            },

            megaDamage = {
                name = "Number Format Settings",
                type = "group",
                order = 3,
                guiInline = true,
                args = {
                    formatNumberHeader = {
                        order = 0,
                        type = "header",
                        name = "Format Numbers in the Frames (Choose one)",
                    },
                    abbreviateExplanation = {
                        order = 1,
                        type = "description",
                        name = "|cffFFFF00PLEASE NOTE|r |cffAAAAAAFormat settings need to be independently enabled on each frame through its respective settings page.|r\n",
                        fontSize = "small",
                    },
                    formatAbbreviate = {
                        order = 2,
                        type = "toggle",
                        name = "Abbreviate Numbers",
                        set = setFormatting,
                        get = getDBSpells,
                    },
                    formatGroups = {
                        order = 3,
                        type = "toggle",
                        name = "Decimal Marks",
                        desc = "Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r",
                        set = setFormatting,
                        get = getDBSpells,
                    },
                    decimalPoint = {
                        order = 4,
                        type = "toggle",
                        name = "Single Decimal Precision",
                        desc = "Shows a single digit of precision when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r).",
                        get = get0,
                        set = set0,
                    },

                    thousandSymbol = {
                        order = 5,
                        type = "input",
                        name = "Thousand Symbol",
                        desc = "Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r",
                        get = getTextIn0,
                        set = setTextIn0,
                    },
                    millionSymbol = {
                        order = 6,
                        type = "input",
                        name = "Million Symbol",
                        desc = "Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r",
                        get = getTextIn0,
                        set = setTextIn0,
                    },
                    billionSymbol = {
                        order = 7,
                        type = "input",
                        name = "Billion Symbol",
                        desc = "Symbol for: |cffFF0000Billions|r |cff798BDD(10e+9)|r",
                        get = getTextIn0,
                        set = setTextIn0,
                    },
                },
            },

            spacer2 = {
                type = "description",
                name = "\n",
                order = 4,
            },

            miscFonts = {
                order = 5,
                type = "group",
                guiInline = true,
                name = "Global Frame Settings |cffFFFFFF(Experimental)|r",
                args = {
                    miscDesc = {
                        order = 51,
                        type = "description",
                        name = "The following settings are marked as experimental. They should all work, but they might not be very useful. Expect chanrges or updates to these in the near future.\n\nClick |cffFFFF00Set All|r to apply setting to all |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames.\n",
                    },
                    font = {
                        order = 52,
                        type = "select",
                        dialogControl = "LSM30_Font",
                        name = "Font",
                        desc = "Set the font of the frame.",
                        values = AceGUIWidgetLSMlists.font,
                        get = function()
                            return miscFont
                        end,
                        set = function(_, value)
                            miscFont = value
                        end,
                    },
                    applyFont = {
                        order = 53,
                        type = "execute",
                        name = "Set All",
                        width = "half",
                        func = function()
                            if miscFont then
                                for _, settings in pairs(x.db.profile.frames) do
                                    settings.font = miscFont
                                end
                                x:UpdateFrames()
                            end
                        end,
                    },

                    spacer1 = {
                        order = 54,
                        type = "description",
                        name = "",
                    },

                    fontOutline = {
                        order = 55,
                        type = "select",
                        name = "Font Outline",
                        desc = "Set the font outline.",
                        values = {
                            ["1NONE"] = "None",
                            ["2OUTLINE"] = "OUTLINE",
                            -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                            -- http://us.battle.net/wow/en/forum/topic/6470967362
                            ["3MONOCHROME"] = "MONOCHROME",
                            ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                            ["5THICKOUTLINE"] = "THICKOUTLINE",
                        },
                        get = function()
                            return miscFontOutline
                        end,
                        set = function(_, value)
                            miscFontOutline = value
                        end,
                    },

                    applyFontOutline = {
                        order = 56,
                        type = "execute",
                        name = "Set All",
                        width = "half",
                        func = function()
                            if miscFontOutline then
                                for _, settings in pairs(x.db.profile.frames) do
                                    settings.fontOutline = miscFontOutline
                                end
                                x:UpdateFrames()
                            end
                        end,
                    },

                    spacer2 = {
                        order = 57,
                        type = "description",
                        name = "",
                    },

                    customFade = {
                        order = 58,
                        type = "toggle",
                        name = "Use Custom Fade",
                        desc = "Allows you to customize the fade time of each frame.",
                        get = function()
                            return miscEnableCustomFade
                        end,
                        set = function(_, value)
                            miscEnableCustomFade = value
                        end,
                    },

                    applyCustomFade = {
                        order = 59,
                        type = "execute",
                        name = "Set All",
                        width = "half",
                        func = function()
                            if miscEnableCustomFade ~= nil then
                                for _, settings in pairs(x.db.profile.frames) do
                                    if settings.enableCustomFade ~= nil then
                                        settings.enableCustomFade = miscEnableCustomFade
                                    end
                                end
                                x:UpdateFrames()
                            end
                        end,
                    },
                },
            },

            --[[ XCT+ The Frames: ]]
            general = {
                name = "|cffFFFFFFGeneral|r",
                type = "group",
                order = 11,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    --[1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 24,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    specialTweaks = {
                        order = 50,
                        name = "Misc",
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = "Miscellaneous Settings",
                            },
                            showInterrupts = {
                                order = 1,
                                type = "toggle",
                                name = "Interrupts",
                                desc = "Display the spell you successfully interrupted.",
                                get = "Options_General_ShowInterrupts",
                                set = set2,
                            },
                            showDispells = {
                                order = 2,
                                type = "toggle",
                                name = "Dispell/Steal",
                                desc = "Show the spell that you dispelled or stole.",
                                get = "Options_General_ShowDispells",
                                set = set2,
                            },
                            showPartyKills = {
                                order = 3,
                                type = "toggle",
                                name = "Unit Killed",
                                desc = "Display unit that was killed by your final blow.",
                                get = "Options_General_ShowPartyKill",
                                set = set2,
                            },
                            showBuffs = {
                                order = 4,
                                type = "toggle",
                                name = "Buff Gains/Fades",
                                desc = "Display the names of helpful auras |cff00FF00(Buffs)|r that you gain and lose.",
                                get = "Options_General_ShowBuffGainsAndFades",
                                set = set2,
                            },
                            showDebuffs = {
                                order = 5,
                                type = "toggle",
                                name = "Debuff Gains/Fades",
                                desc = "Display the names of harmful auras |cffFF0000(Debuffs)|r that you gain and lose.",
                                get = "Options_General_ShowDebuffGainsAndFades",
                                set = set2,
                            },
                            showLowManaHealth = {
                                order = 6,
                                type = "toggle",
                                name = "Low Mana/Health",
                                desc = "Displays 'Low Health/Mana' when your health/mana reaches the low threshold.",
                                get = "Options_General_ShowLowManaAndHealth",
                                set = set2,
                            },
                            showCombatState = {
                                order = 7,
                                type = "toggle",
                                name = "Leave/Enter Combat",
                                desc = "Displays when the player is leaving or entering combat.",
                                get = "Options_General_ShowCombatState",
                                set = set2,
                            },
                            showRepChanges = {
                                order = 8,
                                type = "toggle",
                                name = "Show Reputation",
                                desc = "Displays your player's reputation gains and losses.",
                                get = "Options_General_ShowReputationChanges",
                                set = set2,
                            },
                            showHonorGains = {
                                order = 9,
                                type = "toggle",
                                name = "Show Honor",
                                desc = "Displays your player's honor gains.",
                                get = "Options_General_ShowHonor",
                                set = set2,
                            },
                            showProfessionSkillups = {
                                order = 10,
                                type = "toggle",
                                name = "Profession skillup",
                                desc = "Displays your skill ups in professions.",
                                get = "Options_General_ShowProfessionSkillups",
                                set = set2,
                            },
                        },
                    },
                },
            },

            outgoing = {
                name = "|cffFFFFFFOutgoing Damage|r",
                type = "group",
                order = 12,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    --[2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 34,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },

                            headerAdditionalSettings = {
                                type = "header",
                                order = 10,
                                name = "Additional Settings",
                            },
                            iconsEnabledAutoAttack = {
                                order = 11,
                                type = "toggle",
                                name = "Show Auto Attack Icon",
                                desc = "Show icons from Auto Attacks.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = "Names",
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = "The |cffFFFF00Names Settings|r allows you to further format and customize your combat text frames. By selecting values from below, you will be able to see the source, destination or spell names of certain events.\n\n|cffFF8040NOTE:|r The |cffFFFF00Spam Merger|r will preempt formatting.",
                                fontSize = "small",
                            },

                            nameAppearance = {
                                type = "description",
                                order = 2,
                                name = "|cff798BDDName Appearance|r:\n\n",
                                fontSize = "large",
                                width = "normal",
                            },

                            namePrefix = {
                                order = 3,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = "Events to a Player",
                                args = {
                                    playerNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDPlayer Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = "Color Player Name",
                                        desc = "If the player's class is known (e.g. is a raid member), it will be colored.",
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = "Remove Realm Name",
                                        desc = "If the player has a realm name attatched to her name, it will be removed.",
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = "Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    playerNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 30,
                                        name = "Display Player Name",
                                        desc = "|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event\n\n|cff798BDDSpell Name|r - The name of the spell that is affecting the player",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "Player Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (Player Name - Spell Name)",
                                            [4] = "Both (Spell Name - Player Name)",
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = "Events to a NPC",
                                args = {
                                    npcNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDNPC Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = "NPC Name's Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    npcNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = "Display NPC Name",
                                        desc = "|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC's Name|r - The name of the target that is affected by the event\n\n|cff798BDDSpell Name|r - The name of the spell that is affecting the target",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "NPC's Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (NPC Name - Spell Name)",
                                            [4] = "Both (Spell Name - NPC Name)",
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        type = "group",
                        name = "Misc",
                        args = {
                            specialTweaksPlayer = {
                                type = "header",
                                order = 0,
                                name = "Player Damage Settings",
                            },
                            enableOutDmg = {
                                order = 10,
                                type = "toggle",
                                name = "Show Outgoing Damage",
                                desc = "Show damage you do.",
                                get = "Options_Outgoing_ShowDamage",
                                set = set2,
                            },
                            enableDotDmg = {
                                order = 11,
                                type = "toggle",
                                name = "Show DoTs",
                                desc = "Show your Damage-Over-Time (DOT) damage. (|cffFF0000Requires:|r Outgoing Damage)",
                                get = "Options_Outgoing_ShowDots",
                                set = set2,
                            },
                            enableAutoAttack_Outgoing = {
                                order = 12,
                                type = "toggle",
                                name = "Show Auto Attack",
                                desc = "Show your non-critical, auto attack damage.",
                                get = "Options_Outgoing_ShowAutoAttack",
                                set = set2,
                            },
                            enableAbsorbs = {
                                order = 13,
                                type = "toggle",
                                name = "Show Absorbs as damage",
                                desc = "Display partially or fully absorbed damage as regular damage.",
                                get = "Options_Outgoing_ShowAbsorbedDamageAsNormalDamage",
                                set = set2,
                            },

                            specialTweaksPet = {
                                type = "header",
                                order = 20,
                                name = "Pet and Vehicle Damage Settings",
                            },

                            enablePetDmg = {
                                order = 21,
                                type = "toggle",
                                name = "Show Pet Damage",
                                desc = "Show your pet's damage. Beast Mastery hunters should also look at vehicle damage.",
                                get = "Options_Outgoing_ShowPetDamage",
                                set = set2,
                            },
                            enablePetAutoAttack_Outgoing = {
                                order = 22,
                                type = "toggle",
                                name = "Pet Auto Attacks",
                                desc = "Show your pet's non-critical, auto attacks.",
                                get = "Options_Outgoing_ShowPetAutoAttack",
                                set = set2,
                            },
                            enableKillCommand = {
                                order = 23,
                                type = "toggle",
                                name = "Show Kill Command",
                                desc = "Change the source of |cff798BDDKill Command|r to be the |cffFF8000Player|r. This is helpful when you to turn off |cffFF8000Pet|r damage.",
                                get = "Options_Outgoing_ShowKillCommandAsPlayerDamage",
                                set = set2,
                                hidden = function()
                                    return x.player.class ~= "HUNTER"
                                end,
                            },
                            enableVehicleDmg = {
                                order = 24,
                                type = "toggle",
                                name = "Show Vehicle Damage",
                                desc = "Show damage that your vehicle does. This can be anything from a vehicle you are controlling to Hati, the beast mastery pet.",
                                get = "Options_Outgoing_ShowVehicleDamage",
                                set = set2,
                            },

                            missTypeSettings = {
                                type = "header",
                                order = 50,
                                name = "Miss Type Settings",
                            },
                            enableImmunes = {
                                order = 51,
                                type = "toggle",
                                name = "Show Immunes",
                                desc = "Display 'Immune' when your target cannot take damage.",
                                get = "Options_Outgoing_ShowImmunes",
                                set = set2,
                            },
                            enableMisses = {
                                order = 52,
                                type = "toggle",
                                name = "Show Misses, Dodges, Parries",
                                desc = "Display 'Miss', 'Dodge', 'Parry' when you miss your target.",
                                get = "Options_Outgoing_ShowMisses",
                                set = set2,
                            },
                            enablePartialMisses = {
                                order = 54,
                                type = "toggle",
                                name = "Show partial Misses, Dodges, Parries",
                                desc = "Show when your target takes only a percentage of your damage because it was partially absorbed, resisted, or blocked.\n\n|cffFF0000PLEASE NOTE:|r Only works if the spell is not merged. Turn off the Spell Merger to see all spells.",
                                get = "Options_Outgoing_ShowPartialMisses",
                                set = set2,
                            },
                            showHighestPartialMiss = {
                                order = 55,
                                type = "toggle",
                                name = "Show the Highest Partial Miss",
                                desc = "Only show the highest partial miss, instead of all the misses. (Rare, but less spammy)\n\n|cffFF0000PLEASE NOTE:|r Only works if the spell is not merged. Turn off the Spell Merger to see all spells.",
                                get = get2,
                                set = set2,
                            },
                        },
                    },
                },
            },

            outgoing_healing = {
                name = "|cffFFFFFFOutgoing Healing|r",
                type = "group",
                order = 13,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    --[10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 34,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = "Names",
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = "The |cffFFFF00Names Settings|r allows you to further format and customize your combat text frames. By selecting values from below, you will be able to see the source, destination or spell names of certain events.\n\n|cffFF8040NOTE:|r The |cffFFFF00Spam Merger|r will preempt formatting.",
                                fontSize = "small",
                            },

                            nameAppearance = {
                                type = "description",
                                order = 2,
                                name = "|cff798BDDName Appearance|r:\n\n",
                                fontSize = "large",
                                width = "normal",
                            },

                            namePrefix = {
                                order = 3,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = "Events to a Player",
                                args = {
                                    playerNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDPlayer Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = "Color Player Name",
                                        desc = "If the player's class is known (e.g. is a raid member), it will be colored.",
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = "Remove Realm Name",
                                        desc = "If the player has a realm name attatched to her name, it will be removed.",
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = "Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    playerNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 30,
                                        name = "Display Player Name",
                                        desc = "|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event\n\n|cff798BDDSpell Name|r - The name of the spell that is affecting the player",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "Player Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (Player Name - Spell Name)",
                                            [4] = "Both (Spell Name - Player Name)",
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = "Events to a NPC",
                                args = {
                                    npcNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDNPC Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = "NPC Name's Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    npcNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = "Display NPC Name",
                                        desc = "|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC's Name|r - The name of the target that is affected by the event\n\n|cff798BDDSpell Name|r - The name of the spell that is affecting the target",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "NPC's Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (NPC Name - Spell Name)",
                                            [4] = "Both (Spell Name - NPC Name)",
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        type = "group",
                        name = "Misc",
                        args = {
                            headerHots = {
                                order = 1,
                                type = "header",
                                name = "HoTs",
                            },
                            enableHots = {
                                order = 2,
                                type = "toggle",
                                name = "Show HoTs",
                                desc = "Show your Heal-Over-Time (HOT) healing.",
                                get = "Options_OutgoingHealing_ShowHots",
                                set = set2,
                            },

                            headerOverhealing = {
                                order = 10,
                                type = "header",
                                name = "Overhealing",
                            },
                            enableOverhealing = {
                                order = 11,
                                type = "toggle",
                                name = "Show Overhealing",
                                desc = "Displays overhealing.",
                                get = "Options_OutgoingHealing_ShowOverhealing",
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            enableOverhealingSubtraction = {
                                order = 12,
                                type = "toggle",
                                name = "Subtract Overhealing",
                                desc = "Subtract the overhealed amount from the Total Amount",
                                get = "Options_OutgoingHealing_SubtractOverhealing",
                                set = set2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enabledFrame
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealing
                                end,
                            },
                            enableOverhealingFormat = {
                                order = 13,
                                type = "toggle",
                                name = "Format Overhealing",
                                desc = "Splits overhealing into its own section. Example: +43,000 (O: 12,000)",
                                get = "Options_OutgoingHealing_FormatOverhealing",
                                set = set2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enabledFrame
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealing
                                end,
                            },
                            overhealingPrefix = {
                                order = 14,
                                type = "input",
                                name = "Overhealing Prefix",
                                desc = "Prefix this value to the beginning when displaying an overheal amount.\n\n|cffFF0000Requires:|r |cff798BDDFormat Overhealing|r",
                                get = "Options_OutgoingHealing_OverhealingPrefix",
                                set = setTextIn2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enabledFrame
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealing
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealingFormat
                                end,
                            },
                            overhealingPostfix = {
                                order = 15,
                                type = "input",
                                name = "Overhealing Postfix",
                                desc = "Prefix this value to the endind when displaying an overheal amount.\n\n|cffFF0000Requires:|r |cff798BDDFormat Overhealing|r",
                                get = "Options_OutgoingHealing_OverhealingPostfix",
                                set = setTextIn2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enabledFrame
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealing
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealingFormat
                                end,
                            },
                        },
                    },
                },
            },

            critical = {
                name = "|cffFFFFFFOutgoing|r |cff798BDD(Criticals)|r",
                type = "group",
                order = 14,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    --[3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 34,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = "Names",
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = "The |cffFFFF00Names Settings|r allows you to further format and customize your combat text frames. By selecting values from below, you will be able to see the source, destination or spell names of certain events.\n\n|cffFF8040NOTE:|r The |cffFFFF00Spam Merger|r will preempt formatting.",
                                fontSize = "small",
                            },

                            nameAppearance = {
                                type = "description",
                                order = 2,
                                name = "|cff798BDDName Appearance|r:\n\n",
                                fontSize = "large",
                                width = "normal",
                            },

                            namePrefix = {
                                order = 3,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = "Events to a Player",
                                args = {
                                    playerNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDPlayer Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = "Color Player Name",
                                        desc = "If the player's class is known (e.g. is a raid member), it will be colored.",
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = "Remove Realm Name",
                                        desc = "If the player has a realm name attatched to her name, it will be removed.",
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = "Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    playerNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 30,
                                        name = "Display Player Name",
                                        desc = "",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "Player Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (Player Name - Spell Name)",
                                            [4] = "Both (Spell Name - Player Name)",
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = "Events to a NPC",
                                args = {
                                    npcNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDNPC Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = "NPC Name's Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    npcNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = "Display NPC Name",
                                        desc = "",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "NPC's Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (NPC Name - Spell Name)",
                                            [4] = "Both (Spell Name - NPC Name)",
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        type = "group",
                        name = "Misc",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = "Miscellaneous Settings",
                            },
                            enableAutoAttack_Critical = {
                                order = 1,
                                type = "toggle",
                                name = "Show Auto Attacks",
                                desc = "Show criticals from Auto Attack and Swings. If disabled, they will be displayed as non-critical auto attacks. They will be merged into the Outgoing frame.",
                                get = "Options_Critical_ShowAutoAttack",
                                set = set2,
                            },
                            prefixAutoAttack_Critical = {
                                order = 2,
                                type = "toggle",
                                name = "Show Auto Attacks (Pre)Postfix",
                                desc = "Make Auto Attack and Swing criticals more visible by adding the prefix and postfix.",
                                get = "Options_Critical_PrefixAutoAttack",
                                set = set2,
                            },
                            petCrits = {
                                order = 3,
                                type = "toggle",
                                name = "Allow Pet Crits",
                                desc = "Enable this to see when your pet's abilities critical strike, otherwise disable for less combat text spam.",
                                get = "Options_Critical_ShowPetCrits",
                                set = set2,
                            },

                            criticalAppearance = {
                                type = "header",
                                order = 10,
                                name = "Critical Appearance",
                            },
                            critPrefix = {
                                order = 11,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying a critical amount.",
                                get = getTextIn2,
                                set = setTextIn2,
                                --disabled = isFrameItemDisabled,
                            },
                            critPostfix = {
                                order = 12,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying a critical amount.",
                                get = getTextIn2,
                                set = setTextIn2,
                                --disabled = isFrameItemDisabled,
                            },
                            critPostPreReset = {
                                order = 13,
                                type = "execute",
                                name = "Reset",
                                desc = "Reset Prefix and Postfix to their default setting.",
                                func = function()
                                    local critical = x.db.profile.frames.critical
                                    critical.critPrefix = "|cffFF0000*|r"
                                    critical.critPostfix = "|cffFF0000*|r"
                                end,
                                width = "half",
                                disabled = function()
                                    local critical = x.db.profile.frames.critical
                                    return critical.critPrefix == "|cffFF0000*|r"
                                        and critical.critPostfix == "|cffFF0000*|r"
                                end,
                            },
                        },
                    },
                },
            },

            damage = {
                name = "|cffFFFFFFIncoming Damage|r",
                type = "group",
                order = 15,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    --[4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 24,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },

                            headerAdditionalSettings = {
                                type = "header",
                                order = 10,
                                name = "Additional Settings",
                            },
                            iconsEnabledAutoAttack = {
                                order = 11,
                                type = "toggle",
                                name = "Show Auto Attack Icon",
                                desc = "Show icons from Auto Attacks.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = "Names",
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = "The |cffFFFF00Names Settings|r allows you to further format and customize your combat text frames. By selecting values from below, you will be able to see the source, destination or spell names of certain events.\n\n|cffFF8040NOTE:|r The |cffFFFF00Spam Merger|r will preempt formatting.",
                                fontSize = "small",
                            },

                            nameAppearance = {
                                type = "description",
                                order = 2,
                                name = "|cff798BDDName Appearance|r:\n\n",
                                fontSize = "large",
                                width = "normal",
                            },

                            namePrefix = {
                                order = 3,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = "Events from a Player",
                                args = {
                                    playerNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDPlayer Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = "Color Player Name",
                                        desc = "If the player's class is known (e.g. is a raid member), it will be colored.",
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = "Remove Realm Name",
                                        desc = "If the player has a realm name attatched to her name, it will be removed.",
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = "Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    playerNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 30,
                                        name = "Display Player Name",
                                        desc = "",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "Player Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (Player Name - Spell Name)",
                                            [4] = "Both (Spell Name - Player Name)",
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = "Events from a NPC",
                                args = {
                                    npcNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDNPC Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = "NPC Name's Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    npcNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = "Display NPC Name",
                                        desc = "",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "NPC's Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (NPC Name - Spell Name)",
                                            [4] = "Both (Spell Name - NPC Name)",
                                        },
                                    },
                                },
                            },

                            ENVIRONMENT = {
                                order = 30,
                                type = "group",
                                name = "Events from the Environment",
                                args = {
                                    environmentNames = {
                                        type = "description",
                                        order = 1,
                                        name = '|cff798BDD"Environment" Format Settings|r:',
                                        fontSize = "large",
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = 'Color "Environment"',
                                        desc = "The name will be colored according to it's environmental type.",
                                    },

                                    environmentNames_Spacer1 = {
                                        type = "description",
                                        order = 3,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = "Custom",
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    environmentSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Type",
                                        desc = "The type will be colored according to it's environmental type.",
                                    },

                                    environmentNames_Spacer2 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    environmentNames_Spacer3 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = "Display Environment Name",
                                        desc = "Environment Damage Types:"
                                            .. "\n|cffFFFF00"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_DROWNING
                                            .. "|r,"
                                            .. " |cffFFFF00"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_FALLING
                                            .. "|r,"
                                            .. " |cffFFFF00"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE
                                            .. "|r,"
                                            .. "\n|cffFF8000"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_FIRE
                                            .. "|r,"
                                            .. " |cffFF8000"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_LAVA
                                            .. "|r,"
                                            .. " |cff4DFF4D"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_SLIME
                                            .. "|r",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = '"Environment"',
                                            [2] = "Environmental Damage Type",
                                            [3] = 'Both ("Environment" - Type)',
                                            [4] = 'Both (Type - "Environment")',
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        name = "Misc",
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = "Miscellaneous Settings",
                            },
                            showDodgeParryMiss = {
                                order = 1,
                                type = "toggle",
                                name = "Show Misses, Dodges, Parries",
                                desc = "Displays Dodge, Parry, or Miss when you miss incoming damage.",
                                get = "Options_IncomingDamage_ShowMissTypes",
                                set = set2,
                            },
                            showDamageReduction = {
                                order = 2,
                                type = "toggle",
                                name = "Show Reductions",
                                desc = "Formats incoming damage to show how much was absorbed.",
                                get = "Options_IncomingDamage_ShowResistances",
                                set = set2,
                            },

                            criticalAppearance = {
                                type = "header",
                                order = 10,
                                name = "Critical Appearance",
                            },
                            critPrefix = {
                                order = 11,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying a critical amount.",
                                get = getTextIn2,
                                set = setTextIn2,
                                disabled = isFrameItemDisabled,
                            },
                            critPostfix = {
                                order = 12,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying a critical amount.",
                                get = getTextIn2,
                                set = setTextIn2,
                                disabled = isFrameItemDisabled,
                            },
                        },
                    },
                },
            },

            healing = {
                name = "|cffFFFFFFIncoming Healing|r",
                type = "group",
                order = 16,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    --[5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 24,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = "Names",
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = "The |cffFFFF00Names Settings|r allows you to further format and customize your combat text frames. By selecting values from below, you will be able to see the source, destination or spell names of certain events.\n\n|cffFF8040NOTE:|r The |cffFFFF00Spam Merger|r will preempt formatting.",
                                fontSize = "small",
                            },

                            nameAppearance = {
                                type = "description",
                                order = 2,
                                name = "|cff798BDDName Appearance|r:\n\n",
                                fontSize = "large",
                                width = "normal",
                            },

                            namePrefix = {
                                order = 3,
                                type = "input",
                                name = "Prefix",
                                desc = "Prefix this value to the beginning when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = "Postfix",
                                desc = "Postfix this value to the end when displaying the name.",
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = "Events from a Player",
                                args = {
                                    playerNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDPlayer Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = "Color Player Name",
                                        desc = "If the player's class is known (e.g. is a raid member), it will be colored.",
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = "Remove Realm Name",
                                        desc = "If the player has a realm name attatched to her name, it will be removed.",
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = "Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    playerNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 30,
                                        name = "Display Player Name",
                                        desc = "",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "Player Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (Player Name - Spell Name)",
                                            [4] = "Both (Spell Name - Player Name)",
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = "Events from a NPC",
                                args = {
                                    npcNames = {
                                        type = "description",
                                        order = 1,
                                        name = "|cff798BDDNPC Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = "NPC Name's Color",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        type = "description",
                                        order = 10,
                                        name = "\n|cff798BDDSpell Name Format Settings|r:",
                                        fontSize = "large",
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = "Color Spell Name",
                                        desc = "The spell name will be colored according to it's spell school.",
                                    },

                                    npcNames_Spacer1 = {
                                        type = "description",
                                        order = 12,
                                        name = "",
                                        width = "normal",
                                    },

                                    enableCustomSpellColor = {
                                        order = 13,
                                        type = "toggle",
                                        name = "Custom",
                                        desc = "Preempt an automatic color with a custom one.",
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = "Color",
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcNames_Spacer2 = {
                                        type = "description",
                                        order = 20,
                                        name = "",
                                    },

                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = "Display NPC Name",
                                        desc = "",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = "None",
                                            [1] = "NPC's Name",
                                            [2] = "Spell Name",
                                            [3] = "Both (NPC Name - Spell Name)",
                                            [4] = "Both (Spell Name - NPC Name)",
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        name = "Misc",
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = "Miscellaneous Settings",
                            },
                            enableOverHeal = {
                                order = 4,
                                type = "toggle",
                                name = "Show Overheals",
                                desc = "Show the overhealing you receive from other players.",
                                get = "Options_IncomingHealing_ShowOverHealing",
                                set = set2,
                            },
                            hideAbsorbedHeals = {
                                order = 5,
                                type = "toggle",
                                name = "Hide Absorbed Heals",
                                desc = "If enabled, subtract any healing that was absorbed by a |cffFF0000debuff|r from the total.",
                                get = "Options_IncomingHealing_HideAbsorbedHealing",
                                set = set2,
                            },
                            enableSelfAbsorbs = {
                                order = 6,
                                type = "toggle",
                                name = "Show Absorbs",
                                desc = "Shows absorbs you gain from other players.",
                                get = get2,
                                set = set2,
                            },
                            showOnlyMyHeals = {
                                order = 7,
                                type = "toggle",
                                name = "Show My Heals Only",
                                desc = "Shows only the player's healing done to himself or herself.",
                                get = "Options_IncomingHealing_ShowOnlyMyHeals",
                                set = set2,
                            },
                            showOnlyPetHeals = {
                                order = 7,
                                type = "toggle",
                                name = "Show Pet Heals Too",
                                desc = "Will also attempt to show the player pet's healing.",
                                get = "Options_IncomingHealing_ShowOnlyMyPetsHeals",
                                set = set2,
                                disabled = function()
                                    return not x.db.profile.frames.healing.showOnlyMyHeals
                                end,
                            },
                        },
                    },
                },
            },

            class = {
                name = "|cff808080Class Combo Points (Disabled)|r",
                type = "group",
                order = 17,
                childGroups = "tab",
                disabled = true,

                -- TODO: Still need to implement this
                hidden = true,

                args = {
                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "description",
                                order = 2,
                                name = "\n|cffFF0000Secondary Frame Not Available|r - |cffFFFFFFThis frame cannot output to another frame when it is disabled.\n\n",
                                width = "double",
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            --[[frameScrolling = {
                  type = 'description',
                  order = 10,
                  name = "\n|cff798BDDScrollable Frame Settings|r:",
                  fontSize = 'large',
                },
                enableScrollable = {
                  order = 11,
                  type = 'toggle',
                  name = "Enabled",
                  get = get2,
                  set = set2_update,
                  disabled = isFrameItemDisabled,
                },
                scrollableLines = {
                  order = 12,
                  name = "Number of Lines",
                  type = 'range',
                  min = 10, max = 60, step = 1,
                  get = get2,
                  set = set2_update,
                  disabled = isFrameNotScrollable,
                },
                scrollableInCombat = {
                  order = 13,
                  type = 'toggle',
                  name = "Disable in Combat",
                  get = get2,
                  set = set2_update,
                  disabled = isFrameItemDisabled,
                },]]
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },
                },
            },

            power = {
                name = "|cffFFFFFFClass Power|r",
                type = "group",
                order = 18,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    --[6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            megaDamage = {
                                order = 5,
                                type = "toggle",
                                name = "Number Formatting",
                                desc = "Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. ",
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 24,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },

                    specialTweaks = {
                        order = 50,
                        name = "Misc",
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = "Miscellaneous Settings",
                            },
                            showEnergyGains = {
                                order = 1,
                                type = "toggle",
                                name = "Show Gains",
                                desc = "Show instant gains of class resources (e. g. energy, runic power, ...).",
                                get = get2,
                                set = set2,
                            },
                            showEnergyType = {
                                order = 3,
                                type = "toggle",
                                name = "Show Energy Type",
                                desc = "Show the type of energy that you are gaining.",
                                get = "Options_Power_ShowEnergyTypes",
                                set = set2,
                            },

                            title1 = {
                                type = "header",
                                order = 10,
                                name = "Filter Resources",
                            },
                            title2 = {
                                type = "description",
                                order = 11,
                                name = "Check the resources that you do not wish to be displayed for your character:",
                                fontSize = "small",
                            },

                            -- Disable Powers
                            disableResource_MANA = {
                                order = 100,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. MANA,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_RAGE = {
                                order = 101,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. RAGE,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_FOCUS = {
                                order = 102,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. FOCUS,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_ENERGY = {
                                order = 103,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. ENERGY,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },

                            disableResource_RUNES = {
                                order = 104,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. RUNES,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_RUNIC_POWER = {
                                order = 105,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. RUNIC_POWER,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_SOUL_SHARDS = {
                                order = 106,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. SOUL_SHARDS,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_LUNAR_POWER = {
                                order = 107,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. LUNAR_POWER,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },

                            disableResource_CHI = {
                                order = 108,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. CHI,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_HOLY_POWER = {
                                order = 109,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. HOLY_POWER,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_INSANITY_POWER = {
                                order = 110,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. INSANITY,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_MAELSTROM_POWER = { -- Add in Maelstrom to resources
                                order = 111,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. MAELSTROM_POWER,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },

                            disableResource_ARCANE_CHARGES = {
                                order = 112,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. ARCANE_CHARGES,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_FURY = {
                                order = 113,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. FURY,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_PAIN = {
                                order = 114,
                                type = "toggle",
                                name = "Disable |cff798BDD" .. PAIN,
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                        },
                    },
                },
            },

            procs = {
                name = "|cffFFFFFFSpecial Effects|r |cff798BDD(Procs)|r",
                type = "group",
                order = 19,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = "Options_Procs_ShowProcs",
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    --[7] = "Special Effects (Procs)",
                                    [8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 24,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons next to your damage.",
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = get2,
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            customColors_Desc = {
                                type = "description",
                                order = 4,
                                name = "\n|cffFFFF00Other Color Settings|r:",
                                fontSize = "small",
                            },
                        },
                    },
                },
            },

            loot = {
                name = "|cffFFFFFFLoot, Currency & Money|r",
                type = "group",
                order = 20,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = "Frame",
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = "Frame Settings",
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = "Enable",
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = "Secondary Frame",
                                desc = "A frame to forward messages to when this frame is disabled.",
                                values = {
                                    [0] = "None",
                                    [1] = "General",
                                    [2] = "Outgoing Damage",
                                    [3] = "Outgoing Damage (Criticals)",
                                    [4] = "Incoming Damage",
                                    [5] = "Incoming Healing",
                                    [6] = "Class Power",
                                    [7] = "Special Effects (Procs)",
                                    --[8] = "Loot, Currency & Money",
                                    [10] = "Outgoing Healing"
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = "Text Direction",
                                desc = "Changes the direction that the text travels in the frame.",
                                values = {
                                    ["top"] = "Down",
                                    ["bottom"] = "Up",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = "Frame Alpha",
                                desc = "Sets the alpha of the frame.",
                                type = "range",
                                min = 0,
                                max = 100,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = "Scrollable Frame Settings",
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = "Enabled",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = "Number of Lines",
                                type = "range",
                                min = 10,
                                max = 60,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameNotScrollable,
                            },
                            scrollableInCombat = {
                                order = 13,
                                type = "toggle",
                                name = "Disable in Combat",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = "Fading Text Settings",
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = "Use Custom Fade",
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = "Enable",
                                desc = "Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = "Fade Out Duration",
                                desc = "The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 0,
                                max = 2,
                                step = 0.1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                            visibilityTime = {
                                order = 34,
                                name = "Visibility Duration",
                                desc = "The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r",
                                type = "range",
                                min = 2,
                                max = 15,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFadingDisabled,
                            },
                        },
                    },

                    fonts = {
                        order = 20,
                        type = "group",
                        name = "Font",
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = "Font Settings",
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = "Font",
                                desc = "Set the font of the frame.",
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = "Font Size",
                                desc = "Set the font size of the frame.",
                                type = "range",
                                min = 6,
                                max = 64,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontOutline = {
                                type = "select",
                                order = 3,
                                name = "Font Outline",
                                desc = "Set the font outline.",
                                values = {
                                    ["1NONE"] = "None",
                                    ["2OUTLINE"] = "OUTLINE",
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = "MONOCHROME",
                                    ["4MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
                                    ["5THICKOUTLINE"] = "THICKOUTLINE",
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = "Justification",
                                desc = "Justifies the output to a side.",
                                values = {
                                    ["RIGHT"] = "Right",
                                    ["LEFT"] = "Left",
                                    ["CENTER"] = "Center",
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = "Font Shadow Settings",
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = "Enable Font Shadow",
                                desc = "Shows a shadow behind the combat text fonts.",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = "Font Shadow Color",
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = "Horizonal Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetY = {
                                order = 14,
                                name = "Vertical Offset",
                                type = "range",
                                min = -10,
                                max = 10,
                                step = 1,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameFontShadowDisabled,
                            },
                        },
                    },

                    icons = {
                        order = 30,
                        type = "group",
                        name = "Icons",
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = "Icon Settings",
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = "Enable Icons",
                                desc = "Show icons.",
                                get = "Options_Loot_ShowIcons",
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = "Size",
                                desc = "Set the icon size. (Recommended value: 16)",
                                type = "range",
                                min = 6,
                                max = 22,
                                step = 1,
                                get = "Options_Loot_IconSize",
                                set = set2,
                                disabled = isFrameIconDisabled,
                            },
                            spacerIconsEnabled = {
                                order = 4,
                                type = "toggle",
                                name = "Show Invisible Icons",
                                desc = "When icons are disabled, you can still enable invisible icons to line up text.",
                                get = "Options_Loot_EnableSpacerIcons",
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = "Colors",
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = "Custom Colors",
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = "All Text One Color (Override Color Settings)",
                                width = "double",
                                desc = "Change all the text in this frame to a specific color.",
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = "Color",
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            --[[customColors_Desc = {
                  type = 'description',
                  order = 4,
                  name = "\n|cffFFFF00Other Color Settings|r:",
                  fontSize = 'small',
                },]]
                        },
                    },

                    specialTweaks = {
                        order = 50,
                        type = "group",
                        name = "Misc",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = "Miscellaneous Settings",
                            },
                            showMoney = {
                                order = 1,
                                type = "toggle",
                                name = "Looted Money",
                                desc = "Displays money that you pick up.",
                                get = "Options_Loot_ShowMoney",
                                set = set2,
                            },
                            showItems = {
                                order = 2,
                                type = "toggle",
                                name = "Looted Items",
                                desc = "Displays items that you pick up.",
                                get = "Options_Loot_ShowItems",
                                set = set2,
                            },
                            showCurrency = {
                                order = 3,
                                type = "toggle",
                                name = "Gained Currency",
                                desc = "Displays currecy that you gain.",
                                get = "Options_Loot_ShowCurency",
                                set = set2,
                            },
                            showItemTypes = {
                                order = 4,
                                type = "toggle",
                                name = "Show Item Types",
                                desc = "Formats the looted message to also include the type of item (e.g. Trade Goods, Armor, Junk, etc.).",
                                get = "Options_Loot_ShowItemTypes",
                                set = set2,
                            },
                            showItemTotal = {
                                order = 5,
                                type = "toggle",
                                name = "Total Items",
                                desc = "Displays how many items you have in your bag.",
                                get = "Options_Loot_ShowItemTotals",
                                set = set2,
                            },
                            showCrafted = {
                                order = 6,
                                type = "toggle",
                                name = "Crafted Items",
                                desc = "Displays items that you crafted.",
                                get = "Options_Loot_ShowCraftedItems",
                                set = set2,
                            },
                            showQuest = {
                                order = 7,
                                type = "toggle",
                                name = "Quest Items",
                                desc = "Displays items that pertain to a quest.",
                                get = "Options_Loot_ShowQuestItems",
                                set = set2,
                            },
                            showPurchased = {
                                order = 8,
                                type = "toggle",
                                name = "Purchased Items",
                                desc = "Displays items that were purchased from a vendor.",
                                get = "Options_Loot_ShowPurchasedItems",
                                set = set2,
                            },
                            colorBlindMoney = {
                                order = 9,
                                type = "toggle",
                                name = "Color Blind Mode",
                                desc = "Displays money using letters G, S, and C instead of icons.",
                                get = "Options_Loot_ShowColorBlindMoney",
                                set = set2,
                            },
                            filterItemQuality = {
                                order = 10,
                                type = "select",
                                name = "Filter Item Quality",
                                desc = "Will not display any items that are below this quality (does not filter Quest or Crafted items).",
                                values = {
                                    [0] = "1. |cff9d9d9d" .. ITEM_QUALITY0_DESC .. "|r", -- Poor
                                    [1] = "2. |cffffffff" .. ITEM_QUALITY1_DESC .. "|r", -- Common
                                    [2] = "3. |cff1eff00" .. ITEM_QUALITY2_DESC .. "|r", -- Uncommon
                                    [3] = "4. |cff0070dd" .. ITEM_QUALITY3_DESC .. "|r", -- Rare
                                    [4] = "5. |cffa335ee" .. ITEM_QUALITY4_DESC .. "|r", -- Epic
                                    [5] = "6. |cffff8000" .. ITEM_QUALITY5_DESC .. "|r", -- Legendary
                                    [6] = "7. |cffe6cc80" .. ITEM_QUALITY6_DESC .. "|r", -- Artifact
                                    [7] = "8. |cffe6cc80" .. ITEM_QUALITY7_DESC .. "|r", -- Heirloom
                                },
                                get = "Options_Loot_ItemQualityFilter",
                                set = set2,
                            },
                        },
                    },
                },
            },
        },
    }

    x.CLASS_NAMES = {
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

    optionsAddon.engine:UpdateOptionsTableSpamMergerSpells()
    optionsAddon.engine:UpdateAuraSpellFilter()
    optionsAddon.engine:GenerateSpellSchoolColors()
    optionsAddon.engine:GenerateColorOptions()
end

-- Gets spammy spells from the database and creates options
function optionsAddon.engine:UpdateOptionsTableSpamMergerSpells()
    local function SpamMergerGetSpellInterval(info)
        local spellId = tonumber(info[#info])
        if x.db.profile.spells.merge[spellId] ~= nil and x.db.profile.spells.merge[spellId].interval ~= nil then
            return x.db.profile.spells.merge[spellId].interval
        end
        return optionsAddon.merges[spellId].interval or 0
    end

    local function SpamMergerSetSpellInterval(info, value)
        local spellId = tonumber(info[#info])
        local db = x.db.profile.spells.merge[spellId] or {}
        db.interval = value
        x.db.profile.spells.merge[spellId] = db
    end

    local spells = optionsAddon.optionsTable.args.spells.args.classList.args
    local global = optionsAddon.optionsTable.args.spells.args.globalList.args
    local racetab = optionsAddon.optionsTable.args.spells.args.raceList.args

    for class, specs in pairs(x.CLASS_NAMES) do
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
    for _, entry in pairs(optionsAddon.merges) do
        if not x.CLASS_NAMES[entry.category] then
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
    for spellID, entry in pairs(optionsAddon.merges) do
        local name = C_Spell.GetSpellName(spellID)
        if name then
            --TODO better code when i understand more the code
            -- Create a useful description for the spell
            local spellDesc = C_Spell.GetSpellDescription(spellID) or "No Description"
            local desc = ""
            if entry.desc and not x.CLASS_NAMES[entry.category] then
                desc = "|cff9F3ED5" .. entry.desc .. "|r\n\n"
            end
            desc = desc .. spellDesc .. "\n\n|cffFF0000ID|r |cff798BDD" .. spellID .. "|r"

            local firstSecondaryIdFound = true
            for originalSpellId, replaceSpellId in pairs(optionsAddon.replaceSpellId) do
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
            if x.CLASS_NAMES[entry.category] then
                local index = x.CLASS_NAMES[entry.category][tonumber(entry.desc) or 0]
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

-- Get and set methods for the spell filter
local function isSpellFiltered(info)
    return x.db.profile.spellFilter[info[#info - 2]][info[#info]]
end
local function setIsSpellFiltered(info, value)
    x.db.profile.spellFilter[info[#info - 2]][info[#info]] = value
end

-- Update the Buff, Debuff and Spell filter list
function optionsAddon.engine:UpdateAuraSpellFilter(specific)
    if not specific or specific == "buffs" then
        optionsAddon.optionsTable.args.spellFilter.args.listBuffs.args.headerFilterList = {
            order = 100,
            name = "Filtered Buffs |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listBuffs.args.list = {
            order = 101,
            name = "",
            type = "group",
            guiInline = true,
            args = {},
        }

        local buffs = optionsAddon.optionsTable.args.spellFilter.args.listBuffs.args.list.args
        local updated = false

        -- Update buffs
        for name in pairs(x.db.profile.spellFilter.listBuffs) do
            updated = true
            buffs[name] = {
                name = name,
                type = "toggle",
                get = isSpellFiltered,
                set = setIsSpellFiltered,
            }
        end

        if not updated then
            buffs.noSpells = {
                name = "No buffs have been added to this list yet.",
                type = "description",
            }
        end
    end

    if not specific or specific == "debuffs" then
        optionsAddon.optionsTable.args.spellFilter.args.listDebuffs.args.headerFilterList = {
            order = 100,
            name = "Filtered Debuffs |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listDebuffs.args.list = {
            order = 101,
            name = "",
            type = "group",
            guiInline = true,
            args = {},
        }

        local debuffs = optionsAddon.optionsTable.args.spellFilter.args.listDebuffs.args.list.args
        local updated = false

        for name in pairs(x.db.profile.spellFilter.listDebuffs) do
            updated = true
            debuffs[name] = {
                name = name,
                type = "toggle",
                get = isSpellFiltered,
                set = setIsSpellFiltered,
            }
        end

        if not updated then
            debuffs.noSpells = {
                name = "No debuffs have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update procs
    if not specific or specific == "procs" then
        optionsAddon.optionsTable.args.spellFilter.args.listProcs.args.headerFilterList = {
            order = 100,
            name = "Filtered Procs |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listProcs.args.list = {
            order = 101,
            name = "",
            type = "group",
            guiInline = true,
            args = {},
        }

        local procs = optionsAddon.optionsTable.args.spellFilter.args.listProcs.args.list.args
        local updated = false

        for name in pairs(x.db.profile.spellFilter.listProcs) do
            updated = true
            procs[name] = {
                name = name,
                type = "toggle",
                get = isSpellFiltered,
                set = setIsSpellFiltered,
            }
        end

        if not updated then
            procs.noSpells = {
                name = "No procs have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update spells
    if not specific or specific == "spells" then
        optionsAddon.optionsTable.args.spellFilter.args.listSpells.args.headerFilterList = {
            order = 100,
            name = "Filtered Spells |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listSpells.args.list = {
            order = 101,
            name = "",
            type = "group",
            guiInline = true,
            args = {},
        }

        local spells = optionsAddon.optionsTable.args.spellFilter.args.listSpells.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listSpells) do
            local spellID = tonumber(string.match(id, "%d+"))
            local spellName = C_Spell.GetSpellName(spellID)
            if spellName then
                local spellDesc = C_Spell.GetSpellDescription(spellID)
                updated = true
                spells[id] = {
                    name = spellName,
                    desc = spellDesc .. "\n\n|cffFF0000ID|r |cff798BDD" .. spellID .. "|r",
                    type = "toggle",
                    get = isSpellFiltered,
                    set = setIsSpellFiltered,
                }
            else
                x.db.profile.spellFilter.listSpells[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = "No spells have been added to this list yet.",
                type = "description",
            }
        end
    end

    -- Update spells
    if not specific or specific == "items" then
        optionsAddon.optionsTable.args.spellFilter.args.listItems.args.headerFilterList = {
            order = 100,
            name = "Filtered Items |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listItems.args.list = {
            order = 101,
            name = "",
            type = "group",
            guiInline = true,
            args = {},
        }

        local spells = optionsAddon.optionsTable.args.spellFilter.args.listItems.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listItems) do
            local spellID = tonumber(string.match(id, "%d+"))
            local name = C_Item.GetItemNameByID(spellID or id)
            local texture = C_Item.GetItemIconByID(spellID or id)
            name = name or "Unknown Item"
            updated = true
            spells[id] = {
                name = string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t %s", texture or x.BLANK_ICON, 16, 16, name),
                desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                type = "toggle",
                get = isSpellFiltered,
                set = setIsSpellFiltered,
            }
        end

        if not updated then
            spells.noSpells = {
                name = "No items have been added to this list yet.",
                type = "description",
            }
        end
    end

    if not specific or specific == "damage" then
        optionsAddon.optionsTable.args.spellFilter.args.listDamage.args.headerFilterList = {
            order = 100,
            name = "Filtered Incoming Damage |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listDamage.args.list = {
            order = 101,
            name = "",
            type = "group",
            guiInline = true,
            args = {},
        }

        local spells = optionsAddon.optionsTable.args.spellFilter.args.listDamage.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listDamage) do
            local spellID = tonumber(string.match(id, "%d+"))
            local spellName = C_Spell.GetSpellName(spellID or id)
            if spellName then
                updated = true
                spells[id] = {
                    name = spellName,
                    desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                    type = "toggle",
                    get = isSpellFiltered,
                    set = setIsSpellFiltered,
                }
            else
                x.db.profile.spellFilter.listDamage[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = "No spells have been added to this list yet.",
                type = "description",
            }
        end
    end

    if not specific or specific == "healing" then
        optionsAddon.optionsTable.args.spellFilter.args.listHealing.args.headerFilterList = {
            order = 100,
            name = "Filtered Incoming Healing |cff798BDD(Uncheck to disable)|r",
            type = "header",
        }
        optionsAddon.optionsTable.args.spellFilter.args.listHealing.args.list = {
            name = "",
            type = "group",
            guiInline = true,
            order = 101,
            args = {},
        }

        local spells = optionsAddon.optionsTable.args.spellFilter.args.listHealing.args.list.args
        local updated = false

        for id in pairs(x.db.profile.spellFilter.listHealing) do
            local spellID = tonumber(string.match(id, "%d+"))
            local spellName = C_Spell.GetSpellName(spellID or id)
            if spellName then
                updated = true
                spells[id] = {
                    name = spellName,
                    desc = "|cffFF0000ID|r |cff798BDD" .. id .. "|r\n",
                    type = "toggle",
                    get = isSpellFiltered,
                    set = setIsSpellFiltered,
                }
            else
                x.db.profile.spellFilter.listHealing[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = "No spells have been added to this list yet.",
                type = "description",
            }
        end
    end
end

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

-- DB for the colors
local colorNameDB = {}

-- Returns the color and if it was enabled
function x:LookupColorByName(name)
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
function optionsAddon.engine:GenerateColorOptions()
    for name, settings in pairs(x.db.profile.frames) do
        local options = optionsAddon.optionsTable.args.Frames.args[name]
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

function optionsAddon.engine:GenerateSpellSchoolColors()
    local options = optionsAddon.optionsTable.args.SpellSchools.args
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

local helpfulLastUpdate = GetTime()
function x:OnAddonConfigRefreshed()
    if GetTime() - helpfulLastUpdate > 15 then
        helpfulLastUpdate = GetTime()
        optionsAddon.optionsTable.args.helpfulTip.name = GetNextTip()
        x:RefreshConfig()
    end
end

-- Force Config Page to refresh
function x:RefreshConfig()
    if ACD.OpenFrames[AddonName] then
        ACR:NotifyChange(AddonName)
    end
end

-- Update the combo point list

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

-- TODO currently unused
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

    optionsAddon.optionsTable.args.Frames.args.class.args.tracker = comboSpells

    x.LOADED_COMBO_POINTS_OPTIONS = true

    x:UpdateComboTracker()
end
