local AddonName, AddonVars = ...
local Addon = LibStub("AceAddon-3.0"):GetAddon(AddonName)
local AceGUI = LibStub:GetLibrary('AceGUI-3.0')
local util = AddonVars.util

Addon.shown = false

local function CreateTrainerContainer()
    local container = AceGUI:Create("InlineGroup")
    container:SetRelativeWidth(1)

    local icon = AceGUI:Create("Icon")
    icon:SetImageSize(36,36)
    container:AddChild(icon)

    local label2 = AceGUI:Create("Label")
    label2:SetWidth(400)
    container:AddChild(label2)

    local label3 = AceGUI:Create("Label")
    label3:SetWidth(400)
    container:AddChild(label3)

    local helper = AceGUI:Create("InteractiveLabel")
    local showAnswerText = 'Hover to reveal key binding(s)'
    container:AddChild(helper)

    local function updateContainer()
        icon:SetImage(Addon:CurrentIcon())

        container:SetTitle(Addon:CurrentLabel())
        container.parent:SetStatusText(Addon:CurrentLabel())

        label2:SetText('command: ' .. Addon:CurrentCommandText())
        label3:SetText('category: '..Addon:CurrentCategory())

        if Addon.currentKeys and #Addon.currentKeys > 0 then
            helper:SetText(showAnswerText)
            icon:SetCallback("OnEnter", function(widget) helper:SetText(Addon:CurrentKeysText()) end)
            icon:SetCallback("OnLeave", function() helper:SetText(showAnswerText) end)
        else
            helper:SetText('')
            icon:SetCallback("OnEnter", nil)
            icon:SetCallback("OnLeave", nil)
        end
    end
    return container, updateContainer
end

local updateTrainerContainer

function Addon:UpdateGUI()
    updateTrainerContainer()
end

local function CreateGuiContainer()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Zods Binding Trainer")
    frame:SetWidth(350)
    frame:SetHeight(300)
    frame:SetCallback("OnClose", function(widget)
        Addon.shown = false
        Addon:ClearOverrideBindings()
        AceGUI:Release(widget)
    end)
    frame:SetLayout("List")

    local trainerContainer, updateFunc = CreateTrainerContainer()
    updateTrainerContainer = updateFunc
    frame:AddChild(trainerContainer)

    local rebinder = AceGUI:Create("Keybinding")
    rebinder:SetKey(' ')
    rebinder:SetCallback('OnKeyChanged', nil)
    rebinder:SetDisabled(true)

    local nextButton = AceGUI:Create("Button")
    nextButton:SetText("Next")
    nextButton:SetWidth(300)
    nextButton:SetCallback("OnClick", function()
        rebinder:SetKey(' ')
        rebinder:SetCallback('OnKeyChanged', nil)
        rebinder:SetDisabled(true)
        Addon:NextBind()
    end)
    frame:AddChild(nextButton)

    local clearButton = AceGUI:Create("Button")
    clearButton:SetText("Clear command binds")
    clearButton:SetWidth(200)
    clearButton:SetCallback("OnClick", function()
        Addon:UnbindCurrent()
        Addon:FetchBindings()
        Addon:RefreshGui()
    end)
    frame:AddChild(clearButton)

    local rebindButton = AceGUI:Create("Button")
    rebindButton:SetText("Rebind Command")
    rebindButton:SetWidth(200)
    rebindButton:SetCallback("OnClick", function(widget)
        rebinder:SetKey((Addon.currentKeys or {})[1])
        rebinder:SetCallback("OnKeyChanged", function(_,_, key)
            Addon:BindCurrent(key)
            Addon:FetchBindings()
            Addon:RefreshGui()
        end)
        rebinder:SetDisabled(false)
    end)
    frame:AddChild(rebindButton)

    rebinder:SetKey(' ')
    frame:AddChild(rebinder)

    Addon:NextBind()
end


function Addon:Show()
    if self.shown == true then
        return
    end
    CreateGuiContainer()
    self.shown = true
end