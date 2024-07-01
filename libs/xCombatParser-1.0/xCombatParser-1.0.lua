
-- Create out library
local Lib, oldLib = LibStub:NewLibrary("xCombatParser-1.0", 2)
if not Lib then return end

-- Our own personal space
local private = {}
Lib.private = private

-- This library's functions
local mt = {__index = {}}

do
	-- Upvalues
	local next=next

	-- Registered Event Handles
	-- Hook into the old handles incase someone registered with them before we could load.
	private.handles = oldLib and oldLib.private.handles or{}

	-- ------------------------------------------------------------------------------
	--                               Combat Log Helper
	-- ------------------------------------------------------------------------------
	--   A concise and easy combat log helper that helps parse events.
	-- ------------------------------------------------------------------------------
	-- function Lib:RegisterCombat ( func )
	--   Parameters:
	--       func [callback - function ( args )]:
	--           Callback for every combat event.
	--           Parameters:
	--                args [table]: A table that contains the combat event args.
	--                              Please do NOT change any of the values as it is
	--                              going to be passed to everyone. If you need to
	--                              hold it for a while, use "args:pin()" and
	--                              "args:free()" when you are finished with it.
	-- ------------------------------------------------------------------------------
	function Lib:RegisterCombat(func)
		private.handles[func]=true
		private.frame:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
	end

	-- ------------------------------------------------------------------------------
	-- function Lib:UnregisterCombat ( func )
	--   Parameters:
	--       func [callback - function ( args )]:
	--           The callback that you want to unregister from getting combat
	--           events. See "Lib:RegisterCombat" for more details.
	-- ------------------------------------------------------------------------------
	function Lib:UnregisterCombat(func)
		private.handles[func]=nil
		if not next(private.handles)then
			private.frame:UnregisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
		end
	end
end

-- ------------------------------------------------------------------------------
--                             Recyclable Table Pool
-- ------------------------------------------------------------------------------
--   An extremely simple table recycle program. "Save the Earth"™
--
--   Look at documentation below for details on:
--       + function private.create
--       + function private.destroy
--       + function private.wipe
--       + function private.pin
--       + function private.free
-- ------------------------------------------------------------------------------
do
	-- Upvalues
	local pairs,error,next=pairs,error,next

	-- Pool of tables we've destroyed (they are kept as weak)
	private.mt_weakKeys=oldLib and oldLib.private.mt_weakKeys or setmetatable({}, {__mode = 'k'})

	-- Use our older table pool
	private.tables=oldLib and oldLib.private.tables or setmetatable({},private.mt_weakKeys)

	-- ------------------------------------------------------------------------------
	-- function private.create ( )
	--   Returns:
	--       t [table]:
	--           A clean table ready to go. If a table was recently recycled, you
	--           got that one, otherwise this is a brand new table.
	-- ------------------------------------------------------------------------------
	private.create=function()
		local t=next(private.tables)
		if t then private.tables[t]=nil;end
		return t or{}
	end

	-- ------------------------------------------------------------------------------
	-- function private.destroy ( t )
	--   Parameters:
	--       t [table]:
	--           A table you want recycled. All its values will be removed and it
	--           will be placed in cold storage waiting for private.create()
	--
	--  TODO: Recored where it is pinned created incase they dont destroy
	-- ------------------------------------------------------------------------------
	private.destroy=function(t)
		if t.__pinned and t.__pinned>0 then error"this table is being used somewhere"end
		private.tables[private.wipe(t)]=true
	end

	-- ------------------------------------------------------------------------------
	-- function private.wipe ( t )
	--   Parameters:
	--       t [table]:
	--           A table that contains values you want to wipe.
	--
	--   Returns:
	--       t [table]:
	--           The return "t" and the parameter "t" are the same table.
	-- ------------------------------------------------------------------------------
	private.wipe=function(t)
		for i in pairs(t)do t[i]=nil;end
		return t
	end

	-- ------------------------------------------------------------------------------
	-- function private.pin ( t )
	--   Parameters:
	--       t [table]:
	--           A table that you want to keep for an indeterminate amount of time.
	--           Once "pinned" a table cannot be destroyed until it has been "freed"
	--           the same amount of times as it has been pinned. When there are no
	--           more references, it will be destroyed automatically.
	-- ------------------------------------------------------------------------------
	private.pin=function(t)
		if not t.__pinned then t.__pinned=1;else t.__pinned=t.__pinned+1;end
	end

	-- ------------------------------------------------------------------------------
	-- function private.free ( t )
	--   Parameters:
	--       t [table]:
	--           A table that has been pinned. If there are no more references to
	--           this table, the table will be destroyed automatically.
	-- ------------------------------------------------------------------------------
	private.free=function(t)
		if not t.__pinned then error"table has not been pinned"end
		t.__pinned=t.__pinned-1
		if t.__pinned==0 then private.destroy(t)end
	end

	-- ------------------------------------------------------------------------------
	-- function private.populate ( ... )
	--   Parameters:
	--       ... [dynamic]:
	--           A list of parameters to populate the table with
	-- ------------------------------------------------------------------------------
	private.populate=function(...)
		local t,n=private.create(),select('#',...)
		for i=1,n do
			t[i]=select(i,...)
		end
		t.n=n
		return t
	end
