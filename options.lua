
local addonName, addon = ...
local L = addon.L
local _G = _G

addon.hiddenOptions = {
	UnitNameOwn = { default = "0", text = "UNIT_NAME_OWN", value = "1" },
	UnitNamePlayerGuild = { default = "1", text = "UNIT_NAME_PLAYER_GUILD", value = "0" },
    UnitNameGuildTitle = 0,
    UnitNamePlayerPVPTitle = 0,
	reverseCleanupBags = true,
	stopAutoAttackOnTargetChange = 1,
	assistAttack = 1,
	autoSelfCast = 1,
	ActionButtonUseKeyDown = 1,
	mapFade = 1,
	trackQuestSorting = {1, 2, 3},
	removeChatDelay = 1,
	secureAbilityToggle = 1,
	scriptErrors = 1,
	chatBubbles = 0,
	chatBubblesParty = 0,
}

-- GLOBALS: LibStub, UIDropDownMenu_AddButton
--[[ CVAR LIST:
-- Things that exist in the Interface Options
'deselectOnClick 0 GAMEFIELD_DESELECT_TEXT',
'autoLootDefault 1 AUTO_LOOT_DEFAULT_TEXT',
'autoDismountFlying 1 AUTO_DISMOUNT_FLYING_TEXT',
'threatShowNumeric 1 SHOW_NUMERIC_THREAT',
'showLootSpam 0 SHOW_LOOT_SPAM',
'advancedWatchFrame 1 ADVANCED_OBJECTIVES_TEXT',
'watchFrameIgnoreCursor 1 OBJECTIVES_IGNORE_CURSOR_TEXT',
'profanityFilter 0 PROFANITY_FILTER',
'spamFilter 0 DISABLE_SPAM_FILTER',
'removeChatDelay 1 REMOVE_CHAT_DELAY_TEXT',
'guildMemberNotify 1 GUILDMEMBER_ALERT',
'CombatDamage 0 SHOW_DAMAGE_TEXT',
'CombatHealing 1 SHOW_COMBAT_HEALING',
'showArenaEnemyFrames 0 SHOW_ARENA_ENEMY_FRAMES_TEXT',
'cameraDistanceMax 20',
'cameraDistanceMaxFactor 4',
'cameraWaterCollision 0 WATER_COLLISION',
  ["LOCK_ACTIONBAR"] = { default = "0", cvar = "lockActionBars", event = "LOCK_ACTIONBAR_TEXT" },
  ["SHOW_BUFF_DURATIONS"] = { default = "1", cvar = "buffDurations", event = "SHOW_BUFF_DURATION_TEXT", func = function () SHOW_BUFF_DURATIONS = GetCVar("buffDurations"); BuffFrame_UpdatePositions(); end},
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
  profanityFilter = { text = "PROFANITY_FILTER" },
 spamFilter = { text="SPAM_FILTER" },
  guildMemberNotify = { text="GUILDMEMBER_ALERT" },
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
}
]]--

local frame = addon.frame
frame.name = addonName
frame:Hide()

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

