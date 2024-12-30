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
local x = addon.engine

-- Global Frame Settings
function x:Options_Global_ClearWhenLeavingCombat()
    return x.db.profile.frameSettings.clearLeavingCombat
end


-- Frame General
function x:Options_General_ShowHonor()
    return x.db.profile.frames.general.showHonorGains
end

function x:Options_General_ShowReputationChanges()
    return x.db.profile.frames.general.showRepChanges
end

function x:Options_General_ShowLowManaAndHealth()
    return x.db.profile.frames.general.showLowManaHealth
end

function x:Options_General_ShowCombatState()
    return x.db.profile.frames.general.showCombatState
end

function x:Options_General_ShowInterrupts()
    return x.db.profile.frames.general.showInterrupts
end

function x:Options_General_ShowDispells()
    return x.db.profile.frames.general.showDispells
end

function x:Options_General_ShowPartyKill()
    return x.db.profile.frames.general.showPartyKills
end

function x:Options_General_ShowBuffGainsAndFades()
    return x.db.profile.frames.general.showBuffs
end

function x:Options_General_ShowDebuffGainsAndFades()
    return x.db.profile.frames.general.showDebuffs
end

function x:Options_General_ShowProfessionSkillups()
    return x.db.profile.frames.general.showProfessionSkillups
end

-- Frame Outgoing
function x:Options_Outgoing_ShowDamage()
    return x.db.profile.frames.outgoing.enableOutDmg
end

function x:Options_Outgoing_ShowHealing()
    return x.db.profile.frames.outgoing.enableOutHeal
end

function x:Options_Outgoing_ShowPetDamage()
    return x.db.profile.frames.outgoing.enablePetDmg
end

function x:Options_Outgoing_ShowVehicleDamage()
    return x.db.profile.frames.outgoing.enableVehicleDmg
end

function x:Options_Outgoing_ShowKillCommandAsPlayerDamage()
    return x.db.profile.frames.outgoing.enableKillCommand
end

function x:Options_Outgoing_ShowAutoAttack()
    return x.db.profile.frames.outgoing.enableAutoAttack_Outgoing
end

function x:Options_Outgoing_ShowPetAutoAttack()
    return x.db.profile.frames.outgoing.enablePetAutoAttack_Outgoing
end

function x:Options_Outgoing_ShowDots()
    return x.db.profile.frames.outgoing.enableDotDmg
end

function x:Options_Outgoing_ShowHots()
    return x.db.profile.frames.outgoing.enableHots
end

function x:Options_Outgoing_ShowImmunes()
    return x.db.profile.frames.outgoing.enableImmunes
end

function x:Options_Outgoing_ShowMisses()
    return x.db.profile.frames.outgoing.enableMisses
end

function x:Options_Outgoing_ShowAbsorbedDamageAsNormalDamage()
    return x.db.profile.frames.outgoing.enableAbsorbs
end

function x:Options_Outgoing_ShowPartialMisses()
    return x.db.profile.frames.outgoing.enablePartialMisses
end

-- TODO currently unused
function x:Options_Outgoing_ShowOverhealing()
    return x.db.profile.frames.outgoing.enableOverhealing
end

function x:Options_Outgoing_FormatOverhealing()
    return x.db.profile.frames.outgoing.enableOverhealingFormat
end

function x:Options_Outgoing_OverhealingPrefix()
    return x.db.profile.frames.outgoing.overhealingPrefix
end

function x:Options_Outgoing_OverhealingPostfix()
    return x.db.profile.frames.outgoing.overhealingPostfix
end

function x:Options_Outgoing_FormatOverhealing(amount)
    return x:Options_Outgoing_OverhealingPrefix()
        .. amount
        .. x:Options_Outgoing_OverhealingPostfix()
end

function x:Options_Outgoing_SubtractOverhealing()
    return x.db.profile.frames.outgoing.enableOverhealingSubtraction
end


-- Frame Outgoing (Criticals)
function x:Options_Critical_ShowAutoAttack()
    return x.db.profile.frames.outgoing.enableAutoAttack_Critical
end

function x:Options_Critical_PrefixAutoAttack()
    return x.db.profile.frames.critical.prefixAutoAttack_Critical
end

function x:Options_Critical_ShowPetCrits()
    return x.db.profile.frames.critical.petCrits
end


-- Frame Incoming (Damage)
function x:Options_IncomingDamage_ShowMissTypes()
    return x.db.profile.frames.damage.showDodgeParryMiss
end

function x:Options_IncomingDamage_ShowResistances()
    return x.db.profile.frames.damage.showDamageReduction
end


-- Frame Incoming (Healing)
function x:Options_IncomingHealing_ShowOnlyMyHeals()
    return x.db.profile.frames.healing.showOnlyMyHeals
