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
 Power Type Definitions
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
 AddOn:UpdateCombatTextEvents(
    enable,     [BOOL] - Enable the events?
  )
    Registers or updates the combat text event frame
--]=====================================================]
function x:UpdateCombatTextEvents(enable)
    local f
    if x.combatEvents then
        x.combatEvents:UnregisterAllEvents()
        f = x.combatEvents
    else
        f = CreateFrame("FRAME")
    end

    if enable then
        -- Enabled Combat Text
        f:RegisterEvent("COMBAT_TEXT_UPDATE")
        f:RegisterEvent("UNIT_HEALTH")
        f:RegisterEvent("UNIT_POWER_UPDATE")
        f:RegisterEvent("PLAYER_REGEN_DISABLED")
        f:RegisterEvent("PLAYER_REGEN_ENABLED")
        f:RegisterEvent("UNIT_ENTERED_VEHICLE")
        f:RegisterEvent("UNIT_EXITING_VEHICLE")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:RegisterEvent("UNIT_PET")
        f:RegisterEvent("PLAYER_TARGET_CHANGED")
        f:RegisterEvent("CHAT_MSG_SKILL")

        -- Loot frame
        f:RegisterEvent("CHAT_MSG_LOOT")
        f:RegisterEvent("CHAT_MSG_CURRENCY")
        f:RegisterEvent("CHAT_MSG_MONEY")

        -- Class combo points / runes / ...
        if x.player.class == 'DEATHKNIGHT' then
            f:RegisterEvent("RUNE_POWER_UPDATE")
        end

        f:RegisterEvent("UNIT_AURA")
        f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
        --f:RegisterEvent("UNIT_COMBO_POINTS")
        f:RegisterEvent("PLAYER_TARGET_CHANGED")

        x.combatEvents = f
        f:SetScript("OnEvent", x.OnCombatTextEvent)

        LibStub("xCombatParser-1.0"):RegisterCombat(x.CombatLogEvent)
    else
        -- Disabled Combat Text
        f:SetScript("OnEvent", nil)
        LibStub("xCombatParser-1.0"):UnregisterCombat(x.CombatLogEvent)
    end
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
 String Formatters
--]=====================================================]
local format_pet = string.format("|cff798BDD[%s]:|r %%s (%%s)", string.gsub(BATTLE_PET_CAGE_ITEM_NAME, "%s?%%s", "")) -- [Caged]: Pet Name (Pet Family)

-- TODO: Remove old loot pattern
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):%d+:(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"
-- "You create: |cffa335ee|Hitem:124515::::::::100:254:4:3::530:::|h[Talisman of the Master Tracker]|h|r"
--local msg = "|cff1eff00|Hitem:108840:0:0:0:0:0:0:443688319:90:0:0:0|h[Warlords Intro Zone PH Mail Helm]|h|r"
--local format_loot = "([^|]*)|cff(%x*)|H([^:]*):(%d+):[-?%d+:]+|h%[?([^%]]*)%]|h|r?%s?x?(%d*)%.?"

local format_fade = "-%s"
local format_gain = "+%s"
local format_resist = "-%s |c%s(%s %s)|r"
local format_honor = string.gsub(COMBAT_TEXT_HONOR_GAINED, "%%s", "+%%s")
local format_crit = "%s%s%s"
local format_dispell = "%s: %s"
local format_quality = "ITEM_QUALITY%s_DESC"
local format_remove_realm = "(.*)-.*"

local format_spell_icon = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_msspell_icon_right = "%s |cff%sx%d|r |T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_msspell_icon_left = " |T%s:%d:%d:0:0:64:64:5:59:5:59|t %s |cff%sx%d|r"
local format_msspell_no_icon = "%s |cff%sx%d|r"
local format_loot_icon = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
local format_lewtz_blind = "(%s)"
local format_crafted = (LOOT_ITEM_CREATED_SELF:gsub("%%.*", "")) -- "You create: "
if x.locale == "koKR" then
    format_crafted = (LOOT_ITEM_CREATED_SELF:gsub("%%.+ ", ""))
end
local format_looted = (LOOT_ITEM_SELF:gsub("%%.*", "")) -- "You receive loot: "
local format_pushed = (LOOT_ITEM_PUSHED_SELF:gsub("%%.*", "")) -- "You receive item: "
local format_strcolor_white = "ffffff"
local format_currency_single = (CURRENCY_GAINED:gsub("%%s", "(.+)")) -- "You receive currency: (.+)."
local format_currency_multiple = (CURRENCY_GAINED_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")) -- "You receive currency: (.+) x(%d+)."

--[=====================================================[
 Message Formatters
--]=====================================================]
local xCTFormat = {}

function xCTFormat:SPELL_HEAL(outputFrame, spellID, amount, overhealing, critical, args, settings)
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
    if overhealing > 0 and x:Options_Outgoing_FormatOverhealing() then
        overhealing = x:Abbreviate(overhealing, outputFrame)
        message = message .. x:Options_Outgoing_FormatOverhealing(overhealing)
    end

    -- Add names
    message = message .. x.formatName(args, settings.names)

    -- Add Icons
    message = x:GetSpellTextureFormatted(
        spellID,
        message,
        x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
        x.db.profile.frames[outputFrame].spacerIconsEnabled,
        x.db.profile.frames[outputFrame].fontJustify
    )

    x:AddMessage(outputFrame, message, outputColor)
end

function xCTFormat:SPELL_PERIODIC_HEAL(outputFrame, spellID, amount, overhealing, critical, args, settings)
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
    if overhealing > 0 and x:Options_Outgoing_FormatOverhealing() then
        overhealing = x:Abbreviate(overhealing, outputFrame)
        message = message .. x:Options_Outgoing_FormatOverhealing(overhealing)
    end

    -- Add names
    message = message .. x.formatName(args, settings.names)

    -- Add Icons
    message = x:GetSpellTextureFormatted(
        spellID,
        message,
        x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
        x.db.profile.frames[outputFrame].spacerIconsEnabled,
        x.db.profile.frames[outputFrame].fontJustify
    )

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
 AddOn:OnCombatTextEvent(
    event,     [string] - Name of the event
    ...,       [multiple] - args from the combat event
  )
    This is the event handler and will act like a
  switchboard the send the events to where they need
  to go.
--]=====================================================]
function x.OnCombatTextEvent(self, event, ...)
    if event == "COMBAT_TEXT_UPDATE" then
        local subevent, arg2, arg3 = ...
        if x.combat_events[subevent] then
            x.combat_events[subevent](arg2, arg3)
        end
    else
        if x.events[event] then
            x.events[event](...)
        end
    end
