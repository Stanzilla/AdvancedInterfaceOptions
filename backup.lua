
-- Chat section
local AIO_Chat = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_Chat:Hide()
AIO_Chat:SetAllPoints()
AIO_Chat.name = "Chat"
AIO_Chat.parent = addonName

local Title_Chat = AIO_Chat:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_Chat:SetJustifyV('TOP')
Title_Chat:SetJustifyH('LEFT')
Title_Chat:SetPoint('TOPLEFT', 16, -16)
Title_Chat:SetText(AIO_Chat.name)

local SubText_Chat = AIO_Chat:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_Chat:SetMaxLines(3)
SubText_Chat:SetNonSpaceWrap(true)
SubText_Chat:SetJustifyV('TOP')
SubText_Chat:SetJustifyH('LEFT')
SubText_Chat:SetPoint('TOPLEFT', Title_Chat, 'BOTTOMLEFT', 0, -8)
SubText_Chat:SetPoint('RIGHT', -32, 0)
SubText_Chat:SetText('These options allow you to modify various chat settings that are no longer part of the default UI.')

local chatMouseScroll = newCheckbox(AIO_Chat, 'chatMouseScroll')
local chatDelay = newCheckbox(AIO_Chat, 'removeChatDelay')
chatDelay:SetPoint('TOPLEFT', SubText_Chat, 'BOTTOMLEFT', 0, -8)
chatMouseScroll:SetPoint('TOPLEFT', chatDelay, 'BOTTOMLEFT', 0, -4)

if IsClassic() then
    local classColors = newCheckbox(AIO_Chat, 'chatClassColorOverride')
    classColors:SetPoint('TOPLEFT', chatMouseScroll, 'BOTTOMLEFT', 0, -4)
end

-- Floating Combat Text section
local AIO_FCT = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_FCT:Hide()
AIO_FCT:SetAllPoints()
AIO_FCT.name = FLOATING_COMBATTEXT_LABEL
AIO_FCT.parent = addonName

local Title_FCT = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_FCT:SetJustifyV('TOP')
Title_FCT:SetJustifyH('LEFT')
Title_FCT:SetPoint('TOPLEFT', 16, -16)
Title_FCT:SetText(AIO_FCT.name)

local SubText_FCT = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_FCT:SetMaxLines(3)
SubText_FCT:SetNonSpaceWrap(true)
SubText_FCT:SetJustifyV('TOP')
SubText_FCT:SetJustifyH('LEFT')
SubText_FCT:SetPoint('TOPLEFT', Title_FCT, 'BOTTOMLEFT', 0, -8)
SubText_FCT:SetPoint('RIGHT', -32, 0)
SubText_FCT:SetText(COMBATTEXT_SUBTEXT)

local fctfloatmodeDropdown = CreateFrame("Frame", "AIOfctFloatMode", AIO_FCT, "UIDropDownMenuTemplate")
fctfloatmodeDropdown.initialize = function(dropdown)
    local floatMode = { COMBAT_TEXT_SCROLL_UP, COMBAT_TEXT_SCROLL_DOWN, COMBAT_TEXT_SCROLL_ARC }
    for i, mode in next, floatMode do
        local info = UIDropDownMenu_CreateInfo()
        info.text = floatMode[i]
        info.value = tostring(i)
        info.func = function(self)
            addon:SetCVar("floatingCombatTextFloatMode", self.value)
            UIDropDownMenu_SetSelectedValue(dropdown, self.value)
            COMBAT_TEXT_FLOAT_MODE = self.value
            BlizzardOptionsPanel_UpdateCombatText()
        end
        UIDropDownMenu_AddButton(info)
    end
    UIDropDownMenu_SetSelectedValue(dropdown, GetCVar("floatingCombatTextFloatMode"))
end
fctfloatmodeDropdown:HookScript("OnShow", fctfloatmodeDropdown.initialize)
fctfloatmodeDropdown:HookScript("OnEnter", function(self)
    if not self.isDisabled then
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
        GameTooltip:SetText(OPTION_TOOLTIP_COMBAT_TEXT_MODE, nil, nil, nil, nil, true)
    end
end)
fctfloatmodeDropdown:HookScript("OnLeave", GameTooltip_Hide)
Widgets[ fctfloatmodeDropdown ] = 'floatingCombatTextFloatMode'

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

