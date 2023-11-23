local addonName, addon = ...

--------------------------------------
-- Utility functions
--------------------------------------

-- C_Console.GetAllCommands is now ConsoleGetAllCommands as of 10.2.0
addon.GetAllCommands = ConsoleGetAllCommands or C_Console and C_Console.GetAllCommands

-- GetCVarInfo moved to C_CVar
-- value, defaultValue, isStoredServerAccount, isStoredServerCharacter, isLockedFromUser, isSecure, isReadOnly
addon.GetCVarInfo = GetCVarInfo or C_CVar and C_CVar.GetCVarInfo

function addon:CVarExists(cvar)
	return not not select(2, pcall(function() return addon.GetCVarInfo(cvar) end))
end