--[[
    Superskksksjsjsj's Admin Script
    Version: 3.0.0 - COMPLETE INFINITE YIELD
    Advanced administration tool for Roblox
--]]

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Teams = game:GetService("Teams")
local Debris = game:GetService("Debris")
local InsertService = game:GetService("InsertService")
local CollectionService = game:GetService("CollectionService")

-- Device Detection
local isMobile = UserInputService.TouchEnabled
local isGamepad = UserInputService.GamepadEnabled
local isDesktop = not isMobile and not isGamepad

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Commands = {}
local Aliases = {}
local CommandHistory = {}
local HistoryIndex = 0
local ActiveLoops = {}
local ESPPlayers = {}
local NoClipConnection = nil
local FlyConnection = nil
local Noclip = false

local Settings = {
    Prefix = ";",
    NotificationDuration = 5,
    MaxHistory = 100,
    AntiBan = true,
    AutoClean = false,
    GUIPosition = isMobile and UDim2.new(0.05, 0, 0.1, 0) or UDim2.new(0.35, 0, 0, 50),
    GUISize = isMobile and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0.4, 0, 0.6, 0),
    Keybinds = {
        ToggleGUI = Enum.KeyCode.F3,
        CommandBar = Enum.KeyCode.Semicolon
    },
    CmdBarTheme = "Dark",
    HighlightColor = Color3.fromRGB(0, 170, 255),
    MobileUIVisible = true,
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50
}

-- Remove old GUI if exists
if CoreGui:FindFirstChild("SuperskksksjsjsjAdmin") then
    CoreGui:FindFirstChild("SuperskksksjsjsjAdmin"):Destroy()
end

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperskksksjsjsjAdmin"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- MOBILE FLOATING BUTTON
local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "MobileToggle"
MobileToggleButton.Parent = ScreenGui
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MobileToggleButton.BackgroundTransparency = 0.2
MobileToggleButton.BorderSizePixel = 0
MobileToggleButton.Position = UDim2.new(0.85, 0, 0.02, 0)
MobileToggleButton.Size = UDim2.new(0.12, 0, 0.06, 0)
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.Text = isMobile and "ADMIN" or "OPEN"
MobileToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileToggleButton.TextSize = isMobile and 14 or 12
MobileToggleButton.AutoButtonColor = true
MobileToggleButton.Visible = true
MobileToggleButton.Active = true
MobileToggleButton.ZIndex = 10

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = MobileToggleButton

-- COMMAND BAR
local CommandBar = Instance.new("Frame")
CommandBar.Name = "CommandBar"
CommandBar.Parent = ScreenGui
CommandBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CommandBar.BackgroundTransparency = 0.2
CommandBar.BorderSizePixel = 0
CommandBar.Position = isMobile and UDim2.new(0.1, 0, 0.2, 0) or UDim2.new(0.3, 0, 0.05, 0)
CommandBar.Size = isMobile and UDim2.new(0.8, 0, 0, 50) or UDim2.new(0.4, 0, 0, 35)
CommandBar.Visible = false
CommandBar.Active = true
CommandBar.Draggable = true
CommandBar.ZIndex = 20

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = CommandBar

local CommandInput = Instance.new("TextBox")
CommandInput.Name = "CommandInput"
CommandInput.Parent = CommandBar
CommandInput.BackgroundTransparency = 1
CommandInput.Position = UDim2.new(0.02, 0, 0, 0)
CommandInput.Size = UDim2.new(0.8, 0, 1, 0)
CommandInput.Font = Enum.Font.Code
CommandInput.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
CommandInput.PlaceholderText = "Enter command... (type 'help' for commands)"
CommandInput.Text = ""
CommandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandInput.TextSize = isMobile and 18 or 16
CommandInput.TextXAlignment = Enum.TextXAlignment.Left
CommandInput.ClearTextOnFocus = false

local CloseCmdButton = Instance.new("TextButton")
CloseCmdButton.Name = "CloseCmdButton"
CloseCmdButton.Parent = CommandBar
CloseCmdButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseCmdButton.BorderSizePixel = 0
CloseCmdButton.Position = UDim2.new(0.85, 0, 0.1, 0)
CloseCmdButton.Size = UDim2.new(0.12, 0, 0.8, 0)
CloseCmdButton.Font = Enum.Font.GothamBold
CloseCmdButton.Text = "X"
CloseCmdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseCmdButton.TextSize = isMobile and 16 or 14

-- Output Frame - AUTO SHOW ON MOBILE
local OutputFrame = Instance.new("Frame")
OutputFrame.Name = "OutputFrame"
OutputFrame.Parent = ScreenGui
OutputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OutputFrame.BackgroundTransparency = 0.1
OutputFrame.BorderSizePixel = 0
OutputFrame.Position = Settings.GUIPosition
OutputFrame.Size = Settings.GUISize
OutputFrame.Visible = isMobile and Settings.MobileUIVisible or false
OutputFrame.Active = true
OutputFrame.Draggable = true
OutputFrame.ZIndex = 15

