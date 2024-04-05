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


header "|cffd2d3d8Dragonflight|r™ |cff798BDDTrinkets|r"
do
	item '426564' '1.0' "Augury of the Primal Flame"
	
	item '425701' '1.0' "Tainted Rageheart"
	alias '425461' '425701' -- Shadowflame Lash
	
	item '425509' '1.0' "Branch of the Tormented Ancient"
end

header "|cffd2d3d8Dragonflight|r™ |cff798BDDLegendaries|r"
do
	item '417134' '0.5' "Rage of Fyr'alath"	
	alias '424094' '417134' -- Rage of Fyr'alath
	alias '413584' '417134' -- Explosive Rage
end

header "|cffd2d3d8Dragonflight|r™ |cff798BDDEnchants|r"
do
	item '426288' '0.5' "Smolderon's Delusions of Grandeur"	
end

