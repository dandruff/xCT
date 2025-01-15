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

local ADDON_NAME, addon = ...

-- Textures
local x = addon.engine
x.BLANK_ICON = "Interface\\AddOns\\" .. ADDON_NAME .. "\\media\\blank"

-- Fonts
local LSM = LibStub("LibSharedMedia-3.0")

LSM:Register(
    "font",
    "Champagne (xCT+)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\Champagne & Limousines Bold.ttf]],
    LSM.LOCALE_BIT_western
)
LSM:Register(
    "font",
    "Homespun (xCT+)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\homespun.ttf]],
    LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
    "font",
    "HOOGE (xCT)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\HOOGE.TTF]],
    LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
    "font",
    "Condensed Bold (xCT+)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondBold.ttf]],
    LSM.LOCALE_BIT_western
)
LSM:Register(
    "font",
    "Condensed Light (xCT+)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondLight.ttf]],
    LSM.LOCALE_BIT_western
)
LSM:Register(
    "font",
    "Condensed Light Italics (xCT+)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondLightItalic.ttf]],
    LSM.LOCALE_BIT_western
)
LSM:Register(
    "font",
    "Vintage (xCT+)",
    [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\VintageOne.ttf]],
    LSM.LOCALE_BIT_western
)
