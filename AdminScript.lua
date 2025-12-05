--[[
    Superskksksjsjsj's Admin Script
    Version: 2.1.0 - MOBILE FRIENDLY
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
local MarketPlaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

-- Device Detection
local isMobile = UserInputService.TouchEnabled
local isGamepad = UserInputService.GamepadEnabled

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Commands = {}
local Aliases = {}
local Settings = {
    Prefix = ";",
    NotificationDuration = 5,
    MaxHistory = 100,
    AntiBan = true,
    AutoClean = false,
    GUIPosition = isMobile and UDim2.new(0.05, 0, 0.1, 0) or UDim2.new(0.35, 0, 0, 50),
    GUISize = isMobile and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0.3, 0, 0.5, 0),
    Keybinds = {
        ToggleGUI = Enum.KeyCode.F3,
        CommandBar = Enum.KeyCode.Semicolon
    },
    CmdBarTheme = "Dark",
    HighlightColor = Color3.fromRGB(0, 170, 255),
    MobileUIVisible = true
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

-- MOBILE FLOATING BUTTON (Always visible)
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

-- INFINITE YIELD STYLE COMMAND BAR
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

-- Output Frame (Like Infinite Yield's Output) - AUTO SHOW ON MOBILE
local OutputFrame = Instance.new("Frame")
OutputFrame.Name = "OutputFrame"
OutputFrame.Parent = ScreenGui
OutputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OutputFrame.BackgroundTransparency = 0.1
OutputFrame.BorderSizePixel = 0
OutputFrame.Position = Settings.GUIPosition
OutputFrame.Size = Settings.GUISize
OutputFrame.Visible = isMobile and Settings.MobileUIVisible or false  -- Auto show on mobile
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
Title.Text = isMobile and "📱 Mobile Admin" or "Superskksksjsjsj's Admin"
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

-- MOBILE QUICK BUTTONS BAR
local MobileQuickBar = Instance.new("Frame")
MobileQuickBar.Name = "MobileQuickBar"
MobileQuickBar.Parent = OutputFrame
MobileQuickBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MobileQuickBar.BorderSizePixel = 0
MobileQuickBar.Position = UDim2.new(0, 0, 0.12, 0)
MobileQuickBar.Size = UDim2.new(1, 0, 0.1, 0)
MobileQuickBar.Visible = isMobile

local QuickButtonLayout = Instance.new("UIListLayout")
QuickButtonLayout.Parent = MobileQuickBar
QuickButtonLayout.FillDirection = Enum.FillDirection.Horizontal
QuickButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
QuickButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
QuickButtonLayout.Padding = UDim.new(0, 5)

-- Create Quick Buttons
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
        ParseCommand(Settings.Prefix .. quickCmd.Command, LocalPlayer)
    end)
end

local OutputScrolling = Instance.new("ScrollingFrame")
OutputScrolling.Name = "OutputScrolling"
OutputScrolling.Parent = OutputFrame
OutputScrolling.BackgroundTransparency = 1
OutputScrolling.BorderSizePixel = 0
OutputScrolling.Position = UDim2.new(0.02, 0, isMobile and 0.24 or 0.07, 0)
OutputScrolling.Size = UDim2.new(0.96, 0, isMobile and 0.74 or 0.91, 0)
OutputScrolling.CanvasSize = UDim2.new(0, 0, 5, 0)
OutputScrolling.ScrollBarThickness = 6
OutputScrolling.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
OutputScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
OutputScrolling.VerticalScrollBarInset = Enum.ScrollBarInset.Always

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = OutputScrolling
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

-- Mobile Command Input at Bottom
local MobileCommandInput = Instance.new("Frame")
MobileCommandInput.Name = "MobileCommandInput"
MobileCommandInput.Parent = OutputFrame
MobileCommandInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MobileCommandInput.BorderSizePixel = 0
MobileCommandInput.Position = UDim2.new(0, 0, isMobile and 0.9 or 0.95, 0)
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
MobileInputBox.PlaceholderText = "Type command..."
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

-- Player Finder
local function GetPlayers(input, executor)
    local players = {}
    local inputLower = input and string.lower(input) or ""
    local executor = executor or LocalPlayer
    
    if inputLower == "" then
        return {executor}
    end
    
    -- Special keywords
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
        end
    }
    
    if keywords[inputLower] then
        return keywords[inputLower]()
    end
    
    -- Player name/ID search
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
local CommandHistory = {}
local HistoryIndex = 0
local ActiveLoops = {}

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
        elseif self.Name:find("unloop") or self.Name:find("stop") then
            local baseCmd = self.Name:gsub("un", ""):gsub("stop", "")
            if ActiveLoops[baseCmd] then
                ActiveLoops[baseCmd]()
                ActiveLoops[baseCmd] = nil
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

-- PLAYER COMMANDS
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
end, {"k"}, "Player")

