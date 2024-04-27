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
local spell, _, _, alias, item, header = unpack(addon.merge_helpers)


header "10.x |cff33937FDragonflight|r™ |cff798BDDTrinkets|r"
do
	alias '425461' '425701' -- Shadowflame Lash -> Trinket: Tainted Rageheart
end

header "10.x |cff33937FDragonflight|r™ |cff798BDDLegendaries|r"
do
	item '417134' '3.0' "Rage of Fyr'alath"
	alias '424094' '417134' -- Rage of Fyr'alath -> Weapon Fyr'alath
	alias '413584' '417134' -- Explosive Rage -> Weapon Fyr'alath
end

header "|cffd2d3d8Dragonflight|r™ |cff798BDDEnchants|r"
do
	alias '426527' '426535' -- Amirdrassil Head Enchant (Melee) - 2nd Effect
end