end

-- Handle the Events
do
	-- Upvalues (Only values that will be used more than once)
	local select,sub,tostring,playerGUID=select,string.sub,tostring

	-- Recycle or create out event frame
	private.frame=oldLib and oldLib.private.frame or CreateFrame"frame"
	private.frame:RegisterEvent"PLAYER_ENTERING_WORLD"

	-- Localize Auto Attack
	local ENVIRONMENT_SUBHEADER,AUTO_ATTACK=ENVIRONMENT_SUBHEADER,C_Spell.GetSpellName(6603)

	-- Localize Environmental Damage
	local ENVIRONMENTAL_TYPES = {
		["Drowning"] = ACTION_ENVIRONMENTAL_DAMAGE_DROWNING,
		["Falling"] = ACTION_ENVIRONMENTAL_DAMAGE_FALLING,
		["Fatigue"] = ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE,
		["Fire"] = ACTION_ENVIRONMENTAL_DAMAGE_FIRE,
		["Lava"] = ACTION_ENVIRONMENTAL_DAMAGE_LAVA,
		["Slime"] = ACTION_ENVIRONMENTAL_DAMAGE_SLIME
	}

	-- Used for Spell Icons ONLY
	local ENVIRONMENTAL_FAKE_IDS = {
		["Drowning"] = 89662, -- Drowning (Quest in Hillsbrad (Lvl ~22), for Horde only)
		["Falling"] = 150875, -- Falling (Not sure where it is used)
		["Fatigue"] = 125024, -- Fatigue (Not sure where it is used)
		["Fire"] = 186242,    -- Fire (Not sure where it is used)
		["Lava"] = 192519,    -- Lava (New spell mechanic for something in Legion)
		["Slime"] = 179021,   -- Slime (New spell mechanic for something in Legion)
	}

	local ENVIRONMENTAL_FAKE_SPELLSCHOOL = {
		["Drowning"] = 1, -- Physical
		["Falling"] = 1,  -- Physical
		["Fatigue"] = 1,  -- Physical
		["Fire"] = 4,     -- Fire
		["Lava"] = 4,     -- Fire
		["Slime"] = 8,    -- Nature
	}

	-- Handle all the combat events. This needs to be extremely efficient
	private.frame:SetScript("OnEvent", function(self, frameEvent)
		if frameEvent == "COMBAT_LOG_EVENT_UNFILTERED" then
			local n = 12
			local i, args = 0, private.create()

			-- Create the table so that we can resuse it later
			local t = private.populate( CombatLogGetCurrentEventInfo() )

			-- fast event
			local event = t[2]

			-- 11 Parameters of the COMBAT_LOG_EVENT   ---   Index
			args.timestamp       = t[1]
			args.event           = t[2]
			args.hideCaster      = t[3]
			args.sourceGUID      = t[4]
			args.sourceName      = t[5]
			args.sourceFlags     = t[6]
			args.sourceRaidFlags = t[7]
			args.destGUID        = t[8]
			args.destName        = t[9]
			args.destFlags       = t[10]
			args.destRaidFlags   = t[11]

			local prefix, suffix
			if event == "DAMAGE_SHIELD" or event == "DAMAGE_SPLIT" then
				prefix = "SPELL"
				suffix = "_DAMAGE"
			elseif event == "SPELL_ABSORBED" then
				if t.n <= 21 then
					prefix = "SWING"
					suffix = "_ABSORBED"
				else
					prefix = "SPELL"
					suffix = "_ABSORBED"
				end
			elseif event == "DAMAGE_SHIELD_MISSED" then
				prefix = "SPELL"
				suffix = "_MISSED"
			elseif event == "ENCHANT_APPLIED" or event == "ENCHANT_REMOVED" then
				args.spellName, args.itemId, args.itemName = t[n], t[n+1], t[n+2]
				--args.spellName, args.itemId, args.itemName = select(1, ...)

			elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" or event == "UNIT_DISSIPATES" then
				args.recapID, args.unconsciousOnDeath = t[n], t[n+1]

			elseif event == "PARTY_KILL" then -- do nothing
			else
				prefix = sub(event, 1, 14)
				if prefix == "SPELL_PERIODIC" or prefix == "SPELL_BUILDING" then
					suffix = sub(event, 15)
				else
					prefix = sub(event, 1, 5)
					if prefix == "SPELL" or prefix == "SWING" or prefix == "RANGE" then
						suffix = sub(event, 6)
					else
						prefix = sub(event, 1, 13)
						if prefix == "ENVIRONMENTAL" then
							suffix = sub(event, 14)
						else
							error("Unhandled Combat Log Event: " .. tostring(event))
						end
					end
				end
			end

			args.prefix = prefix
			args.suffix = suffix

			if prefix == "SPELL" or prefix == "SPELL_PERIODIC" or prefix == "RANGE" or prefix == "SPELL_BUILDING" then
				args.spellId, args.spellName, args.spellSchool = t[n], t[n+1], t[n+2]
				i = 3
			elseif prefix == "ENVIRONMENTAL" then
				local environmentalType = t[n]

				args.environmentalType = environmentalType
				args.sourceName = ENVIRONMENT_SUBHEADER

				-- Fake out some spell things for icons and names
				args.spellId, args.spellName, args.spellSchool = ENVIRONMENTAL_FAKE_IDS[environmentalType],
				ENVIRONMENTAL_TYPES[environmentalType], ENVIRONMENTAL_FAKE_SPELLSCHOOL[environmentalType]
				i = 1
			elseif prefix == "SWING" then
				-- SpellId for Auto Attack, "Auto Attack" (Localized), Physical Damage (Spell School)
				args.spellId, args.spellName, args.spellSchool = 6603, AUTO_ATTACK, 1
			end

			if suffix == "_DAMAGE" then
				args.amount, args.overkill, args.school,
				args.resisted, args.blocked, args.absorbed,
				args.critical, args.glancing, args.crushing,
				args.isOffHand = t[n+i], t[n+i+1], t[n+i+2],
				t[n+i+3], t[n+i+4], t[n+i+5], t[n+i+6],
				t[n+i+7], t[n+i+8], t[n+i+9]

			elseif suffix == "_ABSORBED" then
				args.casterGUID, args.casterName, args.casterFlags,
				args.casterRaidFlags, args.absorbSpellId, args.absorbSpellName,
				args.absorbSpellSchool, args.amount, args.critical =
				t[n+i], t[n+i+1], t[n+i+2],
				t[n+i+3], t[n+i+4], t[n+i+5],
				t[n+i+6], t[n+i+7], t[n+i+8]

			elseif suffix == "_MISSED" then
				args.missType, args.isOffHand,
				args.amountMissed = t[n+i], t[n+i+1], t[n+i+2] or 0

			elseif suffix == "_HEAL" then
				args.amount, args.overhealing, args.absorbed,
				args.critical = t[n+i], t[n+i+1], t[n+i+2], t[n+i+3]

			elseif suffix == "_ENERGIZE" then
				args.amount, args.overEnergize, args.powerType,
				args.alternatePowerType = t[n+i], t[n+i+1], t[n+i+2], t[n+i+3]

			elseif suffix == "_DRAIN" or suffix == "_LEECH" then
				args.amount, args.powerType,
				args.extraAmount = t[n+i], t[n+i+1], t[n+i+2]

			elseif suffix == "_INTERRUPT" or suffix == "_DISPEL_FAILED" then
				args.extraSpellId, args.extraSpellName,
				args.extraSchool = t[n+i], t[n+i+1], t[n+i+2]

			elseif suffix == "_DISPEL" or suffix == "_STOLEN" then
				args.extraSpellId, args.extraSpellName,
				args.extraSchool, args.auraType = t[n+i], t[n+i+1], t[n+i+2], t[n+i+3]

			elseif suffix == "_EXTRA_ATTACKS" then
				args.amount = t[n+i]

			elseif suffix == "_AURA_APPLIED" or suffix == "_AURA_REMOVED"
				or suffix == "_AURA_APPLIED_DOSE" or suffix == "_AURA_REMOVED_DOSE"
				or suffix == "_AURA_REFRESH" then
				-- auraType: BUFF, DEBUFF
				args.auraType, args.amount = t[n+i], t[n+i+1]

			elseif suffix == "_AURA_BROKEN" then
				args.auraType = t[n+i]

			elseif suffix == "_AURA_BROKEN_SPELL" then
				args.extraSpellId, args.extraSpellName,
				args.extraSchool, args.auraType = t[n+i], t[n+i+1], t[n+i+2]

			elseif suffix == "_CAST_FAILED" then
				args.failedType = t[n+i]
			end

			-- Destroy the old
			private.destroy(t)

			-- IsPlayer helpers
			args.isPlayer = playerGUID == args.sourceGUID
			args.atPlayer = playerGUID == args.destGUID

			-- Add Our API to the Combat Event Args
			setmetatable(args, mt)

			-- Call all the registered handlers
			args:pin()
			for func in pairs(private.handles) do
				func(args)
			end
			args:free() -- If no one else pinned this table, it should be cleaned up now
		else
			self:UnregisterEvent"PLAYER_ENTERING_WORLD"
			playerGUID=UnitGUID"player"
		end

	end)
