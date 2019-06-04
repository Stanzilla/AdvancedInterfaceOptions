local addonName, addon = ...

function addon:CreateString(parent, text, width, justify)
	local str = parent:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
	str:SetText(text)
	str:SetWordWrap(false) -- hacky bit to truncate string without elipsis
	str:SetNonSpaceWrap(true)
	str:SetHeight(10)
	str:SetMaxLines(2)
	if width then str:SetWidth(width) end
	if justify then str:SetJustifyH(justify) end
	return str
end

-- Scroll frame
local function updatescroll(scroll)
	for line = 1, scroll.slots do
		local lineoffset = line + scroll.value
		if lineoffset <= scroll.itemcount then
			-- If we're mousing over a row when its contents change
			-- call its OnLeave/OnEnter scripts if they exist
			local mousedOver = scroll.slot[line]:IsMouseOver()
			if mousedOver then
				local OnLeave = scroll.slot[line]:GetScript('OnLeave')
				if OnLeave then
					OnLeave(scroll.slot[line])
				end
			end

			scroll.slot[line].value = scroll.items[lineoffset][1]
			scroll.slot[line].offset = lineoffset
			--local text = scroll.items[lineoffset][2]
			--if(scroll.slot[line].value == scroll.selected) then
				--text = "|cffff0000"..text.."|r"
			--end
			--scroll.slot[line].text:SetText(text)
			for i, col in ipairs(scroll.slot[line].cols) do
				col.item = scroll.items[lineoffset][i+1]
				col:SetText(scroll.items[lineoffset][i+1])
				col.id = i
			end

			if mousedOver then
				local OnEnter = scroll.slot[line]:GetScript('OnEnter')
				if OnEnter then
					OnEnter(scroll.slot[line])
				end
			end
			--scroll.slot[line].cols[2]:SetText(text)
			scroll.slot[line]:Show()
		else
			--scroll.slot[line].cols[2]:SetText("")
			scroll.slot[line].value = nil
			scroll.slot[line]:Hide()
		end
	end

	--scroll.scrollbar:SetValue(scroll.value)
end

local function scrollscripts(scroll, scripts)
	for k,v in pairs(scripts) do
		scroll.scripts[k] = v
	end
	for line = 1, scroll.slots do
		for k,v in pairs(scroll.scripts) do
			scroll.slot[line]:SetScript(k,v)
		end
	end
end

local function selectscrollitem(scroll, value)
	scroll.selected = value
	scroll:Update()
end

local function normalize(str)
	str = str and gsub(str, '|c........', '') or ''
	return str:gsub('(%d+)', function(d)
		local lenf = strlen(d)
		return lenf < 10 and (strsub('0000000000', lenf + 1) .. d) or d -- or ''
		--return (d + 0) < 2147483648 and string.format('%010d', d) or d -- possible integer overflow
	end):gsub('%W', ''):lower()
end

local function sortItems(scroll, col)
	-- todo: Keep items sorted when :Update() is called
	-- todo: Show a direction icon on the sorted column
	-- Force it in one direction if we're sorting a different column than was previously sorted
	if not col then
		if scroll.sortCol then
			col = scroll.sortCol
			if scroll.sortUp then
				table.sort(scroll.items, function(a, b)
					local x, y = normalize(a[col]), normalize(b[col])
					if x ~= y then
						return x < y
					else
						return a[1] < b[1]
					end
				end)
			else
				table.sort(scroll.items, function(a, b)
					local x, y = normalize(a[col]), normalize(b[col])
					if x ~= y then
						return x > y
					else
						return a[1] > b[1]
					end
				end)
			end
		end
	else
		if col ~= scroll.sortCol then
			scroll.sortUp = nil
			scroll.sortCol = col
		end
		if scroll.sortUp then
			table.sort(scroll.items, function(a, b)
				local x, y = normalize(a[col]), normalize(b[col])
				if x ~= y then
					return x > y
				else
					return normalize(a[1]) > normalize(b[1])
				end
			end)
			scroll.sortUp = false
		else
			table.sort(scroll.items, function(a, b)
				local x, y = normalize(a[col]), normalize(b[col])
				if x ~= y then
					return x < y
				else
					return normalize(a[1]) < normalize(b[1])
				end
			end)
			scroll.sortUp = true
		end
	end
	scroll:Update()
