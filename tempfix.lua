-- Temporary hack for Okay button overwriting our settings
-- Blocks the Okay button from being clicked on while our addon panels are active and
-- diverts clicks to the cancel button
local addonName = ...
local OkayGo = CreateFrame('Button', nil, InterfaceOptionsFrameOkay)
OkayGo:Hide()
OkayGo:SetAllPoints()

OkayGo:SetScript('OnEnter', function() InterfaceOptionsFrameOkay:LockHighlight() end)
OkayGo:SetScript('OnLeave', function() InterfaceOptionsFrameOkay:UnlockHighlight() end)
OkayGo:SetScript('OnMouseDown', function()
	InterfaceOptionsFrameOkay:SetButtonState('PUSHED', false)
end)
OkayGo:SetScript('OnMouseUp', function(self)
	InterfaceOptionsFrameOkay:SetButtonState('NORMAL', false)
	if MouseIsOver(self) then
		InterfaceOptionsFrameCancel:Click()
	end
end)

for k,f in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
	if f.name == addonName or f.parent == addonName then
		f:HookScript('OnShow', function() OkayGo:Show() end)
		f:HookScript('OnHide', function() OkayGo:Hide() end)
	end
end