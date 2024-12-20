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

local _, addon = ...

local _, _, _, alias, item, header = unpack(addon.merge_helpers)

header(" 7.x |cff93BE3DLegion|r")
do
    item(188091, 1.5, "Potion: Potion of Deadly Grace")
    item(188028, 1.5, "Potion: Potion of the Old War")

    item(225623, 1.5, "Food: Fishbrul Special")
    alias(225624, 225623) --  Pepper Breath
    alias(201573, 225623) --  Pepper Breath
    alias(233150, 188028) --  Hack to give the Old War potion an icon

    -- Trinkets
    item(215047, 3.0, "Trinket: Terrorbound Nexus")
    item(222168, 1.5, "Trinket: Spontaneous Appendages")
    item(214169, 1.5, "Trinket: Spiked Counterweight")
    item(215047, 3.0, "Trinket: Terrorbound Nexus")
    item(213786, 1.5, "Trinket: Corrupted Starlight")
    item(221845, 1.5, "Trinket: Twisting Wind")
    item(214350, 1.5, "Trinket: Oakheart's Gnarled Root")
    alias(228780, 214169) --  Brutal Haymaker (Spiked Counterweight)
    alias(213782, 213786) --  Trinket: Corrupted Starlight
    alias(213833, 213786) --  Trinket: Corrupted Starlight
    alias(213784, 213786) --  Trinket: Corrupted Starlight
    alias(213785, 213786) --  Trinket: Corrupted Starlight
    alias(221865, 221845) --  Trinket: Twisting Wind

    -- Trinkets: Nighthold
    item(225777, 3.5, "Trinket: Draught of Souls")
    item(225731, 3.0, "Trinket: Icon of Rot")
    item(225764, 1.5, "Trinket: Star Gate")

    -- Legendaries
    item(207694, 3.0, "Legendary: Cinidaria, the Symbiote")
    item(210999, 2.5, "Legendary: Obsidian Stone Spaulders")

    -- Val'sharah
    item(202917, 2.5, "Trinket: Temple Priestess' Charm")
    item(202891, 2.5, "Trinket: Lodestone of the Stormbreaker")

    -- Raids
    item(215300, 2.0, "Elerethe Renferal: Web of Pain [Tanks]")
    item(215307, 2.0, "Elerethe Renferal: Web of Pain [Other]")
    item(223699, 1.0, "Dragons of Nightmare: Volatile Infection")
end