local OutputCorner = Instance.new("UICorner")
OutputCorner.CornerRadius = UDim.new(0, 12)
OutputCorner.Parent = OutputFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = OutputFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, isMobile and 40 or 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.02, 0, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = isMobile and "📱 IY Mobile Admin" or "Infinite Yield Style"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = isMobile and 16 or 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.94, 0, 0.15, 0)
CloseButton.Size = UDim2.new(0.04, 0, 0.7, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = isMobile and 14 or 12
CloseButton.AutoButtonColor = false

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.88, 0, 0.15, 0)
MinimizeButton.Size = UDim2.new(0.04, 0, 0.7, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = isMobile and 14 or 12
MinimizeButton.AutoButtonColor = false

-- MOBILE QUICK BUTTONS
local MobileQuickBar = Instance.new("Frame")
MobileQuickBar.Name = "MobileQuickBar"
MobileQuickBar.Parent = OutputFrame
MobileQuickBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MobileQuickBar.BorderSizePixel = 0
MobileQuickBar.Position = UDim2.new(0, 0, 0.12, 0)
MobileQuickBar.Size = UDim2.new(1, 0, 0.08, 0)
MobileQuickBar.Visible = isMobile

local QuickButtonLayout = Instance.new("UIListLayout")
QuickButtonLayout.Parent = MobileQuickBar
QuickButtonLayout.FillDirection = Enum.FillDirection.Horizontal
QuickButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
QuickButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
QuickButtonLayout.Padding = UDim.new(0, 5)

-- Quick Commands
local quickCommands = {
    {Name = "Fly", Command = "fly", Color = Color3.fromRGB(100, 200, 255)},
    {Name = "Speed", Command = "speed 50", Color = Color3.fromRGB(100, 255, 200)},
    {Name = "Kill", Command = "kill me", Color = Color3.fromRGB(255, 100, 100)},
    {Name = "God", Command = "god", Color = Color3.fromRGB(255, 255, 100)},
    {Name = "ESP", Command = "esp", Color = Color3.fromRGB(255, 100, 255)},
    {Name = "Clear", Command = "clear", Color = Color3.fromRGB(200, 200, 200)}
}

for _, quickCmd in ipairs(quickCommands) do
    local QuickButton = Instance.new("TextButton")
    QuickButton.Name = quickCmd.Name .. "Button"
    QuickButton.Parent = MobileQuickBar
    QuickButton.BackgroundColor3 = quickCmd.Color
    QuickButton.BackgroundTransparency = 0.3
    QuickButton.Size = UDim2.new(0.15, 0, 0.8, 0)
    QuickButton.Font = Enum.Font.GothamBold
    QuickButton.Text = quickCmd.Name
    QuickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    QuickButton.TextSize = 12
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = QuickButton
    
    QuickButton.MouseButton1Click:Connect(function()
        ExecuteCommand(Settings.Prefix .. quickCmd.Command, LocalPlayer)
    end)
end

-- Output Scrolling Frame
local OutputScrolling = Instance.new("ScrollingFrame")
OutputScrolling.Name = "OutputScrolling"
OutputScrolling.Parent = OutputFrame
OutputScrolling.BackgroundTransparency = 1
OutputScrolling.BorderSizePixel = 0
OutputScrolling.Position = UDim2.new(0.02, 0, isMobile and 0.22 or 0.1, 0)
OutputScrolling.Size = UDim2.new(0.96, 0, isMobile and 0.66 or 0.88, 0)
OutputScrolling.CanvasSize = UDim2.new(0, 0, 5, 0)
OutputScrolling.ScrollBarThickness = 6
OutputScrolling.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
OutputScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
OutputScrolling.VerticalScrollBarInset = Enum.ScrollBarInset.Always

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = OutputScrolling
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

-- Mobile Command Input
local MobileCommandInput = Instance.new("Frame")
MobileCommandInput.Name = "MobileCommandInput"
MobileCommandInput.Parent = OutputFrame
MobileCommandInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MobileCommandInput.BorderSizePixel = 0
MobileCommandInput.Position = UDim2.new(0, 0, isMobile and 0.9 or 0.92, 0)
MobileCommandInput.Size = UDim2.new(1, 0, 0.08, 0)
MobileCommandInput.Visible = isMobile

local MobileInputBox = Instance.new("TextBox")
MobileInputBox.Name = "MobileInputBox"
MobileInputBox.Parent = MobileCommandInput
MobileInputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MobileInputBox.BackgroundTransparency = 0.2
MobileInputBox.BorderSizePixel = 0
MobileInputBox.Position = UDim2.new(0.02, 0, 0.15, 0)
MobileInputBox.Size = UDim2.new(0.8, 0, 0.7, 0)
MobileInputBox.Font = Enum.Font.Code
MobileInputBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
MobileInputBox.PlaceholderText = "Type command (no prefix)..."
MobileInputBox.Text = ""
MobileInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileInputBox.TextSize = 16
MobileInputBox.TextXAlignment = Enum.TextXAlignment.Left

local MobileSendButton = Instance.new("TextButton")
MobileSendButton.Name = "MobileSendButton"
MobileSendButton.Parent = MobileCommandInput
MobileSendButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MobileSendButton.BorderSizePixel = 0
MobileSendButton.Position = UDim2.new(0.84, 0, 0.15, 0)
MobileSendButton.Size = UDim2.new(0.14, 0, 0.7, 0)
MobileSendButton.Font = Enum.Font.GothamBold
MobileSendButton.Text = "SEND"
MobileSendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileSendButton.TextSize = 14

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = MobileInputBox

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 8)
SendCorner.Parent = MobileSendButton

-- Notification System
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = ScreenGui
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Position = UDim2.new(0.5, 0, 0.05, 0)
NotificationFrame.Size = UDim2.new(0.4, 0, 0, 0)
NotificationFrame.AnchorPoint = Vector2.new(0.5, 0)

local NotificationList = Instance.new("UIListLayout")
NotificationList.Parent = NotificationFrame
NotificationList.SortOrder = Enum.SortOrder.LayoutOrder
NotificationList.Padding = UDim.new(0, 5)

