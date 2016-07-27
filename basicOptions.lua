local addonName, addon = ...
local E = addon:Eve()
local _G = _G

-- GLOBALS: GameTooltip InterfaceOptionsFrame_OpenToCategory
-- GLOBALS: GetSortBagsRightToLeft SetSortBagsRightToLeft GetInsertItemsLeftToRight SetInsertItemsLeftToRight
-- GLOBALS: UIDropDownMenu_AddButton UIDropDownMenu_CreateInfo UIDropDownMenu_SetSelectedValue
-- GLOBALS: SLASH_AIO1 InterfaceOptionsFrame DEFAULT_CHAT_FRAME

local AIO = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO:Hide()
AIO:SetAllPoints()
AIO.name = addonName

-- Some wrapper functions

-------------
-- Checkbox
-------------
local function checkboxGetCVar(self) return GetCVarBool(self.cvar) end
local function checkboxSetChecked(self) self:SetChecked(self:GetValue()) end
local function checkboxSetCVar(self, checked) SetCVar(self.cvar, checked) end
local function checkboxOnClick(self)
	local checked = self:GetChecked()
	PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
	self:SetValue(checked)
end

local function newCheckbox(parent, cvar, getValue, setValue)
	local cvarTable = addon.hiddenOptions[cvar]
	local label = cvarTable['prettyName'] or cvar
	local description = _G[cvarTable['description']] or cvarTable['description'] or 'No description'
	local check = CreateFrame("CheckButton", "AIOCheck" .. label, parent, "InterfaceOptionsCheckButtonTemplate")

	check.cvar = cvar
	check.GetValue = getValue or checkboxGetCVar
	check.SetValue = setValue or checkboxSetCVar
	check:SetScript('OnShow', checkboxSetChecked)
	check:SetScript("OnClick", checkboxOnClick)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = label
	check.tooltipRequirement = description
	return check
end

-----------
-- Slider
-----------
local function sliderGetCVar(self) return GetCVar(self.cvar) end
local function sliderRefresh(self) self:SetValue(self:GetCVarValue()) end
local function sliderSetCVar(self, checked) SetCVar(self.cvar, checked) end

local function newSlider(parent, cvar, minRange, maxRange, stepSize, getValue, setValue)
	local cvarTable = addon.hiddenOptions[cvar]
	local label = cvarTable['prettyName'] or cvar
	local description = cvarTable['description'] or 'No description'
	local slider = CreateFrame('Slider', 'AIOSlider' .. cvar, parent, 'OptionsSliderTemplate')

	slider.cvar = cvar
	slider.GetCVarValue = getValue or sliderGetCVar
	slider.SetCVarValue = setValue or sliderSetCVar
	slider:SetScript('OnShow', sliderRefresh)
	slider:SetValueStep(stepSize or 1)
	slider:SetObeyStepOnDrag(true)

	slider:SetMinMaxValues(minRange, maxRange)
	slider.minText = _G[slider:GetName() .. 'Low']
	slider.maxText = _G[slider:GetName() .. 'High']
	slider.minText:SetText(minRange)
	slider.maxText:SetText(maxRange)
	_G[slider:GetName() .. 'Text']:SetText(label)

	local valueText = slider:CreateFontString(nil, nil, 'GameFontHighlight')
	valueText:SetPoint('TOP', slider, 'BOTTOM', 0, -5)
	slider.valueText = valueText
	slider:HookScript('OnValueChanged', function(self, value)
		valueText:SetText(value)
	end)

	slider:HookScript('OnValueChanged', slider.SetCVarValue)

	slider.tooltipText = label
	slider.tooltipRequirement = description
	return slider
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

