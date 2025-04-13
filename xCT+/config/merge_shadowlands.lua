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
 [  ©2010-2025 All Rights Reserved.    ]
 [====================================]]

local AddonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)
local _, _, _, alias, item, header = unpack(addon.merge_helpers)

header(" 9.x |cffd2d3d8" .. L["Shadowlands"] .. "|r")
do
    alias(344540, 180117) --  Trinket: Empyreal Ordnance dot

    item(178769, 0) -- Trinket: Infinitely Divisible Ooze
    alias(345495, 178769) --  Infinitely Divisible Ooze damage

    alias(345638, 178772) --  Satchel of Misbegotten Minions damage

    item(184021, 0) -- Trinket: Glyph of Assimilation
    alias(345319, 184021) --  Glyph of Assimilation dot

    item(324184, 5) -- Enchant: Lightless Force
end
