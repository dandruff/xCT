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

-- No locals for NOOP
local noop = function() end

local AddonName, addon = ...
addon.engine = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0")

xCT_Plus = addon.engine

-- No Operation
addon.noop = noop



-- fun stuff below

-- /run print("\124cffFF0000Hello \124cff0000FFWorld")
--[[

/run print("\124cffFFFF00 Tormentors of Torghast: \124cff1784d1"..(C_QuestLog.IsQuestFlaggedCompleted(63854)and"Completed"or"Pending"))



]]
