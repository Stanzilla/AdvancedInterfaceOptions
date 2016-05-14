local addonName, addon = ...

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

local tx = OptionsPanel:CreateTexture(nil, 'BACKGROUND')
tx:SetAllPoints()
tx:SetAlpha(0)
tx:SetTexture('interface/icons/inv_mushroom_11')


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
		print(cvar, GetCVarInfo(cvar))
	end
	ListFrame:SetItems(CVarTable)
	ListFrame:SortBy(2)
end

do return end

local AIO = CreateFrame('Frame', 'AIO')

local function argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end

local event_metatable = {
	__call = function(funcs, self, ...)
		for _, func in pairs(funcs) do
			func(self, ...)
		end
	end,
}

local RegisterEvent = AIO.RegisterEvent
function AIO:RegisterEvent(event, func)
	argcheck(event, 2, 'string')

	if(type(func) == 'string' and type(self[func]) == 'function') then
		func = self[func]
	end

	local curev = self[event]
	if(curev and func) then
		if(type(curev) == 'function') then
			self[event] = setmetatable({curev, func}, event_metatable)
		else
			for _, infunc in next, curev do
				if(infunc == func) then return end
			end

			table.insert(curev, func)
		end
	elseif(self:IsEventRegistered(event)) then
		return
	else
		if(func) then
			self[event] = func
		elseif(not self[event]) then
			error("Handler for event [%s] does not exist.", event)
		end

		RegisterEvent(self, event)
	end
end

local UnregisterEvent = AIO.UnregisterEvent
function AIO:UnregisterEvent(event, func)
	argcheck(event, 2, 'string')

	local curev = self[event]
	if(type(curev) == 'table' and func) then
		for k, infunc in pairs(curev) do
			if(infunc == func) then
				curev[k] = nil

				if(#curev == 0) then
					table.remove(curev, k)
					UnregisterEvent(self, event)
				end
			end
		end
	else
		self[event] = nil
		UnregisterEvent(self, event)
	end
end

AIO:SetScript('OnEvent', function(self, event, ...)
	self[event](self, event, ...)
end)

local PLAYER_ENTERING_WORLD = function()
	for cvarName, cvarValue in pairs{addon.hiddenOptions} do
		--SetCVar(cvarName, cvarValue)
		print(cvarName, cvarValue)
	end
end

AIO:RegisterEvent('PLAYER_ENTERING_WORLD', PLAYER_ENTERING_WORLD)