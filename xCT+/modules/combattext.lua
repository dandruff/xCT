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

local _, addon = ...

-- Shorten my handle
local x = addon.engine

-- returns a string with the first character in upper case
local function utf8_fc_upper(source)
    return string.utf8upper(string.utf8sub(source, 1, 1)) .. string.utf8sub(source, 2)
end

local function table_clone(source)
    local clone = {}
    for k,v in pairs(source) do
        clone[k] = v
    end
    return setmetatable(clone, getmetatable(source))
end

x.locale = GetLocale()

local L_AUTOATTACK = C_Spell.GetSpellName(6603)
local L_KILLCOMMAND = C_Spell.GetSpellName(34026)

--[=====================================================[
 Power Type Definitions, see https://wowpedia.fandom.com/wiki/Enum.PowerType
--]=====================================================]
x.POWER_LOOKUP = {
    [0] = "MANA",
    [1] = "RAGE",
    [2] = "FOCUS",
    [3] = "ENERGY",
    [4] = "COMBO_POINTS",
    [5] = "RUNES",
    [6] = "RUNIC_POWER",
    [7] = "SOUL_SHARDS",
    [8] = "LUNAR_POWER",
    [9] = "HOLY_POWER",
    [10] = "ALTERNATE_POWER_INDEX",
    [11] = "MAELSTROM",
    [12] = "CHI",
    [13] = "INSANITY",
    [14] = "BURNING_EMBERS",
    [15] = "DEMONIC_FURY",
    [16] = "ARCANE_CHARGES",
    [17] = "FURY",
    [18] = "PAIN",
    [25] = "VIGOR",
}

--[=====================================================[
 String Formatters
--]=====================================================]
-- TODO: Remove old loot pattern
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
-- "You create: |cffa335ee|Hitem:124515::::::::100:254:4:3::530:::|h[Talisman of the Master Tracker]|h|r"
--local msg = "|cff1eff00|Hitem:108840:0:0:0:0:0:0:443688319:90:0:0:0|h[Warlords Intro Zone PH Mail Helm]|h|r"
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"

local format_honor = string.gsub(COMBAT_TEXT_HONOR_GAINED, "%%s", "+%%s")

local format_crafted = (LOOT_ITEM_CREATED_SELF:gsub("%%.*", "")) -- "You create: "
if x.locale == "koKR" then
    format_crafted = (LOOT_ITEM_CREATED_SELF:gsub("%%.+ ", ""))