end

function x:ShowAutoAttackIcons(frameName)
    return x.db.profile.frames[frameName] and x.db.profile.frames[frameName].iconsEnabledAutoAttack or false
end

--[=====================================================[
 AddOn:GetSpellTextureFormatted(
    spellID,        [number] - The spell ID you want the icon for
    message,        [string] - The message that will be used (usually the amount)
    iconSize,       [number] - The format size of the icon
    showInvisibleIcon,[bool] - Whether or not to include a blank icon (also req iconSize to be -1 if disabled)
    justify,        [string] - Can be 'LEFT' or 'RIGHT'
    strColor,       [string] - the color to be used or defaults white
    mergeCount      [number] - The number of events merged into this message
  )
  Returns:
    message,     [string] - the message contains the formatted icon

    Formats an icon quickly for use when outputting to a combat text frame.
--]=====================================================]
function x:GetSpellTextureFormatted(
    spellID,
    message,
    iconSize,
    showInvisibleIcon,
    justify,
    strColor,
    mergeCount
)
    strColor = strColor or format_strcolor_white

    local icon = x.BLANK_ICON
    if iconSize >= 1 then
        -- always show unless we specify enableIcons to be off (overriding iconSize to be -1)
        showInvisibleIcon = true

        if spellID == 0 then
            icon = PET_ATTACK_TEXTURE
        elseif type(spellID) == "string" then
            icon = spellID
        else
            icon = spellID and C_Spell.GetSpellTexture(addon.replaceSpellId[spellID] or spellID) or x.BLANK_ICON
        end
    end

    if mergeCount > 1 then
        if not showInvisibleIcon then
            message = string.format(format_msspell_no_icon, message, strColor, mergeCount)
        else
            if justify == "LEFT" then
                message = string.format(format_msspell_icon_left, icon, iconSize, iconSize, message, strColor, mergeCount)
            else
                message = string.format(format_msspell_icon_right, message, strColor, mergeCount, icon, iconSize, iconSize)
            end
        end
    else
        if showInvisibleIcon then
            if justify == "LEFT" then
                message = string.format("%s %s", string.format(format_spell_icon, icon, iconSize, iconSize), message)
            else
                message = string.format("%s%s", message, string.format(format_spell_icon, icon, iconSize, iconSize))
            end
        end
    end

    if x.enableMergerDebug then
        message = message .. " |cffFFFFFF[|cffFF0000ID:|r|cffFFFF00" .. (spellID or "No ID") .. "|r]|r"
    end

    return message
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
local function UpdateAuraTracking(unit)
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
        UpdateAuraTracking(entry.unit)

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
        message = message .. string.format(
            " |cffFFFF00(%s)|r",
            totalCount
        )
    end

    x:AddMessage(
        "loot",
        message,
        { item.r, item.g, item.b }
    )
end

