-- Reuben DeLeon: All Rights Reserved. 2018.

-- This example is supposed to help you use xCombatParser-1.0.
-- You need to already have LibStub loaded before xCombatParser.

-- Description:
-- Record all the interrupts that your party/raid did during a combat phase.
-- At the end of combat it will print the top three people that interrupted.


-- Load the xCombatParser Library with LibStub
local xCP = LibStub and LibStub("xCombatParser-1.0", true)

-- Cache all the interrupts that happened during combat
local interruptCache = {}

-- Our xCombatParser Handler
local function xCombatParser_Handler (args)

	-- We only care about people in our raid that interrupted
	if args.suffix == '_INTERRUPT' and (args :IsSourceRaidMember () or args :IsSourcePartyMember ()) then

		-- We need to keep the args around until we are finished with them
		args :pin ()

		-- Faster than table.insert
		interruptCache[#interruptCache + 1] = args
	end
end

-- Create a frame to listen for WoW Combat Enter/Leaving Events
local events = CreateFrame 'Frame'
events :RegisterEvent 'PLAYER_REGEN_DISABLED'
events :RegisterEvent 'PLAYER_REGEN_ENABLED'

events :SetScript ('OnEvent', function (self, event)

	-- Start Logging
	if event == 'PLAYER_REGEN_DISABLED' then
		xCP :RegisterCombat (xCombatParser_Handler)

	-- Stop Logging
	elseif event == 'PLAYER_REGEN_ENABLED' then
		xCP :UnregisterCombat (xCombatParser_Handler)

		-- List of Names, amounts that interrupt
		local interrupts = {}

		-- Total up all the interrupts
		for _, args in pairs(interruptCache) do
			-- If nil, it will create a new entry, otherwise add one to the count
			interrupts[args.sourceName] = (interrupts[args.sourceName] or 0) + 1

			-- ALWAYS free anything you pin
			args :free ()
		end

		-- Sort names by count
		local temp = {}
		for name, count in pairs(interrupts) do
			temp[#temp + 1] = {name = name, count = count}
		end
		table.sort(temp, function (a,b) return a.count < b.count end)

		print "Interrupt Recount:"

		if #temp == 0 then
			print "    Fight Had No Interrupts!"
		else
			for index=1,3 do
				local name, count = temp[index].name, temp[index].count
				print (string.format("    %d: %s interrupted %d time%s.", index, name, count, count == 1 and "" or "s"))
			end
		end

		-- Clear out the old cache
		interrupts = {}
	end
end)
