


-- Spam Merger for xCT+
local spam = {
	handlers = {},
	frame = CreateFrame("frame")
}

function spam:AddMessage(key, item)
	if not self:IsSpam(key) then
		error("'key' ("..key..") needs to be defined in the spamDB")
	end
	key = self.db.merge[key] or key
	local time,i=GetTime(),self.items
	if not i[key]then i[key]=x.create()end
	i[key][#i[key]+1]=item
	i[key].isUpdating=true
	i[key].lastEntry=time
	if not i[key].lastUpdate then
		i[key].lastUpdate=time
	end
	if not self.isUpdating then
		x.RegisterEvent("OnUpdate", self)
		self.isUpdating = true
	end
end

function spam:AddMessage(key, item)
	-- Check to see if we know how to merge this item
	if not self:IsSpam(key) then return false end

	-- Check for a spell id replacement (2 handed swings)
	key = self.db.merge[key] or key

	-- Cache some values
	local now, items = GetTime(), self.items

	-- TODO: change this to a managed table
	if not items[key] then items[key] = {} end

	-- Cache the current working list of items
	local list = items[key]

	-- Insert that current item into the list
	list[#list + 1] = item

	-- Mark the list as active
	list.isActive = true

	-- Prepare the list by informing it of the time that the last item was added
	list.lastEntryTime = now

	-- If this is the first item since a merge, the last time it was updated is now
	if not list.lastUpdate then list.lastUpdate = now end

	-- If this spam merger was not already active, activate it now
	if not self.isUpdating then
		self.frame:RegisterEvent('OnUpdate', self)
	end
end


function spam:RegisterHandler(index, callback)
	self.handlers[index] = callback
end

spam:RegisterHandler("healing", function (index, list)
	-- List of keys

	local total, overhealing, absorbed = 0, 0, 0

	local spellMaxs = ShowMaxHealingSpellAsIcon() and {}
	for args in ipairs(list) do
		if spellMaxs then
			if not spellMaxs[args.spellId] then spellMaxs[args.spellId] = 0 end
			spellMaxs[args.spellId] = math.max(spellMaxs[args.spellId], args.amount)
		end
		total = total + args.amount
		overhealing = overhealing + args.overhealing
		absorbed = absorbed + args.absorbed
	end

	if spellMaxs then
		local maxK, maxV = 0, 0
		for key, value in pairs(spellMaxs) do
			if maxV < value then
				maxV = value
				maxK = key
			end
		end
	else

	end
end)

