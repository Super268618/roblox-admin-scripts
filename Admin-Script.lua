--[[
    Superskksksjsjsj's Admin Script
    Version: 1.0.0
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

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Commands = {}
local Aliases = {}
local Settings = {
    Prefix = ";",
    NotificationDuration = 5,
    MaxHistory = 50,
    AntiBan = true,
    AutoClean = false,
    GUIKeybind = Enum.KeyCode.F3
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CommandBar = Instance.new("TextBox")
local OutputFrame = Instance.new("ScrollingFrame")
local CommandList = Instance.new("ScrollingFrame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")

-- Create GUI
ScreenGui.Name = "SuperskksksjsjsjAdmin"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0.08, 0)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.02, 0, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Superskksksjsjsj's Admin Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.9, 0, 0.2, 0)
CloseButton.Size = UDim2.new(0.08, 0, 0.6, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.82, 0, 0.2, 0)
MinimizeButton.Size = UDim2.new(0.08, 0, 0.6, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14

CommandBar.Name = "CommandBar"
CommandBar.Parent = MainFrame
CommandBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CommandBar.BorderSizePixel = 0
CommandBar.Position = UDim2.new(0.02, 0, 0.92, 0)
CommandBar.Size = UDim2.new(0.96, 0, 0.06, 0)
CommandBar.Font = Enum.Font.Gotham
CommandBar.PlaceholderText = "Enter command..."
CommandBar.Text = ""
CommandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandBar.TextSize = 14
CommandBar.TextXAlignment = Enum.TextXAlignment.Left

OutputFrame.Name = "OutputFrame"
OutputFrame.Parent = MainFrame
OutputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
OutputFrame.BorderSizePixel = 0
OutputFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
OutputFrame.Size = UDim2.new(0.68, 0, 0.8, 0)
OutputFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
OutputFrame.ScrollBarThickness = 4
OutputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

CommandList.Name = "CommandList"
CommandList.Parent = MainFrame
CommandList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
CommandList.BorderSizePixel = 0
CommandList.Position = UDim2.new(0.72, 0, 0.1, 0)
CommandList.Size = UDim2.new(0.26, 0, 0.8, 0)
CommandList.CanvasSize = UDim2.new(0, 0, 5, 0)

-- UI Functions
local function CreateNotification(title, message, color)
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(0.7, 0, 0.05, 0)
    Notification.Size = UDim2.new(0.25, 0, 0.1, 0)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    TitleLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = Notification
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    MessageLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.TextSize = 14
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    task.spawn(function()
        task.wait(Settings.NotificationDuration)
        local tween = TweenService:Create(
            Notification,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, 0, 0.05, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
        Notification:Destroy()
    end)
end

local function OutputMessage(message, color)
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = OutputFrame
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Size = UDim2.new(0.98, 0, 0, 20)
    MessageLabel.Font = Enum.Font.Code
    MessageLabel.Text = "> " .. message
    MessageLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    MessageLabel.TextSize = 12
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
    
    OutputFrame.CanvasPosition = Vector2.new(0, OutputFrame.AbsoluteCanvasSize.Y)
end

-- Command System
local CommandSystem = {}
CommandSystem.__index = CommandSystem

function CommandSystem.new(name, description, func, aliases)
    local self = setmetatable({}, CommandSystem)
    self.Name = name
    self.Description = description
    self.Function = func
    self.Aliases = aliases or {}
    return self
end

function CommandSystem:Execute(args, executor)
    local success, err = pcall(function()
        self.Function(args, executor)
    end)
    
    if not success then
        OutputMessage("Error executing command: " .. err, Color3.fromRGB(255, 50, 50))
    end
end

-- Player Finder
local function GetPlayers(input)
    local players = {}
    local inputLower = string.lower(input)
    
    if inputLower == "all" or inputLower == "others" or inputLower == "me" then
        if inputLower == "me" then
            return {LocalPlayer}
        elseif inputLower == "others" then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(players, player)
                end
            end
            return players
        elseif inputLower == "all" then
            return Players:GetPlayers()
        end
    end
    
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

-- Command Registration
local function RegisterCommand(name, description, func, aliases)
    local cmd = CommandSystem.new(name, description, func, aliases)
    Commands[name] = cmd
    
    if aliases then
        for _, alias in ipairs(aliases) do
            Aliases[alias] = name
        end
    end
    
    -- Add to command list UI
    local CommandButton = Instance.new("TextButton")
    CommandButton.Parent = CommandList
    CommandButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    CommandButton.BorderSizePixel = 0
    CommandButton.Size = UDim2.new(0.96, 0, 0, 25)
    CommandButton.Font = Enum.Font.Gotham
    CommandButton.Text = name
    CommandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CommandButton.TextSize = 12
    CommandButton.AutomaticSize = Enum.AutomaticSize.Y
    
    CommandButton.MouseButton1Click:Connect(function()
        CommandBar.Text = Settings.Prefix .. name .. " "
        CommandBar:CaptureFocus()
    end)
    
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Parent = CommandButton
    Tooltip.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Tooltip.BorderSizePixel = 0
    Tooltip.Position = UDim2.new(0, 0, 1, 0)
    Tooltip.Size = UDim2.new(2, 0, 0, 30)
    Tooltip.Visible = false
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.Text = description
    Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tooltip.TextSize = 12
    Tooltip.TextWrapped = true
    Tooltip.ZIndex = 10
    
    CommandButton.MouseEnter:Connect(function()
        Tooltip.Visible = true
    end)
    
    CommandButton.MouseLeave:Connect(function()
        Tooltip.Visible = false
    end)
end

-- Core Commands
RegisterCommand("help", "Shows all commands", function(args)
    OutputMessage("=== Superskksksjsjsj's Admin Commands ===", Color3.fromRGB(0, 200, 255))
    for name, cmd in pairs(Commands) do
        OutputMessage(Settings.Prefix .. name .. " - " .. cmd.Description, Color3.fromRGB(200, 200, 200))
    end
end, {"h", "commands"})

RegisterCommand("kill", "Kills selected players", function(args)
    local players = GetPlayers(args[1] or "me")
    for _, player in ipairs(players) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
    OutputMessage("Killed " .. #players .. " player(s)", Color3.fromRGB(255, 100, 100))
end, {"k"})

RegisterCommand("kick", "Kicks selected players", function(args)
    local players = GetPlayers(args[1] or "me")
    local reason = table.concat(args, " ", 2) or "No reason provided"
    
    for _, player in ipairs(players) do
        player:Kick("[Admin] " .. reason)
    end
    OutputMessage("Kicked " .. #players .. " player(s)", Color3.fromRGB(255, 150, 50))
end)

RegisterCommand("bring", "Brings players to you", function(args)
    local players = GetPlayers(args[1] or "me")
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                targetRoot.CFrame = root.CFrame + Vector3.new(0, 0, -5)
            end
        end
    end
    OutputMessage("Brought " .. #players .. " player(s)", Color3.fromRGB(100, 255, 100))
end, {"b"})

RegisterCommand("to", "Teleports you to player", function(args)
    local players = GetPlayers(args[1])
    if #players > 0 then
        local target = players[1]
        if target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local char = LocalPlayer.Character
            if char and targetRoot then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 5)
                end
            end
        end
    end
end, {"teleport", "tp"})

RegisterCommand("fly", "Enables flying", function(args)
    local speed = tonumber(args[1]) or 50
    local bodyVelocity = Instance.new("BodyVelocity")
    local bodyGyro = Instance.new("BodyGyro")
    
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    
    local flying = true
    local char = LocalPlayer.Character
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
end, {"f"})

RegisterCommand("noclip", "Enables noclip", function()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    OutputMessage("Noclip enabled", Color3.fromRGB(200, 100, 255))
end, {"nc"})

RegisterCommand("clip", "Disables noclip", function()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    OutputMessage("Noclip disabled", Color3.fromRGB(200, 100, 255))
end)

RegisterCommand("god", "Makes you invincible", function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    OutputMessage("God mode enabled", Color3.fromRGB(255, 255, 100))
end, {"invincible"})

RegisterCommand("ungod", "Removes invincibility", function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
    
    OutputMessage("God mode disabled", Color3.fromRGB(255, 255, 100))
end)

RegisterCommand("speed", "Changes walk speed", function(args)
    local speed = tonumber(args[1]) or 16
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
    
    OutputMessage("Speed set to " .. speed, Color3.fromRGB(100, 255, 200))
end, {"ws"})

RegisterCommand("jump", "Changes jump power", function(args)
    local power = tonumber(args[1]) or 50
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
    end
    
    OutputMessage("Jump power set to " .. power, Color3.fromRGB(100, 255, 200))
end, {"jp"})

RegisterCommand("gravity", "Changes gravity", function(args)
    local gravity = tonumber(args[1]) or 196.2
    Workspace.Gravity = gravity
    OutputMessage("Gravity set to " .. gravity, Color3.fromRGB(200, 200, 100))
end, {"grav"})

RegisterCommand("time", "Changes time of day", function(args)
    local time = args[1] or "12:00"
    Lighting.ClockTime = tonumber(time:match("(%d+):")) or 12
    OutputMessage("Time set to " .. time, Color3.fromRGB(200, 200, 100))
end)

RegisterCommand("clear", "Clears the output", function()
    for _, child in ipairs(OutputFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    OutputMessage("Output cleared", Color3.fromRGB(255, 255, 255))
end, {"clr"})

RegisterCommand("rejoin", "Rejoins the game", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end, {"rj"})

RegisterCommand("serverhop", "Hops to a different server", function()
    local servers = {}
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    end)
    
    if success and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
        end
    end
end, {"hop"})

RegisterCommand("esp", "Enables ESP for players", function(args)
    local players = GetPlayers(args[1] or "all")
    
    for _, player in ipairs(players) do
        if player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "AdminESP"
            highlight.FillColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = player.Character
            highlight.Adornee = player.Character
        end
    end
    OutputMessage("ESP enabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end)

RegisterCommand("unesp", "Disables ESP", function(args)
    local players = GetPlayers(args[1] or "all")
    
    for _, player in ipairs(players) do
        if player.Character then
            for _, highlight in ipairs(player.Character:GetChildren()) do
                if highlight.Name == "AdminESP" and highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end
        end
    end
    OutputMessage("ESP disabled for " .. #players .. " player(s)", Color3.fromRGB(255, 100, 255))
end)

RegisterCommand("tools", "Gives all tools", function()
    for _, tool in ipairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool.Parent ~= LocalPlayer.Backpack then
            tool:Clone().Parent = LocalPlayer.Backpack
        end
    end
    OutputMessage("Collected all tools", Color3.fromRGB(100, 255, 100))
end, {"alltools"})

RegisterCommand("btools", "Gives building tools", function()
    local tools = {"Hammer", "Clone", "Rotate"}
    for _, toolName in ipairs(tools) do
        local tool = Instance.new("Tool")
        tool.Name = toolName
        tool.Parent = LocalPlayer.Backpack
    end
    OutputMessage("Building tools given", Color3.fromRGB(100, 255, 100))
end)

RegisterCommand("infinitejump", "Enables infinite jump", function()
    local connection
    connection = UserInputService.JumpRequest:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    OutputMessage("Infinite jump enabled", Color3.fromRGB(255, 200, 100))
end, {"ijump"})

-- Command Parser
CommandBar.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = CommandBar.Text
        CommandBar.Text = ""
        
        if text:sub(1, 1) == Settings.Prefix then
            local args = {}
            for arg in text:gmatch("%S+") do
                table.insert(args, arg)
            end
            
            local commandName = string.lower(args[1]:sub(2))
            table.remove(args, 1)
            
            local command = Commands[commandName] or Commands[Aliases[commandName]]
            
            if command then
                OutputMessage("> " .. text, Color3.fromRGB(0, 200, 255))
                command:Execute(args, LocalPlayer)
            else
                OutputMessage("Command not found: " .. commandName, Color3.fromRGB(255, 50, 50))
            end
        end
    end
end)

-- UI Events
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Keybind
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Settings.GUIKeybind then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initialization
CreateNotification("Superskksksjsjsj's Admin", "Script loaded! Press F3 to toggle GUI", Color3.fromRGB(0, 150, 255))
OutputMessage("Welcome to Superskksksjsjsj's Admin Script!", Color3.fromRGB(0, 200, 255))
OutputMessage("Type ;help for commands", Color3.fromRGB(200, 200, 200))

-- Anti-AFK
local VirtualInputManager = game:GetService("VirtualInputManager")
local lastActivity = tick()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if Settings.AntiBan then
        VirtualInputManager:SendKeyEvent(true, "W", false, nil)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, nil)
        lastActivity = tick()
    end
end)

-- Auto Clean
if Settings.AutoClean then
    game:GetService("RunService").Heartbeat:Connect(function()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") or (obj:IsA("Part") and not obj.Anchored and obj:GetMass() < 10) then
                obj:Destroy()
            end
        end
    end)
end

-- Make GUI responsive
local function UpdateUIScale()
    local viewportSize = Workspace.CurrentCamera.ViewportSize
    local scale = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    MainFrame.Size = UDim2.new(0.4 * scale, 0, 0.4 * scale, 0)
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateUIScale)
UpdateUIScale()
