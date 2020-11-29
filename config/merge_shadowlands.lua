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

--[[header "|cffd2d3d8SL|r™ |cff798BDDTemplates|r"
do
end

header "|cffd2d3d8SL|r™ |cff798BDDConsumables|r"
do
end

header "|cffd2d3d8SL|r™ |cff798BDDItems|r"
do
end
--]]

header "|cffd2d3d8SL|r™ |cff798BDDQuest Items|r"
do
end

header "|cffd2d3d8SL|r™ |cff798BDDWorld Zones|r"
do
	item '327909' '0.5' "breaking ashen phylactery" -- Thorgast
end

header "|cffd2d3d8ShadowLands|r™ |cff798BDDCovenants|r"
do

	-- warlock
	-- Night Fae 
	item '325640' '1.0' "Soul Rot"

	-- Venthyr
	item '321792' '1.0' "Impending Catastrophe"
	alias '322167' '321792' -- Impending Catastrophe dot
	alias '322170' '321792' -- Impending Catastrophe dot

	-- DeathKnight
	-- Kyrian
	item '312202' '1.0' "Shackle of the Unworthy"

end

header "|cffd2d3d8ShadowLands|r™ |cff798BDDQuest Spells|r"
do
	-- Ardenweald
	item '343048' '1.0' "Nature's Blessing"
end
