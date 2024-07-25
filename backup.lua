
local function getCustomVar(self)
    return AdvancedInterfaceOptionsSaved.CustomVars[self.cvar]
end

local function setCustomVar(self, value)
    AdvancedInterfaceOptionsSaved.CustomVars[self.cvar] = value
end


-- UVARINFO was made local in patch 8.2.0
--[[local uvars = {
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
}]]

--local function FCT_SetValue(self, checked)
--    addon:SetCVar(self.cvar, checked)
--    _G[uvars[self.cvar]] = checked and "1" or "0"
--    BlizzardOptionsPanel_UpdateCombatText()
--end


-- Status Text section
local AIO_ST = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_ST:Hide()
AIO_ST:SetAllPoints()
AIO_ST.name = STATUSTEXT_LABEL
AIO_ST.parent = addonName

local Title_ST = AIO_ST:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_ST:SetJustifyV('TOP')
Title_ST:SetJustifyH('LEFT')
Title_ST:SetPoint('TOPLEFT', 16, -16)
Title_ST:SetText(AIO_ST.name)

local SubText_ST = AIO_ST:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_ST:SetMaxLines(3)
SubText_ST:SetNonSpaceWrap(true)
SubText_ST:SetJustifyV('TOP')
SubText_ST:SetJustifyH('LEFT')
SubText_ST:SetPoint('TOPLEFT', Title_ST, 'BOTTOMLEFT', 0, -8)
SubText_ST:SetPoint('RIGHT', -32, 0)
SubText_ST:SetText(STATUSTEXT_SUBTEXT)

local function setStatusTextBars(frame, value)
    frame.healthbar.cvar = value
    frame.manabar.cvar = value
    TextStatusBar_UpdateTextString(frame.healthbar)
    TextStatusBar_UpdateTextString(frame.manabar)
end

statusTextOptions = {
    playerStatusText = function(value)
        setStatusTextBars(PlayerFrame, value)
    end,
    petStatusText = function(value)
        setStatusTextBars(PetFrame, value)
    end,
    partyStatusText = function(value)
        for i = 1, MAX_PARTY_MEMBERS do
            setStatusTextBars(_G["PartyMemberFrame"..i], value)
        end
    end,
    targetStatusText = function(value)
        setStatusTextBars(TargetFrame, value)
    end,
    alternateResourceText = function(value)
        PlayerFrameAlternateManaBar.cvar = value
        TextStatusBar_UpdateTextString(PlayerFrameAlternateManaBar)
    end,
}

local function setStatusText(self, value)
    setCustomVar(self, value)
    statusTextOptions[self.cvar](value and "statusText")
end

local stPlayer = newCheckbox(AIO_ST, 'playerStatusText', getCustomVar, setStatusText)
local stPet = newCheckbox(AIO_ST, 'petStatusText', getCustomVar, setStatusText)
local stParty = newCheckbox(AIO_ST, 'partyStatusText', getCustomVar, setStatusText)
local stTarget = newCheckbox(AIO_ST, 'targetStatusText', getCustomVar, setStatusText)
local stAltResource = newCheckbox(AIO_ST, 'alternateResourceText', getCustomVar, setStatusText)
local stXpBar = newCheckbox(AIO_ST, 'xpBarText', nil, function(self, checked)
    checkboxSetCVar(self, checked)
    TextStatusBar_UpdateTextString(MainMenuExpBar)
end)

local stToggleStatusText = newCheckbox(AIO_ST, 'statusText',
    function(self) -- getter
        local value = checkboxGetCVar(self)
        stPlayer:SetEnabled(value)
        stPet:SetEnabled(value)
        stParty:SetEnabled(value)
        stTarget:SetEnabled(value)
        stAltResource:SetEnabled(value)
        stXpBar:SetEnabled(value)
        return value
    end,
    function(self, value) -- setter
        addon:SetCVar('statusText', value, 'STATUS_TEXT_DISPLAY') -- forces text on status bars to update
        stPlayer:SetEnabled(value)
        stPet:SetEnabled(value)
        stParty:SetEnabled(value)
        stTarget:SetEnabled(value)
        stAltResource:SetEnabled(value)
        stXpBar:SetEnabled(value)
    end
)

stToggleStatusText:SetPoint("TOPLEFT", SubText_ST, "BOTTOMLEFT", 0, -8)
stPlayer:SetPoint("TOPLEFT", stToggleStatusText, "BOTTOMLEFT", 10, -4)
stPet:SetPoint("TOPLEFT", stPlayer, "BOTTOMLEFT", 0, -4)
stParty:SetPoint("TOPLEFT", stPet, "BOTTOMLEFT", 0, -4)
stTarget:SetPoint("TOPLEFT", stParty, "BOTTOMLEFT", 0, -4)
stAltResource:SetPoint("TOPLEFT", stTarget, "BOTTOMLEFT", 0, -4)
stXpBar:SetPoint("TOPLEFT", stAltResource, "BOTTOMLEFT", 0, -4)

local function stTextDisplaySetValue(self)
    addon:SetCVar('statusTextDisplay', self.value, 'STATUS_TEXT_DISPLAY')
end

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

