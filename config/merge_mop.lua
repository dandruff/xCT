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

header " 5.x |cffF1A864Mists of Pandaria|r™ |cff798BDDLegendary Cloaks|r"
do
	item '147891' '3.5' "Legedary Cloak for Melee"
	item '148008' '3.5' "Legedary Cloak for Casters"
	item '148009' '5.0' "Legedary Cloak for Healers"
	item '149276' '3.5' "Legedary Cloak for Hunters"
end

header " 5.x |cffF1A864Mists of Pandaria|r™ |cff798BDDTrinkets|r"
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
end