local playerTitles = newCheckbox(AIO, 'UnitNamePlayerPVPTitle')
local playerGuilds = newCheckbox(AIO, 'UnitNamePlayerGuild')
local playerGuildTitles = newCheckbox(AIO, 'UnitNameGuildTitle')
local stopAutoAttack = newCheckbox(AIO, 'stopAutoAttackOnTargetChange')
local attackOnAssist = newCheckbox(AIO, 'assistAttack')
local castOnKeyDown = newCheckbox(AIO, 'ActionButtonUseKeyDown')
local fadeMap = newCheckbox(AIO, 'mapFade')
local secureToggle = newCheckbox(AIO, 'secureAbilityToggle')
local luaErrors = newCheckbox(AIO, 'scriptErrors')
local targetDebuffFilter = newCheckbox(AIO, 'noBuffDebuffFilterOnTarget')
local reverseCleanupBags = newCheckbox(AIO, 'reverseCleanupBags',
	-- Get Value
	function(self)
		return GetSortBagsRightToLeft()
	end,
	-- Set Value
	function(self, checked)
		SetSortBagsRightToLeft(checked)
	end
)
local lootLeftmostBag = newCheckbox(AIO, 'lootLeftmostBag',
	-- Get Value
	function(self)
		return GetInsertItemsLeftToRight()
	end,
	-- Set Value
	function(self, checked)
		SetInsertItemsLeftToRight(checked)
	end
)
local enableWoWMouse = newCheckbox(AIO, 'enableWoWMouse')

local questSortingLabel = AIO:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
questSortingLabel:SetPoint('TOPLEFT', enableWoWMouse, 'BOTTOMLEFT', 0, 0)
questSortingLabel:SetText('Select quest sorting mode:')

local questSortingDropdown = CreateFrame("Frame", "AIOQuestSorting", AIO, "UIDropDownMenuTemplate")
questSortingDropdown:SetPoint("TOPLEFT", questSortingLabel, "BOTTOMLEFT", -16, -10)
questSortingDropdown.initialize = function(dropdown)
	local sortMode = { "top", "proximity" }
	for i, mode in next, sortMode do
		local info = UIDropDownMenu_CreateInfo()
		info.text = sortMode[i]
		info.value = sortMode[i]
		info.func = function(self)
			SetCVar("trackQuestSorting", self.value)
			UIDropDownMenu_SetSelectedValue(dropdown, self.value)
		end
		UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetSelectedValue(dropdown, (GetCVarInfo("trackQuestSorting")))
end
questSortingDropdown:HookScript("OnShow", questSortingDropdown.initialize)
questSortingDropdown:HookScript("OnEnter", function(self)
	if not self.isDisabled then
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(_G["OPTION_TOOLTIP_TRACK_QUEST_"..strupper(self.selectedValue)], nil, nil, nil, nil, true)
	end
end)
questSortingDropdown:HookScript("OnLeave", GameTooltip_Hide)

local actionCamModeLabel = AIO:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
actionCamModeLabel:SetPoint('TOPLEFT', questSortingDropdown, 'BOTTOMLEFT', 16, 0)
actionCamModeLabel:SetText('Select Action Cam mode:')

local actionCamModeDropdown = CreateFrame("Frame", "AIOActionCamMode", AIO, "UIDropDownMenuTemplate")
actionCamModeDropdown:SetPoint("TOPLEFT", actionCamModeLabel, "BOTTOMLEFT", -16, -10)
actionCamModeDropdown.initialize = function(dropdown)
	local sortMode = { "basic", "full", "off", "default" }
	for i, mode in next, sortMode do
		local info = UIDropDownMenu_CreateInfo()
		info.text = sortMode[i]
		info.value = sortMode[i]
		info.func = function(self)
			ConsoleExec("actioncam "..self.value)
			UIDropDownMenu_SetSelectedValue(dropdown, self.value)
		end
		UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetSelectedValue(dropdown, "off") -- TODO: This is wrong, obviously
end
actionCamModeDropdown:HookScript("OnShow", actionCamModeDropdown.initialize)

playerTitles:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -8)
playerGuilds:SetPoint("TOPLEFT", playerTitles, "BOTTOMLEFT", 0, -4)
playerGuildTitles:SetPoint("TOPLEFT", playerGuilds, "BOTTOMLEFT", 0, -4)
stopAutoAttack:SetPoint("TOPLEFT", playerGuildTitles, "BOTTOMLEFT", 0, -4)
attackOnAssist:SetPoint("TOPLEFT", stopAutoAttack, "BOTTOMLEFT", 0, -4)
castOnKeyDown:SetPoint("TOPLEFT", attackOnAssist, "BOTTOMLEFT", 0, -4)
fadeMap:SetPoint("TOPLEFT", castOnKeyDown, "BOTTOMLEFT", 0, -4)
secureToggle:SetPoint("TOPLEFT", fadeMap, "BOTTOMLEFT", 0, -4)
luaErrors:SetPoint("TOPLEFT", secureToggle, "BOTTOMLEFT", 0, -4)
targetDebuffFilter:SetPoint("TOPLEFT", luaErrors, "BOTTOMLEFT", 0, -4)
reverseCleanupBags:SetPoint("TOPLEFT", targetDebuffFilter, "BOTTOMLEFT", 0, -4)
lootLeftmostBag:SetPoint("TOPLEFT", reverseCleanupBags, "BOTTOMLEFT", 0, -4)
enableWoWMouse:SetPoint("TOPLEFT", lootLeftmostBag, "BOTTOMLEFT", 0, -4)