end

local function setscrolllist(scroll, items)
	scroll.items = items
	scroll.itemcount = #items
	scroll.stepValue = min(ceil(scroll.slots / 2), max(floor(scroll.itemcount / scroll.slots), 1))
	scroll.maxValue = max(scroll.itemcount - scroll.slots, 0)
	--scroll.value = scroll.minValue
	scroll.value = scroll.value <= scroll.maxValue and scroll.value or scroll.maxValue

	scroll.scrollbar:SetMinMaxValues(0, scroll.maxValue)
	scroll.scrollbar:SetValue(scroll.value)
	scroll.scrollbar:SetValueStep(scroll.stepValue)

	sortItems(scroll)

	scroll:Update()
end



local function scroll(self, arg1)
	-- Called when mousewheel is scrolled or scroll buttons are pressed
	local oldValue = self.value
	if ( self.maxValue > self.minValue ) then
		if ( self.value > self.minValue and self.value < self.maxValue )
		or ( self.value == self.minValue and arg1 == -1 )
		or ( self.value == self.maxValue and arg1 == 1 ) then
			local newval = self.value - arg1 * self.stepValue
			if ( newval <= self.maxValue and newval >= self.minValue ) then
				self.value = newval
			elseif ( newval > self.maxValue ) then
				self.value = self.maxValue
			elseif ( newval < self.minValue ) then
				self.value = self.minValue
			end
		elseif ( self.value < self.minValue ) then
			self.value = self.minValue
		elseif ( self.value > self.maxValue ) then
			self.value = self.maxValue
		end

		if self.value ~= oldValue then
			self:Update() -- probably does not need to be called unless value has changed
		end
	end
	if oldValue ~= self.value then
		self.scrollbar:SetValue(self.value)
	end
end

