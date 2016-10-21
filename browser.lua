local addonName, addon = ...
local _G = _G

local SetCVar = function(cvar, value)
	addon:SetCVar(cvar, value)
end

-- GLOBALS: ListFrame GameTooltip SLASH_AIO1 InterfaceOptionsFrame_OpenToCategory SLASH_CVAR1

-- Create an options panel and insert it into the interface menu
local OptionsPanel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
OptionsPanel:Hide()
OptionsPanel:SetAllPoints()
OptionsPanel.name = "CVar Browser"
OptionsPanel.parent = addonName

local Title = OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title:SetJustifyV('TOP')
Title:SetJustifyH('LEFT')
Title:SetPoint('TOPLEFT', 16, -16)
Title:SetText(OptionsPanel.name)

local SubText = OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText:SetMaxLines(3)
SubText:SetNonSpaceWrap(true)
SubText:SetJustifyV('TOP')
SubText:SetJustifyH('LEFT')
SubText:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
SubText:SetPoint('RIGHT', -32, 0)
SubText:SetText('These options allow you to modify various CVars within the game.')

InterfaceOptions_AddCategory(OptionsPanel, addonName)

-- FilterBox should adjust the contents of the list frame based on the input text
-- todo: Display grey "Search" text in the box if it's empty
local FilterBox = CreateFrame('editbox', nil, OptionsPanel, 'InputBoxTemplate')
FilterBox:SetPoint('TOPLEFT', SubText, 'BOTTOMLEFT', 0, -5)
FilterBox:SetPoint('RIGHT', OptionsPanel, 'RIGHT', -10, 0)
FilterBox:SetHeight(20)
FilterBox:SetAutoFocus(false)
FilterBox:ClearFocus()
FilterBox:SetScript('OnEscapePressed', function(self)
	self:SetAutoFocus(false) -- Allow focus to clear when escape is pressed
	self:ClearFocus()
end)
FilterBox:SetScript('OnEditFocusGained', function(self)
	self:SetAutoFocus(true)
	self:HighlightText()
end)
--FilterBox:SetAutoFocus(true) -- should be the default state anyway

local CVarTable = {}
local ListFrame = addon:CreateListFrame(OptionsPanel, 615, 465, {{NAME, 200}, {'Description', 260, 'LEFT'}, {'Value', 100, 'RIGHT'}})
ListFrame:SetPoint('TOP', FilterBox, 'BOTTOM', 0, -20)
ListFrame:SetPoint('BOTTOMLEFT', 4, 6)
--ListFrame:SetPoint('BOTTOMRIGHT', -4, 6)
ListFrame:SetItems(CVarTable)

ListFrame.Bg:SetAlpha(0.8)

FilterBox:SetMaxLetters(100)

-- Escape special characters for matching a literal string
local function Literalize(str)
	return str:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]', '%%%1')
end
-- Rewrite text pattern to be case-insensitive
local function UnCase(c)
	return '[' .. strlower(c) .. strupper(c) .. ']'
end

local FilteredTable = {} -- Filtered version of CVarTable based on search box input

