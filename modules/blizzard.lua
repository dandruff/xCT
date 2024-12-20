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

-- TODO: Fix this up

local ADDON_NAME, addon = ...
local x = addon.engine

-- Intercept Messages Sent by other Add-Ons that use CombatText_AddMessage
hooksecurefunc('CombatText_AddMessage', function(message, scrollFunction, r, g, b, displayType, isStaggered)
  if not x.db.profile.blizzardFCT.enableFloatingCombatText then
    local lastEntry = COMBAT_TEXT_TO_ANIMATE[ #COMBAT_TEXT_TO_ANIMATE ]
    CombatText_RemoveMessage(lastEntry)
    x:AddMessage("general", message, {r, g, b})
  end
end)