end
local format_looted = (LOOT_ITEM_SELF:gsub("%%.*", "")) -- "You receive loot: "
local format_pushed = (LOOT_ITEM_PUSHED_SELF:gsub("%%.*", "")) -- "You receive item: "
local format_currency_single = (CURRENCY_GAINED:gsub("%%s", "(.+)")) -- "You receive currency: (.+)."
local format_currency_multiple = (CURRENCY_GAINED_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")) -- "You receive currency: (.+) x(%d+)."

--[=====================================================[
 AddOn:UpdatePlayer()
    Updates important information about the player we
  need in order to correctly show combat text events.
--]=====================================================]
function x:UpdatePlayer()
    -- Set the Player's Current Playing Unit
    if UnitHasVehicleUI("player") then
        x.player.unit = "vehicle"
    else
        x.player.unit = "player"
    end

    CombatTextSetActiveUnit(x.player.unit)

    -- Set Player's Information
    local activeTalentGroup = GetActiveSpecGroup(false, false)
    x.player.spec = GetSpecialization(false, false, activeTalentGroup)
end

--[=====================================================[
 Message Formatters
 TODO remove or sync them mit dem Spam Merger!
--]=====================================================]
local xCTFormat = {}

function xCTFormat:SPELL_HEAL(outputFrame, spellId, amount, overhealing, critical, args, frameSettings)
    local outputColor, message = "healingOut"

    -- Format Criticals and also abbreviate values
    if critical then
        outputColor = "healingOutCritical"
        message = x:Options_Global_FormatCritical(x:Abbreviate(amount, "critical"))
    else
        message = x:Abbreviate(amount, outputFrame)
    end

    -- Show and Format Overhealing values
    if overhealing > 0 and x:Options_OutgoingHealing_FormatOverhealing() then
        overhealing = x:Abbreviate(overhealing, outputFrame)
        message = message .. x:Options_OutgoingHealing_FormatOverhealingAmount(overhealing)
    end

    -- Add names
    message = message .. x:formatName(args, frameSettings.names)

    -- Add Icons
    message = x:GetSpellTextureFormatted(spellId, message, frameSettings)

    x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:SPELL_PERIODIC_HEAL(outputFrame, spellId, amount, overhealing, critical, args, frameSettings)
    local outputColor, message = "healingOutPeriodic"

    -- Format Criticals and also abbreviate values
    if critical then
        message = x:Options_Global_FormatCritical(x:Abbreviate(amount, "critical"))
    else
        message = x:Abbreviate(amount, outputFrame)
    end

    -- Show and Format Overhealing values
    if overhealing > 0 and x:Options_OutgoingHealing_FormatOverhealing() then
        overhealing = x:Abbreviate(overhealing, outputFrame)
        message = message .. x:Options_OutgoingHealing_FormatOverhealingAmount(overhealing)
    end

    -- Add names
    message = message .. x:formatName(args, frameSettings.names)

    -- Add Icons
    message = x:GetSpellTextureFormatted(spellId, message, frameSettings)

    x:AddMessage(outputFrame, message, outputColor)
end

--[=====================================================[
 Capitalize Locales
--]=====================================================]
local unsupportedLocales = { zhCN = true, koKR = true, zhTW = true }

local XCT_STOLE
local XCT_KILLED
local XCT_DISPELLED

if unsupportedLocales[x.locale] then
    XCT_STOLE = ACTION_SPELL_STOLEN
    XCT_KILLED = ACTION_PARTY_KILL
    XCT_DISPELLED = ACTION_SPELL_DISPEL
else
    XCT_STOLE = utf8_fc_upper(ACTION_SPELL_STOLEN)
    XCT_KILLED = utf8_fc_upper(ACTION_PARTY_KILL)
    XCT_DISPELLED = utf8_fc_upper(ACTION_SPELL_DISPEL)
end

--[=====================================================[
 Delayed message for loot, to get the correct "totals" of the item in your bag
--]=====================================================]
function x:AddLootMessageDelayed(item)
    local totalCount = C_Item.GetItemCount(item.id)

    local message = item.message
    if totalCount > 1 then
        message = message .. string.format(" |cffFFFF00(%s)|r", totalCount)
    end

    x:AddMessage("loot", message, { item.r, item.g, item.b })
end

-- =====================================================
--                  Format Name Things
-- =====================================================

-- Changes a color table into a hex string

local function hexNameColor(t)
    if type(t) == "string" then
        return "ff" .. t
    elseif not t then
        return "ffFFFFFF"
    elseif t.colorStr then -- Support Blizzard's raid colors
        return t.colorStr
    end
    return string.format(
        "ff%2X%2X%2X",
        math.floor(t[1] * 255 + 0.5),
        math.floor(t[2] * 255 + 0.5),
        math.floor(t[3] * 255 + 0.5)
    )
end

-- Checks the options you provide and outputs the correctly formatted name
local function formatNameHelper(name, color)
    if color then
        return "|c" .. hexNameColor(color) .. name .. "|r"
    end

    return "|cffFFFFFF" .. name .. "|r"
end

-- Format Handlers for name
local nameFormatter = {}
nameFormatter.controllerName = function(args, settings, useSource)
    -- [1] = Source/Destination Name
    local name = args.controllerName
            or useSource and args.sourceName
            or args.destName

    if not name then
        return ""
    end

    if settings.removeRealmName then
        name = string.match(name, "(.*)-.*") or name
    end

    local color
    if settings.enableNameColor then
        if settings.enableCustomNameColor then
            color = settings.customNameColor
        elseif args.prefix == "ENVIRONMENTAL" then
            -- todo spam merger
            color = x.spellColors[args.school or args.spellSchool or 1]
        else
            -- todo guid in the spam merger
            local guid = useSource and args.sourceGUID or args.destGUID
            if guid and string.match(guid, "^Player") then
                local _, class = GetPlayerInfoByGUID(guid)
                color = RAID_CLASS_COLORS[class or 0]
            end
        end
    end

    return formatNameHelper(name, color)
end

nameFormatter.spellName = function(args, settings, useSource)
    -- [2] = Spell Name
    if not args.spellName then
        return ""
    end

    local color
    if settings.enableNameColor then
        if settings.enableCustomNameColor then
            color = settings.customNameColor
        else
            -- NOTE: I don't think we want the spell school of the spell
            --       being cast. We want the spell school of the damage
            --       being done. That said, if you want to change it so
            --       that the spell name matches the type of spell it
            --       is, and not the type of damage it does, change
            --       "args.school" to "args.spellSchool".
            color = x.GetSpellSchoolColor(args.school or args.spellSchool)
        end
    end

    return formatNameHelper(args.spellName, color)
end

nameFormatter.controllerNameSpellName = function(args, settings, useSource)
    -- [3] = Source/Destination Name - Spell Name
    if not args.hideCaster then
        local controllerName = nameFormatter.controllerName(args, settings, useSource)
        if controllerName and controllerName ~= "" then
            return controllerName .. " - " .. nameFormatter.spellName(args, settings, useSource)
        end
    end

    return nameFormatter.spellName(args, settings, useSource)
end

nameFormatter.spellNameControllerName = function(args, settings, useSource)
    -- [4] = Spell Name - Source/Destination Name
    if not args.hideCaster then
        local controllerName = nameFormatter.controllerName(args, settings, useSource)
        if controllerName and controllerName ~= "" then
            return nameFormatter.spellName(args, settings, useSource) .. " - " .. controllerName
        end
    end

    return nameFormatter.spellName(args, settings, useSource)
end

-- Check to see if the name needs for be formatted, if so, handle all the logistics
function x:formatName(args, frameNameSettings, useSource)
    -- "PLAYER", "ENVIRONMENT", "NPC", ...
    local controller = args.controller
            or useSource and args:GetSourceController()
            or args:GetDestinationController()

    local eventType = frameNameSettings[controller]

    -- If we have a valid event type that we can handle
    if eventType and eventType.nameType > 0 then
        local message

        if eventType.nameType == 1 then
            message = nameFormatter.controllerName(args, eventType, useSource)
        elseif eventType.nameType == 2 then
            message = nameFormatter.spellName(args, eventType, useSource)
        elseif eventType.nameType == 3 then
            message = nameFormatter.controllerNameSpellName(args, eventType, useSource)
        elseif eventType.nameType == 4 then
            message = nameFormatter.spellNameControllerName(args, eventType, useSource)
        else
            return ""
        end

        if message and message ~= "" then
            return frameNameSettings.namePrefix .. message .. frameNameSettings.namePostfix
        end
    end

    return ""
end

-- =====================================================
--           Quick Partial Name Formatter
-- =====================================================

local missTypeColorLookup = {
    ["MISS"] = "missTypeMiss",
    ["DODGE"] = "missTypeDodge",
    ["PARRY"] = "missTypeParry",
    ["EVADE"] = "missTypeEvade",
    ["IMMUNE"] = "missTypeImmune",
    ["DEFLECT"] = "missTypeDeflect",
    ["REFLECT"] = "missTypeReflect",
}

local PARTIAL_MISS_FORMATTERS = {
    ["absorbed"] = " |c%s" .. (TEXT_MODE_A_STRING_RESULT_ABSORB:gsub("%%d", "%%s")) .. "|r", -- |c%s(%s Absorbed)|r
    ["blocked"] = " |c%s" .. (TEXT_MODE_A_STRING_RESULT_BLOCK:gsub("%%d", "%%s")) .. "|r", -- |c%s(%s Blocked)|r
    ["resisted"] = " |c%s" .. (TEXT_MODE_A_STRING_RESULT_RESIST:gsub("%%d", "%%s")) .. "|r", -- |c%s(%s Resisted)|r
}

local PARTIAL_MISS_COLORS = {
    ["absorbed"] = "missTypeAbsorbPartial",
    ["blocked"] = "missTypeBlockPartial",
    ["resisted"] = "missTypeResistPartial",
}

local FULL_MISS_COLORS = {
    ["absorbed"] = "missTypeAbsorb",
    ["blocked"] = "missTypeBlock",
    ["resisted"] = "missTypeResist",
}

local function GetPartialMiss(args, settings, outgoingFrame)
    local blocked, absorbed, resisted = args.blocked or 0, args.absorbed or 0, args.resisted or 0
    if blocked > 0 or absorbed > 0 or resisted > 0 then
        -- Show only the highest partial miss
        if settings.showHighestPartialMiss then
            local maxType, color
            if blocked > absorbed then
                if blocked > resisted then
                    maxType = "blocked"
                else
                    maxType = "resisted"
                end
            else
                if absorbed > resisted then
                    maxType = "absorbed"
                else
                    maxType = "resisted"
                end
            end

            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS[maxType] or FULL_MISS_COLORS[maxType])
            )
            return true,
                string.format(PARTIAL_MISS_FORMATTERS[maxType], color, x:Abbreviate(args[maxType], outgoingFrame))
        end

        -- Show All the partial misses that exsist
        local message, color = ""
        if absorbed > 0 then
            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS.absorbed or FULL_MISS_COLORS.absorbed)
            )
            message = message
                .. string.format(PARTIAL_MISS_FORMATTERS.absorbed, color, x:Abbreviate(absorbed, outgoingFrame))
        end

        if blocked > 0 then
            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS.blocked or FULL_MISS_COLORS.blocked)
            )
            message = message
                .. string.format(PARTIAL_MISS_FORMATTERS.blocked, color, x:Abbreviate(blocked, outgoingFrame))
        end

        if resisted > 0 then
            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS.resisted or FULL_MISS_COLORS.resisted)
            )
            message = message
                .. string.format(PARTIAL_MISS_FORMATTERS.resisted, color, x:Abbreviate(resisted, outgoingFrame))
        end

        return true, message
    else
        return false, ""
    end
end

-- =====================================================
--               The New Combat Handlers
-- =====================================================
local EventHandlers = {}

