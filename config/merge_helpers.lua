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

addon.merges = {}
addon.replaceSpellId = {}

do
    local _working_category = ""
    local _working_category_order = 0
    local _working_desc = ""

    -- Switches to a class
    local function class(name)
        _working_category = name
        _working_category_order = _working_category_order + 1
    end

    -- Switches to a spec of a class (set before)
    local function spec(id)
        _working_desc = tonumber(id) or id
        _working_category_order = _working_category_order + 1
    end

    -- Switches to another header
    local function header(title)
        _working_category = title
        _working_desc = ""
        _working_category_order = _working_category_order + 1
    end

    -- Adds a spell to the merge list
    -- Either call class() & spec() or header() before!
    local function spell(id, interval)
        addon.merges[tonumber(id) or id] = {
            category = _working_category,
            categoryOrder = _working_category_order, -- doesnt matter
            interval = tonumber(interval) or interval,
            desc = _working_desc, -- TODO its the spec ID
        }
    end

    -- Adds a merge for a racial spell
    -- Call header() before!
    local function racial_spell(id, interval)
        addon.merges[tonumber(id) or id] = {
            category = _working_category,
            categoryOrder = _working_category_order,
            interval = tonumber(interval) or interval,
            desc = "Racial Spell",
        }
    end

    -- Adds an item to the merge list
    -- Call header() before!
    local function item(id, interval, desc)
        addon.merges[id] = {
            category = _working_category,
            categoryOrder = _working_category_order,
            interval = tonumber(interval) or interval,
            desc = desc,
        }
    end

    -- If spell with id "spellId" is found, use the "replacementSpellId" instead
    -- e. g. for merges
    local function alias(spellId, replacementSpellId)
        addon.replaceSpellId[tonumber(spellId)] = tonumber(replacementSpellId)
    end

    addon.merge_helpers = { spell, class, spec, alias, item, header, racial_spell }
end