end

-- Functions that don't require hasFlag
do
	local band = bit.band
	do
		-- Up-values
		local COMBATLOG_OBJECT_TYPE_MASK, COMBATLOG_OBJECT_CONTROL_MASK,
			COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_AFFILIATION_MASK =
			COMBATLOG_OBJECT_TYPE_MASK, COMBATLOG_OBJECT_CONTROL_MASK,
			COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_AFFILIATION_MASK

		local COMBATLOG_OBJECTS = {
			[0] = 'UNKNOWN',

			-- Types
			[COMBATLOG_OBJECT_TYPE_GUARDIAN] = 'GUARDIAN',
			[COMBATLOG_OBJECT_TYPE_OBJECT] = 'OBJECT',
			[COMBATLOG_OBJECT_TYPE_PLAYER] = 'PLAYER',
			[COMBATLOG_OBJECT_TYPE_PET] = 'PET',
			[COMBATLOG_OBJECT_TYPE_NPC] = 'NPC',

			-- Controllers
			[COMBATLOG_OBJECT_CONTROL_PLAYER] = 'PLAYER',
			[COMBATLOG_OBJECT_CONTROL_NPC] = 'NPC',

			-- Reactions
			[COMBATLOG_OBJECT_REACTION_FRIENDLY] = 'FRIENDLY',
			[COMBATLOG_OBJECT_REACTION_HOSTILE] = 'HOSTILE',
			[COMBATLOG_OBJECT_REACTION_NEUTRAL] = 'NEUTRAL',

			-- Affiliations
			[COMBATLOG_OBJECT_AFFILIATION_OUTSIDER] = 'OUTSIDER',
			[COMBATLOG_OBJECT_AFFILIATION_PARTY] = 'PARTY',
			[COMBATLOG_OBJECT_AFFILIATION_RAID] = 'RAID',
			[COMBATLOG_OBJECT_AFFILIATION_MINE] = 'MINE',
		}

		function private.GetSourceType (args)
			if args.prefix == 'ENVIRONMENTAL' then return 'ENVIRONMENT' end
			return COMBATLOG_OBJECTS[band(args.sourceFlags or 0, COMBATLOG_OBJECT_TYPE_MASK)]
		end

		function private.GetDestinationType (args)
			return COMBATLOG_OBJECTS[band(args.destFlags or 0, COMBATLOG_OBJECT_TYPE_MASK)]
		end

		function private.GetSourceController (args)
			if args.prefix == 'ENVIRONMENTAL' then return 'ENVIRONMENT' end
			return COMBATLOG_OBJECTS[band(args.sourceFlags or 0, COMBATLOG_OBJECT_CONTROL_MASK)]
		end

		function private.GetDestinationController (args)
			return COMBATLOG_OBJECTS[band(args.destFlags or 0, COMBATLOG_OBJECT_CONTROL_MASK)]
		end

		function private.GetSourceReaction (args)
			if args.prefix == 'ENVIRONMENTAL' then return 'NEUTRAL' end
			return COMBATLOG_OBJECTS[band(args.sourceFlags or 0, COMBATLOG_OBJECT_REACTION_MASK)]
		end

		function private.GetDestinationReaction (args)
			return COMBATLOG_OBJECTS[band(args.destFlags or 0, COMBATLOG_OBJECT_REACTION_MASK)]
		end

		function private.GetSourceAffiliation (args)
			if args.prefix == 'ENVIRONMENTAL' then return 'OUTSIDER' end
			return COMBATLOG_OBJECTS[band(args.sourceFlags or 0, COMBATLOG_OBJECT_AFFILIATION_MASK)]
		end

		function private.GetDestinationAffiliation (args)
			return COMBATLOG_OBJECTS[band(args.destFlags or 0, COMBATLOG_OBJECT_AFFILIATION_MASK)]
		end
	end

	-- GetSourceRaidTargetIndex, GetDestinationRaidTargetIndex, GetSourceRaidTargetName, and GetDestinationRaidTargetName
	do
		local RAIDTARGET_INDEXES, RAIDTARGET_NAMES, COMBATLOG_OBJECT_RAIDTARGET_MASK = {
			[0] = 0,
			[COMBATLOG_OBJECT_RAIDTARGET1] = 1,
			[COMBATLOG_OBJECT_RAIDTARGET2] = 2,
			[COMBATLOG_OBJECT_RAIDTARGET3] = 3,
			[COMBATLOG_OBJECT_RAIDTARGET4] = 4,
			[COMBATLOG_OBJECT_RAIDTARGET5] = 5,
			[COMBATLOG_OBJECT_RAIDTARGET6] = 6,
			[COMBATLOG_OBJECT_RAIDTARGET7] = 7,
			[COMBATLOG_OBJECT_RAIDTARGET8] = 8
		}, {
			RAID_TARGET_1, RAID_TARGET_2, RAID_TARGET_3,
			RAID_TARGET_4, RAID_TARGET_5, RAID_TARGET_6,
			RAID_TARGET_7, RAID_TARGET_8, [0] = NONE
		}, COMBATLOG_OBJECT_RAIDTARGET_MASK

		function private.GetSourceRaidTargetIndex (args)
			return RAIDTARGET_INDEXES[band(args.sourceRaidFlags or 0, COMBATLOG_OBJECT_RAIDTARGET_MASK)]
		end

		function private.GetDestinationRaidTargetIndex (args)
			return RAIDTARGET_INDEXES[band(args.destRaidFlags or 0, COMBATLOG_OBJECT_RAIDTARGET_MASK)]
		end

		function private.GetSourceRaidTargetName (args)
			return RAIDTARGET_NAMES[private.GetSourceRaidTargetIndex(args)]
		end

		function private.GetDestinationRaidTargetName (args)
			return RAIDTARGET_NAMES[private.GetDestinationRaidTargetIndex(args)]
		end
	end
