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

-- New way of doing merge spells
-- 'rspell' takes a spell id and a merge interval in seconds
local _, _, _, _, _, _, race, rspell = unpack(addon.merge_helpers)

race "|cfff2ff00Races|r™ |cff8a8dedVoid Elfs|r"
do
	rspell '259756' '2.5' --  Entropic embrace
end

race "|cfff2ff00Races|r™ |cff8a8dedLightforged Draenei|r"
do
	rspell '256893' '0.5' -- Light's judgement
end