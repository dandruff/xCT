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

local BuffsOrDebuffs = {
    ["_AURA_APPLIED"] = true,
    ["_AURA_REMOVED"] = true,
    ["_AURA_APPLIED_DOSE"] = true,
    ["_AURA_REMOVED_DOSE"] = true,
    --["_AURA_REFRESH"] = true, -- I dont know how we should support this
}

--[=====================================================[
 String Formatters
--]=====================================================]
local format_pet = string.format("|cff798BDD[%s]:|r %%s (%%s)", string.gsub(BATTLE_PET_CAGE_ITEM_NAME, "%s?%%s", "")) -- [Caged]: Pet Name (Pet Family)

-- TODO: Remove old loot pattern
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
-- "You create: |cffa335ee|Hitem:124515::::::::100:254:4:3::530:::|h[Talisman of the Master Tracker]|h|r"
--local msg = "|cff1eff00|Hitem:108840:0:0:0:0:0:0:443688319:90:0:0:0|h[Warlords Intro Zone PH Mail Helm]|h|r"
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"

local format_honor = string.gsub(COMBAT_TEXT_HONOR_GAINED, "%%s", "+%%s")
local format_crit = "%s%s%s"
local format_dispell = "%s: %s"
local format_quality = "ITEM_QUALITY%s_DESC"
local format_remove_realm = "(.*)-.*"

local format_loot_icon = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_lewtz_blind = "(%s)"
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
 Fast Boolean Lookups
--]=====================================================]

-- TODO: Add Combo Point Support
local function ShowRogueComboPoints()
    return false
end -- x.db.profile.spells.combo["ROGUE"][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "ROGUE" end
local function ShowFeralComboPoints()
    return false
end -- x.db.profile.spells.combo["DRUID"][2][COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] and x.player.class == "DRUID" and x.player.spec == 2 end
local function ShowMonkChi()
    return false
end -- return x.db.profile.spells.combo["MONK"][CHI] and x.player.class == "MONK" end
local function ShowPaladinHolyPower()
    return false
end -- return x.db.profile.spells.combo["PALADIN"][HOLY_POWER] and x.player.class == "PALADIN" end
local function ShowPriestShadowOrbs()
    return false
end -- return x.db.profile.spells.combo["PRIEST"][3][SHADOW_ORBS] and x.player.class == "PRIEST" and x.player.spec == 3 end
local function ShowWarlockSoulShards()
    return false
end -- return x.db.profile.spells.combo["WARLOCK"][1][SOUL_SHARDS] and x.player.class == "WARLOCK" and x.player.spec == 1 end
local function ShowWarlockDemonicFury()
    return false
end -- return x.db.profile.spells.combo["WARLOCK"][2][DEMONIC_FURY] and x.player.class == "WARLOCK" and x.player.spec == 2 end
local function ShowWarlockBurningEmbers()
    return false
end -- return x.db.profile.spells.combo["WARLOCK"][3][BURNING_EMBERS] and x.player.class == "WARLOCK" and x.player.spec == 3 end

--[=====================================================[
 Message Formatters
--]=====================================================]
local xCTFormat = {}

function xCTFormat:SPELL_HEAL(outputFrame, spellId, amount, overhealing, critical, args, frameSettings)
    local outputColor, message = "healingOut"

    -- Format Criticals and also abbreviate values
    if critical then
        outputColor = "healingOutCritical"
        message = string.format(
            format_crit,
            x.db.profile.frames.critical.critPrefix,
            x:Abbreviate(amount, "critical"),
            x.db.profile.frames.critical.critPostfix
        )
    else
        message = x:Abbreviate(amount, outputFrame)
    end

    -- Show and Format Overhealing values
    if overhealing > 0 and x:Options_OutgoingHealing_FormatOverhealing() then
        overhealing = x:Abbreviate(overhealing, outputFrame)
        message = message .. x:Options_OutgoingHealing_FormatOverhealingAmount(overhealing)
    end

    -- Add names
    message = message .. x.formatName(args, frameSettings.names)

    -- Add Icons
    message = x:GetSpellTextureFormatted(spellId, message, frameSettings)

    x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:SPELL_PERIODIC_HEAL(outputFrame, spellId, amount, overhealing, critical, args, frameSettings)
    local outputColor, message = "healingOutPeriodic"

    -- Format Criticals and also abbreviate values
    if critical then
        message = string.format(
            format_crit,
            x.db.profile.frames.critical.critPrefix,
            x:Abbreviate(amount, "critical"),
            x.db.profile.frames.critical.critPostfix
        )
    else
        message = x:Abbreviate(amount, outputFrame)
    end

    -- Show and Format Overhealing values
    if overhealing > 0 and x:Options_OutgoingHealing_FormatOverhealing() then
        overhealing = x:Abbreviate(overhealing, outputFrame)
        message = message .. x:Options_OutgoingHealing_FormatOverhealingAmount(overhealing)
    end

    -- Add names
    message = message .. x.formatName(args, frameSettings.names)

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
 Combo Points - Rogues / Feral
--]=====================================================]
local function UpdateComboPoints()
    if ShowRogueComboPoints() or ShowFeralComboPoints() then
        local comboPoints, outputColor = GetComboPoints(x.player.unit, "target"), "comboPoints"
        if comboPoints == MAX_COMBO_POINTS then
            outputColor = "comboPointsMax"
        end
        if comboPoints > 0 then
            x.cpUpdated = true
            x:AddMessage("class", comboPoints, outputColor)
        elseif x.cpUpdated then
            x.cpUpdated = false
            x:AddMessage("class", " ", outputColor)
        end
    end
