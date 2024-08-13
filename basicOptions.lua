local addonName, addon = ...
local E = addon:Eve()

local _SetCVar = SetCVar -- Keep a local copy of SetCVar so we don't call the hooked version
local SetCVar = function(...) -- Suppress errors trying to set read-only cvars
  -- Not ideal, but the api doesn't give us this information
  local status, err = pcall(function(...)
    return _SetCVar(...)
  end, ...)
  return status
end

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local GetCVarInfo = addon.GetCVarInfo

AdvancedInterfaceOptionsSaved = {}
local DBVersion = 3

local CVarBlacklist = {
  -- Lowercase list of cvars to never record the value for, even if the user manually sets them
  ["playintromovie"] = true,
}

-- Saved settings
local DefaultSettings = {
  AccountVars = {}, -- account-wide cvars to be re-applied on login, [cvar] = value
  CharVars = {}, -- (todo) character-specific cvar settings? [charName-realm] = { [cvar] = value }
  EnforceSettings = false, -- true to load cvars from our saved variables every time we log in
  -- this will override anything that sets a cvar outside of this addon
  CustomVars = {}, -- custom options for missing/removed cvars
  ModifiedCVars = {}, -- [cvar:lower()] = 'last addon to modify it'
  DBVersion = DBVersion, -- Database version for wiping out incompatible data
}

local AlwaysCharacterSpecificCVars = {
  -- list of cvars that should never be account-wide
  -- [cvar] = true
  -- stopAutoAttackOnTargetChange
}

local function MergeTable(a, b) -- Non-destructively merges table b into table a
  for k, v in pairs(b) do
    if a[k] == nil or type(a[k]) ~= type(b[k]) then
      a[k] = v
      -- print('replacing key', k, v)
    elseif type(v) == "table" then
      a[k] = MergeTable(a[k], b[k])
    end
  end
  return a
end

local AddonLoaded, VariablesLoaded = false, false
function E:VARIABLES_LOADED()
  VariablesLoaded = true
  if AddonLoaded then
    MergeTable(AdvancedInterfaceOptionsSaved, DefaultSettings)
    self:ADDON_LOADED(addonName)
  end
end

function E:ADDON_LOADED(addon_name)
  if addon_name == addonName then
    E:UnregisterEvent("ADDON_LOADED")
    AddonLoaded = true
    if VariablesLoaded then
      E("Init")
    end
  end
end

