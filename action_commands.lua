local AddonName, AddonVars = ...
local Addon = LibStub("AceAddon-3.0"):GetAddon(AddonName)
local util = AddonVars.util


local whitelist = {
    'ACTIONBAR',
    'Bartender4',
    'Gladdy'
}

function Addon:SetActionCommands()
    -- 'COMMAND' = {keys = {'W', 'E'}}
    local actionCommands = self.actionCommands or {}
    self.actionCommands = actionCommands
    self.boundCommands = {}

    for i = 1, GetNumBindings() do
		local keys = {GetBinding(i)}
		local command = table.remove(keys,1)
        local actualKeys = {}
        local category = nil
        for _, key in pairs(keys) do
            local keyCommand = GetBindingAction(key)
            if keyCommand == command then
                table.insert(actualKeys, key)
            else
                category = key
            end
        end

        if #actualKeys > 0 then
            for _, pattern in pairs(whitelist) do
                if category and string.find(category, pattern) then
                    self.boundCommands[command] = true
                end
            end
        end
        actionCommands[command] = {
            keys = actualKeys,
            category = category
        }
	end
end
