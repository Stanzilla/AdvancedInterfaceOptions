
local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25

local maxCameraZoomFactor
if addon.IsClassicEra() then
    maxCameraZoomFactor = 3.4
else
    maxCameraZoomFactor = 2.6
end

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
                width="full",
                order = 2,
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
                width="full",
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
                width="full",
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
                width="full",
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
                disabled = function()
                    return self.IsClassicEra()
                end,
                width="full",
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
                width="full",
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
                width="full",
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
                width="full",
                order = 17,
            },
            reverseCleanupBags = {
                type = "toggle",
                name = REVERSE_CLEAN_UP_BAGS_TEXT,
                desc = OPTION_TOOLTIP_REVERSE_CLEAN_UP_BAGS,
                get = function()
                    if C_Container and C_Container.GetSortBagsRightToLeft then
                        return C_Container.GetSortBagsRightToLeft()
                    else
                        return false
                    end
                end,
                set = function(_, value)
                    C_Container.SetSortBagsRightToLeft(value)
                end,
                width="full",
                order = 18,
            },
            lootLeftmostBag = {
                type = "toggle",
                name = REVERSE_NEW_LOOT_TEXT,
                desc = OPTION_TOOLTIP_REVERSE_NEW_LOOT,
                get = function()
                    if C_Container and C_Container.GetInsertItemsLeftToRight then
                        return C_Container.GetInsertItemsLeftToRight()
                    else
                        return false
                    end
                end,
                set = function(_, value)
                    C_Container.SetInsertItemsLeftToRight(value)
                end,
                disabled = function()
                    return self.IsClassicEra()
                end,
                width="full",
                order = 19,
            },
            enableWoWMouse = {
                type = "toggle",
                name = WOW_MOUSE,
                desc = OPTION_TOOLTIP_WOW_MOUSE,
                get = function()
                    return C_CVar.GetCVarBool("enableWoWMouse")
                end,
                set = function(_, value)
                    self:SetCVar("enableWoWMouse", value)
                end,
                width="full",
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
            actionCam = {
                type = "select",
                name = "Select Action Cam mode:",
                desc = "Select the mode for the Action Cam.",
                values = {
                    ["default"] = "Default",
                    ["on"] = "On",
                    ["basic"] = "Basic",
                    ["full"] = "Full",
                },
                sorting = {
                    "default",
                    "on",
                    "basic",
                    "full",
                },
                get = function()
                    return self.getActionCamMode()
                end,
                set = function(_, value)
                    ConsoleExec("actioncam".." "..value)
                end,
                width = THIRD_WIDTH,
                order = 32,
            },
            --TODO: This might need more work for classic
            cameraDistanceMaxZoomFactor = {
                type = "range",
                name = MAX_FOLLOW_DIST,
                desc = OPTION_TOOLTIP_MAX_FOLLOW_DIST,
                min = 1,
                max = maxCameraZoomFactor,
                step = 0.1,
                get = function()
                    return tonumber(C_CVar.GetCVar("cameraDistanceMaxZoomFactor"))
                end,
                set = function(_, value)
                    self:SetCVar("cameraDistanceMaxZoomFactor", value)
                end,
                width = THIRD_WIDTH,
                order = 33,
            },
            -------------------------------------------------
            dataHeader = {
                type = "header",
                name = "",
                order = 40,
            },
            backupSettings = {
                type = 'execute',
                name = "Backup Settings",
                func = function()
                    StaticPopup_Show("AIO_BACKUP_SETTINGS")
                end,
                width = THIRD_WIDTH,
                order = 41,
            },
            restoreSettings = {
                type = 'execute',
                name = "Restore Settings",
                func = function()
                    StaticPopup_Show("AIO_RESTORE_SETTINGS")
                end,
                width = THIRD_WIDTH,
                order = 43,
            },
            resetSettings = {
                type = 'execute',
                name = "Reset Settings",
                func = function()
                    StaticPopup_Show("AIO_RESET_EVERYTHING")
                end,
                width = THIRD_WIDTH,
                order = 43,
            },
        }
    }

    return generalOptions
end