-- Outgoing healing
EventHandlers.OutgoingHealing = function(args)
    local isHoT = args.prefix == "SPELL_PERIODIC"

    -- Keep track of spells that go by
    if x:Options_Filter_TrackSpells() then
        x.spellCache.spells[args.spellId] = true
    end

    -- Check to see if this is a HoT
    if isHoT and not x:Options_OutgoingHealing_ShowHots() then
        return
    end

    -- Filter Outgoing Healing Spell
    if x:Options_Filter_HideSpell(args.spellId) then
        return
    end

    local amount, amountOverhealing = args.amount, args.overhealing

    -- Filter Overhealing
    if x:Options_IncomingHealing_ShowOverHealing() then
        if x:Options_OutgoingHealing_SubtractOverhealing() then
            amount = amount - amountOverhealing
        end
    else
        amount = amount - amountOverhealing
        amountOverhealing = 0
    end

    if not x:Options_OutgoingHealing_HideAbsorbedHealing() and args.absorbed and args.absorbed > 0 then
        amount = amount + args.absorbed
    end

    if amount <= 0 then
        return
    end

    -- Figure out which frame and color to output
    local outputFrame, outputColor = "outgoing_healing", "healingOut"
    if args.critical then
        outputFrame = "critical"
        outputColor = "healingOutCritical"
    end

    -- HoTs only have one color
    if isHoT then
        outputColor = "healingOutPeriodic"
    end

    -- Condensed Critical Merge
    local spamMergerInterval = x:Options_SpamMerger_SpellInterval(args.spellId)
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        if args.critical then
            if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                x:AddSpamMessage(
                    outputFrame,
                    args.spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    {
                        useSource = false,
                        spellName = args.spellName,
                        spellSchool = args.spellSchool,
                        controller = args:GetDestinationController(),
                        controllerName = args.destName,
                        outputFormat = "+%s",
                        critical = args.critical
                    }
                )
                return
            elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                x:AddSpamMessage(
                    "outgoing_healing",
                    args.spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    {
                        useSource = false,
                        spellName = args.spellName,
                        spellSchool = args.spellSchool,
                        controller = args:GetDestinationController(),
                        controllerName = args.destName,
                        outputFormat = "+%s",
                        critical = args.critical
                    }
                )
            elseif x:Options_SpamMerger_HideMergedCriticals() then
                x:AddSpamMessage(
                    "outgoing_healing",
                    args.spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    {
                        useSource = false,
                        spellName = args.spellName,
                        spellSchool = args.spellSchool,
                        controller = args:GetDestinationController(),
                        controllerName = args.destName,
                        outputFormat = "+%s",
                        critical = args.critical
                    }
                )
                return
            end
        else
            x:AddSpamMessage(
                outputFrame,
                args.spellId,
                amount,
                outputColor,
                spamMergerInterval,
                {
                    useSource = false,
                    spellName = args.spellName,
                    spellSchool = args.spellSchool,
                    controller = args:GetDestinationController(),
                    controllerName = args.destName,
                    outputFormat = "+%s",
                    critical = args.critical
                }
            )
            return
        end
    end

    if x:Options_Filter_OutgoingHealing_HideEvent(amount, args.critical) then
        return
    end

    -- Get the settings for the correct output frame
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Format the message correctly
    if args.event == "SPELL_PERIODIC_HEAL" then
        xCTFormat:SPELL_PERIODIC_HEAL(
            outputFrame,
            args.spellId,
            amount,
            amountOverhealing,
            args.critical,
            args,
            frameSettings
        )
    elseif args.event == "SPELL_HEAL" then
        xCTFormat:SPELL_HEAL(outputFrame, args.spellId, amount, amountOverhealing, args.critical, args, frameSettings)
    else
        x:Print("Please report: unhandled _HEAL event", args.event)
    end
end

-- Outgoing damage
EventHandlers.OutgoingDamage = function(args)
    local spellId, isEnvironmental, isSwing, isAutoShot, isDoT =
        args.spellId,
        args.prefix == "ENVIRONMENTAL",
        args.prefix == "SWING",
        args.spellId == 75,
        args.prefix == "SPELL_PERIODIC"

    -- Keep track of spells that go by (Don't track Swings or Environmental damage)
    if not isEnvironmental and not isSwing and x:Options_Filter_TrackSpells() then
        x.spellCache.spells[spellId] = true
    end

    if not x:Options_Outgoing_ShowDamage() then
        return
    end

    -- Check to see if this is a HoT
    if isDoT and not x:Options_Outgoing_ShowDots() then
        return
    end

    -- Filter Outgoing Damage Spell
    if x:Options_Filter_HideSpell(spellId) then
        return
    end

    if isSwing and not args:IsSourceMyPet() and not args:IsSourceMyVehicle() then
        if args.critical and not x:Options_Outgoing_ShowAutoAttack() then
            return
        end

        if not args.critical and not x:Options_Critical_ShowAutoAttack() then
            return
        end
    end

    local amount = args.amount or 0
    if x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage() then
        -- Its a partial absorb, add it to the amount
        amount = amount + (args.absorbed or 0)
    end

    if amount <= 0 then
        return
    end

    local outputFrame = "outgoing"

    -- Check to see if my pet is doing things
    if args:IsSourceMyPet() and (not x:Options_Outgoing_ShowKillCommandAsPlayerDamage() or spellId ~= 34026) then
        if not x:Options_Outgoing_ShowPetDamage() then
            return
        end

        if isSwing and not x:Options_Outgoing_ShowPetAutoAttack() then
            return
        end

        local spamMergerInterval = x:Options_SpamMerger_PetAttackInterval()
        if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            local icon = x:GetPetTexture() or ""
            x:AddSpamMessage(
                outputFrame,
                icon, -- use the pet icon as spell ID so that EVERYTHING from it will be merged together
                amount,
                x.db.profile.spells.mergePetColor,
                spamMergerInterval,
                {
                    useSource = false,
                    -- We switch to "auto attack" so that each spell of the pet is merged together and displayed as "auto attack"
                    spellName = spellId == 34026 and L_KILLCOMMAND or L_AUTOATTACK,
                    spellSchool = args.spellSchool,
                    controller = args:GetDestinationController(),
                    controllerName = args.destName,
                    critical = args.critical
                }
            )
            return
        end

        if not x:Options_Critical_ShowPetCrits() then
            args.critical = nil -- stupid spam fix for hunter pets
        end

        if isSwing then
            spellId = 0 -- this will get fixed later
        end
    end

    if args:IsSourceMyVehicle() then
        if not x:Options_Outgoing_ShowVehicleDamage() then
            return
        end
        if isSwing and not x:Options_Outgoing_ShowPetAutoAttack() then
            return
        end -- for BM's second pet, Hati
        if not x:Options_Critical_ShowPetCrits() then
            args.critical = nil -- stupid spam fix for hunter pets
        end
        if isSwing then
            spellId = 0 -- this will get fixed later
        end
    end

    -- Check for Critical Swings
    if args.critical then
        if (isSwing or isAutoShot) and x:Options_Critical_ShowAutoAttack() then
            outputFrame = "critical"
        elseif not isSwing and not isAutoShot then
            outputFrame = "critical"
        end
    end

    -- Lookup the color
    local outputColorType
    if isSwing or isAutoShot then
        outputColorType = args.critical and "meleeCrit" or "melee"
    end

    local outputColor = x.GetSpellSchoolColor(args.spellSchool, outputColorType)

    local spamMergerInterval = x:Options_SpamMerger_SpellInterval(spellId)
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        if isSwing or isAutoShot then
            if outputFrame == "critical" then
                if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                    x:AddSpamMessage(
                        outputFrame,
                        spellId,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        {
                            useSource = false,
                            spellName = L_AUTOATTACK,
                            spellSchool = args.spellSchool,
                            controller = args:GetDestinationController(),
                            controllerName = args.destName,
                            critical = args.critical
                        }
                    )
                    return
                elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellId,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        {
                            useSource = false,
                            spellName = L_AUTOATTACK,
                            spellSchool = args.spellSchool,
                            controller = args:GetDestinationController(),
                            controllerName = args.destName,
                            critical = args.critical
                        }
                    )
                elseif x:Options_SpamMerger_HideMergedCriticals() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellId,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        {
                            useSource = false,
                            spellName = L_AUTOATTACK,
                            spellSchool = args.spellSchool,
                            controller = args:GetDestinationController(),
                            controllerName = args.destName,
                            critical = args.critical
                        }
                    )
                    return
                end
            else
                x:AddSpamMessage(
                    outputFrame,
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    {
                        useSource = false,
                        spellName = L_AUTOATTACK,
                        spellSchool = args.spellSchool,
                        controller = args:GetDestinationController(),
                        controllerName = args.destName,
                        critical = args.critical
                    }
                )
                return
            end
        elseif not isSwing and not isAutoShot then
            if args.critical then
                if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                    x:AddSpamMessage(
                        outputFrame,
                        spellId,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        {
                            useSource = false,
                            spellName = args.spellName,
                            spellSchool = args.spellSchool,
                            controller = args:GetDestinationController(),
                            controllerName = args.destName,
                            critical = args.critical
                        }
                    )
                    return
                elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellId,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        {
                            useSource = false,
                            spellName = args.spellName,
                            spellSchool = args.spellSchool,
                            controller = args:GetDestinationController(),
                            controllerName = args.destName,
                            critical = args.critical
                        }
                    )
                elseif x:Options_SpamMerger_HideMergedCriticals() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellId,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        {
                            useSource = false,
                            spellName = args.spellName,
                            spellSchool = args.spellSchool,
                            controller = args:GetDestinationController(),
                            controllerName = args.destName,
                            critical = args.critical
                        }
                    )
                    return
                end
            else
                x:AddSpamMessage(
                    outputFrame,
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    {
                        useSource = false,
                        spellName = args.spellName,
                        spellSchool = args.spellSchool,
                        controller = args:GetDestinationController(),
                        controllerName = args.destName,
                        critical = args.critical
                    }
                )
                return
            end
        end
    end

    if x:Options_Filter_OutgoingDamage_HideEvent(amount, args.critical) then
        -- Amount is not high enough
        return
    end

    local message
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    if args.critical and (not (isSwing or isAutoShot) or x:Options_Critical_ShowAutoAttack()) then
        if not (isSwing or isAutoShot) or x:Options_Critical_PrefixAutoAttack() then
        message = x:Options_Global_FormatCritical(x:Abbreviate(amount, outputFrame))
        else
            message = x:Abbreviate(amount, outputFrame)
        end
    else
        message = x:Abbreviate(amount, outputFrame)
    end

    -- Add the Partial Miss Types
    if x:Options_Outgoing_ShowPartialMisses() then
        local hasPartialMiss, formattedMessage = GetPartialMiss(args, frameSettings, outputFrame)

        if hasPartialMiss then
            message = message .. formattedMessage
        end
    end

    -- Add names
    message = message .. x:formatName(args, frameSettings.names)

    -- Add Icons (Hide Auto Attack icons)
    if args.prefix ~= "SWING" or x:ShowAutoAttackIcons(outputFrame) then
        message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)
    else
        message = x:GetSpellTextureFormatted(nil, message, frameSettings)
    end

    x:AddMessage(outputFrame, message, outputColor)
