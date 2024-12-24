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
 [  ©2024. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...

-- Textures
local x = addon.engine
x.BLANK_ICON = "Interface\\AddOns\\" .. ADDON_NAME .. "\\media\\blank"
x.new = "\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1\124t"

x.runeIcons = {

  [1] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood:0:0:0:-1\124t";
  [2] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy:0:0:0:-1\124t";
  [3] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost:0:0:0:-1\124t";
  [4] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Death:0:0:0:-1\124t";
--[===[
  [1] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-DeathKnight-Blood-Off.tga:0:0:0:-1\124t",
	[2] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-DeathKnight-Death-Off.tga:0:0:0:-1\124t",
	[3] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-DeathKnight-Frost-Off.tga:0:0:0:-1\124t",
	[4] = "\124TInterface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Chromatic-Off.tga:0:0:0:-1\124t",
  ]===]
}

-- Fonts
local LSM = LibStub("LibSharedMedia-3.0")

LSM:Register("font", "HOOGE (xCT)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\HOOGE.TTF]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Homespun (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\homespun.ttf]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Vintage (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\VintageOne.ttf]], LSM.LOCALE_BIT_western)
--LSM:Register("font", "Champagne (BI)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\Champagne & Limousines Bold Italic.ttf]], LSM.LOCALE_BIT_western)
LSM:Register("font", "Champagne (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\Champagne & Limousines Bold.ttf]], LSM.LOCALE_BIT_western)
--LSM:Register("font", "Champagne (I)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\Champagne & Limousines Italic.ttf]], LSM.LOCALE_BIT_western)
--LSM:Register("font", "Champagne", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\Champagne & Limousines.ttf]], LSM.LOCALE_BIT_western)

LSM:Register("font", "Condensed Bold (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondBold.ttf]], LSM.LOCALE_BIT_western)
LSM:Register("font", "Condensed Light (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondLight.ttf]], LSM.LOCALE_BIT_western)
LSM:Register("font", "Condensed Light Italics (xCT+)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\OpenSans-CondLightItalic.ttf]], LSM.LOCALE_BIT_western)

-- Do you want awesome text? Put your name below :D
if UnitName("PLAYER") == "Puppycat" or UnitName("PLAYER") == "Dandraffbal" then
  local settings = CreateFrame("FRAME")
  settings:RegisterEvent("PLAYER_ENTERING_WORLD")

  settings:SetScript("OnEvent", function(self, event, ...)
		-- Change Zone Font Text to something cooler :)
		PVPArenaTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 30, "MONOCHROMEOUTLINE")
		PVPInfoTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 10, "MONOCHROMEOUTLINE")
		ZoneTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 30, "MONOCHROMEOUTLINE")
		SubZoneTextString:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")

		-- Change the Errors frame fonts to be cooolio!
		UIErrorsFrame:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 10, "MONOCHROMEOUTLINE")
		UIErrorsFrame:SetShadowColor(0, 0, 0, 0)

		-- Change the Raid Warning stuff
		RaidWarningFrameSlot1:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
		RaidWarningFrameSlot1:SetShadowColor(0, 0, 0, 0)
		RaidWarningFrameSlot2:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
		RaidWarningFrameSlot2:SetShadowColor(0, 0, 0, 0)

		-- Change the Raid Boss Emote stuff
		RaidBossEmoteFrameSlot1:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
		RaidBossEmoteFrameSlot1:SetShadowColor(0, 0, 0, 0)
		RaidBossEmoteFrameSlot2:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 20, "MONOCHROMEOUTLINE")
		RaidBossEmoteFrameSlot2:SetShadowColor(0, 0, 0, 0)

		-- Unregister all this crap-ola
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:SetScript("OnEvent", nil)
		self = nil
	end)

end
