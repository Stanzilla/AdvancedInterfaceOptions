local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25
local HALF_WIDTH = 1.5

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- UVARINFO was made local in patch 8.2.0
local uvars = {
  removeChatDelay = "REMOVE_CHAT_DELAY",
  lockActionBars = "LOCK_ACTIONBAR",
  buffDurations = "SHOW_BUFF_DURATIONS",
  alwaysShowActionBars = "ALWAYS_SHOW_MULTIBARS",
  showPartyPets = "SHOW_PARTY_PETS",
  showPartyBackground = "SHOW_PARTY_BACKGROUND",
  showTargetOfTarget = "SHOW_TARGET_OF_TARGET",
  autoQuestWatch = "AUTO_QUEST_WATCH",
  lootUnderMouse = "LOOT_UNDER_MOUSE",
  autoLootDefault = "AUTO_LOOT_DEFAULT",
  enableFloatingCombatText = "SHOW_COMBAT_TEXT",
  floatingCombatTextLowManaHealth = "COMBAT_TEXT_SHOW_LOW_HEALTH_MANA",
  floatingCombatTextAuras = "COMBAT_TEXT_SHOW_AURAS",
  floatingCombatTextAuraFade = "COMBAT_TEXT_SHOW_AURA_FADE",
  floatingCombatTextCombatState = "COMBAT_TEXT_SHOW_COMBAT_STATE",
  floatingCombatTextDodgeParryMiss = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS",
  floatingCombatTextDamageReduction = "COMBAT_TEXT_SHOW_RESISTANCES",
  floatingCombatTextRepChanges = "COMBAT_TEXT_SHOW_REPUTATION",
  floatingCombatTextReactives = "COMBAT_TEXT_SHOW_REACTIVES",
  floatingCombatTextFriendlyHealers = "COMBAT_TEXT_SHOW_FRIENDLY_NAMES",
  floatingCombatTextComboPoints = "COMBAT_TEXT_SHOW_COMBO_POINTS",
  floatingCombatTextEnergyGains = "COMBAT_TEXT_SHOW_ENERGIZE",
  floatingCombatTextPeriodicEnergyGains = "COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE",
  floatingCombatTextFloatMode = "COMBAT_TEXT_FLOAT_MODE",
  floatingCombatTextHonorGains = "COMBAT_TEXT_SHOW_HONOR_GAINED",
  showCastableBuffs = "SHOW_CASTABLE_BUFFS",
  showDispelDebuffs = "SHOW_DISPELLABLE_DEBUFFS",
  showArenaEnemyFrames = "SHOW_ARENA_ENEMY_FRAMES",
  showArenaEnemyCastbar = "SHOW_ARENA_ENEMY_CASTBAR",
  showArenaEnemyPets = "SHOW_ARENA_ENEMY_PETS",
}

local function BlizzardOptionsPanel_UpdateCombatText()
  -- Hack to call CombatText_UpdateDisplayedMessages which only exists if the Blizzard_CombatText AddOn is loaded
  if CombatText_UpdateDisplayedMessages then
    CombatText_UpdateDisplayedMessages()
  end
end

