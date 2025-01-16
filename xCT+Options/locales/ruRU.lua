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

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(AddonName, "ruRU", true, true)
if not L then return end

L["                                                      Version: %s                                                      "] = "                                                      Версия: %s                                                      "
L["Unknown"] = true
L["|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDConfiguration Tool|r\n"] = "|cffFF0000x|rCT|cffFFFF00+|r |cff798BDDИнструмент конфигурации|r\n"
L["|cffFFFF00Helpful Tips:|r\n\n"] = "|cffFFFF00Полезные советы:|r\n\n"
L["On the left list, under the |cffFFFF00Startup Message|r checkbox, you can click on the |cff798BDD+ Buttons|r (plus) to show more options."] = "В левом списке под флажком |cffFFFF00Стартовое сообщение|r Вы можете нажать на кнопку |cff798BDD+ Кнопки|r (плюс), чтобы отобразить дополнительные параметры."
L["Hide Config in Combat"] = "Скрывать конфигурацию в бою"
L["This option helps prevent UI taints by closing the config when you enter combat.\n\n|cffFF8000Highly Recommended Enabled|r"] = "Эта опция помогает предотвратить порчу пользовательского интерфейса, закрывая конфигурацию при входе в бой.\n\n|cffFF8000Настоятельно рекомендуется включить|r"
L["Allows you to preview xCT+ in order to tweak settings outside of combat.\n\nYou can also type: '|cffFF0000/xct test|r'"] = "Позволяет предварительно просмотреть xCT+, чтобы изменить настройки вне боя.\n\nВы также можете ввести: '|cffFF0000/xct test|r'"
L["Test"] = "Тест"
L["Move"] = "Передвинуть"
L["Allows you to adjust the position of all the xCT+ frames on your screen.\n\nYou can also type: '|cffFF0000/xct lock|r'"] = "Позволяет Вам настроить положение всех фреймов xCT+ на Вашем экране.\n\nВы также можете ввести: '|cffFF0000/xct lock|r'"

-- Frames
L["Frame Settings"] = "Настройки фрейма"
L["Frame Strata"] = "Слой фрейма"
L["The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames onto. If you find that another addon is in front of |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames, try increasing the Frame Strata."] = true
L["Parent |cffFF0000(Lowest)|r"] = "Родительский |cffFF0000(Самый низкий)|r"
L["Background |cffFF0000(Lowest)|r"] = "Фон |cffFF0000(Самый низкий)|r"
L["Low"] = "Низкий"
L["Medium"] = "Средний"
L["High |cffFFFF00(Default)|r"] = "Высокий |cffFFFF00(по умолчанию)|r"
L["Dialog"] = "Диалоговый"
L["Fullscreen"] = "Полноэкранный"
L["Fullscreen Dialog"] = "Полноэкранный диалоговый"
L["ToolTip |cffAAFF80(Highest)|r"] = "Подсказка |cffAAFF80(Самый высокий)|r"
L["Clear Frames when leaving combat"] = "Очистить фреймы при выходе из боя"
L["Enable this option if you have problems with 'floating' icons."] = "Включите эту опцию, если у Вас возникли проблемы с 'плавающими' значками."
L["When moving the Frames"] = "При перемещении фреймов"
L["Show Align Grid"] = "Показать выравнивание по сетке"
L["Shows a grid after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."] = "Показывает сетку после |cffFFFF00Переключения фреймов|r, чтобы помочь Вам лучше выровнять |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r фреймы."
L["Show Positions"] = "Показать позиции"
L["Shows the locations and sizes of your frames after you |cffFFFF00Toggle Frames|r to help you align |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frames better."] = "Показывает расположение и размеры Ваших фреймов после того, как Вы |cffFFFF00Переключили фреймы|r, чтобы помочь Вам лучше выровнять |cffFF0000x|r|cffFF00CT|r|cffFF0000+|r фреймы"

-- megaDamage
L["Number Format Settings"] = "Настройки числового формата"
L["Format Numbers in the Frames (Choose one)"] = "Форматировать числа во фреймах (выберите один)"
L["|cffFFFF00PLEASE NOTE|r |cffAAAAAAFormat settings need to be independently enabled on each frame through its respective settings page.|r\n"] = "|cffFFFF00ОБРАТИТЕ ВНИМАНИЕ|r |cffAAAAAAНастройки формата необходимо включать независимо для каждого фрейма через соответствующую страницу настроек.|r\n"
L["Abbreviate Numbers"] = "Сокращение чисел"
L["Decimal Marks"] = "Десятичные знаки"
L["Groups decimals and separates them by commas; this allows for better responsiveness when reading numbers.\n\n|cffFF0000EXAMPLE|r |cff798BDD12,890|r"] = "Группирует десятичные числа и разделяет их запятыми; это позволяет лучше реагировать при чтении чисел.\n\n|cffFFFF0000ПРИМЕР|r |cff798BDD12,890|r"
L["Single Decimal Precision"] = "Точность одинарного знака после запятой"
L["Shows a single digit of precision when abbreviating the value (e.g. will show |cff798BDD5.9K|r instead of |cff798BDD6K|r)."] = "Показывает одну цифру точности при сокращении значения (например, будет показано |cff798BDD5.9K|r вместо |cff798BDD6K|r)."
L["Thousand Symbol"] = "Символ тысячи"
L["Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r"] = "Символ для: |cffFF0000Тысячи|r |cff798BDD(10e+3)|r"
L["Million Symbol"] = "Символ миллиона"
L["Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r"] = "Символ для: |cffFF0000Миллиона|r |cff798BDD(10e+6)|r"
L["Billion Symbol"] = "Символ миллиарда"
L["Symbol for: |cffFF0000Billions|r |cff798BDD(10e+9)|r"] = "Символ для: |cffFF0000Миллиарда|r |cff798BDD(10e+9)|r"
