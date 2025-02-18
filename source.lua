local Library = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UI = {
    MainFrame = nil,
    Tabs = {},
    ActiveTab = 1,
    ActiveToggle = 1,
    Visible = false,
    Dragging = false,
    DragOffset = Vector2.new(),
    PositionPresets = {
        ["TopLeft"] = Vector2.new(20, 20),
        ["TopCenter"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2 - 100, 20),
        ["TopRight"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 220, 20),
        ["CenterLeft"] = Vector2.new(20, workspace.CurrentCamera.ViewportSize.Y / 2 - 100),
        ["Center"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2 - 100, workspace.CurrentCamera.ViewportSize.Y / 2 - 100),
        ["CenterRight"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 220, workspace.CurrentCamera.ViewportSize.Y / 2 - 100),
    },
    CurrentPosition = "Center",
    TitlePosition = "TopLeft",
    OutlineColor = Color3.fromRGB(255, 255, 255)
}

function UI:CreateMainFrame()
    local Frame = Drawing.new("Square")
    Frame.Size = Vector2.new(200, 300)
    Frame.Position = self.PositionPresets[self.CurrentPosition]
    Frame.Color = Color3.fromRGB(30, 30, 30)
    Frame.Filled = true
    Frame.Transparency = 0.9
    Frame.Visible = false
    Frame.Thickness = 2
    self.MainFrame = Frame
    
    local Title = Drawing.new("Text")
    Title.Text = "Library - [None]"
    Title.Size = 20
    Title.Color = Color3.fromRGB(255, 255, 255)
    Title.Outline = true
    Title.Visible = false
    self.Title = Title
    self:UpdateTitlePosition()
end

function UI:UpdateTitle()
    if self.Tabs[self.ActiveTab] then
        self.Title.Text = "Library - [" .. self.Tabs[self.ActiveTab].Name .. "]"
    else
        self.Title.Text = "Library - [None]"
    end
    self:UpdateTitlePosition()
end

function UI:UpdateTitlePosition()
    local FramePos = self.MainFrame.Position
    if self.TitlePosition == "TopLeft" then
        self.Title.Position = FramePos + Vector2.new(10, 10)
    elseif self.TitlePosition == "TopCenter" then
        self.Title.Position = FramePos + Vector2.new(100 - self.Title.TextBounds.X / 2, 10)
    elseif self.TitlePosition == "TopRight" then
        self.Title.Position = FramePos + Vector2.new(190 - self.Title.TextBounds.X, 10)
    end
end

function UI:ToggleUI()
    self.Visible = not self.Visible
    self.MainFrame.Visible = self.Visible
    self.Title.Visible = self.Visible
    
    for _, tab in ipairs(self.Tabs) do
        for _, button in ipairs(tab.Buttons) do
            button.Object.Visible = false
        end
    end
    
    if self.Visible and self.Tabs[self.ActiveTab] then
        for _, button in ipairs(self.Tabs[self.ActiveTab].Buttons) do
            button.Object.Visible = true
        end
    end
end

function Library:NewTab(name)
    local tab = {Name = name, Buttons = {}}
    table.insert(UI.Tabs, tab)
    UI:UpdateTitle()
    return #UI.Tabs
end

function Library:NewToggle(name, tabID, callback)
    local tab = UI.Tabs[tabID]
    if not tab then return end
    local Button = Drawing.new("Text")
    Button.Text = "[ ] " .. name
    Button.Position = UI.MainFrame.Position + Vector2.new(10, 40 + #tab.Buttons * 25)
    Button.Size = 18
    Button.Color = Color3.fromRGB(255, 255, 255)
    Button.Outline = true
    Button.Visible = false
    tab.Buttons[#tab.Buttons + 1] = {Object = Button, Callback = callback, Active = false}
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.RightShift then
            UI:ToggleUI()
        elseif input.KeyCode == Enum.KeyCode.O then
            UI.ActiveTab = math.min(#UI.Tabs, UI.ActiveTab + 1)
            UI.ActiveToggle = 1
            UI:UpdateTitle()
        elseif input.KeyCode == Enum.KeyCode.P then
            UI.ActiveTab = math.max(1, UI.ActiveTab - 1)
            UI.ActiveToggle = 1
            UI:UpdateTitle()
        elseif input.KeyCode == Enum.KeyCode.I then
            UI.ActiveToggle = math.max(1, UI.ActiveToggle - 1)
        elseif input.KeyCode == Enum.KeyCode.K then
            if UI.Tabs[UI.ActiveTab] then
                UI.ActiveToggle = math.min(#UI.Tabs[UI.ActiveTab].Buttons, UI.ActiveToggle + 1)
            end
        elseif input.KeyCode == Enum.KeyCode.Return then
            local tab = UI.Tabs[UI.ActiveTab]
            if tab and tab.Buttons[UI.ActiveToggle] then
                tab.Buttons[UI.ActiveToggle].Callback()
                tab.Buttons[UI.ActiveToggle].Active = not tab.Buttons[UI.ActiveToggle].Active
                tab.Buttons[UI.ActiveToggle].Object.Text = (tab.Buttons[UI.ActiveToggle].Active and "[✔] " or "[ ] ") .. tab.Buttons[UI.ActiveToggle].Object.Text:sub(5)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for tabIndex, tab in ipairs(UI.Tabs) do
        for i, button in ipairs(tab.Buttons) do
            button.Object.Position = UI.MainFrame.Position + Vector2.new(10, 40 + (i - 1) * 25)
            button.Object.Visible = (UI.Visible and tabIndex == UI.ActiveTab)
            
            if i == UI.ActiveToggle then
                button.Object.Text = "> " .. button.Object.Text:sub(3)
                button.Object.Color = Color3.fromRGB(0, 255, 0)
            else
                button.Object.Text = "  " .. button.Object.Text:sub(3)
                button.Object.Color = button.Active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
            end
        end
    end
    UI.MainFrame.Color = UI.OutlineColor
end)

UI:CreateMainFrame()
return Library
