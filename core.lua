
local addonName, addon = ...

local PLAYER_ENTERING_WORLD = function()
	for cvarName, cvarValue in pairs{addon.hiddenOptions} do
		SetCVar(cvarName, cvarValue)
	end
end



addon:RegisterEvent('PLAYER_ENTERING_WORLD', PLAYER_ENTERING_WORLD)