local function FCT_SetValue(cvar, checked)
  _G[uvars[cvar]] = checked and "1" or "0"
  BlizzardOptionsPanel_UpdateCombatText()
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateFloatingCombatTextOptions()
  local floatingCombatTextOptions = {
    type = "group",
    childGroups = "tree",
    name = FLOATING_COMBATTEXT_LABEL,
    args = {
      instructions = {
        type = "description",
        name = COMBATTEXT_SUBTEXT,
        fontSize = "medium",
        order = 1,
      },
      -------------------------------------------------
      onTargetHeader = {
        type = "header",
        name = "Floating Combat Text on Target",
        order = 10,
      },
      floatingCombatTextCombatDamage_v2 = {
        type = "toggle",
        name = SHOW_DAMAGE_TEXT,
        desc = OPTION_TOOLTIP_SHOW_DAMAGE,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatDamage_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatDamage_v2", value)
        end,
        width = HALF_WIDTH,
        order = 11,
      },
      floatingCombatTextCombatLogPeriodicSpells_v2 = {
        type = "toggle",
        name = LOG_PERIODIC_EFFECTS_TEXT or LOG_PERIODIC_EFFECTS,
        desc = OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatLogPeriodicSpells_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatLogPeriodicSpells_v2", value)
        end,
        width = HALF_WIDTH,
        order = 12,
      },
      floatingCombatTextPetMeleeDamage_v2 = {
        type = "toggle",
        name = SHOW_PET_MELEE_DAMAGE_TEXT or SHOW_PET_MELEE_DAMAGE,
        desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextPetMeleeDamage_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextPetMeleeDamage_v2", value)
          self:SetCVar("floatingCombatTextPetSpellDamage_v2", value)
        end,
        width = HALF_WIDTH,
        order = 13,
      },
      floatingCombatTextCombatDamageDirectionalScale_v2 = {
        type = "toggle",
        name = "Directional Scale",
        desc = "Directional damage numbers movement scale (disabled = no directional numbers)",
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatDamageDirectionalScale_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatDamageDirectionalScale_v2", value)
        end,
        width = HALF_WIDTH,
        order = 14,
      },
      floatingCombatTextCombatHealing_v2 = {
        type = "toggle",
        name = SHOW_COMBAT_HEALING_TEXT or SHOW_COMBAT_HEALING,
        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatHealing_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatHealing_v2", value)
        end,
        width = HALF_WIDTH,
        order = 15,
      },
      floatingCombatTextCombatHealingAbsorbTarget_v2 = {
        type = "toggle",
        name = SHOW_COMBAT_HEALING_ABSORB_TARGET .. " " .. "(Target)",
        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatHealingAbsorbTarget_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatHealingAbsorbTarget_v2", value)
        end,
        width = HALF_WIDTH,
        order = 16,
      },
      -- NOTE: Removed in 12.0?
      -- floatingCombatTextSpellMechanics = {
      --   type = "toggle",
      --   name = SHOW_TARGET_EFFECTS,
      --   desc = OPTION_TOOLTIP_SHOW_TARGET_EFFECTS,
      --   get = function()
      --     return C_CVar.GetCVarBool("floatingCombatTextSpellMechanics")
      --   end,
      --   set = function(_, value)
      --     self:SetCVar("floatingCombatTextSpellMechanics", value)
      --   end,
      --   width = HALF_WIDTH,
      --   order = 17,
      -- },
      -- floatingCombatTextSpellMechanicsOther = {
      --   type = "toggle",
      --   name = SHOW_OTHER_TARGET_EFFECTS,
      --   desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
      --   get = function()
      --     return C_CVar.GetCVarBool("floatingCombatTextSpellMechanicsOther")
      --   end,
      --   set = function(_, value)
      --     self:SetCVar("floatingCombatTextSpellMechanicsOther", value)
      --   end,
      --   width = HALF_WIDTH,
      --   order = 18,
      -- },
      WorldTextScale_v2 = {
        type = "range",
        name = "World Text Scale",
        desc = "The scale of in-world damage numbers, xp gain, artifact gains, etc",
        min = 0.5,
        max = 2.5,
        step = 0.1,
        get = function()
          return tonumber(C_CVar.GetCVar("WorldTextScale_v2"))
        end,
        set = function(_, value)
          self:SetCVar("WorldTextScale_v2", value)
        end,
        width = THIRD_WIDTH,
        order = 19,
      },
      -------------------------------------------------
      onMeHeader = {
        type = "header",
        name = "Floating Combat Text on Me",
        order = 20,
      },
      -- No 'v2' version of this
      enableFloatingCombatText = {
        type = "toggle",
        name = SHOW_COMBAT_TEXT_TEXT,
        desc = OPTION_TOOLTIP_SHOW_COMBAT_TEXT,
        get = function()
          return C_CVar.GetCVarBool("enableFloatingCombatText")
        end,
        set = function(_, value)
          self:SetCVar("enableFloatingCombatText", value)
          FCT_SetValue("enableFloatingCombatText", value)
        end,
        width = HALF_WIDTH,
        order = 21,
      },
      floatingCombatTextFloatMode_v2 = {
        type = "select",
        name = COMBAT_TEXT_FLOAT_MODE_LABEL,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_MODE,
        values = {
          ["1"] = "Scroll Up",
          ["2"] = "Scroll Down",
          ["3"] = "Arc",
        },
        sorting = {
          "1",
          "2",
          "3",
        },
        get = function()
          return C_CVar.GetCVar("floatingCombatTextFloatMode_v2")
        end,
        set = function(_, value)
          addon:SetCVar("floatingCombatTextFloatMode_v2", value)
          BlizzardOptionsPanel_UpdateCombatText()
        end,
        width = THIRD_WIDTH,
        order = 22,
      },
      floatingCombatTextDodgeParryMiss_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_DODGE_PARRY_MISS_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_DODGE_PARRY_MISS,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextDodgeParryMiss_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextDodgeParryMiss_v2", value)
          FCT_SetValue("floatingCombatTextDodgeParryMiss_v2", value)
        end,
        width = HALF_WIDTH,
        order = 23,
      },
      floatingCombatTextDamageReduction_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_RESISTANCES_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_RESISTANCES,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextDamageReduction_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextDamageReduction_v2", value)
          FCT_SetValue("floatingCombatTextDamageReduction_v2", value)
        end,
        width = HALF_WIDTH,
        order = 24,
      },
      floatingCombatTextRepChanges_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_REPUTATION_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REPUTATION,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextRepChanges_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextRepChanges_v2", value)
          FCT_SetValue("floatingCombatTextRepChanges_v2", value)
        end,
        width = HALF_WIDTH,
        order = 25,
      },
      floatingCombatTextReactives_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_REACTIVES_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REACTIVES,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextReactives_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextReactives_v2", value)
          FCT_SetValue("floatingCombatTextReactives_v2", value)
        end,
        width = HALF_WIDTH,
        order = 26,
      },
      floatingCombatTextFriendlyHealers_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_FRIENDLY_NAMES_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_FRIENDLY_NAMES,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextFriendlyHealers_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextFriendlyHealers_v2", value)
          FCT_SetValue("floatingCombatTextFriendlyHealers_v2", value)
        end,
        width = HALF_WIDTH,
        order = 27,
      },
      floatingCombatTextCombatState_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_COMBAT_STATE_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatState_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatState_v2", value)
          FCT_SetValue("floatingCombatTextCombatState_v2", value)
        end,
        width = HALF_WIDTH,
        order = 28,
      },
      floatingCombatTextCombatHealingAbsorbSelf_v2 = {
        type = "toggle",
        name = SHOW_COMBAT_HEALING_ABSORB_SELF .. " " .. "(Self)",
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextCombatHealingAbsorbSelf_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextCombatHealingAbsorbSelf_v2", value)
        end,
        width = HALF_WIDTH,
        order = 29,
      },
      floatingCombatTextLowManaHealth_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_LOW_HEALTH_MANA_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_LOW_HEALTH_MANA,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextLowManaHealth_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextLowManaHealth_v2", value)
          FCT_SetValue("floatingCombatTextLowManaHealth_v2", value)
        end,
        width = HALF_WIDTH,
        order = 30,
      },
      floatingCombatTextEnergyGains_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_ENERGIZE_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_ENERGIZE,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextEnergyGains_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextEnergyGains_v2", value)
          FCT_SetValue("floatingCombatTextEnergyGains_v2", value)
        end,
        width = HALF_WIDTH,
        order = 31,
      },
      floatingCombatTextComboPoints_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBO_POINTS,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextComboPoints_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextComboPoints_v2", value)
          FCT_SetValue("floatingCombatTextComboPoints_v2", value)
        end,
        width = HALF_WIDTH,
        order = 32,
      },
      floatingCombatTextPeriodicEnergyGains_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextPeriodicEnergyGains_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextPeriodicEnergyGains_v2", value)
          FCT_SetValue("floatingCombatTextPeriodicEnergyGains_v2", value)
        end,
        width = HALF_WIDTH,
        order = 33,
      },
      floatingCombatTextHonorGains_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_HONOR_GAINED,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextHonorGains_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextHonorGains_v2", value)
          FCT_SetValue("floatingCombatTextHonorGains_v2", value)
        end,
        width = HALF_WIDTH,
        order = 34,
      },
      floatingCombatTextAuras_v2 = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_AURAS_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_AURAS,
        get = function()
          return C_CVar.GetCVarBool("floatingCombatTextAuras_v2")
        end,
        set = function(_, value)
          self:SetCVar("floatingCombatTextAuras_v2", value)
          FCT_SetValue("floatingCombatTextAuras_v2", value)
        end,
        width = HALF_WIDTH,
        order = 35,
      },
    },
  }

  return floatingCombatTextOptions
end