--[=====================================================[
 Event handlers - Combat Text Events
--]=====================================================]
x.combat_events = {

    ["SPELL_ACTIVE"] = function(spellName)
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

        -- Add Icons
        if icon and x.db.profile.frames.procs.iconsEnabled then
            if x.db.profile.frames.procs.fontJustify == "LEFT" then
                message = string.format(format_spell_icon, icon, iconSize, iconSize) .. "  " .. message
            else
                message = message .. string.format(format_spell_icon, icon, iconSize, iconSize)
            end
        end

        x:AddMessage("procs", message, "spellProc")
    end,

    ["SPELL_CAST"] = function(spellName)
        if x:Options_Procs_ShowProcs() then
            x:AddMessage("procs", spellName, "spellReactive")
        end
    end,

    -- REMOVING PERIODIC_ENERGIZE, AS IT'S NOW COVERED BY SPELLENERGIZE Event

    -- TODO: Create a merger for faction and honor xp
    ["HONOR_GAINED"] = function() -- UNTESTED
        if not x:Options_General_ShowHonor() then
            return
        end

        local amount = GetCurrentCombatTextEventInfo()
        local num = math.floor(tonumber(amount) or 0)
        if num > 0 then
            x:AddMessage(
                "general",
                string.format(
                    format_honor,
                    _G.HONOR,
                    x:Abbreviate(amount, "general")
                ),
                "honorGains"
            )
        end
    end,

    ["FACTION"] = function()
        if not x:Options_General_ShowReputationChanges() then
            return
        end

        local faction, amount = GetCurrentCombatTextEventInfo()
        local num = math.floor(tonumber(amount) or 0)

        if num > 0 then
            x:AddMessage(
                "general",
                string.format(
                    "%s: +%s %s",
                    _G.REPUTATION,
                    x:Abbreviate(amount, "general"),
                    faction
                ),
                "reputationGain"
            )
        elseif num < 0 then
            x:AddMessage(
                "general",
                string.format(
                    "%s: -%s %s",
                    _G.REPUTATION,
                    x:Abbreviate(amount, "general"),
                    faction
                ),
                "reputationLoss"
            )
        end
    end,
}

--[=====================================================[
 Event handlers - General Events
--]=====================================================]
x.events = {
    ["UNIT_HEALTH"] = function()
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
    end,

    ["UNIT_POWER_UPDATE"] = function(unit, powerType)
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
    end,

    ["RUNE_POWER_UPDATE"] = function(runeIndex)
        if not x:Options_Power_ShowGains() then
            return
        end

        if x:Options_Power_ShowResource("RUNES") then
            return
        end

        if not x.DeathKnightRunes then
            x.DeathKnightRunes = {}
        end

        if runeIndex >= 1 and runeIndex <= 6 then
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
    end,

    ["PLAYER_REGEN_ENABLED"] = function()
        x.inCombat = false
        x:CombatStateChanged()
        if x:Options_Global_ClearWhenLeavingCombat() then
            -- only clear frames with icons
            x:Clear("general")
            x:Clear("outgoing")
            x:Clear("critical")
            x:Clear("damage")
            x:Clear("healing")
            x:Clear("power")
            x:Clear("procs")
            x:Clear("loot")
        end

        if x:Options_General_ShowCombatState() then
            x:AddMessage("general", _G.LEAVING_COMBAT, "combatLeaving")
        end
    end,

    ["PLAYER_REGEN_DISABLED"] = function()
        x.inCombat = true
        x:CombatStateChanged()
        if x:Options_General_ShowCombatState() then
            x:AddMessage("general", _G.ENTERING_COMBAT, "combatEntering")
        end
    end,

    ["UNIT_COMBO_POINTS"] = function()
        UpdateComboPoints()
    end,

    ["PLAYER_TARGET_CHANGED"] = function()
        UpdateComboPoints()
    end,

    ["UNIT_AURA"] = function(unit)
        UpdateAuraTracking(unit)
    end,

    ["UNIT_ENTERED_VEHICLE"] = function(unit)
        if unit == "player" then
            x:UpdatePlayer()
        end
    end,

    ["UNIT_EXITING_VEHICLE"] = function(unit)
        if unit == "player" then
            x:UpdatePlayer()
        end
    end,

    ["PLAYER_ENTERING_WORLD"] = function()
        x:UpdatePlayer()
        --x:UpdateComboPointOptions()
        x:Clear()

        -- Lazy Coding (Clear up messy libraries... yuck!)
        collectgarbage()
    end,

    ["UNIT_PET"] = function()
        x:UpdatePlayer()
    end,

    ["ACTIVE_TALENT_GROUP_CHANGED"] = function()
        x:UpdatePlayer()
    end, -- x:UpdateComboTracker(); x:UpdateComboPointOptions(true),

    ["CHAT_MSG_LOOT"] = function(msg)
        -- Fixing Loot for Legion
        local preMessage, linkColor, itemString, itemName, amount = string.match(
            msg,
            "([^|]+)|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r[^%d]*(%d*)"
        )

        if not preMessage or preMessage == "" then
            local format_getCraftedItemString = ""
            if x.locale == "koKR" then
                format_getCraftedItemString = "|cff(%x+)|H([^|]+)|h%[([^%]]+)%]|h|r.+ (.+)"
            end

            linkColor, itemString, itemName, preMessage = string.match(
                msg,
                format_getCraftedItemString
            )
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
                    icon = string.format(format_loot_icon, itemTexture, x:Options_Loot_IconSize(), x:Options_Loot_IconSize())
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
                    x:ScheduleTimer(
                        "AddLootMessageDelayed",
                        0.5,
                        {
                            id = linkID,
                            message = message,
                            r = itemQualityColor.r,
                            g = itemQualityColor.g,
                            b = itemQualityColor.b,
                        }
                    )
                else
                    -- Display the message directly
                    x:AddMessage(
                        "loot",
                        message,
                        { itemQualityColor.r, itemQualityColor.g, itemQualityColor.b }
                    )
                end
            end
        end
    end,

    ["CHAT_MSG_CURRENCY"] = function(msg)
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
            icon = string.format(format_loot_icon, currencyInfo.iconFileID, x:Options_Loot_IconSize(), x:Options_Loot_IconSize())
        end

        local message
        if tonumber(amountGained) > 1 then
            message = string.format(
                "%s: |cff798BDD+%s|r %s %s",
                _G.CURRENCY,
                amountGained,
                icon,
                currencyInfo.name
            )
        else
            message = string.format(
                "%s: %s %s",
                _G.CURRENCY,
                icon,
                currencyInfo.name
            )
        end

        if currencyInfo.quantity > 1 then
            message = message .. string.format(
                " |cffFFFF00(%s)|r",
                currencyInfo.quantity
            )
        end

        local qualityColor = ITEM_QUALITY_COLORS[currencyInfo.quality]

        x:AddMessage(
            "loot",
            message,
            { qualityColor.r, qualityColor.g, qualityColor.b, }
        )
    end,

    ["CHAT_MSG_SKILL"] = function(msg)
        if not x:Options_General_ShowProfessionSkillups() then
            return
        end

        local profession, newSkillLevel = msg:match("Your skill in (.+) has increased to (%d+).")
        if not profession or not newSkillLevel then
            return
        end

        x:AddMessage("general", profession .. " increased to " .. newSkillLevel .. "!", {0, 0.44, 0.87})
    end,

    ["CHAT_MSG_MONEY"] = function(msg)
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
    end,
}

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
    return string.format("ff%2X%2X%2X", math.floor(t[1] * 255 + 0.5), math.floor(t[2] * 255 + 0.5), math.floor(t[3] * 255 + 0.5))
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
            return true, string.format(PARTIAL_MISS_FORMATTERS[maxType], color, x:Abbreviate(args[maxType], outgoingFrame))
        end

        -- Show All the partial misses that exsist
        local message, color = ""
        if absorbed > 0 then
            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS.absorbed or FULL_MISS_COLORS.absorbed)
            )
            message = message .. string.format(PARTIAL_MISS_FORMATTERS.absorbed, color, x:Abbreviate(absorbed, outgoingFrame))
        end

        if blocked > 0 then
            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS.blocked or FULL_MISS_COLORS.blocked)
            )
            message = message .. string.format(PARTIAL_MISS_FORMATTERS.blocked, color, x:Abbreviate(blocked, outgoingFrame))
        end

        if resisted > 0 then
            color = hexNameColor(
                x:LookupColorByName(args.amount > 0 and PARTIAL_MISS_COLORS.resisted or FULL_MISS_COLORS.resisted)
            )
            message = message .. string.format(PARTIAL_MISS_FORMATTERS.resisted, color, x:Abbreviate(resisted, outgoingFrame))
        end

        return true, message
    else
        return false, ""
    end