end

--[=====================================================[
  Combo Points - Class Power Types
--]=====================================================]
local function UpdateUnitPower(unit, powertype)
    if unit == x.player.unit then
        local value

        if powertype == "CHI" and ShowMonkChi() then
            value = UnitPower(x.player.unit, SPELL_POWER_CHI)
        elseif powertype == "HOLY_POWER" and ShowPaladinHolyPower() then
            value = UnitPower(x.player.unit, SPELL_POWER_HOLY_POWER)
        elseif powertype == "SHADOW_ORBS" and ShowPriestShadowOrbs() then
            value = UnitPower(x.player.unit, SPELL_POWER_SHADOW_ORBS)
        elseif powertype == "SOUL_SHARDS" and ShowWarlockSoulShards() then
            value = UnitPower(x.player.unit, SPELL_POWER_SOUL_SHARDS) / 100
        elseif powertype == "DEMONIC_FURY" and ShowWarlockDemonicFury() then
            value = UnitPower(x.player.unit, SPELL_POWER_DEMONIC_FURY) / 100
        elseif powertype == "BURNING_EMBERS" and ShowWarlockBurningEmbers() then
            value = UnitPower(x.player.unit, SPELL_POWER_BURNING_EMBERS)
        end

        if value then
            if value < 1 then
                if value == 0 then
                    x:AddMessage("class", " ", "comboPoints")
                else
                    x:AddMessage("class", "0", "comboPoints")
                end
            else
                x:AddMessage("class", math.floor(value), "comboPoints")
            end
        end
    end
end

--[=====================================================[
 Combo Points - Class Aura Types
--]=====================================================]
local function UpdateAuraTracking(_, unit)
    local entry = x.TrackingEntry

    if entry then
        if unit == entry.unit then
            local i, name, icon, count, _, _, _, _, _, _, spellId = 1, C_UnitAuras.GetBuffDataByIndex(entry.unit, 1)

            while name do
                if entry.id == spellId then
                    break
                end
                i = i + 1
                name, icon, count, _, _, _, _, _, _, spellId = C_UnitAuras.GetBuffDataByIndex(entry.unit, i)
            end

            if name and count > 0 then
                x:AddMessage("class", count, "comboPoints")
            else
                x:AddMessage("class", " ", "comboPoints")
            end

        -- Fix issue of not reseting when unit disapears (e.g. dismiss pet)
        elseif not UnitExists(entry.unit) then
            x:AddMessage("class", " ", "comboPoints")
        end
    end
end