end

-- Incoming damage
EventHandlers.IncomingDamage = function(args)
    -- Keep track of spells that go by
    if args.spellId and x:Options_Filter_TrackSpells() then
        x.spellCache.damage[args.spellId] = true
    end

    if args.spellId and x:Options_Filter_HideIncomingDamage(args.spellId) then
        return
    end

    local outputFrame = "damage"
    local amount = args.amount

    local colorOverride
    if args.spellSchool == 1 then
        colorOverride = args.critical and "damageTakenCritical" or "damageTaken"
    else
        colorOverride = args.critical and "spellDamageTakenCritical" or "spellDamageTaken"
    end

    local spamMergerInterval = x:Options_SpamMerger_IncomingDamageInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        if amount <= 0 then
            return
        end

        x:AddSpamMessage(
            outputFrame,
            args.spellId,
            -amount,
            colorOverride,
            spamMergerInterval,
            {
                useSource = true,
                spellName = args.spellName,
                spellSchool = args.spellSchool,
                controller = args:GetSourceController(),
                controllerName = args.sourceName,
                critical = args.critical
            }
        )
        return
    end

    local message
    -- Check for partial resists / absorbs / ...
    if x:Options_IncomingDamage_ShowReductions() then
        local resistedAmount = (args.resisted or 0) + (args.blocked or 0) + (args.absorbed or 0)
        if resistedAmount > 0 then
            local resistType, color

            if (args.resisted or 0) > (args.blocked or 0) and (args.resisted or 0) > (args.absorbed or 0) then
                resistType = RESIST
                color = amount > 0 and "missTypeResist" or "missTypeResistPartial"
            elseif (args.blocked or 0) > (args.resisted or 0) and (args.blocked or 0) > (args.absorbed or 0) then
                resistType = BLOCK
                color = amount > 0 and "missTypeBlock" or "missTypeBlockPartial"
            elseif (args.absorbed or 0) > (args.resisted or 0) and (args.absorbed or 0) > (args.blocked or 0) then
                resistType = ABSORB
                color = amount > 0 and "missTypeAbsorb" or "missTypeAbsorbPartial"
            end

            amount = amount + resistedAmount
            color = hexNameColor(x:LookupColorByName(color))
            message = string.format(
                "-%s |c%s(%s %s)|r",
                x:Abbreviate(amount, outputFrame),
                color,
                resistType,
                x:Abbreviate(resistedAmount, outputFrame)
            )
        end
    end

    if x:Options_Filter_IncomingDamage_HideEvent(amount, args.critical) then
        return
    end

    -- If this is not a resist, then lets format it as normal
    if not message then
        -- Format Criticals and also abbreviate values
        if args.critical then
            message = x:Options_Global_FormatCritical(x:Abbreviate(-amount, "critical"))
        else
            message = x:Abbreviate(-amount, outputFrame)
        end
    end

    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add names
    message = message .. x:formatName(args, frameSettings.names, true)

    -- Add Icons (Hide Auto Attack icons)
    if args.prefix ~= "SWING" or x:ShowAutoAttackIcons(outputFrame) then
        message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)
    else
        message = x:GetSpellTextureFormatted(nil, message, frameSettings)
    end

    -- Output message
    x:AddMessage(outputFrame, message, x.GetSpellSchoolColor(args.spellSchool, colorOverride))
end

EventHandlers.IncomingHealing = function(args)
    if x:Options_Filter_TrackSpells() then
        x.spellCache.healing[args.spellId] = true
    end

    if x:Options_Filter_HideIncomingHealing(args.spellId) then
        return
    end

    local amount, isHoT, outputFrame = args.amount, args.prefix == "SPELL_PERIODIC", "healing"
    local color = isHoT and "healingTakenPeriodic" or args.critical and "healingTakenCritical" or "healingTaken"

    -- Adjust the amount if the user doesnt want over healing
    if not x:Options_IncomingHealing_ShowOverHealing() then
        amount = amount - args.overhealing
    end

    if not x:Options_IncomingHealing_HideAbsorbedHealing() and args.absorbed and args.absorbed > 0 then
        amount = amount + args.absorbed
    end

    if amount <= 0 then
        return
    end

    if x:Options_IncomingHealing_ShowOnlyMyHeals() and not args.isPlayer then
        if x:Options_IncomingHealing_ShowOnlyMyPetsHeals() and args:IsSourceMyPet() then
            -- If its the pet, then continue
        else
            return
        end
    end

    local message = string.format("+%s", x:Abbreviate(amount, outputFrame))

    local spamMergerInterval = x:Options_SpamMerger_IncomingHealingInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(
            outputFrame,
            args.sourceName or "Unknown Source",
            amount,
            "healingTaken",
            spamMergerInterval,
            {
                useSource = true,
                sourceGUID = args.sourceGUID,
                controller = args:GetSourceController(),
                controllerName = args.sourceName,
                critical = args.critical
            }
        )
        return
    end

    if x:Options_Filter_IncomingHealing_HideEvent(amount, args.critical) then
        return
    end

    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add names
    message = message .. x:formatName(args, frameSettings.names, true)

    -- Add the icon
    message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)

    x:AddMessage(outputFrame, message, color)
