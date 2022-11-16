local AddonName, AddonVars = ...
local Addon = LibStub("AceAddon-3.0"):GetAddon(AddonName)
local util = AddonVars.util

local BAR_PATTERNS = {
    "(ACTION)BUTTON(%d+)",
    "(MULTIACTIONBAR%d+)BUTTON(%d+)",
    "(BT4Button)(%d+)",
    "(SHAPESHIFTBUTTON)(%d)"
}

local MULTIACTIONBAR_MAPPINGS = {
    MULTIACTIONBAR3 = 2,
    MULTIACTIONBAR4 = 3,
    MULTIACTIONBAR2 = 4,
    MULTIACTIONBAR1 = 5
}

local function GetActionBarSlot(barName, btnInd)
    if barName == 'ACTION' then
        return btnInd
    elseif string.find(barName, 'MULTIACTIONBAR') then
        local barInd = MULTIACTIONBAR_MAPPINGS[barName]
        assert(barInd, 'what is MULTIACTIONBAR_MAPPINGS '..barName..'BUTTON' .. btnInd)
        return btnInd + (barInd * 12)
    elseif barName == 'BT4Button' then
        return btnInd
    end
end

local function GetStanceInfo(ind)
    local icon, _, _, spellID = GetShapeshiftFormInfo(ind)
    if icon then
        local name = GetSpellInfo(spellID)
        return { text = 'Stance ' .. name, icon = icon }
    else
        return { text = 'Placeholder for stance ' .. ind }
    end
end

function Addon:GetCommandSlotInfo(command)
    local commandInfo = self.actionCommands[command]
    assert(commandInfo, 'no command found:' .. command)
    for _, pattern in pairs(BAR_PATTERNS) do
        local _, _, barName, btnInd = string.find(command, pattern)
        if barName == 'SHAPESHIFTBUTTON' then
            return GetStanceInfo(btnInd)
        elseif btnInd then
            local slot = GetActionBarSlot(barName, btnInd)
            return self.actionBars[tonumber(slot)] or  {
                text = 'Empty Bound Action Slot',
                actionType = 'empty',
                icon = 136116
            }
        end
    end
end
