
local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25
local HALF_WIDTH = 1.5


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
                    return C_CVar.GetCVarBool("floatingCombatTextCombatDamage")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatDamage", value)
                end,
                width = HALF_WIDTH,
                order = 11,
            },
            floatingCombatTextCombatLogPeriodicSpells = {
                type = "toggle",
                name = LOG_PERIODIC_EFFECTS,
                desc = OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextCombatLogPeriodicSpells")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatLogPeriodicSpells", value)
                end,
                width = HALF_WIDTH,
                order = 12,
            },
            floatingCombatTextPetMeleeDamage = {
                type = "toggle",
                name = SHOW_PET_MELEE_DAMAGE,
                desc = OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextPetMeleeDamage")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextPetMeleeDamage", value)
                    self:SetCVar("floatingCombatTextPetSpellDamage", value)
                end,
                width = HALF_WIDTH,
                order = 13,
            },
            floatingCombatTextCombatDamageDirectionalScale = {
                type = "toggle",
                name = "Directional Scale",
                desc = "Directional damage numbers movement scale (disabled = no directional numbers)",
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextCombatDamageDirectionalScale")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatDamageDirectionalScale", value)
                end,
                width = HALF_WIDTH,
                order = 14,
            },
            floatingCombatTextCombatHealing = {
                type = "toggle",
                name = SHOW_COMBAT_HEALING,
                desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextCombatHealing")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatHealing", value)
                end,
                width = HALF_WIDTH,
                order = 15,
            },
            floatingCombatTextCombatHealingAbsorbTarget = {
                type = "toggle",
                name = SHOW_COMBAT_HEALING_ABSORB_TARGET.." ".."(Target)",
                desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextCombatHealingAbsorbTarget")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatHealingAbsorbTarget", value)
                end,
                width = HALF_WIDTH,
                order = 16,
            },
            floatingCombatTextSpellMechanics = {
                type = "toggle",
                name = SHOW_TARGET_EFFECTS,
                desc = OPTION_TOOLTIP_SHOW_TARGET_EFFECTS,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextSpellMechanics")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextSpellMechanics", value)
                end,
                width = HALF_WIDTH,
                order = 17,
            },
            floatingCombatTextSpellMechanicsOther = {
                type = "toggle",
                name = SHOW_OTHER_TARGET_EFFECTS,
                desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextSpellMechanicsOther")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextSpellMechanicsOther", value)
                end,
                width = HALF_WIDTH,
                order = 18,
            },
            WorldTextScale = {
                type = "range",
                name = "World Text Scale",
                desc = "The scale of in-world damage numbers, xp gain, artifact gains, etc",
                min = 0.5,
                max = 2.5,
                step = 0.1,
                get = function()
                    return tonumber(C_CVar.GetCVar("WorldTextScale"))
                end,
                set = function(_, value)
                    self:SetCVar("WorldTextScale", value)
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
                    return C_CVar.GetCVarBool("enableFloatingCombatText")
                end,
                set = function(_, value)
                    self:SetCVar("enableFloatingCombatText", value)
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
                    return C_CVar.GetCVar("floatingCombatTextFloatMode")
                end,
                set = function(_, value)
                    addon:SetCVar("floatingCombatTextFloatMode", value)
                end,
                width = THIRD_WIDTH,
                order = 22,
            },
            floatingCombatTextDodgeParryMiss = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_DODGE_PARRY_MISS_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_DODGE_PARRY_MISS,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextDodgeParryMiss")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextDodgeParryMiss", value)
                end,
                width = HALF_WIDTH,
                order = 23,
            },
            floatingCombatTextDamageReduction = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_RESISTANCES_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_RESISTANCES,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextDamageReduction")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextDamageReduction", value)
                end,
                width = HALF_WIDTH,
                order = 24,
            },
            floatingCombatTextRepChanges = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_REPUTATION_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REPUTATION,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextRepChanges")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextRepChanges", value)
                end,
                width = HALF_WIDTH,
                order = 25,
            },
            floatingCombatTextReactives = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_REACTIVES_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REACTIVES,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextReactives")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextReactives", value)
                end,
                width = HALF_WIDTH,
                order = 26,
            },
            floatingCombatTextFriendlyHealers = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_FRIENDLY_NAMES_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_FRIENDLY_NAMES,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextFriendlyHealers")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextFriendlyHealers", value)
                end,
                width = HALF_WIDTH,
                order = 27,
            },
            floatingCombatTextCombatState = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_COMBAT_STATE_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextCombatState")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatState", value)
                end,
                width = HALF_WIDTH,
                order = 28,
            },
            floatingCombatTextCombatHealingAbsorbSelf = {
                type = "toggle",
                name = SHOW_COMBAT_HEALING_ABSORB_SELF.." ".."(Self)",
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextCombatHealingAbsorbSelf")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextCombatHealingAbsorbSelf", value)
                end,
                width = HALF_WIDTH,
                order = 29,
            },
            floatingCombatTextLowManaHealth = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_LOW_HEALTH_MANA_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_LOW_HEALTH_MANA,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextLowManaHealth")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextLowManaHealth", value)
                end,
                width = HALF_WIDTH,
                order = 30,
            },
            floatingCombatTextEnergyGains = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_ENERGIZE_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_ENERGIZE,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextEnergyGains")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextEnergyGains", value)
                end,
                width = HALF_WIDTH,
                order = 31,
            },
            floatingCombatTextComboPoints = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBO_POINTS,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextComboPoints")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextComboPoints", value)
                end,
                width = HALF_WIDTH,
                order = 32,
            },
            floatingCombatTextPeriodicEnergyGains = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextPeriodicEnergyGains")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextPeriodicEnergyGains", value)
                end,
                width = HALF_WIDTH,
                order = 33,
            },
            floatingCombatTextHonorGains = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_HONOR_GAINED,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextHonorGains")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextHonorGains", value)
                end,
                width = HALF_WIDTH,
                order = 34,
            },
            floatingCombatTextAuras = {
                type = "toggle",
                name = COMBAT_TEXT_SHOW_AURAS_TEXT,
                desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_AURAS,
                get = function()
                    return C_CVar.GetCVarBool("floatingCombatTextAuras")
                end,
                set = function(_, value)
                    self:SetCVar("floatingCombatTextAuras", value)
                end,
                width = HALF_WIDTH,
                order = 35,
            },
        }
    }

    return floatingCombatTextOptions
end
