local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateNameplateOptions()
  local nameplateOptions = {
    type = "group",
    childGroups = "tree",
    name = "Nameplates",
    args = {
      instructions = {
        type = "description",
        name = "These options allow you to modify Nameplate Options.",
        fontSize = "medium",
        order = 1,
      },
      header = {
        type = "header",
        name = "",
        order = 10,
      },
      -------------------------------------------------
      nameplateOtherAtBase = {
        type = "toggle",
        name = "Nameplate at Base",
        desc = "Position other nameplates at the base, rather than overhead. 2=under unit, 0=over unit",
        get = function()
          return C_CVar.GetCVarBool("nameplateOtherAtBase")
        end,
        set = function(_, value)
          self:SetCVar("nameplateOtherAtBase", value)
        end,
        width = "full",
        order = 11,
      },
      ShowClassColorInFriendlyNameplate = {
        type = "toggle",
        name = "Class color friendly nameplates",
        desc = "Class color for friendly nameplates",
        get = function()
          return C_CVar.GetCVarBool("ShowClassColorInFriendlyNameplate")
        end,
        set = function(_, value)
          self:SetCVar("ShowClassColorInFriendlyNameplate", value)
        end,
        width = "full",
        order = 12,
      },
    },
  }

  return nameplateOptions
end