end

-- =====================================================
--               The New Combat Handlers
-- =====================================================
local CombatEventHandlers = {
    ["HealingOutgoing"] = function(args)
        local spellName, spellSchool = args.spellName, args.spellSchool
        local spellID, isHoT, amount, overhealing =
            args.spellId, args.prefix == "SPELL_PERIODIC", args.amount, args.overhealing

        -- Keep track of spells that go by
        if x:Options_Filter_TrackSpells() then
            x.spellCache.spells[spellID] = true
        end

        if not x:Options_Outgoing_ShowHealing() then
            return
        end

        -- Check to see if this is a HoT
        if isHoT and not x:Options_Outgoing_ShowHots() then
            return
        end

        -- Filter Outgoing Healing Spell
        if x:Options_Filter_HideSpell(spellID) then
            return
        end

        -- Filter Overhealing
        if x:Options_IncomingHealing_ShowOverHealing() then
            if x:Options_Outgoing_SubtractOverhealing() then
                amount = amount - overhealing
            end
        else
            amount = amount - overhealing
            overhealing = 0
            if amount < 1 then
                return
            end
        end

        -- Figure out which frame and color to output
        local outputFrame, outputColor, critical = "outgoing", "healingOut", args.critical
        if critical then
            outputFrame = "critical"
            outputColor = "healingOutCritical"
        end

        -- Get the settings for the correct output frame
        local settings = x.db.profile.frames[outputFrame]

        -- HoTs only have one color
        if isHoT then
            outputColor = "healingOutPeriodic"
        end

        -- Condensed Critical Merge
        local spamMergerInterval = x:Options_SpamMerger_SpellInterval(spellID)
        if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            if critical then
                if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                    x:AddSpamMessage(
                        outputFrame,
                        spellID,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        "spellName",
                        spellName,
                        "spellSchool",
                        spellSchool,
                        "destinationController",
                        args:GetDestinationController()
                    )
                    return
                elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellID,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        "spellName",
                        spellName,
                        "spellSchool",
                        spellSchool,
                        "destinationController",
                        args:GetDestinationController()
                    )
                elseif x:Options_SpamMerger_HideMergedCriticals() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellID,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        "spellName",
                        spellName,
                        "spellSchool",
                        spellSchool,
                        "destinationController",
                        args:GetDestinationController()
                    )
                    return
                end
            else
                x:AddSpamMessage(
                    outputFrame,
                    spellID,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    spellName,
                    "spellSchool",
                    spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            end
        end

        if x:Options_Filter_OutgoingHealing_HideEvent(amount, critical) then
            return
        end

        -- TODO whats this?
        if args.event == "SPELL_PERIODIC_HEAL" then
            xCTFormat:SPELL_PERIODIC_HEAL(outputFrame, spellID, amount, overhealing, critical, args, settings)
        elseif args.event == "SPELL_HEAL" then
            xCTFormat:SPELL_HEAL(outputFrame, spellID, amount, overhealing, critical, args, settings)
        else
            x:Print("Please report: unhandled _HEAL event", args.event)
        end
    end,

    ["DamageOutgoing"] = function(args)
        local message
        local spellName, spellSchool = args.spellName, args.spellSchool
        local critical, spellID, amount = args.critical, args.spellId, args.amount
        local isEnvironmental, isSwing, isAutoShot, isDoT =
            args.prefix == "ENVIRONMENTAL",
            args.prefix == "SWING",
            spellID == 75,
            args.prefix == "SPELL_PERIODIC"
        local outputFrame, outputColorType = "outgoing"

        -- Keep track of spells that go by (Don't track Swings or Environmental damage)
        if not isEnvironmental and not isSwing and x:Options_Filter_TrackSpells() then
            x.spellCache.spells[spellID] = true
        end

        if not x:Options_Outgoing_ShowDamage() then
            return
        end

        -- Check to see if this is a HoT
        if isDoT and not x:Options_Outgoing_ShowDots() then
            return
        end

        -- Filter Outgoing Damage Spell
        if x:Options_Filter_HideSpell(spellID) then
            return
        end

        if isSwing and not args:IsSourceMyPet() and not args:IsSourceMyVehicle() then
            if critical and not x:Options_Outgoing_ShowAutoAttack() then
                return
            end
            if not critical and not x:Options_Critical_ShowAutoAttack() then
                return
            end
        end

        if x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage() then
            -- Its a partial absorb, add it to the amount
            amount = amount + (args.absorbed or 0)
        end

        -- Check to see if my pet is doing things
        if args:IsSourceMyPet() and (not x:Options_Outgoing_ShowKillCommandAsPlayerDamage() or spellID ~= 34026) then
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
                    spellID == 34026 and L_KILLCOMMAND or L_AUTOATTACK,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            end

            if not x:Options_Critical_ShowPetCrits() then
                critical = nil -- stupid spam fix for hunter pets
            end

            if isSwing then
                spellID = 0 -- this will get fixed later
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
                critical = nil -- stupid spam fix for hunter pets
            end
            if isSwing then
                spellID = 0 -- this will get fixed later
            end
        end

        -- Check for Critical Swings
        if critical then
            if (isSwing or isAutoShot) and x:Options_Critical_ShowAutoAttack() then
                outputFrame = "critical"
            elseif not isSwing and not isAutoShot then
                outputFrame = "critical"
            end
        end

        -- Lookup the color
        if isSwing or isAutoShot then
            outputColorType = critical and "meleeCrit" or "melee"
        end

        local outputColor = x.GetSpellSchoolColor(spellSchool, outputColorType)

        local spamMergerInterval = x:Options_SpamMerger_SpellInterval(spellID)
        if (isSwing or isAutoShot) and x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            if outputFrame == "critical" then
                if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                    x:AddSpamMessage(
                        outputFrame,
                        spellID,
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
                        spellID,
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
                        spellID,
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
                    spellID,
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
            if critical then
                if x:Options_SpamMerger_MergeCriticalsByThemselves() then
                    x:AddSpamMessage(
                        outputFrame,
                        spellID,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        "spellName",
                        spellName,
                        "spellSchool",
                        spellSchool,
                        "destinationController",
                        args:GetDestinationController()
                    )
                    return
                elseif x:Options_SpamMerger_MergeCriticalsWithOutgoing() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellID,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        "spellName",
                        spellName,
                        "spellSchool",
                        spellSchool,
                        "destinationController",
                        args:GetDestinationController()
                    )
                elseif x:Options_SpamMerger_HideMergedCriticals() then
                    x:AddSpamMessage(
                        "outgoing",
                        spellID,
                        amount,
                        outputColor,
                        spamMergerInterval,
                        "spellName",
                        spellName,
                        "spellSchool",
                        spellSchool,
                        "destinationController",
                        args:GetDestinationController()
                    )
                    return
                end
            else
                -- args:GetSourceController() / args:GetDestinationController()
                x:AddSpamMessage(
                    outputFrame,
                    spellID,
                    amount,
                    outputColor,
                    spamMergerInterval,
                    "spellName",
                    spellName,
                    "spellSchool",
                    spellSchool,
                    "destinationController",
                    args:GetDestinationController()
                )
                return
            end
        end

        if x:Options_Filter_OutgoingDamage_HideEvent(amount, critical) then
            -- Amount is not high enough
            return
        end

        local settings
        if critical and (not (isSwing or isAutoShot) or x:Options_Critical_ShowAutoAttack()) then
            settings = x.db.profile.frames["critical"]
            if not (isSwing or isAutoShot) or x:Options_Critical_PrefixAutoAttack() then
                message = string.format(
                    format_crit,
                    x.db.profile.frames.critical.critPrefix,
                    x:Abbreviate(amount, "critical"),
                    x.db.profile.frames.critical.critPostfix
                )
            else
                message = x:Abbreviate(amount, "critical")
            end
        else
            settings = x.db.profile.frames["outgoing"]
            message = x:Abbreviate(amount, "outgoing")
        end

        -- Add the Partial Miss Types
        if x:Options_Outgoing_ShowPartialMisses() then
            local hasPartialMiss, formattedMessage =
                GetPartialMiss(args, settings, critical and "critical" or "outgoing")
            if hasPartialMiss then
                message = message .. formattedMessage
            end
        end

        -- Add names
        message = message .. x.formatName(args, settings.names)

        -- Add Icons (Hide Auto Attack icons)
        if args.prefix ~= "SWING" or x:ShowAutoAttackIcons(outputFrame) then
            message = x:GetSpellTextureFormatted(
                args.spellId,
                message,
                x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
                x.db.profile.frames[outputFrame].spacerIconsEnabled,
                x.db.profile.frames[outputFrame].fontJustify
            )
        else
            message = x:GetSpellTextureFormatted(
                nil,
                message,
                x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
                x.db.profile.frames[outputFrame].spacerIconsEnabled,
                x.db.profile.frames[outputFrame].fontJustify
            )
        end

        x:AddMessage(outputFrame, message, outputColor)
    end,

    ["DamageIncoming"] = function(args)
        local message
        local spellName, spellSchool, outputFrame = args.spellName, args.spellSchool, "damage"
        local settings = x.db.profile.frames[outputFrame]

        -- Keep track of spells that go by
        if args.spellId and x:Options_Filter_TrackSpells() then
            x.spellCache.damage[args.spellId] = true
        end

        if args.spellId and x:Options_Filter_HideIncomingDamage(args.spellId) then
            return
        end

        local totalAmount = args.amount

        -- Check for resists
        if x:Options_IncomingDamage_ShowResistances() then
            totalAmount = totalAmount + (args.resisted or 0) + (args.blocked or 0) + (args.absorbed or 0)

            local resistedAmount, resistType, color

            -- Check for resists (full and partials)
            if (args.resisted or 0) > 0 then
                resistType, resistedAmount = RESIST, args.amount > 0 and args.resisted
                color = resistedAmount and "missTypeResist" or "missTypeResistPartial"
            elseif (args.blocked or 0) > 0 then
                resistType, resistedAmount = BLOCK, args.amount > 0 and args.blocked
                color = resistedAmount and "missTypeBlock" or "missTypeBlockPartial"
            elseif (args.absorbed or 0) > 0 then
                resistType, resistedAmount = ABSORB, args.amount > 0 and args.absorbed
                color = resistedAmount and "missTypeAbsorb" or "missTypeAbsorbPartial"
            end

            if resistType then
                -- Craft the new message (if is partial)
                if resistedAmount then
                    -- format_resist: "-%s |c%s(%s %s)|r"
                    color = hexNameColor(x:LookupColorByName(color))
                    message = string.format(
                        format_resist,
                        x:Abbreviate(args.amount, outputFrame),
                        color,
                        resistType,
                        x:Abbreviate(resistedAmount, outputFrame)
                    )
                else
                    -- It was a full resist
                    message = resistType -- TODO: Add an option to still see how much was reisted on a full resist
                end
            end
        end

        -- If this is not a resist, then lets format it as normal
        if not message then
            -- Format Criticals and also abbreviate values
            if args.critical then
                message = string.format(
                    format_crit,
                    x.db.profile.frames[outputFrame].critPrefix,
                    x:Abbreviate(-args.amount, outputFrame),
                    x.db.profile.frames[outputFrame].critPostfix
                )
            else
                message = x:Abbreviate(-args.amount, outputFrame)
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
                -args.amount,
                colorOverride,
                spamMergerInterval,
                "spellName",
                spellName,
                "spellSchool",
                spellSchool,
                "sourceController",
                args:GetSourceController()
            )
            return
        end

        if x:Options_Filter_IncomingDamage_HideEvent(totalAmount, args.critical) then
            return
        end

        -- Add names
        message = message .. x.formatName(args, settings.names, true)

        -- Add Icons (Hide Auto Attack icons)
        if args.prefix ~= "SWING" or x:ShowAutoAttackIcons(outputFrame) then
            message = x:GetSpellTextureFormatted(
                args.spellId,
                message,
                x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
                x.db.profile.frames[outputFrame].spacerIconsEnabled,
                x.db.profile.frames[outputFrame].fontJustify
            )
        else
            message = x:GetSpellTextureFormatted(
                nil,
                message,
                x.db.profile.frames[outputFrame].iconsEnabled and x.db.profile.frames[outputFrame].iconsSize or -1,
                x.db.profile.frames[outputFrame].spacerIconsEnabled,
                x.db.profile.frames[outputFrame].fontJustify
            )
        end

        -- Output message
        x:AddMessage(outputFrame, message, x.GetSpellSchoolColor(args.spellSchool, colorOverride))
    end,

    ["HealingIncoming"] = function(args)
        local amount, isHoT = args.amount, args.prefix == "SPELL_PERIODIC"
        local color = isHoT and "healingTakenPeriodic" or args.critical and "healingTakenCritical" or "healingTaken"
        local settings = x.db.profile.frames["healing"]

        if x:Options_Filter_TrackSpells() then
            x.spellCache.healing[args.spellId] = true
        end

        if x:Options_Filter_HideIncomingHealing(args.spellId) then
            return
        end

        -- Adjust the amount if the user doesnt want over healing
        if not x:Options_IncomingHealing_ShowOverHealing() then
            amount = amount - args.overhealing
        end

        -- Don't show healing that gets absorbed by a debuff or mechanic
        if x:Options_IncomingHealing_HideAbsorbedHealing() then
            amount = amount - args.absorbed
        end

        -- Filter out small amounts
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

        -- format_gain = "+%s"
        local message = string.format(format_gain, x:Abbreviate(amount, "healing"))

        local spamMergerInterval = x:Options_SpamMerger_IncomingHealingInterval()
        if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            x:AddSpamMessage(
                "healing",
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

            -- Add names
            message = message .. x.formatName(args, settings.names, true)

            -- Add the icon
            message = x:GetSpellTextureFormatted(
                args.spellId,
                message,
                x.db.profile.frames.healing.iconsEnabled and x.db.profile.frames.healing.iconsSize or -1,
                x.db.profile.frames.healing.spacerIconsEnabled,
                x.db.profile.frames.healing.fontJustify
            )

            x:AddMessage("healing", message, color)
        end
    end,

    ["AuraIncoming"] = function(args)
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
        local color, message
        if isGaining then
            message = string.format(format_gain, args.spellName)
            color = isBuff and "buffsGained" or "debuffsGained"
        else
            message = string.format(format_fade, args.spellName)
            color = isBuff and "buffsFaded" or "debuffsFaded"
        end

        -- Add the icon
        message = x:GetSpellTextureFormatted(
            args.spellId,
            message,
            x.db.profile.frames.general.iconsEnabled and x.db.profile.frames.general.iconsSize or -1,
            x.db.profile.frames.general.spacerIconsEnabled,
            x.db.profile.frames.general.fontJustify
        )

        x:AddMessage("general", message, color)
    end,

    ["KilledUnit"] = function(args)
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
    end,

    ["InterruptedUnit"] = function(args)
        if not x:Options_General_ShowInterrupts() then
            return
        end

        -- Create and format the message
        local message = string.format(format_dispell, INTERRUPTED, args.extraSpellName)

        -- Add the icon
        message = x:GetSpellTextureFormatted(
            args.extraSpellId,
            message,
            x.db.profile.frames.general.iconsEnabled and x.db.profile.frames.general.iconsSize or -1,
            x.db.profile.frames.general.spacerIconsEnabled,
            x.db.profile.frames.general.fontJustify
        )

        x:AddMessage("general", message, "interrupts")
    end,

    ["OutgoingMiss"] = function(args)
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

        -- Absorbs are handled in the x.CombatLogEvent() function
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

        local message = _G["COMBAT_TEXT_" .. args.missType]

        local spamMergerInterval = x:Options_SpamMerger_OutgoingDamageMissesInterval()
        if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            x:AddSpamMessage(
                "outgoing",
                message,
                0,
                "misstypesOut",
                spamMergerInterval
            )
            return
        end

        -- Add Icons
        message = x:GetSpellTextureFormatted(
            spellId,
            message,
            x.db.profile.frames.outgoing.iconsEnabled and x.db.profile.frames.outgoing.iconsSize or -1,
            x.db.profile.frames.outgoing.spacerIconsEnabled,
            x.db.profile.frames.outgoing.fontJustify
        )

        x:AddMessage("outgoing", message, "misstypesOut")
    end,

    ["IncomingMiss"] = function(args)
        if not x:Options_IncomingDamage_ShowMissTypes() then
            return
        end

        -- Check if incoming spell is filtered
        if x:Options_Filter_HideIncomingDamage(args.spellId) then
            return
        end

        local message = _G["COMBAT_TEXT_" .. args.missType]
        local color = missTypeColorLookup[args.missType] or "misstypesOut"

        local spamMergerInterval = x:Options_SpamMerger_IncomingMissesInterval()
        if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            x:AddSpamMessage(
                "damage",
                message,
                0,
                color,
                spamMergerInterval
            )
            return
        end

        -- Add Icons
        message = x:GetSpellTextureFormatted(
            args.spellId,
            message,
            x.db.profile.frames.damage.iconsEnabled and x.db.profile.frames.damage.iconsSize or -1,
            x.db.profile.frames.damage.spacerIconsEnabled,
            x.db.profile.frames.damage.fontJustify
        )

        x:AddMessage("damage", message, color)
    end,

    ["SpellDispel"] = function(args)
        if not x:Options_General_ShowDispells() then
            return
        end

        local color = args.auraType == "BUFF" and "dispellBuffs" or "dispellDebuffs"
        local message = string.format(format_dispell, XCT_DISPELLED, args.extraSpellName)

        -- Add Icons
        message = x:GetSpellTextureFormatted(
            args.extraSpellId,
            message,
            x.db.profile.frames.general.iconsEnabled and x.db.profile.frames.general.iconsSize or -1,
            x.db.profile.frames.general.spacerIconsEnabled,
            x.db.profile.frames.general.fontJustify
        )

        local spamMergerInterval = x:Options_SpamMerger_DispellInterval()
        if x:Options_SpamMerger_EnableSpamMerger() and spamMergerInterval > 0 then
            x:AddSpamMessage("general", args.extraSpellName, message, color, spamMergerInterval)
        else
            x:AddMessage("general", message, color)
        end
    end,

    ["SpellStolen"] = function(args)
        if not x:Options_General_ShowDispells() then
            return
        end

        local message = string.format(format_dispell, XCT_STOLE, args.extraSpellName)

        -- Add Icons
        message = x:GetSpellTextureFormatted(
            args.extraSpellId,
            message,
            x.db.profile.frames.general.iconsEnabled and x.db.profile.frames.general.iconsSize or -1,
            x.db.profile.frames.general.spacerIconsEnabled,
            x.db.profile.frames.general.fontJustify
        )

        x:AddMessage("general", message, "dispellStolen")
    end,

    ["SpellEnergize"] = function(args)
        if not x:Options_Power_ShowGains() then
            return
        end

        if math.abs(tonumber(args.amount)) <= tonumber(x:Options_Filter_PlayerPowerMinimumThreshold()) then
            return
        end

        -- TODO use Enum.PowerType instead?
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
            x.events["RUNE_POWER_UPDATE"](0)
        else
            x:AddMessage(
                "power",
                string.format("+%s %s", message, x:Options_Power_ShowEnergyTypes() and _G[energy_type] or ""),
                color
            )
        end
    end,
}

local BuffsOrDebuffs = {
    ["_AURA_APPLIED"] = true,
    ["_AURA_REMOVED"] = true,
    ["_AURA_APPLIED_DOSE"] = true,
    ["_AURA_REMOVED_DOSE"] = true,
    --["_AURA_REFRESH"] = true, -- I dont know how we should support this
}

function x.CombatLogEvent(args)
    -- Is the source someone we care about?
    if args.isPlayer or args:IsSourceMyVehicle() or x:Options_Outgoing_ShowPetDamage() and args:IsSourceMyPet() then
        if args.suffix == "_HEAL" then
            CombatEventHandlers.HealingOutgoing(args)
        elseif args.suffix == "_DAMAGE" then
            CombatEventHandlers.DamageOutgoing(args)
        elseif args.suffix == "_MISSED" then
            if args.missType == "ABSORB" then
                if x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage() then
                    -- This was fully absorbed, but we would like to display it... use the DamageOutgoing EventHandler
                    -- TODO What about fully absorbed heals?
                    args.amount = args.amountMissed
                    CombatEventHandlers.DamageOutgoing(args)
                end
            else
                CombatEventHandlers.OutgoingMiss(args)
            end
        elseif args.event == "PARTY_KILL" then
            CombatEventHandlers.KilledUnit(args)
        elseif args.event == "SPELL_INTERRUPT" then
            CombatEventHandlers.InterruptedUnit(args)
        elseif args.event == "SPELL_DISPEL" then
            CombatEventHandlers.SpellDispel(args)
        elseif args.event == "SPELL_STOLEN" then
            CombatEventHandlers.SpellStolen(args)
        elseif args.suffix == "_ENERGIZE" then
            CombatEventHandlers.SpellEnergize(args)
        end
    end

    -- Is the destination someone we care about?
    if args.atPlayer or args:IsDestinationMyVehicle() then
        if args.suffix == "_HEAL" then
            CombatEventHandlers.HealingIncoming(args)
        elseif args.suffix == "_DAMAGE" then
            CombatEventHandlers.DamageIncoming(args)
        elseif args.suffix == "_MISSED" then
            CombatEventHandlers.IncomingMiss(args)
        elseif args.event == "SPELL_DISPEL" then
            if x:Options_General_ShowDispells() then
                local message = args.sourceName .. " dispelled:"

                if x.locale == "koKR" then
                    message = args.sourceName .. " 무효화:"
                end

                message = x:GetSpellTextureFormatted(
                    args.extraSpellId,
                    message,
                    x.db.profile.frames.general.iconsEnabled and x.db.profile.frames.general.iconsSize or -1,
                    x.db.profile.frames.general.spacerIconsEnabled,
                    x.db.profile.frames.general.fontJustify
                )

                x:AddMessage("general", message, "dispellDebuffs")
            end
        end
    end

    -- Player Auras
    if args.atPlayer and BuffsOrDebuffs[args.suffix] then
        CombatEventHandlers.AuraIncoming(args)
    end
end
