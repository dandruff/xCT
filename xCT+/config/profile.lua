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

-- This file is a static default profile.  After your first profile is created, editing this file will do nothing.
local ADDON_NAME, addon = ...

-- taken from: https://github.com/Gethe/wow-ui-source/blob/e337b8949ffad2876ea0489d8331db2414342d32/FrameXML/CombatFeedback.lua
do -- blizzard hiding globals?
    SCHOOL_MASK_NONE = 0x00
    SCHOOL_MASK_PHYSICAL = 0x01
    SCHOOL_MASK_HOLY = 0x02
    SCHOOL_MASK_FIRE = 0x04
    SCHOOL_MASK_NATURE = 0x08
    SCHOOL_MASK_FROST = 0x10
    SCHOOL_MASK_SHADOW = 0x20
    SCHOOL_MASK_ARCANE = 0x40
end

addon.defaults = {
    profile = {
        hideConfig = true,
        bypassCVars = false,

        blizzardFCT = {
            blizzardHeadNumbers = false, -- enable the head numbers
            enabled = false, -- enable custom font for head numbers
            font = "Condensed Bold (xCT+)",
            fontName = [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondBold.ttf]],
            fontSize = 32, -- unused
            fontOutline = "2OUTLINE", -- unused

            -- CVars
            enableFloatingCombatText = false,
            floatingCombatTextAllSpellMechanics = false,
            floatingCombatTextAuras = false,
            floatingCombatTextCombatDamage = false,
            floatingCombatTextCombatDamageAllAutos = false,
            floatingCombatTextCombatHealing = false,
            floatingCombatTextCombatHealingAbsorbSelf = false,
            floatingCombatTextCombatHealingAbsorbTarget = false,
            floatingCombatTextCombatLogPeriodicSpells = false,
            floatingCombatTextCombatState = false,
            floatingCombatTextComboPoints = false,
            floatingCombatTextDamageReduction = false,
            floatingCombatTextDodgeParryMiss = false,
            floatingCombatTextEnergyGains = false,
            floatingCombatTextFloatMode = false,
            floatingCombatTextFriendlyHealers = false,
            floatingCombatTextHonorGains = false,
            floatingCombatTextLowManaHealth = false,
            floatingCombatTextPeriodicEnergyGains = false,
            floatingCombatTextPetMeleeDamage = false,
            floatingCombatTextPetSpellDamage = false,
            floatingCombatTextReactives = false,
            floatingCombatTextRepChanges = false,
            floatingCombatTextSpellMechanics = false,
            floatingCombatTextSpellMechanicsOther = false,

            floatingCombatTextCombatDamageDirectionalOffset = 1,
            floatingCombatTextCombatDamageDirectionalScale = 1,
        },

        SpellColors = {
            -- Vanilla Schools
            [tostring(SCHOOL_MASK_PHYSICAL)] = {
                enabled = false,
                desc = "Physical",
                default = { 1.00, 1.00, 1.00 },
            },
            [tostring(SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Holy",
                default = { 1.00, 1.00, 0.30 },
            },
            [tostring(SCHOOL_MASK_FIRE)] = {
                enabled = false,
                desc = "Fire",
                default = { 1.00, 0.15, 0.18 },
            },
            [tostring(SCHOOL_MASK_NATURE)] = {
                enabled = false,
                desc = "Nature",
                default = { 0.40, 1.00, 0.40 },
            },
            [tostring(SCHOOL_MASK_FROST)] = {
                enabled = false,
                desc = "Frost",
                default = { 0.30, 0.30, 0.90 },
            },
            [tostring(SCHOOL_MASK_SHADOW)] = {
                enabled = false,
                desc = "Shadow",
                default = { 1.00, 0.70, 1.00 },
            },
            [tostring(SCHOOL_MASK_ARCANE)] = {
                enabled = false,
                desc = "Arcane",
                default = { 0.75, 0.75, 0.75 },
            },

            -- Physical and a Magical
            [tostring(SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE)] = {
                enabled = false,
                desc = "Flamestrike",
                default = { 1.00, 0.58, 0.59 },
            },
            [tostring(SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FROST)] = {
                enabled = false,
                desc = "Froststrike",
                default = { 0.65, 0.65, 0.95 },
            },
            [tostring(SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_ARCANE)] = {
                enabled = false,
                desc = "Spellstrike",
                default = { 0.87, 0.87, 0.87 },
            },
            [tostring(SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_NATURE)] = {
                enabled = false,
                desc = "Stormstrike",
                default = { 0.70, 1.00, 0.70 },
            },
            [tostring(SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_SHADOW)] = {
                enabled = false,
                desc = "Shadowstrike",
                default = { 1.00, 0.85, 1.00 },
            },
            [tostring(SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Holystrike",
                default = { 1.00, 1.00, 0.83 },
            },

            -- Two Magical Schools
            [tostring(SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST)] = {
                enabled = false,
                desc = "Frostfire",
                default = { 0.65, 0.23, 0.54 },
            },
            [tostring(SCHOOL_MASK_FIRE + SCHOOL_MASK_ARCANE)] = {
                enabled = false,
                desc = "Spellfire",
                default = { 0.87, 0.45, 0.47 },
            },
            [tostring(SCHOOL_MASK_FIRE + SCHOOL_MASK_NATURE)] = {
                enabled = false,
                desc = "Firestorm",
                default = { 0.70, 0.58, 0.29 },
            },
            [tostring(SCHOOL_MASK_FIRE + SCHOOL_MASK_SHADOW)] = {
                enabled = false,
                desc = "Shadowflame",
                default = { 1.00, 0.43, 0.59 },
            },
            [tostring(SCHOOL_MASK_FIRE + SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Holyfire (Radiant)",
                default = { 1.00, 0.58, 0.24 },
            },
            [tostring(SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE)] = {
                enabled = false,
                desc = "Spellfrost",
                default = { 0.53, 0.53, 0.83 },
            },
            [tostring(SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE)] = {
                enabled = false,
                desc = "Froststorm",
                default = { 0.35, 0.65, 0.65 },
            },
            [tostring(SCHOOL_MASK_FROST + SCHOOL_MASK_SHADOW)] = {
                enabled = false,
                desc = "Shadowfrost",
                default = { 0.65, 0.50, 0.95 },
            },
            [tostring(SCHOOL_MASK_FROST + SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Holyfrost",
                default = { 0.65, 0.65, 0.60 },
            },
            [tostring(SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE)] = {
                enabled = false,
                desc = "Spellstorm (Astral)",
                default = { 0.58, 0.87, 0.58 },
            },
            [tostring(SCHOOL_MASK_ARCANE + SCHOOL_MASK_SHADOW)] = {
                enabled = false,
                desc = "Spellshadow",
                default = { 0.87, 0.73, 0.87 },
            },
            [tostring(SCHOOL_MASK_ARCANE + SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Divine",
                default = { 0.87, 0.87, 0.53 },
            },
            [tostring(SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW)] = {
                enabled = false,
                desc = "Shadowstorm (Plague)",
                default = { 0.70, 0.85, 0.70 },
            },
            [tostring(SCHOOL_MASK_NATURE + SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Holystorm",
                default = { 0.70, 1.00, 0.35 },
            },
            [tostring(SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY)] = {
                enabled = false,
                desc = "Shadowlight (Twilight)",
                default = { 1.00, 0.85, 0.65 },
            },

            -- Three or More Schools
            [tostring(SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE)] = {
                enabled = false,
                desc = "Elemental",
                default = { 0.57, 0.48, 0.49 },
            },

            [tostring(
                SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW
            )] = {
                enabled = false,
                desc = "Chromatic",
                default = { 0.69, 0.58, 0.65 },
            },

            [tostring(
                SCHOOL_MASK_FIRE
                    + SCHOOL_MASK_FROST
                    + SCHOOL_MASK_ARCANE
                    + SCHOOL_MASK_NATURE
                    + SCHOOL_MASK_SHADOW
                    + SCHOOL_MASK_HOLY
            )] = {
                enabled = false,
                desc = "Magic",
                default = { 0.74, 0.65, 0.59 },
            },

            [tostring(
                SCHOOL_MASK_PHYSICAL
                    + SCHOOL_MASK_FIRE
                    + SCHOOL_MASK_FROST
                    + SCHOOL_MASK_ARCANE
                    + SCHOOL_MASK_NATURE
                    + SCHOOL_MASK_SHADOW
                    + SCHOOL_MASK_HOLY
            )] = {
                enabled = false,
                desc = "Chaos",
                default = { 0.78, 0.70, 0.65 },
            },
        },

        frameSettings = {
            clearLeavingCombat = false,
            showGrid = true,
            showPositions = true,
            frameStrata = "5HIGH",
        },

        megaDamage = {
            thousandSymbol = "|cffFF8000K|r",
            millionSymbol = "|cffFF0000M|r",
            billionSymbol = "|cffFF0000G|r",
            decimalPoint = true,
        },

        frames = {
            general = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "bottom",
                alpha = 100,
                megaDamage = true,

                -- position
                X = 0,
                Y = 224,
                Width = 512,
                Height = 128,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 18,
                fontOutline = "2OUTLINE",
                fontJustify = "CENTER",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                showInterrupts = true,
                showDispells = true,
                showIncomingDispells = true,
                showPartyKills = true,
                showBuffs = true,
                showDebuffs = true,
                showLowManaHealth = true,
                showCombatState = true,
                showRepChanges = true,
                showHonorGains = true,
                showProfessionSkillups = true,
            },

            outgoing = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "bottom",
                alpha = 100,
                megaDamage = true,

                -- position
                X = 400,
                Y = 0,
                Width = 164,
                Height = 512,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 18,
                fontOutline = "2OUTLINE",
                fontJustify = "RIGHT",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- name formatting
                names = {
                    -- appearance
                    namePrefix = " |cffFFFFFF<|r",
                    namePostfix = "|cffFFFFFF>|r",

                    -- events from a player's character
                    PLAYER = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 0,

                        enableNameColor = true,
                        removeRealmName = true,
                        enableCustomNameColor = false,
                        customNameColor = { 1, 1, 1 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from a npc
                    NPC = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 0,

                        enableNameColor = true, -- Always On (Not in Options)
                        removeRealmName = false, -- Always Off (Not in Options)
                        enableCustomNameColor = true, -- Always On (Not in Options)
                        customNameColor = { 0.3, 0, 0.3 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from the envirornment
                    ENVIRONMENT = {
                        nameType = 0,
                    },
                },

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                iconsEnabledAutoAttack = true,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                enableAutoAttack_Outgoing = true, -- OLD: enableAutoAttack
                enablePetAutoAttack_Outgoing = true,

                enableOutDmg = true,
                enablePetDmg = true,
                enableVehicleDmg = true,
                enableDotDmg = true,
                enableImmunes = true,
                enableMisses = true,
                enableAbsorbs = true,
                enablePartialMisses = false,
                showHighestPartialMiss = false,
                enableKillCommand = false,
            },

            critical = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "bottom",
                alpha = 100,
                megaDamage = true,

                -- position
                X = 192,
                Y = 0,
                Width = 256,
                Height = 140,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 24,
                fontOutline = "2OUTLINE",
                fontJustify = "RIGHT",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- name formatting
                names = {

                    -- appearance
                    namePrefix = " |cffFFFFFF<|r",
                    namePostfix = "|cffFFFFFF>|r",

                    -- events from a player's character
                    PLAYER = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 0,

                        enableNameColor = true,
                        removeRealmName = true,
                        enableCustomNameColor = false,
                        customNameColor = { 1, 1, 1 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from a npc
                    NPC = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 0,

                        enableNameColor = true, -- Always On (Not in Options)
                        removeRealmName = false, -- Always Off (Not in Options)
                        enableCustomNameColor = true, -- Always On (Not in Options)
                        customNameColor = { 0.3, 0, 0.3 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from the envirornment
                    ENVIRONMENT = {
                        nameType = 0, -- NOT SHOWN
                    },
                },

                -- critical appearance
                critPrefix = "|cffFF0000*|r",
                critPostfix = "|cffFF0000*|r",

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                enableAutoAttack_Critical = true, -- OLD: showSwing
                prefixAutoAttack_Critical = true, -- OLD: prefixSwing
                petCrits = false,
            },

            outgoing_healing = {
                enabledFrame = false,
                secondaryFrame = 2,
                insertText = "bottom",
                alpha = 100,
                megaDamage = true,

                -- position
                X = 400,
                Y = 0,
                Width = 164,
                Height = 512,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 18,
                fontOutline = "2OUTLINE",
                fontJustify = "RIGHT",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- name formatting
                names = {
                    -- appearance
                    namePrefix = " |cffFFFFFF<|r",
                    namePostfix = "|cffFFFFFF>|r",

                    -- events from a player's character
                    PLAYER = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 0,

                        enableNameColor = true,
                        removeRealmName = true,
                        enableCustomNameColor = false,
                        customNameColor = { 1, 1, 1 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from a npc
                    NPC = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 0,

                        enableNameColor = true, -- Always On (Not in Options)
                        removeRealmName = false, -- Always Off (Not in Options)
                        enableCustomNameColor = true, -- Always On (Not in Options)
                        customNameColor = { 0.3, 0, 0.3 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from the envirornment
                    ENVIRONMENT = {
                        nameType = 0,
                    },
                },

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                iconsEnabledAutoAttack = true,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                enableAutoAttack_Outgoing = true, -- OLD: enableAutoAttack
                enablePetAutoAttack_Outgoing = true,

                enableOutHeal = true,
                enableHots = true,
                enableImmunes = true,
                enableMisses = true,

                enableOverhealing = true,
                enableOverhealingFormat = false,
                enableOverhealingSubtraction = false,
                overhealingPrefix = " |cffFFFFFF(O: ",
                overhealingPostfix = ")|r",
                hideAbsorbedOutgoingHeals = false,
            },

            damage = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "top",
                alpha = 100,
                megaDamage = true,

                -- position
                X = -288,
                Y = -80,
                Width = 448,
                Height = 160,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 18,
                fontOutline = "2OUTLINE",
                fontJustify = "LEFT",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- critical appearance
                critPrefix = "|cffFF0000*|r",
                critPostfix = "|cffFF0000*|r",

                -- name formatting
                names = {

                    -- appearance
                    namePrefix = " |cffFFFFFF<|r",
                    namePostfix = "|cffFFFFFF>|r",

                    -- events from a player's character
                    PLAYER = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 2,

                        enableNameColor = true,
                        removeRealmName = true,
                        enableCustomNameColor = false,
                        customNameColor = { 1, 1, 1 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from a npc
                    NPC = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 2,

                        enableNameColor = true, -- Always On (Not in Options)
                        removeRealmName = false, -- Always Off (Not in Options)
                        enableCustomNameColor = true, -- Always On (Not in Options)
                        customNameColor = { 0.3, 0, 0.3 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from the envirornment
                    ENVIRONMENT = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Environment
                        --   2 = Environment Type
                        --   3 = Both ("Environment - Environment Type")
                        --   4 = Both ("Environment Type - Environment")
                        nameType = 2,

                        enableNameColor = true,
                        enableCustomNameColor = true,
                        removeRealmName = false, -- Always Off (Not in Options)
                        customNameColor = { 0.32, 0.317, 0.1 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },
                },

                -- icons
                iconsEnabled = true,
                iconsSize = 14,
                iconsEnabledAutoAttack = true,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- Special Tweaks
                showDodgeParryMiss = true,
                showDamageReduction = true,
            },

            healing = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "bottom",
                alpha = 100,
                megaDamage = true,

                -- positioon
                X = -288,
                Y = 88,
                Width = 448,
                Height = 144,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 18,
                fontOutline = "2OUTLINE",
                fontJustify = "LEFT",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- name formatting
                names = {

                    -- appearance
                    namePrefix = " |cffFFFFFF<|r",
                    namePostfix = "|cffFFFFFF>|r",

                    -- events from a player's character
                    PLAYER = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 1,

                        enableNameColor = true,
                        removeRealmName = true,
                        enableCustomNameColor = false,
                        customNameColor = { 1, 1, 1 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from a npc
                    NPC = {
                        -- Name Types:
                        --   0 = None
                        --   1 = Source Name
                        --   2 = Spell Name
                        --   3 = Both ("Source Name - Spell Name")
                        --   4 = Both ("Spell Name - Source Name")
                        nameType = 2,

                        enableNameColor = true, -- Always On (Not in Options)
                        removeRealmName = false, -- Always On (Not in Options)
                        enableCustomNameColor = true, -- Always On (Not in Options)
                        customNameColor = { 0.3, 0, 0.3 },

                        enableSpellColor = true,
                        enableCustomSpellColor = false,
                        customSpellColor = { 1, 1, 1 },
                    },

                    -- events from the envirornment
                    ENVIRONMENT = {
                        nameType = 0, -- NOT SHOWN
                    },
                },

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                enableOverHeal = true,
                hideAbsorbedHeals = false,
                enableSelfAbsorbs = true,
                showOnlyMyHeals = false,
                showOnlyPetHeals = false,
            },

            --[[class = {
        enabledFrame = true,
        alpha = 100,

        -- position
        X = 0,
        Y = 64,
        Width = 64,
        Height = 64,

        -- fonts
        font = "Condensed Bold (xCT+)",
        fontSize = 64,
        fontOutline = "2OUTLINE",

        -- font shadow
        enableFontShadow = true,
        fontShadowColor = { 0, 0, 0, 0.6 },
        fontShadowOffsetX = 2,
        fontShadowOffsetY = -2,

        -- font colors
        customColor = false,
        fontColor = { 1.00, 1.00, 1.00 },
      },]]

            power = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "bottom",
                alpha = 100,
                megaDamage = true,

                -- position
                X = 0,
                Y = -16,
                Width = 128,
                Height = 96,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 17,
                fontOutline = "2OUTLINE",
                fontJustify = "CENTER",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                showEnergyGains = true,
                showEnergyType = true,

                -- Generated from "Blizzard Add-On's/Constants.lua"
                disableResource_MANA = false,
                disableResource_RAGE = false,
                disableResource_FOCUS = false,
                disableResource_ENERGY = false,

                disableResource_RUNES = true,
                disableResource_RUNIC_POWER = false,
                disableResource_SOUL_SHARDS = false,
                disableResource_LUNAR_POWER = true,

                disableResource_CHI_POWER = true,
                disableResource_HOLY_POWER = false,
                disableResource_INSANITY_POWER = false,
                disableResource_MAELSTROM_POWER = true,

                disableResource_ARCANE_CHARGES = false,
                disableResource_FURY = false,
                disableResource_PAIN = false,
            },

            procs = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "top",
                alpha = 100,

                -- position
                X = 0,
                Y = -256,
                Width = 294,
                Height = 64,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 24,
                fontOutline = "2OUTLINE",
                fontJustify = "CENTER",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,
            },

            loot = {
                enabledFrame = true,
                secondaryFrame = 0,
                insertText = "top",
                alpha = 100,

                -- position
                X = 0,
                Y = -352,
                Width = 512,
                Height = 128,

                -- fonts
                font = "Condensed Bold (xCT+)",
                fontSize = 18,
                fontOutline = "2OUTLINE",
                fontJustify = "CENTER",

                -- font shadow
                enableFontShadow = true,
                fontShadowColor = { 0, 0, 0, 0.6 },
                fontShadowOffsetX = 2,
                fontShadowOffsetY = -2,

                -- font colors
                customColor = false,
                fontColor = { 1.00, 1.00, 1.00 },

                -- icons
                iconsEnabled = true,
                iconsSize = 16,
                spacerIconsEnabled = true,

                -- scrollable
                enableScrollable = false,
                scrollableLines = 10,
                scrollableInCombat = false,

                -- fading text
                enableCustomFade = true,
                enableFade = true,
                fadeTime = 0.3,
                visibilityTime = 5,

                -- special tweaks
                showItems = true,
                showItemTypes = true,
                showMoney = true,
                showItemTotal = true,
                showCrafted = true,
                showQuest = true,
                showPurchased = false,
                colorBlindMoney = false,
                filterItemQuality = 3,
            },
        },

        spells = {
            enableMerger = true, -- enable/disable spam merger
            mergeEverythingInterval = 0.5,
            mergeIncomingHealingInterval = 5,
            mergeIncomingDamageInterval = 1,
            mergeIncomingMissesInterval = 3,
            mergeOutgoingDamageMissesInterval = 3,
            mergeDispellInterval = 1,
            mergeReputationInterval = 3,
            mergePetInterval = 3,
            mergeVehicle = true,
            mergePetColor = { 1, 0.5, 0 },
            mergeVehicleColor = { 0, 0.5, 1 },

            -- Only one of these can be true
            mergeDontMergeCriticals = true,
            mergeCriticalsWithOutgoing = false,
            mergeCriticalsByThemselves = false,
            mergeHideMergedCriticals = false,

            -- Abbreviate or Groups Settings
            formatAbbreviate = false,
            formatGroups = true,

            combo = {
                DEATHKNIGHT = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                DEMONHUNTER = {
                    [1] = {},
                    [2] = {},
                },

                DRUID = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                    [4] = {},
                },

                EVOKER = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                HUNTER = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                MAGE = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                MONK = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                PALADIN = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                PRIEST = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                ROGUE = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                SHAMAN = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                WARLOCK = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },

                WARRIOR = {
                    [1] = {},
                    [2] = {},
                    [3] = {},
                },
            },

            -- This gets dynamically generated
            merge = {},

            -- yes this is supposed to be blank :P
            -- it is dynamically generated in core.lua
            items = {},
        },

        spellFilter = {
            whitelistBuffs = false,
            whitelistDebuffs = false,
            whitelistSpells = false,
            whitelistProcs = false,
            whitelistItems = false,
            whitelistDamage = false,
            whitelistHealing = false,
            trackSpells = true,

            listSpells = {}, -- Used to filter outgoing spells        (Spell ID)
            listBuffs = {}, -- Used to filter gains/fades of buffs   (Spell Name)
            listDebuffs = {}, -- Used to filter gains/fades of debuffs (Spell Name)
            listProcs = {}, -- Used to filter spell procs            (Proc Name)
            listItems = {}, -- Used to filter Items                  (Item ID)
            listDamage = {}, -- Used to filter incoming damage        (Spell ID)
            listHealing = {}, -- Used to filter incoming healing       (Spell ID)

            -- Minimal Spell Amount
            filterPowerValue = 0,

            filterOutgoingDamageValue = 0,
            filterOutgoingDamageCritEnabled = false,
            filterOutgoingDamageCritValue = 0,

            filterOutgoingHealingValue = 0,
            filterOutgoingHealingCritEnabled = false,
            filterOutgoingHealingCritValue = 0,

            filterIncomingDamageValue = 0,
            filterIncomingDamageCritEnabled = false,
            filterIncomingDamageCritValue = 0,

            filterIncomingHealingValue = 0,
            filterIncomingHealingCritEnabled = false,
            filterIncomingHealingCritValue = 0,
        },

        Colors = {
            -- General
            combatEntering = {
                enabled = false,
                desc = "Entering Combat",
                category = "general",
                default = { 1.00, 0.10, 0.10 },
            },
            combatLeaving = {
                enabled = false,
                desc = "Leaving Combat",
                category = "general",
                default = { 0.10, 1.00, 0.10 },
            },
            interrupts = {
                enabled = false,
                desc = "Interrupts",
                category = "general",
                default = { 1.00, 0.50, 0.00 },
            },
            killingBlow = {
                enabled = false,
                desc = "Killing Blows",
                category = "general",
                default = { 0.20, 1.00, 0.20 },
            },
            buffsGained = {
                enabled = false,
                desc = "Buffs Gained",
                category = "general",
                default = { 1.00, 0.50, 0.50 },
            },
            buffsFaded = {
                enabled = false,
                desc = "Buffs Faded",
                category = "general",
                default = { 0.50, 0.50, 0.50 },
            },
            debuffsGained = {
                enabled = false,
                desc = "Debuffs Gained",
                category = "general",
                default = { 1.00, 0.10, 0.10 },
            },
            debuffsFaded = {
                enabled = false,
                desc = "Debuffs Faded",
                category = "general",
                default = { 0.50, 0.50, 0.50 },
            },
            dispellBuffs = {
                enabled = false,
                desc = "Buffs",
                category = "general",
                default = { 0.00, 1.00, 0.50 },
            },
            dispellDebuffs = {
                enabled = false,
                desc = "Debuffs",
                category = "general",
                default = { 1.00, 0.00, 0.50 },
            },
            dispellStolen = {
                enabled = false,
                desc = "Spell Stolen",
                category = "general",
                default = { 0.31, 0.71, 1.00 },
            },
            lowResourcesHealth = {
                enabled = false,
                desc = "Low Health",
                category = "general",
                default = { 1.00, 0.10, 0.10 },
            },
            lowResourcesMana = {
                enabled = false,
                desc = "Low Mana",
                category = "general",
                default = { 1.00, 0.10, 0.10 },
            },

            -- Outgoing Damage
            melee = {
                enabled = false,
                desc = "Auto Attack Damage",
                category = "outgoing_damage",
                default = { 1.00, 1.00, 1.00 },
            },
            misstypesOut = {
                enabled = false,
                desc = "Missed Attacks",
                category = "outgoing_damage",
                default = { 0.50, 0.50, 0.50 },
            },

            -- Outgoing Healing
            healingOut = {
                enabled = false,
                desc = "Healing",
                category = "outgoing_healing",
                default = { 0.10, 0.75, 0.10 },
            },
            healingOutPeriodic = {
                enabled = false,
                desc = "Healing (Periodic)",
                category = "outgoing_healing",
                default = { 0.10, 0.50, 0.10 },
            },

            -- Outgoing (Criticals)
            meleeCrit = {
                enabled = false,
                desc = "Auto Attack Damage (Critical)",
                category = "outgoing_criticals",
                default = { 1.00, 1.00, 0.00 },
            },
            healingOutCritical = {
                enabled = false,
                desc = "Healing (Critical)",
                category = "outgoing_criticals",
                default = { 0.10, 1.00, 0.10 },
            },

            -- Incoming Damage
            damageTaken = {
                enabled = false,
                desc = "Physical Damage",
                category = "incoming_damage",
                default = { 0.75, 0.10, 0.10 },
            },
            damageTakenCritical = {
                enabled = false,
                desc = "Critical Physical Damage",
                category = "incoming_damage",
                default = { 1.00, 0.10, 0.10 },
            },
            spellDamageTaken = {
                enabled = false,
                desc = "Spell Damage",
                category = "incoming_damage",
                default = { 0.75, 0.30, 0.85 },
            },
            spellDamageTakenCritical = {
                enabled = false,
                desc = "Critical Spell Damage",
                category = "incoming_damage",
                default = { 0.75, 0.30, 0.85 },
            },
            missTypeMiss = {
                enabled = false,
                desc = "Missed",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeDodge = {
                enabled = false,
                desc = "Dodged",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeParry = {
                enabled = false,
                desc = "Parry",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeEvade = {
                enabled = false,
                desc = "Evade",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeDeflect = {
                enabled = false,
                desc = "Deflect",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeImmune = {
                enabled = false,
                desc = "Immune",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeReflect = {
                enabled = false,
                desc = "Reflect",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeResist = {
                enabled = false,
                desc = "Resisted",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeBlock = {
                enabled = false,
                desc = "Blocked",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeAbsorb = {
                enabled = false,
                desc = "Asorbed",
                category = "incoming_damage",
                default = { 0.50, 0.50, 0.50 },
            },
            missTypeResistPartial = {
                enabled = false,
                desc = "Resisted |cff798BDD(Partial)|r",
                category = "incoming_damage",
                default = { 0.75, 0.50, 0.50 },
            },
            missTypeBlockPartial = {
                enabled = false,
                desc = "Blocked |cff798BDD(Partial)|r",
                category = "incoming_damage",
                default = { 0.75, 0.50, 0.50 },
            },
            missTypeAbsorbPartial = {
                enabled = false,
                desc = "Asorbed |cff798BDD(Partial)|r",
                category = "incoming_damage",
                default = { 0.75, 0.50, 0.50 },
            },

            -- Incoming Healing
            healingTaken = {
                enabled = false,
                desc = "Healing",
                category = "incoming_healing",
                default = { 0.10, 0.75, 0.10 },
            },
            healingTakenCritical = {
                enabled = false,
                desc = "Critical Healing",
                category = "incoming_healing",
                default = { 0.10, 1.00, 0.10 },
            },
            healingTakenPeriodic = {
                enabled = false,
                desc = "Periodic Healing",
                category = "incoming_healing",
                default = { 0.10, 0.50, 0.10 },
            },
            healingTakenPeriodicCritical = {
                enabled = false,
                desc = "Critical Periodic Healing",
                category = "incoming_healing",
                default = { 0.10, 0.50, 0.10 },
            },

            -- Class Power
            -- https://github.com/Gethe/wow-ui-source/blob/e337b8949ffad2876ea0489d8331db2414342d32
            -- /AddOns/Blizzard_CombatLog/Blizzard_CombatLog.lua#L1797
            color_MANA = {
                enabled = false,
                desc = MANA,
                category = "class_power",
                default = { 0.00, 0.00, 1.00 },
            },
            color_RAGE = {
                enabled = false,
                desc = RAGE,
                category = "class_power",
                default = { 1.00, 0.00, 0.00 },
            },
            color_FURY = {
                enabled = false,
                desc = FURY,
                category = "class_power",
                default = { 0.788, 0.259, 0.992 },
            },
            color_PAIN = {
                enabled = false,
                desc = PAIN,
                category = "class_power",
                default = { 1.000, 0.612, 0.000 },
            },
            color_FOCUS = {
                enabled = false,
                desc = FOCUS,
                category = "class_power",
                default = { 1.00, 0.50, 0.25 },
            },
            color_RUNES = {
                enabled = false,
                desc = RUNES,
                category = "class_power",
                default = { 0.50, 0.50, 0.50 },
            },
            color_ENERGY = {
                enabled = false,
                desc = ENERGY,
                category = "class_power",
                default = { 1.00, 1.00, 0.00 },
            },
            color_CHI_POWER = {
                enabled = false,
                desc = CHI_POWER,
                category = "class_power",
                default = { 0.71, 1.00, 0.92 },
            },
            color_HOLY_POWER = {
                enabled = false,
                desc = HOLY_POWER,
                category = "class_power",
                default = { 0.95, 0.90, 0.60 },
            },
            color_RUNIC_POWER = {
                enabled = false,
                desc = RUNIC_POWER,
                category = "class_power",
                default = { 0.00, 0.82, 1.00 },
            },
            color_SOUL_SHARDS = {
                enabled = false,
                desc = SOUL_SHARDS,
                category = "class_power",
                default = { 0.50, 0.32, 0.55 },
            },
            color_LUNAR_POWER = {
                enabled = false,
                desc = LUNAR_POWER,
                category = "class_power",
                default = { 0.30, 0.52, 0.90 },
            },
            color_INSANITY_POWER = {
                enabled = false,
                desc = INSANITY_POWER,
                category = "class_power",
                default = { 0.40, 0.00, 0.80 },
            },
            color_MAELSTROM_POWER = {
                enabled = false,
                desc = MAELSTROM_POWER,
                category = "class_power",
                default = { 0.00, 0.50, 1.00 },
            },
            color_ALTERNATE_POWER = {
                enabled = false,
                desc = ALTERNATE_POWER_TEXT,
                category = "class_power",
                default = { 0.10, 0.10, 0.98 },
            },
            color_ARCANE_CHARGES_POWER = {
                enabled = false,
                desc = ARCANE_CHARGES_POWER,
                category = "class_power",
                default = { 0.10, 0.10, 0.98 },
            },
            -- TODO Vigor (Skyriding) & Evoker
            --comboPoints = {
            --    enabled = false,
            --    desc = "Combo Points",
            --    default = { 1.00, 0.82, 0.00 }
            --},
            --comboPointsMax = {
            --    enabled = false,
            --    desc = "Max Combo Points",
            --    default = { 0.00, 0.82, 1.00 }
            --},

            -- Procs
            spellProc = {
                enabled = false,
                desc = "Spell Procs",
                category = "procs",
                default = { 1.00, 0.82, 0.00 },
            },
            spellReactive = {
                enabled = false,
                desc = "Spell Reactive",
                category = "procs",
                default = { 1.00, 0.82, 0.00 },
            },

            -- Loot, Currency & Money
            honorGains = {
                enabled = false,
                desc = "Honor Gained",
                category = "loot",
                default = { 0.10, 0.10, 1.00 },
            },
            reputationGain = {
                enabled = false,
                desc = "Reputation Gained",
                category = "loot",
                default = { 0.10, 0.10, 1.00 },
            },
            reputationLoss = {
                enabled = false,
                desc = "Reputation Lost",
                category = "loot",
                default = { 1.00, 0.10, 0.10 },
            },
        },
    },
}
