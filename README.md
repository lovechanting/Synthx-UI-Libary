# Synthx-UI-Libary
Advanced Roblox UI Library using Drawing.New completely stream-proof, fully animated, highly sophisticated, and optimized for zero lag!

Example:

```local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lovechanting/Synthx-UI-Libary/refs/heads/main/source.lua"))()

local tabID = UI:NewTab("Main Tab")

UI:NewToggle("Enable Feature", tabID, function()
    print("Feature Toggled!")
end)

UI:NewToggle("God Mode", tabID, function()
    print("God Mode Toggled!")
end)

UI:NewToggle("Infinite Ammo", tabID, function()
    print("Infinite Ammo Toggled!")
end)

local settingsTabID = UI:NewTab("Settings")
UI:NewToggle("Dark Mode", settingsTabID, function()
    print("Dark Mode Toggled!")
end)

UI.CurrentPosition = "TopRight"
UI:CreateMainFrame()

-- UI Keybinds:
-- Press 'RightShift' to toggle the UI visibility.
-- Press 'O' and 'P' to switch between tabs.
-- Press 'I' and 'K' to navigate toggle buttons.
-- Press 'Enter' to activate the selected toggle.
-- Press 'L' to reset UI position to default.```
