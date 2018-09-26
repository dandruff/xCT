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
 [  ©2018. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...

-- New way of doing merge items
-- 'alias' takes the original spell id and a replacement spell id
-- item takes a item id, the merge interval in seconds, and a helpful description of the item
-- header switches the header for the next set of items
local _, _, _, alias, item, header = unpack(addon.merge_helpers)

header "|cff325A93Battle for Azeroth|r™ |cff798BDDItems|r"
do
	-- Trinkets
	item '276199' '1.0' "Trinket: Darkmoon Deck: Fathoms"
	item '276132' '2.0' "Trinket: Darkmoon Deck: Squalls"
	item '278057' '0.5' "Trinket: Vigilant's Bloodshaper"
	item '270827' '0.5' "Trinket: Vessel of Skittering Shadows"
	
	alias '276199' '276196' -- "Trinket: Darkmoon Deck: Fathoms (ItemID: 159125)"
end

header "|cff325A93Battle for Azeroth|r™ |cff798BDDAzerite Traits|r"
do
	item '280705' '0.5' "Laser Matrix"
	item '280286' '0.5' "Dagger in the Back"
	item '269031' '0.5' "Gutripper"
	item '279958' '0.5' "Azerite Globules"
	item '271685' '0.5' "Heed My Call"
	
	alias '271685' '271686' -- Azerite Trait: "Heed My Call"
end
