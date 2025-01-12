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

local _, addon = ...

local _, _, _, alias, item, header = unpack(addon.merge_helpers)

header("10.x |cff33937FDragonflight|r")
do
    alias(425461, 425701) -- Trinket: Tainted Rageheart (Spell: Shadowflame Lash)

    item(417134, 3.0, "Legendary: Rage of Fyr'alath")
    alias(424094, 417134) -- Rage of Fyr'alath -> Weapon Fyr'alath
    alias(413584, 417134) -- Explosive Rage -> Weapon Fyr'alath

    alias(426527, 426535) -- Amirdrassil Head Enchant (Melee) - 2nd Effect
end
