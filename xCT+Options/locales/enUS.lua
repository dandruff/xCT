--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Feylynn-Antonidas EU       ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2010-2025 All Rights Reserved.    ]
 [====================================]]

local AddonName = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(AddonName, "enUS", true, true)
if not L then return end

L["                                                      Version: %s                                                      "] = true
L["Unknown"] = true
L["|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n"] = true
L["|cffFFFF00Helpful Tips:|r\n\n"] = true
L["On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options."] = true
L["Hide Config in Combat"] = true
L["This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r"] = true
L["Allows you to preview xCT+ in order to tweak settings outside of combat.\n\nYou can also type: '|cffFF0000/xct test|r'"] = true
L["Test"] = true
L["Move"] = true
L["Allows you to adjust the position of all the xCT+ frames on your screen.\n\nYou can also type: '|cffFF0000/xct lock|r'"] = true

-- Frames
L["Frame Settings"] = true
L["Frame Strata"] = true
L["The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata."] = true
L["Parent |cffFF0000(Lowest)|r"] = true
L["Background |cffFF0000(Lowest)|r"] = true
L["Low"] = true
L["Medium"] = true
L["High |cffFFFF00(Default)|r"] = true
L["Dialog"] = true
L["Fullscreen"] = true
L["Fullscreen Dialog"] = true
L["ToolTip |cffAAFF80(Highest)|r"] = true
L["Clear Frames when leaving combat"] = true
L["Enable this option if you have problems with 'floating' icons."] = true
L["When moving the Frames"] = true
L["Show Align Grid"] = true
L["Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."] = true
L["Show Positions"] = true
L["Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."] = true

-- megaDamage
L["Number Format Settings"] = true
L["Format Numbers in the Frames (Choose one)"] = true
L["|cffFFFF00PLEASE NOTE|r |cffAAAAAAFormat settings need to be independently enabled on each frame through its respective settings page.|r\n"] = true
L["Abbreviate Numbers"] = true
L["Decimal Marks"] = true
L["Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r"] = true
L["Single Decimal Precision"] = true
L["Shows a single digit of precision when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r)."] = true
L["Thousand Symbol"] = true
L["Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r"] = true
L["Million Symbol"] = true
L["Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r"] = true
L["Billion Symbol"] = true
L["Symbol for: |cffFF0000Billions|r |cff798BDD(10e+9)|r"] = true