function addon:CreateListFrame(parent, w, h, cols)
	-- Contents of the list frame should be completely contained within the outer frame
	local frame = CreateFrame('Frame', nil, parent, 'InsetFrameTemplate')

	local inset = CreateFrame('Frame', nil, frame, 'InsetFrameTemplate')


	frame:SetSize(w, h)
	frame:SetFrameLevel(1)

	frame.scripts = {
		--["OnMouseDown"] = function(self) print(self.text:GetText()) end
	}
	frame.selected = nil
	frame.items = {}
	frame.itemcount = 0
	frame.minValue = 0
	frame.itemheight = 15 -- todo: base this on font size
	frame.slots = floor((frame:GetHeight()-10)/frame.itemheight)
	frame.slot = {}
	frame.stepValue = min(frame.slots, max(floor(frame.itemcount / frame.slots), 1))
	frame.maxValue = max(frame.itemcount - frame.slots, 0)
	frame.value = frame.minValue

	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", scroll)

	frame.Update = updatescroll
	frame.SetItems = setscrolllist
	frame.SortBy = sortItems
	frame.SetScripts = scrollscripts

	-- scrollbar
	local scrollUpBg = frame:CreateTexture(nil, nil, 1)
	scrollUpBg:SetTexture([[Interface\ClassTrainerFrame\UI-ClassTrainer-ScrollBar]])
	scrollUpBg:SetPoint('TOPRIGHT', 0, -2)--TOPLEFT', scrollbar, 'TOPRIGHT', -3, 2)
	scrollUpBg:SetTexCoord(0, 0.46875, 0.0234375, 0.9609375)
	scrollUpBg:SetSize(30, 120)


	local scrollDownBg = frame:CreateTexture(nil, nil, 1)
	scrollDownBg:SetTexture([[Interface\ClassTrainerFrame\UI-ClassTrainer-ScrollBar]])
	scrollDownBg:SetPoint('BOTTOMRIGHT', 0, 1)
	scrollDownBg:SetTexCoord(0.53125, 1, 0.03125, 1)
	scrollDownBg:SetSize(30, 123)
	--scrollDownBg:SetAlpha(0)


	local scrollMidBg = frame:CreateTexture(nil, nil, 2) -- fill in the middle gap, a bit hacky
	scrollMidBg:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]], false, true)
	--scrollMidBg:SetPoint('RIGHT', -1, 0)
	scrollMidBg:SetTexCoord(0, 0.44, 0.75, 0.98)
	--scrollMidBg:SetSize(28, 80)
	--scrollMidBg:SetWidth(28)
	scrollMidBg:SetPoint('TOPLEFT', scrollUpBg, 'BOTTOMLEFT', 1, 2)
	scrollMidBg:SetPoint('BOTTOMRIGHT', scrollDownBg, 'TOPRIGHT', -1, -2)




	local scrollbar = CreateFrame('Slider', nil, frame, 'UIPanelScrollBarTemplate')
	--scrollbar:SetPoint('TOPLEFT', frame, 'TOPRIGHT', 4, -16)
	--scrollbar:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT', 4, 16)
	scrollbar:SetPoint('TOP', scrollUpBg, 2, -18)
	scrollbar:SetPoint('BOTTOM', scrollDownBg, 2, 18)
	scrollbar.ScrollUpButton:SetScript('OnClick', function() scroll(frame, 1) end)
	scrollbar.ScrollDownButton:SetScript('OnClick', function() scroll(frame, -1) end)
	scrollbar:SetScript('OnValueChanged', function(self, value)
		frame.value = floor(value)
		frame:Update()
		if frame.value == frame.minValue then self.ScrollUpButton:Disable()
		else self.ScrollUpButton:Enable() end
		if frame.value >= frame.maxValue then self.ScrollDownButton:Disable()
		else self.ScrollDownButton:Enable() end
	end)
	frame.scrollbar = scrollbar

	local padding = 4
	-- columns
	frame.cols = {}
	local offset = 0
	for i, colTbl in ipairs(cols) do
		local name, width, justify = colTbl[1], colTbl[2], colTbl[3]
		local col = CreateFrame('Button', nil, frame)
		col:SetNormalFontObject('GameFontHighlightSmallLeft')
		col:SetHighlightFontObject('GameFontNormalSmallLeft')
		col:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 8 + offset, 0)
		col:SetSize(width, 18)
		col:SetText(name)
		col:GetFontString():SetAllPoints()
		if justify then
			col:GetFontString():SetJustifyH(justify)
			col.justify = justify
		end
		col.offset = offset
		col.width = width
		offset = offset + width + padding
		frame.cols[i] = col

		col:SetScript('OnClick', function(self)
			frame:SortBy(i+1)
		end)
	end


	-- rows
	for slot = 1, frame.slots do
		local f = CreateFrame("frame", nil, frame)
		f.cols = {}

		local bg = f:CreateTexture()
		bg:SetAllPoints()
		bg:SetColorTexture(1,1,1,0.1)
		bg:Hide()
		f.bg = bg

		f:EnableMouse(true)
		f:SetWidth(frame:GetWidth() - 38)
		f:SetHeight(frame.itemheight)

		for i, col in ipairs(frame.cols) do
			local str = addon:CreateString(f, 'x')
			str:SetPoint('LEFT', col.offset, 0)
			str:SetWidth(col.width)
			if col.justify then
				str:SetJustifyH(col.justify)
			end
			f.cols[i] = str
		end

		--[[
		local str = addon:CreateString(f, "Scroll_Slot_"..slot)
		str:SetAllPoints(f)
		str:SetWordWrap(false)
		str:SetNonSpaceWrap(false)
		--str:SetWidth(frame:GetWidth() - 50)
		--]]

		frame.slot[slot] = f
		if(slot > 1) then
			f:SetPoint("TOPLEFT", frame.slot[slot-1], "BOTTOMLEFT")
		else
			f:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
		end
		--f.text = str
	end


	frame:Update()
	return frame
end

--[[
local function npcprep(npctable, scroll)
	local newtable = {}
	for npcID,v in pairs(npctable) do
		tinsert(newtable, v)
	end
	sort(newtable, function(a,b) return a[2] < b[2] end)
	setscrolllist(scroll, newtable)
end
--]]

