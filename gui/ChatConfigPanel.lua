local _, addon = ...

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function addon:CreateChatOptions()
  local chatOptions = {
    type = "group",
    childGroups = "tree",
    name = "Chat",
    args = {
      instructions = {
        type = "description",
        name = "These options allow you to modify various chat settings that are no longer part of the default UI.",
        fontSize = "medium",
        order = 1,
      },
      header = {
        type = "header",
        name = "",
        order = 10,
      },
      -------------------------------------------------
      chatMouseScroll = {
        type = "toggle",
        name = CHAT_MOUSE_WHEEL_SCROLL,
        desc = OPTION_TOOLTIP_CHAT_MOUSE_WHEEL_SCROLL,
        get = function()
          return C_CVar.GetCVarBool("chatMouseScroll")
        end,
        set = function(_, value)
          self:SetCVar("chatMouseScroll", value)
        end,
        width = "full",
        order = 11,
      },
      removeChatDelay = {
        type = "toggle",
        name = REMOVE_CHAT_DELAY_TEXT,
        desc = OPTION_TOOLTIP_REMOVE_CHAT_DELAY_TEXT,
        get = function()
          return C_CVar.GetCVarBool("removeChatDelay")
        end,
        set = function(_, value)
          self:SetCVar("removeChatDelay", value)
        end,
        width = "full",
        order = 12,
      },
      chatClassColorOverride = {
        type = "toggle",
        name = "Disable Class Colors",
        desc = "Disables Class Colors in Chat",
        get = function()
          return C_CVar.GetCVarBool("chatClassColorOverride")
        end,
        set = function(_, value)
          self:SetCVar("chatClassColorOverride", value)
        end,
        hidden = function()
          return not self.IsClassicEra() and not self.IsClassic()
        end,
        width = "full",
        order = 13,
      },
    },
  }

  return chatOptions
end