end

EventHandlers.IncomingAura = function(args)
    -- Some useful information about the event
    local isBuff, isGaining =
        args.auraType == "BUFF", args.suffix == "_AURA_APPLIED" or args.suffix == "_AURA_APPLIED_DOSE"

    -- Track the aura
    if x:Options_Filter_TrackSpells() then
        x.spellCache[isBuff and "buffs" or "debuffs"][args.spellName] = true
    end

    if isBuff then
        -- Stop if we're not showing buffs _or_ the spell's name is filtered
        if not x:Options_General_ShowBuffGainsAndFades() or x:Options_Filter_HideBuff(args.spellName) then
            return
        end
    else
        -- Aura is a debuff
        -- Stop if we're not showing debuffs _or_ the spell's name is filtered
        if not x:Options_General_ShowDebuffGainsAndFades() or x:Options_Filter_HideDebuff(args.spellName) then
            return
        end
    end

    -- Begin constructing the event message and color
    local message, color
    if isGaining then
        message = string.format("+%s", args.spellName)
        color = isBuff and "buffsGained" or "debuffsGained"
    else
        message = string.format("-%s", args.spellName)
        color = isBuff and "buffsFaded" or "debuffsFaded"
    end

    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    x:AddMessage(outputFrame, x:GetSpellTextureFormatted(args.spellId, message, frameSettings), color)
end

EventHandlers.KilledUnit = function(args)
    if not x:Options_General_ShowPartyKill() then
        return
    end

    local color = "killingBlow"
    if args.destGUID then
        local class = select(2, GetPlayerInfoByGUID(args.destGUID))
        if RAID_CLASS_COLORS[class] then
            color = RAID_CLASS_COLORS[class]
        end
    end

    x:AddMessage("general", string.format("%s: %s", XCT_KILLED, args.destName), color)
end

EventHandlers.InterruptedUnit = function(args)
    if not x:Options_General_ShowInterrupts() then
        return
    end

    -- Create and format the message
    local message = string.format("%s: %s", INTERRUPTED, args.extraSpellName)

    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add the icon
    message = x:GetSpellTextureFormatted(args.extraSpellId, message, frameSettings)

    x:AddMessage(outputFrame, message, "interrupts")
end

EventHandlers.OutgoingMiss = function(args)
    local spellId = args.spellId

    -- If this is a melee swing, it could also be our pets
    if args.prefix == "SWING" then
        if not x:Options_Outgoing_ShowAutoAttack() then
            return
        end

        if args:IsSourceMyPet() then
            spellId = PET_ATTACK_TEXTURE
        else
            spellId = 6603
        end
    end

    -- Absorbs are handled in the x.onCombatLogEvent() function
    -- Check for filtered immunes
    if args.missType == "IMMUNE" and not x:Options_Outgoing_ShowImmunes() then
        return
    end

    if args.missType ~= "IMMUNE" and not x:Options_Outgoing_ShowMisses() then
        return
    end

    -- Check if spell is filtered
    if x:Options_Filter_HideSpell(spellId) then
        return
    end

    local outputFrame = "outgoing"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    local message = _G["COMBAT_TEXT_" .. args.missType]

    local spamMergerInterval = x:Options_SpamMerger_OutgoingDamageMissesInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(outputFrame, args.missType, message, "misstypesOut", spamMergerInterval)
        return
    end

    x:AddMessage(outputFrame, x:GetSpellTextureFormatted(spellId, message, frameSettings), "misstypesOut")
end

EventHandlers.IncomingMiss = function(args)
    if not x:Options_IncomingDamage_ShowMissTypes() then
        return
    end

    -- Check if incoming spell is filtered
    if x:Options_Filter_HideIncomingDamage(args.spellId) then
        return
    end

    local message = _G["COMBAT_TEXT_" .. args.missType]
    local color = missTypeColorLookup[args.missType] or "misstypesOut"
    local outputFrame = "damage"

    local spamMergerInterval = x:Options_SpamMerger_IncomingMissesInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(outputFrame, args.missType, message, color, spamMergerInterval)
        return
    end

    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add Icons
    message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)

    x:AddMessage(outputFrame, message, color)
end

-- Outgoing dispel
EventHandlers.SpellDispel = function(args)
    if not x:Options_General_ShowDispells() then
        return
    end

    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    local color = args.auraType == "BUFF" and "dispellBuffs" or "dispellDebuffs"
    local message = x:GetSpellTextureFormatted(args.extraSpellId, args.extraSpellName, frameSettings)
    local sourceName = args.sourceName
    if args.isPlayer then
        sourceName = "You"
    end

    message = sourceName .. " dispelled " .. message

    local spamMergerInterval = x:Options_SpamMerger_DispellInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(outputFrame, args.extraSpellName, message, color, spamMergerInterval)
        return
    end

    local destName = args.destName
    if args.atPlayer then
        destName = "you"
    end
    x:AddMessage(outputFrame, message .. " on " .. destName, color)
end

EventHandlers.IncomingSpellDispel = function (args)
    if not x:Options_General_ShowIncomingDispells() then
        return
    end

    if args.isPlayer and args.atPlayer and x:Options_General_ShowDispells() then
        -- Its a self-dispel and outgoing dispells are enabled too. Skip here so we dont display the same message twice.
        return
    end

    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    local message = x:GetSpellTextureFormatted(args.extraSpellId, args.extraSpellName, frameSettings)
    local sourceName = args.sourceName
    if args.isPlayer then
        sourceName = "You"
    end

    local destName = args.destName
    if args.atPlayer then
        destName = "you"
    end

    message = sourceName .. " dispelled " .. message .. " on " .. destName

    x:AddMessage(outputFrame, message, "dispellDebuffs")
end

EventHandlers.SpellStolen = function(args)
    if not x:Options_General_ShowDispells() then
        return
    end

    local message = string.format("%s: %s", XCT_STOLE, args.extraSpellName)
    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add Icons
    message = x:GetSpellTextureFormatted(args.extraSpellId, message, frameSettings)

    x:AddMessage(outputFrame, message, "dispellStolen")
end

EventHandlers.SpellEnergize = function(args)
    if not x:Options_Power_ShowGains() then
        return
    end

    if math.abs(tonumber(args.amount)) <= tonumber(x:Options_Filter_PlayerPowerMinimumThreshold()) then
        return
    end

    local energy_type = x.POWER_LOOKUP[args.powerType]
    if not energy_type then
        x:Print("Unknown SPELL_ENERGIZE power type: " .. args.powerType)
        return
    end

    if x:Options_Power_ShowResource(energy_type) then
        return
    end

    local message = x:Abbreviate(args.amount, "power")
    local color = x:LookupColorByName("color_" .. energy_type) or { 1, 1, 1 }

    if energy_type == "RUNES" then
        -- Something procced and a DK rune has gone off cooldown
        -- Use the corresponding function for it, but we dont know which rune came off CD
        if x:Options_Power_ShowResource("RUNES") then
            EventHandlers.RUNE_POWER_UPDATE(nil, 0)
        end
    else
        x:AddMessage(
            "power",
            string.format("+%s %s", message, x:Options_Power_ShowEnergyTypes() and _G[energy_type] or ""),
            color
        )
    end
