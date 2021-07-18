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

header "|cff325A93Battle for Azeroth|r™ |cff798BDDItems|r"
do
	-- Trinkets
	item '276199' '1.0' "Trinket: Darkmoon Deck: Fathoms"
	item '276132' '2.0' "Trinket: Darkmoon Deck: Squalls"
	item '278057' '0.5' "Trinket: Vigilant's Bloodshaper"
	item '270827' '0.5' "Trinket: Vessel of Skittering Shadows"
	item '302311' '0.5' "Trinket: Remote Guidance Device"
end

header "|cff325A93Battle for Azeroth|r™ |cff798BDDWorldQuest|r"
do
	-- worldquest
	item '269238' '1.5' "World Quest: Drustvar "			-- Vehicules world quest Drustvar
end