-- UI Functions
local function CreateNotification(title, message, color, duration)
    duration = duration or Settings.NotificationDuration
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = NotificationFrame
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Notification.BackgroundTransparency = 0.2
    Notification.BorderSizePixel = 0
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.AutomaticSize = Enum.AutomaticSize.Y
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    TitleLabel.Size = UDim2.new(0.9, 0, 0, 22)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = color or Settings.HighlightColor
    TitleLabel.TextSize = isMobile and 16 or 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = Notification
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
    MessageLabel.Size = UDim2.new(0.9, 0, 0, 20)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    MessageLabel.TextSize = isMobile and 14 or 12
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
    
    Notification.Size = UDim2.new(1, 0, 0, 70 + MessageLabel.TextBounds.Y)
    
    task.spawn(function()
        task.wait(duration)
        local tween = TweenService:Create(
            Notification,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}
        )
        tween:Play()
        tween.Completed:Wait()
        Notification:Destroy()
    end)
end

local function OutputMessage(message, color, noPrefix)
    color = color or Color3.fromRGB(255, 255, 255)
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = OutputScrolling
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Size = UDim2.new(1, 0, 0, 22)
    MessageLabel.Font = Enum.Font.Code
    MessageLabel.Text = (noPrefix and "" or "> ") .. message
    MessageLabel.TextColor3 = color
    MessageLabel.TextSize = isMobile and 14 or 12
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    OutputScrolling.CanvasPosition = Vector2.new(0, OutputScrolling.AbsoluteCanvasSize.Y)
end

