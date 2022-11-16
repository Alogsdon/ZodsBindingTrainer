local AddonName, AddonVars = ...
local Addon = LibStub("AceAddon-3.0"):GetAddon(AddonName)
local util = AddonVars.util

local DEFAULT_ICON = 134400

local bindingFrame = CreateFrame("Frame", nil, UIParent)

function Addon:SetCurrentCommand(command)
    self.currentCommand = command
    local cmdInfo = self.actionCommands[command] or {}
    self.currentKeys = cmdInfo.keys or {}
    self.currentCategory = cmdInfo.category
    self:ClearOverrideBindings()
    for _, key in pairs(self.currentKeys) do
        SetOverrideBinding(bindingFrame, true, key, 'ZOD1');
    end

    local slotInfo = self:GetCommandSlotInfo(command) or {}
    self.currentIcon = slotInfo.icon or DEFAULT_ICON
    self.currentLabel = slotInfo.text
end

function Addon:ClearOverrideBindings()
    ClearOverrideBindings(bindingFrame)
end

function Addon:RandomBind()
    local command = util.sample(self.boundCommands)
    while command == self.currentCommand do
        command = util.sample(self.boundCommands)
    end
    return command
end

function Addon:NextBind(bind)
    self:SetCurrentCommand(bind or self:RandomBind())
    self.timeStart = GetTime()
    self:UpdateGUI()
end

function Addon:RefreshGui()
    self:NextBind(self.currentCommand)
end

function Addon:UnbindCurrent()
    util.dump('Unbinding '.. self.currentCommand)
    for _, key in pairs(self.currentKeys) do
        util.dump('Unbound '..key)
        SetBinding(key)
    end
    SaveBindings(GetCurrentBindingSet())
end

function Addon:BindCurrent(key)
    util.dump('Bindinding '.. self.currentCommand .. ':' .. key)
    SetBinding(key, self.currentCommand)
    SaveBindings(GetCurrentBindingSet())
end

function Addon:CurrentKeysText()
    local s = ''
    for _, value in ipairs(self.currentKeys or {}) do
        s = s .. value .. ','
    end
    if string.len(s) > 0 then
        return strsub(s, 1, -2)
    else
        return s
    end
end

function Addon:CurrentCategory()
    return self.currentCategory
end

function Addon:CurrentIcon()
    return self.currentIcon
end

function Addon:CurrentLabel()
    return self.currentLabel or self.currentCommand
end

function Addon:CurrentCommandText()
    return self.currentCommand
end
