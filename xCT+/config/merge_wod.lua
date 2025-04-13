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
local _, _, _, _, item, header = unpack(addon.merge_helpers)

header(" 6.x |cffA32C12" .. L["Warlords of Draenor"] .. "|r")
do
    -- WoD Trinkets
    item(184280, 5) -- Trinket: Mirror of the Blademaster
    item(184256, 5) -- Trinket: Empty Drinking Horn
    item(185098, 5) -- Trinket: Soothing Breeze
    item(185321, 5) -- Trinket: Seed of Creation (Guardian)

    -- HFC
    item(180223, 5) -- HFC Construct #4
end
