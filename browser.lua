local _, addon = ...
local E = addon:Eve()

local GetCVarInfo = addon.GetCVarInfo

-- C_Console.GetAllCommands() does not return the complete list of CVars on login
-- Repopulate the list using UpdateCVarList() when the CVar browser is opened
local CVarList = {}

local function UpdateCVarList()
  for i, info in pairs(addon:GetCVars()) do
    local cvar = info.command
    if addon.hiddenOptions[cvar] then
      CVarList[cvar] = addon.hiddenOptions[cvar]
    else
      CVarList[cvar] = {
        description = info.help,
      }
    end
  end
end

-------------------------------------------------------
-- Track cvars set by the interface and other addons
-- hook SetCVar early, record to a temporary table and commit to saved vars when we finish loading

local SVLoaded = false -- we can't record any changes until after our own saved vars have loaded
local TempTraces = {} -- [cvar:lower()] = {source, value}

function E:Init()
  SVLoaded = true
  for cvar, trace in pairs(TempTraces) do -- commit temp vars to sv
    local source, value = trace.source, trace.value
    local currentValue = GetCVar(cvar)
    if value == currentValue then -- only record if the 2 values match, otherwise we probably overwrote it with our own
      AdvancedInterfaceOptionsSaved.ModifiedCVars[cvar] = source
      addon:DontRecordCVar(cvar, value)
    end
  end
end

local function TraceCVar(cvar, value, ...)
  if not addon:CVarExists(cvar) then
    return
  end

  --[=[
        -- Example calls to debugstack(2) as of patch 9.1.5
        -- A call to `SetCVar' results in this hook running twice because SetCVar is a wrapper for C_CVar.SetCVar

        1) `C_CVar.SetCVar' traces to `SetCVar' in CvarUtil.lua
        [string "=[C]"]: in function `SetCVar'
        [string "@Interface\SharedXML\CvarUtil.lua"]:13: in function <Interface\SharedXML\CvarUtil.lua:9>
        [string "=[C]"]: in function `SetCVar'
        [string "@Interface\AddOns\AdvancedInterfaceOptions\browser.lua"]:89: in main chunk

        2) `SetCVar' traces to the function that invoked it
        [string "=[C]"]: in function `SetCVar'
        [string "@Interface\AddOns\AdvancedInterfaceOptions\browser.lua"]:89: in main chunk
    ]=]

  local trace = debugstack(2)
  local source, lineNum = trace:match('"@([^"]+)"%]:(%d+)')
  if not source then
    -- Attempt to pull source out of "in function <file:line>" string
    source, lineNum = trace:match("in function <([^:%[>]+):(%d+)>")
    if not source then
      -- Give up and record entire traceback
      source = trace
      lineNum = "(unhandled exception)"
    end
  end
  -- Ignore C_CVar.SetCVar hook if it originated from ourselves or CvarUtil.lua or ClassicCvarUtil.lua
  if
    source
    and not (
      source:lower():find("[\\/]advancedinterfaceoptions[\\/]")
      or source:lower():find("[_\\/]sharedxmlbase[\\/]cvarutil%.lua")
      or source:lower():find("[_\\/]sharedxml[\\/]cvarutil%.lua")
      or source:lower():find("[_\\/]sharedxml[\\/]classiccvarutil%.lua")
      or source:lower():find("[_\\/]sharedxml[\\/]classic[\\/]classiccvarutil%.lua")
    )
  then
    local realValue = GetCVar(cvar) -- the client does some conversions to the original value
    if SVLoaded then
      AdvancedInterfaceOptionsSaved.ModifiedCVars[cvar:lower()] = source .. ":" .. lineNum
      addon:DontRecordCVar(cvar, realValue)
    else
      -- this will still record blame for an addon even if we overwrite their setting
      TempTraces[cvar:lower()] = {
        source = source .. ":" .. lineNum,
        value = realValue,
      }
    end
  end
end

hooksecurefunc("SetCVar", TraceCVar) -- /script SetCVar(cvar, value)
if C_CVar and C_CVar.SetCVar then
  hooksecurefunc(C_CVar, "SetCVar", TraceCVar) -- C_CVar.SetCVar(cvar, value)
end
hooksecurefunc("ConsoleExec", function(msg)
  local cmd, cvar, value = msg:match("^(%S+)%s+(%S+)%s*(%S*)")
  if cmd then
    if cmd:lower() == "set" then -- /console SET cvar value
      TraceCVar(cvar, value)
    else -- /console cvar value
      TraceCVar(cmd, cvar)
    end
  end
end)

local SetCVar = function(cvar, value)
  addon:SetCVar(cvar, value)
end