local function FCT_SetValue(self, checked)
    addon:SetCVar(self.cvar, checked)
    _G[uvars[self.cvar]] = checked and "1" or "0"
    BlizzardOptionsPanel_UpdateCombatText()
end

local fctAbsorbTarget = newCheckbox(AIO_FCT, 'floatingCombatTextCombatHealingAbsorbTarget')
local fctDamage = newCheckbox(AIO_FCT, 'floatingCombatTextCombatDamage')
local fctDirectionalScale = newCheckbox(AIO_FCT, 'floatingCombatTextCombatDamageDirectionalScale')
local fctHealing = newCheckbox(AIO_FCT, 'floatingCombatTextCombatHealing')
local fctPeriodicSpells = newCheckbox(AIO_FCT, 'floatingCombatTextCombatLogPeriodicSpells')
local fctPetMeleeDamage = newCheckbox(AIO_FCT, 'floatingCombatTextPetMeleeDamage', nil, function(self, checked)
    checkboxSetCVar(self, checked)
    addon:SetCVar('floatingCombatTextPetSpellDamage', checked)
end)
local fctSpellMechanics = newCheckbox(AIO_FCT, 'floatingCombatTextSpellMechanics')
local fctSpellMechanicsOther = newCheckbox(AIO_FCT, 'floatingCombatTextSpellMechanicsOther')
local worldTextScale = newSlider(AIO_FCT, 'WorldTextScale', 0.5, 2.5, 0.1)

local enablefct = newCheckbox(AIO_FCT, 'enableFloatingCombatText', nil, FCT_SetValue)
local fctAbsorbSelf = newCheckbox(AIO_FCT, 'floatingCombatTextCombatHealingAbsorbSelf')
local fctAuras = newCheckbox(AIO_FCT, 'floatingCombatTextAuras', nil, FCT_SetValue)
local fctCombatState = newCheckbox(AIO_FCT, 'floatingCombatTextCombatState', nil, FCT_SetValue)
local fctComboPoints = newCheckbox(AIO_FCT, 'floatingCombatTextComboPoints', nil, FCT_SetValue)
local fctDamageReduction = newCheckbox(AIO_FCT, 'floatingCombatTextDamageReduction', nil, FCT_SetValue)
local fctDodgeParryMiss = newCheckbox(AIO_FCT, 'floatingCombatTextDodgeParryMiss', nil, FCT_SetValue)
local fctEnergyGains = newCheckbox(AIO_FCT, 'floatingCombatTextEnergyGains', nil, FCT_SetValue)
local fctFriendlyHealer = newCheckbox(AIO_FCT, 'floatingCombatTextFriendlyHealers', nil, FCT_SetValue)
local fctHonorGains = newCheckbox(AIO_FCT, 'floatingCombatTextHonorGains', nil, FCT_SetValue)
local fctLowHPMana = newCheckbox(AIO_FCT, 'floatingCombatTextLowManaHealth', nil, FCT_SetValue)
local fctPeriodicEnergyGains = newCheckbox(AIO_FCT, 'floatingCombatTextPeriodicEnergyGains', nil, FCT_SetValue)
local fctReactives = newCheckbox(AIO_FCT, 'floatingCombatTextReactives', nil, FCT_SetValue)
local fctRepChanges = newCheckbox(AIO_FCT, 'floatingCombatTextRepChanges', nil, FCT_SetValue)

local fctTargetLabel = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
fctTargetLabel:SetText(FLOATING_COMBAT_TARGET_LABEL)
fctTargetLabel:SetPoint('TOPLEFT', SubText_FCT, 'BOTTOMLEFT', 0, -25)

