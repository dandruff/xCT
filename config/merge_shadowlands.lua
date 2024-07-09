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

header " 9.x |cffd2d3d8ShadowLands|r™ |cff798BDDCovenants|r"
do
	-- Venthyr
	alias '322167' '321792' -- Impending Catastrophe dot
	alias '322170' '321792' -- Impending Catastrophe dot
	alias '325640' '234153' --  Drain life multi with soulrot

	-- Warlock
	item '321792' '1.0' "Impending Catastrophe"
end

header " 9.x |cffd2d3d8ShadowLands|r™ |cff798BDDQuest Spells|r"
do
	-- Ardenweald
	item '343048' '1.0' "Nature's Blessing"
end

header " 9.x |cffd2d3d8ShadowLands|r™ |cff798BDDTrinkets|r"
do
	alias '344540' '180117' -- Trinket: Empyreal Ordnance dot

	item '178769' '1.0' "Infinitely Divisible Ooze"
	alias '345495' '178769' -- Infinitely Divisible Ooze damage

	alias '345638' '178772' -- Satchel of Misbegotten Minions damage

	item '184021' '2.0' "Glyph of Assimilation"
	alias '345319' '184021' -- Glyph of Assimilation dot

	alias '339545' '182453' -- Twilight Bloom: Twilight Restoration
end

header " 9.x |cffd2d3d8ShadowLands|r™ |cff798BDDLegendaries|r"
do
	-- Priest
	alias '193473' '336214' -- Eternal Call to the Void: Mind Flay
	alias '344752' '336214' -- Eternal Call to the Void: Mind Sear
end

header " 9.x |cffd2d3d8ShadowLands|r™ |cff798BDDEnchants|r"
do
	item '324184' '1.5' "Lightless Force"
end