function E:Init() -- Runs after our saved variables are loaded and cvars have been loaded
  if AdvancedInterfaceOptionsSaved.DBVersion ~= DBVersion then
    -- Wipe out previous settings if database versions don't match
    AdvancedInterfaceOptionsSaved["DBVersion"] = DBVersion
    AdvancedInterfaceOptionsSaved["AccountVars"] = {}
  end
  MergeTable(AdvancedInterfaceOptionsSaved, DefaultSettings) -- Repair database if keys are missing

  if AdvancedInterfaceOptionsSaved.EnforceSettings then
    if not AdvancedInterfaceOptionsSaved.AccountVars then
      AdvancedInterfaceOptionsSaved["AccountVars"] = {}
    end
    for cvar, value in pairs(AdvancedInterfaceOptionsSaved.AccountVars) do
      if addon.hiddenOptions[cvar] and addon:CVarExists(cvar) and not CVarBlacklist[cvar:lower()] then -- confirm we still use this cvar
        if GetCVar(cvar) ~= value then
          if not InCombatLockdown() or not addon.combatProtected[cvar] then
            SetCVar(cvar, value)
            -- print('Loading cvar', cvar, value)
          end
        end
      else -- remove if cvar is no longer supported
        AdvancedInterfaceOptionsSaved.AccountVars[cvar] = nil
      end
    end
  end

  --Register our options with the Blizzard Addon Options panel
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions", addon:CreateGeneralOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_Camera", addon:CreateCameraOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_Chat", addon:CreateChatOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_Combat", addon:CreateCombatOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_FloatingCombatText", addon:CreateFloatingCombatTextOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_StatusText", addon:CreateStatusTextOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_Nameplate", addon:CreateNameplateOptions())
  AceConfigRegistry:RegisterOptionsTable("AdvancedInterfaceOptions_cVar", addon:CreateCVarOptions())

  local categoryFrame, mainCategoryID = AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions", "AdvancedInterfaceOptions")
  AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_Camera", "Camera", "AdvancedInterfaceOptions")
  AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_Chat", "Chat", "AdvancedInterfaceOptions")
  AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_Combat", "Combat", "AdvancedInterfaceOptions")
  AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_FloatingCombatText", "Floating Combat Text", "AdvancedInterfaceOptions")
  AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_StatusText", "Status Text", "AdvancedInterfaceOptions")
  AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_Nameplate", "Nameplates", "AdvancedInterfaceOptions")
  local cVarFrame, cVarCategoryID = AceConfigDialog:AddToBlizOptions("AdvancedInterfaceOptions_cVar", "CVar Browser", "AdvancedInterfaceOptions")

  -- Inject our custom cVar browser into the panel created by Ace3
  addon:PopulateCVarPanel(cVarFrame)
  -------------------------------------------------------------------------
  -------------------------------------------------------------------------

  -- Slash handler
  SlashCmdList.AIO = function(msg)
    msg = msg:lower()
    if not InCombatLockdown() then
      Settings.OpenToCategory(mainCategoryID)
    else
      DEFAULT_CHAT_FRAME:AddMessage(format("%s: Can't modify interface options in combat", addonName))
    end
  end
  SLASH_AIO1 = "/aio"

  -- TODO: Adjust in 11.0.2 when subcategories are properly fixed
  SlashCmdList.CVAR = function()
    if not InCombatLockdown() then
      for _, category in ipairs(SettingsPanel:GetCategoryList().allCategories) do
        if category.ID == mainCategoryID and category.subcategories then
          for _, subCategory in ipairs(category.subcategories) do
            if subCategory.ID == cVarCategoryID then
              SettingsPanel:Show()
              SettingsPanel:SelectCategory(subCategory)
              break
            end
          end
        end
      end
    else
      DEFAULT_CHAT_FRAME:AddMessage(format("%s: Can't modify interface options in combat", addonName))
    end
  end
  SLASH_CVAR1 = "/cvar"
end

function addon:RecordCVar(cvar, value) -- Save cvar to DB for loading later
  if not AlwaysCharacterSpecificCVars[cvar] then
    -- We either need to normalize all cvars being entered into this table or verify that
    -- the case matches the case in our database or we risk duplicating entries.
    -- eg. MouseSpeed = 1, and mouseSpeed = 2 could exist in the table simultaneously,
    -- which would lead to an indeterminate value being loaded on startup
    local found = rawget(addon.hiddenOptions, cvar)
    if not found then
      local mk = cvar:lower()
      for k, v in pairs(addon.hiddenOptions) do
        if k:lower() == mk then
          cvar = k
          found = true
          break
        end
      end
    end
    if found and not CVarBlacklist[cvar:lower()] then -- only record cvars that exist in our database
      -- If we don't save the value if it's set to the default, and something else changes it from the default, we won't know to set it back
      --if GetCVar(cvar) == GetCVarDefault(cvar) then -- don't bother recording if default value
      --	AdvancedInterfaceOptionsSaved.AccountVars[cvar] = nil
      --else
      AdvancedInterfaceOptionsSaved.AccountVars[cvar] = GetCVar(cvar) -- not necessarily the same as "value"
      --end
    end
  end
end

function addon:DontRecordCVar(cvar, value) -- Wipe out saved variable if another addon modifies it
  if not AlwaysCharacterSpecificCVars[cvar] then
    local found = rawget(addon.hiddenOptions, cvar)
    if not found then
      local mk = cvar:lower()
      for k, v in pairs(addon.hiddenOptions) do
        if k:lower() == mk then
          cvar = k
          found = true
          break
        end
      end
    end
    if found then
      AdvancedInterfaceOptionsSaved.AccountVars[cvar] = nil
    end
  end
end

