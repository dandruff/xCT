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

-- Short handles to the xCT engine and the xCT options engine
local x = xCT_Plus.engine
local xo = optionsAddon.engine
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)

if not x then
    return
end

local function getColoredClassName(class)
    return string.format(
        "|c%s%s|r",
        RAID_CLASS_COLORS[class].colorStr,
        LOCALIZED_CLASS_NAMES_MALE[class]
    )
end

function x:InitOptionsTable()
    -- Create the options table for AceConfig
    optionsAddon.optionsTable = {
        -- Add a place for the user to grab
        name = string.format(
            L["                                                      Version: %s                                                      "],
            C_AddOns.GetAddOnMetadata("xCT+", "Version") or L["Unknown"]
        ),
        handler = x,
        type = "group",
        args = {
            xCT_Title = {
                order = 0,
                type = "description",
                fontSize = "large",
                name = L["|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n"],
                width = "double",
            },

            spacer0 = {
                order = 1,
                type = "description",
                name = L["|cffFFFF00Helpful Tips:|r\n\n"],
                width = "half",
            },

            helpfulTip = {
                order = 2,
                type = "description",
                fontSize = "medium",
                name = L["On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options."],
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
                name = L["Hide Config in Combat"],
                desc = L["This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r"],
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
          name = L["Restore Defaults"],
          func = x.RestoreAllDefaults,
        },]==]
            space2 = {
                order = 20,
                type = "description",
                name = "",
                width = "half",
            },
            space3 = {
                order = 30,
                type = "description",
                name = "",
                width = "half",
            },
            space4 = {
                order = 30,
                type = "description",
                name = "",
                width = "half",
            },
            ToggleTestMode = {
                order = 31,
                type = "execute",
                name = L["Test"],
                desc = L["Allows you to preview xCT+ in order to tweak settings outside of combat.\n\nYou can also type: '|cffFF0000/xct test|r'"],
                width = "half",
                func = x.ToggleTestMode,
            },
            ToggleFrames = {
                order = 32,
                type = "execute",
                name = L["Move"],
                desc = L["Allows you to adjust the position of all the xCT+ frames on your screen.\n\nYou can also type: '|cffFF0000/xct lock|r'"],
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
        local optionKey = info[#info]
        x.db.profile.frames[info[#info - 2]][optionKey] = value
        if optionKey == "showProfessionSkillups"
                or optionKey == "showLowManaHealth"
                or optionKey == "showCurrency"
                or optionKey == "showMoney"
                or optionKey == "showEnergyGains"
        then
            x:RegisterCombatEvents()
        else
            x:UpdateCVar()
        end
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
        return not x.db.profile.frames[info[#info - 2]].enabledFrame
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

        for id in pairs(x.spellCache.spells) do
            result[tostring(id)] = string.format(
                "%s %s |cff798BDD(%d)|r",
                x:FormatIcon(C_Spell.GetSpellTexture(id) or 0, 16),
                C_Spell.GetSpellName(id) or UNKNOWN,
                id
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

        for id in pairs(x.spellCache.items) do
            result[tostring(id)] = string.format(
                "%s %s |cff798BDD(%d)|r",
                x:FormatIcon(C_Item.GetItemIconByID(id) or 0, 16),
                C_Item.GetItemNameByID(id) or UNKNOWN,
                id
            )
        end

        return result
    end

    local function GetDamageIncomingHistory()
        local result = {}

        for id in pairs(x.spellCache.damage) do
            result[tostring(id)] = string.format(
                "%s %s |cff798BDD(%d)|r",
                x:FormatIcon(C_Spell.GetSpellTexture(id) or 0, 16),
                C_Spell.GetSpellName(id) or UNKNOWN,
                id
            )
        end

        return result
    end

    local function GetHealingIncomingHistory()
        local result = {}

        for id in pairs(x.spellCache.healing) do
            result[tostring(id)] = string.format(
                "%s %s |cff798BDD(%d)|r",
                x:FormatIcon(C_Spell.GetSpellTexture(id) or 0, 16),
                C_Spell.GetSpellName(id) or UNKNOWN,
                id
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
            xo:UpdateAuraSpellFilter("buffs")
        elseif category == "listDebuffs" then
            xo:UpdateAuraSpellFilter("debuffs")
        elseif category == "listSpells" then
            xo:UpdateAuraSpellFilter("spells")
        elseif category == "listProcs" then
            xo:UpdateAuraSpellFilter("procs")
        elseif category == "listItems" then
            xo:UpdateAuraSpellFilter("items")
        elseif category == "listDamage" then
            xo:UpdateAuraSpellFilter("damage")
        elseif category == "listHealing" then
            xo:UpdateAuraSpellFilter("healing")
        else
            xo:Print("|cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
        end
    end

    local function removeFilteredSpell(info, value)
        local category = info[#info - 1]

        x.db.profile.spellFilter[category][value] = nil

        if category == "listBuffs" then
            xo:UpdateAuraSpellFilter("buffs")
        elseif category == "listDebuffs" then
            xo:UpdateAuraSpellFilter("debuffs")
        elseif category == "listSpells" then
            xo:UpdateAuraSpellFilter("spells")
        elseif category == "listProcs" then
            xo:UpdateAuraSpellFilter("procs")
        elseif category == "listItems" then
            xo:UpdateAuraSpellFilter("items")
        elseif category == "listDamage" then
            xo:UpdateAuraSpellFilter("damage")
        elseif category == "listHealing" then
            xo:UpdateAuraSpellFilter("healing")
        else
            x:Print("|cffFF0000Error:|r Unknown filter type '" .. category .. "'!")
        end
    end

    -- Apply to All variables
    local miscFont, miscFontOutline, miscEnableCustomFade

    optionsAddon.optionsTable.args.Frames = {
        name = L["Frames"],
        type = "group",
        order = 0,
        args = {
            frameSettings = {
                order = 1,
                name = L["Frame Settings"],
                type = "group",
                guiInline = true,
                args = {
                    frameStrata = {
                        order = 1,
                        type = "select",
                        name = L["Frame Strata"],
                        desc = L["The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata."],
                        values = {
                            --["1PARENT"]             = L["Parent |cffFF0000(Lowest)|r"],
                            ["2BACKGROUND"] = L["Background |cffFF0000(Lowest)|r"],
                            ["3LOW"] = L["Low"],
                            ["4MEDIUM"] = L["Medium"],
                            ["5HIGH"] = L["High |cffFFFF00(Default)|r"],
                            ["6DIALOG"] = L["Dialog"],
                            ["7FULLSCREEN"] = L["Fullscreen"],
                            ["8FULLSCREEN_DIALOG"] = L["Fullscreen Dialog"],
                            ["9TOOLTIP"] = L["ToolTip |cffAAFF80(Highest)|r"],
                        },
                        get = get0,
                        set = set0_update,
                    },
                    clearLeavingCombat = {
                        order = 2,
                        type = "toggle",
                        name = L["Clear Frames when leaving combat"],
                        desc = L["Enable this option if you have problems with 'floating' icons."],
                        width = "full",
                        get = get0,
                        set = set0,
                    },

                    whenMovingFrames = {
                        order = 10,
                        type = "header",
                        name = L["When moving the Frames"],
                    },
                    showGrid = {
                        order = 11,
                        type = "toggle",
                        name = L["Show Align Grid"],
                        desc = L["Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."],
                        get = get0,
                        set = set0,
                    },
                    showPositions = {
                        order = 12,
                        type = "toggle",
                        name = L["Show Positions"],
                        desc = L["Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."],
                        get = get0,
                        set = set0,
                    },
                },
            },

            spacer1 = {
                order = 2,
                type = "description",
                name = "\n",
            },

            megaDamage = {
                order = 3,
                name = L["Number Format Settings"],
                type = "group",
                guiInline = true,
                args = {
                    formatAbbreviate = {
                        order = 1,
                        type = "toggle",
                        name = L["Abbreviate Numbers"],
                        set = setFormatting,
                        get = getDBSpells,
                    },
                    formatGroups = {
                        order = 2,
                        type = "toggle",
                        name = L["Decimal Marks"],
                        desc = L["Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r"],
                        set = setFormatting,
                        get = getDBSpells,
                    },
                    decimalPoint = {
                        order = 3,
                        type = "toggle",
                        name = L["Single Decimal Precision"],
                        desc = L["Shows a single digit of precision when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r)."],
                        get = get0,
                        set = set0,
                    },
                    thousandSymbol = {
                        order = 4,
                        type = "input",
                        name = L["Thousand Symbol"],
                        desc = L["Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r"],
                        get = getTextIn0,
                        set = setTextIn0,
                    },
                    millionSymbol = {
                        order = 5,
                        type = "input",
                        name = L["Million Symbol"],
                        desc = L["Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r"],
                        get = getTextIn0,
                        set = setTextIn0,
                    },
                    billionSymbol = {
                        order = 6,
                        type = "input",
                        name = L["Billion Symbol"],
                        desc = L["Symbol for: |cffFF0000Billions|r |cff798BDD(10e+9)|r"],
                        get = getTextIn0,
                        set = setTextIn0,
                    },

                    critPrefix = {
                        order = 11,
                        type = "input",
                        name = L["Critical Prefix"],
                        desc = L["Add these character(s) before the amount of a critical hit."],
                        get = function()
                            return string.gsub(x.db.profile.megaDamage.critPrefix, "|", "||")
                        end,
                        set = setTextIn0,
                    },
                    critSuffix = {
                        order = 12,
                        type = "input",
                        name = L["Critical Suffix"],
                        desc = L["Add these character(s) after the amount of a critical hit."],
                        get = function()
                            return string.gsub(x.db.profile.megaDamage.critSuffix, "|", "||")
                        end,
                        set = setTextIn0,
                    },
                    critPrefixSuffixReset = {
                        order = 13,
                        type = "execute",
                        name = L["Reset"],
                        desc = L["Reset the prefix and the suffix of criticals to their default setting."],
                        func = function()
                            x.db.profile.megaDamage.critPrefix = "|cffFF0000*|r"
                            x.db.profile.megaDamage.critSuffix = "|cffFF0000*|r"
                        end,
                        width = "half",
                        disabled = function()
                            return x:Options_Global_CritPrefix() == "|cffFF0000*|r"
                                and x:Options_Global_CritSuffix() == "|cffFF0000*|r"
                        end,
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
                name = L["Global Frame Settings |cffFFFFFF(Experimental)|r"],
                args = {
                    miscDesc = {
                        order = 51,
                        type = "description",
                        name = L["The following settings are marked as experimental. They should all work, but they might not be very useful. Expect changes or updates to these in the near future.\n\nClick |cffFFFF00Set All|r to apply setting to all |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames.\n"],
                    },
                    font = {
                        order = 52,
                        type = "select",
                        dialogControl = "LSM30_Font",
                        name = L["Font"],
                        desc = L["Set the font of the frame."],
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
                        name = L["Set All"],
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
                        name = L["Font Outline"],
                        desc = L["Set the font outline."],
                        values = {
                            ["1NONE"] = L["None"],
                            ["2OUTLINE"] = L["Outline"],
                            -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                            -- http://us.battle.net/wow/en/forum/topic/6470967362
                            ["3MONOCHROME"] = L["Monochrome"],
                            ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                            ["5THICKOUTLINE"] = L["Thick Outline"],
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
                        name = L["Set All"],
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
                        name = L["Use Custom Fade"],
                        desc = L["Allows you to customize the fade time of each frame."],
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
                        name = L["Set All"],
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
                name = L["|cffFFFFFFGeneral|r"],
                type = "group",
                order = 11,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    --[1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    specialTweaks = {
                        order = 50,
                        name = L["Misc"],
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = L["Miscellaneous Settings"],
                            },
                            showInterrupts = {
                                order = 1,
                                type = "toggle",
                                name = L["Interrupts"],
                                desc = L["Display the spell you successfully interrupted."],
                                get = "Options_General_ShowInterrupts",
                                set = set2,
                            },
                            showDispells = {
                                order = 2,
                                type = "toggle",
                                name = L["Your Dispells / Spell Steals"],
                                desc = L["Show the spell that you dispelled or stole."],
                                get = "Options_General_ShowDispells",
                                set = set2,
                            },
                            showIncomingDispells = {
                                order = 3,
                                type = "toggle",
                                name = L["Incoming Dispells / Spell Steals"],
                                desc = L["Show the spell that somebody else dispelled on you or stole a buff/debuff from you."],
                                get = "Options_General_ShowIncomingDispells",
                                set = set2,
                            },
                            showPartyKills = {
                                order = 4,
                                type = "toggle",
                                name = L["Unit Killed"],
                                desc = L["Display unit that was killed by your final blow."],
                                get = "Options_General_ShowPartyKill",
                                set = set2,
                            },
                            showBuffs = {
                                order = 5,
                                type = "toggle",
                                name = L["Buff Gains/Fades"],
                                desc = L["Display the names of helpful auras |cff00FF00(Buffs)|r that you gain and lose."],
                                get = "Options_General_ShowBuffGainsAndFades",
                                set = set2,
                            },
                            showDebuffs = {
                                order = 6,
                                type = "toggle",
                                name = L["Debuff Gains/Fades"],
                                desc = L["Display the names of harmful auras |cffFF0000(Debuffs)|r that you gain and lose."],
                                get = "Options_General_ShowDebuffGainsAndFades",
                                set = set2,
                            },
                            showLowManaHealth = {
                                order = 7,
                                type = "toggle",
                                name = L["Low Mana/Health"],
                                desc = L["Displays 'Low Health/Mana' when your health/mana reaches the low threshold."],
                                get = "Options_General_ShowLowManaAndHealth",
                                set = set2,
                            },
                            showCombatState = {
                                order = 8,
                                type = "toggle",
                                name = L["Leave/Enter Combat"],
                                desc = L["Displays when the player is leaving or entering combat."],
                                get = "Options_General_ShowCombatState",
                                set = set2,
                            },
                            showRepChanges = {
                                order = 9,
                                type = "toggle",
                                name = L["Reputation Gains/Losses"],
                                desc = L["Displays your player's reputation gains and losses."],
                                get = "Options_General_ShowReputationChanges",
                                set = set2,
                            },
                            showHonorGains = {
                                order = 10,
                                type = "toggle",
                                name = L["Honor Gains"],
                                desc = L["Displays your player's honor gains."],
                                get = "Options_General_ShowHonor",
                                set = set2,
                            },
                            showProfessionSkillups = {
                                order = 11,
                                type = "toggle",
                                name = L["Profession skillup"],
                                desc = L["Displays your skill ups in professions."],
                                get = "Options_General_ShowProfessionSkillups",
                                set = set2,
                            },
                        },
                    },
                },
            },

            outgoing = {
                name = L["|cffFFFFFFOutgoing Damage|r"],
                type = "group",
                order = 12,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    --[2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },

                            headerAdditionalSettings = {
                                type = "header",
                                order = 10,
                                name = L["Additional Settings"],
                            },
                            iconsEnabledAutoAttack = {
                                order = 11,
                                type = "toggle",
                                name = L["Show Auto Attack Icon"],
                                desc = L["Show icons from Auto Attacks."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                order = 0,
                                type = "header",
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = L["Names"],
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = L["The |cffFFFF00Names Settings|r allows you to add the player / npc / spell name to each message. The spam merger will hide player / npc names if different players / npcs were hit."],
                                fontSize = "small",
                            },

                            namePrefix = {
                                order = 2,
                                type = "input",
                                name = L["Name Prefix"],
                                desc = L["Add these character(s) to the beginning of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = L["Name Suffix"],
                                desc = L["Add these character(s) to the end of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = L["Events to a Player"],
                                args = {
                                    playerNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["Player Name Format"],
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = L["Color Player Name"],
                                        desc = L["If the player's class is known (e.g. is a raid member), it will be colored."],
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = L["Remove Realm Name"],
                                        desc = L["If the player has a realm name attached to her name, it will be removed."],
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = L["Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["Player Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["Player Name"] .. " - " .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. " - " .. L["Player Name"],
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = L["Events to a NPC"],
                                args = {
                                    npcNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["NPC Name Format"],
                                    },
                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = L["NPC Name Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },
                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC Name|r - The name of the NPC that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["NPC Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["NPC Name"] .. ' - ' .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. ' - ' .. L["NPC Name"],
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        type = "group",
                        name = L["Misc"],
                        args = {
                            specialTweaksPlayer = {
                                type = "header",
                                order = 0,
                                name = L["Player Damage Settings"],
                            },
                            enableOutDmg = {
                                order = 10,
                                type = "toggle",
                                name = L["Show Outgoing Damage"],
                                desc = L["Show damage you do."],
                                get = "Options_Outgoing_ShowDamage",
                                set = set2,
                            },
                            enableDotDmg = {
                                order = 11,
                                type = "toggle",
                                name = L["Show DoTs"],
                                desc = L["Show your Damage-Over-Time (DOT) damage. (|cffFF0000Requires:|r Outgoing Damage)"],
                                get = "Options_Outgoing_ShowDots",
                                set = set2,
                            },
                            enableAutoAttack_Outgoing = {
                                order = 12,
                                type = "toggle",
                                name = L["Show Auto Attack"],
                                desc = L["Show your non-critical, auto attack damage."],
                                get = "Options_Outgoing_ShowAutoAttack",
                                set = set2,
                            },
                            enableAbsorbs = {
                                order = 13,
                                type = "toggle",
                                name = L["Show Absorbs as damage"],
                                desc = L["Display partially or fully absorbed damage as regular damage."],
                                get = "Options_Outgoing_ShowAbsorbedDamageAsNormalDamage",
                                set = set2,
                            },

                            specialTweaksPet = {
                                type = "header",
                                order = 20,
                                name = L["Pet and Vehicle Damage Settings"],
                            },

                            enablePetDmg = {
                                order = 21,
                                type = "toggle",
                                name = L["Show Pet Damage"],
                                desc = L["Show your pet's damage. Beast Mastery hunters should also look at vehicle damage."],
                                get = "Options_Outgoing_ShowPetDamage",
                                set = set2,
                            },
                            enablePetAutoAttack_Outgoing = {
                                order = 22,
                                type = "toggle",
                                name = L["Pet Auto Attacks"],
                                desc = L["Show your pet's non-critical, auto attacks."],
                                get = "Options_Outgoing_ShowPetAutoAttack",
                                set = set2,
                            },
                            enableKillCommand = {
                                order = 23,
                                type = "toggle",
                                name = L["Show Kill Command"],
                                desc = L["Change the source of |cff798BDDKill Command|r to be the |cffFF8000Player|r. This is helpful when you to turn off |cffFF8000Pet|r damage."],
                                get = "Options_Outgoing_ShowKillCommandAsPlayerDamage",
                                set = set2,
                                hidden = function()
                                    return x.player.class ~= "HUNTER"
                                end,
                            },
                            enableVehicleDmg = {
                                order = 24,
                                type = "toggle",
                                name = L["Show Vehicle Damage"],
                                desc = L["Show damage that your vehicle does. This can be anything from a vehicle you are controlling to Hati, the beast mastery pet."],
                                get = "Options_Outgoing_ShowVehicleDamage",
                                set = set2,
                            },

                            missTypeSettings = {
                                type = "header",
                                order = 50,
                                name = L["Miss Type Settings"],
                            },
                            enableImmunes = {
                                order = 51,
                                type = "toggle",
                                name = L["Show Immunes"],
                                desc = L["Display 'Immune' when your target cannot take damage."],
                                get = "Options_Outgoing_ShowImmunes",
                                set = set2,
                            },
                            enableMisses = {
                                order = 52,
                                type = "toggle",
                                name = L["Show Misses, Dodges, Parries"],
                                desc = L["Display 'Miss', 'Dodge', 'Parry' when you miss your target."],
                                get = "Options_Outgoing_ShowMisses",
                                set = set2,
                            },
                            enablePartialMisses = {
                                order = 54,
                                type = "toggle",
                                name = L["Show partial Misses, Dodges, Parries"],
                                desc = L["Show when your target takes only a percentage of your damage because it was partially absorbed, resisted, or blocked.\n\n|cffFF0000PLEASE NOTE:|r Only works if the spell is not merged. Turn off the Spell Merger to see all spells."],
                                get = "Options_Outgoing_ShowPartialMisses",
                                set = set2,
                            },
                            showHighestPartialMiss = {
                                order = 55,
                                type = "toggle",
                                name = L["Show the Highest Partial Miss"],
                                desc = L["Only show the highest partial miss, instead of all the misses. (Rare, but less spammy)\n\n|cffFF0000PLEASE NOTE:|r Only works if the spell is not merged. Turn off the Spell Merger to see all spells."],
                                get = get2,
                                set = set2,
                            },
                        },
                    },
                },
            },

            outgoing_healing = {
                name = L["|cffFFFFFFOutgoing Healing|r"],
                type = "group",
                order = 13,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    --[10] = L["Outgoing Healing"]
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = L["Names"],
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = L["The |cffFFFF00Names Settings|r allows you to add the player / npc / spell name to each message. The spam merger will hide player / npc names if different players / npcs were hit."],
                                fontSize = "small",
                            },

                            namePrefix = {
                                order = 2,
                                type = "input",
                                name = L["Name Prefix"],
                                desc = L["Add these character(s) to the beginning of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = L["Name Suffix"],
                                desc = L["Add these character(s) to the end of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = L["Events to a Player"],
                                args = {
                                    playerNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["Player Name Format"],
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = L["Color Player Name"],
                                        desc = L["If the player's class is known (e.g. is a raid member), it will be colored."],
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = L["Remove Realm Name"],
                                        desc = L["If the player has a realm name attached to her name, it will be removed."],
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = L["Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["Player Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["Player Name"] .. " - " .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. " - " .. L["Player Name"],
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = L["Events to a NPC"],
                                args = {
                                    npcNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["NPC Name Format"],
                                    },
                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = L["NPC Name Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },
                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC Name|r - The name of the NPC that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["NPC Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["NPC Name"] .. ' - ' .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. ' - ' .. L["NPC Name"],
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        type = "group",
                        name = L["Misc"],
                        args = {
                            headerHots = {
                                order = 1,
                                type = "header",
                                name = L["Miscellaneous Settings"],
                            },
                            enableHots = {
                                order = 2,
                                type = "toggle",
                                name = L["Show HoTs"],
                                desc = L["Show your Heal-Over-Time (HOT) healing."],
                                get = "Options_OutgoingHealing_ShowHots",
                                set = set2,
                            },
                            hideAbsorbedOutgoingHeals = {
                                order = 3,
                                type = "toggle",
                                name = L["Hide Absorbed Heals"],
                                desc = L["If enabled, subtract any healing that was absorbed by a |cffFF0000debuff|r from the total."],
                                get = "Options_OutgoingHealing_HideAbsorbedHealing",
                                set = set2,
                            },

                            headerOverhealing = {
                                order = 10,
                                type = "header",
                                name = L["Overhealing"],
                            },
                            enableOverhealing = {
                                order = 11,
                                type = "toggle",
                                name = L["Show Overhealing"],
                                desc = L["Displays overhealing."],
                                get = "Options_OutgoingHealing_ShowOverhealing",
                                set = set2,
                            },
                            enableOverhealingSubtraction = {
                                order = 12,
                                type = "toggle",
                                name = L["Subtract Overhealing"],
                                desc = L["Subtract the overhealed amount from the Total Amount"],
                                get = "Options_OutgoingHealing_SubtractOverhealing",
                                set = set2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enableOverhealing
                                end,
                            },
                            enableOverhealingFormat = {
                                order = 13,
                                type = "toggle",
                                name = L["Format Overhealing"],
                                desc = L["Splits overhealing into its own section. Example: +43,000 (O: 12,000)"],
                                get = "Options_OutgoingHealing_FormatOverhealing",
                                set = set2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enableOverhealing
                                end,
                            },
                            overhealingPrefix = {
                                order = 14,
                                type = "input",
                                name = L["Overhealing Prefix"],
                                desc = L["Prefix this value to the beginning when displaying an overheal amount.\n\n|cffFF0000Requires:|r |cff798BDDFormat Overhealing|r"],
                                get = "Options_OutgoingHealing_OverhealingPrefix",
                                set = setTextIn2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enableOverhealing
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealingFormat
                                end,
                            },
                            overhealingPostfix = {
                                order = 15,
                                type = "input",
                                name = L["Overhealing Postfix"],
                                desc = L["Prefix this value to the ending when displaying an overheal amount.\n\n|cffFF0000Requires:|r |cff798BDDFormat Overhealing|r"],
                                get = "Options_OutgoingHealing_OverhealingPostfix",
                                set = setTextIn2,
                                disabled = function()
                                    return not x.db.profile.frames.outgoing_healing.enableOverhealing
                                        or not x.db.profile.frames.outgoing_healing.enableOverhealingFormat
                                end,
                            },
                        },
                    },
                },
            },

            critical = {
                name = L["|cffFFFFFFOutgoing|r |cff798BDD(Criticals)|r"],
                type = "group",
                order = 14,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    --[3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = L["Names"],
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = L["The |cffFFFF00Names Settings|r allows you to add the player / npc / spell name to each message. The spam merger will hide player / npc names if different players / npcs were hit."],
                                fontSize = "small",
                            },

                            namePrefix = {
                                order = 2,
                                type = "input",
                                name = L["Name Prefix"],
                                desc = L["Add these character(s) to the beginning of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = L["Name Suffix"],
                                desc = L["Add these character(s) to the end of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = L["Events to a Player"],
                                args = {
                                    playerNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["Player Name Format"],
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = L["Color Player Name"],
                                        desc = L["If the player's class is known (e.g. is a raid member), it will be colored."],
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = L["Remove Realm Name"],
                                        desc = L["If the player has a realm name attached to her name, it will be removed."],
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = L["Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["Player Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["Player Name"] .. " - " .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. " - " .. L["Player Name"],
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = L["Events to a NPC"],
                                args = {
                                    npcNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["NPC Name Format"],
                                    },
                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = L["NPC Name Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },
                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC Name|r - The name of the NPC that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["NPC Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["NPC Name"] .. ' - ' .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. ' - ' .. L["NPC Name"],
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        type = "group",
                        name = L["Misc"],
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = L["Miscellaneous Settings"],
                            },
                            enableAutoAttack_Critical = {
                                order = 1,
                                type = "toggle",
                                name = L["Show Auto Attacks"],
                                desc = L["Show criticals from Auto Attack and Swings. If disabled, they will be displayed as non-critical auto attacks. They will be merged into the Outgoing frame."],
                                get = "Options_Critical_ShowAutoAttack",
                                set = set2,
                            },
                            prefixAutoAttack_Critical = {
                                order = 2,
                                type = "toggle",
                                name = L["Show Auto Attacks (Pre)Postfix"],
                                desc = L["Make Auto Attack and Swing criticals more visible by adding the prefix and postfix."],
                                get = "Options_Critical_PrefixAutoAttack",
                                set = set2,
                            },
                            petCrits = {
                                order = 3,
                                type = "toggle",
                                name = L["Allow Pet Crits"],
                                desc = L["Enable this to see when your pet's abilities critical strike, otherwise disable for less combat text spam."],
                                get = "Options_Critical_ShowPetCrits",
                                set = set2,
                            },
                        },
                    },
                },
            },

            damage = {
                name = L["|cffFFFFFFIncoming Damage|r"],
                type = "group",
                order = 15,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    --[4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },

                            headerAdditionalSettings = {
                                type = "header",
                                order = 10,
                                name = L["Additional Settings"],
                            },
                            iconsEnabledAutoAttack = {
                                order = 11,
                                type = "toggle",
                                name = L["Show Auto Attack Icon"],
                                desc = L["Show icons from Auto Attacks."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = L["Names"],
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = L["The |cffFFFF00Names Settings|r allows you to add the player / npc / spell name to each message. The spam merger will hide player / npc names if different players / npcs were hit."],
                                fontSize = "small",
                            },

                            namePrefix = {
                                order = 2,
                                type = "input",
                                name = L["Name Prefix"],
                                desc = L["Add these character(s) to the beginning of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = L["Name Suffix"],
                                desc = L["Add these character(s) to the end of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = L["Events from a Player"],
                                args = {
                                    playerNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["Player Name Format"],
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = L["Color Player Name"],
                                        desc = L["If the player's class is known (e.g. is a raid member), it will be colored."],
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = L["Remove Realm Name"],
                                        desc = L["If the player has a realm name attached to her name, it will be removed."],
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = L["Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["Player Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["Player Name"] .. " - " .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. " - " .. L["Player Name"],
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = L["Events from a NPC"],
                                args = {
                                    npcNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["NPC Name Format"],
                                    },
                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = L["NPC Name Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },
                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC Name|r - The name of the NPC that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["NPC Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["NPC Name"] .. ' - ' .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. ' - ' .. L["NPC Name"],
                                        },
                                    },
                                },
                            },

                            ENVIRONMENT = {
                                order = 30,
                                type = "group",
                                name = L["Events from the Environment"],
                                args = {
                                    environmentNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["Environment Format"],
                                    },
                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = L["Color Environment"],
                                        desc = L["The name will be colored according to it's environmental type."],
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
                                        name = L["Custom"],
                                        width = "half",
                                    },
                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    environmentSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Type"],
                                        desc = L["The type will be colored according to it's environmental type."],
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
                                        name = L["Custom"],
                                        width = "half",
                                    },
                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDEnvironment|r: Displays 'Environment' as the one who damaged you.\n\n|cff798BDDDamage Types|r: Displays the damage type e.g. "]
                                            .. " |cffFFFF00"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_DROWNING
                                            .. "|r, |cffFFFF00"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_FALLING
                                            .. "|r, |cffFFFF00"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE
                                            .. "|r, |cffFF8000"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_FIRE
                                            .. "|r, |cffFF8000"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_LAVA
                                            .. "|r, |cff4DFF4D"
                                            .. ACTION_ENVIRONMENTAL_DAMAGE_SLIME
                                            .. "|r.",
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["Environment"],
                                            [2] = L["Damage Type"],
                                            [3] = L["Environment"] .. " - " .. L["Damage Type"],
                                            [4] = L["Damage Type"] .. " - " .. L["Environment"],
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        name = L["Misc"],
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = L["Miscellaneous Settings"],
                            },
                            showDodgeParryMiss = {
                                order = 1,
                                type = "toggle",
                                name = L["Show Misses, Dodges, Parries"],
                                desc = L["Displays Dodge, Parry, or Miss when you miss incoming damage."],
                                get = "Options_IncomingDamage_ShowMissTypes",
                                set = set2,
                            },
                            showDamageReduction = {
                                order = 2,
                                type = "toggle",
                                name = L["Show Reductions"],
                                desc = L["Formats incoming damage to show how much was absorbed. The spam merger hides these reduction and effectively disables this option though."],
                                get = "Options_IncomingDamage_ShowReductions",
                                set = set2,
                            },
                        },
                    },
                },
            },

            healing = {
                name = L["|cffFFFFFFIncoming Healing|r"],
                type = "group",
                order = 16,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    --[5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    names = {
                        order = 50,
                        type = "group",
                        name = L["Names"],
                        childGroups = "select",
                        get = getNameFormat,
                        set = setNameFormat,
                        args = {
                            namesDescription = {
                                type = "description",
                                order = 1,
                                name = L["The |cffFFFF00Names Settings|r allows you to add the player / npc / spell name to each message. The spam merger will hide player / npc names if different players / npcs were hit."],
                                fontSize = "small",
                            },

                            namePrefix = {
                                order = 2,
                                type = "input",
                                name = L["Name Prefix"],
                                desc = L["Add these character(s) to the beginning of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            namePostfix = {
                                order = 4,
                                type = "input",
                                name = L["Name Suffix"],
                                desc = L["Add these character(s) to the end of the message."],
                                get = getNameFormatText,
                                set = setNameFormatText,
                            },

                            PLAYER = {
                                order = 10,
                                type = "group",
                                name = L["Events from a Player"],
                                args = {
                                    playerNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["Player Name Format"],
                                    },

                                    enableNameColor = {
                                        order = 2,
                                        type = "toggle",
                                        name = L["Color Player Name"],
                                        desc = L["If the player's class is known (e.g. is a raid member), it will be colored."],
                                    },

                                    removeRealmName = {
                                        order = 3,
                                        type = "toggle",
                                        name = L["Remove Realm Name"],
                                        desc = L["If the player has a realm name attached to her name, it will be removed."],
                                    },

                                    enableCustomNameColor = {
                                        order = 4,
                                        type = "toggle",
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customNameColor = {
                                        order = 5,
                                        type = "color",
                                        name = L["Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    playerSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },

                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },

                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                        width = "half",
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDPlayer Name|r - The name of the player that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["Player Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["Player Name"] .. " - " .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. " - " .. L["Player Name"],
                                        },
                                    },
                                },
                            },

                            NPC = {
                                order = 20,
                                type = "group",
                                name = L["Events from a NPC"],
                                args = {
                                    npcNames = {
                                        order = 1,
                                        type = "header",
                                        name = L["NPC Name Format"],
                                    },
                                    customNameColor = {
                                        order = 2,
                                        type = "color",
                                        name = L["NPC Name Color"],
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    npcSpellNames = {
                                        order = 10,
                                        type = "header",
                                        name = L["Spell Name Format"],
                                    },
                                    enableSpellColor = {
                                        order = 11,
                                        type = "toggle",
                                        name = L["Color Spell Name"],
                                        desc = L["The spell name will be colored according to it's spell school."],
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
                                        name = L["Custom"],
                                        desc = L["Preempt an automatic color with a custom one."],
                                        width = "half",
                                    },
                                    customSpellColor = {
                                        order = 14,
                                        type = "color",
                                        name = L["Color"],
                                        width = "half",
                                        get = getNameFormatColor,
                                        set = setNameFormatColor,
                                    },

                                    nameTypeHeader = {
                                        order = 20,
                                        type = "header",
                                        name = L["Names to display"],
                                    },
                                    nameType = {
                                        type = "select",
                                        order = 21,
                                        name = L["Names to display"],
                                        desc = L["|cff798BDDNone|r - Disabled\n\n|cff798BDDNPC Name|r - The name of the NPC that is affected by the event. Empty when using the spell merger and hitting different targets.\n\n|cff798BDDSpell Name|r - The name of the spell."],
                                        width = "double",
                                        style = "radio",
                                        values = {
                                            [0] = L["None"],
                                            [1] = L["NPC Name"],
                                            [2] = L["Spell Name"],
                                            [3] = L["NPC Name"] .. ' - ' .. L["Spell Name"],
                                            [4] = L["Spell Name"] .. ' - ' .. L["NPC Name"],
                                        },
                                    },
                                },
                            },
                        },
                    },

                    specialTweaks = {
                        order = 60,
                        name = L["Misc"],
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = L["Miscellaneous Settings"],
                            },
                            enableOverHeal = {
                                order = 4,
                                type = "toggle",
                                name = L["Show Overheals"],
                                desc = L["Show the overhealing you receive from other players."],
                                get = "Options_IncomingHealing_ShowOverHealing",
                                set = set2,
                            },
                            hideAbsorbedHeals = {
                                order = 5,
                                type = "toggle",
                                name = L["Hide Absorbed Heals"],
                                desc = L["If enabled, subtract any healing that was absorbed by a |cffFF0000debuff|r from the total."],
                                get = "Options_IncomingHealing_HideAbsorbedHealing",
                                set = set2,
                            },
                            enableSelfAbsorbs = {
                                order = 6,
                                type = "toggle",
                                name = L["Show Absorbs"],
                                desc = L["Shows absorbs you gain from other players."],
                                get = get2,
                                set = set2,
                            },
                            showOnlyMyHeals = {
                                order = 7,
                                type = "toggle",
                                name = L["Show My Heals Only"],
                                desc = L["Shows only the player's healing done to himself or herself."],
                                get = "Options_IncomingHealing_ShowOnlyMyHeals",
                                set = set2,
                            },
                            showOnlyPetHeals = {
                                order = 7,
                                type = "toggle",
                                name = L["Show Pet Heals Too"],
                                desc = L["Will also attempt to show the player pet's healing."],
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

            power = {
                name = L["|cffFFFFFFClass Power|r"],
                type = "group",
                order = 18,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    --[6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Number Formatting"],
                                desc = L["Enables number formatting. This option can be customized in the main |cff00FF00Frames|r options page to be either |cff798BDDAbbreviation|r or |cff798BDDDecimal Marks|r. "],
                                get = get2,
                                set = set2,
                            },

                            frameScrolling = {
                                type = "header",
                                order = 10,
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    specialTweaks = {
                        order = 50,
                        name = L["Misc"],
                        type = "group",
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = L["Miscellaneous Settings"],
                            },
                            showEnergyGains = {
                                order = 1,
                                type = "toggle",
                                name = L["Show Gains"],
                                desc = L["Show instant gains of class resources (e. g. energy, runic power, ...)."],
                                get = "Options_Power_ShowGains",
                                set = set2,
                            },
                            showEnergyType = {
                                order = 3,
                                type = "toggle",
                                name = L["Show Energy Type"],
                                desc = L["Show the type of energy that you are gaining."],
                                get = "Options_Power_ShowEnergyTypes",
                                set = set2,
                            },

                            title1 = {
                                type = "header",
                                order = 10,
                                name = L["Filter Resources"],
                            },
                            title2 = {
                                type = "description",
                                order = 11,
                                name = L["Check the resources that you do not wish to be displayed for your character:"],
                                fontSize = "small",
                            },

                            -- Disable Powers
                            disableResource_MANA = {
                                order = 100,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. MANA .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_RAGE = {
                                order = 101,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. RAGE .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_FOCUS = {
                                order = 102,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. FOCUS .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_ENERGY = {
                                order = 103,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. ENERGY .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },

                            disableResource_RUNES = {
                                order = 104,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. RUNES .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_RUNIC_POWER = {
                                order = 105,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. RUNIC_POWER .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_SOUL_SHARDS = {
                                order = 106,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. SOUL_SHARDS .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_LUNAR_POWER = {
                                order = 107,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. LUNAR_POWER .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },

                            disableResource_CHI = {
                                order = 108,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. CHI .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_HOLY_POWER = {
                                order = 109,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. HOLY_POWER .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_INSANITY_POWER = {
                                order = 110,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. INSANITY .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_MAELSTROM_POWER = {
                                order = 111,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. MAELSTROM_POWER .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },

                            disableResource_ARCANE_CHARGES = {
                                order = 112,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. ARCANE_CHARGES .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_FURY = {
                                order = 113,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. FURY .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                            disableResource_PAIN = {
                                order = 114,
                                type = "toggle",
                                name = L["Disable"] .. " |cff798BDD" .. PAIN .. "|r",
                                get = get2,
                                set = set2,
                                width = "normal",
                            },
                        },
                    },
                },
            },

            procs = {
                name = L["|cffFFFFFFSpecial Effects|r |cff798BDD(Procs)|r"],
                type = "group",
                order = 19,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = "Options_Procs_ShowProcs",
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    --[7] = L["Special Effects (Procs)"],
                                    [8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 20,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 21,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 22,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 23,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons next to your damage."],
                                get = get2,
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = get2,
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },
                },
            },

            loot = {
                name = L["|cffFFFFFFLoot, Currency & Money|r"],
                type = "group",
                order = 20,
                childGroups = "tab",
                args = {

                    frameSettings = {
                        order = 10,
                        type = "group",
                        name = L["Frame"],
                        args = {
                            headerFrameSettings = {
                                type = "header",
                                order = 0,
                                name = L["Frame Settings"],
                            },
                            enabledFrame = {
                                order = 1,
                                type = "toggle",
                                name = L["Enable"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                            },
                            secondaryFrame = {
                                type = "select",
                                order = 2,
                                name = L["Secondary Frame"],
                                desc = L["A frame to forward messages to when this frame is disabled."],
                                values = {
                                    [0] = L["None"],
                                    [1] = L["General"],
                                    [2] = L["Outgoing Damage"],
                                    [3] = L["Outgoing Damage (Criticals)"],
                                    [4] = L["Incoming Damage"],
                                    [5] = L["Incoming Healing"],
                                    [6] = L["Class Power"],
                                    [7] = L["Special Effects (Procs)"],
                                    --[8] = L["Loot, Currency & Money"],
                                    [10] = L["Outgoing Healing"],
                                },
                                get = get2,
                                set = set2,
                                disabled = isFrameItemEnabled,
                            },
                            insertText = {
                                type = "select",
                                order = 3,
                                name = L["Text Direction"],
                                desc = L["Changes the direction that the text travels in the frame."],
                                values = {
                                    ["top"] = L["Down"],
                                    ["bottom"] = L["Up"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            alpha = {
                                order = 4,
                                name = L["Frame Alpha"],
                                desc = L["Sets the alpha of the frame."],
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
                                name = L["Scrollable Frame Settings"],
                            },
                            enableScrollable = {
                                order = 11,
                                type = "toggle",
                                name = L["Enabled"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            scrollableLines = {
                                order = 12,
                                name = L["Number of Lines"],
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
                                name = L["Disable in Combat"],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            frameFading = {
                                type = "header",
                                order = 30,
                                name = L["Fading Text Settings"],
                            },
                            enableCustomFade = {
                                order = 31,
                                type = "toggle",
                                name = L["Use Custom Fade"],
                                width = "full",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            enableFade = {
                                order = 32,
                                type = "toggle",
                                name = L["Enable"],
                                desc = L["Turn off to disable fading all together.\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
                                width = "half",
                                get = get2,
                                set = set2_update,
                                disabled = isFrameUseCustomFade,
                            },
                            fadeTime = {
                                order = 33,
                                name = L["Fade Out Duration"],
                                desc = L["The duration of the fade out animation. |cffFFFF00(Default: |cff798BDD0.3|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                                name = L["Visibility Duration"],
                                desc = L["The duration that the text is shown in the frame. |cffFFFF00(Default: |cff798BDD5|r)|r\n\n|cffFF0000Requires:|r |cffFFFF00Use Custom Fade|r"],
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
                        name = L["Font"],
                        args = {
                            fontSettings = {
                                type = "header",
                                order = 0,
                                name = L["Font Settings"],
                            },
                            font = {
                                type = "select",
                                dialogControl = "LSM30_Font",
                                order = 1,
                                name = L["Font"],
                                desc = L["Set the font of the frame."],
                                values = AceGUIWidgetLSMlists.font,
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontSize = {
                                order = 2,
                                name = L["Font Size"],
                                desc = L["Set the font size of the frame."],
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
                                name = L["Font Outline"],
                                desc = L["Set the font outline."],
                                values = {
                                    ["1NONE"] = L["None"],
                                    ["2OUTLINE"] = L["Outline"],
                                    -- BUG: Setting font to monochrome AND above size 16 will crash WoW
                                    -- http://us.battle.net/wow/en/forum/topic/6470967362
                                    ["3MONOCHROME"] = L["Monochrome"],
                                    ["4MONOCHROMEOUTLINE"] = L["Monochrome Outline"],
                                    ["5THICKOUTLINE"] = L["Thick Outline"],
                                },
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },
                            fontJustify = {
                                type = "select",
                                order = 4,
                                name = L["Justification"],
                                desc = L["Justifies the output to a side."],
                                values = {
                                    ["RIGHT"] = L["Right"],
                                    ["LEFT"] = L["Left"],
                                    ["CENTER"] = L["Center"],
                                },
                                get = get2,
                                set = set2_update,
                            },

                            fontShadowSettings = {
                                type = "header",
                                order = 10,
                                name = L["Font Shadow Settings"],
                            },

                            enableFontShadow = {
                                order = 11,
                                type = "toggle",
                                name = L["Enable Font Shadow"],
                                desc = L["Shows a shadow behind the combat text fonts."],
                                get = get2,
                                set = set2_update,
                                disabled = isFrameItemDisabled,
                            },

                            fontShadowColor = {
                                order = 12,
                                type = "color",
                                hasAlpha = true,
                                name = L["Font Shadow Color"],
                                get = getColor2,
                                set = setColor2_alpha,
                                disabled = isFrameFontShadowDisabled,
                            },

                            fontShadowOffsetX = {
                                order = 13,
                                name = L["Horizontal Offset"],
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
                                name = L["Vertical Offset"],
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
                        name = L["Icons"],
                        args = {
                            headerIconSettings = {
                                type = "header",
                                order = 1,
                                name = L["Icon Settings"],
                            },
                            iconsEnabled = {
                                order = 2,
                                type = "toggle",
                                name = L["Enable Icons"],
                                desc = L["Show icons."],
                                get = "Options_Loot_ShowIcons",
                                set = set2,
                                disabled = isFrameItemDisabled,
                            },
                            iconsSize = {
                                order = 3,
                                name = L["Size"],
                                desc = L["Set the icon size. (Recommended value: 16)"],
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
                                name = L["Show Invisible Icons"],
                                desc = L["When icons are disabled, you can still enable invisible icons to line up text."],
                                get = "Options_Loot_EnableSpacerIcons",
                                set = set2,
                                disabled = isFrameIconSpacerDisabled,
                            },
                        },
                    },

                    fontColors = {
                        order = 40,
                        type = "group",
                        name = L["Colors"],
                        args = {
                            customColors_label = {
                                type = "header",
                                order = 0,
                                name = L["Custom Colors"],
                            },

                            customColor = {
                                order = 2,
                                type = "toggle",
                                name = L["All Text One Color (Override Color Settings)"],
                                width = "double",
                                desc = L["Change all the text in this frame to a specific color."],
                                get = get2,
                                set = set2,
                            },

                            fontColor = {
                                order = 3,
                                type = "color",
                                name = L["Color"],
                                get = getColor2,
                                set = setColor2,
                                hidden = isFrameCustomColorDisabled,
                            },

                            headerEventColor = {
                                type = "header",
                                order = 4,
                                name = L["Colors of the events"],
                            },
                        },
                    },

                    specialTweaks = {
                        order = 50,
                        type = "group",
                        name = L["Misc"],
                        args = {
                            specialTweaks = {
                                type = "header",
                                order = 0,
                                name = L["Miscellaneous Settings"],
                            },
                            showMoney = {
                                order = 1,
                                type = "toggle",
                                name = L["Looted Money"],
                                desc = L["Displays money that you pick up."],
                                get = "Options_Loot_ShowMoney",
                                set = set2,
                            },
                            showItems = {
                                order = 2,
                                type = "toggle",
                                name = L["Looted Items"],
                                desc = L["Displays items that you pick up."],
                                get = "Options_Loot_ShowItems",
                                set = set2,
                            },
                            showCurrency = {
                                order = 3,
                                type = "toggle",
                                name = L["Gained Currency"],
                                desc = L["Displays currency that you gain."],
                                get = "Options_Loot_ShowCurrency",
                                set = set2,
                            },
                            showItemTypes = {
                                order = 4,
                                type = "toggle",
                                name = L["Show Item Types"],
                                desc = L["Formats the looted message to also include the type of item (e.g. Trade Goods, Armor, Junk, etc.)."],
                                get = "Options_Loot_ShowItemTypes",
                                set = set2,
                            },
                            showItemTotal = {
                                order = 5,
                                type = "toggle",
                                name = L["Total Items"],
                                desc = L["Displays how many items you have in your bag."],
                                get = "Options_Loot_ShowItemTotals",
                                set = set2,
                            },
                            showCrafted = {
                                order = 6,
                                type = "toggle",
                                name = L["Crafted Items"],
                                desc = L["Displays items that you crafted."],
                                get = "Options_Loot_ShowCraftedItems",
                                set = set2,
                            },
                            showQuest = {
                                order = 7,
                                type = "toggle",
                                name = L["Quest Items"],
                                desc = L["Displays items that pertain to a quest."],
                                get = "Options_Loot_ShowQuestItems",
                                set = set2,
                            },
                            showPurchased = {
                                order = 8,
                                type = "toggle",
                                name = L["Purchased Items"],
                                desc = L["Displays items that were purchased from a vendor."],
                                get = "Options_Loot_ShowPurchasedItems",
                                set = set2,
                            },
                            colorBlindMoney = {
                                order = 9,
                                type = "toggle",
                                name = L["Color Blind Mode"],
                                desc = L["Displays money using letters G, S, and C instead of icons."],
                                get = "Options_Loot_ShowColorBlindMoney",
                                set = set2,
                            },
                            filterItemQuality = {
                                order = 10,
                                type = "select",
                                name = L["Filter Item Quality"],
                                desc = L["Will not display any items that are below this quality (does not filter Quest or Crafted items)."],
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

    optionsAddon.optionsTable.args.FloatingCombatText = {
        name = L["Floating Combat Text"],
        type = "group",
        order = 1,
        childGroups = "tab",
        args = {
            title2 = {
                order = 0,
                type = "description",
                name = L["The following settings allow you to tweak Blizzard's Floating Combat Text."],
            },

            blizzardFCT = {
                name = L["General"],
                type = "group",
                order = 1,
                disabled = "CVar_BypassCVars",
                args = {
                    enableFloatingCombatText = {
                        order = 1,
                        name = L["Enable Scrolling Combat Text (Self)"],
                        type = "toggle",
                        desc = L["Shows incoming damage and healing done to you. It is also required for a lot of the other events to work (as noted in their descriptions).\n\n|cffFF0000Changing this requires a UI Reload!|r"],
                        width = "double",
                        get = get0,
                        set = set0_update,
                    },

                    enableFCT_Header = {
                        type = "description",
                        order = 2,
                        name = L["|CffFF0000Requires:|r |cff00FF33/reload|r after change"],
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
                        name = L["Appearance"],
                    },

                    floatingCombatTextCombatDamageDirectionalOffset = {
                        order = 5,
                        name = L["Direction Offset"],
                        desc = L["The amount to offset the vertical origin of the directional damage numbers when they appear. (e.g. move them up and down)\n\n0 = Default"],
                        type = "range",
                        min = -20,
                        max = 20,
                        step = 0.1,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatDamageDirectionalScale = {
                        order = 6,
                        name = L["Direction Scale"],
                        desc = L["The amount to scale the distance that directional damage numbers will move as they appear. Damage numbers will just scroll up if this is disabled.\n\n0 = Disabled\n1 = Default\n3.6 = Recommended"],
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
                        name = L["Damage"],
                    },

                    floatingCombatTextCombatDamage = {
                        order = 11,
                        name = L["Show Damage"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_DAMAGE,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatLogPeriodicSpells = {
                        order = 12,
                        name = L["Show DoTs"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatDamageAllAutos = {
                        order = 13,
                        name = L["Show Auto Attacks"],
                        type = "toggle",
                        desc = L["Enable this option if you want to see all auto-attacks."],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextPetMeleeDamage = {
                        order = 14,
                        name = L["Show Pet Melee"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextPetSpellDamage = {
                        order = 15,
                        name = L["Show Pet Spells"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
                        get = get0,
                        set = set0_update,
                    },

                    -- Healing and Absorbs
                    headerHealingAbsorbs = {
                        type = "header",
                        order = 20,
                        name = L["Healing and Absorbs"],
                    },

                    floatingCombatTextCombatHealing = {
                        order = 21,
                        name = L["Show Healing"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextFriendlyHealers = {
                        order = 22,
                        name = L["Show Friendly Healers"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_FRIENDLY_NAMES
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatHealingAbsorbSelf = {
                        order = 23,
                        name = L["Show Absorbs (Self)"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_SELF
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextCombatHealingAbsorbTarget = {
                        order = 24,
                        name = L["Show Absorbs (Target)"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextDamageReduction = {
                        order = 25,
                        name = L["Show Damage Reduction"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_RESISTANCES
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    -- Gains
                    headerGains = {
                        type = "header",
                        order = 30,
                        name = L["Player Gains"],
                    },

                    floatingCombatTextEnergyGains = {
                        order = 31,
                        name = L["Show Energy"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_ENERGIZE
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextPeriodicEnergyGains = {
                        order = 31,
                        name = L["Show Energy (Periodic)"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextComboPoints = {
                        order = 32,
                        name = L["Show Combo Points"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBO_POINTS
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextHonorGains = {
                        order = 33,
                        name = L["Show Honor"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_HONOR_GAINED
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextRepChanges = {
                        order = 34,
                        name = L["Show Rep Changes"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REPUTATION
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    -- Status Effects
                    headerStatusEffects = {
                        type = "header",
                        order = 40,
                        name = L["Status Effects"],
                    },

                    floatingCombatTextDodgeParryMiss = {
                        order = 41,
                        name = L["Show Miss Types"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_DODGE_PARRY_MISS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextAuras = {
                        order = 42,
                        name = L["Show Auras"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_AURAS
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextSpellMechanics = {
                        order = 43,
                        name = L["Show Effects (Mine)"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_TARGET_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextSpellMechanicsOther = {
                        order = 44,
                        name = L["Show Effects (Group)"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextAllSpellMechanics = {
                        order = 45,
                        name = L["Show Effects (All)"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
                        get = get0,
                        set = set0_update,
                    },

                    CombatThreatChanges = {
                        order = 46,
                        type = "toggle",
                        name = L["Show Threat Changes"],
                        desc = L["Enable this option if you want to see threat changes."],
                        get = get0,
                        set = set0_update,
                    },

                    -- Player's Status
                    headerPlayerStatus = {
                        type = "header",
                        order = 50,
                        name = L["Player Status"],
                    },

                    floatingCombatTextCombatState = {
                        order = 52,
                        name = L["Show Combat State"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextLowManaHealth = {
                        order = 53,
                        name = L["Show Low HP/Mana"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_LOW_HEALTH_MANA
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },

                    floatingCombatTextReactives = {
                        order = 54,
                        name = L["Show Reactives"],
                        type = "toggle",
                        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REACTIVES
                            .. L["\n\n|cffFF0000Requires Self Scrolling Combat Text|r"],
                        get = get0,
                        set = set0_update,
                    },
                },
            },

            advancedSettings = {
                name = L["Advanced"],
                type = "group",
                order = 2,
                args = {
                    bypassCVARUpdates = {
                        order = 4,
                        type = "toggle",
                        name = L["Bypass CVar Updates (requires |cffFF0000/reload|r)"],
                        desc = L["Allows you to bypass xCT+'s CVar engine. This option might help if you have FCT enabled, but it disappears after awhile. Once you set your FCT options, enable this.\n\n|cffFF0000Changing this requires a UI Reload!|r"],
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
                        name = L["|CffFF0000Requires:|r |cff00FF33/reload|r after change"],
                        fontSize = "small",
                        width = "normal",
                    },
                },
            },
        },
    }

    optionsAddon.optionsTable.args.spells = {
        name = L["Spam Merger"],
        type = "group",
        childGroups = "tab",
        order = 2,
        args = {
            explanation = {
                type = "description",
                order = 1,
                name = L["Normally all damage / heal events of a spell will result in one message each.\nSo AoE spells like Rain of Fire or Spinning Crane Kick will spam a lot of messages into the xCT frames.\nIf the spam merger is enabled, then the damage events in a configured interval of X seconds of each spell will be merged into one message.\n|cffFF0000Drawback|r: the (merged) message will be delayed by the configured interval!!\nUse an interval of 0 to disable the specific merge."],
            },

            mergeOptions = {
                name = L["Merge Options"],
                type = "group",
                order = 11,
                args = {
                    enableMerger = {
                        order = 2,
                        type = "toggle",
                        name = L["Enable Spam Merger"],
                        get = "Options_SpamMerger_EnableSpamMerger",
                        set = set0_1,
                    },
                    enableMergerDebug = {
                        order = 3,
                        type = "toggle",
                        name = L["Enable Debugging"],
                        desc = L["Adds the spell ID to each message for this session only."],
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
                        name = L["Outgoing Damage / Healing"],
                    },

                    outgoingExplanation = {
                        type = "description",
                        order = 11,
                        name = L["The merge interval for a lot of spells can be set via the 'Class Spells', 'Global Spells/Items' and 'Racial Spells' tabs."],
                    },

                    mergeOutgoingDamageMissesInterval = {
                        order = 23,
                        name = L["Merge-Interval Outgoing Misses"],
                        desc = L["The interval (seconds) in which outgoing full misses, dodges and parries will be merged. Different messages will still be displayed for different types of miss. Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_OutgoingDamageMissesInterval",
                        set = set0_1,
                    },

                    mergeEverythingInterval = {
                        order = 12,
                        name = L["Merge-Interval for other spells"],
                        desc = L["The interval (seconds) in which all other spells will be merged. Certain spells have other intervals, see the tabs for them. Use 0 to disable."],
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
                        name = L["Incoming Damage / Healing"],
                    },

                    mergeIncomingHealingInterval = {
                        order = 21,
                        name = L["Merge-Interval Incoming Healing"],
                        desc = L["The interval (seconds) in which incoming healing will be merged. All healing done by the same person will be merged together! Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_IncomingHealingInterval",
                        set = set0_1,
                    },

                    mergeIncomingDamageInterval = {
                        order = 22,
                        name = L["Merge-Interval Incoming Damage"],
                        desc = L["The interval (seconds) in which incoming damage will be merged. Different messages will still be displayed for different spells. Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_IncomingDamageInterval",
                        set = set0_1,
                    },

                    mergeIncomingMissesInterval = {
                        order = 23,
                        name = L["Merge-Interval Incoming Misses"],
                        desc = L["The interval (seconds) in which incoming full misses, dodges and parries will be merged. Different messages will still be displayed for different types of miss. Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_IncomingMissesInterval",
                        set = set0_1,
                    },

                    petAttacksHeader = {
                        type = "header",
                        order = 30,
                        name = L["Pet Attacks"],
                    },

                    mergePetInterval = {
                        order = 31,
                        name = L["Merge-Interval for ALL Pet Abilities"],
                        desc = L["The interval (seconds) in which ALL pet damage will be merged. It will use your pet's icon instead of an spell icon. Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_PetAttackInterval",
                        set = set0_1,
                    },

                    mergePetColor = {
                        order = 32,
                        type = "color",
                        name = L["Pet Color"],
                        desc = L["Which color do you want the merged pet messages to be?"],
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
              name = L["Merge Vehicle Abilities"],
              desc = L["Merges all of your vehicle abilities together."],
              get = get0_1,
              set = set0_1,
            },

            mergeVehicleColor = {
              order = 39,
              type = 'color',
              name = L["Vehicle Color"],
              get = getColor0_1,
              set = setColor0_1,
            },
            ]]

                    criticalHitsHeader = {
                        type = "header",
                        order = 40,
                        name = L["Critical Hits"],
                    },

                    criticalHitsExplanation = {
                        type = "description",
                        order = 41,
                        name = L["Please choose one:"],
                    },

                    mergeDontMergeCriticals = {
                        order = 42,
                        type = "toggle",
                        name = L["Don't Merge Critical Hits Together"],
                        desc = L["Crits will not get merged in the critical frame, but they will be included in the outgoing total. |cffFFFF00(Default)|r"],
                        get = "Options_SpamMerger_DontMergeCriticals",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    mergeCriticalsWithOutgoing = {
                        order = 43,
                        type = "toggle",
                        name = L["Merge Critical Hits with Outgoing"],
                        desc = L["Crits will be merged, but the total merged amount in the outgoing frame includes crits."],
                        get = "Options_SpamMerger_MergeCriticalsWithOutgoing",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    mergeCriticalsByThemselves = {
                        order = 44,
                        type = "toggle",
                        name = L["Merge Critical Hits by Themselves"],
                        desc = L["Crits will be merged and the total merged amount in the outgoing frame |cffFF0000DOES NOT|r include crits."],
                        get = "Options_SpamMerger_MergeCriticalsByThemselves",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    mergeHideMergedCriticals = {
                        order = 45,
                        type = "toggle",
                        name = L["Hide Merged Criticals"],
                        desc = L["Criticals that have been merged with the Outgoing frame will not be shown in the Critical frame"],
                        get = "Options_SpamMerger_HideMergedCriticals",
                        set = setSpecialCriticalOptions,
                        width = "full",
                    },

                    dispellHeader = {
                        type = "header",
                        order = 50,
                        name = L["Other"],
                    },

                    mergeDispellInterval = {
                        order = 51,
                        name = L["Merge-Interval for Dispells"],
                        desc = L["The interval (seconds) in which dispells are merged together. Only dispells for the same aura (by name) will be merged. Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 5,
                        step = 0.1,
                        get = "Options_SpamMerger_DispellInterval",
                        set = set0_1,
                    },

                    mergeReputationInterval = {
                        order = 52,
                        name = L["Merge-Interval for Reputation"],
                        desc = L["The interval (seconds) in which reputation gains / losses are merged together. Use 0 to disable."],
                        type = "range",
                        min = 0,
                        max = 15,
                        step = 0.1,
                        get = "Options_SpamMerger_ReputationInterval",
                        set = set0_1,
                    },
                },
            },

            classList = {
                name = L["Class Spells"],
                type = "group",
                order = 21,
                childGroups = "select",
                args = {
                    ["DEATHKNIGHT"] = { type = "group", order = 1, name = getColoredClassName("DEATHKNIGHT") },
                    ["DEMONHUNTER"] = { type = "group", order = 2, name = getColoredClassName("DEMONHUNTER") },
                    ["DRUID"] = { type = "group", order = 3, name = getColoredClassName("DRUID") },
                    ["EVOKER"] = { type = "group", order = 4, name = getColoredClassName("EVOKER") },
                    ["HUNTER"] = { type = "group", order = 5, name = getColoredClassName("HUNTER") },
                    ["MAGE"] = { type = "group", order = 6, name = getColoredClassName("MAGE") },
                    ["MONK"] = { type = "group", order = 7, name = getColoredClassName("MONK") },
                    ["PALADIN"] = { type = "group", order = 8, name = getColoredClassName("PALADIN") },
                    ["PRIEST"] = { type = "group", order = 9, name = getColoredClassName("PRIEST") },
                    ["ROGUE"] = { type = "group", order = 10, name = getColoredClassName("ROGUE") },
                    ["SHAMAN"] = { type = "group", order = 11, name = getColoredClassName("SHAMAN") },
                    ["WARLOCK"] = { type = "group", order = 12, name = getColoredClassName("WARLOCK") },
                    ["WARRIOR"] = { type = "group", order = 13, name = getColoredClassName("WARRIOR") },
                },
            },

            globalList = {
                name = L["Global Spells / Items"],
                type = "group",
                order = 22,
                args = {},
            },

            raceList = {
                name = L["Racial Spells"],
                type = "group",
                order = 23,
                args = {},
            },
        },
    }

    optionsAddon.optionsTable.args.spellFilter = {
        name = L["Filters"],
        type = "group",
        order = 3,
        args = {
            filterValues = {
                name = L["Minimal Value Thresholds"],
                type = "group",
                order = 10,
                guiInline = true,
                args = {
                    headerPlayerPower = {
                        order = 0,
                        type = "header",
                        name = L["Incoming Player Power Threshold (Mana, Rage, Energy, etc.)"],
                    },
                    filterPowerValue = {
                        order = 1,
                        type = "input",
                        name = L["Minimum Threshold"],
                        desc = L["The minimal amount of player's power required in order for it to be displayed."],
                        get = "Options_Filter_PlayerPowerMinimumThreshold",
                        set = setNumber2,
                    },

                    headerOutgoingDamage = {
                        order = 10,
                        type = "header",
                        name = L["Outgoing Damage"],
                    },
                    filterOutgoingDamageValue = {
                        order = 11,
                        type = "input",
                        name = L["Minimum Threshold"],
                        desc = L["The minimal amount of damage required in order for it to be displayed."],
                        get = "Options_Filter_OutgoingDamage_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterOutgoingDamageCritEnabled = {
                        order = 12,
                        type = "toggle",
                        name = L["Use other threshold for Crits"],
                        desc = L["Enable a different threshold for outgoing damage criticals."],
                        get = "Options_Filter_OutgoingDamage_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterOutgoingDamageCritValue = {
                        order = 13,
                        type = "input",
                        name = L["Minimum Threshold for Crits"],
                        desc = L["The minimal amount of damage required for a critical in order for it to be displayed."],
                        get = "Options_Filter_OutgoingDamage_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_OutgoingDamage_Critical_UseOwnThreshold()
                        end,
                    },

                    headerOutgoingHealing = {
                        order = 20,
                        type = "header",
                        name = L[L["Outgoing Healing"]],
                    },
                    filterOutgoingHealingValue = {
                        order = 21,
                        type = "input",
                        name = L["Minimum Threshold"],
                        desc = L["The minimal amount of healing required in order for it to be displayed."],
                        get = "Options_Filter_OutgoingHealing_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterOutgoingHealingCritEnabled = {
                        order = 22,
                        type = "toggle",
                        name = L["Use other threshold for Crits"],
                        desc = L["Enable a different threshold for outgoing healing criticals."],
                        get = "Options_Filter_OutgoingHealing_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterOutgoingHealingCritValue = {
                        order = 23,
                        type = "input",
                        name = L["Minimum Threshold for Crits"],
                        desc = L["The minimal amount of healing required for a critical in order for it to be displayed."],
                        get = "Options_Filter_OutgoingHealing_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_OutgoingHealing_Critical_UseOwnThreshold()
                        end,
                    },

                    headerIncomingDamage = {
                        order = 30,
                        type = "header",
                        name = L["Incoming Damage"],
                    },
                    filterIncomingDamageValue = {
                        order = 31,
                        type = "input",
                        name = L["Minimum Threshold"],
                        desc = L["The minimal amount of damage required in order for it to be displayed."],
                        get = "Options_Filter_IncomingDamage_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterIncomingDamageCritEnabled = {
                        order = 32,
                        type = "toggle",
                        name = L["Use other threshold for Crits"],
                        desc = L["Enable a different threshold for incoming damage criticals."],
                        get = "Options_Filter_IncomingDamage_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterIncomingDamageCritValue = {
                        order = 33,
                        type = "input",
                        name = L["Minimum Threshold for Crits"],
                        desc = L["The minimal amount of damage required for a critical in order for it to be displayed."],
                        get = "Options_Filter_IncomingDamage_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_IncomingDamage_Critical_UseOwnThreshold()
                        end,
                    },

                    headerIncomingHealing = {
                        order = 40,
                        type = "header",
                        name = L["Incoming Healing"],
                    },
                    filterIncomingHealingValue = {
                        order = 41,
                        type = "input",
                        name = L["Minimum Threshold"],
                        desc = L["The minimal amount of healing required in order for it to be displayed."],
                        get = "Options_Filter_IncomingHealing_Noncritical_MinimumThreshold",
                        set = setNumber2,
                    },
                    filterIncomingHealingCritEnabled = {
                        order = 42,
                        type = "toggle",
                        name = L["Use other threshold for Crits"],
                        desc = L["Enable a different threshold for incoming healing criticals."],
                        get = "Options_Filter_IncomingHealing_Critical_UseOwnThreshold",
                        set = set0_1,
                    },
                    filterIncomingHealingCritValue = {
                        order = 43,
                        type = "input",
                        name = L["Minimum Threshold for Crits"],
                        desc = L["The minimal amount of healing required for a critical in order for it to be displayed."],
                        get = "Options_Filter_IncomingHealing_Critical_MinimumThreshold",
                        set = setNumber2,
                        hidden = function()
                            return not x:Options_Filter_IncomingHealing_Critical_UseOwnThreshold()
                        end,
                    },

                    headerSpellTracker = {
                        order = 50,
                        type = "header",
                        name = L["Spell History"],
                    },
                    trackSpells = {
                        order = 51,
                        type = "toggle",
                        name = L["Track all Spells"],
                        desc = L["Track all the spells that you've seen. This will make filtering them out easier."],
                        get = "Options_Filter_TrackSpells",
                        set = set0_1,
                    },
                },
            },

            listBuffs = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDBuffs|r"],
                type = "group",
                order = 20,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter out |cff1AFF1ABuff|r auras that your player gains or loses."],
                    },
                    whitelistBuffs = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Filtered auras gains and fades that are |cff1AFF1ABuffs|r will be on a whitelist (opposed to a blacklist)."],
                        get = "Options_Filter_BuffWhitelist",
                        set = set0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Buff to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via Name"],
                        desc = L["The full, case-sensitive name of the |cff1AFF1ABuff|r you want to filter (e.g. 'Power Word: Fortitude')."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cff1AFF1ABuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetBuffHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Buff from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered Buff"],
                        desc = L["Remove the Buff from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listDebuffs = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDDebuffs|r"],
                type = "group",
                order = 30,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter out |cffFF1A1ADebuff|r auras that your player gains or loses."],
                    },
                    whitelistDebuffs = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Filtered auras gains and fades that are |cffFF1A1ADebuffs|r will be on a whitelist (opposed to a blacklist)."],
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Debuff to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via Name"],
                        desc = L["The full, case-sensitive name of the |cff1AFF1ABuff|r you want to filter (e.g. 'Shadow Word: Pain')."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cffFF0000Debuff|r names that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetDebuffHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Debuff from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered Debuff"],
                        desc = L["Remove the Debuff from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listProcs = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDProcs|r"],
                type = "group",
                order = 40,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter out spell |cffFFFF00Procs|r that your player triggers."],
                    },
                    whitelistProcs = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Check for whitelist, uncheck for blacklist."],
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Proc to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via Name"],
                        desc = L["The full, case-sensitive name of the |cff1AFF1AProc|r you want to filter (e.g. 'Power Word: Fortitude')."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cff1AFF1AProcs|r that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetProcHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Proc from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered proc"],
                        desc = L["Remove the proc from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listSpells = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDOutgoing Spells|r"],
                type = "group",
                order = 50,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter |cff71d5ffOutgoing Spells|r that your player does."],
                    },
                    whitelistSpells = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Filtered |cff71d5ffOutgoing Spells|r will be on a whitelist (opposed to a blacklist)."],
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Spell to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via ID"],
                        desc = L["The spell ID of the |cff71d5ffOutgoing Spell|r you want to filter."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cff71d5ffOutgoing Spell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetSpellHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Spell from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered spell"],
                        desc = L["Remove the spell ID from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listItems = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDItems|r"],
                type = "group",
                order = 60,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter out |cff8020FFItems|r that your player collects."],
                    },
                    whitelistItems = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Filtered |cff798BDDItems|r will be on a whitelist (opposed to a blacklist)."],
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Item to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via ID"],
                        desc = L["The ID of the |cff798BDDItem|r you want to filter."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cff798BDDItem|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetItemHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Item from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered Item"],
                        desc = L["Remove the Item from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listDamage = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDIncoming Damage|r"],
                type = "group",
                order = 70,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter out certain |cffFFFF00Spell ID|rs from |cff798BDDIncoming Damage|r to your character."],
                    },
                    whitelistDamage = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Filtered |cff71d5ffIncoming Damage Spells|r will be on a whitelist (opposed to a blacklist)."],
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Spell to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via ID"],
                        desc = L["The Spell ID of the |cff798BDDSpell|r you want to filter."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cff798BDDSpell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetDamageIncomingHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Spell from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered spell"],
                        desc = L["Remove the spell ID from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },

            listHealing = {
                name = L["|cffFFFFFFFilter:|r |cff798BDDIncoming Healing|r"],
                type = "group",
                order = 80,
                guiInline = false,
                args = {
                    description = {
                        order = 0,
                        type = "description",
                        name = L["These options allow you to filter out certain |cffFFFF00Spell ID|rs from |cff798BDDIncoming Healing|r to your character."],
                    },
                    whitelistHealing = {
                        order = 1,
                        type = "toggle",
                        name = L["Whitelist"],
                        desc = L["Filtered |cff71d5ffIncoming Healing Spells|r will be on a whitelist (opposed to a blacklist)."],
                        set = set0_1,
                        get = get0_1,
                    },

                    headerAdd = {
                        order = 10,
                        type = "header",
                        name = L["Add new Spell to filter"],
                    },
                    spellName = {
                        order = 11,
                        type = "input",
                        name = L["Add via ID"],
                        desc = L["The Spell ID of the |cff798BDDSpell|r you want to filter."],
                        set = AddFilteredSpell,
                    },
                    selectTracked = {
                        order = 12,
                        type = "select",
                        name = L["Add via History"],
                        desc = L["A list of |cff798BDDSpell|r IDs that have been seen. |cffFF0000Requires:|r |cff798BDDTrack Spell History|r"],
                        disabled = IsTrackSpellsDisabled,
                        values = GetHealingIncomingHistory,
                        set = AddFilteredSpell,
                    },

                    headerRemove = {
                        order = 20,
                        type = "header",
                        name = L["Remove Spell from filter"],
                    },
                    removeSpell = {
                        order = 21,
                        type = "select",
                        name = L["Remove filtered spell"],
                        desc = L["Remove the spell ID from the config all together."],
                        values = getFilteredSpells,
                        set = removeFilteredSpell,
                    },
                },
            },
        },
    }

    optionsAddon.optionsTable.args.SpellColors = {
        name = L["Spell School Colors"],
        type = "group",
        order = 4,
        args = {
            title = {
                type = "header",
                order = 0,
                name = L["Customize Spell School Colors"],
            },
        },
    }

    optionsAddon.optionsTable.args.Credits = {
        name = L["Credits"],
        type = "group",
        order = 5,
        args = {
            title = {
                type = "header",
                order = 0,
                name = L["Special Thanks"],
            },
            specialThanksList = {
                order = 1,
                type = "description",
                fontSize = "medium",
                name = "|cffAA0000Tukz|r, |cffAA0000Elv|r, |cffFFFF00Affli|r, |cffFF8000BuG|r, |cff8080FFShestak|r, Toludin, Nidra, gnangnan, NitZo, Naughtia, Derap, sortokk, ckaotik, Cecile",
            },

            testerTitle = {
                order = 10,
                type = "header",
                name = L["Beta Testers - Version 3.0.0"],
            },
            userName1 = {
                type = "description",
                order = 11,
                fontSize = "medium",
                name = "Alex, BuG, Kkthnxbye, Azilroka, Prizma, schmeebs, Pat, hgwells, Jaron, Fitzbattleaxe, Nihan, Jaxo, Schaduw, sylenced, kaleidoscope, Killatones, Trokko, Yperia, Edoc, Cazart, Nevah, Refrakt, Thakah, johnis007, Sgt, NitZo, cptblackgb, pollyzoid",
            },

            curseTitle = {
                order = 20,
                type = "header",
                name = L["Beta Testers - Version 4.0.0 (Curse)"],
            },
            userName2 = {
                order = 21,
                type = "description",
                fontSize = "medium",
                name = "CadjieBOOM, Mokal, ShadoFall, alloman, chhld, chizzlestick, egreym, nukme, razrwolf, star182, zacheklund",
            },

            tukuiTitle = {
                order = 30,
                type = "header",
                name = L["Beta Testers - Version 4.0.0 (Tukui)"],
            },
            userName3 = {
                order = 31,
                type = "description",
                fontSize = "medium",
                name = "Affiniti, Badinfluence, BuG, Curdi, Dorkie, Galadeon, HarryDotter, Joebacsi21, Kuron, Mabb22, Narlya, Nihan, Verdell, arzelia, blessed, djouga, fakemessiah, faze, firewall, jatha86, jaydogg10, jlor, lunariongames, stoankold",
            },

            tukuiTitleLegion = {
                order = 40,
                type = "header",
                name = L["Beta Testers - Version 4.3.0+ (Legion)"],
            },
            userName3Legion = {
                order = 41,
                type = "description",
                fontSize = "medium",
                name = "Azazu, Broni, CursedBunny, Daemios, Dajova, Delerionn, dunger, feetss, gesuntight, Homaxz, karamei, Merathilis, re1jo, sammael666, scathee, Tonyleila, Torch, WetU, Znuff, Zylos",
            },

            tukuiTitleBfA = {
                order = 50,
                type = "header",
                name = L["Beta Testers - Version 4.4.0+ (Battle for Azeroth)"],
            },
            userName3BfA = {
                order = 51,
                type = "description",
                fontSize = "medium",
                name = "Toludin",
            },

            githubTitle = {
                type = "header",
                order = 70,
                name = L["GitHub Contributors"],
            },
            githubUsers = {
                order = 71,
                type = "description",
                fontSize = "medium",
                name = "oBusk, BourgeoisM, Witnesscm, Tonyleila, ckaotik, Stanzilla, Torch (behub), vforge, Toludin (BfA Update!), Edarlingen",
            },

            translatorsTitle = {
                type = "header",
                order = 80,
                name = L["zhCN Translators"],
            },
            gitHubUsers = {
                order = 81,
                type = "description",
                fontSize = "medium",
                name = "萌丶汉丶纸 (fredako)",
            },

            translatorsTitle = {
                type = "header",
                order = 90,
                name = L["ruRU Translators"],
            },
            gitHubUsers = {
                order = 91,
                type = "description",
                fontSize = "medium",
                name = "ZamestoTV",
            },

            contactMeTitle = {
                order = 100,
                type = "header",
                name = L["How to contact me"],
            },
            contactMeGithub = {
                order = 101,
                type = "description",
                name = L["Create an issue at GitHub:"] .. " https://github.com/dandruff/xCT",
            },
            contactMeCurseforgeComment = {
                order = 102,
                type = "description",
                name = L["Create a comment on Curseforge:"] .. " https://www.curseforge.com/wow/addons/xct-plus/comments"
            },
            contactMeCurseforgePm = {
                order = 103,
                type = "description",
                name = L["Write me a PM on Curseforge:"] .. " https://www.curseforge.com/members/redaces"
            }
        },
    }

    xo:UpdateOptionsTableSpamMergerSpells()
    xo:UpdateAuraSpellFilter()
    xo:GenerateSpellSchoolColors()
    xo:GenerateColorOptions()
end

-- Gets spammy spells from the database and creates options
function xo:UpdateOptionsTableSpamMergerSpells()
    local function SpamMergerGetSpellInterval(info)
        local spellId = tonumber(info[#info])
        if x.db.profile.spells.merge[spellId] ~= nil and x.db.profile.spells.merge[spellId].interval ~= nil then
            return x.db.profile.spells.merge[spellId].interval
        end
        return xCT_Plus.merges[spellId].interval or 0
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

    for class, specs in pairs(xo.CLASS_NAMES) do
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
    for _, entry in pairs(xCT_Plus.merges) do
        if not xo.CLASS_NAMES[entry.category] then
            if entry.racial_spell then
                table.insert(
                    spamMergerRacialSpellCategories,
                    { category = entry.category, order = entry.categoryOrder }
                )
            else
                table.insert(
                    spamMergerGlobalSpellCategories,
                    { category = entry.category, order = entry.categoryOrder }
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

        -- TODO localization for category.category?

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

        -- TODO localization for rcategory.category?

        -- Create the Category Header
        racetab[rcategory.category] = {
            type = "header",
            order = rcurrentIndex,
            name = rcategory.category,
        }
        spamMergerRacialSpellOrders[rcategory.category] = rcurrentIndex + 1
    end

    -- Update the UI
    for spellID, entry in pairs(xCT_Plus.merges) do
        local name = C_Spell.GetSpellName(spellID)
        if name then
            -- Create a useful description for the spell
            local desc = string.format(
                "%s\n\n|cffFF0000%s|r |cff798BDD%s|r",
                C_Spell.GetSpellDescription(spellID) or L["No Description"],
                L["ID"],
                spellID
            )

            -- TODO C_Spell.GetSpellDescription() sometimes returns "", what to do I do then ?

            local firstSecondaryIdFound = true
            for originalSpellId, replaceSpellId in pairs(xCT_Plus.replaceSpellId) do
                if replaceSpellId == spellID then
                    if firstSecondaryIdFound then
                        desc = desc .. "\n|cffFF0000" .. L["Secondary ID(s)"] .. "|r |cff798BDD" .. originalSpellId
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
            if xo.CLASS_NAMES[entry.category] then
                local index = xo.CLASS_NAMES[entry.category][tonumber(entry.desc) or 0]
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
            elseif entry.racial_spell then
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
function xo:UpdateAuraSpellFilter(specific)
    if not specific or specific == "buffs" then
        optionsAddon.optionsTable.args.spellFilter.args.listBuffs.args.headerFilterList = {
            order = 100,
            name = L["Filtered Buffs |cff798BDD(Uncheck to disable)|r"],
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
                name = L["No buffs have been added to this list yet."],
                type = "description",
            }
        end
    end

    if not specific or specific == "debuffs" then
        optionsAddon.optionsTable.args.spellFilter.args.listDebuffs.args.headerFilterList = {
            order = 100,
            name = L["Filtered Debuffs |cff798BDD(Uncheck to disable)|r"],
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
                name = L["No debuffs have been added to this list yet."],
                type = "description",
            }
        end
    end

    -- Update procs
    if not specific or specific == "procs" then
        optionsAddon.optionsTable.args.spellFilter.args.listProcs.args.headerFilterList = {
            order = 100,
            name = L["Filtered Procs |cff798BDD(Uncheck to disable)|r"],
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
            -- TODO localization for name
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
                name = L["No procs have been added to this list yet."],
                type = "description",
            }
        end
    end

    -- Update spells
    if not specific or specific == "spells" then
        optionsAddon.optionsTable.args.spellFilter.args.listSpells.args.headerFilterList = {
            order = 100,
            name = L["Filtered Spells |cff798BDD(Uncheck to disable)|r"],
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
            if spellID then
                local spellName = C_Spell.GetSpellName(spellID)
                if spellName then
                    local texture = C_Spell.GetSpellTexture(spellID) or x.BLANK_ICON
                    local spellDesc = C_Spell.GetSpellDescription(spellID)
                    updated = true
                    spells[tostring(spellID)] = {
                        name = x:FormatIcon(texture, 16) .. " " .. spellName,
                        desc = string.format(
                            "%s\n\n|cffFF0000%s|r |cff798BDD%s|r",
                            spellDesc,
                            L["ID"],
                            spellID
                        ),
                        type = "toggle",
                        get = isSpellFiltered,
                        set = setIsSpellFiltered,
                    }
                else
                    x:Print("Removing deleted spell", id, "from the outgoing spell filter.")
                    x.db.profile.spellFilter.listSpells[id] = nil
                end
            else
                x:Print("Removing deleted spell", id, "from the outgoing spell filter.")
                x.db.profile.spellFilter.listSpells[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = L["No spells have been added to this list yet."],
                type = "description",
            }
        end
    end

    -- Update items
    if not specific or specific == "items" then
        optionsAddon.optionsTable.args.spellFilter.args.listItems.args.headerFilterList = {
            order = 100,
            name = L["Filtered Items |cff798BDD(Uncheck to disable)|r"],
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
            local itemID = tonumber(string.match(id, "%d+"))
            if itemID then
                local name = C_Item.GetItemNameByID(itemID)
                if name then
                    local texture = C_Item.GetItemIconByID(itemID) or x.BLANK_ICON
                    updated = true
                    spells[id] = {
                        name = x:FormatIcon(texture, 16) .. " " .. name,
                        desc = string.format(
                            "|cffFF0000%s|r |cff798BDD%s|r",
                            L["ID"],
                            id
                        ),
                        type = "toggle",
                        get = isSpellFiltered,
                        set = setIsSpellFiltered,
                    }
                else
                    x:Print("Removing deleted item", id, "from the spell filter.")
                    x.db.profile.spellFilter.listItems[id] = nil
                end
            else
                x:Print("Removing deleted item", id, "from the spell filter.")
                x.db.profile.spellFilter.listItems[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = L["No items have been added to this list yet."],
                type = "description",
            }
        end
    end

    if not specific or specific == "damage" then
        optionsAddon.optionsTable.args.spellFilter.args.listDamage.args.headerFilterList = {
            order = 100,
            name = L["Filtered Incoming Damage |cff798BDD(Uncheck to disable)|r"],
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
            if spellID then
                local spellName = C_Spell.GetSpellName(spellID)
                if spellName then
                    local texture = C_Spell.GetSpellTexture(spellID) or x.BLANK_ICON
                    local spellDesc = C_Spell.GetSpellDescription(spellID)
                    updated = true
                    spells[tostring(spellID)] = {
                        name = x:FormatIcon(texture, 16) .. " " .. spellName,
                        desc = string.format(
                            "%s\n\n|cffFF0000%s|r |cff798BDD%s|r",
                            spellDesc,
                            L["ID"],
                            spellID
                        ),
                        type = "toggle",
                        get = isSpellFiltered,
                        set = setIsSpellFiltered,
                    }
                else
                    x:Print("Removing deleted spell", id, "from the incoming damage spell filter.")
                    x.db.profile.spellFilter.listDamage[id] = nil
                end
            else
                x:Print("Removing deleted spell", id, "from the incoming damage spell filter.")
                x.db.profile.spellFilter.listDamage[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = L["No spells have been added to this list yet."],
                type = "description",
            }
        end
    end

    if not specific or specific == "healing" then
        optionsAddon.optionsTable.args.spellFilter.args.listHealing.args.headerFilterList = {
            order = 100,
            name = L["Filtered Incoming Healing |cff798BDD(Uncheck to disable)|r"],
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
            if spellID then
                local spellName = C_Spell.GetSpellName(spellID)
                if spellName then
                    local texture = C_Spell.GetSpellTexture(spellID) or x.BLANK_ICON
                    local spellDesc = C_Spell.GetSpellDescription(spellID)
                    updated = true
                    spells[tostring(spellID)] = {
                        name = x:FormatIcon(texture, 16) .. " " .. spellName,
                        desc = string.format(
                            "%s\n\n|cffFF0000%s|r |cff798BDD%s|r",
                            spellDesc,
                            L["ID"],
                            spellID
                        ),
                        type = "toggle",
                        get = isSpellFiltered,
                        set = setIsSpellFiltered,
                    }
                else
                    x:Print("Removing deleted spell", id, "from the incoming healing spell filter.")
                    x.db.profile.spellFilter.listHealing[id] = nil
                end
            else
                x:Print("Removing deleted spell", id, "from the incoming healing spell filter.")
                x.db.profile.spellFilter.listHealing[id] = nil
            end
        end

        if not updated then
            spells.noSpells = {
                name = L["No spells have been added to this list yet."],
                type = "description",
            }
        end
    end
end

local isColorOverrideEnabled = function(info)
    local colorName = string.match(info[#info], "(.*)_enabled")
    local category = info[#info - 1]
    if category ~= "SpellColors" then
        category = "Colors"
    end
    return x.db.profile[category][colorName].enabled
end

local setColorOverrideEnabled = function(info, enabled)
    local colorName = string.match(info[#info], "(.*)_enabled")
    local category = info[#info - 1]
    if category ~= "SpellColors" then
        category = "Colors"
    end
    x.db.profile[category][colorName].enabled = enabled
end

local getColorOverride = function(info)
    local colorName = string.match(info[#info], "(.*)_color")
    local category = info[#info - 1]
    if category ~= "SpellColors" then
        category = "Colors"
    end
    return unpack(x.db.profile[category][colorName].color or x.db.profile[category][colorName].default)
end

local setColorOverride = function(info, r, g, b)
    local colorName = string.match(info[#info], "(.*)_color")
    local category = info[#info - 1]
    if category ~= "SpellColors" then
        category = "Colors"
    end
    x.db.profile[category][colorName].color = { r, g, b }
end

local resetColorOverride = function(info)
    local colorName = string.match(info[#info], "(.*)_reset")
    local category = info[#info - 1]
    if category ~= "SpellColors" then
        category = "Colors"
    end
    x.db.profile[category][colorName].color = nil
end

local isColorPickerHidden = function(info)
    local colorName = string.match(info[#info], "(.*)_color") or string.match(info[#info], "(.*)_reset")
    local category = info[#info - 1]
    if category ~= "SpellColors" then
        category = "Colors"
    end
    return not x.db.profile[category][colorName].enabled
end

local function GenerateColorOptionsTable_Entry(colorName, colorSettings, options, index)
    -- Check for nil colors and set them to the default
    if not colorSettings.color or not unpack(colorSettings.color) then
        -- This needs to be a new table apparently
        colorSettings.color = { unpack(colorSettings.default) }
    end

    options[colorName .. "_enabled"] = {
        order = index,
        type = "toggle",
        -- TODO localization for colorSettings.desc
        name = colorSettings.desc,
        get = isColorOverrideEnabled,
        set = setColorOverrideEnabled,
        desc = string.format(
            L["Enable a custom color for |cff798BDD%s|r."],
            colorSettings.desc
        ),
    }
    options[colorName .. "_color"] = {
        order = index + 1,
        type = "color",
        name = L["Color"],
        get = getColorOverride,
        set = setColorOverride,
        desc = string.format(
            L["Change the color for |cff798BDD%s|r."],
            colorSettings.desc
        ),
        hidden = isColorPickerHidden,
    }
    options[colorName .. "_reset"] = {
        order = index + 2,
        type = "execute",
        name = L["Reset"],
        width = "half",
        func = resetColorOverride,
        desc = string.format(
            L["Resets |cff798BDD%s|r back to the default color."],
            colorSettings.desc
        ),
        hidden = isColorPickerHidden,
    }
    options["spacer" .. index] = {
        order = index + 3,
        type = "description",
        fontSize = "small",
        width = "full",
        name = "",
    }
end

-- Generate Colors for each Frame
function xo:GenerateColorOptions()
    local orders = {}
    local parents = {
        general = "general",
        outgoing_damage = "outgoing",
        outgoing_healing = "outgoing_healing",
        outgoing_criticals = "critical",
        incoming_damage = "damage",
        incoming_healing = "healing",
        class_power = "power",
        procs = "procs",
        loot = "loot",
    }

    for colorName, colorSettings in pairs(x.db.profile.Colors) do
        if not orders[colorSettings.category] then
            orders[colorSettings.category] = 10
        end

        if colorSettings.desc then
            if parents[colorSettings.category] then
                GenerateColorOptionsTable_Entry(
                    colorName,
                    colorSettings,
                    optionsAddon.optionsTable.args.Frames.args[parents[colorSettings.category]].args.fontColors.args,
                    orders[colorSettings.category] + 1
                )
                orders[colorSettings.category] = orders[colorSettings.category] + 5
            else
                self:Print("Unknown color category", colorSettings.category, "for color", colorName)
            end
        end
    end
end

function xo:GenerateSpellSchoolColors()
    local options = optionsAddon.optionsTable.args.SpellColors.args
    local settings = x.db.profile.SpellColors
    local index = 10

    local sortedList = {}
    for n in pairs(settings) do
        table.insert(sortedList, tonumber(n))
    end

    table.sort(sortedList)

    local colorName
    local colorSettings
    for _, mask in ipairs(sortedList) do
        colorName = tostring(mask)
        colorSettings = settings[colorName]
        GenerateColorOptionsTable_Entry(colorName, colorSettings, options, index)
        index = index + 5
    end
end

-- A helpful set of tips
local tips = {
    L["On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options."],
    L["If you want to |cff798BDDCombine Frame Outputs|r, disable one of the frames and use the |cffFFFF00Secondary Frame|r option on that frame."],
    L["Only the |cffFFFF00General|r, |cffFF8000Outgoing|r, |cffFFFF00Outgoing (Crits)|r, |cffFF8000Incoming Damage|r and |cffFFFF00Healing|r, and |cffFF8000Class Power|r frames can be abbreviated."],
    L["The |cffFFFF00Hide Config in Combat|r option was added to prevent |cffFFFF00xCT+|r from tainting your UI. It is highly recommended left enabled."],
    L["|cffFFFF00xCT+|r has several different ways it will merge critical hits. You can check them out in the |cffFFFF00Spam Merger|r section."],
    L["Each frame has a |cffFFFF00Misc|r section; select a frame and select the drop-down box to find it."],
    L["If there is a certain |cff798BDDSpell|r, |cff798BDDBuff|r, or |cff798BDDDebuff|r that you don't want to see, consider adding it to a |cff798BDDFilter|r."],
    L["You can change how |cffFFFF00xCT+|r shows you names in the |cffFFFF00Names|r section of most frames."],
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
    if LibStub("AceConfigDialog-3.0").OpenFrames[AddonName] then
        LibStub("AceConfigRegistry-3.0"):NotifyChange(AddonName)
    end
end