-- Injects the CVar browser into the options panel created by Ace3
function addon:PopulateCVarPanel(OptionsPanel)
  local Title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  Title:SetJustifyV("TOP")
  Title:SetJustifyH("LEFT")
  Title:SetPoint("TOPLEFT", 10, -16)
  Title:SetText("CVar Browser")

  local SubText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  SubText:SetMaxLines(3)
  SubText:SetNonSpaceWrap(true)
  SubText:SetJustifyV("TOP")
  SubText:SetJustifyH("LEFT")
  SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -12)
  SubText:SetPoint("RIGHT", -32, 0)
  SubText:SetText("These options allow you to modify various CVars within the game.")

  -- FilterBox should adjust the contents of the list frame based on the input text
  -- todo: Display grey "Search" text in the box if it's empty
  local FilterBox = CreateFrame("editbox", nil, OptionsPanel, "InputBoxTemplate")
  FilterBox:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 5, -10)
  FilterBox:SetPoint("RIGHT", OptionsPanel, "RIGHT", -40, 0)
  FilterBox:SetHeight(20)
  FilterBox:SetAutoFocus(false)
  FilterBox:ClearFocus()
  FilterBox:SetScript("OnEscapePressed", function(self)
    self:SetAutoFocus(false) -- Allow focus to clear when escape is pressed
    self:ClearFocus()
  end)
  FilterBox:SetScript("OnEnterPressed", function(self)
    self:SetAutoFocus(false) -- Clear focus when enter is pressed because Ketho said so
    self:ClearFocus()
  end)
  FilterBox:SetScript("OnEditFocusGained", function(self)
    self:SetAutoFocus(true)
    self:HighlightText()
  end)

  local CVarTable = {}
  local ListFrame = addon:CreateListFrame(OptionsPanel, 650, 465, { { NAME, 200 }, { "Description", 260, "LEFT" }, { "Value", 100, "RIGHT" } })
  ListFrame:SetPoint("TOP", FilterBox, "BOTTOM", 0, -20)
  ListFrame:SetPoint("BOTTOMLEFT", 0, 15)
  ListFrame:SetItems(CVarTable)

  ListFrame.Bg:SetAlpha(0.8)

  FilterBox:SetMaxLetters(100)

  -- Escape special characters for matching a literal string
  local function Literalize(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
  end

  -- Rewrite text pattern to be case-insensitive
  local function UnCase(c)
    return "[" .. strlower(c) .. strupper(c) .. "]"
  end

  local FilteredTable = {} -- Filtered version of CVarTable based on search box input

  -- Filter displayed items based on value of FilterBox
  local function FilterCVarList()
    local text = FilterBox:GetText()
    if text == "" then
      -- set to default list
      ListFrame:SetItems(CVarTable)
    else
      local pattern = Literalize(text):gsub("%a", UnCase)
      -- filter based on text
      wipe(FilteredTable)
      for i = 1, #CVarTable do
        local row = CVarTable[i]
        for j = 2, #row - 1 do -- start at 2 to skip the hidden value column, not sure if we should include every column in the filter or not
          local col = row[j]
          -- Color the search query, this is pretty inefficient
          local newtext, replacements = col:gsub(pattern, "|cffff0000%1|r")
          if replacements > 0 then
            local newrow = { row[1], [#row] = row[#row] }
            for k = 2, #row - 1 do
              newrow[k] = row[k]:gsub(pattern, "|cffff0000%1|r")
            end
            tinsert(FilteredTable, newrow)
            break
          end
        end
      end
      ListFrame:SetItems(FilteredTable)
    end
  end

  FilterBox:SetScript("OnTextChanged", FilterCVarList)

  -- Returns a rounded integer or float, the default value, and whether it's set to its default value
  local function GetPrettyCVar(cvar)
    local value, default = GetCVarInfo(cvar)
    --if not value then value = '|cff00ff00EROR' end
    --if not default then default = '|cff00ff00EROR' end
    if not default or not value then
      return "", false
    end -- this cvar doesn't exist
    local isFloat = strmatch(value or "", "^-?%d+%.%d+$")
    if isFloat then
      value = format("%.2f", value):gsub("%.?0+$", "")
    end

    local isDefault = tonumber(value) and tonumber(default) and (value - default == 0) or (value == default)
    return value, default, isDefault
  end

  -- Update CVarTable to reflect current values
  local function RefreshCVarList()
    wipe(CVarTable)
    UpdateCVarList()
    -- todo: this needs to be updated every time a cvar changes while the table is visible
    for cvar, tbl in pairs(CVarList) do
      local value, default, isDefault = GetPrettyCVar(cvar)

      if not (type(value) == "string" and (value:byte(2) == 1 or value:byte(1) == 2)) then -- hack to strip tracking variables and filters from our table, maybe look for a better solution
        tinsert(CVarTable, { cvar, cvar, tbl.description or "", isDefault and value or ("|cffff0000" .. value .. "|r") })
      end
    end
    --ListFrame:SetItems(CVarTable)
  end

  local function FilteredRefresh()
    if ListFrame:IsVisible() then
      RefreshCVarList()
      FilterCVarList()
    end
  end

  ListFrame:HookScript("OnShow", FilteredRefresh)

  -- Events
  local oSetCVar = SetCVar

  -- TODO: this needs to be updated every time a cvar changes while the table is visible
  RefreshCVarList()
  ListFrame:SetItems(CVarTable)
  ListFrame:SortBy(2)
  --FilterCVarList()

  -- We don't really want the user to be able to do anything else while the input box is open
  -- I'd rather make this a child of the input box, but I can't get it to show up above its child
  -- todo: show default value around the input box somewhere while it's active
  local CVarInputBoxMouseBlocker = CreateFrame("frame", nil, ListFrame)
  CVarInputBoxMouseBlocker:SetFrameStrata("FULLSCREEN_DIALOG")
  CVarInputBoxMouseBlocker:Hide()

  local CVarInputBox = CreateFrame("editbox", nil, CVarInputBoxMouseBlocker, "InputBoxTemplate")
  -- block clicking and cancel on any clicks outside the edit box
  CVarInputBoxMouseBlocker:EnableMouse(true)
  CVarInputBoxMouseBlocker:SetScript("OnMouseDown", function(self)
    CVarInputBox:ClearFocus()
  end)
  -- block scrolling
  CVarInputBoxMouseBlocker:EnableMouseWheel(true)
  CVarInputBoxMouseBlocker:SetScript("OnMouseWheel", function() end)
  CVarInputBoxMouseBlocker:SetAllPoints(nil)

  local blackout = CVarInputBoxMouseBlocker:CreateTexture(nil, "BACKGROUND")
  blackout:SetAllPoints()
  blackout:SetColorTexture(0, 0, 0, 0.2)

  CVarInputBox:Hide()
  CVarInputBox:SetSize(100, 20)
  CVarInputBox:SetJustifyH("RIGHT")
  CVarInputBox:SetTextInsets(5, 10, 0, 0)
  CVarInputBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
    self:Hide()
  end)

  CVarInputBox:SetScript("OnEnterPressed", function(self)
    -- TODO: I don't like this, change it
    oSetCVar(self.cvar, self:GetText() or "")
    self:Hide()
    FilteredRefresh()
  end)
  --CVarInputBox:SetScript('OnShow', function(self)
  --self:SetFocus()
  --end)
  CVarInputBox:SetScript("OnHide", function(self)
    CVarInputBoxMouseBlocker:Hide()
    if self.str then
      self.str:Show()
    end
  end)
  CVarInputBox:SetScript("OnEditFocusLost", function(self)
    self:Hide()
    FilterBox:SetFocus()
  end)

  function E:PLAYER_REGEN_DISABLED()
    if CVarInputBox:IsVisible() then
      CVarInputBox:Hide()
    end
    FilterBox:GetScript("OnEscapePressed")(FilterBox)
  end

  local LastClickTime = 0 -- Track double clicks on rows
  ListFrame:SetScripts({
    OnEnter = function(self)
      if self.value ~= "" then
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
        local cvarTable = CVarList[self.value]
        local _, defaultValue = GetCVarInfo(self.value)
        GameTooltip:AddLine(cvarTable["prettyName"] or self.value, nil, nil, nil, false)
        GameTooltip:AddLine(" ")
        if cvarTable["description"] then --and _G[ cvarTable['description'] ] then
          GameTooltip:AddLine(cvarTable["description"], 1, 1, 1, true)
        end
        GameTooltip:AddDoubleLine("Default Value:", defaultValue, 0.2, 1, 0.6, 0.2, 1, 0.6)

        local modifiedBy = AdvancedInterfaceOptionsSaved.ModifiedCVars[self.value:lower()]
        if modifiedBy then
          GameTooltip:AddDoubleLine("Last Modified By:", modifiedBy, 1, 0, 0, 1, 0, 0)
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
        CVarInputBox:SetPoint("RIGHT", self)
        local value = GetPrettyCVar(self.value)
        CVarInputBox:SetText(value or "")
        CVarInputBox:HighlightText()
        CVarInputBoxMouseBlocker:Show()
        CVarInputBox:Show()
        CVarInputBox:SetFocus()
      else
        LastClickTime = now
      end
    end,
  })

  -- Update browser when a cvar is set while it's open
  -- There are at least 4 different ways a cvar can be set:
  --    /run SetCVar("cvar", value)
  --    /console "cvar" value
  --    /console SET "cvar" value (case doesn't matter)
  --    Hitting ` and typing SET "cvar" into the console window itself
  --    Console is not part of the interface, doesn't fire an event, and I'm not sure that we can hook it

  -- These could be more efficient by not refreshing the entire list but that would be more work
  hooksecurefunc("SetCVar", FilteredRefresh)

  -- should we even bother checking what the console command did?
  hooksecurefunc("ConsoleExec", FilteredRefresh)
end