function x:QuickClassFrameUpdate()
    local entry = x.TrackingEntry
    if entry and UnitExists(entry.unit) then
        -- Update Buffs
        UpdateAuraTracking(nil, entry.unit)

        -- Update Unit's Power
        if ShowMonkChi() then
            UpdateUnitPower(entry.unit, "LIGHT_FORCE")
        elseif ShowPaladinHolyPower() then
            UpdateUnitPower(entry.unit, "HOLY_POWER")
        elseif ShowPriestShadowOrbs() then
            UpdateUnitPower(entry.unit, "SHADOW_ORBS")
        elseif ShowWarlockSoulShards() then
            UpdateUnitPower(entry.unit, "SOUL_SHARDS")
        elseif ShowWarlockDemonicFury() then
            UpdateUnitPower(entry.unit, "DEMONIC_FURY")
        elseif ShowWarlockBurningEmbers() then
            UpdateUnitPower(entry.unit, "BURNING_EMBERS")
        end
    else
        -- Update Combo Points
        UpdateComboPoints()
    end
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
local function formatNameHelper(name, enableColor, color, enableCustomColor, customColor)
    if enableColor then
        if enableCustomColor then
            return "|c" .. hexNameColor(customColor) .. name .. "|r"
        end
        return "|c" .. hexNameColor(color) .. name .. "|r"
    end
    return "|cffFFFFFF" .. name .. "|r"
end

-- Format Handlers for name
local formatNameTypes = {
    function(args, settings, isSource) -- [1] = Source/Destination Name
        local guid, name, color =
            isSource and args.sourceGUID or args.destGUID, isSource and args.sourceName or args.destName

        if settings.removeRealmName then
            name = string.match(name, format_remove_realm) or name
        end

        if settings.enableNameColor and not settings.enableCustomNameColor then
            if args.prefix == "ENVIRONMENTAL" then
                color = x.spellColors[args.school or args.spellSchool or 1]
            else
                if string.match(guid, "^Player") then
                    local _, class = GetPlayerInfoByGUID(guid)
                    color = RAID_CLASS_COLORS[class or 0]
                end
            end
        end

        return formatNameHelper(
            name,
            settings.enableNameColor,
            color,
            settings.enableCustomNameColor,
            settings.customNameColor
        )
    end,

    function(args, settings, isSource) -- [2] = Spell Name
        local color
        if settings.enableNameColor and not settings.enableCustomNameColor then
            -- NOTE: I don't think we want the spell school of the spell
            --       being cast. We want the spell school of the damage
            --       being done. That said, if you want to change it so
            --       that the spell name matches the type of spell it
            --       is, and not the type of damage it does, change
            --       "args.school" to "args.spellSchool".
            color = x.GetSpellSchoolColor(args.school or args.spellSchool)
        end

        return formatNameHelper(
            args.spellName,
            settings.enableSpellColor,
            color,
            settings.enableCustomSpellColor,
            settings.customSpellColor
        )
    end,

    function(args, settings, isSource) -- [3] = Source Name - Spell Name
        if args.hideCaster then
            return formatNameTypes[2](args, settings, isSource)
        end

        return formatNameTypes[1](args, settings, isSource) .. " - " .. formatNameTypes[2](args, settings, isSource)
    end,

    function(args, settings, isSource) -- [4] = Spell Name - Source Name
        if args.hideCaster then
            return formatNameTypes[2](args, settings, isSource)
        end

        return formatNameTypes[2](args, settings, isSource) .. " - " .. formatNameTypes[1](args, settings, isSource)
    end,
}

