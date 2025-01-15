
# Parsed Event Args --- Parameters

### Base Parameters
| `args.`*index* | Description |
| ---:|:--- |
| `timestamp` | Uses the function [time()](http://wow.gamepedia.com/API_time) to reference the time of the event when the client received it from the server. |
| `event` | The full name of the event. This is only useful when looking for a specific event or determining if a special event was triggered. |
| `hideCaster` | This parameter lets you know when there is no adequate source name for the event. The parameter `sourceName` will generally be a nil value. <br><br> __NOTE:__ This parser will recolor Environmental events with relevant names and spell IDs. So if this is set, you **_still_** may want to show the `sourceName`. I am considering turning this off for environmental events. |
| `sourceGUID` | The [GUID](http://wow.gamepedia.com/GUID) of the source.
| `sourceName` | The localized name of the source. If `hideCaster` is set, this value may be `nil`, unless the event is environmental. |
| `sourceFlags` | The [unit flags](http://wow.gamepedia.com/UnitFlag) of the source. See [Combat Object Methods](#NEED-LINK) for a set of parsing functions. May be `nil` if you try parsing it yourself. |
| `sourceRaidFlags` | The [raid flags](http://wow.gamepedia.com/RaidFlag) of the source. See [Raid Target Methods](#NEED-LINK) for a set of parsing functions. |
| `destGUID` | The [GUID](http://wow.gamepedia.com/GUID) of the destination.
| `destName` | The localized name of the destination. |
| `destFlags` | The [unit flags](http://wow.gamepedia.com/UnitFlag) of the destination. See [Combat Object Methods](#NEED-LINK) for a set of parsing functions. |
| `destRaidFlags` | The [raid flags](http://wow.gamepedia.com/RaidFlag) of the destination. See [Raid Target Methods](#NEED-LINK) for a set of parsing functions. |


### Event Prefixes

Events with the following prefixes will also have some additional parameters

| `args.prefix` | Parameters | | |
|:--- |:---:|:---:|:---:|
| `"SWING"` | *none* | | |
| `"RANGE"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"SPELL"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"SPELL_PERIODIC"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"SPELL_BUILDING"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"ENVIRONMENTAL"` | [`environmentalType`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Environmental_Type) | | |

> __NOTE:__ The use of `spellSchool` above is specific to the spell that was cast. For example, if you cast a _Holy_ spell that did Arcane + Holy (_Divine_) damage, then `spellSchool` would be _Holy_ and `school` would be _Divine_.


### Event Suffixes
Use `args.suffix == "_????"` to view which additional parameters each suffix has.


#### `_DAMAGE`--- Additional Parameters

This is arguably one of the most complicated suffixes and will have its own section dealing with it.

| `args.`*index* | Description |
| ---:|:--- |
| `amount` | The _final_ amount of damage that the destination took from the source in the event. |
| `overkill` | If the destination was killed by the source, this will specify the negative health of the destination. This will be `nil` most of the time. |
| `school` | Specifies the [spell school](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) that was used to damage the destination. It is most useful for coloring the damage amount. |
| `resisted` | Shows how much damage was subtracted from `amount` that was resisted by the destination. You can use `_G["RESIST"]` for a localized string. |
| `blocked` | Shows how much damage was subtracted from `amount` that was blocked by the destination. You can use `_G["BLOCK"]` for a localized string. |
| `absorbed` | Shows how much damage was subtracted from `amount` that was absorbed by the destination. You can use `_G["ABSORB"]` for a localized string. |
| `critical` | A true/false flag that informs if the event was a critical strike. |
| `glancing` | A true/false flag that informs if the event was a glancing blow. |
| `crushing` | A true/false flag that informs if the event was a crushing blow. |
| `isOffHand` | A true/false flag that informs if the event was from the source's off-hand. |

#### `_ABSORBED`--- Additional Parameters

Another complicated suffix and relatively new. If it has `"SPELL"` as its prefix, it will bring `spellId`, `spellName`, and `spellSchool` arguments.

| `args.`*index* | Description |
| ---:|:--- |
| `casterGUID` | The [GUID](http://wow.gamepedia.com/GUID) of the source that casted the absorb-aura. |
| `casterName` | The localized name of the source that casted the absorb-aura. |
| `casterFlags` | The [unit flags](http://wow.gamepedia.com/UnitFlag) of the source that casted the absorb-aura. See [Combat Object Methods](#NEED-LINK) for a set of parsing functions. May be `nil` if you try parsing it yourself. |
| `casterRaidFlags` | The [raid flags](http://wow.gamepedia.com/RaidFlag) of the source that casted the absorb-aura. See [Raid Target Methods](#NEED-LINK) for a set of parsing functions. |
| `absorbSpellId` | The spell ID of the absorb-aura.<br><br>__NOTE:__ If this was a `SPELL_ABSORB`, you can use `args.spellId`, `args.spellName`, and `args.spellSchool` to see relevant information about the spell that did the interrupt. `SWING_ABSORB` does not have this information. |
| `absorbSpellName` | The localized name of the absorb-aura. |
| `absorbSpellSchool` | The school of the absorb-aura. |
| `amount` | The _final_ amount of damage that absorb-aura absorbed from the source in the event. |
| `critical` | A true/false flag that informs if the event was a critical strike. |

#### `_MISSED`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `missType` | The [type of miss](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Miss_type) that occured. |
| `isOffHand` | A true/false flag that informs if the event was from the source's off-hand. |
| `amountMissed` | The potential damage that no one will ever see or care about. |


#### `_HEAL`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `amount` | The amount of healing that the destination unit from the source. |
| `overhealing` | The amount of healing that was over the maximum health of the destination unit. |
| `absorbed` | The amount of healing that was absorbed by the unit (e.g. by a debuff). |
| `critical` | A true/false flag that informs if the event was a critical strike. |


#### `_ENERGIZE`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `amount` | The amount of energy that the destination unit gained. |
| `powerType` | The [type of power](#power-type-lookup) that the destination unit gained. This used to be an index, but now is just a string with the type. See the table below for the possible values.<br><br>__NOTE:__ If you need a localized string of the power type, you can do:<br><br>`local name = _G[args.powerType];`<br><br>If you need the color of the power type, Blizzard provides that in their `PowerBarColor` global:<br><br>`local color = PowerBarColor[args.powerType]`<br>`local red, green, blue = color.r, color.g, color.b;`|

> #### Power Type Lookup
> | Index (Old) | Power Type | Color (RGB) | Color (Hex) |
> | :---: | :--- | :--- | :--- |
> | 0 | `"MANA"` |  rgb(0, 0, 1) | 0000FF |
> | 1 | `"RAGE"` | rgb(1, 0, 0) | FF0000 |
> | 2 | `"FOCUS"` | rgb(1, 0.5, 0.25) | FF8040 |
> | 3 | `"ENERGY"` | rgb(1, 1, 0) | FFFF00 |
> | 4 | `"CHI"` | rgb(0.71, 1, 0.92) | B5FFEB |
> | 5 | `"RUNES"` | rgb(0.5, 0.5, 0.5) | 808080 |
> | 6 | `"RUNIC_POWER"` | rgb(0, 0.82, 1) | 00D1FF |
> | 7 | `"SOUL_SHARDS"` | rgb(0.5, 0.32, 0.55) | 80528C |
> | 8 | `"LUNAR_POWER"` | rgb(0.3, 0.52, 0.9) | 4D85E6 |
> | 9 | `"HOLY_POWER"` | rgb(0.95, 0.9, 0.6) | F2E699 |
> | 11 | `"MAELSTROM"` | rgb(0, 0.5, 1) | 0080FF |
> | 13 | `"INSANITY"` | rgb(0.4, 0, 0.8) | 6600CC|
> | 17 | `"FURY"` | rgb(0.788, 0.259, 0.992) | C942FD |
> | 18 | `"PAIN"` | rgb(1, 0.612, 0) | FF9C00 |
> | n/a | `"AMMOSLOT"` | rgb(0.8, 0.6, 0) | CC9900  |
> | n/a | `"ARCANE_CHARGES"` | rgb(0.1, 0.1, 0.98) | 1A1AFA |
> | n/a | `"COMBO_POINTS"` | rgb(1, 0.96, 0.41) | FFF569 |
> | n/a | `"FUEL"` | rgb(0, 0.55, 0.5) | 008C80 |
> | n/a | `"STAGGER"` | [1] = rgb(0.52, 1, 0.52)<br>[2] = rgb(1, 0.98, 0.72)<br>[3] = rgb(1, 0.42, 0.42) |  85FF85 _-- Light_ <br>FFFAB8 _-- Moderate_<br>FF6B6B _-- Heavy_ |


#### `_DRAIN` and `_LEECH`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `amount` | The amount that was drained/leeched from the destination to the source. |
| `powerType` | The [type of power](#power-type-lookup) that was drained/leeched.<br><br>__NOTE:__ I believe if this is -2, health was drained/leeched. Also, the new minor stat **Leech** does not seem to use this event. Rather you will find it with `SPELL_HEAL` and `args.spellId == 143924`. |
| `extraAmount` | The amount that was over the power type maximum of the source unit. |


#### `_INTERRUPT`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `extraSpellId` | The spell ID of the spell that was interrupted.<br><br>__NOTE:__ You can use `args.spellId`, `args.spellName`, and `args.spellSchool` to see relevant information about the spell that did the interrupt. |
| `extraSpellName` | The localized name of the spell that was interrupted. |
| `extraSchool` | The school of the spell that was interrupted. |


#### `_DISPEL` and `_STOLEN`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `extraSpellId` | The spell ID of the aura that was dispelled/stolen.<br><br>__NOTE:__ You can use `args.spellId`, `args.spellName`, and `args.spellSchool` to see relevant information about the spell that did the dispelling/stealing. |
| `extraSpellName` | The localized name of the aura that was dispelled/stolen. |
| `extraSchool` | The school of the aura that was dispelled/stolen. |
| `auraType` | The type of aura that was dispelled/stolen: `"BUFF"` or `"DEBUFF"`. |


#### `_DISPEL_FAILED`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `extraSpellId` | The spell ID of the aura that wasn't dispelled.<br><br>__NOTE:__ You can use `args.spellId`, `args.spellName`, and `args.spellSchool` to see relevant information about the spell that tried to dispel. |
| `extraSpellName` | The localized name of the aura that wasn't dispelled. |
| `extraSchool` | The school of the aura that wasn't dispelled. |

#### `_EXTRA_ATTACKS`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `amount` | _Unknown value. More research or documentation is needed._ |


#### `_AURA_APPLIED`, `_AURA_REMOVED`, `_AURA_APPLIED_DOSE	`,  `_AURA_REMOVED_DOSE`, and `_AURA_REFRESH`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `auraType` | The type of the aura being referenced in the event (`"BUFF"` or `"DEBUFF"`).  |
| `amount` | The number of stacks of the aura. |


#### `_AURA_BROKEN`--- Additional Parameters
| `args.`*index* | Description |
| ---:|:--- |
| `auraType` | The type of the aura being broken in the event (`"BUFF"` or `"DEBUFF"`).  |


#### `_AURA_BROKEN_SPELL`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `extraSpellId` | The spell ID of the aura that was broken.<br><br>__NOTE:__ You can use `args.spellId`, `args.spellName`, and `args.spellSchool` to see relevant information about the spell that did the breaking. |
| `extraSpellName` | The localized name of the aura that was broken. |
| `extraSchool` | The school of the aura that was broken. |
| `auraType` | The type of aura that was broken: `"BUFF"` or `"DEBUFF"`. |


#### `_CAST_FAILED`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `failedType` | A localized string that gives the reason the spell failed.<br><br>__Examples:__<br><br>`"Can only use outside"`<br>`"Item is not ready yet"`<br>`"No target"`<br>...<br>_etc._|
