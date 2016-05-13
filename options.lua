
local addonName, addon = ...
local L = addon.L
local _G = _G
local AIO = CreateFrame('Frame', 'AIOptions')
local frame = AIO
frame:Hide()

-- GLOBALS: LibStub, UIDropDownMenu_AddButton

addon.hiddenOptions = {
	["UnitNameOwn"] = { prettyName = "UNIT_NAME_OWN", description = "OPTION_TOOLTIP_UNIT_NAME_OWN", value = "1" },
	["UnitNamePlayerGuild"] = { prettyName = "UNIT_NAME_GUILD", description = "OPTION_TOOLTIP_UNIT_NAME_GUILD", value = "0" },
    ["UnitNameGuildTitle"] = { prettyName = "UNIT_NAME_GUILD_TITLE", description = "OPTION_TOOLTIP_GUILD_TITLE", value = "0" },
    ["UnitNamePlayerPVPTitle"] = { prettyName = "UNIT_NAME_PLAYER_TITLE", description = "OPTION_TOOLTIP_PLAYER_TITLE", value = "0" },
	["reverseCleanupBags"] = { prettyName = "UNIT_NAME_PLAYER_GUILD", description = "OPTION_TOOLTIP_PLAYER_GUILD", value = "0" },
	["stopAutoAttackOnTargetChange"] = { prettyName = "STOP_AUTO_ATTACK", description = "OPTION_TOOLTIP_STOP_AUTO_ATTACK", value = "0" },
	["assistAttack"] = { prettyName = "ASSIST_ATTACK", description = "OPTION_TOOLTIP_ASSIST_ATTACK", value = "0" },
	["autoSelfCast"] = { prettyName = "AUTO_SELF_CAST_TEXT", description = "OPTION_TOOLTIP_SELF_CAST_TEXT", value = "0" },
	["ActionButtonUseKeyDown"] = { prettyName = "ACTION_BUTTON_USE_KEY_DOWN", description = "OPTION_TOOLTIP_USE_KEY_DOWN", value = "0" },
	["mapFade"] = { prettyName = "MAP_FADE_TEXT", description = "OPTION_TOOLTIP_MAP_FADE_TEXT", value = "0" },
	["trackQuestSorting"] = { mode = "proximity", mode = "top" },
	["removeChatDelay"] = { prettyName = "REMOVE_CHAT_DELAY_TEXT", description = "OPTION_TOOLTIP_REMOVE_CHAT_DELAY_TEXT", value = "0" },
	["secureAbilityToggle"] = { prettyName = "SECURE_ABILITY_TOGGLE", description = "OPTION_TOOLTIP_SECURE_ABILITY_TOGGLE", value = "0" },
	["scriptErrors"] = { prettyName = "SHOW_LUA_ERRORS", description = "OPTION_TOOLTIP_SHOW_LUA_ERRORS", value = "0" },
	["lootUnderMouse"] = { prettyName = "LOOT_UNDER_MOUSE_TEXT", description = "OPTION_TOOLTIP_LOOT_UNDER_MOUSE_TEXT", value = "1" },

	["autoLootDefault"] = { prettyName = "AUTO_LOOT_DEFAULT_TEXT", description = "OPTION_TOOLTIP_ ", value = "1" },
	["threatShowNumeric"] = { prettyName = "SHOW_NUMERIC_THREAT", description = "OPTION_TOOLTIP_ ", value = "1" },
	["showLootSpam"] = { prettyName = "SHOW_LOOT_SPAM", description = "OPTION_TOOLTIP_ ", value = "0" },
	["advancedWatchFrame"] = { prettyName = "ADVANCED_OBJECTIVES_TEXT", description = "OPTION_TOOLTIP_ ", value = "1" },
	["watchFrameIgnoreCursor"] = { prettyName = "OBJECTIVES_IGNORE_CURSOR_TEXT", description = "OPTION_TOOLTIP_ ", value = "1" },
	["guildMemberNotify"] = { prettyName = "GUILDMEMBER_ALERT", description = "OPTION_TOOLTIP_ ", value = "1" },
	["CombatDamage"] = { prettyName = "SHOW_DAMAGE_TEXT", description = "OPTION_TOOLTIP_ ", value = "0" },
	["combatHealing"] = { prettyName = "SHOW_COMBAT_HEALING", description = "OPTION_TOOLTIP_ ", value = "1" },
	["showArenaEnemyFrames"] = { prettyName = "SHOW_ARENA_ENEMY_FRAMES_TEXT", description = "OPTION_TOOLTIP_ ", value = "0" },
}


