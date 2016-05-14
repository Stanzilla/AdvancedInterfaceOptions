--------
-- Event handler
-- Usage: E = addon:Eve()
-- function E:ADDON_LOADED()
-- 	-- respond to ADDON_LOADED event
-- end
--------

-- todo: Should we treat function hooks like callbacks?
-- we can use debugstack to get the name of the file executing
-- our functions if we require an identifier

-- setmetatable({}, {__index = function(self, event) self[event] = {} return self[event] end})
local F, Events, A, T = CreateFrame('frame'), {}, ...

local function Raise(_, event, ...)
	if Events[event] then
		for module in pairs(Events[event]) do
			module[event](module, ...)
		end
	end
end

local function RegisterEvent(module, event, func)
	--if type(func) == 'function' then -- and not module[event]
	if func then
		rawset(module, event, func)
	end
	if not Events[event] then
		Events[event] = {}
	end
	Events[event][module] = true
	if strmatch(event, '^[%u_]+$') then
		F:RegisterEvent(event)
	end
	return module
end

local function UnregisterEvent(module, event)
	if Events[event] then
		Events[event][module] = nil
		if not next(Events[event]) and strmatch(event, '^[%u_]+$') then -- don't unregister unless the event table is empty
			F:UnregisterEvent(event)
		end
	end
	return module
end

local Module = {
	__newindex = RegisterEvent, -- function E:ADDON_LOADED() end
	__call = Raise, -- E('CallBack', ...) -- Fire a callback across ALL modules
	__index = {
		RegisterEvent = RegisterEvent, -- E:RegisterEvent('ADDON_LOADED', func)
		UnregisterEvent = UnregisterEvent, -- E:UnregisterEvent('ADDON_LOADED')
		Raise = Raise, -- E:Raise('CallBack', ...)
	},
}

T.Eve = setmetatable({}, {
	__call = function(eve)
		local module = setmetatable({}, Module)
		eve[ #eve + 1 ] = module
		return module
	end,
})

F:SetScript('OnEvent', Raise)