end

local hasFlag
do
	local band = bit.band
	function hasFlag (flags, flag)
		return band(flags or 0, flag) == flag
	end
end

do
	local COMBATLOG_OBJECT_NONE = COMBATLOG_OBJECT_NONE

	function private.IsSourceNotSpecial (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_NONE)
	end

	function private.IsDestinationNotSpecial (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_NONE)
	end
end

do
	local COMBATLOG_OBJECT_MAINASSIST = COMBATLOG_OBJECT_MAINASSIST

	function private.IsSourceMainAssist (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_MAINASSIST)
	end

	function private.IsDestinationMainAssist (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_MAINASSIST)
	end
end

do
	local COMBATLOG_OBJECT_MAINTANK = COMBATLOG_OBJECT_MAINTANK

	function private.IsSourceMainTank (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_MAINTANK)
	end

	function private.IsDestinationMainTank (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_MAINTANK)
	end
end

do
	local COMBATLOG_OBJECT_FOCUS = COMBATLOG_OBJECT_FOCUS

	function private.IsSourceFocus (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_FOCUS)
	end

	function private.IsDestinationFocus (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_FOCUS)
	end
end

do
	local COMBATLOG_OBJECT_TARGET = COMBATLOG_OBJECT_TARGET

	function private.IsSourceTarget (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_TARGET)
	end

	function private.IsDestinationTarget (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_TARGET)
	end