-- TODO reducedLagTolerance maxSpellStartRecoveryOffset


-- Chat settings
local AIO_Chat = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_Chat:Hide()
AIO_Chat:SetAllPoints()
AIO_Chat.name = "Chat"
AIO_Chat.parent = addonName

local Title_Chat = AIO_Chat:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_Chat:SetJustifyV('TOP')
Title_Chat:SetJustifyH('LEFT')
Title_Chat:SetPoint('TOPLEFT', 16, -16)
Title_Chat:SetText(AIO_Chat.name)

local SubText_Chat = AIO_Chat:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_Chat:SetMaxLines(3)
SubText_Chat:SetNonSpaceWrap(true)
SubText_Chat:SetJustifyV('TOP')
SubText_Chat:SetJustifyH('LEFT')
SubText_Chat:SetPoint('TOPLEFT', Title_Chat, 'BOTTOMLEFT', 0, -8)
SubText_Chat:SetPoint('RIGHT', -32, 0)
SubText_Chat:SetText('These options allow you to modify chat settings.') -- TODO

local chatMouseScroll = newCheckbox(AIO_Chat, 'chatMouseScroll')
local chatDelay = newCheckbox(AIO_Chat, 'removeChatDelay')

chatDelay:SetPoint('TOPLEFT', SubText_Chat, 'BOTTOMLEFT', 0, -8)
chatMouseScroll:SetPoint('TOPLEFT', chatDelay, 'BOTTOMLEFT', 0, -4)


-- Floating Combat Text settings
local AIO_FCT = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_FCT:Hide()
AIO_FCT:SetAllPoints()
AIO_FCT.name = "Floating Combat Text"
AIO_FCT.parent = addonName

local Title_FCT = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_FCT:SetJustifyV('TOP')
Title_FCT:SetJustifyH('LEFT')
Title_FCT:SetPoint('TOPLEFT', 16, -16)
Title_FCT:SetText(AIO_FCT.name)

local SubText_FCT = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_FCT:SetMaxLines(3)
SubText_FCT:SetNonSpaceWrap(true)
SubText_FCT:SetJustifyV('TOP')
SubText_FCT:SetJustifyH('LEFT')
SubText_FCT:SetPoint('TOPLEFT', Title_FCT, 'BOTTOMLEFT', 0, -8)
SubText_FCT:SetPoint('RIGHT', -32, 0)
SubText_FCT:SetText(COMBATTEXT_SUBTEXT)

local fctfloatmodeDropdown = CreateFrame("Frame", "AIOfctFloatMode", AIO_FCT, "UIDropDownMenuTemplate")
fctfloatmodeDropdown.initialize = function(dropdown)
	local floatMode = { COMBAT_TEXT_SCROLL_UP, COMBAT_TEXT_SCROLL_DOWN, COMBAT_TEXT_SCROLL_ARC }
	for i, mode in next, floatMode do
		local info = UIDropDownMenu_CreateInfo()
		info.text = floatMode[i]
		info.value = tostring(i)
		info.func = function(self)
			SetCVar("floatingCombatTextFloatMode", self.value)
			UIDropDownMenu_SetSelectedValue(dropdown, self.value)
		end
		UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetSelectedValue(dropdown, GetCVar("floatingCombatTextFloatMode"))
end
fctfloatmodeDropdown:HookScript("OnShow", fctfloatmodeDropdown.initialize)
fctfloatmodeDropdown:HookScript("OnEnter", function(self)
	if not self.isDisabled then
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(OPTION_TOOLTIP_COMBAT_TEXT_MODE, nil, nil, nil, nil, true)
	end
end)
fctfloatmodeDropdown:HookScript("OnLeave", GameTooltip_Hide)