RegisterCommand("kick", "Kicks selected players", function(args, executor)
    local players = GetPlayers(args[1] or "me", executor)
    local reason = table.concat(args, " ", 2) or "Kicked by admin"
    
    for _, player in ipairs(players) do
        player:Kick("[Admin] " .. reason)
    end
    OutputMessage("Kicked " .. #players .. " player(s)", Color3.fromRGB(255, 150, 50))
end, {}, "Player")

-- MOVEMENT COMMANDS
RegisterCommand("fly", "Enables flying", function(args, executor)
    local speed = tonumber(args[1]) or 50
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
        
        -- Mobile touch controls
        if isMobile then
            local touchThumbstick = game:GetService("VirtualInputManager"):GetTouchThumbstick()
            if touchThumbstick then
                move = move + Vector3.new(touchThumbstick.Position.X, 0, -touchThumbstick.Position.Y)
            end
        end
        
        bodyVelocity.Velocity = move.Unit * speed
    end)
    
    OutputMessage("Fly enabled (Speed: " .. speed .. ")", Color3.fromRGB(100, 200, 255))
    
    return function()
        flying = false
    end
end, {"f"}, "Movement")

RegisterCommand("unfly", "Disables flying", function() end, {}, "Movement")

RegisterCommand("noclip", "Enables noclip", function(args, executor)
    local char = executor.Character
    if not char then return end
    
    local noclipConnection
    noclipConnection = RunService.Stepped:Connect(function()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    OutputMessage("Noclip enabled", Color3.fromRGB(200, 100, 255))
    
    return function()
        noclipConnection:Disconnect()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end, {"nc"}, "Movement")

RegisterCommand("clip", "Disables noclip", function() end, {}, "Movement")

RegisterCommand("speed", "Changes walk speed", function(args, executor)
    local speed = tonumber(args[1]) or 50
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
    
    OutputMessage("Speed set to " .. speed, Color3.fromRGB(100, 255, 200))
end, {"ws"}, "Movement")

-- GOD/HEALTH COMMANDS
RegisterCommand("god", "Makes you invincible", function(args, executor)
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    OutputMessage("God mode enabled", Color3.fromRGB(255, 255, 100))
end, {"invincible"}, "Health")

RegisterCommand("ungod", "Removes invincibility", function(args, executor)
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
    
    OutputMessage("God mode disabled", Color3.fromRGB(255, 255, 100))
end, {}, "Health")

-- ESP/VISUAL COMMANDS
RegisterCommand("esp", "Enables ESP for players", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "AdminESP"
            highlight.FillColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = player.Character
            highlight.Adornee = player.Character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end
    OutputMessage("ESP enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

-- MORE COMMANDS (Added for completeness)
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

RegisterCommand("gravity", "Changes gravity", function(args)
    local gravity = tonumber(args[1]) or 196.2
    Workspace.Gravity = gravity
    OutputMessage("Gravity set to " .. gravity, Color3.fromRGB(200, 200, 100))
end, {"grav"}, "World")

RegisterCommand("time", "Changes time of day", function(args)
    local time = args[1] or "12:00"
    if tonumber(time) then
        Lighting.ClockTime = tonumber(time)
    else
        local hours, minutes = time:match("(%d+):(%d+)")
        if hours and minutes then
            Lighting.ClockTime = tonumber(hours) + tonumber(minutes)/60
        end
    end
    OutputMessage("Time set to " .. Lighting.ClockTime, Color3.fromRGB(200, 200, 100))
end, {}, "World")

RegisterCommand("brightness", "Changes brightness", function(args)
    local brightness = tonumber(args[1]) or 1
    Lighting.Brightness = brightness
    OutputMessage("Brightness set to " .. brightness, Color3.fromRGB(200, 200, 100))
end, {}, "World")

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
        end
    end
end, {"hop"}, "Server")

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
    
    OutputMessage("=== MOBILE ADMIN COMMANDS ===", Settings.HighlightColor)
    OutputMessage("Prefix: " .. Settings.Prefix, Color3.fromRGB(200, 200, 200))
    OutputMessage("Commands:", Color3.fromRGB(200, 200, 200))
    
    for category, cmds in pairs(categories) do
        OutputMessage("[" .. category .. "]", Color3.fromRGB(0, 170, 255))
        table.sort(cmds)
        for _, cmdName in ipairs(cmds) do
            local cmd = Commands[cmdName]
            local aliasText = ""
            if #cmd.Aliases > 0 then
                aliasText = " (" .. table.concat(cmd.Aliases, ", ") .. ")"
            end
            OutputMessage("  " .. Settings.Prefix .. cmdName .. aliasText, Color3.fromRGB(220, 220, 220))
            OutputMessage("    " .. cmd.Description, Color3.fromRGB(180, 180, 180))
        end
    end
end, {"h", "commands"}, "Utility")

-- ==================== COMMAND PARSER ====================

local function ParseCommand(text, executor)
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
        
        local command = Commands[commandName] or Commands[Aliases[commandName]]
        
        if command then
            OutputMessage("> " .. text, Settings.HighlightColor)
            command:Execute(args, executor or LocalPlayer)
        else
            OutputMessage("Command not found: " .. commandName, Color3.fromRGB(255, 50, 50))
            CreateNotification("Command Error", "Unknown command: " .. commandName, Color3.fromRGB(255, 50, 50), 2)
        end
    else
        OutputMessage("Invalid command: " .. text, Color3.fromRGB(255, 50, 50))
    end
end

-- ==================== MOBILE UI EVENTS ====================

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
        ParseCommand(Settings.Prefix .. text, LocalPlayer)
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
        ParseCommand(Settings.Prefix .. text, LocalPlayer)
    end
end)

MobileInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = MobileInputBox.Text
        if text ~= "" then
            MobileInputBox.Text = ""
            ParseCommand(Settings.Prefix .. text, LocalPlayer)
        end
    end
end)

-- Toggle Output Frame
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
                -- Double tap detected
                CommandBar.Visible = true
                CommandInput:CaptureFocus()
            end
            lastTap = currentTime
        end
    end)
    
    -- Swipe to clear output
    local startPos
    OutputFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            startPos = input.Position
        end
    end)
    
    OutputFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and startPos then
            local endPos = input.Position
            local delta = startPos - endPos
            if math.abs(delta.Y) > 50 and math.abs(delta.X) < 30 then
                -- Swipe detected
                if delta.Y > 0 then
                    -- Swipe up
                    ParseCommand(Settings.Prefix .. "clear", LocalPlayer)
                end
            end
        end
    end)
end

-- Keybinds (for non-mobile)
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
OutputMessage("=== Superskksksjsjsj's Mobile Admin ===", Settings.HighlightColor)
OutputMessage("Version: 2.1.0 - TOUCH FRIENDLY", Color3.fromRGB(200, 200, 200))
OutputMessage("Loaded successfully!", Color3.fromRGB(100, 255, 100))
if isMobile then
    OutputMessage("📱 Mobile Mode: Active", Color3.fromRGB(0, 170, 255))
    OutputMessage("Use buttons above for quick commands", Color3.fromRGB(200, 200, 200))
    OutputMessage("Type commands in box below", Color3.fromRGB(200, 200, 200))
    OutputMessage("Double tap window to open full command bar", Color3.fromRGB(200, 200, 200))
    OutputMessage("Swipe up on window to clear output", Color3.fromRGB(200, 200, 200))
else
    OutputMessage("Press '" .. Settings.Keybinds.CommandBar.Name .. "' to open command bar", Color3.fromRGB(200, 200, 200))
    OutputMessage("Press '" .. Settings.Keybinds.ToggleGUI.Name .. "' to toggle output window", Color3.fromRGB(200, 200, 200))
end
OutputMessage("Type ';help' for command list", Color3.fromRGB(200, 200, 200))

-- Welcome Notification
CreateNotification(
    "Superskksksjsjsj's Mobile Admin", 
    "Script loaded successfully!\n" .. (isMobile and "📱 Mobile mode active" or "Press F3 to toggle GUI"),
    Settings.HighlightColor,
    5
)

-- Make GUI responsive
local function UpdateUIScale()
    local viewportSize = Workspace.CurrentCamera.ViewportSize
    
    if isMobile then
        -- Mobile scaling
        local scale = math.min(viewportSize.X / 1080, viewportSize.Y / 1920)
        OutputFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
        MobileToggleButton.Size = UDim2.new(0.12, 0, 0.06, 0)
        MobileToggleButton.Position = UDim2.new(0.85, 0, 0.02, 0)
        
        -- Adjust text sizes for mobile
        Title.TextSize = 16
        OutputScrolling.ScrollBarThickness = 8
        MobileInputBox.TextSize = 18
        MobileSendButton.TextSize = 16
        
        for _, child in ipairs(MobileQuickBar:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextSize = 14
            end
        end
    else
        -- Desktop scaling
        local scale = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
        OutputFrame.Size = UDim2.new(0.35 * scale, 0, 0.6 * scale, 0)
        CommandBar.Size = UDim2.new(0.4 * scale, 0, 0, 35)
    end
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateUIScale)
UpdateUIScale()

-- Keep script running
while true do
    task.wait(1)
end