fctDamage:SetPoint("TOPLEFT", fctTargetLabel, "BOTTOMLEFT", 0, -6)
fctPeriodicSpells:SetPoint("TOPLEFT", fctDamage, "BOTTOMLEFT", 10, 0)
fctPetMeleeDamage:SetPoint("TOPLEFT", fctPeriodicSpells, "BOTTOMLEFT", 0, 0)
fctDirectionalScale:SetPoint("TOPLEFT", fctPetMeleeDamage, "BOTTOMLEFT", 0, 0)
fctHealing:SetPoint("TOPLEFT", fctDirectionalScale, "BOTTOMLEFT", -10, -6)
fctAbsorbTarget:SetPoint("TOPLEFT", fctHealing, "BOTTOMLEFT", 10, 0)

fctSpellMechanics:SetPoint("TOPLEFT", fctDamage, "TOPRIGHT", 260, 0)
fctSpellMechanicsOther:SetPoint("TOPLEFT", fctSpellMechanics, "BOTTOMLEFT", 10, -4)
worldTextScale:SetPoint("TOPLEFT", fctSpellMechanicsOther, "BOTTOMLEFT", -6, -40)

local fctSelfLabel = AIO_FCT:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
fctSelfLabel:SetText(FLOATING_COMBAT_SELF_LABEL)
fctSelfLabel:SetPoint('TOPLEFT', fctAbsorbTarget, 'BOTTOMLEFT', -10, -25)

enablefct:SetPoint("TOPLEFT", fctSelfLabel, "BOTTOMLEFT", 0, -4)
fctfloatmodeDropdown:SetPoint("TOPLEFT", enablefct, "BOTTOMLEFT", -4, 0)
fctDodgeParryMiss:SetPoint("TOPLEFT", enablefct, "BOTTOMLEFT", 10, -32)
fctDamageReduction:SetPoint("TOPLEFT", fctDodgeParryMiss, "BOTTOMLEFT", 0, -4)
fctRepChanges:SetPoint("TOPLEFT", fctDamageReduction, "BOTTOMLEFT", 0, -4)
fctReactives:SetPoint("TOPLEFT", fctRepChanges, "BOTTOMLEFT", 0, -4)
fctFriendlyHealer:SetPoint("TOPLEFT", fctReactives, "BOTTOMLEFT", 0, -4)
fctCombatState:SetPoint("TOPLEFT", fctFriendlyHealer, "BOTTOMLEFT", 0, -4)
fctAbsorbSelf:SetPoint("TOPLEFT", fctDodgeParryMiss, "TOPRIGHT", 260, 0)
fctLowHPMana:SetPoint("TOPLEFT", fctAbsorbSelf, "BOTTOMLEFT", 0, -4)
fctEnergyGains:SetPoint("TOPLEFT", fctLowHPMana, "BOTTOMLEFT", 0, -4)
fctPeriodicEnergyGains:SetPoint("TOPLEFT", fctEnergyGains, "BOTTOMLEFT", 0, -4)
fctHonorGains:SetPoint("TOPLEFT", fctPeriodicEnergyGains, "BOTTOMLEFT", 0, -4)
fctAuras:SetPoint("TOPLEFT", fctHonorGains, "BOTTOMLEFT", 0, -4)

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

-- Nameplate section
local AIO_NP = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_NP:Hide()
AIO_NP:SetAllPoints()
AIO_NP.name = "Nameplates"
AIO_NP.parent = addonName

local Title_NP = AIO_NP:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_NP:SetJustifyV('TOP')
Title_NP:SetJustifyH('LEFT')
Title_NP:SetPoint('TOPLEFT', 16, -16)
Title_NP:SetText(AIO_NP.name)

local SubText_NP = AIO_NP:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_NP:SetMaxLines(3)
SubText_NP:SetNonSpaceWrap(true)
SubText_NP:SetJustifyV('TOP')
SubText_NP:SetJustifyH('LEFT')
SubText_NP:SetPoint('TOPLEFT', Title_NP, 'BOTTOMLEFT', 0, -8)
SubText_NP:SetPoint('RIGHT', -32, 0)
SubText_NP:SetText('These options allow you to modify Nameplate Options.')