end

do
	local MY_PET_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE,
	                             COMBATLOG_OBJECT_REACTION_FRIENDLY,
	                             COMBATLOG_OBJECT_CONTROL_PLAYER,
	                             COMBATLOG_OBJECT_TYPE_PET)

	function private.IsSourceMyPet (args)
		return hasFlag(args.sourceFlags, MY_PET_FLAGS)
	end

	function private.IsDestinationMyPet (args)
		return hasFlag(args.destFlags, MY_PET_FLAGS)
	end
end

do
	local MY_VEHICLE_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE,
	                                 COMBATLOG_OBJECT_REACTION_FRIENDLY,
	                                 COMBATLOG_OBJECT_CONTROL_PLAYER,
	                                 COMBATLOG_OBJECT_TYPE_GUARDIAN)

	function private.IsSourceMyVehicle (args)
		return hasFlag(args.sourceFlags, MY_VEHICLE_FLAGS)
	end

	function private.IsDestinationMyVehicle (args)
		return hasFlag(args.destFlags, MY_VEHICLE_FLAGS)
	end
end

do
	local MY_RAID_MEMBER = bit.bor(COMBATLOG_OBJECT_AFFILIATION_RAID,
	                               COMBATLOG_OBJECT_REACTION_FRIENDLY,
	                               COMBATLOG_OBJECT_CONTROL_PLAYER,
	                               COMBATLOG_OBJECT_TYPE_PLAYER)

	function private.IsSourceRaidMember (args)
		return hasFlag(args.sourceFlags, MY_RAID_MEMBER)
	end

	function private.IsDestinationRaidMember (args)
		return hasFlag(args.destFlags, MY_RAID_MEMBER)
	end
