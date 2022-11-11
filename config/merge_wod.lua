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

header "|cffA32C12Warlords of Draenor|r™ |cff798BDDItems|r"
do
	-- Enchants
	item '159238' '3.5' "Shattered Hand"
	item '188505' '0.5' "Felmouth Frenzy"

	-- Legendary Rings
	item '187626' '0.5' "Legedary Ring: Agi DPS"
	item '187625' '0.5' "Legedary Ring: Int DPS"
	item '187624' '0.5' "Legedary Ring: Str DPS"

	-- WoD Trinkets
	item '184280' '3.5' "Mirror of the Blademaster"
	item '184256' '2.5' "Empty Drinking Horn"
	item '184248' '0.5' "Discordant Chorus"
	item '185098' '4.5' "Soothing Breeze"
	item '184075' '0.5' "Prophecy of Fear"
	item '184559' '0.5' "Soul Capacitor"
	item '185321' '1.5' "Seed of Creation (Guardian)"

	-- Tier Gear
	item '188046' '1.5' "T18 Druid Balance 2P"
end

header "|cffA32C12Warlords of Draenor|r™ |cff798BDDBodyguards|r"
do
	-- Bodyguards
	item '171764' '3.5' "Bodyguard: Vivianne"
	item '175806' '3.5' "Bodyguard: Vivianne"
	item '173010' '3.5' "Bodyguard: Vivianne"
	item '175814' '3.5' "Bodyguard: Vivianne"
	item '176020' '0.5' "Bodyguard: Aeda"
	item '176017' '3.5' "Bodyguard: Aeda"
	item '172965' '3.5' "Bodyguard: Delvar"
	item '175796' '3.5' "Bodyguard: Delvar"
end

header "|cffA32C12Warlords of Draenor|r™ |cff798BDDWorld Zone|r"
do
	-- Vehicles
	item '165421' '3.5' "Shredder"
	item '164603' '3.5' "Shredder"
end

header "|cffA32C12Warlords of Draenor|r™ |cff798BDDRaids|r"
do
	-- HFC
	item '181102' '.5' "Mark Eruption"
	item '182635' '0.5' "HFC Construct #1"
	item '182218' '0.5' "HFC Construct #2"
	item '180223' '1.5' "HFC Construct #4"
	item '185656' '0.5' "Shadowfel Annihilation"
end