-- Filter displayed items based on value of FilterBox
local function FilterCVarList()
	local text = FilterBox:GetText()
	if text == '' then
		-- set to default list
		ListFrame:SetItems(CVarTable)
	else
		local pattern = Literalize(text):gsub('%a', UnCase)
		-- filter based on text
		wipe(FilteredTable)
		for i = 1, #CVarTable do
			local row = CVarTable[i]
			for j = 2, #row - 1 do -- start at 2 to skip the hidden value column, not sure if we should include every column in the filter or not
				local col = row[j]
				-- Color the search query, this is pretty inefficient
				local newtext, replacements = col:gsub(pattern, '|cffff0000%1|r')
				if replacements > 0 then
					local newrow = {row[1], [#row] = row[#row]}
					for k = 2, #row - 1 do
						newrow[k] = row[k]:gsub(pattern, '|cffff0000%1|r')
					end
					tinsert(FilteredTable, newrow)
					break
				--if col:lower():find(text, 1, true) then
					--tinsert(FilteredTable, row)
					--break
				end
			end
		end
		ListFrame:SetItems(FilteredTable)
	end
end

FilterBox:SetScript('OnTextChanged', FilterCVarList)

-- Returns a rounded integer or float, the default value, and whether it's set to its default value
local function GetPrettyCVar(cvar)
	local value, default = GetCVarInfo(cvar)
	--if not value then value = '|cff00ff00EROR' end
	--if not default then default = '|cff00ff00EROR' end
	if not default or not value then return '', false end -- this cvar doesn't exist
	local isFloat = strmatch(value or '', '^-?%d+%.%d+$')
	if isFloat then
		value = format('%.2f', value):gsub("%.?0+$", "")
	end

	local isDefault = tonumber(value) and tonumber(default) and (value - default == 0) or (value == default)
	return value, default, isDefault
end

-- Update CVarTable to reflect current values
local function RefreshCVarList()
	wipe(CVarTable)
	-- todo: this needs to be updated every time a cvar changes while the table is visible
	for cvar, tbl in pairs(addon.hiddenOptions) do
		local value, default, isDefault = GetPrettyCVar(cvar)
		tinsert(CVarTable, {cvar, cvar, tbl.description or '', isDefault and value or ('|cffff0000' .. value .. '|r')})
	end
	--ListFrame:SetItems(CVarTable)
end

local function FilteredRefresh()
	if ListFrame:IsVisible() then
		RefreshCVarList()
		FilterCVarList()
	end
end

ListFrame:HookScript('OnShow', FilteredRefresh)

-- Events
local E = addon:Eve()
local oSetCVar = SetCVar
function E:PLAYER_LOGIN()
	-- todo: this needs to be updated every time a cvar changes while the table is visible
	RefreshCVarList()
	ListFrame:SetItems(CVarTable)
	ListFrame:SortBy(2)
	--FilterCVarList()

	-- We don't really want the user to be able to do anything else while the input box is open
	-- I'd rather make this a child of the input box, but I can't get it to show up above its child
	-- todo: show default value around the input box somewhere while it's active
	local CVarInputBoxMouseBlocker = CreateFrame('frame', nil, ListFrame)
	CVarInputBoxMouseBlocker:SetFrameStrata('FULLSCREEN_DIALOG')
	CVarInputBoxMouseBlocker:Hide()

	local CVarInputBox = CreateFrame('editbox', nil, CVarInputBoxMouseBlocker, 'InputBoxTemplate')
	-- block clicking and cancel on any clicks outside the edit box
	CVarInputBoxMouseBlocker:EnableMouse(true)
	CVarInputBoxMouseBlocker:SetScript('OnMouseDown', function(self) CVarInputBox:ClearFocus() end)
	-- block scrolling
	CVarInputBoxMouseBlocker:EnableMouseWheel(true)
	CVarInputBoxMouseBlocker:SetScript('OnMouseWheel', function() end)
	CVarInputBoxMouseBlocker:SetAllPoints(nil)

	local blackout = CVarInputBoxMouseBlocker:CreateTexture(nil, 'BACKGROUND')
	blackout:SetAllPoints()
	blackout:SetColorTexture(0,0,0,0.2)

	CVarInputBox:Hide()
	CVarInputBox:SetSize(100, 20)
	CVarInputBox:SetJustifyH('RIGHT')
	CVarInputBox:SetTextInsets(5, 10, 0, 0)
	CVarInputBox:SetScript('OnEscapePressed', function(self)
		self:ClearFocus()
		self:Hide()
	end)

	CVarInputBox:SetScript('OnEnterPressed', function(self)
		-- todo: I don't like this, change it
		oSetCVar(self.cvar, self:GetText() or '')
		self:Hide()
		FilteredRefresh()
	end)
	--CVarInputBox:SetScript('OnShow', function(self)
		--self:SetFocus()
	--end)
	CVarInputBox:SetScript('OnHide', function(self)
		CVarInputBoxMouseBlocker:Hide()
		if self.str then
			self.str:Show()
		end
	end)
	CVarInputBox:SetScript('OnEditFocusLost', function(self)
		self:Hide()
		FilterBox:SetFocus()
	end)

	local LastClickTime = 0 -- Track double clicks on rows
	ListFrame:SetScripts({
		OnEnter = function(self)
			if self.value ~= '' then
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
				local cvarTable = addon.hiddenOptions[self.value]
				local _, defaultValue = GetCVarInfo(self.value)
				if cvarTable['prettyName'] then --and _G[ cvarTable['prettyName'] ] then
					GameTooltip:AddLine(cvarTable['prettyName'], nil, nil, nil, false)
					GameTooltip:AddLine(" ")
				else
					GameTooltip:AddLine(self.value, nil, nil, nil, false)
					GameTooltip:AddLine(" ")
				end
				if cvarTable['description'] then --and _G[ cvarTable['description'] ] then
					GameTooltip:AddLine("|cFFFFFFFF" .. cvarTable['description'] .. "|r", nil, nil, nil, true)
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
		OnMouseDown = function(self)
			local now = GetTime()
			if now - LastClickTime <= 0.2 then
				-- display edit box on row with current cvar value
				-- save on enter, discard on escape or losing focus
				if CVarInputBox.str then
					CVarInputBox.str:Show()
				end
				self.cols[#self.cols]:Hide()
				CVarInputBox.str = self.cols[#self.cols]
				CVarInputBox.cvar = self.value
				CVarInputBox.row = self
				CVarInputBox:SetPoint('RIGHT', self)
				local value = GetPrettyCVar(self.value)
				CVarInputBox:SetText(value or '')
				CVarInputBox:HighlightText()
				CVarInputBoxMouseBlocker:Show()
				CVarInputBox:Show()
				CVarInputBox:SetFocus()
			else
				LastClickTime = now
			end
		end,
	})
end

-- Update browser when a cvar is set while it's open
-- There are at least 4 different ways a cvar can be set:
--    /run SetCVar("cvar", value)
--    /console "cvar" value
--    /console SET "cvar" value (case doesn't matter)
--    Hitting ` and typing SET "cvar" into the console window itself
--    Console is not part of the interface, doesn't fire an event, and I'm not sure that we can hook it

-- These could be more efficient by not refreshing the entire list but that would be more work
hooksecurefunc('SetCVar', FilteredRefresh)

-- should we even bother checking what the console command did?
hooksecurefunc('ConsoleExec', FilteredRefresh)

SlashCmdList.CVAR = function()
	InterfaceOptionsFrame_OpenToCategory(OptionsPanel)
	InterfaceOptionsFrame_OpenToCategory(OptionsPanel)
end
SLASH_CVAR1 = "/cvar"