end

do
	local MY_PARTY_MEMBER = bit.bor(COMBATLOG_OBJECT_AFFILIATION_PARTY,
	                                COMBATLOG_OBJECT_REACTION_FRIENDLY,
	                                COMBATLOG_OBJECT_CONTROL_PLAYER,
	                                COMBATLOG_OBJECT_TYPE_PLAYER)

	function private.IsSourcePartyMember (args)
		return hasFlag(args.sourceFlags, MY_PARTY_MEMBER)
	end

	function private.IsDestinationPartyMember (args)
		return hasFlag(args.destFlags, MY_PARTY_MEMBER)
	end
end

-- Memory Helpers
mt.__index.pin = private.pin
mt.__index.free = private.free

-- Unit Flag Helpers
mt.__index.GetSourceType             = private.GetSourceType
mt.__index.GetDestinationType        = private.GetDestinationType
mt.__index.GetSourceController       = private.GetSourceController
mt.__index.GetDestinationController  = private.GetDestinationController
mt.__index.GetSourceReaction         = private.GetSourceReaction
mt.__index.GetDestinationReaction    = private.GetDestinationReaction
mt.__index.GetSourceAffiliation      = private.GetSourceAffiliation
mt.__index.GetDestinationAffiliation = private.GetDestinationAffiliation

-- Raid Target Flag Helpers
mt.__index.GetSourceRaidTargetIndex      = private.GetSourceRaidTargetIndex
mt.__index.GetDestinationRaidTargetIndex = private.GetDestinationRaidTargetIndex
mt.__index.GetSourceRaidTargetName       = private.GetSourceRaidTargetName
mt.__index.GetDestinationRaidTargetName  = private.GetDestinationRaidTargetName

-- Special Unit Flag Helpers
mt.__index.IsSourceNotSpecial      = private.IsSourceNotSpecial
mt.__index.IsDestinationNotSpecial = private.IsDestinationNotSpecial
mt.__index.IsSourceMainAssist      = private.IsSourceMainAssist
mt.__index.IsDestinationMainAssist = private.IsDestinationMainAssist
mt.__index.IsSourceMainTank        = private.IsSourceMainTank
mt.__index.IsDestinationMainTank   = private.IsDestinationMainTank
mt.__index.IsSourceFocus           = private.IsSourceFocus
mt.__index.IsDestinationFocus      = private.IsDestinationFocus
mt.__index.IsSourceTarget          = private.IsSourceTarget
mt.__index.IsDestinationTarget     = private.IsDestinationTarget

-- Crafted Unit Flag Helpers
mt.__index.IsSourceMyPet          = private.IsSourceMyPet
mt.__index.IsDestinationMyPet     = private.IsDestinationMyPet
mt.__index.IsSourceMyVehicle      = private.IsSourceMyVehicle
mt.__index.IsDestinationMyVehicle = private.IsDestinationMyVehicle

-- Raid/Party Member Checks
mt.__index.IsSourceRaidMember       = private.IsSourceRaidMember
mt.__index.IsDestinationRaidMember  = private.IsDestinationRaidMember
mt.__index.IsSourcePartyMember      = private.IsSourcePartyMember
mt.__index.IsDestinationPartyMember = private.IsDestinationPartyMember
