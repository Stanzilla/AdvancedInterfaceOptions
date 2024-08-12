local _, addon = ...

-- Constants
local THIRD_WIDTH = 1.25

local maxCameraZoomFactor
if not addon.IsRetail() then
  maxCameraZoomFactor = 3.4
else
  maxCameraZoomFactor = 2.6
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateCameraOptions()
  local cameraOptions = {
    type = "group",
    childGroups = "tree",
    name = "Camera",
    args = {
      instructions = {
        type = "description",
        name = "These options allow you to modify Camera Options.",
        fontSize = "medium",
        order = 1,
      },
      -------------------------------------------------
      header = {
        type = "header",
        name = "",
        order = 10,
      },
      -- TODO: This might need more work for classic
      cameraDistanceMaxZoomFactor = {
        type = "range",
        name = MAX_FOLLOW_DIST,
        desc = OPTION_TOOLTIP_MAX_FOLLOW_DIST,
        min = 1,
        max = maxCameraZoomFactor,
        step = 0.1,
        get = function()
          return tonumber(C_CVar.GetCVar("cameraDistanceMaxZoomFactor"))
        end,
        set = function(_, value)
          self:SetCVar("cameraDistanceMaxZoomFactor", value)
        end,
        width = THIRD_WIDTH,
        order = 11,
      },
      -------------------------------------------------
      cameraCollisionHeader = {
        type = "header",
        name = "Camera Collision",
        order = 20,
        --this feature is only supported in 11.0 at the moment
        hidden = function()
          return not addon.IsRetail()
        end,
      },
      cameraIndirectVisibility = {
        type = "toggle",
        name = "Camera Indirect Visibility",
        desc = "Allow for the player character to be more obstructed by the environment before colliding and pushing the camera forward.",
        get = function()
          return C_CVar.GetCVarBool("cameraIndirectVisibility")
        end,
        set = function(_, value)
          self:SetCVar("cameraIndirectVisibility", value)
        end,
        --this feature is only supported in 11.0 at the moment
        hidden = function()
          return not addon.IsRetail()
        end,
        width = THIRD_WIDTH,
        order = 21,
      },
      cameraIndirectOffset = {
        type = "range",
        name = "Camera Indirect Offset",
        desc = "Control the sensitivity threshold for camera collisions when 'Camera Indirect Visibility' is enabled. [0] is the most sensitive, [10] is the least sensitive.",
        min = 1,
        max = 10,
        step = 0.1,
        get = function()
          return tonumber(C_CVar.GetCVar("cameraIndirectOffset"))
        end,
        set = function(_, value)
          self:SetCVar("cameraIndirectOffset", value)
        end,
        disabled = function()
          return not C_CVar.GetCVarBool("cameraIndirectVisibility")
        end,
        --this feature is only supported in 11.0 at the moment
        hidden = function()
          return not addon.IsRetail()
        end,
        width = THIRD_WIDTH,
        order = 22,
      },
      -------------------------------------------------
      actionCameraHeader = {
        type = "header",
        name = "Action Camera",
        order = 30,
      },
      actionCam = {
        type = "select",
        name = "Select Action Cam mode:",
        desc = "Select the mode for the Action Cam.",
        values = {
          ["default"] = "Default",
          ["on"] = "On",
          ["basic"] = "Basic",
          ["full"] = "Full",
        },
        sorting = {
          "default",
          "on",
          "basic",
          "full",
        },
        get = function()
          return self.getActionCamMode()
        end,
        set = function(_, value)
          ConsoleExec("actioncam" .. " " .. value)
        end,
        width = THIRD_WIDTH,
        order = 31,
      },
    }
  }

  return cameraOptions
end
