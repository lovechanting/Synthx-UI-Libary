local Library = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UI = {
    MainFrame = nil,
    Tabs = {},
    ActiveTab = 1,
    Visible = false,
    PositionPresets = {
        ["TopLeft"] = Vector2.new(20, 20),
        ["TopCenter"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2 - 100, 20),
        ["TopRight"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 220, 20),
        ["CenterLeft"] = Vector2.new(20, workspace.CurrentCamera.ViewportSize.Y / 2 - 100),
        ["Center"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2 - 100, workspace.CurrentCamera.ViewportSize.Y / 2 - 100),
        ["CenterRight"] = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 220, workspace.CurrentCamera.ViewportSize.Y / 2 - 100),
    },
    CurrentPosition = "Center",
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
    Title.Text = "Library"
    Title.Position = Frame.Position + Vector2.new(10, 10)
    Title.Size = 20
    Title.Color = Color3.fromRGB(255, 255, 255)
    Title.Outline = true
    Title.Visible = false
    self.Title = Title
end

function UI:ToggleUI()
    self.Visible = not self.Visible
    self.MainFrame.Visible = self.Visible
    self.Title.Visible = self.Visible
    local targetTransparency = self.Visible and 0.9 or 0
    for i = self.MainFrame.Transparency, targetTransparency, self.Visible and 0.1 or -0.1 do
        self.MainFrame.Transparency = i
        self.Title.Transparency = i
        task.wait(0.01)
    end
end

function Library:NewTab(name)
    local tab = {Name = name, Buttons = {}}
    table.insert(UI.Tabs, tab)
    return #UI.Tabs
end

function Library:NewToggle(name, tabID, callback)
    local tab = UI.Tabs[tabID]
    if not tab then return end
    local Button = Drawing.new("Text")
    Button.Text = name
    Button.Position = UI.MainFrame.Position + Vector2.new(10, 40 + #tab.Buttons * 20)
    Button.Size = 18
    Button.Color = Color3.fromRGB(255, 255, 255)
    Button.Outline = true
    Button.Visible = UI.Visible
    tab.Buttons[#tab.Buttons + 1] = {Object = Button, Callback = callback}
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.RightShift then
            UI:ToggleUI()
        elseif input.KeyCode == Enum.KeyCode.I then
            UI.ActiveTab = math.max(1, UI.ActiveTab - 1)
        elseif input.KeyCode == Enum.KeyCode.O then
            UI.ActiveTab = math.min(#UI.Tabs, UI.ActiveTab + 1)
        elseif input.KeyCode == Enum.KeyCode.Return then
            local tab = UI.Tabs[UI.ActiveTab]
            if tab and tab.Buttons[1] then
                tab.Buttons[1].Callback()
            end
        end
    end
end)

UI:CreateMainFrame()
return Library
