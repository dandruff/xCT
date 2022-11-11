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
 [  ©2020. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...

-- New way of doing merge items
-- 'alias' takes the original spell id and a replacement spell id
-- item takes a item id, the merge interval in seconds, and a helpful description of the item
-- header switches the header for the next set of items
local _, _, _, alias, item, header = unpack(addon.merge_helpers)

header "|cff93BE3DLegion|r™ |cff798BDDBodyguards|r"
do
	-- Druid
	item '218797' '3.5' "Broll Bearmantle (Moonfire)"

	-- Paladin
	item '221647' '0.5' "Vindicator Boros (Hammer of the Righteous)"
	item '222175' '1.5' "Blood Vanguard (Trample)"
	item '222175' '1.5' "Arator the Redeemer (Divine Storm)"
	item '221720' '1.5' "Arator the Redeemer (Divine Storm Heal)"

	-- Monk
	item '212141' '1.5' "The Monkey King (Spinning Crane Kick)"

	-- Mage
	item '228672' '1.0' "Archmage Modera (Flurry)"
	item '220128' '0.5' "Archmage Modera (Frost Nova)"
end

header "|cff93BE3DLegion|r™ |cff798BDDConsumables|r"
do
	item '188091' '1.5' "Potion: Potion of Deadly Grace"
	item '188028' '1.5' "Potion: Potion of the Old War"
	item '225623' '1.5' "Food: Fishbrul Special"
	alias '225624' '225623' --  Pepper Breath
	alias '201573' '225623' --  Pepper Breath
	alias '233150' '188028' --  Hack to give the Old War potion an icon
end

header "|cff93BE3DLegion|r™ |cff798BDDItems|r"
do
	-- Trinkets
	item '214052' '0.5' "Trinket: Eye of Skovald"
	item '215047' '3.0' "Trinket: Terrorbound Nexus"
	item '222168' '1.5' "Trinket: Spontaneous Appendages"
	item '214169' '1.5' "Trinket: Spiked Counterweight"
	item '215047' '3.0' "Trinket: Terrorbound Nexus"
	item '213786' '1.5' "Trinket: Corrupted Starlight"
	item '221845' '1.5' "Trinket: Twisting Wind"
	item '221804' '0.5' "Trinket: Ravaged Seed Pod"
	item '222197' '0.5' "Trinket: Unstable Horrorslime"
	item '214350' '1.5' "Trinket: Oakheart's Gnarled Root"
	alias '228780' '214169' --  Brutal Haymaker (Spiked Counterweight)
	alias '213782' '213786' --  Trinket: Corrupted Starlight
	alias '213833' '213786' --  Trinket: Corrupted Starlight
	alias '213784' '213786' --  Trinket: Corrupted Starlight
	alias '213785' '213786' --  Trinket: Corrupted Starlight
	alias '221865' '221845' --  Trinket: Twisting Wind

	-- Trinkets: Nighthold
	item '229700' '0.5' "Trinket: Pharamere's Forbidden Grimoire"
	item '225777' '3.5' "Trinket: Draught of Souls"
	item '225731' '3.0' "Trinket: Icon of Rot"
	item '225764' '1.5' "Trinket: Star Gate"
	item '225716' '0.5' "Trinket: Claw of the Crystalline Scorpid"
	item '225721' '0.5' "Trinket: Arcanogolem Digit"

	-- Legendaries
	item '207694' '3.0' "Legendary: Cinidaria, the Symbiote"
	item '210999' '2.5' "Legendary: Obsidian Stone Spaulders"

	-- Class Hall Items
	item '223667' '1.5' "Druid: Thornstalk Barbs"
end

header "|cff93BE3DLegion|r™ |cff798BDDWorld Zones|r"
do
	-- All
	item '205238' '0.5' "World Quest: PvP Warden Tower's (Powder Keg)"

	-- Suramar
	item '203148' '0.5' "World Quest: Air Superiority (Unstable Mana)"
	item '221254' '0.5' "World Quest: Life Finds a Way (Devour Demon)"
	item '218895' '1.0' "World Quest: Withered Army Training (Throw Rock)"
	item '23106' '1.0' "World Quest: Withered Army Training (Chain Lightning)"
	item '204204' '0.5' "World Quest: The Battle Rages On (Unleashed Magic)"

	-- Broken Shore
	item '200009' '0.5' "Quest: The Battle for Broken Shore (Fel Cannonball)"

	-- Stormheim
	item '184427' '2.5' "Quest: Greymane's Gambit (Skyfire Deck Gun)"
	item '179021' '0.5' "Quest: Murlocs: The Next Generation (Slime)"
	item '179041' '0.5' "Quest: Murlocs: The Next Generation (Pufferfish"

	-- Karazhan (Artifact Quests)
	item '201645' '0.5' "Quest: Revil Cost (Cudgel of Light)"
	item '201877' '0.5' "Quest: Revil Cost (Holy Nova)"
	item '201642' '3.5' "Quest: Revil Cost (Holy Fire)"

	-- Val'sharah
	item '218594' '0.5' "Quest: Softening the Target (Terrorfiend)"

	-- Stormheim
	item '183058' '0.5' "Quest: Cry Thunder!"
	item '183042' '0.5' "Quest: Cry Thunder!"
	item '190863' '0.5' "Quest: Gates of Valor (Call of the Storm)"
	item '190919' '0.5' "Quest: Gates of Valor (Guardian Orbs)"
	item '187780' '3.5' "Quest: Skold-Ashil (Aspirant's Conviction)"

	-- Highmountain
	item '215729' '2.5' "Quest: Lifespring Cavern (Healing Rain)"
	item '192997' '1.5' "Quest: Huln's War - The Arrival (Wild Carve)"
	item '193008' '0.5' "Quest: Huln's War - The Arrival (Harpoon Stomp)"
	item '193091' '0.5' "Quest: Huln's War - The Arrival (Harpoon Stomp)"
	item '213474' '0.5' "Quest: Justice Rains from Above (Skyhorn Strafing Run)"
	item '214479' '0.5' "Quest: Bolas Bastion (Flaming Bolas)"

	-- Azsuna
	item '179217' '1.5' "Quest: The Walk of Shame (Prince Farondis)"
	item '215555' '1.5' "Quest: The Walk of Shame (Prince Farondis)"
end

header "|cff93BE3DLegion|r™ |cff798BDDQuest Items|r"
do
	-- Val'sharah
	item '202917' '2.5' "Trinket: Temple Priestess' Charm"
	item '202891' '2.5' "Trinket: Lodestone of the Stormbreaker"
end

header "|cff93BE3DLegion|r™ |cff798BDDRaids|r"
do
	item '215300' '2.0' "Elerethe Renferal: Web of Pain [Tanks]"
	item '215307' '2.0' "Elerethe Renferal: Web of Pain [Other]"
	item '223699' '1.0' "Dragons of Nightmare: Volatile Infection"
end
