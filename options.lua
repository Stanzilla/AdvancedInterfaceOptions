
local addonName, addon = ...
local L = addon.L
local _G = _G

-- GLOBALS: UIDropDownMenu_AddButton

addon.hiddenOptions = {
	["UnitNameOwn"] = { prettyName = "UNIT_NAME_OWN", description = "OPTION_TOOLTIP_UNIT_NAME_OWN", type = "boolean" },
	["UnitNameNPC"] = { prettyName = "UNIT_NAME_NPC", description = "OPTION_TOOLTIP_UNIT_NAME_NPC", type = "boolean" },
	["UnitNameNonCombatCreatureName"] = { prettyName = "UNIT_NAME_NONCOMBAT_CREATURE", description = "OPTION_TOOLTIP_UNIT_NAME_NONCOMBAT_CREATURE", type = "boolean" },
	["UnitNamePlayerGuild"] = { prettyName = "UNIT_NAME_GUILD", description = "OPTION_TOOLTIP_UNIT_NAME_GUILD", type = "boolean" },
    ["UnitNameGuildTitle"] = { prettyName = "UNIT_NAME_GUILD_TITLE", description = "OPTION_TOOLTIP_GUILD_TITLE", type = "boolean" },
    ["UnitNamePlayerPVPTitle"] = { prettyName = "UNIT_NAME_PLAYER_TITLE", description = "OPTION_TOOLTIP_PLAYER_TITLE", type = "boolean" },

	["UnitNameFriendlyPlayerName"] = { prettyName = "UNIT_NAME_FRIENDLY", description = "OPTION_TOOLTIP_UNIT_NAME_FRIENDLY", type = "boolean" },
	["UnitNameFriendlyPetName"] = { prettyName = "UNIT_NAME_FRIENDLY_PETS", description = "OPTION_TOOLTIP_UNIT_NAME_FRIENDLY_PETS", type = "boolean" },
	["UnitNameFriendlyGuardianName"] = { prettyName = "UNIT_NAME_FRIENDLY_GUARDIANS", description = "OPTION_TOOLTIP_UNIT_NAME_FRIENDLY_GUARDIANS", type = "boolean" },
	["UnitNameFriendlyTotemName"] = { prettyName = "UNIT_NAME_FRIENDLY_TOTEMS", description = "OPTION_TOOLTIP_UNIT_NAME_FRIENDLY_TOTEMS", type = "boolean" },

	["UnitNameEnemyPlayerName"] = { prettyName = "UNIT_NAME_ENEMY", description = "OPTION_TOOLTIP_UNIT_NAME_ENEMY", type = "boolean" },
	["UnitNameEnemyPetName"] = { prettyName = "UNIT_NAME_ENEMY_PETS", description = "OPTION_TOOLTIP_UNIT_NAME_ENEMY_PETS", type = "boolean" },
	["UnitNameEnemyGuardianName"] = { prettyName = "UNIT_NAME_ENEMY_GUARDIANS", description = "OPTION_TOOLTIP_UNIT_NAME_ENEMY_GUARDIANS", type = "boolean" },
	["UnitNameEnemyTotemName"] = { prettyName = "UNIT_NAME_ENEMY_TOTEMS", description = "OPTION_TOOLTIP_UNIT_NAME_ENEMY_TOTEMS", type = "boolean" },
	["UnitNameForceHideMinus"] = { prettyName = "UNIT_NAME_HIDE_MINUS", description = "OPTION_TOOLTIP_UNIT_NAME_HIDE_MINUS", type = "boolean" },

	["nameplateShowFriends"] = { prettyName = "UNIT_NAMEPLATES_SHOW_FRIENDS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_FRIENDS", type = "boolean" },
	["nameplateShowFriendlyPets"] = { prettyName = "UNIT_NAMEPLATES_SHOW_FRIENDLY_PETS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_FRIENDLY_PETS", type = "boolean" },
	["nameplateShowFriendlyGuardians"] = { prettyName = "UNIT_NAMEPLATES_SHOW_FRIENDLY_GUARDIANS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_FRIENDLY_GUARDIANS", type = "boolean" },
	["nameplateShowFriendlyTotems"] = { prettyName = "UNIT_NAMEPLATES_SHOW_FRIENDLY_TOTEMS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_FRIENDLY_TOTEMS", type = "boolean" },
	["nameplateShowEnemies"] = { prettyName = "UNIT_NAMEPLATES_SHOW_ENEMIES", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMIES", type = "boolean" },
	["nameplateShowEnemyPets"] = { prettyName = "UNIT_NAMEPLATES_SHOW_ENEMY_PETS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMY_PETS", type = "boolean" },
	["nameplateShowEnemyGuardians"] = { prettyName = "UNIT_NAMEPLATES_SHOW_ENEMY_GUARDIANS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMY_GUARDIANS", type = "boolean" },
	["nameplateShowEnemyTotems"] = { prettyName = "UNIT_NAMEPLATES_SHOW_ENEMY_TOTEMS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMY_TOTEMS", type = "boolean" },
	["nameplateShowEnemyMinus"] = { prettyName = "UNIT_NAMEPLATES_SHOW_ENEMY_MINUS", description = "OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMY_MINUS", type = "boolean" },
	["ShowClassColorInNameplate"] = { prettyName = "SHOW_CLASS_COLOR_IN_V_KEY", description = "OPTION_TOOLTIP_SHOW_CLASS_COLOR_IN_V_KEY", type = "boolean" },

	["reverseCleanupBags"] = { prettyName = "UNIT_NAME_PLAYER_GUILD", description = "OPTION_TOOLTIP_PLAYER_GUILD", type = "boolean" },
	["stopAutoAttackOnTargetChange"] = { prettyName = "STOP_AUTO_ATTACK", description = "OPTION_TOOLTIP_STOP_AUTO_ATTACK", type = "boolean" },
	["assistAttack"] = { prettyName = "ASSIST_ATTACK", description = "OPTION_TOOLTIP_ASSIST_ATTACK", type = "boolean" },
	["autoSelfCast"] = { prettyName = "AUTO_SELF_CAST_TEXT", description = "OPTION_TOOLTIP_SELF_CAST_TEXT", type = "boolean" },
	["ActionButtonUseKeyDown"] = { prettyName = "ACTION_BUTTON_USE_KEY_DOWN", description = "OPTION_TOOLTIP_USE_KEY_DOWN", type = "boolean" },
	["mapFade"] = { prettyName = "MAP_FADE_TEXT", description = "OPTION_TOOLTIP_MAP_FADE_TEXT", type = "boolean" },
	["trackQuestSorting"] = { type = "table", options = {"proximity", "top" } },
	["removeChatDelay"] = { prettyName = "REMOVE_CHAT_DELAY_TEXT", description = "OPTION_TOOLTIP_REMOVE_CHAT_DELAY_TEXT", type = "boolean" },
	["secureAbilityToggle"] = { prettyName = "SECURE_ABILITY_TOGGLE", description = "OPTION_TOOLTIP_SECURE_ABILITY_TOGGLE", type = "boolean" },
	["scriptErrors"] = { prettyName = "SHOW_LUA_ERRORS", description = "OPTION_TOOLTIP_SHOW_LUA_ERRORS", type = "boolean" },
	["lootUnderMouse"] = { prettyName = "LOOT_UNDER_MOUSE_TEXT", description = "OPTION_TOOLTIP_LOOT_UNDER_MOUSE_TEXT", type = "boolean" },

	["autoLootDefault"] = { prettyName = "AUTO_LOOT_DEFAULT_TEXT", description = "OPTION_TOOLTIP_AUTO_LOOT_DEFAULT", type = "boolean" },
	["threatShowNumeric"] = { prettyName = "SHOW_NUMERIC_THREAT", description = "OPTION_TOOLTIP_SHOW_NUMERIC_THREAT", type = "boolean" },
	["showLootSpam"] = { prettyName = "SHOW_LOOT_SPAM", description = "OPTION_TOOLTIP_SHOW_LOOT_SPAM", type = "boolean" },
	["advancedWatchFrame"] = { prettyName = "ADVANCED_OBJECTIVES_TEXT", description = "OPTION_TOOLTIP_ADVANCED_OBJECTIVES_TEXT", type = "" },
	["watchFrameIgnoreCursor"] = { prettyName = "OBJECTIVES_IGNORE_CURSOR_TEXT", description = "OPTION_TOOLTIP_OBJECTIVES_IGNORE_CURSOR", type = "boolean" },
	["guildMemberNotify"] = { prettyName = "GUILDMEMBER_ALERT", description = "OPTION_TOOLTIP_GUILDMEMBER_ALERT", type = "boolean" },
	["CombatDamage"] = { prettyName = "SHOW_DAMAGE_TEXT", description = "OPTION_TOOLTIP_SHOW_DAMAGE_TEXT", type = "boolean" },
	["combatHealing"] = { prettyName = "SHOW_COMBAT_HEALING", description = "OPTION_TOOLTIP_SHOW_COMBAT_HEALING", type = "boolean" },
	["showArenaEnemyFrames"] = { prettyName = "SHOW_ARENA_ENEMY_FRAMES_TEXT", description = "OPTION_TOOLTIP_SHOW_ARENA_ENEMY_FRAMES", type = "boolean" },

	["autoClearAFK"] = { prettyName = "", description = "OPTION_TOOLTIP_CLEAR_AFK", type = "boolean" },
	["colorblindWeaknessFactor"] = { prettyName = "", description = "OPTION_TOOLTIP_ADJUST_COLORBLIND_STRENGTH", type = "boolean" },
	["autoLootDefault"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_LOOT_DEFAULT", type = "boolean" },
	["ChatAmbienceVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_", type = "boolean" },
	["threatShowNumeric"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_NUMERIC_THREAT", type = "boolean" },
	["fctDamageReduction"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_RESISTANCES", type = "boolean" },
	["rightActionBar"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_MULTIBAR3", type = "boolean" },
	["fctHonorGains"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_HONOR_GAINED", type = "boolean" },
	["emphasizeMySpellEffects"] = { prettyName = "", description = "OPTION_TOOLTIP_EMPHASIZE_MY_SPELLS", type = "boolean" },
	["chatBubblesParty"] = { prettyName = "", description = "OPTION_TOOLTIP_PARTY_CHAT_BUBBLES", type = "boolean" },
	["enableTwitter"] = { prettyName = "", description = "OPTION_TOOLTIP_SOCIAL_ENABLE_TWITTER_FUNCTIONALITY", type = "boolean" },
	["CombatHealing"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_COMBAT_HEALING", type = "boolean" },
	["fctFriendlyHealers"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_FRIENDLY_NAMES", type = "boolean" },
	["threatPlaySounds"] = { prettyName = "", description = "OPTION_TOOLTIP_PLAY_AGGRO_SOUNDS", type = "boolean" },

	["showToastOnline"] = { prettyName = "SHOW_TOAST_ONLINE_TEXT", description = "OPTION_TOOLTIP_SHOW_TOAST_ONLINE", type = "boolean" },
	["showToastOffline"] = { prettyName = "SHOW_TOAST_OFFLINE_TEXT", description = "OPTION_TOOLTIP_SHOW_TOAST_OFFLINE", type = "boolean" },
	["showToastBroadcast"] = { prettyName = "SHOW_TOAST_BROADCAST_TEXT", description = "OPTION_TOOLTIP_SHOW_TOAST_BROADCAST", type = "boolean" },
	["showToastFriendRequest"] = { prettyName = "SHOW_TOAST_FRIEND_REQUEST_TEXT", description = "OPTION_TOOLTIP_SHOW_TOAST_FRIEND_REQUEST", type = "boolean" },
	["showToastConversation"] = { prettyName = "SHOW_TOAST_CONVERSATION_TEXT", description = "OPTION_TOOLTIP_SHOW_TOAST_CONVERSATION", type = "boolean" },
	["showToastWindow"] = { prettyName = "SHOW_TOAST_WINDOW_TEXT", description = "OPTION_TOOLTIP_SHOW_TOAST_WINDOW", type = "boolean" },
	["toastDuration"] = { prettyName = "", description = "OPTION_TOOLTIP_TOAST_DURATION", type = "number" },

	["enableMouseSpeed"] = { prettyName = "ENABLE_MOUSE_SPEED", description = "OPTION_TOOLTIP_ENABLE_MOUSE_SPEED", type = "boolean" },
	["mouseInvertPitch"] = { prettyName = "INVERT_MOUSE", description = "OPTION_TOOLTIP_INVERT_MOUSE", type = "boolean" },
	["enableWoWMouse"] = { prettyName = "WOW_MOUSE", description = "OPTION_TOOLTIP_WOW_MOUSE", type = "boolean" },
	["autointeract"] = { prettyName = "CLICK_TO_MOVE", description = "OPTION_TOOLTIP_CLICK_TO_MOVE", type = "boolean" },
	["mouseSpeed"] = { prettyName = "MOUSE_SENSITIVITY", description = "OPTION_TOOLTIP_MOUSE_SENSITIVITY", type = "number" },
	["cameraYawMoveSpeed"] = { prettyName = "MOUSE_LOOK_SPEED", description = "OPTION_TOOLTIP_MOUSE_LOOK_SPEED", type = "number" },

	["wholeChatWindowClickable"] = { prettyName = "", description = "OPTION_TOOLTIP_CHAT_WHOLE_WINDOW_CLICKABLE", type = "boolean" },
	["useEnglishAudio"] = { prettyName = "", description = "OPTION_TOOLTIP_USE_ENGLISH_AUDIO", type = "boolean" },
	["enableCombatText"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_COMBAT", type = "boolean" },
	["fctEnergyGains"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_ENERGIZE", type = "boolean" },
	["ChatSoundVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_", type = "number" },
	["CombatHealingAbsorbSelf"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_SELF", type = "boolean" },
	["reducedLagTolerance"] = { prettyName = "", description = "OPTION_TOOLTIP_REDUCED_LAG_TOLERANCE", type = "boolean" },
	["fctLowManaHealth"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_LOW_HEALTH_MANA", type = "boolean" },
	["EnableMicrophone"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_MICROPHONE", type = "boolean" },
	["CombatDamage"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_DAMAGE", type = "boolean" },
	["cameraTerrainTilt"] = { prettyName = "", description = "OPTION_TOOLTIP_FOLLOW_TERRAIN", type = "boolean" },
	["autoOpenLootHistory"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_OPEN_LOOT_HISTORY", type = "boolean" },
	["showVKeyCastbarOnlyOnTarget"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_TARGET_CASTBAR_IN_V_KEY_ONLY_ON_TARGET", type = "boolean" },
	["fctAuras"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_AURAS", type = "boolean" },
	["displaySpellActivationOverlays"] = { prettyName = "", description = "OPTION_TOOLTIP_DISPLAY_SPELL_ALERTS", type = "boolean" },
	["fctRepChanges"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_REPUTATION", type = "boolean" },
	["hdPlayerModels"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_HD_MODELS", type = "boolean" },
	["autoLootKey"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_LOOT_KEY", type = "boolean" }, -- TODO TYPE
	["MaxSpellStartRecoveryOffset"] = { prettyName = "", description = "OPTION_TOOLTIP_LAG_TOLERANCE", type = "number" },
	["advancedCombatLogging"] = { prettyName = "", description = "OPTION_TOOLTIP_ADVANCED_COMBAT_LOGGING", type = "boolean" },
	["disableServerNagle"] = { prettyName = "", description = "OPTION_TOOLTIP_OPTIMIZE_NETWORK_SPEED", type = "boolean" },
	["cameraYawSmoothSpeed"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_FOLLOW_SPEED", type = "number" },
	["cameraWaterCollision"] = { prettyName = "", description = "OPTION_TOOLTIP_WATER_COLLISION", type = "boolean" },
	["cameraBobbing"] = { prettyName = "", description = "OPTION_TOOLTIP_HEAD_BOB", type = "boolean" },
	["cameraPivot"] = { prettyName = "", description = "OPTION_TOOLTIP_SMART_PIVOT", type = "boolean" },
	["cameraDistanceMaxFactor"] = { prettyName = "", description = "OPTION_TOOLTIP_MAX_FOLLOW_DIST", type = "number" },
	["chatBubbles"] = { prettyName = "", description = "OPTION_TOOLTIP_CHAT_BUBBLES", type = "boolean" },
	["autoDismountFlying"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_DISMOUNT_FLYING", type = "boolean" },
	["bottomRightActionBar"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_MULTIBAR2", type = "boolean" },

	["showPartyBackground"] = { prettyName = "SHOW_PARTY_BACKGROUND_TEXT", description = "OPTION_TOOLTIP_SHOW_PARTY_BACKGROUND", type = "boolean" },
	["showPartyPets"] = { prettyName = "SHOW_PARTY_PETS_TEXT", description = "OPTION_TOOLTIP_SHOW_PARTY_PETS", type = "boolean" },
	["showArenaEnemyFrames"] = { prettyName = "SHOW_ARENA_ENEMY_FRAMES_TEXT", description = "OPTION_TOOLTIP_SHOW_ARENA_ENEMY_FRAMES", type = "boolean" },
	["showArenaEnemyCastbar"] = { prettyName = "SHOW_ARENA_ENEMY_CASTBAR_TEXT", description = "OPTION_TOOLTIP_SHOW_ARENA_ENEMY_CASTBAR", type = "boolean" },
	["showArenaEnemyPets"] = { prettyName = "SHOW_ARENA_ENEMY_PETS_TEXT", description = "OPTION_TOOLTIP_SHOW_ARENA_ENEMY_PETS", type = "boolean" },
	["fullSizeFocusFrame"] = { prettyName = "FULL_SIZE_FOCUS_FRAME_TEXT", description = "OPTION_TOOLTIP_FULL_SIZE_FOCUS_FRAME", type = "boolean" },

	["showChatIcons"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_CHAT_ICONS", type = "boolean" },
	["spamFilter"] = { prettyName = "", description = "OPTION_TOOLTIP_SPAM_FILTER", type = "boolean" },
	["profanityFilter"] = { prettyName = "", description = "OPTION_TOOLTIP_PROFANITY_FILTER", type = "boolean" },
	["EnableVoiceChat"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_VOICECHAT", type = "boolean" },
	["rightTwoActionBar"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_MULTIBAR4", type = "boolean" },
	["rotateMinimap"] = { prettyName = "", description = "OPTION_TOOLTIP_ROTATE_MINIMAP", type = "boolean" },
	["blockTrades"] = { prettyName = "", description = "OPTION_TOOLTIP_BLOCK_TRADES", type = "boolean" },
	["movieSubtitle"] = { prettyName = "", description = "OPTION_TOOLTIP_CINEMATIC_SUBTITLES", type = "boolean" },
	["displayFreeBagSlots"] = { prettyName = "", description = "OPTION_TOOLTIP_DISPLAY_FREE_BAG_SLOTS", type = "boolean" },
	["lockActionBars"] = { prettyName = "", description = "OPTION_TOOLTIP_LOCK_ACTIONBAR", type = "boolean" },
	["screenEdgeFlash"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_FULLSCREEN_STATUS", type = "boolean" },
	["fctSpellMechanics"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_TARGET_EFFECTS", type = "boolean" },
	["showVKeyCastbar"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_TARGET_CASTBAR_IN_V_KEY", type = "boolean" },
	["chatMouseScroll"] = { prettyName = "", description = "OPTION_TOOLTIP_CHAT_MOUSE_WHEEL_SCROLL", type = "boolean" },
	["showGameTips"] = { prettyName = "SHOW_TIPOFTHEDAY_TEXT", description = "OPTION_TOOLTIP_SHOW_TIPOFTHEDAY", type = "boolean" },
	["InboundChatVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_VOICE_OUTPUT_VOLUME", type = "number" },
	["spellActivationOverlayOpacity"] = { prettyName = "", description = "OPTION_TOOLTIP_SPELL_ALERT_OPACITY", type = "number" },
	["PushToTalkSound"] = { prettyName = "", description = "OPTION_TOOLTIP_PUSHTOTALK_SOUND", type = "boolean" },
	["countdownForCooldowns"] = { prettyName = "", description = "OPTION_TOOLTIP_COUNTDOWN_FOR_COOLDOWNS", type = "boolean" },
	["VoiceActivationSensitivity"] = { prettyName = "", description = "OPTION_TOOLTIP_VOICE_ACTIVATION_SENSITIVITY", type = "number" },
	["alwaysShowActionBars"] = { prettyName = "", description = "OPTION_TOOLTIP_ALWAYS_SHOW_MULTIBARS", type = "boolean" },
	["OutboundChatVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_VOICE_INPUT_VOLUME", type = "number" },
	["CombatHealingAbsorbTarget"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET", type = "boolean" },
	["autoQuestWatch"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_QUEST_WATCH", type = "boolean" },
	["fctDodgeParryMiss"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_DODGE_PARRY_MISS", type = "boolean" },
	["SpellTooltip_DisplayAvgValues"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_POINTS_AS_AVG", type = "boolean" },
	["fctCombatState"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_COMBAT_STATE", type = "boolean" },

	["xpBarText"] = { prettyName = "XP_BAR_TEXT", description = "OPTION_TOOLTIP_XP_BAR", type = "boolean" },
	["playerStatusText"] = { prettyName = "STATUS_TEXT_PLAYER", description = "OPTION_TOOLTIP_STATUS_PLAYER", type = "boolean" },
	["petStatusText"] = { prettyName = "STATUS_TEXT_PET", description = "OPTION_TOOLTIP_STATUS_PET", type = "boolean" },
	["partyStatusText"] = { prettyName = "STATUS_TEXT_PARTY", description = "OPTION_TOOLTIP_STATUS_PARTY", type = "boolean" },
	["targetStatusText"] = { prettyName = "STATUS_TEXT_TARGET", description = "OPTION_TOOLTIP_STATUS_TARGET", type = "boolean" },
	["alternateResourceText"] = { prettyName = "ALTERNATE_RESOURCE_TEXT", description = "OPTION_TOOLTIP_ALTERNATE_RESOURCE", type = "boolean" },

	["bottomLeftActionBar"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_MULTIBAR1", type = "boolean" },
	["showVKeyCastbarSpellName"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_TARGET_CASTBAR_IN_V_KEY_SPELL_NAME", type = "boolean" },
	["fctReactives"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_REACTIVES", type = "boolean" },
	["buffDurations"] = { prettyName = "SHOW_BUFF_DURATION_TEXT", description = "OPTION_TOOLTIP_SHOW_BUFF_DURATION", type = "boolean" },
	["showDispelDebuffs"] = { prettyName = "SHOW_DISPELLABLE_DEBUFFS_TEXT", description = "OPTION_TOOLTIP_SHOW_DISPELLABLE_DEBUFFS", type = "boolean" },
	["showCastableBuffs"] = { prettyName = "SHOW_CASTABLE_BUFFS_TEXT", description = "OPTION_TOOLTIP_SHOW_CASTABLE_BUFFS", type = "boolean" },
	["consolidateBuffs"] = { prettyName = "CONSOLIDATE_BUFFS_TEXT", description = "OPTION_TOOLTIP_CONSOLIDATE_BUFFS", type = "boolean" },
	["showAllEnemyDebuffs"] = { prettyName = "SHOW_ALL_ENEMY_DEBUFFS_TEXT", description = "OPTION_TOOLTIP_SHOW_ALL_ENEMY_DEBUFFS", type = "boolean" },
	["deselectOnClick"] = { prettyName = "", description = "OPTION_TOOLTIP_GAMEFIELD_DESELECT", type = "boolean" },
	["autoQuestProgress"] = { prettyName = "", description = "OPTION_TOOLTIP_AUTO_QUEST_PROGRESS", type = "boolean" },
	["UberTooltips"] = { prettyName = "USE_UBERTOOLTIPS", description = "OPTION_TOOLTIP_USE_UBERTOOLTIPS", type = "boolean" },
	["fctComboPoints"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_COMBO_POINTS", type = "boolean" },

	["Sound_EnableAllSound"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_SOUND", type = "boolean" },
	["Sound_EnableDSPEffects"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_DSP_EFFECTS", type = "boolean" },
	["Sound_SFXVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_SOUND_VOLUME", type = "number" },
	["Sound_ZoneMusicNoDelay"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_MUSIC_LOOPING", type = "boolean" },
	["Sound_EnableDialog"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_DIALOG", type = "boolean" },
	["Sound_EnableSoundWhenGameIsInBG"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_BGSOUND", type = "boolean" },
	["Sound_EnableEmoteSounds"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_EMOTE_SOUNDS", type = "boolean" },
	["Sound_EnableAmbience"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_AMBIENCE", type = "boolean" },
	["Sound_DialogVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_DIALOG_VOLUME", type = "number" },
	["Sound_EnablePetBattleMusic"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_PET_BATTLE_MUSIC", type = "boolean" },
	["Sound_MusicVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_MUSIC_VOLUME", type = "number" },
	["Sound_EnableReverb"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_REVERB", type = "boolean" },
	["Sound_MasterVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_MASTER_VOLUME", type = "number" },
	["Sound_EnableMusic"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_MUSIC", type = "boolean" },
	["Sound_AmbienceVolume"] = { prettyName = "", description = "OPTION_TOOLTIP_AMBIENCE_VOLUME", type = "number" },
	["Sound_EnableErrorSpeech"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_ERROR_SPEECH", type = "boolean" },
	["Sound_EnableSFX"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_SOUNDFX", type = "boolean" },
	["Sound_ListenerAtCharacter"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_SOUND_AT_CHARACTER", type = "boolean" },
	["Sound_EnablePetSounds"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_PET_SOUNDS", type = "boolean" },

	["showTargetOfTarget"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_TARGET_OF_TARGET", type = "boolean" },
	["guildMemberNotify"] = { prettyName = "", description = "OPTION_TOOLTIP_GUILDMEMBER_ALERT", type = "boolean" },
	["PetMeleeDamage"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_PET_MELEE_DAMAGE", type = "boolean" },
	["Sound_EnableSoftwareHRTF"] = { prettyName = "", description = "OPTION_TOOLTIP_ENABLE_SOFTWARE_HRTF", type = "boolean" },
	["fctPeriodicEnergyGains"] = { prettyName = "", description = "OPTION_TOOLTIP_COMBAT_SHOW_PERIODIC_ENERGIZE", type = "boolean" },
	["advancedWorldMap"] = { prettyName = "", description = "OPTION_TOOLTIP_ADVANCED_WORLD_MAP", type = "boolean" },
	["showTutorials"] = { prettyName = "SHOW_TUTORIALS", description = "OPTION_TOOLTIP_SHOW_TUTORIALS", type = "boolean" },
	["lossOfControl"] = { prettyName = "", description = "OPTION_TOOLTIP_LOSS_OF_CONTROL", type = "boolean" },
	["blockChannelInvites"] = { prettyName = "", description = "OPTION_TOOLTIP_BLOCK_CHAT_CHANNEL_INVITE", type = "boolean" },
	["showTargetCastbar"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_TARGET_CASTBAR", type = "boolean" },
	["enablePetBattleCombatText"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_PETBATTLE_COMBAT", type = "boolean" },
	["fctSpellMechanicsOther"] = { prettyName = "", description = "OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS", type = "boolean" },
	["CombatLogPeriodicSpells"] = { prettyName = "", description = "OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS", type = "boolean" },
	["colorblindMode"] = { prettyName = "", description = "OPTION_TOOLTIP_USE_COLORBLIND_MODE", type = "boolean" },
	["useIPv6"] = { prettyName = "", description = "OPTION_TOOLTIP_USEIPV6", type = "boolean" },
	["interactOnLeftClick"] = { prettyName = "", description = "OPTION_TOOLTIP_INTERACT_ON_LEFT_CLICK", type = "boolean" },
	["enableMovePad"] = { prettyName = "MOVE_PAD", description = "OPTION_TOOLTIP_MOVE_PAD", type = "boolean" },
	["colorblindSimulator"] = { prettyName = "", description = "OPTION_TOOLTIP_COLORBLIND_FILTER", type = "boolean" },
}
--[[
	OptionsPanel:SetScript("OnShow", function(OptionsPanel)
	local function newCheckbox(label, description, onClick)
		local check = CreateFrame("CheckButton", "AIOCheck" .. label, OptionsPanel, "InterfaceOptionsCheckButtonTemplate")
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

	local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local playerName = newCheckbox(
		L["Your own name"],
		"UNIT_NAME_OWN",
		function(self, value) addon.db.auto = value end)
	playerName:SetChecked(addon.db.auto)
	playerName:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)

	local chatFrame = newCheckbox(
		L["ChatOptionsPanel output"],
		L.chatFrameDesc,
		function(self, value) addon.db.chatOptionsPanel = value end)
	chatFrame:SetChecked(addon.db.chatOptionsPanel)
	chatFrame:SetPoint("TOPLEFT", playerName, "BOTTOMLEFT", 0, -8)

	local info = {}
	local fontSizeDropdown = CreateFrame("Frame", "BugSackFontSize", OptionsPanel, "UIDropDownMenuTemplate")
	fontSizeDropdown:SetPoint("TOPLEFT", "BOTTOMLEFT", -15, -10)
	fontSizeDropdown.initialize = function()
		wipe(info)
		local fonts = {"GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge"}
		local names = {L["Small"], L["Medium"], L["Large"], L["X-Large"]}
		for i, font in next, fonts do
			info.text = names[i]
			info.value = font
			info.func = function(self)

			end
			info.checked = font == addon.db.fontSize
			UIDropDownMenu_AddButton(info)
		end
	end

	local reset = CreateFrame("Button", "AIOResetButton", OptionsPanel, "UIPanelButtonTemplate")
	reset:SetText(L["Reset to default"])
	reset:SetWidth(177)
	reset:SetHeight(24)
	reset:SetPoint("TOPLEFT", fontSizeDropdown, "BOTTOMLEFT", 17, -25)
	reset:SetScript("OnClick", function()
		addon:Reset()
	end)
	reset.tooltipText = L["Reset Advanced Interface Options to Blizzard defaults"]
	reset.newbieText = L.wipeDesc

	OptionsPanel:SetScript("OnShow", nil)
end)
]]--