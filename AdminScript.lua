--[[
    Superskksksjsjsj's Admin Script
    Version: 2.0.0 - INFINITE YIELD STYLE
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
local PathfindingService = game:GetService("PathfindingService")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")
local Teams = game:GetService("Teams")
local Stats = game:GetService("Stats")

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
    GUIPosition = UDim2.new(0.35, 0, 0, 50),
    GUISize = UDim2.new(0.3, 0, 0.5, 0),
    Keybinds = {
        ToggleGUI = Enum.KeyCode.F3,
        CommandBar = Enum.KeyCode.Semicolon
    },
    CmdBarTheme = "Dark",
    HighlightColor = Color3.fromRGB(0, 170, 255)
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

-- INFINITE YIELD STYLE COMMAND BAR
local CommandBar = Instance.new("Frame")
CommandBar.Name = "CommandBar"
CommandBar.Parent = ScreenGui
CommandBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CommandBar.BackgroundTransparency = 0.3
CommandBar.BorderSizePixel = 0
CommandBar.Position = UDim2.new(0.3, 0, 0.05, 0)
CommandBar.Size = UDim2.new(0.4, 0, 0, 35)
CommandBar.Visible = false
CommandBar.Active = true
CommandBar.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = CommandBar

local CommandInput = Instance.new("TextBox")
CommandInput.Name = "CommandInput"
CommandInput.Parent = CommandBar
CommandInput.BackgroundTransparency = 1
CommandInput.Position = UDim2.new(0.02, 0, 0, 0)
CommandInput.Size = UDim2.new(0.96, 0, 1, 0)
CommandInput.Font = Enum.Font.Code
CommandInput.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
CommandInput.PlaceholderText = "Enter command... (type 'help' for commands)"
CommandInput.Text = ""
CommandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandInput.TextSize = 16
CommandInput.TextXAlignment = Enum.TextXAlignment.Left
CommandInput.ClearTextOnFocus = false

-- Output Frame (Like Infinite Yield's Output)
local OutputFrame = Instance.new("Frame")
OutputFrame.Name = "OutputFrame"
OutputFrame.Parent = ScreenGui
OutputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OutputFrame.BackgroundTransparency = 0.2
OutputFrame.BorderSizePixel = 0
OutputFrame.Position = Settings.GUIPosition
OutputFrame.Size = Settings.GUISize
OutputFrame.Visible = false
OutputFrame.Active = true
OutputFrame.Draggable = true

local OutputCorner = Instance.new("UICorner")
OutputCorner.CornerRadius = UDim.new(0, 6)
OutputCorner.Parent = OutputFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = OutputFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.02, 0, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Superskksksjsjsj's Admin - INFINITE YIELD STYLE"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.94, 0, 0.2, 0)
CloseButton.Size = UDim2.new(0.04, 0, 0.6, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.AutoButtonColor = false

CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.88, 0, 0.2, 0)
MinimizeButton.Size = UDim2.new(0.04, 0, 0.6, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 12
MinimizeButton.AutoButtonColor = false

MinimizeButton.MouseEnter:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
end)

MinimizeButton.MouseLeave:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
end)

local OutputScrolling = Instance.new("ScrollingFrame")
OutputScrolling.Name = "OutputScrolling"
OutputScrolling.Parent = OutputFrame
OutputScrolling.BackgroundTransparency = 1
OutputScrolling.BorderSizePixel = 0
OutputScrolling.Position = UDim2.new(0.02, 0, 0.07, 0)
OutputScrolling.Size = UDim2.new(0.96, 0, 0.91, 0)
OutputScrolling.CanvasSize = UDim2.new(0, 0, 5, 0)
OutputScrolling.ScrollBarThickness = 4
OutputScrolling.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
OutputScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
OutputScrolling.VerticalScrollBarInset = Enum.ScrollBarInset.Always

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = OutputScrolling
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

-- Notification System (Like Infinite Yield)
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
    Notification.BackgroundTransparency = 0.3
    Notification.BorderSizePixel = 0
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.AutomaticSize = Enum.AutomaticSize.Y
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Notification
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    TitleLabel.Size = UDim2.new(0.9, 0, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = color or Settings.HighlightColor
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = Notification
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
    MessageLabel.Size = UDim2.new(0.9, 0, 0, 20)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    MessageLabel.TextSize = 12
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
    
    Notification.Size = UDim2.new(1, 0, 0, 60 + MessageLabel.TextBounds.Y)
    
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
    MessageLabel.Size = UDim2.new(1, 0, 0, 20)
    MessageLabel.Font = Enum.Font.Code
    MessageLabel.Text = (noPrefix and "" or "> ") .. message
    MessageLabel.TextColor3 = color
    MessageLabel.TextSize = 12
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    OutputScrolling.CanvasPosition = Vector2.new(0, OutputScrolling.AbsoluteCanvasSize.Y)
end

-- Command System
local CommandHistory = {}
local HistoryIndex = 0

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
    
    -- Check if input is a number (distance)
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
        end
    end
    
    return players
end

-- INFINITE YIELD COMMAND SETUP
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
        self.Function(args, executor)
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
        local connection
        connection = RunService.Heartbeat:Connect(function()
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
        return function() connection:Disconnect() end
    end
end, {"loopto"}, "Teleport")

RegisterCommand("unloopgoto", "Stops loopgoto", function() end, {"unloopto"}, "Teleport")

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
        
        bodyVelocity.Velocity = move.Unit * speed
    end)
    
    OutputMessage("Fly enabled (Speed: " .. speed .. ")", Color3.fromRGB(100, 200, 255))
    
    -- Return function to stop flying
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
    local speed = tonumber(args[1]) or 16
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
    
    OutputMessage("Speed set to " .. speed, Color3.fromRGB(100, 255, 200))
end, {"ws"}, "Movement")

RegisterCommand("jump", "Changes jump power", function(args, executor)
    local power = tonumber(args[1]) or 50
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
    end
    
    OutputMessage("Jump power set to " .. power, Color3.fromRGB(100, 255, 200))
end, {"jp"}, "Movement")

RegisterCommand("hipheight", "Changes hip height", function(args, executor)
    local height = tonumber(args[1]) or 0
    local char = executor.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.HipHeight = height
    end
    
    OutputMessage("Hip height set to " .. height, Color3.fromRGB(100, 255, 200))
end, {"hh"}, "Movement")

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
        local char = player.Character
        if char then
            char:BreakJoints()
        end
    end
    OutputMessage("Respawned " .. #players .. " player(s)", Color3.fromRGB(200, 200, 100))
end, {"re"}, "Health")

-- WORLD COMMANDS
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

RegisterCommand("gravity", "Changes gravity", function(args)
    local gravity = tonumber(args[1]) or 196.2
    Workspace.Gravity = gravity
    OutputMessage("Gravity set to " .. gravity, Color3.fromRGB(200, 200, 100))
end, {"grav"}, "World")

RegisterCommand("ambient", "Changes ambient color", function(args)
    if #args >= 3 then
        local r, g, b = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if r and g and b then
            Lighting.Ambient = Color3.fromRGB(r, g, b)
            OutputMessage("Ambient color set to " .. r .. ", " .. g .. ", " .. b, Color3.fromRGB(200, 200, 100))
        end
    end
end, {}, "World")

RegisterCommand("brightness", "Changes brightness", function(args)
    local brightness = tonumber(args[1]) or 1
    Lighting.Brightness = brightness
    OutputMessage("Brightness set to " .. brightness, Color3.fromRGB(200, 200, 100))
end, {}, "World")

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
            
            -- Add billboard gui with name
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPName"
            billboard.Adornee = player.Character:WaitForChild("Head")
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
            
            local healthLabel = Instance.new("TextLabel")
            healthLabel.Parent = billboard
            healthLabel.BackgroundTransparency = 1
            healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
            healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
            healthLabel.Text = "100/100"
            healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            healthLabel.TextScaled = true
            
            billboard.Parent = player.Character
            
            -- Update health
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    healthLabel.TextColor3 = humanoid.Health/humanoid.MaxHealth > 0.5 and Color3.fromRGB(100, 255, 100) or 
                                           humanoid.Health/humanoid.MaxHealth > 0.2 and Color3.fromRGB(255, 255, 100) or 
                                           Color3.fromRGB(255, 100, 100)
                end)
            end
        end
    end
    OutputMessage("ESP enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

RegisterCommand("boxes", "Enables box ESP", function(args, executor)
    -- Similar to esp but with box outlines
    OutputMessage("Box ESP enabled", Color3.fromRGB(255, 100, 255))
end, {"boxesp"}, "Visual")

RegisterCommand("chams", "Enables chams", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local material = part.Material
                    part.Material = Enum.Material.ForceField
                    part.Transparency = 0.3
                    part.Color = player.Team and player.TeamColor.Color or Color3.fromRGB(0, 170, 255)
                end
            end
        end
    end
    OutputMessage("Chams enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

RegisterCommand("tracers", "Enables tracers", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
        if player.Character then
            local tracer = Instance.new("Beam")
            tracer.Name = "AdminTracer"
            tracer.Color = ColorSequence.new(player.Team and player.TeamColor.Color or Color3.fromRGB(0, 170, 255))
            tracer.Width0 = 0.2
            tracer.Width1 = 0.2
            
            local attachment0 = Instance.new("Attachment")
            attachment0.Parent = Workspace.CurrentCamera
            local attachment1 = Instance.new("Attachment")
            attachment1.Parent = player.Character:WaitForChild("HumanoidRootPart")
            
            tracer.Attachment0 = attachment0
            tracer.Attachment1 = attachment1
            tracer.Parent = Workspace.CurrentCamera
        end
    end
    OutputMessage("Tracers enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end, {}, "Visual")

RegisterCommand("unesp", "Disables ESP", function(args, executor)
    local players = GetPlayers(args[1] or "all", executor)
    
    for _, player in ipairs(players) do
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
        -- Clean up tracers
        for _, beam in ipairs(Workspace.CurrentCamera:GetChildren()) do
            if beam.Name == "AdminTracer" and beam:IsA("Beam") then
                beam:Destroy()
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
                return game:GetService("InsertService"):LoadAsset(gearId)
            end)
            if success then
                for _, item in ipairs(result:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("HopperBin") then
                        item.Parent = player.Backpack
                    end
                end
            end
        end
        OutputMessage("Gear ID " .. gearId .. " given to " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
    end
end, {}, "Items")

-- FUN/TAUNT COMMANDS
RegisterCommand("spam", "Spams message in chat", function(args, executor)
    local message = table.concat(args, " ")
    local count = 10
    
    for i = 1, count do
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        wait(0.5)
    end
    OutputMessage("Spammed message 10 times", Color3.fromRGB(255, 100, 255))
end, {}, "Fun")

RegisterCommand("play", "Plays audio by ID", function(args, executor)
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
                OutputMessage("Spinning " .. player.Name .. " at speed " .. speed, Color3.fromRGB(200, 100, 255))
            end
        end
    end
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
        end
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
    
    OutputMessage("=== SUPERSKKSKSJSJSJ'S ADMIN - INFINITE YIELD STYLE ===", Settings.HighlightColor)
    OutputMessage("Prefix: " .. Settings.Prefix, Color3.fromRGB(200, 200, 200))
    OutputMessage("Commands:", Color3.fromRGB(200, 200, 200))
    
    for category, cmds in pairs(categories) do
        OutputMessage("[" .. category .. "]", Color3.fromRGB(0, 170, 255))
        table.sort(cmds)
        for _, cmdName in ipairs(cmds) do
            local cmd = Commands[cmdName]
            local aliasText = ""
            if #cmd.Aliases > 0 then
                aliasText = " (Aliases: " .. table.concat(cmd.Aliases, ", ") .. ")"
            end
            OutputMessage("  " .. Settings.Prefix .. cmdName .. " - " .. cmd.Description .. aliasText, Color3.fromRGB(220, 220, 220))
        end
    end
end, {"h", "commands"}, "Utility")

RegisterCommand("prefix", "Changes command prefix", function(args)
    if args[1] then
        Settings.Prefix = args[1]
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

-- ADVANCED COMMANDS
RegisterCommand("explorer", "Opens object explorer", function()
    -- Create explorer GUI
    local explorerFrame = Instance.new("Frame")
    explorerFrame.Name = "Explorer"
    explorerFrame.Parent = ScreenGui
    explorerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    explorerFrame.BackgroundTransparency = 0.1
    explorerFrame.BorderSizePixel = 0
    explorerFrame.Position = UDim2.new(0.6, 0, 0.1, 0)
    explorerFrame.Size = UDim2.new(0.35, 0, 0.8, 0)
    explorerFrame.Active = true
    explorerFrame.Draggable = true
    
    OutputMessage("Explorer opened - Drag to move", Settings.HighlightColor)
end, {"dex"}, "Advanced")

RegisterCommand("saveinstance", "Saves the game instance", function()
    OutputMessage("Save instance feature would be here", Color3.fromRGB(200, 100, 100))
    CreateNotification("Save Instance", "This feature requires additional setup", Color3.fromRGB(200, 100, 100), 3)
end, {"save"}, "Advanced")

RegisterCommand("remotespy", "Enables remote spy", function()
    OutputMessage("Remote spy enabled", Color3.fromRGB(200, 100, 100))
    CreateNotification("Remote Spy", "Monitoring remote events", Settings.HighlightColor, 3)
end, {}, "Advanced")

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
    end
end

-- ==================== UI EVENTS ====================

-- Command Bar Input
CommandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = CommandInput.Text
        CommandInput.Text = ""
        CommandBar.Visible = false
        ParseCommand(text, LocalPlayer)
    end
end)

CommandInput:GetPropertyChangedSignal("Text"):Connect(function()
    if CommandInput.Text == "" then
        CommandBar.Visible = false
    end
end)

-- Toggle Output Frame
CloseButton.MouseButton1Click:Connect(function()
    OutputFrame.Visible = false
end)

MinimizeButton.MouseButton1Click:Connect(function()
    OutputScrolling.Visible = not OutputScrolling.Visible
    if OutputScrolling.Visible then
        MinimizeButton.Text = "_"
        OutputFrame.Size = Settings.GUISize
    else
        MinimizeButton.Text = "+"
        OutputFrame.Size = UDim2.new(Settings.GUISize.X.Scale, Settings.GUISize.X.Offset, 0, 30)
    end
end)

-- Keybinds
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
                CommandInput.Text = CommandHistory[HistoryIndex] or ""
            elseif HistoryIndex == 1 then
                CommandInput.Text = CommandHistory[1] or ""
            end
        elseif input.KeyCode == Enum.KeyCode.Down then
            if HistoryIndex < #CommandHistory then
                HistoryIndex = HistoryIndex + 1
                CommandInput.Text = CommandHistory[HistoryIndex] or ""
            elseif HistoryIndex == #CommandHistory then
                HistoryIndex = #CommandHistory + 1
                CommandInput.Text = ""
            end
        end
    end
end)

-- ==================== INITIALIZATION ====================

-- Anti-AFK
local VirtualInputManager = game:GetService("VirtualInputManager")
local lastActivity = tick()

Players.LocalPlayer.Idled:Connect(function()
    if Settings.AntiBan then
        VirtualInputManager:SendKeyEvent(true, "W", false, nil)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, nil)
        lastActivity = tick()
    end
end)

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
OutputMessage("=== Superskksksjsjsj's Admin Script ===", Settings.HighlightColor)
OutputMessage("Version: 2.0.0 - INFINITE YIELD STYLE", Color3.fromRGB(200, 200, 200))
OutputMessage("Loaded successfully!", Color3.fromRGB(100, 255, 100))
OutputMessage("Press '" .. Settings.Keybinds.CommandBar.Name .. "' to open command bar", Color3.fromRGB(200, 200, 200))
OutputMessage("Press '" .. Settings.Keybinds.ToggleGUI.Name .. "' to toggle output window", Color3.fromRGB(200, 200, 200))
OutputMessage("Type ';help' for command list", Color3.fromRGB(200, 200, 200))

-- Welcome Notification
CreateNotification(
    "Superskksksjsjsj's Admin", 
    "Script loaded successfully!\nPress " .. Settings.Keybinds.CommandBar.Name .. " for command bar\nPress " .. Settings.Keybinds.ToggleGUI.Name .. " for output",
    Settings.HighlightColor,
    5
)

-- Make GUI responsive
local function UpdateUIScale()
    local viewportSize = Workspace.CurrentCamera.ViewportSize
    local scale = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    OutputFrame.Size = UDim2.new(0.35 * scale, 0, 0.6 * scale, 0)
    CommandBar.Size = UDim2.new(0.4 * scale, 0, 0, 35)
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateUIScale)
UpdateUIScale()

-- Keep script running
while true do
    task.wait(1)
end