local RoleStrings = {
	TANK = '|TInterface/LFGFrame/LFGRole:16:16:0:0:64:16:32:48:0:16|t',
	HEALER = '|TInterface/LFGFrame/LFGRole:16:16:0:0:64:16:48:64:0:16|t',
	DAMAGER = '|TInterface/LFGFrame/LFGRole:16:16:0:0:64:16:16:32:0:16|t',
}

--[[
local waitList = newscroll(nil, UIParent, 310, 240, {{LEVEL_ABBR, 20, 'RIGHT'}, {NAME, 158}, {ITEM_LEVEL_ABBR, 25, 'RIGHT'},{RoleStrings['TANK'], 16, 'CENTER'}, {RoleStrings['HEALER'], 16, 'CENTER'}, {RoleStrings['DAMAGER'], 16, 'CENTER'}})
waitList:SetPoint('CENTER')
--left:SetPoint("TOPRIGHT", model, "TOPLEFT", -5, 0)
local creatures = {}
for i=1, 100 do
	tinsert(creatures, {random(60,90),"Name Placeholder "..i,random(460, 570),RoleStrings['TANK'], RoleStrings['HEALER'], RoleStrings['DAMAGER']})
end
--npcprep(creatures, left)
setscrolllist(waitList, creatures)


scrollscripts(waitList, {
	--["OnMouseDown"] = function(self)
	--	selectscrollitem(waitList, self.value)
	--end,
	["OnEnter"] = function(self)
		self.bg:Show()
	end,
	["OnLeave"] = function(self)
		self.bg:Hide()
	end,
})
--]]

--[[
local waitList = newscroll(nil, UIParent, 310, 240, {{CALENDAR_EVENT_DESCRIPTION, 148}, {ITEM_LEVEL_ABBR, 25, 'RIGHT'}, {RoleStrings['TANK'], 28, 'RIGHT'}, {RoleStrings['HEALER'], 28, 'RIGHT'}, {RoleStrings['DAMAGER'], 28, 'RIGHT'}})
waitList:SetPoint('CENTER')
--left:SetPoint("TOPRIGHT", model, "TOPLEFT", -5, 0)
local creatures = {}
for i=1, 100 do
	tinsert(creatures, {"Flex 1st wing, fresh!"..i, random(460, 570), random(0,2) .. ' ' .. RoleStrings['TANK'], random(0,6) .. ' ' .. RoleStrings['HEALER'], random(0,17) .. ' ' .. RoleStrings['DAMAGER']})
end
--npcprep(creatures, left)
--setscrolllist(waitList, creatures)
waitList:SetItems(creatures)
--]]
--table.sort(creatures, function(a,b) return a[1] < b[1] end)
--waitList:Update()