end

EventHandlers.UNIT_HEALTH = function()
    if UnitHealth(x.player.unit) / UnitHealthMax(x.player.unit) <= _G.COMBAT_TEXT_LOW_HEALTH_THRESHOLD then
        if not x.lowHealth then
            x:AddMessage("general", _G.HEALTH_LOW, "lowResourcesHealth")
            x.lowHealth = true
        end
    else
        x.lowHealth = false
    end
end

EventHandlers.UNIT_POWER_UPDATE = function(_, unit, powerType)
    if UnitPower(x.player.unit) / UnitPowerMax(x.player.unit) <= _G.COMBAT_TEXT_LOW_MANA_THRESHOLD then
        if not x.lowMana then
            x:AddMessage("general", MANA_LOW, "lowResourcesMana")
            x.lowMana = true
        end
    else
        x.lowMana = false
    end
end

EventHandlers.PLAYER_REGEN_DISABLED = function()
    for framename, settings in pairs(x.db.profile.frames) do
        if settings.enableScrollable and settings.scrollableInCombat then
            x:DisableFrameScrolling(framename)
        end
    end

    if x:Options_General_ShowCombatState() then
        x:AddMessage("general", _G.ENTERING_COMBAT, "combatEntering")
    end
end

EventHandlers.PLAYER_REGEN_ENABLED = function()
    for framename, settings in pairs(x.db.profile.frames) do
        if settings.enableScrollable and settings.scrollableInCombat then
            x:EnableFrameScrolling(framename)
        end
    end

    if x:Options_Global_ClearWhenLeavingCombat() then
        -- only clear frames with icons
        x:Clear("general")
        x:Clear("outgoing")
        x:Clear("critical")
        x:Clear("outgoing_healing")
        x:Clear("damage")
        x:Clear("healing")
        x:Clear("power")
        x:Clear("procs")
        x:Clear("loot")
    end

    if x:Options_General_ShowCombatState() then
        x:AddMessage("general", _G.LEAVING_COMBAT, "combatLeaving")
    end
end

EventHandlers.UNIT_ENTERED_VEHICLE = function(_, unit)
    if unit == "player" then
        x:UpdatePlayer()
    end
end

EventHandlers.UNIT_EXITING_VEHICLE = function(_, unit)
    if unit == "player" then
        x:UpdatePlayer()
    end
end

EventHandlers.PLAYER_ENTERING_WORLD = function()
    x:UpdatePlayer()
    x:Clear()

    -- Lazy Coding (Clear up messy libraries... yuck!)
    collectgarbage()
end

EventHandlers.UNIT_PET = function()
    x:UpdatePlayer()
end

EventHandlers.CHAT_MSG_SKILL = function(_, msg)
    -- TODO must be localized!
    local profession, newSkillLevel = msg:match("Your skill in (.+) has increased to (%d+).")
    if not profession or not newSkillLevel then
        return
    end

    x:AddMessage(
        "general",
        string.format("%s increased to %s", profession, newSkillLevel),
        { 0, 0.44, 0.87 }
    )
end

EventHandlers.CHAT_MSG_LOOT = function(_, msg)
    --x:Print(string.gsub(msg, "\124", "\124\124"))

    local preMessage, itemString, itemName, amount = string.match(
        msg,
        "(.+)%|c.+%|H(.+)|h%[(.+)%]%|h%|rx?(.*)"
    )

    if x.locale == "koKR" and (not preMessage or preMessage == "") then
        -- TODO amount ?
        itemString, itemName, preMessage = string.match(msg, "%|c.+%|H(.+)%|h%[(.+)%]%|h%|r.+ (.+)")
    end

    if not itemString or itemString == "" then
        return
    end

    -- Decode item string: (linkQuality for pets only)
    local linkType, linkID, _, linkQuality = strsplit(":", itemString)

    -- TODO: Clean up this debug scratch stuff
    --"([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
    -- "|cff0070dd|Hbattlepet:1343:1:3:158:10:12:BattlePet-0-000002C398CB|h[Bonkers]|h|r" - C_PetJournal.GetPetInfoBySpeciesID(1343)
    -- "|cff9d9d9d|Hbattlepet:467:1:0:140:9:9:BattlePet-0-000002C398C4|h[Dung Beetle]|h|r" - C_PetJournal.GetPetInfoBySpeciesID(467)
    -- ITEM_QUALITY_COLORS[3]

    -- local format_getItemString = "([^|]+)|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r[^%d]*(%d*)"
    -- "|cffffffff|Hitem:119299::::::::100:252::::::|h[드레노어 기계공학의 비밀]|h|r을 만들었습니다."

    if x:Options_Filter_TrackSpells() then
        x.spellCache.items[linkID] = true
    end

    if x:Options_Filter_HideItem(linkID) then
        return
    end

    -- Check to see if this is a battle pet
    if linkType == "battlepet" then
        -- TODO: Add pet icons!
        local speciesName, speciesIconTexture, petType = C_PetJournal.GetPetInfoBySpeciesID(linkID)

        -- [Caged]: Pet Name (Pet Family)
        local message = string.format(
            "|cff798BDD[%s]:|r %s (%s)",
            string.gsub(BATTLE_PET_CAGE_ITEM_NAME, "%s?%%s", ""),
            speciesName,
            PET_TYPE_SUFFIX[petType] or ""
        )
        local itemQualityColor = ITEM_QUALITY_COLORS[tonumber(linkQuality)]
        x:Print(linkID, linkQuality, itemQualityColor)

        x:AddMessage("loot", message, { itemQualityColor.r, itemQualityColor.g, itemQualityColor.b })
        return
    end

    -- Check to see if this is a item
    if linkType == "item" then
        local crafted, looted, pushed =
            (preMessage == format_crafted), (preMessage == format_looted), (preMessage == format_pushed)

        -- Item Quality, See "GetAuctionItemClasses()" For Type and Subtype, Item Icon Texture Location
        local itemQuality, _, _, itemType, itemSubtype, _, _, itemTexture = select(3, C_Item.GetItemInfo(linkID))

        -- Item White-List Filter
        local listed = x.db.profile.spells.items[itemType]
            and (x.db.profile.spells.items[itemType][itemSubtype] == true)

        -- Fix the Amount of a item looted
        amount = tonumber(amount) or 1

        -- Only let self looted items go through the "Always Show" filter
        if
            (listed and looted)
            or (x:Options_Loot_ShowItems() and looted and itemQuality >= x:Options_Loot_ItemQualityFilter())
            or (itemType == "Quest" and x:Options_Loot_ShowQuestItems() and looted)
            or (crafted and x:Options_Loot_ShowCraftedItems())
            or (pushed and x:Options_Loot_ShowPurchasedItems())
        then
            local itemQualityColor = ITEM_QUALITY_COLORS[itemQuality]
            -- "%s%s: %s [%s]%s %%s"

            local icon = ""
            if x:Options_Loot_ShowIcons() then
                icon = x:FormatIcon(itemTexture, x:Options_Loot_IconSize())
            end

            local itemQualityText = ""
            if x:Options_Loot_ShowColorBlindMoney() then
                -- Item Quality (Color Blind)
                itemQualityText = string.format("(%s)", _G[string.format("ITEM_QUALITY%s_DESC", itemQuality)])
            end

            local message
            if amount > 1 then
                message = string.format(
                    "%s%s: |cff798BDD+%s|r %s [%s]",
                    x:Options_Loot_ShowItemTypes() and itemType or "Item", -- Item Type
                    itemQualityText,
                    amount,
                    icon,
                    itemName
                )
            else
                message = string.format(
                    "%s%s: %s [%s]",
                    x:Options_Loot_ShowItemTypes() and itemType or "Item", -- Item Type
                    itemQualityText,
                    icon,
                    itemName
                )
            end

            if x:Options_Loot_ShowItemTotals() then
                -- We have to delay the message in order to get correct "totals".
                x:ScheduleTimer("AddLootMessageDelayed", 0.5, {
                    id = linkID,
                    message = message,
                    r = itemQualityColor.r,
                    g = itemQualityColor.g,
                    b = itemQualityColor.b,
                })
            else
                -- Display the message directly
                x:AddMessage("loot", message, { itemQualityColor.r, itemQualityColor.g, itemQualityColor.b })
            end
        end
    end
