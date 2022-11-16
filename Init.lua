local AddonName, AddonVars = ...
local Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceEvent-3.0", "AceTimer-3.0")
local util = AddonVars.util
_G[AddonName] = Addon

function Addon:OnInitialize()
    self:ScheduleTimer("AfterLoad", 1)
end

function Addon:AfterLoad()
	self:FetchBindings()
end

function Addon:FetchBindings()
	Addon:SetActionCommands()
	Addon:SetActionBars()
end

_G["SLASH_" .. AddonName .. "1"] = '/zbt'

SlashCmdList[AddonName] = function(msg)
	if not msg or string.len(msg) == 0 then
		Addon:FetchBindings()
		Addon:Show()
	else
		local info = Addon:FindActionText(msg)
		util.dump(info)
	end
end

function Addon:RunScript()
	local time = GetTime()
	local timeDiff = time - self.timeStart
	util.dump(self.currentCommand .. ', got it! ' .. string.format("%.2f", timeDiff) .. 'seconds')
    self:NextBind()
end