end

function x:Options_IncomingHealing_ShowOnlyMyPetsHeals()
    return x.db.profile.frames.healing.showOnlyPetHeals
end

function x:Options_IncomingHealing_ShowOverHealing()
    return x.db.profile.frames.healing.enableOverHeal
end

function x:Options_IncomingHealing_HideAbsorbedHealing()
    return x.db.profile.frames.healing.hideAbsorbedHeals
end


-- Frame Class Power
function x:Options_Power_ShowGains()
    return x.db.profile.frames.power.showEnergyGains
end

function x:Options_Power_ShowEnergyTypes()
    return x.db.profile.frames.power.showEnergyType
end

function x:Options_Power_ShowResource(resource)
    if x.db.profile.frames.power["disableResource_" .. resource] ~= nil then
        return x.db.profile.frames.power["disableResource_" .. resource]
    end

    return true
end


-- Frame Special Effects (Procs)
function x:Options_Procs_ShowProcs()
    return x.db.profile.frames.procs.enabledFrame
end


-- Frame Loot, Currency & Money
function x:Options_Loot_ShowItems()
    return x.db.profile.frames.loot.showItems
end

function x:Options_Loot_ShowItemTypes()
    return x.db.profile.frames.loot.showItemTypes
end

function x:Options_Loot_ShowMoney()
    return x.db.profile.frames.loot.showMoney
end

function x:Options_Loot_ShowCurency()
    return x.db.profile.frames.loot.showCurrency
end

function x:Options_Loot_ShowItemTotals()
    return x.db.profile.frames.loot.showItemTotal
end

function x:Options_Loot_ShowCraftedItems()
    return x.db.profile.frames.loot.showCrafted
end

function x:Options_Loot_ShowQuestItems()
    return x.db.profile.frames.loot.showQuest
end

function x:Options_Loot_ShowPurchasedItems()
    return x.db.profile.frames.loot.showPurchased
end

function x:Options_Loot_ShowColorBlindMoney()
    return x.db.profile.frames.loot.colorBlindMoney
end

function x:Options_Loot_ItemQualityFilter()
    return x.db.profile.frames.loot.filterItemQuality
end

function x:Options_Loot_ShowIcons()
    return x.db.profile.frames.loot.iconsEnabled
end

function x:Options_Loot_IconSize()
    return x.db.profile.frames.loot.iconsSize
end

function x:Options_Loot_EnableSpacerIcons()
    return x.db.profile.frames.loot.spacerIconsEnabled
end


-- Spam Merger
function x:Options_SpamMerger_EnableSpamMerger()
    return x.db.profile.spells.enableMerger
end

function x:Options_SpamMerger_FallbackInterval()
    return x.db.profile.spells.mergeEverythingInterval
end

function x:Options_SpamMerger_IncomingHealingInterval()
    return x.db.profile.spells.mergeIncomingHealingInterval or 0
end

function x:Options_SpamMerger_IncomingDamageInterval()
    return x.db.profile.spells.mergeIncomingDamageInterval or 0
end

function x:Options_SpamMerger_PetAttackInterval()
    return x.db.profile.spells.mergePetInterval
end

function x:Options_SpamMerger_MergeCriticalsWithOutgoing()
    return x.db.profile.spells.mergeCriticalsWithOutgoing
end

function x:Options_SpamMerger_MergeCriticalsByThemselves()
    return x.db.profile.spells.mergeCriticalsByThemselves
end

function x:Options_SpamMerger_DontMergeCriticals()
    return x.db.profile.spells.mergeDontMergeCriticals
end

function x:Options_SpamMerger_HideMergedCriticals()
    return x.db.profile.spells.mergeHideMergedCriticals
end

function x:Options_SpamMerger_DispellInterval()
    return x.db.profile.spells.mergeDispellInterval or 0
end

function x:Options_SpamMerger_IncomingMissesInterval()
    return x.db.profile.spells.mergeIncomingMissesInterval or 0
end

function x:Options_SpamMerger_OutgoingDamageMissesInterval()
    return x.db.profile.spells.mergeOutgoingDamageMissesInterval or 0
end

function x:Options_SpamMerger_SpellInterval(spellId)
    if x.db.profile.spells.merge[spellId] ~= nil and x.db.profile.spells.merge[spellId].interval ~= nil then
        return x.db.profile.spells.merge[spellId].interval
    end

    return x:Options_SpamMerger_FallbackInterval()
end


-- Spell Filter
function x:Options_Filter_PlayerPowerMinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterPowerValue)
end

function x:Options_Filter_OutgoingDamage_Noncritical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterOutgoingDamageValue)
end

function x:Options_Filter_OutgoingDamage_Critical_UseOwnThreshold()
    return x.db.profile.spellFilter.filterOutgoingDamageCritEnabled
