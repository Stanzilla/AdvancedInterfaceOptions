
local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25


-------------------------------------------------------------------------
-------------------------------------------------------------------------

local statusTextVals = {
    playerStatusText = function(value)
        addon.setStatusTextBars(PlayerFrame, value)
    end,
    petStatusText = function(value)
        addon.setStatusTextBars(PetFrame, value)
    end,
    --TODO: This appears to be deprecated
    partyStatusText = function(value)
        for i = 1, MAX_PARTY_MEMBERS do
            addon.setStatusTextBars(_G["PartyMemberFrame"..i], value)
        end
    end,
    targetStatusText = function(value)
        addon.setStatusTextBars(TargetFrame, value)
    end,
    alternateResourceText = function(value)
        PlayerFrameAlternateManaBar.cvar = value
        if not addon.IsClassicEra() and not addon.IsClassic() then
            PlayerFrameAlternateManaBar:UpdateTextString()
        else
            TextStatusBar_UpdateTextString(PlayerFrameAlternateManaBar)
        end
    end,
    xpBarText = function(value)
        MainMenuExpBar.cvar = value
        if not addon.IsClassicEra() and not addon.IsClassic() then
            MainMenuExpBar:UpdateTextString()
        else
            TextStatusBar_UpdateTextString(MainMenuExpBar)
        end
    end,
}

function addon.setStatusTextBars(frame, value)
    frame.healthbar.cvar = value
    frame.manabar.cvar = value
    if not addon.IsClassicEra() and not addon.IsClassic() then
        frame.healthbar:UpdateTextString()
        frame.manabar:UpdateTextString()
    else
        TextStatusBar_UpdateTextString(frame.healthbar)
        TextStatusBar_UpdateTextString(frame.manabar)
    end
end

function addon.setStatusText(cvar, value)
    addon.setCustomVar(cvar, value)
    statusTextVals[cvar](value and "statusText")
end

--[[
for k, v in pairs(AdvancedInterfaceOptionsSaved.CustomVars) do
    if statusTextOptions[k] then
        statusTextOptions[k](v and "statusText")
    end
end
--]]

--[[local function stTextDisplaySetValue(self)
    addon:SetCVar('statusTextDisplay', self.value, 'STATUS_TEXT_DISPLAY')
end]]

-- TODO: figure out why the built-in tooltipTitle and tooltipText attributes don't work
-- local stTextDisplay = addon:CreateDropdown(AIO_ST, 130, {
-- 	{text = STATUS_TEXT_VALUE, value = 'NUMERIC', func = stTextDisplaySetValue},
-- 	{text = STATUS_TEXT_PERCENT, value = 'PERCENT', func = stTextDisplaySetValue},
-- 	{text = STATUS_TEXT_BOTH, value = 'BOTH', func = stTextDisplaySetValue},
-- })
-- stTextDisplay:SetPoint('LEFT', stToggleStatusText, 'RIGHT', 100, -2)
-- stTextDisplay:HookScript('OnShow', function(self) self:SetValue(GetCVar('statusTextDisplay')) end)
-- stTextDisplay:HookScript("OnEnter", function(self)
-- 	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
-- 	GameTooltip:SetText(OPTION_TOOLTIP_STATUS_TEXT_DISPLAY, nil, nil, nil, nil, true)
-- end)
-- stTextDisplay:HookScript("OnLeave", GameTooltip_Hide)

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateStatusTextOptions()
    local statusTextOptions = {
        type = "group",
        childGroups = "tree",
        name = STATUSTEXT_LABEL,
        args = {
            instructions = {
                type = "description",
                name = STATUSTEXT_SUBTEXT,
                fontSize = "medium",
                order = 1,
            },
            header = {
                type = "header",
                name = "",
                order = 10,
            },
            -------------------------------------------------
            statusText = {
                type = "toggle",
                name = STATUS_TEXT,
                desc = "Whether the status bars show numeric health/mana values",
                get = function()
                    return self.getCustomVar("statusText")
                end,
                set = function(_, value)
                    self.setCustomVar("statusText", value)
                end,
                width="full",
                order = 11,
            },
            playerStatusText = {
                type = "toggle",
                name = STATUS_TEXT_PLAYER,
                desc = OPTION_TOOLTIP_STATUS_TEXT_PLAYER,
                get = function()
                    return self.getCustomVar("playerStatusText")
                end,
                set = function(_, value)
                    self.setStatusText("playerStatusText", value)
                end,
                disabled = function()
                    return not self.getCustomVar("statusText")
                end,
                width="full",
                order = 12,
            },
            petStatusText = {
                type = "toggle",
                name = STATUS_TEXT_PET,
                desc = OPTION_TOOLTIP_STATUS_TEXT_PET,
                get = function()
                    return self.getCustomVar("petStatusText")
                end,
                set = function(_, value)
                    self.setStatusText("petStatusText", value)
                end,
                disabled = function()
                    return not self.getCustomVar("statusText")
                end,
                width="full",
                order = 13,
            },
            partyStatusText = {
                type = "toggle",
                name = STATUS_TEXT_PARTY,
                desc = OPTION_TOOLTIP_STATUS_TEXT_PARTY,
                get = function()
                    return self.getCustomVar("partyStatusText")
                end,
                set = function(_, value)
                    self.setStatusText("partyStatusText", value)
                end,
                disabled = function()
                    return not self.getCustomVar("statusText")
                end,
                hidden = function()
                    -- Frames only exists on Classic and Classic_Era
                    return not PartyMemberFrame1
                end,
                width="full",
                order = 14,
            },
            targetStatusText = {
                type = "toggle",
                name = STATUS_TEXT_TARGET,
                desc = OPTION_TOOLTIP_STATUS_TEXT_TARGET,
                get = function()
                    return self.getCustomVar("targetStatusText")
                end,
                set = function(_, value)
                    self.setStatusText("targetStatusText", value)
                end,
                disabled = function()
                    return not self.getCustomVar("statusText")
                end,
                width="full",
                order = 15,
            },
            alternateResourceText = {
                type = "toggle",
                name = ALTERNATE_RESOURCE_TEXT,
                desc = OPTION_TOOLTIP_ALTERNATE_RESOURCE,
                get = function()
                    return self.getCustomVar("alternateResourceText")
                end,
                set = function(_, value)
                    self.setStatusText("alternateResourceText", value)
                end,
                disabled = function()
                    return not self.getCustomVar("statusText")
                end,
                hidden = function()
                    -- Frame only exists on Classic and Classic_Era
                    return not PlayerFrameAlternateManaBar
                end,
                width="full",
                order = 16,
            },
            xpBarText = {
                type = "toggle",
                name = XP_BAR_TEXT,
                desc = OPTION_TOOLTIP_XP_BAR,
                get = function()
                    return self.getCustomVar("xpBarText")
                end,
                set = function(_, value)
                    self.setStatusText("xpBarText", value)
                end,
                disabled = function()
                    return not self.getCustomVar("statusText")
                end,
                hidden = function()
                    -- Frame only exists on Classic and Classic_Era
                    return not MainMenuExpBar
                end,
                width="full",
                order = 17,
            },
        }
    }

    return statusTextOptions
end
