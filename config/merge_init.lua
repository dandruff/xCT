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
addon.merge2h = {}

do
	local _debug_working = false
	local _working = {}

	local function class(name)
		_working.class = tonumber(name) or name
	end

	local function spec(id)
		_working.desc = tonumber(id) or id
	end

	-- spell helper

	-- for spell, but the second arg
	local function spell_2(interval)
		_debug_working = false
		interval = tonumber(interval)
		-- Create the spell here
		addon.merges[_working.spellId] = {
			class = _working.class or "ITEM",
			interval = interval or 0.5,
			desc = _working.desc,
			prep = _working.prep or interval or 0.5,
		}
	end

	-- Adds a class spell to the merge list
	local function spell(id)

		-- Leave this in so you don't shoot yourself in the foot
		if _debug_working then error "finish your first spell" end
		_debug_working = true

		_working.spellId = tonumber(id) or id
		return spell_2
	end
	
	-- rspell for race spells
	
	local _debug_working_race = false
	local _working_race = {}
	
	local function race(name)
		_working_race.race = name
	end
	
	-- for spell, but the second arg
	local function rspell_2(interval)
		_debug_working_race = false
		interval = tonumber(interval)
		-- Create the spell here
		addon.merges[_working_race.spellId] = {
			class = _working_race.race or "ITEM",
			interval = interval or 0.5,
			desc = "Racial Spell",
			prep = _working_race.prep or interval or 0.5,
		}
	end
	
	local function rspell(id)

		-- Leave this in so you don't shoot yourself in the foot
		if _debug_working_race then error "finish your first spell" end
		_debug_working_race = true
		_working_race.spellId = tonumber(id) or id
		return rspell_2
	end

	-- alias helper
	local _debug_working_alias = false
	local _working_alias

	local function alias_2(id)
		_debug_working_alias = false
		addon.merge2h[_working_alias] = tonumber(id)
	end

	local function alias(id)

		-- Leave this in so you don't shoot yourself in the foot
		if _debug_working_alias then error "finish your first alias" end
		_debug_working_alias = true

		_working_alias = tonumber(id)
		return alias_2
	end

	-- item helper
	local _debug_working_item = false
	local _working_item = {}

	local function header(title)
		_working_item.class = title
	end

	local function item_3(desc)
		_debug_working_item = false
		-- Create the spell here
		addon.merges[_working_item.spellId] = {
			class = _working_item.class or "ITEM",
			interval = _working_item.interval or 0.5,
			desc = desc,
			prep = _working_item.prep or _working_item.interval or 0.5,
		}
	end

	local function item_2(interval)
		_working_item.interval = tonumber(interval)
		return item_3
	end

	-- Adds a class spell to the merge list
	local function item(id)

		-- Leave this in so you don't shoot yourself in the foot
		if _debug_working_item then error "finish your first item" end
		_debug_working_item = true

		_working_item.spellId = tonumber(id) or id
		return item_2
	end


	addon.merge_helpers = {spell, class, spec, alias, item, header, race, rspell}
end