-- Input boxes
function addon:CreateInput(parent, width, defaultText, maxChars, numeric)
	local editbox = CreateFrame('EditBox', nil, parent)

	editbox:SetTextInsets(5, 0, 0, 0)

	local borderLeft = editbox:CreateTexture(nil, 'BACKGROUND')
	borderLeft:SetTexture([[Interface\Common\Common-Input-Border]])
	borderLeft:SetSize(8, 20)
	borderLeft:SetPoint('LEFT', 0, 0)
	borderLeft:SetTexCoord(0, 0.0625, 0, 0.625)

	local borderRight = editbox:CreateTexture(nil, 'BACKGROUND')
	borderRight:SetTexture([[Interface\Common\Common-Input-Border]])
	borderRight:SetSize(8, 20)
	borderRight:SetPoint('RIGHT', 0, 0)
	borderRight:SetTexCoord(0.9375, 1, 0, 0.625)

	local borderMiddle = editbox:CreateTexture(nil, 'BACKGROUND')
	borderMiddle:SetTexture([[Interface\Common\Common-Input-Border]])
	borderMiddle:SetSize(10, 20)
	borderMiddle:SetPoint('LEFT', borderLeft, 'RIGHT')
	borderMiddle:SetPoint('RIGHT', borderRight, 'LEFT')
	borderMiddle:SetTexCoord(0.0625, 0.9375, 0, 0.625)

	editbox:SetFontObject('ChatFontNormal')

	editbox:SetSize(width or 8, 20)
	editbox:SetAutoFocus(false)

	if defaultText then
		local placeholderText = addon:CreateString(editbox, defaultText, width or 8)
		placeholderText:SetFontObject('GameFontDisableLeft')
		placeholderText:SetPoint('LEFT', 5, 0)

		editbox:SetScript('OnEditFocusLost', function(self)
			if self:GetText() == '' then
				placeholderText:Show()
			else
				EditBox_ClearHighlight(self)
			end
		end)

		editbox:SetScript('OnEditFocusGained', function(self)
			placeholderText:Hide()
			EditBox_HighlightText(self)
		end)
	else
		editbox:SetScript('OnEditFocusLost', EditBox_ClearHighlight)
		editbox:SetScript('OnEditFocusGained', EditBox_HighlightText)
	end

	editbox:SetScript('OnEscapePressed', EditBox_ClearFocus)
	--editbox:SetScript('OnEditFocusLost', EditBox_ClearHighlight)
	--editbox:SetScript('OnEditFocusGained', EditBox_HighlightText)
	editbox:SetScript('OnTabPressed', function(self)
		if self.tabTarget then
			self.tabTarget:SetFocus()
		end
	end)
	if maxChars then
		editbox:SetMaxLetters(maxChars)
	end
	if numeric then
		editbox:SetNumeric(true)
	end
	--editbox:SetText(defaultText or '')
	return editbox
end

-- Dropdown Menus
local DropdownCount = 0

local function initmenu(items)

	local info = UIDropDownMenu_CreateInfo()
	info.text = 'Challenge Mode' --GUILD_CHALLENGE_TYPE2
	info.func = function() return end
	UIDropDownMenu_AddButton(info)
end

function addon:CreateDropdown(parent, width, items, defaultValue)
	local dropdown = CreateFrame('frame', addonName .. 'DropDownMenu' .. DropdownCount, parent, 'UIDropDownMenuTemplate')
	-- todo: redo all of this
	--dropdown:EnableMouse(true)
	DropdownCount = DropdownCount + 1
	--groupTypeDropdown:SetPoint('LEFT', ilevelInput, 'RIGHT', -5, -3)
	--groupTypeDropdown:SetPoint('TOPRIGHT', titleInput, 'BOTTOMRIGHT', 16, -8)
	--dropdown:SetPoint('BOTTOMRIGHT', parent, 10, 0)
	--UIDropDownMenu_Initialize(dropdown, function()
	dropdown.SetValue = function(dropdown, value)
		dropdown.value = value
		dropdown:initialize()
	end

	dropdown.initialize = function(dropdown)
		--local selectedValue = UIDropDownMenu_GetSelectedValue(dropdown)
		for i, tbl in ipairs(items) do
			local info = UIDropDownMenu_CreateInfo()
			--info.value = v[1]
			--info.text = v[2]

			for k, v in pairs(tbl) do
				info[k] = v
				if not defaultValue and k == 'value' then
					defaultValue = v
				end
			end


			info.func = function(self)
				if tbl.func then
					tbl.func(self)
				end
				--UIDropDownMenu_SetSelectedID(dropdown, self:GetID(), true)
				UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				dropdown.value = self.value
			end

			--if info.isTitle then
				--info.text = '-' .. info.text .. '-'
			--end

			UIDropDownMenu_AddButton(info)
		end
		-- dropdown:SetValue(dropdown.value or defaultValue)
		UIDropDownMenu_SetSelectedValue(dropdown, dropdown.value or defaultValue)
	end


	--UIDropDownMenu_SetSelectedID(dropdown, defaultID or 1)
	--UIDropDownMenu_SetSelectedValue(dropdown, defaultValue)
	dropdown:SetValue(defaultValue)
	UIDropDownMenu_SetWidth(dropdown, width or 160)

	_G[dropdown:GetName() .. 'Button']:HookScript('OnClick', function(self)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		--ToggleDropDownMenu(nil, nil, dropdown, dropdown, 0, 0)
	end)

	return dropdown
end
