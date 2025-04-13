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

header(L["Basic spells"])
do
    item(143924, 3.5) -- Item Leech

    -- not technically an item but thats not important right now
    item(6603, 5) -- Auto Attack
    item(75, 5) -- Auto Shot
end
