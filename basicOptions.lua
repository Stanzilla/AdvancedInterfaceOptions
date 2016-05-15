local addonName, addon = ...
local _G = _G
local L = AIO.L

-- GLOBALS: ListFrame GameTooltip SLASH_AIO1 InterfaceOptionsFrame_OpenToCategory

local AIO = CreateFrame('Frame', addonName .. 'Panel', InterfaceOptionsFramePanelContainer)
AIO:Hide()
AIO:SetAllPoints()
AIO.name = addonName

AIO:SetScript("OnShow", function(AIO)
local function newCheckbox(label, description, onClick)
	local check = CreateFrame("CheckButton", "AIOCheck" .. label, AIO, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		onClick(self, self:GetChecked() and true or false)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = label
	check.tooltipRequirement = description
	return check
end

local title = AIO:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(addonName)

local subText = AIO:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
subText:SetMaxLines(3)
subText:SetNonSpaceWrap(true)
subText:SetJustifyV('TOP')
subText:SetJustifyH('LEFT')
subText:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
subText:SetPoint('RIGHT', -32, 0)
subText:SetText('These options allow you to toggle various options that have been removed from the game in Legion.')

local playerName = newCheckbox(
	L["Your own name"],
	"UNIT_NAME_OWN",
	function(self, value) addon.hiddenOptions["UNIT_NAME_OWN"] = value end)
playerName:SetChecked(true) -- TODO
playerName:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)
end)

--[[
local info = {}
local fontSizeDropdown = CreateFrame("Frame", "BugSackFontSize", AIO, "UIDropDownMenuTemplate")
fontSizeDropdown:SetPoint("TOPLEFT", "BOTTOMLEFT", -15, -10)
fontSizeDropdown.initialize = function()
	wipe(info)
	local fonts = {"GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge"}
	local names = {L["Small"], L["Medium"], L["Large"], L["X-Large"]}
	for i, font in next, fonts do
		info.text = names[i]
		info.value = font
		info.func = function(self)

		end
		info.checked = font == addon.db.fontSize
		UIDropDownMenu_AddButton(info)
	end
end


local reset = CreateFrame("Button", "AIOResetButton", AIO, "UIPanelButtonTemplate")
reset:SetText(L["Reset to default"])
reset:SetWidth(177)
reset:SetHeight(24)
reset:SetPoint("TOPLEFT", fontSizeDropdown, "BOTTOMLEFT", 17, -25)
reset:SetScript("OnClick", function()
	addon:Reset()
end)
reset.tooltipText = L["Reset Advanced Interface Options to Blizzard defaults"]
reset.newbieText = L.wipeDesc

AIO:SetScript("OnShow", nil)
end)
]]--