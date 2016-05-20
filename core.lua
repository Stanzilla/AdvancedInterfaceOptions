local addonName, addon = ...
local _G = _G

-- GLOBALS: ListFrame GameTooltip SLASH_AIO1 InterfaceOptionsFrame_OpenToCategory

SlashCmdList.AIO = function(msg)
	--msg = msg:lower()
	InterfaceOptionsFrame_OpenToCategory(addonName)
	InterfaceOptionsFrame_OpenToCategory(addonName)
end
SLASH_AIO1 = "/aio"
