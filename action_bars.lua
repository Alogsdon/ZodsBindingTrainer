local AddonName, AddonVars = ...
local Addon = LibStub("AceAddon-3.0"):GetAddon(AddonName)
local util = AddonVars.util

local MACRO = 'macro'
local SPELL = 'spell'
local ITEM = 'item'
local ACTION_TYPES = {
    [MACRO] = {
        GetText = function(macroId)
            local name = GetMacroInfo(macroId)
            return 'Macro '.. (name or 'missing macro name')
        end
    },
    [SPELL] = {
        GetText = function(spellId)
            local name = GetSpellInfo(spellId)
            return 'Cast '.. (name or 'missing spell name')
        end
    },
    [ITEM] = {
        GetText = function(itemId)
            local name = GetItemInfo(itemId)
            return 'Use '.. (name or 'missing item name')
        end
    }
}

-- not sure if there's a better way to get this. works for now
local NUM_ACTION_SLOTS = 120

function Addon:SetActionBars()
    -- 1 = {text = 'text', icon = 'iconId'}
    local actionBars = self.actionBars or {}
    self.actionBars = actionBars

	for lActionSlot = 1, NUM_ACTION_SLOTS do
        local actionType, id = GetActionInfo(lActionSlot)
        if actionType then
            local ACTION_TYPE = ACTION_TYPES[actionType]
            if ACTION_TYPE then
                local actionText = ACTION_TYPE.GetText(id)
                local actionIcon = GetActionTexture(lActionSlot);
                actionBars[lActionSlot] = {
                    slot = lActionSlot,
                    actionType = actionType,
                    text = actionText,
                    icon = actionIcon
                }
            end
        else
            actionBars[lActionSlot] = nil
        end
    end
end

function Addon:FindActionText(txt)
    for _, actionInfo in pairs(self.actionBars) do
        if string.find(actionInfo.text, txt) then
            return actionInfo
        end
    end
end