end

EventHandlers.CHAT_MSG_CURRENCY = function(_, msg)
    -- get currency from chat
    local currencyLink, amountGained = msg:match(format_currency_multiple)
    if not currencyLink then
        amountGained, currencyLink = 1, msg:match(format_currency_single)
        if not currencyLink then
            return
        end
    end

    local currencyInfo = C_CurrencyInfo.GetCurrencyInfoFromLink(currencyLink)

    local icon = ""
    if x:Options_Loot_ShowIcons() then
        icon = x:FormatIcon(currencyInfo.iconFileID, x:Options_Loot_IconSize())
    end

    local message
    if tonumber(amountGained) > 1 then
        message = string.format("%s: |cff798BDD+%s|r %s %s", _G.CURRENCY, amountGained, icon, currencyInfo.name)
    else
        message = string.format("%s: %s %s", _G.CURRENCY, icon, currencyInfo.name)
    end

    if currencyInfo.quantity > 1 then
        message = message .. string.format(" |cffFFFF00(%s)|r", currencyInfo.quantity)
    end

    local qualityColor = ITEM_QUALITY_COLORS[currencyInfo.quality]

    x:AddMessage("loot", message, { qualityColor.r, qualityColor.g, qualityColor.b })
end

EventHandlers.CHAT_MSG_MONEY = function(_, msg)
    local g, s, c =
        tonumber(msg:match(GOLD_AMOUNT:gsub("%%d", "(%%d+)"))),
        tonumber(msg:match(SILVER_AMOUNT:gsub("%%d", "(%%d+)"))),
        tonumber(msg:match(COPPER_AMOUNT:gsub("%%d", "(%%d+)")))
    local money, o = (g and g * 10000 or 0) + (s and s * 100 or 0) + (c or 0), MONEY .. ": "

    -- TODO: Add a filter for a minimum amount of money

    if x:Options_Loot_ShowColorBlindMoney() then
        o = o .. (g and g .. " G " or "") .. (s and s .. " S " or "") .. (c and c .. " C " or "")
    else
        o = o .. C_CurrencyInfo.GetCoinTextureString(money) .. " "
    end

    -- This only works on english clients :\
    if msg:find("share") then
        o = o .. "(split)"
    end

    x:AddMessage("loot", o, { 1, 1, 0 }) -- yellow
end

EventHandlers.RUNE_POWER_UPDATE = function(_, runeIndex)
    if not x.DeathKnightRunes then
        x.DeathKnightRunes = {}
    end

    if tonumber(runeIndex) and runeIndex >= 1 and runeIndex <= 6 then
        -- A Rune has gone on cooldown
        local _, _, runeReady = GetRuneCooldown(runeIndex)
        if not runeReady then
            x.DeathKnightRunes[runeIndex] = true
        end
    end

    -- A Rune may have come off cooldown!
    -- IDK why but runeIndex is really really big (> 32k or even negative)
    local runeCount = 0
    for otherRuneIndex, wasOnCd in pairs(x.DeathKnightRunes) do
        if wasOnCd then
            local _, _, runeReady = GetRuneCooldown(otherRuneIndex)
            if runeReady then
                runeCount = runeCount + 1
                x.DeathKnightRunes[otherRuneIndex] = false
            end
        end
    end

    if runeCount > 0 then
        x:AddMessage(
            "power",
            string.format("+%s %s", runeCount, _G.RUNES),
            x:LookupColorByName("color_RUNES") or { 1, 1, 1 }
        )
    end
end

EventHandlers.ACTIVE_TALENT_GROUP_CHANGED = function()
    x:UpdatePlayer()
end

-- Handlers for COMBAT_TEXT_UPDATE
local CombatTextUpdateHandlers = {}
CombatTextUpdateHandlers.SPELL_ACTIVE = function(spellName)
    if not spellName then
        return
    end

    if x:Options_Filter_TrackSpells() then
        x.spellCache.procs[spellName] = true
    end

    if x:Options_Filter_HideProc(spellName) then
        return
    end

    local message = spellName

    -- Add Stacks
    local icon, spellStacks = select(3, UnitAura("player", spellName))
    if spellStacks and tonumber(spellStacks) > 1 then
        message = spellName .. " |cffFFFFFFx" .. spellStacks .. "|r"
    end

    local outputFrame = "procs"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add Icons
    if icon and frameSettings.iconsEnabled then
        if frameSettings.fontJustify == "LEFT" then
            message = x:FormatIcon(icon, frameSettings.iconsSize) .. "  " .. message
        else
            message = message .. " " .. x:FormatIcon(icon, frameSettings.iconsSize)
        end
    end

    x:AddMessage(outputFrame, message, "spellProc")
end

CombatTextUpdateHandlers.SPELL_CAST = function(spellName)
    if x:Options_Procs_ShowProcs() then
        x:AddMessage("procs", spellName, "spellReactive")
    end
end

CombatTextUpdateHandlers.HONOR_GAINED = function()
    -- TODO: Create a merger for honor xp
    -- UNTESTED
    if not x:Options_General_ShowHonor() then
        return
    end

    local amount = GetCurrentCombatTextEventInfo()
    local num = math.floor(tonumber(amount) or 0)
    if num > 0 then
        x:AddMessage("general", string.format(format_honor, _G.HONOR, x:Abbreviate(amount, "general")), "honorGains")
    end
end

CombatTextUpdateHandlers.FACTION = function()
    if not x:Options_General_ShowReputationChanges() then
        return
    end

    local faction, amount = GetCurrentCombatTextEventInfo()
    amount = math.floor(tonumber(amount) or 0)
    local outputFrame, color, outputFormat = "general"
    if amount > 0 then
        color = "reputationGain"
        outputFormat = string.format("%s: +%s %s", _G.REPUTATION, "%s", faction)
    else
        color = "reputationLoss"
        outputFormat = string.format("%s: -%s %s", _G.REPUTATION, "%s", faction)
    end

    local spamMergerInterval = x:Options_SpamMerger_DispellInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(
            outputFrame,
            faction,
            amount,
            color,
            spamMergerInterval,
            {
                outputFormat = outputFormat,
                disableIcon = true
            }
        )
        return
    end

    x:AddMessage(
        outputFrame,
        string.format(outputFormat, x:Abbreviate(amount, "general")),
        "reputationGain"
    )
end

EventHandlers.COMBAT_TEXT_UPDATE = function(_, subevent, ...)
    if CombatTextUpdateHandlers[subevent] then
        CombatTextUpdateHandlers[subevent](...)
    end
end

