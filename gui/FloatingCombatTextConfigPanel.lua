local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25
local HALF_WIDTH = 1.5

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- UVARINFO was made local in patch 8.2.0
-- FIXME: These globals don't seem to exist in 12.0.0
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

local function FCT_SetValue(cvar, value)
  if uvars[cvar] and _G[uvars[cvar]] then
    _G[uvars[cvar]] = value and "1" or "0"
    BlizzardOptionsPanel_UpdateCombatText()
  end
end

-- For 12.0: Append "_v2" to any cvars that need it while supporting backwards compatibility
local function GetCVarBool_v2(cvar)
  if addon:CVarExists(cvar .. "_v2") then
    cvar = cvar .. "_v2"
  end
  return C_CVar.GetCVarBool(cvar)
end

local function GetCVar_v2(cvar)
  if addon:CVarExists(cvar .. "_v2") then
    cvar = cvar .. "_v2"
  end
  return C_CVar.GetCVar(cvar)
end

local function SetCVar_v2(cvar, value)
  if addon:CVarExists(cvar .. "_v2") then
    cvar = cvar .. "_v2"
  end
  local result = addon:SetCVar(cvar, value)
  -- FIXME: Required to get combat text settings to actually apply when changed
  if C_CVar.GetCVarBool("enableFloatingCombatText") then
    addon:SetCVar("enableFloatingCombatText", 0)
    addon:SetCVar("enableFloatingCombatText", 1)
  end
  return result
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
      floatingCombatTextCombatDamage = {
        type = "toggle",
        name = SHOW_DAMAGE_TEXT,
        desc = OPTION_TOOLTIP_SHOW_DAMAGE,
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatDamage")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatDamage", value)
        end,
        width = HALF_WIDTH,
        order = 11,
      },
      floatingCombatTextCombatLogPeriodicSpells = {
        type = "toggle",
        name = LOG_PERIODIC_EFFECTS_TEXT or LOG_PERIODIC_EFFECTS,
        desc = OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS,
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatLogPeriodicSpells")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatLogPeriodicSpells", value)
        end,
        width = HALF_WIDTH,
        order = 12,
      },
      floatingCombatTextPetMeleeDamage = {
        type = "toggle",
        name = SHOW_PET_MELEE_DAMAGE_TEXT or SHOW_PET_MELEE_DAMAGE,
        desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
        get = function()
          return GetCVarBool_v2("floatingCombatTextPetMeleeDamage")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextPetMeleeDamage", value)
          SetCVar_v2("floatingCombatTextPetSpellDamage", value)
        end,
        width = HALF_WIDTH,
        order = 13,
      },
      floatingCombatTextCombatDamageDirectionalScale = {
        type = "toggle",
        name = "Directional Scale",
        desc = "Directional damage numbers movement scale (disabled = no directional numbers)",
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatDamageDirectionalScale")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatDamageDirectionalScale", value)
        end,
        width = HALF_WIDTH,
        order = 14,
      },
      floatingCombatTextCombatHealing = {
        type = "toggle",
        name = SHOW_COMBAT_HEALING_TEXT or SHOW_COMBAT_HEALING,
        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING,
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatHealing")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatHealing", value)
        end,
        width = HALF_WIDTH,
        order = 15,
      },
      floatingCombatTextCombatHealingAbsorbTarget = {
        type = "toggle",
        name = SHOW_COMBAT_HEALING_ABSORB_TARGET .. " " .. "(Target)",
        desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET,
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatHealingAbsorbTarget")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatHealingAbsorbTarget", value)
        end,
        width = HALF_WIDTH,
        order = 16,
      },
      -- FIXME: Removed in 12.0, but we should show for other versions of the game
      -- floatingCombatTextSpellMechanics = {
      --   type = "toggle",
      --   name = SHOW_TARGET_EFFECTS,
      --   desc = OPTION_TOOLTIP_SHOW_TARGET_EFFECTS,
      --   get = function()
      --     return GetCVarBool("floatingCombatTextSpellMechanics")
      --   end,
      --   set = function(_, value)
      --     SetCVarV2("floatingCombatTextSpellMechanics", value)
      --   end,
      --   width = HALF_WIDTH,
      --   order = 17,
      -- },
      -- floatingCombatTextSpellMechanicsOther = {
      --   type = "toggle",
      --   name = SHOW_OTHER_TARGET_EFFECTS,
      --   desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
      --   get = function()
      --     return GetCVarBool("floatingCombatTextSpellMechanicsOther")
      --   end,
      --   set = function(_, value)
      --     SetCVarV2("floatingCombatTextSpellMechanicsOther", value)
      --   end,
      --   width = HALF_WIDTH,
      --   order = 18,
      -- },
      WorldTextScale = {
        type = "range",
        name = "World Text Scale",
        desc = "The scale of in-world damage numbers, xp gain, artifact gains, etc",
        min = 0.5,
        max = 2.5,
        step = 0.1,
        get = function()
          return tonumber(GetCVar_v2("WorldTextScale"))
        end,
        set = function(_, value)
          SetCVar_v2("WorldTextScale", value)
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
      enableFloatingCombatText = {
        type = "toggle",
        name = SHOW_COMBAT_TEXT_TEXT,
        desc = OPTION_TOOLTIP_SHOW_COMBAT_TEXT,
        get = function()
          -- No 'v2' version of this
          return C_CVar.GetCVarBool("enableFloatingCombatText")
        end,
        set = function(_, value)
          self:SetCVar("enableFloatingCombatText", value)
          FCT_SetValue("enableFloatingCombatText", value)
        end,
        width = HALF_WIDTH,
        order = 21,
      },
      floatingCombatTextFloatMode = {
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
          return GetCVar_v2("floatingCombatTextFloatMode")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextFloatMode", value)
          BlizzardOptionsPanel_UpdateCombatText()
        end,
        width = THIRD_WIDTH,
        order = 22,
      },
      floatingCombatTextDodgeParryMiss = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_DODGE_PARRY_MISS_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_DODGE_PARRY_MISS,
        get = function()
          return GetCVarBool_v2("floatingCombatTextDodgeParryMiss")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextDodgeParryMiss", value)
          FCT_SetValue("floatingCombatTextDodgeParryMiss", value)
        end,
        width = HALF_WIDTH,
        order = 23,
      },
      floatingCombatTextDamageReduction = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_RESISTANCES_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_RESISTANCES,
        get = function()
          return GetCVarBool_v2("floatingCombatTextDamageReduction")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextDamageReduction", value)
          FCT_SetValue("floatingCombatTextDamageReduction", value)
        end,
        width = HALF_WIDTH,
        order = 24,
      },
      floatingCombatTextRepChanges = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_REPUTATION_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REPUTATION,
        get = function()
          return GetCVarBool_v2("floatingCombatTextRepChanges")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextRepChanges", value)
          FCT_SetValue("floatingCombatTextRepChanges", value)
        end,
        width = HALF_WIDTH,
        order = 25,
      },
      floatingCombatTextReactives = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_REACTIVES_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REACTIVES,
        get = function()
          return GetCVarBool_v2("floatingCombatTextReactives")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextReactives", value)
          FCT_SetValue("floatingCombatTextReactives", value)
        end,
        width = HALF_WIDTH,
        order = 26,
      },
      floatingCombatTextFriendlyHealers = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_FRIENDLY_NAMES_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_FRIENDLY_NAMES,
        get = function()
          return GetCVarBool_v2("floatingCombatTextFriendlyHealers")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextFriendlyHealers", value)
          FCT_SetValue("floatingCombatTextFriendlyHealers", value)
        end,
        width = HALF_WIDTH,
        order = 27,
      },
      floatingCombatTextCombatState = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_COMBAT_STATE_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE,
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatState")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatState", value)
          FCT_SetValue("floatingCombatTextCombatState", value)
        end,
        width = HALF_WIDTH,
        order = 28,
      },
      floatingCombatTextCombatHealingAbsorbSelf = {
        type = "toggle",
        name = SHOW_COMBAT_HEALING_ABSORB_SELF .. " " .. "(Self)",
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE,
        get = function()
          return GetCVarBool_v2("floatingCombatTextCombatHealingAbsorbSelf")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextCombatHealingAbsorbSelf", value)
        end,
        width = HALF_WIDTH,
        order = 29,
      },
      floatingCombatTextLowManaHealth = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_LOW_HEALTH_MANA_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_LOW_HEALTH_MANA,
        get = function()
          return GetCVarBool_v2("floatingCombatTextLowManaHealth")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextLowManaHealth", value)
          FCT_SetValue("floatingCombatTextLowManaHealth", value)
        end,
        width = HALF_WIDTH,
        order = 30,
      },
      floatingCombatTextEnergyGains = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_ENERGIZE_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_ENERGIZE,
        get = function()
          return GetCVarBool_v2("floatingCombatTextEnergyGains")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextEnergyGains", value)
          FCT_SetValue("floatingCombatTextEnergyGains", value)
        end,
        width = HALF_WIDTH,
        order = 31,
      },
      floatingCombatTextComboPoints = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBO_POINTS,
        get = function()
          return GetCVarBool_v2("floatingCombatTextComboPoints")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextComboPoints", value)
          FCT_SetValue("floatingCombatTextComboPoints", value)
        end,
        width = HALF_WIDTH,
        order = 32,
      },
      floatingCombatTextPeriodicEnergyGains = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE,
        get = function()
          return GetCVarBool_v2("floatingCombatTextPeriodicEnergyGains")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextPeriodicEnergyGains", value)
          FCT_SetValue("floatingCombatTextPeriodicEnergyGains", value)
        end,
        width = HALF_WIDTH,
        order = 33,
      },
      floatingCombatTextHonorGains = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_HONOR_GAINED,
        get = function()
          return GetCVarBool_v2("floatingCombatTextHonorGains")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextHonorGains", value)
          FCT_SetValue("floatingCombatTextHonorGains", value)
        end,
        width = HALF_WIDTH,
        order = 34,
      },
      floatingCombatTextAuras = {
        type = "toggle",
        name = COMBAT_TEXT_SHOW_AURAS_TEXT,
        desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_AURAS,
        get = function()
          return GetCVarBool_v2("floatingCombatTextAuras")
        end,
        set = function(_, value)
          SetCVar_v2("floatingCombatTextAuras", value)
          FCT_SetValue("floatingCombatTextAuras", value)
        end,
        width = HALF_WIDTH,
        order = 35,
      },
    },
  }

  return floatingCombatTextOptions
end
