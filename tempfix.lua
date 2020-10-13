-- Temporary hack for Okay button overwriting our settings
-- Blocks the Okay button from being clicked on while our addon panels are active and
-- diverts clicks to the cancel button
local addonName, addon = ...
local E = addon:Eve()

-- Block mouse interaction with our interface panels in combat
local LockdownFrame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
LockdownFrame:Hide()
LockdownFrame:SetAllPoints()
LockdownFrame:EnableMouse(true)
LockdownFrame:SetFrameStrata('FULLSCREEN_DIALOG')

local LockdownBg = LockdownFrame:CreateTexture()
LockdownBg:SetAllPoints()
LockdownBg:SetColorTexture(0,0,0,0.6)

local LockdownText = LockdownFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalHugeOutline')
LockdownText:SetTextColor(1, 0, 0)
LockdownText:SetPoint('CENTER')
LockdownText:SetText("CAN'T MODIFY CVARS IN COMBAT")

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
	if MouseIsOver(self) and not InCombatLockdown() then
		--InterfaceOptionsFrame:Hide()
		HideUIPanel(InterfaceOptionsFrame)
		--InterfaceOptionsFrameCancel:Click() -- taints regardless of whether you're in combat
	end
end)

for k,f in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
	if f.name == addonName or f.parent == addonName then
		f:HookScript('OnShow', function()
			OkayGo:Show()
			if InCombatLockdown() then
				LockdownFrame:Show()
				OkayGo:EnableMouse(false)
			else
				OkayGo:EnableMouse(true)
			end
		end)
		f:HookScript('OnHide', function()
			OkayGo:Hide()
			LockdownFrame:Hide()
		end)
	end
end

function E:PLAYER_REGEN_DISABLED()
	if OkayGo:IsShown() then
		-- InterfaceOptionsFrameCancel:Click() -- this seems to taint even though it shouldn't
		OkayGo:EnableMouse(false)
		LockdownFrame:Show()
	end
end

function E:PLAYER_REGEN_ENABLED()
	OkayGo:EnableMouse(true)
	if LockdownFrame:IsShown() then
		LockdownFrame:Hide()
	end
end