local fctAbsorbTarget = newCheckbox(AIO_FCT, 'floatingCombatTextCombatHealingAbsorbTarget')
local fctDamage = newCheckbox(AIO_FCT, 'floatingCombatTextCombatDamage')
local fctDirectionalScale = newCheckbox(AIO_FCT, 'floatingCombatTextCombatDamageDirectionalScale')
local fctHealing = newCheckbox(AIO_FCT, 'floatingCombatTextCombatHealing')
local fctPetMeleeDamage = newCheckbox(AIO_FCT, 'floatingCombatTextPetMeleeDamage')
local fctSpellMechanics = newCheckbox(AIO_FCT, 'floatingCombatTextSpellMechanics')
local fctSpellMechanicsOther = newCheckbox(AIO_FCT, 'floatingCombatTextSpellMechanicsOther')

local enablefct = newCheckbox(AIO_FCT, 'enableFloatingCombatText')
local fctAbsorbSelf = newCheckbox(AIO_FCT, 'floatingCombatTextCombatHealingAbsorbSelf')
local fctAuras = newCheckbox(AIO_FCT, 'floatingCombatTextAuras')
local fctCombatState = newCheckbox(AIO_FCT, 'floatingCombatTextCombatState')
local fctComboPoints = newCheckbox(AIO_FCT, 'floatingCombatTextComboPoints')
local fctDamageReduction = newCheckbox(AIO_FCT, 'floatingCombatTextDamageReduction')
local fctDodgeParryMiss = newCheckbox(AIO_FCT, 'floatingCombatTextDodgeParryMiss')
local fctEnergyGains = newCheckbox(AIO_FCT, 'floatingCombatTextEnergyGains')
local fctFriendlyHealer = newCheckbox(AIO_FCT, 'floatingCombatTextFriendlyHealers')
local fctHonorGains = newCheckbox(AIO_FCT, 'floatingCombatTextHonorGains')
local fctLowHPMana = newCheckbox(AIO_FCT, 'floatingCombatTextLowManaHealth')
local fctPeriodicEnergyGains = newCheckbox(AIO_FCT, 'floatingCombatTextPeriodicEnergyGains')
local fctPeriodicSpells = newCheckbox(AIO_FCT, 'floatingCombatTextCombatLogPeriodicSpells')
local fctReactives = newCheckbox(AIO_FCT, 'floatingCombatTextReactives')
local fctRepChanges = newCheckbox(AIO_FCT, 'floatingCombatTextRepChanges')

local fctTargetLabel = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
fctTargetLabel:SetText(FLOATING_COMBAT_TARGET_LABEL)
fctTargetLabel:SetPoint('TOPLEFT', SubText_FCT, 'BOTTOMLEFT', 0, -25)

fctDamage:SetPoint("TOPLEFT", fctTargetLabel, "BOTTOMLEFT", 0, -6)
fctPeriodicSpells:SetPoint("TOPLEFT", fctDamage, "BOTTOMLEFT", 10, 0)
fctPetMeleeDamage:SetPoint("TOPLEFT", fctPeriodicSpells, "BOTTOMLEFT", 0, 0)
fctDirectionalScale:SetPoint("TOPLEFT", fctPetMeleeDamage, "BOTTOMLEFT", 0, 0)
fctHealing:SetPoint("TOPLEFT", fctDirectionalScale, "BOTTOMLEFT", -10, -6)
fctAbsorbTarget:SetPoint("TOPLEFT", fctHealing, "BOTTOMLEFT", 10, 0)

fctSpellMechanics:SetPoint("TOPLEFT", fctDamage, "TOPRIGHT", 260, 0)
fctSpellMechanicsOther:SetPoint("TOPLEFT", fctSpellMechanics, "BOTTOMLEFT", 10, -4)

local fctSelfLabel = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
fctSelfLabel:SetText(FLOATING_COMBAT_SELF_LABEL)
fctSelfLabel:SetPoint('TOPLEFT', fctAbsorbTarget, 'BOTTOMLEFT', -10, -25)