end

function x:Options_Filter_OutgoingDamage_Critical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterOutgoingDamageCritValue)
end

function x:Options_Filter_OutgoingDamage_HideEvent(value, critical)
    if critical and x:Options_Filter_OutgoingDamage_Critical_UseOwnThreshold() then
        return tonumber(x:Options_Filter_OutgoingDamage_Critical_MinimumThreshold()) > value
    end

    return tonumber(x:Options_Filter_OutgoingDamage_Noncritical_MinimumThreshold()) > value
end

function x:Options_Filter_OutgoingHealing_Noncritical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterOutgoingHealingValue)
end

function x:Options_Filter_OutgoingHealing_Critical_UseOwnThreshold()
    return x.db.profile.spellFilter.filterOutgoingHealingCritEnabled
end

function x:Options_Filter_OutgoingHealing_Critical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterOutgoingHealingCritValue)
end

function x:Options_Filter_OutgoingHealing_HideEvent(value, critical)
    if critical and x:Options_Filter_OutgoingHealing_Critical_UseOwnThreshold() then
        return tonumber(x:Options_Filter_OutgoingHealing_Critical_MinimumThreshold()) > value
    end

    return tonumber(x:Options_Filter_OutgoingHealing_Noncritical_MinimumThreshold()) > value
end

function x:Options_Filter_IncomingDamage_Noncritical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterIncomingDamageValue)
end

function x:Options_Filter_IncomingDamage_Critical_UseOwnThreshold()
    return x.db.profile.spellFilter.filterIncomingDamageCritEnabled
end

function x:Options_Filter_IncomingDamage_Critical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterIncomingDamageCritValue)
end

function x:Options_Filter_IncomingDamage_HideEvent(value, critical)
    if critical and x:Options_Filter_IncomingDamage_Critical_UseOwnThreshold() then
        return tonumber(x:Options_Filter_IncomingDamage_Critical_MinimumThreshold()) > value
    end

    return tonumber(x:Options_Filter_IncomingDamage_Noncritical_MinimumThreshold()) > value
end

function x:Options_Filter_IncomingHealing_Noncritical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterIncomingHealingValue)
end

function x:Options_Filter_IncomingHealing_Critical_UseOwnThreshold()
    return x.db.profile.spellFilter.filterIncomingHealingCritEnabled
end

function x:Options_Filter_IncomingHealing_Critical_MinimumThreshold()
    return tostring(x.db.profile.spellFilter.filterIncomingHealingCritValue)
end

function x:Options_Filter_IncomingHealing_HideEvent(value, critical)
    if critical and x:Options_Filter_IncomingHealing_Critical_UseOwnThreshold() then
        return tonumber(x:Options_Filter_IncomingHealing_Critical_MinimumThreshold()) > value
    end

    return tonumber(x:Options_Filter_IncomingHealing_Noncritical_MinimumThreshold()) > value
end

function x:Options_Filter_TrackSpells()
    return x.db.profile.spellFilter.trackSpells
end

function x:Options_Filter_HideBuff(name)
    local hidden = x.db.profile.spellFilter.listBuffs[name]
    if x.db.profile.spellFilter.whitelistBuffs then
        return not hidden
    end
    return hidden
end

function x:Options_Filter_HideDebuff(name)
    local hidden = x.db.profile.spellFilter.listDebuffs[name]
    if x.db.profile.spellFilter.whitelistDebuffs then
        return not hidden
    end
    return hidden
end

function x:Options_Filter_HideProc(name)
    local hidden = x.db.profile.spellFilter.listProcs[name]
    if x.db.profile.spellFilter.whitelistProcs then
        return not hidden
    end
    return hidden
end

function x:Options_Filter_HideItem(name)
    local hidden = x.db.profile.spellFilter.listItems[name]
    if x.db.profile.spellFilter.whitelistItems then
        return not hidden
    end
    return hidden
end

function x:Options_Filter_HideSpell(spellId)
    local hidden = x.db.profile.spellFilter.listSpells[tostring(spellId)]
    if x.db.profile.spellFilter.whitelistSpells then
        return not hidden
    end
    return hidden
end

function x:Options_Filter_HideIncomingDamage(spellId)
    local hidden = x.db.profile.spellFilter.listDamage[tostring(spellId)]
    if x.db.profile.spellFilter.whitelistDamage then
        return not hidden
    end
    return hidden
end

function x:Options_Filter_HideIncomingHealing(spellId)
    local hidden = x.db.profile.spellFilter.listHealing[tostring(spellId)]
    if x.db.profile.spellFilter.whitelistHealing then
        return not hidden
    end
    return hidden
end


-- Other options
function x:CVar_BypassCVars()
    return x.db.profile.bypassCVars
end
