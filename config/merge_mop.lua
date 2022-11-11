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

header "|cffF1A864Mists of Pandaria|r™ |cff798BDDLegendary Cloaks|r"
do
	item '147891' '3.5' "Legedary Cloak for Melee"
	item '148008' '3.5' "Legedary Cloak for Casters"
	item '148009' '5.0' "Legedary Cloak for Healers"
	item '149276' '3.5' "Legedary Cloak for Hunters"
end

header "|cffF1A864Mists of Pandaria|r™ |cff798BDDTrinkets|r"
do
	-- Trinket: Kardris' Toxic Totem
	item '146061' '5' "Physical Damage (Melee)"
	item '146063' '5' "Holy Damage"
	item '146064' '5' "Arcane Damage (Balance Druids)"
	item '146065' '5' "Shadow Damage (Priests, Warlocks)"
	item '146067' '5' "Fire, Frost Damage (Mages)"
	item '146069' '5' "Physical Damage (Hunters)"
	item '146071' '5' "Nature Damage (Elemental Shamans)"
	item '146070' '5' "Arcane Damage (Mages)"
	item '146075' '5' "Nature Damage (Windwalker Monks)"
	item '146177' '5' "Holy Healing (Priest, Paladin)"
	item '146178' '5' "Nature Healing (Druid, Monk)"

	-- Trinket: Thok's Acid-Grooved Tooth
	item '146137' '.5' "Physical Damage (Melee)"
	item '146157' '.5' "Holy Damage"
	item '146158' '.5' "Arcane Damage (Balance Druids)"
	item '146159' '.5' "Shadow Damage (Priests, Warlocks)"
	item '146160' '.5' "Fire, Frost Damage (Mages)"
	item '146162' '.5' "Physical Damage (Hunters)"
	item '146166' '.5' "Arcane Damage (Mages)"
	item '146171' '.5' "Nature Damage (Elemental Shamans)"
	item '148234' '.5' "Holy Healing (Priests, Paladins)"
	item '148235' '.5' "Nature Healing (Monks, Druids)"
end
