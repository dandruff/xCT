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

header " 8.x |cff325A93Battle for Azeroth|r™ |cff798BDDItems|r"
do
	-- Trinkets
	item '276199' '1.0' "Trinket: Darkmoon Deck: Fathoms"
	item '276132' '2.0' "Trinket: Darkmoon Deck: Squalls"
end

header " 8.x |cff325A93Battle for Azeroth|r™ |cff798BDDHeart Of Azeroth|r"
do
	item '295367' '1.0' "Heart of Azeroth (Crucible of flames)"  
	item '295261' '1.5' "Heart of Azeroth (Focusing iris)"  
end

header " 8.x |cff325A93Battle for Azeroth|r™ |cff798BDDAzerite Traits|r"
do
	alias '271685' '271686' -- Azerite Trait: "Heed My Call"

	-- Warlock

	item '280206' '2.5' "Ruinous Bolt (Azerite Traits)"   	--  Warlock: Ruinous bolt
	
	-- Death Knight
	
	alias '275931' '47541'  								-- Harrowing Decay links to Death Coil
end

header " 8.x |cff325A93Battle for Azeroth|r™ |cff798BDDWorldQuest|r"
do
	-- worldquest
	item '269238' '1.5' "World Quest: Drustvar "			-- Vehicles world quest in Drustvar
end

header " 8.x |cff325A93Battle for Azeroth|r™ |cff6D1192Corruption|r"
do
	item '318187' '1.0' "Gushing Wound"
end