enablefct:SetPoint("TOPLEFT", fctSelfLabel, "BOTTOMLEFT", 0, -4)
fctfloatmodeDropdown:SetPoint("TOPLEFT", enablefct, "BOTTOMLEFT", -4, 0)
fctDodgeParryMiss:SetPoint("TOPLEFT", enablefct, "BOTTOMLEFT", 10, -32)
fctDamageReduction:SetPoint("TOPLEFT", fctDodgeParryMiss, "BOTTOMLEFT", 0, -4)
fctRepChanges:SetPoint("TOPLEFT", fctDamageReduction, "BOTTOMLEFT", 0, -4)
fctReactives:SetPoint("TOPLEFT", fctRepChanges, "BOTTOMLEFT", 0, -4)
fctFriendlyHealer:SetPoint("TOPLEFT", fctReactives, "BOTTOMLEFT", 0, -4)
fctCombatState:SetPoint("TOPLEFT", fctFriendlyHealer, "BOTTOMLEFT", 0, -4)

fctAbsorbSelf:SetPoint("TOPLEFT", fctDodgeParryMiss, "TOPRIGHT", 260, 0)
fctLowHPMana:SetPoint("TOPLEFT", fctAbsorbSelf, "BOTTOMLEFT", 0, -4)
fctEnergyGains:SetPoint("TOPLEFT", fctLowHPMana, "BOTTOMLEFT", 0, -4)
fctPeriodicEnergyGains:SetPoint("TOPLEFT", fctEnergyGains, "BOTTOMLEFT", 0, -4)
fctHonorGains:SetPoint("TOPLEFT", fctPeriodicEnergyGains, "BOTTOMLEFT", 0, -4)
fctAuras:SetPoint("TOPLEFT", fctHonorGains, "BOTTOMLEFT", 0, -4)

-- Nameplate settings
local AIO_NP = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_NP:Hide()
AIO_NP:SetAllPoints()
AIO_NP.name = "Nameplates"
AIO_NP.parent = addonName

local Title_NP = AIO_NP:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_NP:SetJustifyV('TOP')
Title_NP:SetJustifyH('LEFT')
Title_NP:SetPoint('TOPLEFT', 16, -16)
Title_NP:SetText(AIO_NP.name)

local SubText_NP = AIO_NP:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_NP:SetMaxLines(3)
SubText_NP:SetNonSpaceWrap(true)
SubText_NP:SetJustifyV('TOP')
SubText_NP:SetJustifyH('LEFT')
SubText_NP:SetPoint('TOPLEFT', Title_NP, 'BOTTOMLEFT', 0, -8)
SubText_NP:SetPoint('RIGHT', -32, 0)
SubText_NP:SetText('These options allow you to modify Nameplate Options.')

local nameplateDistance = newSlider(AIO_NP, 'nameplateMaxDistance', 10, 60)
nameplateDistance:SetPoint('TOPLEFT', SubText_NP, 'BOTTOMLEFT', 0, -20)

local nameplateAtBase = newCheckbox(AIO_NP, 'nameplateOtherAtBase')
nameplateAtBase:SetPoint("TOPLEFT", nameplateDistance, "BOTTOMLEFT", 0, -16)
nameplateAtBase:SetScript('OnClick', function(self)
	local checked = self:GetChecked()
	PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
	self:SetValue(checked and 2 or 0)
end)


-- Hook up options to addon panel
InterfaceOptions_AddCategory(AIO, addonName)
InterfaceOptions_AddCategory(AIO_Chat, addonName)
InterfaceOptions_AddCategory(AIO_FCT, addonName)
InterfaceOptions_AddCategory(AIO_NP, addonName)


function E:PLAYER_REGEN_DISABLED()
	if AIO:IsVisible() then
		--InterfaceOptionsFrame_Show()
		InterfaceOptionsFrame:Hide()
	end
end

-- Slash handler
SlashCmdList.AIO = function(msg)
	--msg = msg:lower()
	if not InCombatLockdown() then
		InterfaceOptionsFrame_OpenToCategory(addonName)
		InterfaceOptionsFrame_OpenToCategory(addonName)
	else
		DEFAULT_CHAT_FRAME:AddMessage(format("%s: Can't modify interface options in combat", addonName))
	end
end
SLASH_AIO1 = "/aio"