function addon:SetCVar(cvar, value, ...) -- save our cvar to the db
  if not InCombatLockdown() then
    SetCVar(cvar, value, ...)
    addon:RecordCVar(cvar, value)
    -- Clear entry from ModifiedCVars if we're modifying it directly
    -- Enforced settings don't use this function, so shouldn't wipe them out
    if AdvancedInterfaceOptionsSaved.ModifiedCVars[cvar:lower()] then
      AdvancedInterfaceOptionsSaved.ModifiedCVars[cvar:lower()] = nil
    end
  else
    --print("Can't modify interface options in combat")
  end
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Button to reset all of our settings back to their defaults
StaticPopupDialogs["AIO_RESET_EVERYTHING"] = {
  text = 'Type "IRREVERSIBLE" into the text box to reset all CVars to their default settings',
  button1 = "Confirm",
  button2 = "Cancel",
  hasEditBox = true,
  OnShow = function(self)
    self.button1:SetEnabled(false)
  end,
  EditBoxOnTextChanged = function(self, data)
    self:GetParent().button1:SetEnabled(self:GetText():lower() == "irreversible")
  end,
  OnAccept = function()
    for _, info in ipairs(addon:GetCVars()) do
      local cvar = info.command
      local current, default = GetCVarInfo(cvar)
      if current ~= default then
        print(format("|cffaaaaff%s|r reset from |cffffaaaa%s|r to |cffaaffaa%s|r", tostring(cvar), tostring(current), tostring(default)))
        addon:SetCVar(cvar, default)
      end
    end
    wipe(AdvancedInterfaceOptionsSaved.CustomVars)
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
  showAlert = true,
}

-- Backup Settings
function addon.BackupSettings()
  --[[
		FIXME: We probably don't actually want to back up every CVar
		Some CVars use bitfields to track progress that the player likely isn't expecting to be undone by a restore
		We may need to manually create a list of CVars to ignore, I don't know if there's a way to automate this
	--]]
  local cvarBackup = {}
  local settingCount = 0
  for _, info in ipairs(addon:GetCVars()) do
    -- Only record CVars that don't match their default value
    -- NOTE: Defaults can potentially change, should we store every cvar?
    local currentValue, defaultValue = GetCVarInfo(info.command)
    if currentValue ~= defaultValue then
      -- Normalize casing to simplify lookups
      local cvar = info.command:lower()
      cvarBackup[cvar] = currentValue
      settingCount = settingCount + 1
    end
  end

  -- TODO: Support multiple backups (save & restore named cvar profiles)
  if not AdvancedInterfaceOptionsSaved.Backups then
    AdvancedInterfaceOptionsSaved.Backups = {}
  end
  AdvancedInterfaceOptionsSaved.Backups[1] = {
    timestamp = GetServerTime(),
    cvars = cvarBackup,
  }

  print(format("AIO: Backed up %d customized CVar settings!", settingCount))
end

StaticPopupDialogs["AIO_BACKUP_SETTINGS"] = {
  text = "Save current CVar settings to restore later?",
  button1 = "Backup Settings",
  button2 = "Cancel",
  OnAccept = addon.BackupSettings,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

-- Restore Settings
function addon.RestoreSettings()
  local backup = AdvancedInterfaceOptionsSaved.Backups and AdvancedInterfaceOptionsSaved.Backups[1]
  if backup then
    for _, info in ipairs(addon:GetCVars()) do
      local cvar = info.command
      local backupValue = backup.cvars[cvar:lower()] -- Always lowercase cvar names
      local currentValue, defaultValue = GetCVarInfo(cvar)
      if backupValue then
        -- Restore value from backup
        if currentValue ~= backupValue then
          print(format("|cffaaaaff%s|r changed from |cffffaaaa%s|r to |cffaaffaa%s|r", cvar, tostring(currentValue), tostring(backupValue)))
          addon:SetCVar(cvar, backupValue)
        end
      else
        -- TODO: If CVar isn't in backup and isn't set to default value, should we reset to default or ignore it?
        if currentValue ~= defaultValue then
          print(format("|cffaaaaff%s|r changed from |cffffaaaa%s|r to |cffaaffaa%s|r", cvar, tostring(currentValue), tostring(defaultValue)))
          addon:SetCVar(cvar, defaultValue)
        end
      end
    end
  end
end

StaticPopupDialogs["AIO_RESTORE_SETTINGS"] = {
  text = "Restore CVar settings from backup?\nNote: This can't be undone!",
  button1 = "Restore Settings",
  button2 = "Cancel",
  OnAccept = addon.RestoreSettings,
  OnShow = function(self)
    -- Disable accept button if we don't have any backups
    self.button1:SetEnabled(AdvancedInterfaceOptionsSaved.Backups and AdvancedInterfaceOptionsSaved.Backups[1])
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
  showAlert = true,
}
