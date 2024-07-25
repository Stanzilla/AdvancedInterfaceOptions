
local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25


-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateCVarOptions()
    local cvarOptions = {
        type = "group",
        childGroups = "tree",
        name = "",
        args = {
            -- Left Empty --
        }
    }

    return cvarOptions
end
