local addonName, addon = ...
local _G = _G

-- GLOBALS: ListFrame GameTooltip SLASH_AIO1 InterfaceOptionsFrame_OpenToCategory

-- Create an options panel and insert it into the interface menu
local OptionsPanel = CreateFrame('Frame', addonName .. 'Panel', InterfaceOptionsFramePanelContainer)
OptionsPanel:Hide()
OptionsPanel:SetAllPoints()
OptionsPanel.name = "CVar Browser"
OptionsPanel.parent = addonName

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

ListFrame.Bg:SetAlpha(0.8)

-- Events
local E = addon:Eve()
function E:PLAYER_LOGIN()
	wipe(CVarTable)
	for cvar, val in pairs(addon.hiddenOptions) do
		-- ["UnitNameOwn"] = { prettyName = "UNIT_NAME_OWN", description = "OPTION_TOOLTIP_UNIT_NAME_OWN", type = "boolean" },
		tinsert(CVarTable, {cvar, cvar, _G[val.description] or '', GetCVar(cvar) or ''})
		--print(cvar, GetCVarInfo(cvar))
	end
	ListFrame:SetItems(CVarTable)
	ListFrame:SortBy(2)

	ListFrame:SetScripts({
		OnEnter = function(self)
			if self.value ~= '' then
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
				local cvarTable = addon.hiddenOptions[self.value]
				local _, defaultValue = GetCVarInfo(self.value)
				if cvarTable['prettyName'] and _G[ cvarTable['prettyName'] ] then
					GameTooltip:AddLine(_G[ cvarTable['prettyName'] ], nil, nil, nil, false)
					GameTooltip:AddLine(" ")
				else
					GameTooltip:AddLine(self.value, nil, nil, nil, false)
					GameTooltip:AddLine(" ")
				end
				if cvarTable['description'] and _G[ cvarTable['description'] ] then
					GameTooltip:AddLine("|cFFFFFFFF" .. _G[ cvarTable['description'] ] .. "|r", nil, nil, nil, true)
					GameTooltip:AddDoubleLine("|cFF33FF99Default Value:|r", defaultValue, nil, nil, nil, false)
				else
					GameTooltip:AddDoubleLine("|cFF33FF99Default Value:|r", defaultValue, nil, nil, nil, false)
				end
				GameTooltip:Show()
			end
			self.bg:Show()
		end,
		OnLeave = function(self)
			GameTooltip:Hide()
			self.bg:Hide()
		end,
	})
end