
local addonName, addon = ...
local AIO = CreateFrame('Frame', 'AIO')

local function argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end

local event_metatable = {
	__call = function(funcs, self, ...)
		for _, func in pairs(funcs) do
			func(self, ...)
		end
	end,
}

local RegisterEvent = AIO.RegisterEvent
function AIO:RegisterEvent(event, func)
	argcheck(event, 2, 'string')

	if(type(func) == 'string' and type(self[func]) == 'function') then
		func = self[func]
	end

	local curev = self[event]
	if(curev and func) then
		if(type(curev) == 'function') then
			self[event] = setmetatable({curev, func}, event_metatable)
		else
			for _, infunc in next, curev do
				if(infunc == func) then return end
			end

			table.insert(curev, func)
		end
	elseif(self:IsEventRegistered(event)) then
		return
	else
		if(func) then
			self[event] = func
		elseif(not self[event]) then
			error("Handler for event [%s] does not exist.", event)
		end

		RegisterEvent(self, event)
	end
end

local UnregisterEvent = AIO.UnregisterEvent
function AIO:UnregisterEvent(event, func)
	argcheck(event, 2, 'string')

	local curev = self[event]
	if(type(curev) == 'table' and func) then
		for k, infunc in pairs(curev) do
			if(infunc == func) then
				curev[k] = nil

				if(#curev == 0) then
					table.remove(curev, k)
					UnregisterEvent(self, event)
				end
			end
		end
	else
		self[event] = nil
		UnregisterEvent(self, event)
	end
end

AIO:SetScript('OnEvent', function(self, event, ...)
	self[event](self, event, ...)
end)

local PLAYER_ENTERING_WORLD = function()
	for cvarName, cvarValue in pairs{addon.hiddenOptions} do
		--SetCVar(cvarName, cvarValue)
		print(cvarName, cvarValue)
	end
end

AIO:RegisterEvent('PLAYER_ENTERING_WORLD', PLAYER_ENTERING_WORLD)