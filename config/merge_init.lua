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

addon.merges = {}
addon.replaceSpellId = {}

do
    local _working = {}

    local function class(name)
        _working.class = tonumber(name) or name
    end

    local function spec(id)
        _working.desc = tonumber(id) or id
    end

    -- Adds a class spell to the merge list
    local function spell(id, interval)
        -- Create the spell here
        addon.merges[tonumber(id) or id] = {
            class = _working.class or "ITEM",
            interval = tonumber(interval) or interval or 0.5,
            desc = _working.desc, -- TODO its the spec ID
            prep = _working.prep or tonumber(interval) or interval or 0.5, -- TODO what is .prep?!
        }
    end

    -- rspell for race spells

    local _working_race_name = "Racial Spells"

    local function race(name)
        _working_race_name = name
    end

    -- Adds a merge for a racial spell
    local function rspell(id, interval)
        addon.merges[tonumber(id) or id] = {
            class = _working_race_name,
            interval = tonumber(interval) or interval or 0.5,
            desc = "Racial Spell",
            prep = interval or 0.5,
        }
    end

    -- If spell with id "spellId" is found, use the "replacementSpellId" instead
    -- e. g. for merges
    local function alias(spellId, replacementSpellId)
        addon.replaceSpellId[tonumber(spellId)] = tonumber(replacementSpellId)
    end

    -- item helper
    local _working_item_header = "ITEM"

    local function header(header)
        _working_item_header = header
    end

    -- Adds an item to the merge list
    local function item(id, interval, desc)
        addon.merges[id] = {
            class = _working_item_header,
            interval = tonumber(interval) or interval or 0.5,
            desc = desc,
            prep = tonumber(interval) or interval or 0.5,
        }
    end

    addon.merge_helpers = { spell, class, spec, alias, item, header, race, rspell }
end