local nameplateAtBase = newCheckbox(AIO_NP, 'nameplateOtherAtBase')
nameplateAtBase:SetPoint("TOPLEFT", SubText_NP, "BOTTOMLEFT", 0, -20)
nameplateAtBase:SetScript('OnClick', function(self)
    local checked = self:GetChecked()
    PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    self:SetValue(checked and 2 or 0)
end)

local nameplateColorFriendly = newCheckbox(AIO_NP, 'ShowClassColorInFriendlyNameplate')
nameplateColorFriendly:SetPoint("TOPLEFT", nameplateAtBase, "BOTTOMLEFT", 0, -8)

-- Combat section
local AIO_C = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
AIO_C:Hide()
AIO_C:SetAllPoints()
AIO_C.name = "Combat"
AIO_C.parent = addonName

local Title_C = AIO_C:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title_C:SetJustifyV('TOP')
Title_C:SetJustifyH('LEFT')
Title_C:SetPoint('TOPLEFT', 16, -16)
Title_C:SetText(AIO_C.name)

local SubText_C = AIO_C:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText_C:SetMaxLines(3)
SubText_C:SetNonSpaceWrap(true)
SubText_C:SetJustifyV('TOP')
SubText_C:SetJustifyH('LEFT')
SubText_C:SetPoint('TOPLEFT', Title_C, 'BOTTOMLEFT', 0, -8)
SubText_C:SetPoint('RIGHT', -32, 0)
SubText_C:SetText('These options allow you to modify Combat Options.')

local stopAutoAttack = newCheckbox(AIO_C, 'stopAutoAttackOnTargetChange')
stopAutoAttack:SetPoint("TOPLEFT", SubText_C, "BOTTOMLEFT", 0, -8)

local attackOnAssist = newCheckbox(AIO_C, 'assistAttack')
attackOnAssist:SetPoint("TOPLEFT", stopAutoAttack, "BOTTOMLEFT", 0, -4)

local castOnKeyDown = newCheckbox(AIO_C, 'ActionButtonUseKeyDown')
castOnKeyDown:SetPoint("TOPLEFT", attackOnAssist, "BOTTOMLEFT", 0, -4)

local spellStartRecovery = newSlider(AIO_C, 'SpellQueueWindow', 0, 400)
spellStartRecovery:SetPoint('TOPLEFT', castOnKeyDown, 'BOTTOMLEFT', 24, -12)
spellStartRecovery.minMaxValues = {spellStartRecovery:GetMinMaxValues()}
spellStartRecovery.minText:SetFormattedText("%d %s", spellStartRecovery.minMaxValues[1], MILLISECONDS_ABBR)
spellStartRecovery.maxText:SetFormattedText("%d %s", spellStartRecovery.minMaxValues[2], MILLISECONDS_ABBR)

-- Hook up options to addon panel
local category = Settings.RegisterCanvasLayoutCategory(AIO, AIO.name, AIO.name)
local chatSubcategory = Settings.RegisterCanvasLayoutSubcategory(category, AIO_Chat, AIO_Chat.name, AIO_Chat.name)
chatSubcategory.ID = AIO_Chat.name;
local cSubcategory = Settings.RegisterCanvasLayoutSubcategory(category, AIO_C, AIO_C.name, AIO_C.name)
cSubcategory.ID = AIO_C.name;
local fctSubcategory = Settings.RegisterCanvasLayoutSubcategory(category, AIO_FCT, AIO_FCT.name, AIO_FCT.name)
fctSubcategory.ID = AIO_FCT.name;
local stSubcategory = Settings.RegisterCanvasLayoutSubcategory(category, AIO_ST, AIO_ST.name, AIO_ST.name)
stSubcategory.ID = AIO_ST.name;
local npSubcategory = Settings.RegisterCanvasLayoutSubcategory(category, AIO_NP, AIO_NP.name, AIO_NP.name)
npSubcategory.ID = AIO_NP.name;
local cvarsSubcategory = Settings.RegisterCanvasLayoutSubcategory(category, addon.OptionsPanel, addon.OptionsPanel.name, addon.OptionsPanel.name)
cvarsSubcategory.ID = addon.OptionsPanel.name;
Settings.RegisterAddOnCategory(category)
