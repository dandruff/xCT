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

-- Translator: https://www.curseforge.com/members/%E8%90%8C%E4%B8%B6%E6%B1%89%E4%B8%B6%E7%BA%B8/projects

local AddonName = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(AddonName, "zhCN", false, true)
if not L then return end

L["                                                      Version: %s                                                      "] = "                                                      版本: %s                                                      "
L["Unknown"] = "未知"
L["|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n"] = "|cffFF0000x|rCT|cffFFFF00+|r|cff798BDD设置工具|r\n"
L["|cffFFFF00Helpful Tips:|r\n\n"] = "|cffFFFF00实用小贴士:|r\n\n"
L["On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options."] = "在左边的列表中, 在|cffFFFF00启动消息|r复选框下, 您可以点击|cff798BDD+按钮|r(加号)来显示更多选项."
L["Hide Config in Combat"] = "在战斗中隐藏设置"
L["This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r"] = "这个选项有助于防止用户界面污染, 当您进入战斗时关闭设置.\n\n|cffFF8000强烈推荐启用|r"
L["Allows you to preview xCT+ in order to tweak settings outside of combat.\n\nYou can also type: '|cffFF0000/xct test|r'"] = "允许您预览xCT+以便在战斗之外调整设置.\n\n您也可以输入: '|cffFF0000/xct test|r'"
L["Test"] = "测试"
L["Move"] = "移动"
L["Allows you to adjust the position of all the xCT+ frames on your screen.\n\nYou can also type: '|cffFF0000/xct lock|r'"] = "允许您调整所有xCT+框体在您屏幕上的位置.\n\n您也可以输入: '|cffFF0000/xct lock|r'"

-- Frames
L["Frame Settings"] = "框体设置"
L["Frame Strata"] = "框体层级"
L["The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata."] = "设置|cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r框体的Z层级. 如果您发现另一个插件挡住了|cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r框体, 可以尝试提高框体层级."
L["Parent |cffFF0000(Lowest)|r"] = "父级|cffFF0000(最低)|r"
L["Background |cffFF0000(Lowest)|r"] = "背景|cffFF0000(最底)|r"
L["Low"] = "底层"
L["Medium"] = "中间"
L["High |cffFFFF00(Default)|r"] = "高|cffFFFF00(默认)|r"
L["Dialog"] = "聊天框"
L["Fullscreen"] = "全屏"
L["Fullscreen Dialog"] = "全屏聊天框"
L["ToolTip |cffAAFF80(Highest)|r"] = "提示信息|cffAAFF80(最高)|r"
L["Clear Frames when leaving combat"] = "离开战斗时清除框体"
L["Enable this option if you have problems with 'floating' icons."] = "如果您遇到'浮动'图标的问题请启用此选项."
L["When moving the Frames"] = "移动框体时"
L["Show Align Grid"] = "显示对齐网格"
L["Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."] = "在您|cffFFFF00切换框体|r后显示一个网格帮助您更好地对齐|cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r框体."
L["Show Positions"] = "显示位置"
L["Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."] = "在您|cffFFFF00切换框体|r后显示框体的位置和大小帮助您更好地对齐|cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r框体."

-- megaDamage
L["Number Format Settings"] = "数字格式设置"
L["Format Numbers in the Frames (Choose one)"] = "框体中的数字格式(选一个)"
L["|cffFFFF00PLEASE NOTE|r |cffAAAAAAFormat settings need to be independently enabled on each frame through its respective settings page.|r\n"] = "|cffFFFF00请注意|r|cffAAAAAA格式设置需要在每个框体上通过其各自的设置页面独立启用.|r\n"
L["Abbreviate Numbers"] = "数字缩写"
L["Decimal Marks"] = "小数点符号"
L["Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r"] = "将小数分组并以逗号分隔; 这使得在读取数字时有更好的反应速度.\n\n|cffFF0000比如|r |cff798BDD12,890|r"
L["Single Decimal Precision"] = "单一小数精度"
L["Shows a single digit of precision when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r)."] = "在缩写数值时显示单一小数精度(例如显示|cff798BDD5.9K|r而不是|cff798BDD6K|r)."
L["Thousand Symbol"] = "千位符号"
L["Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r"] = "符号表示: |cffFF0000千位|r|cff798BDD(10e+3)|r"
L["Million Symbol"] = "百万符号"
L["Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r"] = "符号表示: |cffFF0000百万|r|cff798BDD(10e+6)|r"
L["Billion Symbol"] = "十亿符号"
L["Symbol for: |cffFF0000Billions|r |cff798BDD(10e+9)|r"] = "符号表示: |cffFF0000十亿|r|cff798BDD(10e+9)|r"