--[[ CVAR LIST:
-- Things that exist in the Interface Options
reducedLagTolerance
maxSpellStartRecoveryOffset
cameraDistanceMax description = " ", value = "20",
cameraDistanceMaxFactor value = "4",
cameraWaterCollision value = "0 ", text = "WATER_COLLISION",
  ["LOCK_ACTIONBAR"] = { default = "0", cvar = "lockActionBars", event = "LOCK_ACTIONBAR_TEXT" },
  ["SHOW_BUFF_DURATIONS"] = { default = "1", cvar = "buffDurations", event = "SHOW_BUFF_DURATION_TEXT", GetCVar("buffDurations"); },
  ["ALWAYS_SHOW_MULTIBARS"] = { default = "0", cvar = "alwaysShowActionBars", event = "ALWAYS_SHOW_MULTIBARS_TEXT" },
  ["SHOW_PARTY_PETS"] = { default = "1", cvar = "showPartyPets", event = "SHOW_PARTY_PETS_TEXT" },
  ["SHOW_PARTY_BACKGROUND"] = { default = "0", cvar = "showPartyBackground", event = "SHOW_PARTY_BACKGROUND_TEXT" },
  ["SHOW_TARGET_OF_TARGET"] = { default = "0", cvar = "showTargetOfTarget", event = "SHOW_TARGET_OF_TARGET_TEXT" },
  ["SHOW_TARGET_OF_TARGET_STATE"] = { default = "5", cvar = "targetOfTargetMode", event = "SHOW_TARGET_OF_TARGET_STATE" },
  ["AUTO_QUEST_WATCH"] = { default = "1", cvar = "autoQuestWatch", event = "AUTO_QUEST_WATCH_TEXT" },
  ["LOOT_UNDER_MOUSE"] = { default = "0", cvar = "lootUnderMouse", event = "LOOT_UNDER_MOUSE_TEXT" },
  ["AUTO_LOOT_DEFAULT"] = { default = "0", cvar = "autoLootDefault", event = "AUTO_LOOT_DEFAULT_TEXT" },
  ["SHOW_COMBAT_TEXT"] = { default = "1", cvar = "enableCombatText", event = "SHOW_COMBAT_TEXT_TEXT" },
  ["COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"] = { default = "1", cvar = "fctLowManaHealth", event = "COMBAT_TEXT_SHOW_LOW_HEALTH_MANA_TEXT" },
  ["COMBAT_TEXT_SHOW_AURAS"] = { default = "0", cvar = "fctAuras", event = "COMBAT_TEXT_SHOW_AURAS_TEXT" },
  ["COMBAT_TEXT_SHOW_AURA_FADE"] = { default = "0", cvar = "fctAuras", event = "COMBAT_TEXT_SHOW_AURAS_TEXT" },
  ["COMBAT_TEXT_SHOW_COMBAT_STATE"] = { default = "0", cvar = "fctCombatState", event = "COMBAT_TEXT_SHOW_COMBAT_STATE_TEXT" },
  ["COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"] = { default = "0", cvar = "fctDodgeParryMiss", event = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS_TEXT" },
  ["COMBAT_TEXT_SHOW_RESISTANCES"] = { default = "0", cvar = "fctDamageReduction", event = "COMBAT_TEXT_SHOW_RESISTANCES_TEXT" },
  ["COMBAT_TEXT_SHOW_REPUTATION"] = { default = "1", cvar = "fctRepChanges", event = "COMBAT_TEXT_SHOW_REPUTATION_TEXT" },
  ["COMBAT_TEXT_SHOW_REACTIVES"] = { default = "0", cvar = "fctReactives", event = "COMBAT_TEXT_SHOW_REACTIVES_TEXT" },
  ["COMBAT_TEXT_SHOW_FRIENDLY_NAMES"] = { default = "0", cvar = "fctFriendlyHealers", event = "COMBAT_TEXT_SHOW_FRIENDLY_NAMES_TEXT" },
  ["COMBAT_TEXT_SHOW_COMBO_POINTS"] = { default = "0", cvar = "fctComboPoints", event = "COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT" },
  ["COMBAT_TEXT_SHOW_ENERGIZE"] = { default = "0", cvar = "fctEnergyGains", event = "COMBAT_TEXT_SHOW_ENERGIZE_TEXT" },
  ["COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"] = { default = "0", cvar = "fctPeriodicEnergyGains", event = "COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE_TEXT" },
  ["COMBAT_TEXT_FLOAT_MODE"] = { default = "1", cvar = "combatTextFloatMode", event = "COMBAT_TEXT_FLOAT_MODE" },
  ["COMBAT_TEXT_SHOW_HONOR_GAINED"] = { default = "0", cvar = "fctHonorGains", event = "COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT" },
  ["ALWAYS_SHOW_MULTIBARS"] = { default = "0", cvar = "alwaysShowActionBars", },
  ["SHOW_CASTABLE_BUFFS"] = { default = "0", cvar = "showCastableBuffs", event = "SHOW_CASTABLE_BUFFS_TEXT" },
  ["SHOW_DISPELLABLE_DEBUFFS"] = { default = "1", cvar = "showDispelDebuffs", event = "SHOW_DISPELLABLE_DEBUFFS_TEXT" },
  ["SHOW_ARENA_ENEMY_FRAMES"] = { default = "1", cvar = "showArenaEnemyFrames", event = "SHOW_ARENA_ENEMY_FRAMES_TEXT" },
  ["SHOW_ARENA_ENEMY_CASTBAR"] = { default = "1", cvar = "showArenaEnemyCastbar", event = "SHOW_ARENA_ENEMY_CASTBAR_TEXT" },
  ["SHOW_ARENA_ENEMY_PETS"] = { default = "1", cvar = "showArenaEnemyPets", event = "SHOW_ARENA_ENEMY_PETS_TEXT" },
  ["SHOW_ALL_ENEMY_DEBUFFS"] = { default = "0", cvar = "showAllEnemyDebuffs", event = "SHOW_ALL_ENEMY_DEBUFFS_TEXT" },
 showChatIcons = { text="SHOW_CHAT_ICONS" },
 wholeChatWindowClickable = { text = "CHAT_WHOLE_WINDOW_CLICKABLE" },
 chatMouseScroll = { text = "CHAT_MOUSE_WHEEL_SCROLL" },
 enableTwitter = { text = "SOCIAL_ENABLE_TWITTER_FUNCTIONALITY" },
 
  UnitNameNPC = { text = "UNIT_NAME_NPC" },
  UnitNameNonCombatCreatureName = { text = "UNIT_NAME_NONCOMBAT_CREATURE" },


  UnitNameFriendlyPlayerName = { text = "UNIT_NAME_FRIENDLY" },
  UnitNameFriendlyPetName = { text = "UNIT_NAME_FRIENDLY_PETS" },
  UnitNameFriendlyGuardianName = { text = "UNIT_NAME_FRIENDLY_GUARDIANS" },
  UnitNameFriendlyTotemName = { text = "UNIT_NAME_FRIENDLY_TOTEMS" },

  UnitNameEnemyPlayerName = { text = "UNIT_NAME_ENEMY" },
  UnitNameEnemyPetName = { text = "UNIT_NAME_ENEMY_PETS" },
  UnitNameEnemyGuardianName = { text = "UNIT_NAME_ENEMY_GUARDIANS" },
  UnitNameEnemyTotemName = { text = "UNIT_NAME_ENEMY_TOTEMS" },
  UnitNameForceHideMinus = { text = "UNIT_NAME_HIDE_MINUS" },

  nameplateShowFriends = { text = "UNIT_NAMEPLATES_SHOW_FRIENDS" },
  nameplateShowFriendlyPets = { text = "UNIT_NAMEPLATES_SHOW_FRIENDLY_PETS" },
  nameplateShowFriendlyGuardians = { text = "UNIT_NAMEPLATES_SHOW_FRIENDLY_GUARDIANS" },
  nameplateShowFriendlyTotems = { text = "UNIT_NAMEPLATES_SHOW_FRIENDLY_TOTEMS" },
  nameplateShowEnemies = { text = "UNIT_NAMEPLATES_SHOW_ENEMIES" },
  nameplateShowEnemyPets = { text = "UNIT_NAMEPLATES_SHOW_ENEMY_PETS" },
  nameplateShowEnemyGuardians = { text = "UNIT_NAMEPLATES_SHOW_ENEMY_GUARDIANS" },
  nameplateShowEnemyTotems = { text = "UNIT_NAMEPLATES_SHOW_ENEMY_TOTEMS" },
  nameplateShowEnemyMinus = { text = "UNIT_NAMEPLATES_SHOW_ENEMY_MINUS" },
  ShowClassColorInNameplate = { text = "SHOW_CLASS_COLOR_IN_V_KEY" },
]]--

frame:SetScript("OnShow", function(frame)
	local function newCheckbox(label, description, onClick)
		local check = CreateFrame("CheckButton", "AIOCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
		check:SetScript("OnClick", function(self)
			PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
			onClick(self, self:GetChecked() and true or false)
		end)
		check.label = _G[check:GetName() .. "Text"]
		check.label:SetText(label)
		check.tooltipText = label
		check.tooltipRequirement = description
		return check
	end

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local playerName = newCheckbox(
		L["Your own name"],
		"UNIT_NAME_OWN",
		function(self, value) addon.db.auto = value end)
	playerName:SetChecked(addon.db.auto)
	playerName:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)

	local chatFrame = newCheckbox(
		L["Chatframe output"],
		L.chatFrameDesc,
		function(self, value) addon.db.chatframe = value end)
	chatFrame:SetChecked(addon.db.chatframe)
	chatFrame:SetPoint("TOPLEFT", playerName, "BOTTOMLEFT", 0, -8)

	local info = {}
	local fontSizeDropdown = CreateFrame("Frame", "BugSackFontSize", frame, "UIDropDownMenuTemplate")
	fontSizeDropdown:SetPoint("TOPLEFT", mute, "BOTTOMLEFT", -15, -10)
	fontSizeDropdown.initialize = function()
		wipe(info)
		local fonts = {"GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge"}
		local names = {L["Small"], L["Medium"], L["Large"], L["X-Large"]}
		for i, font in next, fonts do
			info.text = names[i]
			info.value = font
			info.func = function(self)
				addon.db.fontSize = self.value
				if _G.BugSackFrameScrollText then
					_G.BugSackFrameScrollText:SetFontObject(_G[self.value])
				end
				BugSackFontSizeText:SetText(self:GetText())
			end
			info.checked = font == addon.db.fontSize
			UIDropDownMenu_AddButton(info)
		end
	end
	BugSackFontSizeText:SetText(L["Font size"])

	local reset = CreateFrame("Button", "AIOResetButton", frame, "UIPanelButtonTemplate")
	reset:SetText(L["Reset to default"])
	reset:SetWidth(177)
	reset:SetHeight(24)
	reset:SetPoint("TOPLEFT", fontSizeDropdown, "BOTTOMLEFT", 17, -25)
	reset:SetScript("OnClick", function()
		addon:Reset()
	end)
	reset.tooltipText = L["Reset Advanced Interface Options to Blizzard defaults"]
	reset.newbieText = L.wipeDesc

	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)

