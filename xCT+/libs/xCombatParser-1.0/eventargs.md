# Event Args Methods
In the callback that you passed to `RegisterCombat`,  you will be given a single parameter `args`. This parameter contains all the parsed information from the event in names similar to Wowpedia's page on [Combat Log Event](http://wow.gamepedia.com/COMBAT_LOG_EVENT). The documentation below outlines all the functions inside the `args` table.

### Table of Contents
* [Event Args Methods](#event-args-methods)
	* [__Memory__ Methods](#memory-methods)
	* [__Combat Object__ Methods](#combat-object-methods)
	* [__Raid Target__ Methods](#raid-target-methods)
	* [__Special Object__ Methods](#special-object-methods)

### Memory Methods
 * `args:pin()`— Pins the table in memory so that you can use it at a later time.

 * `args:free()`— Unpins the table in memory. If this was the only reference, the table will be recycled.

### Combat Object Methods

* `args:GetDestinationType()`— Gets the [Object's Type](http://wow.gamepedia.com/UnitFlag#Constants) from the destination flags.
	* __Returns:__ `string objectType`

> `'GUARDIAN' | 'PET' | 'PLAYER' | 'NPC' | 'OBJECT' | 'UNKNOWN'`

* `args:GetDestinationController()`— Gets the [Object's Controller](http://wow.gamepedia.com/UnitFlag#Constants) from the destination flags.
	* __Returns:__ `string objectController`

> `'PLAYER' | 'NPC' | 'UNKNOWN'`

* `args:GetDestinationReaction()`— Gets the [Object's Reaction](http://wow.gamepedia.com/UnitFlag#Constants) from the destination flags.
	* __Returns:__ `string objectReaction`

> `'FRIENDLY' | 'NEUTRAL' | 'HOSTILE' | 'UNKNWON'`

* `args:GetDestinationAffiliation()`— Gets the [Object's Affiliation](http://wow.gamepedia.com/UnitFlag#Constants) from the destination flags.
	* __Returns:__ `string objectAffiliation`

> `'OUTSIDER' | 'PARTY' | 'RAID' | 'MINE' | 'UNKNWON'`

* `args:GetSourceType()`— Gets the [Object's Type](http://wow.gamepedia.com/UnitFlag#Constants) from the source flags. If this is an environmental event,  the type is the environment.
	* __Returns:__ `string objectType`

> `'ENVIRONMENT' | 'GUARDIAN' | 'PET' | 'PLAYER' | 'NPC' | 'OBJECT' | 'UNKNOWN'`

* `args:GetSourceController()`— Gets the [Object's Controller](http://wow.gamepedia.com/UnitFlag#Constants) from the source flags. If this is an environmental event,  the controller is the environment.
	* __Returns:__ `string objectController`

> `'ENVIRONMENT' | 'PLAYER' | 'NPC' | 'UNKNOWN'`

* `args:GetSourceReaction()`— Gets the [Object's Reaction](http://wow.gamepedia.com/UnitFlag#Constants) from the source flags. If this is an environmental event,  the reaction is neutral.
	* __Returns:__ `string objectReaction`

> `'FRIENDLY' | 'NEUTRAL' | 'HOSTILE' | 'UNKNWON'`

* `args:GetSourceAffiliation()`— Gets the [Object's Affiliation](http://wow.gamepedia.com/UnitFlag#Constants) from the source flags. If this is an environmental event,  the affiliation is an outsider.
	* __Returns:__ `string objectAffiliation`

> `'OUTSIDER' | 'PARTY' | 'RAID' | 'MINE' | 'UNKNWON'`

### Raid Target Methods

> Raid Target Lookup Table
>
> | Index | Description | Lua Name (`_G[name]`)
> |:---:| --- | --- |
> | 0 | Nothing | `NONE` |
> | 1 | Yellow Star | `RAID_TARGET_1` |
> | 2 | Orange Circle | `RAID_TARGET_2` |
> | 3 | Purple Diamond | `RAID_TARGET_3` |
> | 4 | Green Triangle | `RAID_TARGET_4` |
> | 5 | Pale Blue Moon | `RAID_TARGET_5` |
> | 6 | Blue Square | `RAID_TARGET_6` |
> | 7 | Red Cross | `RAID_TARGET_7` |
> | 8 | White Skull | `RAID_TARGET_8` |
> [Source](http://wow.gamepedia.com/Target_Marker#Arguments)

* `args:GetSourceRaidTargetIndex()`— Gets [Target Marker](http://wow.gamepedia.com/Target_Marker#Arguments) index of the source object.
	* __Returns:__ `number raidTargetIndex`

* `args:GetDestinationRaidTargetIndex()`— Gets [Target Marker](http://wow.gamepedia.com/Target_Marker#Arguments) index of the destination object.
	* __Returns:__ `number raidTargetIndex`

* `args:GetSourceRaidTargetName()`— Gets the localized name of the [Target Marker](http://wow.gamepedia.com/Target_Marker#Arguments) that the source object has.
	* __Returns:__ `string raidTarget`

> `enUS Example: 'None' | 'Star' | 'Circle' | 'Skull' | etc.`

* `args:GetDestinationRaidTargetName()`— Gets the localized name of the [Target Marker](http://wow.gamepedia.com/Target_Marker#Arguments) that the destination object has.
	* __Returns:__ `string raidTarget`

> `enUS Example: 'None' | 'Star' | 'Circle' | 'Skull' | etc.`

### Special Object Methods

* `args:IsSourceMainAssist()`— Checks to see if the source [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is a main assist (e.g. Assists, Officers, Healers, etc.).
	* __Returns:__ `boolean isAssist`

* `args:IsDestinationMainAssist()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is a main assist (e.g. Assists, Officers, Healers, etc.).
	* __Returns:__ `boolean isAssist`

* `args:IsSourceMainTank()`— Checks to see if the source [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is a main tank (e.g. Tank Frames).
	* __Returns:__ `boolean isTank`

* `args:IsDestinationMainTank()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is a main tank (e.g. Tank Frames).
	* __Returns:__ `boolean isTank`

* `args:IsSourceFocus()`— Checks to see if the source [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current focus. Using this is faster than comparing GUID's.
	* __Returns:__ `boolean isFocus`

* `args:IsDestinationFocus()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current focus. Using this is faster than comparing GUID's.
	* __Returns:__ `boolean isFocus`

* `args:IsSourceTarget()`— Checks to see if the source [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current target. Using this is faster than comparing GUID's.
	* __Returns:__ `boolean isTarget`

* `args:IsDestinationTarget()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current target. Using this is faster than comparing GUID's.
	* __Returns:__ `boolean isTarget`

* `args:IsSourceMyPet()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current pet. Using this is more reliable than trying to update and compare GUID's.
	* __Returns:__ `boolean isMyPet`

* `args:IsDestinationMyPet()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current pet. Using this is more reliable than trying to update and compare GUID's.
	* __Returns:__ `boolean isMyPet`

* `args:IsSourceMyVehicle()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current vehicle. This information is impossible to get from any other method.
	* __Returns:__ `boolean isMyVehicle`

* `args:IsDestinationMyVehicle()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is the player's current vehicle. This information is impossible to get from any other method.
	* __Returns:__ `boolean isMyVehicle`

* `args:IsSourceRaidMember()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is in the player's current raid group. Using this is more reliable than trying to update and compare GUID's.
	* __Returns:__ `boolean isRaidMember`

* `args:IsDestinationRaidMember()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is in the player's current raid group. Using this is more reliable than trying to update and compare GUID's.
	* __Returns:__ `boolean isRaidMember`

* `args:IsSourcePartyMember()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is in the player's current party. Using this is more reliable than trying to update and compare GUID's.
	* __Returns:__ `boolean isPartyMember`

* `args:IsDestinationPartyMember()`— Checks to see if the destination [Combat Object](http://wow.gamepedia.com/UnitFlag#Constants) is in the player's current party. Using this is more reliable than trying to update and compare GUID's.
	* __Returns:__ `boolean isPartyMember`


> Written with [StackEdit](https://stackedit.io/).
