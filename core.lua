local addonName, addon = ...
local _G = _G

-- GLOBALS: ListFrame

-- Create an options panel and insert it into the interface menu
local OptionsPanel = CreateFrame('Frame', addonName .. 'Panel', InterfaceOptionsFramePanelContainer)
OptionsPanel:Hide()
OptionsPanel:SetAllPoints()
OptionsPanel.name = addonName

local Title = OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title:SetJustifyV('TOP')
Title:SetJustifyH('LEFT')
Title:SetPoint('TOPLEFT', 16, -16)
Title:SetText(addonName)

local SubText = OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText:SetMaxLines(3)
SubText:SetNonSpaceWrap(true)
SubText:SetJustifyV('TOP')
SubText:SetJustifyH('LEFT')
SubText:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
SubText:SetPoint('RIGHT', -32, 0)
SubText:SetText('These options allow you to modify various CVars within the game.')

InterfaceOptions_AddCategory(OptionsPanel, addonName)

local CVarTable = {}
local ListFrame = addon:CreateListFrame(OptionsPanel, 615, 450, {{NAME, 200}, {'Description', 260, 'RIGHT'}, {'Value', 100, 'RIGHT'}})
--ListFrame:SetPoint('TOP', SubText, 'BOTTOM', 0, -40)
ListFrame:SetPoint('BOTTOMLEFT', 4, 6)
--ListFrame:SetPoint('BOTTOMRIGHT', -4, 6)
ListFrame:SetItems(CVarTable)

-- Events
local E = addon:Eve()
function E:PLAYER_ENTERING_WORLD()
	wipe(CVarTable)
	for cvar, val in pairs(addon.hiddenOptions) do
		-- ["UnitNameOwn"] = { prettyName = "UNIT_NAME_OWN", description = "OPTION_TOOLTIP_UNIT_NAME_OWN", type = "boolean" },
		tinsert(CVarTable, {cvar, cvar, _G[val.description] or '', GetCVar(cvar) or ''})
		--print(cvar, GetCVarInfo(cvar))
	end
	ListFrame:SetItems(CVarTable)
	ListFrame:SortBy(2)
end
