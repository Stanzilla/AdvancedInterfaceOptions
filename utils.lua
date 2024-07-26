local _, addon = ...

--------------------------------------
-- Utility functions
--------------------------------------

function addon.IsClassicEra()
  return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function addon.IsClassic()
  return WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
end

function addon.IsRetail()
  return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function addon.getActionCamMode()
  local cameraDynamicPitch = C_CVar.GetCVarBool("test_cameraDynamicPitch")
  local cameraHeadMovementStrength = C_CVar.GetCVarBool("test_cameraHeadMovementStrength")
  local cameraOverShoulder = C_CVar.GetCVarBool("test_cameraOverShoulder")
  local cameraTargetFocusInteractEnable = C_CVar.GetCVarBool("test_cameraTargetFocusInteractEnable")
  local cameraTargetFocusEnemyEnable = C_CVar.GetCVarBool("test_cameraTargetFocusEnemyEnable")

  if cameraDynamicPitch and cameraHeadMovementStrength and cameraOverShoulder and cameraTargetFocusInteractEnable and cameraTargetFocusEnemyEnable then
    return "full"
  elseif cameraDynamicPitch and cameraHeadMovementStrength and cameraOverShoulder and cameraTargetFocusInteractEnable and not cameraTargetFocusEnemyEnable then
    return "on"
  elseif cameraDynamicPitch and not cameraHeadMovementStrength and not cameraOverShoulder and not cameraTargetFocusInteractEnable and not cameraTargetFocusEnemyEnable then
    return "basic"
  else
    return "default"
  end
end

function addon.getCustomVar(cvar)
  return AdvancedInterfaceOptionsSaved.CustomVars[cvar]
end

function addon.setCustomVar(cvar, value)
  AdvancedInterfaceOptionsSaved.CustomVars[cvar] = value
end

-- C_Console.GetAllCommands is now ConsoleGetAllCommands as of 10.2.0
addon.GetAllCommands = ConsoleGetAllCommands or C_Console and C_Console.GetAllCommands

-- value, defaultValue, isStoredServerAccount, isStoredServerCharacter, isLockedFromUser, isSecure, isReadOnly
addon.GetCVarInfo = C_CVar.GetCVarInfo

function addon:CVarExists(cvar)
  return not not select(
    2,
    pcall(function()
      return addon.GetCVarInfo(cvar)
    end)
  )
end