function x.onCombatLogEvent(args)
    -- Is the source someone we care about?
    if args.isPlayer or args:IsSourceMyVehicle() or x:Options_Outgoing_ShowPetDamage() and args:IsSourceMyPet() then
        if args.suffix == "_HEAL" then
            EventHandlers.OutgoingHealing(args)
        elseif args.suffix == "_DAMAGE" then
            EventHandlers.OutgoingDamage(args)
        elseif args.suffix == "_MISSED" then
            if args.missType == "ABSORB" then
                if x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage() then
                    -- This was fully absorbed, but we would like to display it... use the DamageOutgoing EventHandler
                    -- TODO What about fully absorbed heals?
                    args.amount = args.amountMissed
                    EventHandlers.OutgoingDamage(args)
                end
            else
                EventHandlers.OutgoingMiss(args)
            end
        elseif args.event == "PARTY_KILL" then
            EventHandlers.KilledUnit(args)
        elseif args.event == "SPELL_INTERRUPT" then
            EventHandlers.InterruptedUnit(args)
        elseif args.event == "SPELL_DISPEL" then
            EventHandlers.SpellDispel(args)
        elseif args.event == "SPELL_STOLEN" then
            EventHandlers.SpellStolen(args)
        elseif args.suffix == "_ENERGIZE" then
            EventHandlers.SpellEnergize(args)
        end
    end

    -- Is the destination someone we care about?
    if args.atPlayer or args:IsDestinationMyVehicle() then
        if args.suffix == "_HEAL" then
            EventHandlers.IncomingHealing(args)
        elseif args.suffix == "_DAMAGE" then
            EventHandlers.IncomingDamage(args)
        elseif args.suffix == "_MISSED" then
            EventHandlers.IncomingMiss(args)
        elseif args.event == "SPELL_DISPEL" then
            EventHandlers.IncomingSpellDispel(args)
        end
    end

    -- Player Auras
    if args.atPlayer
        and (
            args.suffix == "_AURA_APPLIED"
            or args.suffix == "_AURA_REMOVED"
            or args.suffix == "_AURA_APPLIED_DOSE"
            or args.suffix == "_AURA_REMOVED_DOSE"
        )
    then
        EventHandlers.IncomingAura(args)
    end

    -- Special case: Warrior's Spell reflect
    if x.player.class == "WARRIOR" then
        -- Spell reflect is weird:
        -- 1. The Buff "Spell Reflect" is gained
        -- 2. The Buff "Spell Reflect" is lost, this comes directly after a spell is reflected.
        -- 3. There is a SPELL_DAMAGE event with the source == destination, this will come when the spell LANDS back on the caster.
        -- 4. There is a SPELL_MISSED event (type REFLECT) with target = player, this usually comes after 3!

        -- We can match the SPELL_MISSED to the SPELL_DAMAGE event via the sourceGUID while the Buff is up
        -- Now we have to correlate all the 4 events to each other to get the correct SPELL_DAMAGE event to the SPELL_MISSED

        if args.isPlayer and args.atPlayer and args.spellId == 23920
        then
            -- The warrior self-buffed (or lost) Spell reflect
            if args.event == "SPELL_AURA_APPLIED" then
                x.spellReflectApplied = args.timestamp
                x.spellReflectRemoved = nil
            elseif args.event == "SPELL_AURA_REMOVED" then
                x.spellReflectRemoved = args.timestamp
            end
        elseif x.spellReflectApplied
            and x.spellReflectApplied <= args.timestamp
            and (x.spellReflectRemoved == nil or x.spellReflectRemoved + 1 >= args.timestamp)
        then
            -- The SPELL_DAMAGE event can / will come after the buff is lost, because of spell travel time
            -- The SPELL_MISSED event came after the SPELL_DAMAGE event, idk why.

            -- This event was triggered while spell reflect is active
            local runHandler = false
            if args.atPlayer and args.event == "SPELL_MISSED" and args.missType == "REFLECT" then
                -- args get reused by the combatparser-lib, we have to clone it
                x.spellReflectSpellMissed = table_clone(args)
                runHandler = true
            elseif args.event == "SPELL_DAMAGE" and args.sourceGUID == args.destGUID then
                -- args get reused by the combatparser-lib, we have to clone it
                x.spellReflectReflectedSpell = table_clone(args)
                runHandler = true
            end

            if runHandler
                and x.spellReflectSpellMissed
                and x.spellReflectReflectedSpell
                and x.spellReflectSpellMissed.sourceGUID == x.spellReflectReflectedSpell.sourceGUID
            then
                EventHandlers.OutgoingDamage(x.spellReflectReflectedSpell)
                -- We found the reflected spell, nil everything so that it stops!
                x.spellReflectSpellMissed = nil
                x.spellReflectReflectedSpell = nil
                x.spellReflectApplied = nil
                x.spellReflectRemoved = nil
            end
        end
    end
end

-- Register for the needed events
function x:RegisterCombatEvents()
    -- Unregister all events
    self:UnregisterAllEvents()
    LibStub("xCombatParser-1.0"):UnregisterCombat(self.onCombatLogEvent)

    -- Register handlers the events we need

    self:RegisterEvent("COMBAT_TEXT_UPDATE", EventHandlers.COMBAT_TEXT_UPDATE)

    self:RegisterEvent("PLAYER_REGEN_DISABLED", EventHandlers.PLAYER_REGEN_DISABLED)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", EventHandlers.PLAYER_REGEN_ENABLED)
    self:RegisterEvent("UNIT_ENTERED_VEHICLE", EventHandlers.UNIT_ENTERED_VEHICLE)
    self:RegisterEvent("UNIT_EXITING_VEHICLE", EventHandlers.UNIT_EXITING_VEHICLE)
    self:RegisterEvent("PLAYER_ENTERING_WORLD", EventHandlers.PLAYER_ENTERING_WORLD)
    self:RegisterEvent("UNIT_PET", EventHandlers.UNIT_PET)

    if self:GetFrameSettings("general") then
        --  The "general" frame is enabled or its output is rerouted to a secondary frame.

        if x:Options_General_ShowLowManaAndHealth() then
            self:RegisterEvent("UNIT_HEALTH", EventHandlers.UNIT_HEALTH)

            if select(2, UnitPowerType(x.player.unit)) == "MANA" then
                self:RegisterEvent("UNIT_POWER_UPDATE", EventHandlers.UNIT_POWER_UPDATE)
            end
        end

        if x:Options_General_ShowProfessionSkillups() then
            self:RegisterEvent("CHAT_MSG_SKILL", EventHandlers.CHAT_MSG_SKILL)
        end
    end

    if self:GetFrameSettings("loot") then
        --  The "loot" frame is enabled or its output is rerouted to a secondary frame.

        self:RegisterEvent("CHAT_MSG_LOOT", EventHandlers.CHAT_MSG_LOOT)

        if x:Options_Loot_ShowCurrency() then
            self:RegisterEvent("CHAT_MSG_CURRENCY", EventHandlers.CHAT_MSG_CURRENCY)
        end

        if x:Options_Loot_ShowMoney() then
            self:RegisterEvent("CHAT_MSG_MONEY", EventHandlers.CHAT_MSG_MONEY)
        end
    end

    if self:GetFrameSettings("power") then
        --  The "power" frame is enabled or its output is rerouted to a secondary frame.

        if x:Options_Power_ShowGains() and x:Options_Power_ShowResource("RUNES") and x.player.class == "DEATHKNIGHT" then
            self:RegisterEvent("RUNE_POWER_UPDATE", EventHandlers.RUNE_POWER_UPDATE)
        end
    end

    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", EventHandlers.ACTIVE_TALENT_GROUP_CHANGED)

    LibStub("xCombatParser-1.0"):RegisterCombat(self.onCombatLogEvent)
end
