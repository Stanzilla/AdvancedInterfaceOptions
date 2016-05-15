local addonName, addon = ...
local _G = _G

-- GLOBALS: ListFrame GameTooltip SLASH_AIO1 InterfaceOptionsFrame_OpenToCategory

local AIO = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO:Hide()
AIO:SetAllPoints()
AIO.name = addonName

AIO.okay = function()
	print(GetCVarInfo('unitnameown') == '1' and 'Enabled after Ok' or 'Disabled after Ok')
end
AIO.cancel = function()
	print(GetCVarInfo('unitnameown') == '1' and 'Enabled after Cancel' or 'Disabled after Cancel')
end
--local function newCheckbox(label, description, onClick)
local function newCheckbox(cvar)
	local cvarTable = addon.hiddenOptions[cvar]
	local label = _G[cvarTable['prettyName']] or cvar
	local description = _G[cvarTable['description']] or 'No description'
	local check = CreateFrame("CheckButton", "AIOCheck" .. label, AIO, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript('OnShow', function(self)
		self:SetChecked(GetCVarInfo(cvar) == '1')
	end)
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		SetCVar(cvar, self:GetChecked() and '1' or '0')
		print(GetCVarInfo(cvar) == '1' and 'Enabled after OnClick' or 'Disabled after OnClick')
		--onClick(self, self:GetChecked() and true or false)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = label
	check.tooltipRequirement = description
	return check
end

local title = AIO:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(AIO.name)

local subText = AIO:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
subText:SetMaxLines(3)
subText:SetNonSpaceWrap(true)
subText:SetJustifyV('TOP')
subText:SetJustifyH('LEFT')
subText:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
subText:SetPoint('RIGHT', -32, 0)
subText:SetText('These options allow you to toggle various options that have been removed from the game in Legion.')

local playerName = newCheckbox('UnitNameOwn')
--[[
	"Your Own Name", -- TODO Get prettyName from the hiddenOptions table
	"UNIT_NAME_OWN",
	function(self, value) addon.hiddenOptions["UNIT_NAME_OWN"] = value end)
	
playerName:SetChecked(true) -- TODO
--]]
playerName:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)


InterfaceOptions_AddCategory(AIO, addonName)
