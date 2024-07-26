local _, addon = ...

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateCVarOptions()
  local cvarOptions = {
    type = "group",
    childGroups = "tree",
    name = "",
    args = {
      -- Left Empty --
    },
  }

  return cvarOptions
end
