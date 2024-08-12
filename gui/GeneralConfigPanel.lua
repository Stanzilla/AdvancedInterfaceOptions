local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateGeneralOptions()
  local generalOptions = {
    type = "group",
    childGroups = "tree",
    name = "Advanced Interface Options",
    args = {
      instructions = {
        type = "description",
        name = "These options allow you to toggle various options that have been removed from the game in Legion.",
        fontSize = "medium",
        order = 1,
      },
      header = {
        type = "header",
        name = "",
        order = 2,
      },
      -------------------------------------------------
      enforceBox = {
        type = "toggle",
        name = "Enforce Settings on Startup",
        desc = "Reapplies all settings when you log in or change characters.\n\nCheck this if your settings aren't being saved between sessions.",
        get = function()
          return AdvancedInterfaceOptionsSaved.EnforceSettings
        end,
        set = function(_, value)
          AdvancedInterfaceOptionsSaved.EnforceSettings = value
        end,
        width = "full",
        order = 3,
      },
      -------------------------------------------------
      generalHeader = {
        type = "header",
        name = "General Options",
        order = 10,
      },
      UnitNamePlayerPVPTitle = {
        type = "toggle",
        name = UNIT_NAME_PLAYER_TITLE,
        desc = OPTION_TOOLTIP_UNIT_NAME_PLAYER_TITLE,
        get = function()
          return C_CVar.GetCVarBool("UnitNamePlayerPVPTitle")
        end,
        set = function(_, value)
          self:SetCVar("UnitNamePlayerPVPTitle", value)
        end,
        width = "full",
        order = 11,
      },
      UnitNamePlayerGuild = {
        type = "toggle",
        name = UNIT_NAME_GUILD,
        desc = OPTION_TOOLTIP_UNIT_NAME_GUILD,
        get = function()
          return C_CVar.GetCVarBool("UnitNamePlayerGuild")
        end,
        set = function(_, value)
          self:SetCVar("UnitNamePlayerGuild", value)
        end,
        width = "full",
        order = 12,
      },
      UnitNameGuildTitle = {
        type = "toggle",
        name = UNIT_NAME_GUILD_TITLE,
        desc = OPTION_TOOLTIP_UNIT_NAME_GUILD_TITLE,
        get = function()
          return C_CVar.GetCVarBool("UnitNameGuildTitle")
        end,
        set = function(_, value)
          self:SetCVar("UnitNameGuildTitle", value)
        end,
        width = "full",
        order = 13,
      },
      mapFade = {
        type = "toggle",
        name = MAP_FADE_TEXT,
        desc = OPTION_TOOLTIP_MAP_FADE,
        get = function()
          return C_CVar.GetCVarBool("mapFade")
        end,
        set = function(_, value)
          self:SetCVar("mapFade", value)
        end,
        hidden = function()
          return self.IsClassicEra() or self.IsClassic()
        end,
        width = "full",
        order = 14,
      },
      secureAbilityToggle = {
        type = "toggle",
        name = SECURE_ABILITY_TOGGLE,
        desc = OPTION_TOOLTIP_SECURE_ABILITY_TOGGLE,
        get = function()
          return C_CVar.GetCVarBool("secureAbilityToggle")
        end,
        set = function(_, value)
          self:SetCVar("secureAbilityToggle", value)
        end,
        width = "full",
        order = 15,
      },
      scriptErrors = {
        type = "toggle",
        name = SHOW_LUA_ERRORS,
        desc = OPTION_TOOLTIP_SHOW_LUA_ERRORS,
        get = function()
          return C_CVar.GetCVarBool("scriptErrors")
        end,
        set = function(_, value)
          self:SetCVar("scriptErrors", value)
        end,
        width = "full",
        order = 16,
      },
      noBuffDebuffFilterOnTarget = {
        type = "toggle",
        name = "No Debuff Filter on Target",
        desc = "Do not filter buffs or debuffs at all on targets",
        get = function()
          return C_CVar.GetCVarBool("noBuffDebuffFilterOnTarget")
        end,
        set = function(_, value)
          self:SetCVar("noBuffDebuffFilterOnTarget", value)
        end,
        width = "full",
        order = 17,
      },
      reverseCleanupBags = {
        type = "toggle",
        name = REVERSE_CLEAN_UP_BAGS_TEXT,
        desc = OPTION_TOOLTIP_REVERSE_CLEAN_UP_BAGS,
        get = function()
          if C_Container and C_Container.GetSortBagsRightToLeft then
            return C_Container.GetSortBagsRightToLeft()
          elseif GetInsertItemsRightToLeft then
            return GetInsertItemsRightToLeft()
          end
        end,
        set = function(_, value)
          -- This is a dirty hack for SetSortBagsRightToLeft not instantly updating the bags
          -- Force a refresh of the UI after a set amount of time to make the checkbox reflect the new value
          C_Timer.After(0.5, function()
            LibStub("AceConfigRegistry-3.0"):NotifyChange("AdvancedInterfaceOptions")
          end)

          if C_Container and C_Container.SetSortBagsRightToLeft then
            C_Container.SetSortBagsRightToLeft(value)
          elseif SetSortBagsRightToLeft then
            SetSortBagsRightToLeft(value)
          end
        end,
        hidden = function()
          return self.IsClassicEra() or self.IsClassic()
        end,
        width = "full",
        order = 18,
      },
      lootLeftmostBag = {
        type = "toggle",
        name = REVERSE_NEW_LOOT_TEXT,
        desc = OPTION_TOOLTIP_REVERSE_NEW_LOOT,
        get = function()
          if C_Container and C_Container.GetInsertItemsLeftToRight then
            return C_Container.GetInsertItemsLeftToRight()
          elseif GetInsertItemsLeftToRight then
            GetInsertItemsLeftToRight()
          end
        end,
        set = function(_, value)
          -- This is a dirty hack for SetInsertItemsLeftToRight not instantly updating the bags
          -- Force a refresh of the UI after a set amount of time to make the checkbox reflect the new value
          C_Timer.After(0.5, function()
            LibStub("AceConfigRegistry-3.0"):NotifyChange("AdvancedInterfaceOptions")
          end)

          if C_Container and C_Container.SetInsertItemsLeftToRight then
            return C_Container.SetInsertItemsLeftToRight(value)
          elseif SetInsertItemsLeftToRight then
            SetInsertItemsLeftToRight(value)
          end
        end,
        hidden = function()
          return self.IsClassicEra() or self.IsClassic()
        end,
        width = "full",
        order = 19,
      },
      enableWoWMouse = {
        type = "toggle",
        name = WOW_MOUSE,
        desc = OPTION_TOOLTIP_WOW_MOUSE,
        get = function()
          -- NOTE: Currently broken, see https://github.com/Stanzilla/AdvancedInterfaceOptions/issues/83
          ---@diagnostic disable-next-line: param-type-mismatch
          return C_CVar.GetCVarBool("enableWoWMouse")
        end,
        set = function(_, value)
          self:SetCVar("enableWoWMouse", value)
        end,
        width = "full",
        order = 20,
      },
      -------------------------------------------------
      cameraHeader = {
        type = "header",
        name = "",
        order = 30,
      },
      trackQuestSorting = {
        type = "select",
        name = "Select quest sorting mode:",
        desc = "Select how quests are sorted in the quest log.",
        values = {
          ["top"] = "Top",
          ["proximity"] = "Proximity",
        },
        sorting = {
          "top",
          "proximity",
        },
        get = function()
          return C_CVar.GetCVar("trackQuestSorting")
        end,
        set = function(_, value)
          self:SetCVar("trackQuestSorting", value)
        end,
        width = THIRD_WIDTH,
        order = 31,
      },
      -------------------------------------------------
      dataHeader = {
        type = "header",
        name = "",
        order = 40,
      },
      backupSettings = {
        type = "execute",
        name = "Backup Settings",
        func = function()
          StaticPopup_Show("AIO_BACKUP_SETTINGS")
        end,
        width = THIRD_WIDTH,
        order = 41,
      },
      restoreSettings = {
        type = "execute",
        name = "Restore Settings",
        func = function()
          StaticPopup_Show("AIO_RESTORE_SETTINGS")
        end,
        width = THIRD_WIDTH,
        order = 43,
      },
      resetSettings = {
        type = "execute",
        name = "Reset Settings",
        func = function()
          StaticPopup_Show("AIO_RESET_EVERYTHING")
        end,
        width = THIRD_WIDTH,
        order = 43,
      },
    },
  }

  return generalOptions
end