-- Player Finder (Complete Infinite Yield System)
local function GetPlayers(input, executor)
    executor = executor or LocalPlayer
    local players = {}
    local inputLower = input and string.lower(input) or ""
    
    if inputLower == "" then
        return {executor}
    end
    
    -- Special Keywords
    local keywords = {
        ["me"] = function() return {executor} end,
        ["others"] = function()
            local others = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= executor then
                    table.insert(others, player)
                end
            end
            return others
        end,
        ["all"] = function() return Players:GetPlayers() end,
        ["random"] = function()
            local all = Players:GetPlayers()
            return {all[math.random(1, #all)]}
        end,
        ["friends"] = function()
            local friends = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player:IsFriendsWith(executor.UserId) then
                    table.insert(friends, player)
                end
            end
            return friends
        end,
        ["nonfriends"] = function()
            local nonfriends = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if not player:IsFriendsWith(executor.UserId) then
                    table.insert(nonfriends, player)
                end
            end
            return nonfriends
        end,
        ["team"] = function()
            local teamPlayers = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Team == executor.Team then
                    table.insert(teamPlayers, player)
                end
            end
            return teamPlayers
        end,
        ["notteam"] = function()
            local notTeamPlayers = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Team ~= executor.Team then
                    table.insert(notTeamPlayers, player)
                end
            end
            return notTeamPlayers
        end,
        ["nearest"] = function()
            local executorChar = executor.Character
            if executorChar and executorChar:FindFirstChild("HumanoidRootPart") then
                local executorPos = executorChar.HumanoidRootPart.Position
                local nearestPlayer = nil
                local nearestDistance = math.huge
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= executor and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local distance = (executorPos - targetRoot.Position).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
                return nearestPlayer and {nearestPlayer} or {}
            end
            return {}
        end,
        ["farthest"] = function()
            local executorChar = executor.Character
            if executorChar and executorChar:FindFirstChild("HumanoidRootPart") then
                local executorPos = executorChar.HumanoidRootPart.Position
                local farthestPlayer = nil
                local farthestDistance = 0
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= executor and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local distance = (executorPos - targetRoot.Position).Magnitude
                            if distance > farthestDistance then
                                farthestDistance = distance
                                farthestPlayer = player
                            end
                        end
                    end
                end
                return farthestPlayer and {farthestPlayer} or {}
            end
            return {}
        end
    }
    
    if keywords[inputLower] then
        return keywords[inputLower]()
    end
    
    -- Distance based (e.g., ;kill 10)
    local distance = tonumber(input)
    if distance then
        local executorChar = executor.Character
        if executorChar and executorChar:FindFirstChild("HumanoidRootPart") then
            local executorPos = executorChar.HumanoidRootPart.Position
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    if (executorPos - playerPos).Magnitude <= distance then
                        table.insert(players, player)
                    end
                end
            end
            return players
        end
    end
    
    -- Username search
    for _, player in ipairs(Players:GetPlayers()) do
        local nameLower = string.lower(player.Name)
        local displayLower = string.lower(player.DisplayName)
        
        if nameLower:find(inputLower, 1, true) or 
           displayLower:find(inputLower, 1, true) or
           tostring(player.UserId):find(inputLower, 1, true) then
            table.insert(players, player)
        end
    end
    
    return players
end

-- Command System
local CommandSystem = {}
CommandSystem.__index = CommandSystem

function CommandSystem.new(name, description, func, aliases, category)
    local self = setmetatable({}, CommandSystem)
    self.Name = name
    self.Description = description
    self.Function = func
    self.Aliases = aliases or {}
    self.Category = category or "General"
    return self
end

function CommandSystem:Execute(args, executor)
    local success, err = pcall(function()
        local result = self.Function(args, executor)
        if result and type(result) == "function" then
            ActiveLoops[self.Name] = result
        elseif self.Name:find("unloop") or self.Name:find("stop") or self.Name:find("un") then
            local baseCmd = self.Name:gsub("un", ""):gsub("stop", ""):gsub("no", "")
            if ActiveLoops[baseCmd] then
                ActiveLoops[baseCmd]()
                ActiveLoops[baseCmd] = nil
                OutputMessage("Stopped " .. baseCmd, Color3.fromRGB(255, 150, 50))
            end
        end
    end)
    
    if not success then
        OutputMessage("Error: " .. err, Color3.fromRGB(255, 50, 50))
        CreateNotification("Command Error", err, Color3.fromRGB(255, 50, 50), 3)
    end
end

-- Command Registration
local function RegisterCommand(name, description, func, aliases, category)
    local cmd = CommandSystem.new(name, description, func, aliases, category)
    Commands[name] = cmd
    
    if aliases then
        for _, alias in ipairs(aliases) do
            Aliases[alias] = name
        end
    end
    
    return cmd
end

-- ==================== INFINITE YIELD COMMANDS ====================

-- BASIC COMMANDS
RegisterCommand("kill", "Kills selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
    OutputMessage("Killed " .. #players .. " player(s)", Color3.fromRGB(255, 100, 100))
end, {"k"}, "Basic")

RegisterCommand("kick", "Kicks selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local reason = table.concat(args, " ", 2) or "Kicked by admin"
    
    for _, player in ipairs(players) do
        player:Kick("[Admin] " .. reason)
    end
    OutputMessage("Kicked " .. #players .. " player(s)", Color3.fromRGB(255, 150, 50))
end, {}, "Basic")

RegisterCommand("explode", "Explodes selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    for _, player in ipairs(players) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local explosion = Instance.new("Explosion")
                explosion.Position = hrp.Position
                explosion.BlastPressure = 1000000
                explosion.BlastRadius = 10
                explosion.Parent = Workspace
            end
        end
    end
    OutputMessage("Exploded " .. #players .. " player(s)", Color3.fromRGB(255, 100, 100))
end, {"boom"}, "Basic")

RegisterCommand("freeze", "Freezes selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    for _, player in ipairs(players) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end
    end
    OutputMessage("Froze " .. #players .. " player(s)", Color3.fromRGB(100, 150, 255))
end, {"fr"}, "Basic")

RegisterCommand("thaw", "Unfreezes selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    for _, player in ipairs(players) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end
    end
    OutputMessage("Unfroze " .. #players .. " player(s)", Color3.fromRGB(100, 150, 255))
end, {"unfreeze", "melt"}, "Basic")

RegisterCommand("fire", "Sets selected players on fire", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    for _, player in ipairs(players) do
        if player.Character then
            local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
            if torso then
                local fire = Instance.new("Fire")
                fire.Size = 10
                fire.Heat = 10
                fire.Parent = torso
            end
        end
    end
    OutputMessage("Set fire to " .. #players .. " player(s)", Color3.fromRGB(255, 100, 50))
end, {"burn"}, "Basic")

RegisterCommand("unfire", "Removes fire from players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    for _, player in ipairs(players) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                for _, fire in ipairs(part:GetChildren()) do
                    if fire:IsA("Fire") then
                        fire:Destroy()
                    end
                end
            end
        end
    end
    OutputMessage("Removed fire from " .. #players .. " player(s)", Color3.fromRGB(255, 100, 50))
end, {"unburn"}, "Basic")

-- TELEPORT COMMANDS
RegisterCommand("bring", "Brings players to you", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local char = executor.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, player in ipairs(players) do
        if player ~= executor and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                targetRoot.CFrame = root.CFrame + Vector3.new(0, 0, -5)
            end
        end
    end
    OutputMessage("Brought " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
end, {"b"}, "Teleport")

RegisterCommand("to", "Teleports you to player", function(args, executor)
    local players = GetPlayers(args[1] or "random", executor)
    if #players > 0 then
        local target = players[1]
        if target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local char = executor.Character
            if char and targetRoot then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 5)
                end
            end
        end
    end
end, {"teleport", "tp"}, "Teleport")

RegisterCommand("goto", "Teleports to player", function(args, executor)
    local players = GetPlayers(args[1], executor)
    if #players > 0 then
        local target = players[1]
        if target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local char = executor.Character
            if char and targetRoot then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = targetRoot.CFrame
                end
            end
        end
    end
end, {}, "Teleport")

RegisterCommand("loopgoto", "Continuously teleports to player", function(args, executor)
    local players = GetPlayers(args[1], executor)
    if #players > 0 then
        local target = players[1]
        local loop = true
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if not loop then
                connection:Disconnect()
                return
            end
            if target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local char = executor.Character
                if char and targetRoot then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = targetRoot.CFrame
                    end
                end
            end
        end)
        
        OutputMessage("Looping teleport to " .. target.Name, Color3.fromRGB(100, 255, 100))
        return function() loop = false end
    end
end, {"loopto"}, "Teleport")

RegisterCommand("unloopgoto", "Stops loopgoto", function() end, {"unloopto"}, "Teleport")

RegisterCommand("clicktp", "Teleport to where you click", function(args, executor)
    local connection
    connection = Mouse.Button1Down:Connect(function()
        local target = Mouse.Hit.Position + Vector3.new(0, 5, 0)
        local char = executor.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(target)
            end
        end
    end)
    OutputMessage("Click TP enabled - Click anywhere to teleport", Color3.fromRGB(100, 255, 100))
    return function() connection:Disconnect() end
end, {"ctp"}, "Teleport")

RegisterCommand("unclicktp", "Disables clicktp", function() end, {"unctp"}, "Teleport")

-- MOVEMENT COMMANDS
RegisterCommand("fly", "Enables flying", function(args, executor)
    local speed = tonumber(args[1]) or Settings.FlySpeed
    local bodyVelocity = Instance.new("BodyVelocity")
    local bodyGyro = Instance.new("BodyGyro")
    
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    
    local flying = true
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid.PlatformStand = true
    
    bodyVelocity.Parent = char.HumanoidRootPart
    bodyGyro.Parent = char.HumanoidRootPart
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not flying then
            connection:Disconnect()
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            humanoid.PlatformStand = false
            return
        end
        
        local camera = Workspace.CurrentCamera
        local root = char.HumanoidRootPart
        
        bodyGyro.CFrame = camera.CFrame
        
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move = move - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = move.Unit * speed
    end)
    
    OutputMessage("Fly enabled (Speed: " .. speed .. ")", Color3.fromRGB(100, 200, 255))
    return function() flying = false end
end, {"f"}, "Movement")

RegisterCommand("unfly", "Disables flying", function() end, {}, "Movement")

RegisterCommand("noclip", "Enables noclip", function(args, executor)
    Noclip = true
    local char = executor.Character
    if not char then return end
    
    local connection
    connection = RunService.Stepped:Connect(function()
        if not Noclip then
            connection:Disconnect()
            return
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    OutputMessage("Noclip enabled", Color3.fromRGB(200, 100, 255))
    return function() Noclip = false end
end, {"nc"}, "Movement")

RegisterCommand("clip", "Disables noclip", function(args, executor)
    Noclip = false
    local char = executor.Character
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    OutputMessage("Noclip disabled", Color3.fromRGB(200, 100, 255))
end, {}, "Movement")

RegisterCommand("speed", "Changes walk speed", function(args, executor)
    local speed = tonumber(args[1]) or 50
    local players = GetPlayers(args[2] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
    end
    OutputMessage("Speed set to " .. speed .. " for " .. #players .. " player(s)", Color3.fromRGB(100, 255, 200))
end, {"ws"}, "Movement")

RegisterCommand("jump", "Changes jump power", function(args, executor)
    local power = tonumber(args[1]) or 50
    local players = GetPlayers(args[2] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = power
            end
        end
    end
    OutputMessage("Jump power set to " .. power .. " for " .. #players .. " player(s)", Color3.fromRGB(100, 255, 200))
end, {"jp"}, "Movement")

RegisterCommand("hipheight", "Changes hip height", function(args, executor)
    local height = tonumber(args[1]) or 0
    local players = GetPlayers(args[2] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HipHeight = height
            end
        end
    end
    OutputMessage("Hip height set to " .. height .. " for " .. #players .. " player(s)", Color3.fromRGB(100, 255, 200))
end, {"hh"}, "Movement")

-- GOD/HEALTH COMMANDS
RegisterCommand("god", "Makes you invincible", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
    end
    OutputMessage("God mode enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 255, 100))
end, {"invincible"}, "Health")

RegisterCommand("ungod", "Removes invincibility", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
    OutputMessage("God mode disabled for " .. #players .. " player(s)", Color3.fromRGB(255, 255, 100))
end, {}, "Health")

RegisterCommand("heal", "Heals selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end
    OutputMessage("Healed " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
end, {}, "Health")

RegisterCommand("respawn", "Respawns selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        player:LoadCharacter()
    end
    OutputMessage("Respawned " .. #players .. " player(s)", Color3.fromRGB(200, 200, 100))
end, {"re"}, "Health")

-- WORLD COMMANDS
RegisterCommand("time", "Changes time of day", function(args)
    local time = args[1] or "12"
    Lighting.ClockTime = tonumber(time) or 12
    OutputMessage("Time set to " .. Lighting.ClockTime, Color3.fromRGB(200, 200, 100))
end, {}, "World")

RegisterCommand("gravity", "Changes gravity", function(args)
    local gravity = tonumber(args[1]) or 196.2
    Workspace.Gravity = gravity
    OutputMessage("Gravity set to " .. gravity, Color3.fromRGB(200, 200, 100))
end, {"grav"}, "World")

RegisterCommand("brightness", "Changes brightness", function(args)
    local brightness = tonumber(args[1]) or 1
    Lighting.Brightness = brightness
    OutputMessage("Brightness set to " .. brightness, Color3.fromRGB(200, 200, 100))
end, {}, "World")

RegisterCommand("ambient", "Changes ambient color", function(args)
    if #args >= 3 then
        local r, g, b = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if r and g and b then
            Lighting.Ambient = Color3.fromRGB(r, g, b)
            OutputMessage("Ambient color set to " .. r .. ", " .. g .. ", " .. b, Color3.fromRGB(200, 200, 100))
        end
    end
end, {}, "World")

RegisterCommand("outdoorambient", "Changes outdoor ambient color", function(args)
    if #args >= 3 then
        local r, g, b = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if r and g and b then
            Lighting.OutdoorAmbient = Color3.fromRGB(r, g, b)
            OutputMessage("Outdoor ambient color set", Color3.fromRGB(200, 200, 100))
        end
    end
end, {"outdoor"}, "World")

RegisterCommand("fog", "Changes fog settings", function(args)
    if #args >= 3 then
        local enabled = args[1]:lower() == "true"
        local density = tonumber(args[2]) or 0
        local color = args[3]
        
        Lighting.FogEnd = density
        if color == "default" then
            Lighting.FogColor = Color3.fromRGB(191, 191, 191)
        elseif color:find(",") then
            local r, g, b = color:match("(%d+),(%d+),(%d+)")
            if r and g and b then
                Lighting.FogColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            end
        end
        OutputMessage("Fog updated", Color3.fromRGB(200, 200, 100))
    end
end, {}, "World")

RegisterCommand("removefog", "Removes fog", function()
    Lighting.FogEnd = 0
    OutputMessage("Fog removed", Color3.fromRGB(200, 200, 100))
end, {"nofog"}, "World")

-- ESP/VISUAL COMMANDS
RegisterCommand("esp", "Enables ESP for players", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
        if not ESPPlayers[player] then
            ESPPlayers[player] = true
            
            local function addESP(char)
                if char then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "AdminESP"
                    highlight.FillColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = char
                    highlight.Adornee = char
                    
                    -- Add billboard for name
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPName"
                    billboard.Adornee = char:WaitForChild("Head")
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Parent = billboard
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    nameLabel.Text = player.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLabel.TextScaled = true
                    
                    billboard.Parent = char
                end
            end
            
            if player.Character then
                addESP(player.Character)
            end
            
            player.CharacterAdded:Connect(addESP)
        end
    end
    OutputMessage("ESP enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

RegisterCommand("boxes", "Enables box ESP", function(args, executor)
    -- Box ESP implementation
    OutputMessage("Box ESP enabled - Coming soon!", Color3.fromRGB(255, 100, 255))
end, {"boxesp"}, "Visual")

RegisterCommand("tracers", "Enables tracers", function(args, executor)
    OutputMessage("Tracers enabled - Coming soon!", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

RegisterCommand("chams", "Enables chams", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.ForceField
                    part.Transparency = 0.3
                    part.Color = player.Team and player.TeamColor.Color or Color3.fromRGB(0, 170, 255)
                end
            end
        end
    end
    OutputMessage("Chams enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

RegisterCommand("unesp", "Disables ESP", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
        ESPPlayers[player] = nil
        if player.Character then
            for _, child in ipairs(player.Character:GetChildren()) do
                if child.Name == "AdminESP" and child:IsA("Highlight") then
                    child:Destroy()
                end
                if child.Name == "ESPName" and child:IsA("BillboardGui") then
                    child:Destroy()
                end
            end
        end
    end
    OutputMessage("ESP disabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

-- TOOLS/ITEMS COMMANDS
RegisterCommand("tools", "Gives all tools", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        for _, tool in ipairs(Workspace:GetDescendants()) do
            if tool:IsA("Tool") and tool.Parent ~= player.Backpack then
                local clone = tool:Clone()
                clone.Parent = player.Backpack
            end
        end
    end
    OutputMessage("Collected all tools for " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
end, {"alltools"}, "Items")

RegisterCommand("btools", "Gives building tools", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local tools = {"Hammer", "Clone", "Rotate"}
    
    for _, player in ipairs(players) do
        for _, toolName in ipairs(tools) do
            local tool = Instance.new("Tool")
            tool.Name = toolName
            tool.Parent = player.Backpack
        end
    end
    OutputMessage("Building tools given to " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
end, {}, "Items")

RegisterCommand("gear", "Gives gear by ID", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local gearId = tonumber(args[2])
    
    if gearId then
        for _, player in ipairs(players) do
            local success, result = pcall(function()
                return InsertService:LoadAsset(gearId)
            end)
            if success then
                for _, item in ipairs(result:GetChildren()) do
                    if item:IsA("Tool") then
                        local clone = item:Clone()
                        clone.Parent = player.Backpack
                    end
                end
            end
        end
        OutputMessage("Gear ID " .. gearId .. " given to " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
    end
end, {}, "Items")

-- FUN COMMANDS
RegisterCommand("spam", "Spams message in chat", function(args, executor)
    local message = table.concat(args, " ")
    if message == "" then return end
    
    local count = 10
    for i = 1, count do
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
        wait(0.5)
    end
    OutputMessage("Spammed message 10 times", Color3.fromRGB(255, 100, 255))
end, {}, "Fun")

RegisterCommand("play", "Plays audio by ID", function(args)
    local soundId = tonumber(args[1])
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 1
        sound.Parent = Workspace
        sound:Play()
        OutputMessage("Playing audio ID: " .. soundId, Color3.fromRGB(200, 100, 255))
    end
end, {}, "Fun")

RegisterCommand("size", "Changes player size", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local scale = tonumber(args[2]) or 2
    
    for _, player in ipairs(players) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * scale
                end
            end
        end
    end
    OutputMessage("Size changed to " .. scale .. "x for " .. #players .. " player(s)", Color3.fromRGB(200, 100, 255))
end, {}, "Fun")

RegisterCommand("spin", "Makes players spin", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local speed = tonumber(args[2]) or 50
    
    for _, player in ipairs(players) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                bodyAngularVelocity.MaxTorque = Vector3.new(40000, 40000, 40000)
                bodyAngularVelocity.AngularVelocity = Vector3.new(0, speed, 0)
                bodyAngularVelocity.Parent = root
            end
        end
    end
    OutputMessage("Spinning " .. #players .. " player(s) at speed " .. speed, Color3.fromRGB(200, 100, 255))
end, {}, "Fun")

RegisterCommand("unspin", "Stops spinning", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in ipairs(root:GetChildren()) do
                    if v:IsA("BodyAngularVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end
    OutputMessage("Stopped spinning for " .. #players .. " player(s)", Color3.fromRGB(200, 100, 255))
end, {}, "Fun")

-- SERVER COMMANDS
RegisterCommand("rejoin", "Rejoins the game", function(args, executor)
    TeleportService:Teleport(game.PlaceId, executor)
end, {"rj"}, "Server")

RegisterCommand("serverhop", "Hops to a different server", function(args, executor)
    local servers = {}
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    end)
    
    if success and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, executor)
        else
            OutputMessage("No available servers found", Color3.fromRGB(255, 100, 100))
        end
    else
        OutputMessage("Failed to get server list", Color3.fromRGB(255, 100, 100))
    end
end, {"hop"}, "Server")

RegisterCommand("copylink", "Copies server link to clipboard", function()
    setclipboard("https://www.roblox.com/games/" .. game.PlaceId .. "?code=" .. game.JobId)
    OutputMessage("Server link copied to clipboard", Color3.fromRGB(100, 255, 100))
end, {"copy", "link"}, "Server")

-- UTILITY COMMANDS
RegisterCommand("clear", "Clears the output", function()
    for _, child in ipairs(OutputScrolling:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    OutputMessage("Output cleared", Color3.fromRGB(255, 255, 255), true)
end, {"clr"}, "Utility")

RegisterCommand("help", "Shows all commands", function(args)
    local categories = {}
    for name, cmd in pairs(Commands) do
        if not categories[cmd.Category] then
            categories[cmd.Category] = {}
        end
        table.insert(categories[cmd.Category], name)
    end
    
    OutputMessage("=== COMPLETE INFINITE YIELD COMMANDS ===", Settings.HighlightColor)
    OutputMessage("Prefix: " .. Settings.Prefix, Color3.fromRGB(200, 200, 200))
    OutputMessage("Total Commands: " .. #Commands, Color3.fromRGB(200, 200, 200))
    
    for category, cmds in pairs(categories) do
        OutputMessage("[" .. category .. "]", Color3.fromRGB(0, 170, 255))
        table.sort(cmds)
        for _, cmdName in ipairs(cmds) do
            local cmd = Commands[cmdName]
            local aliasText = ""
            if #cmd.Aliases > 0 then
                aliasText = " (Aliases: " .. table.concat(cmd.Aliases, ", ") .. ")"
            end
            OutputMessage("  " .. Settings.Prefix .. cmdName .. aliasText, Color3.fromRGB(220, 220, 220))
        end
    end
end, {"h", "commands"}, "Utility")

RegisterCommand("prefix", "Changes command prefix", function(args)
    if args[1] then
        local newPrefix = args[1]
        if #newPrefix > 1 then
            OutputMessage("Prefix must be 1 character", Color3.fromRGB(255, 50, 50))
            return
        end
        Settings.Prefix = newPrefix
        OutputMessage("Prefix changed to: " .. Settings.Prefix, Settings.HighlightColor)
    else
        OutputMessage("Current prefix: " .. Settings.Prefix, Settings.HighlightColor)
    end
end, {}, "Utility")

RegisterCommand("history", "Shows command history", function()
    OutputMessage("=== Command History ===", Settings.HighlightColor)
    for i, cmd in ipairs(CommandHistory) do
        OutputMessage(i .. ". " .. cmd, Color3.fromRGB(200, 200, 200))
    end
end, {}, "Utility")

-- ADMIN COMMANDS
RegisterCommand("players", "Lists all players", function()
    OutputMessage("=== Players Online (" .. #Players:GetPlayers() .. ") ===", Settings.HighlightColor)
    for _, player in ipairs(Players:GetPlayers()) do
        local teamText = player.Team and " [" .. player.Team.Name .. "]" or ""
        local status = player.Character and "Alive" or "Dead"
        OutputMessage(player.Name .. " (ID: " .. player.UserId .. ")" .. teamText .. " - " .. status, Color3.fromRGB(200, 200, 200))
    end
end, {"plr", "list"}, "Admin")

RegisterCommand("info", "Shows player info", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    
    for _, player in ipairs(players) do
        OutputMessage("=== " .. player.Name .. " Info ===", Settings.HighlightColor)
        OutputMessage("Display Name: " .. player.DisplayName, Color3.fromRGB(200, 200, 200))
        OutputMessage("User ID: " .. player.UserId, Color3.fromRGB(200, 200, 200))
        OutputMessage("Account Age: " .. player.AccountAge .. " days", Color3.fromRGB(200, 200, 200))
        OutputMessage("Team: " .. (player.Team and player.Team.Name or "No Team"), Color3.fromRGB(200, 200, 200))
        
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                OutputMessage("Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), Color3.fromRGB(200, 200, 200))
                OutputMessage("WalkSpeed: " .. humanoid.WalkSpeed, Color3.fromRGB(200, 200, 200))
                OutputMessage("JumpPower: " .. humanoid.JumpPower, Color3.fromRGB(200, 200, 200))
            end
        end
    end
end, {}, "Admin")

-- ==================== COMMAND PARSER ====================

local function ExecuteCommand(text, executor)
    if text:sub(1, 1) == Settings.Prefix then
        local args = {}
        for arg in text:gmatch("%S+") do
            table.insert(args, arg)
        end
        
        local commandName = string.lower(args[1]:sub(2))
        table.remove(args, 1)
        
        -- Save to history
        table.insert(CommandHistory, text)
        if #CommandHistory > Settings.MaxHistory then
            table.remove(CommandHistory, 1)
        end
        HistoryIndex = #CommandHistory + 1
        
        local command = Commands[commandName] or Commands[Aliases[commandName]]
        
        if command then
            OutputMessage("> " .. text, Settings.HighlightColor)
            command:Execute(args, executor or LocalPlayer)
        else
            OutputMessage("Command not found: " .. commandName, Color3.fromRGB(255, 50, 50))
        end
    else
        OutputMessage("Invalid command format. Use prefix: " .. Settings.Prefix, Color3.fromRGB(255, 50, 50))
    end
end

-- ==================== UI EVENTS ====================

-- Mobile Toggle Button
MobileToggleButton.MouseButton1Click:Connect(function()
    OutputFrame.Visible = not OutputFrame.Visible
    MobileToggleButton.Text = OutputFrame.Visible and "CLOSE" or "OPEN"
end)

-- Command Bar Input
CommandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = CommandInput.Text
        CommandInput.Text = ""
        CommandBar.Visible = false
        if text ~= "" then
            ExecuteCommand(Settings.Prefix .. text, LocalPlayer)
        end
    end
end)

CloseCmdButton.MouseButton1Click:Connect(function()
    CommandBar.Visible = false
    CommandInput.Text = ""
end)

-- Mobile Command Input
MobileSendButton.MouseButton1Click:Connect(function()
    local text = MobileInputBox.Text
    if text ~= "" then
        MobileInputBox.Text = ""
        ExecuteCommand(Settings.Prefix .. text, LocalPlayer)
    end
end)

MobileInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = MobileInputBox.Text
        if text ~= "" then
            MobileInputBox.Text = ""
            ExecuteCommand(Settings.Prefix .. text, LocalPlayer)
        end
    end
end)

-- UI Buttons
CloseButton.MouseButton1Click:Connect(function()
    OutputFrame.Visible = false
    MobileToggleButton.Text = "OPEN"
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local isMinimized = OutputScrolling.Visible
    OutputScrolling.Visible = isMinimized
    MobileQuickBar.Visible = isMinimized
    MobileCommandInput.Visible = isMinimized
    if isMinimized then
        MinimizeButton.Text = "_"
        OutputFrame.Size = Settings.GUISize
    else
        MinimizeButton.Text = "+"
        OutputFrame.Size = UDim2.new(Settings.GUISize.X.Scale, Settings.GUISize.X.Offset, 0, isMobile and 40 or 30)
    end
end)

-- Mobile touch gestures
if isMobile then
    -- Double tap to open command bar
    local lastTap = 0
    OutputFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local currentTime = tick()
            if currentTime - lastTap < 0.5 then
                CommandBar.Visible = true
                CommandInput:CaptureFocus()
            end
            lastTap = currentTime
        end
    end)
end

-- Desktop keybinds
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        -- Toggle Command Bar
        if input.KeyCode == Settings.Keybinds.CommandBar then
            if not CommandBar.Visible then
                CommandBar.Visible = true
                CommandInput:CaptureFocus()
            end
        end
        
        -- Toggle Output Frame
        if input.KeyCode == Settings.Keybinds.ToggleGUI then
            OutputFrame.Visible = not OutputFrame.Visible
        end
        
        -- Escape to close command bar
        if input.KeyCode == Enum.KeyCode.Escape then
            if CommandBar.Visible then
                CommandBar.Visible = false
                CommandInput.Text = ""
            end
        end
        
        -- Command history navigation
        if CommandBar.Visible and CommandInput:IsFocused() then
            if input.KeyCode == Enum.KeyCode.Up then
                if HistoryIndex > 1 then
                    HistoryIndex = HistoryIndex - 1
                    CommandInput.Text = CommandHistory[HistoryIndex]:sub(2) or ""
                elseif HistoryIndex == 1 then
                    CommandInput.Text = CommandHistory[1]:sub(2) or ""
                end
            elseif input.KeyCode == Enum.KeyCode.Down then
                if HistoryIndex < #CommandHistory then
                    HistoryIndex = HistoryIndex + 1
                    CommandInput.Text = CommandHistory[HistoryIndex]:sub(2) or ""
                elseif HistoryIndex == #CommandHistory then
                    HistoryIndex = #CommandHistory + 1
                    CommandInput.Text = ""
                end
            end
        end
    end)
end

-- ==================== INITIALIZATION ====================

-- Anti-AFK
if Settings.AntiBan then
    Players.LocalPlayer.Idled:Connect(function()
        if Settings.AntiBan then
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendKeyEvent(true, "W", false, nil)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "W", false, nil)
        end
    end)
end

-- Auto Clean
if Settings.AutoClean then
    spawn(function()
        while task.wait(5) do
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Tool") or (obj:IsA("BasePart") and not obj.Anchored and obj:GetMass() < 10) then
                    obj:Destroy()
                end
            end
        end
    end)
end

-- Initial Output
task.wait(1)
OutputMessage("=== Superskksksjsjsj's Infinite Yield ===", Settings.HighlightColor)
OutputMessage("Version: 3.0.0 - Complete Infinite Yield", Color3.fromRGB(200, 200, 200))
OutputMessage("Prefix: " .. Settings.Prefix, Color3.fromRGB(200, 200, 200))
OutputMessage("Loaded successfully!", Color3.fromRGB(100, 255, 100))
if isMobile then
    OutputMessage("📱 Mobile Mode: Active", Color3.fromRGB(0, 170, 255))
    OutputMessage("Quick buttons available above", Color3.fromRGB(200, 200, 200))
    OutputMessage("Type commands in box below", Color3.fromRGB(200, 200, 200))
    OutputMessage("Double tap window for full command bar", Color3.fromRGB(200, 200, 200))
else
    OutputMessage("Press '" .. Settings.Keybinds.CommandBar.Name .. "' for command bar", Color3.fromRGB(200, 200, 200))
    OutputMessage("Press '" .. Settings.Keybinds.ToggleGUI.Name .. "' to toggle GUI", Color3.fromRGB(200, 200, 200))
    OutputMessage("Use UP/DOWN arrows for command history", Color3.fromRGB(200, 200, 200))
end
OutputMessage("Type '" .. Settings.Prefix .. "help' for command list", Color3.fromRGB(200, 200, 200))

-- Welcome Notification
CreateNotification(
    "Infinite Yield Style Admin", 
    "Script loaded successfully!\n" .. 
    "Prefix: " .. Settings.Prefix .. "\n" ..
    (isMobile and "📱 Mobile mode active" or "Press " .. Settings.Keybinds.ToggleGUI.Name .. " to toggle GUI"),
    Settings.HighlightColor,
    5
)

-- Make GUI responsive
local function UpdateUIScale()
    local viewportSize = Workspace.CurrentCamera.ViewportSize
    
    if isMobile then
        local scale = math.min(viewportSize.X / 1080, viewportSize.Y / 1920)
        OutputFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
        MobileToggleButton.Size = UDim2.new(0.12, 0, 0.06, 0)
        MobileToggleButton.Position = UDim2.new(0.85, 0, 0.02, 0)
        Title.TextSize = 16
    else
        local scale = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
        OutputFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
        CommandBar.Size = UDim2.new(0.4, 0, 0, 35)
    end
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateUIScale)
UpdateUIScale()

-- Keep script running
while true do
    task.wait(1)
end
