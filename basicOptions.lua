local addonName, addon = ...
local _G = _G

-- GLOBALS: GameTooltip InterfaceOptionsFrame_OpenToCategory

local AIO = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO:Hide()
AIO:SetAllPoints()
AIO.name = addonName

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
		--print(GetCVarInfo(cvar) == '1' and 'Enabled after OnClick' or 'Disabled after OnClick')
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

local playerTitles = newCheckbox('UnitNamePlayerPVPTitle')
local playerGuilds = newCheckbox('UnitNamePlayerGuild')
local playerGuildTitles = newCheckbox('UnitNameGuildTitle')
local stopAutoAttack = newCheckbox('stopAutoAttackOnTargetChange')
local attackOnAssist = newCheckbox('assistAttack')
local autoSelfCast = newCheckbox('autoSelfCast')
local castOnKeyDown = newCheckbox('ActionButtonUseKeyDown')
local fadeMap = newCheckbox('mapFade')
local chatDelay = newCheckbox('removeChatDelay')
local secureToggle = newCheckbox('secureAbilityToggle')
local luaErrors = newCheckbox('scriptErrors')
local lootUnderMouse = newCheckbox('lootUnderMouse')
local targetDebuffFilter = newCheckbox('noBuffDebuffFilterOnTarget')

playerTitles:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -8)
playerGuilds:SetPoint("TOPLEFT", playerTitles, "BOTTOMLEFT", 0, -4)
playerGuildTitles:SetPoint("TOPLEFT", playerGuilds, "BOTTOMLEFT", 0, -4)
stopAutoAttack:SetPoint("TOPLEFT", playerGuildTitles, "BOTTOMLEFT", 0, -4)
attackOnAssist:SetPoint("TOPLEFT", stopAutoAttack, "BOTTOMLEFT", 0, -4)
autoSelfCast:SetPoint("TOPLEFT", attackOnAssist, "BOTTOMLEFT", 0, -4)
castOnKeyDown:SetPoint("TOPLEFT", autoSelfCast, "BOTTOMLEFT", 0, -4)
fadeMap:SetPoint("TOPLEFT", castOnKeyDown, "BOTTOMLEFT", 0, -4)
chatDelay:SetPoint("TOPLEFT", fadeMap, "BOTTOMLEFT", 0, -4)
secureToggle:SetPoint("TOPLEFT", chatDelay, "BOTTOMLEFT", 0, -4)
luaErrors:SetPoint("TOPLEFT", secureToggle, "BOTTOMLEFT", 0, -4)
lootUnderMouse:SetPoint("TOPLEFT", luaErrors, "BOTTOMLEFT", 0, -4)
targetDebuffFilter:SetPoint("TOPLEFT", lootUnderMouse, "BOTTOMLEFT", 0, -4)

-- TODO reducedLagTolerance maxSpellStartRecoveryOffset


InterfaceOptions_AddCategory(AIO, addonName)