-- Check to see if the name needs for be formatted, if so, handle all the logistics
function x.formatName(args, settings, isSource)
    -- Event Type helper
    local index = isSource and (args.fake_sourceController or args:GetSourceController())
        or (args.fake_destinationController or args:GetDestinationController())

    local eventType = settings[index]

    -- If we have a valid event type that we can handle
    if eventType and eventType.nameType > 0 then
        return settings.namePrefix
            .. formatNameTypes[eventType.nameType](args, eventType, isSource)
            .. settings.namePostfix
    end
    return "" -- Names not supported
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
EventHandlers.HealingOutgoing = function(args)
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
        if amount < 1 then
            return
        end
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
                    "spellName",
                    args.spellName,
                    "spellSchool",
                    args.spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                x:AddSpamMessage(
                    "outgoing_healing",
                    args.spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    args.spellName,
                    "spellSchool",
                    args.spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
            elseif x:Options_SpamMerger_HideMergedCriticals() then
                x:AddSpamMessage(
                    "outgoing_healing",
                    args.spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    args.spellName,
                    "spellSchool",
                    args.spellSchool,
                    "destinationController",
                    args:GetDestinationController()
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
                "spellName",
                args.spellName,
                "spellSchool",
                args.spellSchool,
                "destinationController",
                args:GetDestinationController()
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
EventHandlers.DamageOutgoing = function(args)
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

    local amount = args.amount
    if x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage() then
        -- Its a partial absorb, add it to the amount
        amount = amount + (args.absorbed or 0)
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
                "auto",
                spellId == 34026 and L_KILLCOMMAND or L_AUTOATTACK,
                "destinationController",
                args:GetDestinationController()
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
    if (isSwing or isAutoShot) and x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        if outputFrame == "critical" then
            if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                x:AddSpamMessage(
                    outputFrame,
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "auto",
                    L_AUTOATTACK,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                x:AddSpamMessage(
                    "outgoing",
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "auto",
                    L_AUTOATTACK,
                    "destinationController",
                    args:GetDestinationController()
                )
            elseif x:Options_SpamMerger_HideMergedCriticals() then
                x:AddSpamMessage(
                    "outgoing",
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "auto",
                    L_AUTOATTACK,
                    "destinationController",
                    args:GetDestinationController()
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
                "auto",
                L_AUTOATTACK,
                "destinationController",
                args:GetDestinationController()
            )
            return
        end
    elseif not isSwing and not isAutoShot and spamMergerInterval > 0 then
        if args.critical then
            if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                x:AddSpamMessage(
                    outputFrame,
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    args.spellName,
                    "spellSchool",
                    args.spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                x:AddSpamMessage(
                    "outgoing",
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    args.spellName,
                    "spellSchool",
                    args.spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
            elseif x:Options_SpamMerger_HideMergedCriticals() then
                x:AddSpamMessage(
                    "outgoing",
                    spellId,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    args.spellName,
                    "spellSchool",
                    args.spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            end
        else
            -- args:GetSourceController() / args:GetDestinationController()
            x:AddSpamMessage(
                outputFrame,
                spellId,
                amount,
                outputColor,
                spamMergerInterval,
                "spellName",
                args.spellName,
                "spellSchool",
                args.spellSchool,
                "destinationController",
                args:GetDestinationController()
            )
            return
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
            message = string.format(
                format_crit,
                x.db.profile.frames.critical.critPrefix,
                x:Abbreviate(amount, outputFrame),
                x.db.profile.frames.critical.critPostfix
            )
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
    message = message .. x.formatName(args, frameSettings.names)

    -- Add Icons (Hide Auto Attack icons)
    if args.prefix ~= "SWING" or x:ShowAutoAttackIcons(outputFrame) then
        message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)
    else
        message = x:GetSpellTextureFormatted(nil, message, frameSettings)
    end

    x:AddMessage(outputFrame, message, outputColor)
end

-- Incoming damage
EventHandlers.DamageIncoming = function(args)
    -- Keep track of spells that go by
    if args.spellId and x:Options_Filter_TrackSpells() then
        x.spellCache.damage[args.spellId] = true
    end

    if args.spellId and x:Options_Filter_HideIncomingDamage(args.spellId) then
        return
    end

    local outputFrame = "damage"
    local amount = args.amount
    local message

    -- Check for resists
    if x:Options_IncomingDamage_ShowResistances() then
        local resistedAmount = (args.resisted or 0) + (args.blocked or 0) + (args.absorbed or 0)
        if resistedAmount > 0 then
            local resistType, color

            -- Check for resists (full and partials)
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

    local colorOverride
    if args.spellSchool == 1 then
        colorOverride = args.critical and "damageTakenCritical" or "damageTaken"
    else
        colorOverride = args.critical and "spellDamageTakenCritical" or "spellDamageTaken"
    end

    local spamMergerInterval = x:Options_SpamMerger_IncomingDamageInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(
            outputFrame,
            args.spellId,
            -amount,
            colorOverride,
            spamMergerInterval,
            "spellName",
            args.spellName,
            "spellSchool",
            args.spellSchool,
            "sourceController",
            args:GetSourceController()
        )
        return
    end

    if x:Options_Filter_IncomingDamage_HideEvent(amount, args.critical) then
        return
    end

    -- If this is not a resist, then lets format it as normal
    if not message then
        -- Format Criticals and also abbreviate values
        if args.critical then
            message = string.format(
                format_crit,
                x.db.profile.frames.critical.critPrefix,
                x:Abbreviate(-amount, "critical"),
                x.db.profile.frames.critical.critPostfix
            )
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
    message = message .. x.formatName(args, frameSettings.names, true)

    -- Add Icons (Hide Auto Attack icons)
    if args.prefix ~= "SWING" or x:ShowAutoAttackIcons(outputFrame) then
        message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)
    else
        message = x:GetSpellTextureFormatted(nil, message, frameSettings)
    end

    -- Output message
    x:AddMessage(outputFrame, message, x.GetSpellSchoolColor(args.spellSchool, colorOverride))
end

EventHandlers.HealingIncoming = function(args)
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

    -- Don't show healing that gets absorbed by a debuff or mechanic
    if x:Options_IncomingHealing_HideAbsorbedHealing() then
        amount = amount - args.absorbed
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
            "sourceGUID",
            args.sourceGUID,
            "sourceController",
            args:GetSourceController()
        )
    else
        if x:Options_Filter_IncomingHealing_HideEvent(amount, args.critical) then
            return
        end

        local frameSettings = x:GetFrameSettings(outputFrame)
        if not frameSettings then
            -- Frame is disabled and the secondary frame is disabled too or not chosen
            return
        end

        -- Add names
        message = message .. x.formatName(args, frameSettings.names, true)

        -- Add the icon
        message = x:GetSpellTextureFormatted(args.spellId, message, frameSettings)

        x:AddMessage(outputFrame, message, color)
    end
end

EventHandlers.AuraIncoming = function(args)
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

    x:AddMessage("general", string.format(format_dispell, XCT_KILLED, args.destName), color)
end

EventHandlers.InterruptedUnit = function(args)
    if not x:Options_General_ShowInterrupts() then
        return
    end

    -- Create and format the message
    local message = string.format(format_dispell, INTERRUPTED, args.extraSpellName)

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

    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    local message = _G["COMBAT_TEXT_" .. args.missType]

    local spamMergerInterval = x:Options_SpamMerger_OutgoingDamageMissesInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(outputFrame, message, 0, "misstypesOut", spamMergerInterval)
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
        x:AddSpamMessage(outputFrame, message, 0, color, spamMergerInterval)
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

EventHandlers.SpellDispel = function(args)
    if not x:Options_General_ShowDispells() then
        return
    end

    local color = args.auraType == "BUFF" and "dispellBuffs" or "dispellDebuffs"
    local message = string.format(format_dispell, XCT_DISPELLED, args.extraSpellName)
    local outputFrame = "general"
    local frameSettings = x:GetFrameSettings(outputFrame)
    if not frameSettings then
        -- Frame is disabled and the secondary frame is disabled too or not chosen
        return
    end

    -- Add Icons
    message = x:GetSpellTextureFormatted(args.extraSpellId, message, frameSettings)

    local spamMergerInterval = x:Options_SpamMerger_DispellInterval()
    if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
        x:AddSpamMessage(outputFrame, args.extraSpellName, message, color, spamMergerInterval)
    else
        x:AddMessage(outputFrame, message, color)
    end
end

EventHandlers.SpellStolen = function(args)
    if not x:Options_General_ShowDispells() then
        return
    end

    local message = string.format(format_dispell, XCT_STOLE, args.extraSpellName)
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
        EventHandlers.RUNE_POWER_UPDATE(nil, 0)
    else
        x:AddMessage(
            "power",
            string.format("+%s %s", message, x:Options_Power_ShowEnergyTypes() and _G[energy_type] or ""),
            color
        )
    end
end

EventHandlers.UNIT_HEALTH = function()
    if
        x:Options_General_ShowLowManaAndHealth()
        and UnitHealth(x.player.unit) / UnitHealthMax(x.player.unit) <= _G.COMBAT_TEXT_LOW_HEALTH_THRESHOLD
    then
        if not x.lowHealth then
            x:AddMessage("general", _G.HEALTH_LOW, "lowResourcesHealth")
            x.lowHealth = true
        end
    else
        x.lowHealth = false
    end
end

EventHandlers.UNIT_POWER_UPDATE = function(_, unit, powerType)
    -- Update for Class Combo Points
    UpdateUnitPower(unit, powerType)

    if
        select(2, UnitPowerType(x.player.unit)) == "MANA"
        and x:Options_General_ShowLowManaAndHealth()
        and UnitPower(x.player.unit) / UnitPowerMax(x.player.unit) <= _G.COMBAT_TEXT_LOW_MANA_THRESHOLD
    then
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
    if not x:Options_General_ShowProfessionSkillups() then
        return
    end

    local profession, newSkillLevel = msg:match("Your skill in (.+) has increased to (%d+).")
    if not profession or not newSkillLevel then
        return
    end

    x:AddMessage("general", profession .. " increased to " .. newSkillLevel .. "!", { 0, 0.44, 0.87 })
end

EventHandlers.CHAT_MSG_LOOT = function(_, msg)
    local preMessage, linkColor, itemString, itemName, amount =
        string.match(msg, "([^|]+)|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r[^%d]*(%d*)")

    if not preMessage or preMessage == "" then
        local format_getCraftedItemString = ""
        if x.locale == "koKR" then
            format_getCraftedItemString = "|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r.+ (.+)"
        end

        linkColor, itemString, itemName, preMessage = string.match(msg, format_getCraftedItemString)
    end

    if not itemString or itemString == "" then
        return
    end

    -- Decode item string: (linkQuality for pets only)
    local linkType, linkID = strsplit(":", itemString)

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
        local speciesName, speciesIcon, petType = C_PetJournal.GetPetInfoBySpeciesID(linkID)
        local petTypeName = PET_TYPE_SUFFIX[petType]
        local message = string.format(format_pet, speciesName, petTypeName)
        local itemQualityColor = ITEM_QUALITY_COLORS[itemQuality]

        -- Add the message
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
                icon =
                    string.format(format_loot_icon, itemTexture, x:Options_Loot_IconSize(), x:Options_Loot_IconSize())
            end

            local itemQualityText = ""
            if x:Options_Loot_ShowColorBlindMoney() then
                -- Item Quality (Color Blind)
                itemQualityText = string.format(format_lewtz_blind, _G[string.format(format_quality, itemQuality)])
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
    if not x:Options_Loot_ShowCurency() then
        return
    end

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
        icon = string.format(
            format_loot_icon,
            currencyInfo.iconFileID,
            x:Options_Loot_IconSize(),
            x:Options_Loot_IconSize()
        )
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
    if not x:Options_Loot_ShowMoney() then
        return
    end

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
    if not x:Options_Power_ShowGains() then
        return
    end

    if x:Options_Power_ShowResource("RUNES") then
        return
    end

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
    -- x:UpdateComboTracker()
    -- x:UpdateComboPointOptions(true)
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
    if icon and x.db.profile.frames.procs.iconsEnabled then
        local iconStr =
            string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t", icon, frameSettings.iconsSize, frameSettings.iconsSize)

        if x.db.profile.frames.procs.fontJustify == "LEFT" then
            message = iconStr .. "  " .. message
        else
            message = message .. " " .. iconStr
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
    -- TODO: Create a merger for faction and honor xp
    if not x:Options_General_ShowReputationChanges() then
        return
    end

    local faction, amount = GetCurrentCombatTextEventInfo()
    local num = math.floor(tonumber(amount) or 0)

    if num > 0 then
        x:AddMessage(
            "general",
            string.format("%s: +%s %s", _G.REPUTATION, x:Abbreviate(amount, "general"), faction),
            "reputationGain"
        )
    elseif num < 0 then
        x:AddMessage(
            "general",
            string.format("%s: -%s %s", _G.REPUTATION, x:Abbreviate(amount, "general"), faction),
            "reputationLoss"
        )
    end
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
            EventHandlers.HealingOutgoing(args)
        elseif args.suffix == "_DAMAGE" then
            EventHandlers.DamageOutgoing(args)
        elseif args.suffix == "_MISSED" then
            if args.missType == "ABSORB" then
                if x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage() then
                    -- This was fully absorbed, but we would like to display it... use the DamageOutgoing EventHandler
                    -- TODO What about fully absorbed heals?
                    args.amount = args.amountMissed
                    EventHandlers.DamageOutgoing(args)
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
            EventHandlers.HealingIncoming(args)
        elseif args.suffix == "_DAMAGE" then
            EventHandlers.DamageIncoming(args)
        elseif args.suffix == "_MISSED" then
            EventHandlers.IncomingMiss(args)
        elseif args.event == "SPELL_DISPEL" then
            if x:Options_General_ShowDispells() then
                local message

                if x.locale == "koKR" then
                    message = args.sourceName .. " 무효화:"
                else
                    message = args.sourceName .. " dispelled:"
                end

                local outputFrame = "general"
                local frameSettings = x:GetFrameSettings(outputFrame)
                if frameSettings then
                    message = x:GetSpellTextureFormatted(args.extraSpellId, message, frameSettings)

                    x:AddMessage(outputFrame, message, "dispellDebuffs")
                end
            end
        end
    end

    -- Player Auras
    if args.atPlayer and BuffsOrDebuffs[args.suffix] then
        EventHandlers.AuraIncoming(args)
    end
end

-- Register for the needed events
function x:RegisterCombatEvents()
    self:RegisterEvent("COMBAT_TEXT_UPDATE", EventHandlers.COMBAT_TEXT_UPDATE)
    self:RegisterEvent("UNIT_HEALTH", EventHandlers.UNIT_HEALTH)
    self:RegisterEvent("UNIT_POWER_UPDATE", EventHandlers.UNIT_POWER_UPDATE)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", EventHandlers.PLAYER_REGEN_DISABLED)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", EventHandlers.PLAYER_REGEN_ENABLED)
    self:RegisterEvent("UNIT_ENTERED_VEHICLE", EventHandlers.UNIT_ENTERED_VEHICLE)
    self:RegisterEvent("UNIT_EXITING_VEHICLE", EventHandlers.UNIT_EXITING_VEHICLE)
    self:RegisterEvent("PLAYER_ENTERING_WORLD", EventHandlers.PLAYER_ENTERING_WORLD)
    self:RegisterEvent("UNIT_PET", EventHandlers.UNIT_PET)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateComboPoints)
    self:RegisterEvent("CHAT_MSG_SKILL", EventHandlers.CHAT_MSG_SKILL)

    -- Loot frame
    self:RegisterEvent("CHAT_MSG_LOOT", EventHandlers.CHAT_MSG_LOOT)
    self:RegisterEvent("CHAT_MSG_CURRENCY", EventHandlers.CHAT_MSG_CURRENCY)
    self:RegisterEvent("CHAT_MSG_MONEY", EventHandlers.CHAT_MSG_MONEY)

    -- Class combo points / runes / ...
    if x.player.class == "DEATHKNIGHT" then
        self:RegisterEvent("RUNE_POWER_UPDATE", EventHandlers.RUNE_POWER_UPDATE)
    end

    self:RegisterEvent("UNIT_AURA", UpdateAuraTracking)
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", EventHandlers.ACTIVE_TALENT_GROUP_CHANGED)
    --self:RegisterEvent("UNIT_COMBO_POINTS", UpdateComboPoints)

    LibStub("xCombatParser-1.0"):RegisterCombat(self.onCombatLogEvent)
end
