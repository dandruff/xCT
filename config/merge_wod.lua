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

header " 6.x |cffA32C12Warlords of Draenor|r™ |cff798BDDItems|r"
do
	-- Enchants
	item '159238' '3.5' "Shattered Hand"


	-- WoD Trinkets
	item '184280' '3.5' "Mirror of the Blademaster"
	item '184256' '2.5' "Empty Drinking Horn"
	item '185098' '4.5' "Soothing Breeze"
	item '185321' '1.5' "Seed of Creation (Guardian)"

	-- Tier Gear
	item '188046' '1.5' "T18 Druid Balance 2P"
end

header " 6.x |cffA32C12Warlords of Draenor|r™ |cff798BDDBodyguards|r"
do
	-- Bodyguards
	item '171764' '3.5' "Bodyguard: Vivianne"
	item '175806' '3.5' "Bodyguard: Vivianne"
	item '173010' '3.5' "Bodyguard: Vivianne"
	item '175814' '3.5' "Bodyguard: Vivianne"
	item '176017' '3.5' "Bodyguard: Aeda"
	item '172965' '3.5' "Bodyguard: Delvar"
	item '175796' '3.5' "Bodyguard: Delvar"
end

header " 6.x |cffA32C12Warlords of Draenor|r™ |cff798BDDWorld Zone|r"
do
	-- Vehicles
	item '165421' '3.5' "Shredder"
	item '164603' '3.5' "Shredder"
end

header " 6.x |cffA32C12Warlords of Draenor|r™ |cff798BDDRaids|r"
do
	-- HFC
	item '180223' '1.5' "HFC Construct #4"
end
