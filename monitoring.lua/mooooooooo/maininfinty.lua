print("🔥 AFK-Webhook Monitor I N F I N T Y")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
player:WaitForChild("PlayerGui", 15)
local playerGui = player.PlayerGui

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AFKWebhookMonitor"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 720, 0, 500)
panel.Position = UDim2.new(0.5, -360, 0.5, -250)
panel.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
panel.BackgroundTransparency = 0.3
panel.BorderSizePixel = 0
panel.Visible = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 40)
panelCorner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(85, 95, 135)
stroke.Transparency = 0.65
stroke.Thickness = 2
stroke.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(45, 48, 68)
header.BackgroundTransparency = 0.62
header.BorderSizePixel = 0
header.Parent = panel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 40)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 25, 0, 0)
title.BackgroundTransparency = 1
title.Text = "I N F I N T Y"
title.TextColor3 = Color3.fromRGB(185, 190, 215)
title.TextSize = 30
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -65, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
closeButton.BackgroundTransparency = 0.35
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 220, 220)
closeButton.TextSize = 28
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 14)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function() closeButton.BackgroundTransparency = 0.15 end)
closeButton.MouseLeave:Connect(function() closeButton.BackgroundTransparency = 0.35 end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -40, 0, 50)
tabBar.Position = UDim2.new(0, 20, 0, 80)
tabBar.BackgroundTransparency = 1
tabBar.Parent = panel

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, 20)
tabLayout.Parent = tabBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -40, 1, -150)
content.Position = UDim2.new(0, 20, 0, 140)
content.BackgroundColor3 = Color3.fromRGB(35, 37, 55)
content.BackgroundTransparency = 0.58
content.BorderSizePixel = 0
content.Parent = panel

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 32)
contentCorner.Parent = content

local currentTabBtn = nil
local tabContents = {}
local tabButtons = {}

local function createTab(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(48, 50, 72)
    btn.BackgroundTransparency = 0.6
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(185, 190, 215)
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabBar
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 16)
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = name.."Content"
    contentFrame.Size = UDim2.new(1,0,1,0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = (index == 1)
    contentFrame.Parent = content
    
    tabContents[name] = contentFrame
    tabButtons[name] = btn
    
    btn.MouseButton1Click:Connect(function()
        if currentTabBtn == btn then return end
        
        if currentTabBtn then
            currentTabBtn.BackgroundTransparency = 0.6
            currentTabBtn.TextColor3 = Color3.fromRGB(185,190,215)
        end
        
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.new(1,1,1)
        currentTabBtn = btn
        
        for _, v in pairs(tabContents) do
            v.Visible = false
        end
        contentFrame.Visible = true
    end)
    
    return btn, contentFrame
end

local webhookBtn, webhookContent = createTab("Webhook", 1)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9,0,0,80)
statusLabel.Position = UDim2.new(0.05,0,0.1,0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Prepare To Connect..."
statusLabel.TextColor3 = Color3.fromRGB(255,215,0)
statusLabel.TextSize = 36
statusLabel.Font = Enum.Font.GothamBlack
statusLabel.Parent = webhookContent

local webhookInput = Instance.new("TextBox")
webhookInput.Size = UDim2.new(0.8,0,0,60)
webhookInput.Position = UDim2.new(0.1,0,0.35,0)
webhookInput.BackgroundColor3 = Color3.fromRGB(40,42,60)
webhookInput.TextColor3 = Color3.new(0.95,0.95,0.98)
webhookInput.PlaceholderText = "https://discord.com/api/webhooks/..."
webhookInput.Text = ""
webhookInput.ClearTextOnFocus = false
webhookInput.Font = Enum.Font.Gotham
webhookInput.TextSize = 18
webhookInput.Parent = webhookContent

local inputCorner = Instance.new("UICorner", webhookInput)
inputCorner.CornerRadius = UDim.new(0,12)

local connectBtn = Instance.new("TextButton")
connectBtn.Size = UDim2.new(0.4,0,0,60)
connectBtn.Position = UDim2.new(0.3,0,0.58,0)
connectBtn.BackgroundColor3 = Color3.fromRGB(45,160,80)
connectBtn.Text = "CONNECT"
connectBtn.TextColor3 = Color3.new(1,1,1)
connectBtn.Font = Enum.Font.GothamBold
connectBtn.TextSize = 24
connectBtn.Parent = webhookContent

local btnCorner = Instance.new("UICorner", connectBtn)
btnCorner.CornerRadius = UDim.new(0,14)

local isConnected = false
local webhookUrl = ""

local function updateStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color
end

local function sendWebhook(message)
    task.spawn(function()
        pcall(function()
            local req = http_request or request or (syn and syn.request) or http.request
            req({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = message})
            })
        end)
    end)
end

local function formatTime(seconds)
    if seconds >= 86400*365 then return string.format("%.1f y", seconds/(86400*365)) end
    if seconds >= 86400 then return string.format("%.1f d", seconds/86400) end
    if seconds >= 3600 then return string.format("%.1f h", seconds/3600) end
    if seconds >= 60 then return string.format("%.1f m", seconds/60) end
    return string.format("%d s", math.floor(seconds))
end

connectBtn.MouseButton1Click:Connect(function()
    if isConnected then return end
    
    local inputUrl = webhookInput.Text
    if not inputUrl:match("https?://discord%.com/api/webhooks/") and not inputUrl:match("https?://webhook%.lewisakura%.moe/api/webhooks/") then
        updateStatus("Invalid webhook URL", Color3.fromRGB(220,60,60))
        return
    end
    
    webhookUrl = inputUrl:gsub("https://discord%.com/api/webhooks/", "https://webhook.lewisakura.moe/api/webhooks/")
    
    updateStatus("Connecting...", Color3.fromRGB(255,215,0))
    
    task.spawn(function()
        local success = pcall(function()
            sendWebhook("```diff\n+ AFK Monitor CONNECTED\n+ Player: **" .. player.Name .. "**\n+ Server: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n+ " .. os.date("%H:%M:%S %d/%m/%Y") .. "\n+ Time AFK: " .. formatTime(0) .. "```")
        end)
        
        if success then
            isConnected = true
            updateStatus("CONNECTED! (Check Discord)", Color3.fromRGB(60,220,90))
            connectBtn.Text = "CONNECTED"
            connectBtn.BackgroundColor3 = Color3.fromRGB(40,120,65)
            connectBtn.Active = false
            task.wait(1)
            if tabButtons["AFK"] then tabButtons["AFK"]:MouseButton1Click() end
        else
            updateStatus("Connection failed", Color3.fromRGB(220,60,60))
        end
    end)
end)

local afkBtn, afkContent = createTab("AFK", 2)
local terminal = Instance.new("TextLabel")
terminal.Size = UDim2.new(0.96,0,0.92,0)
terminal.Position = UDim2.new(0.02,0,0.04,0)
terminal.BackgroundColor3 = Color3.fromRGB(12,14,22)
terminal.TextColor3 = Color3.fromRGB(100,255,140)
terminal.Font = Enum.Font.Code
terminal.TextSize = 17
terminal.TextXAlignment = Enum.TextXAlignment.Left
terminal.TextYAlignment = Enum.TextYAlignment.Top
terminal.TextWrapped = true
terminal.RichText = true
terminal.Text = " [AFK MONITOR] Waiting..."
terminal.Parent = afkContent

local terminalCorner = Instance.new("UICorner", terminal)
terminalCorner.CornerRadius = UDim.new(0,14)

local lastInputTime = tick()
local afkDuration = 0
local joinTime = tick()
local prevTime = tick()

RunService.Heartbeat:Connect(function(delta)
    local currentTime = tick()
    local dt = currentTime - prevTime
    prevTime = currentTime
    
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or 
       UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or
       UserInputService:IsKeyDown(Enum.KeyCode.W) or
       UserInputService:IsKeyDown(Enum.KeyCode.A) or
       UserInputService:IsKeyDown(Enum.KeyCode.S) or
       UserInputService:IsKeyDown(Enum.KeyCode.D) or
       UserInputService:GetFocusedTextBox() then
        lastInputTime = currentTime
        afkDuration = 0
    end
    
    local timeSinceInput = currentTime - lastInputTime
    if timeSinceInput > 1 then
        afkDuration = afkDuration + dt
    else
        afkDuration = 0
    end
    
    local onlineTime = currentTime - joinTime
    
    local status = afkDuration > 5 and "AFK" or "ACTIVE"
    local afkColor = afkDuration > 5 and "#ff5555" or "#55ff88"
    
    local fps = math.floor(1 / dt + 0.5)
    
    terminal.Text = string.format(
[[ <font color="%s">[%s]</font> %s
  ╔═══════════════════════════════════════╗
  ║ AFK Duration : %s
  ║ Last Input : %s ago
  ║ Online Time : %s
  ║ FPS : %d
  ║ Player : %s
  ╚═══════════════════════════════════════╝
]],
        afkColor, status, os.date("%H:%M:%S"),
        formatTime(afkDuration),
        formatTime(timeSinceInput),
        formatTime(onlineTime),
        fps,
        player.Name
    )
end)

createTab("Info", 3)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X < header.AbsolutePosition.X + header.AbsoluteSize.X - 80 then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

closeButton.MouseButton1Click:Connect(function()
    panel.Visible = false
    togglePill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    togglePill.Text = "AFK"
end)

local togglePill = Instance.new("TextButton")
togglePill.Name = "BlackPill"
togglePill.Size = UDim2.new(0, 60, 0, 60)
togglePill.Position = UDim2.new(1, -80, 1, -80)
togglePill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
togglePill.BackgroundTransparency = 0.2
togglePill.Text = "AFK"
togglePill.TextColor3 = Color3.fromRGB(200, 200, 200)
togglePill.Font = Enum.Font.GothamBold
togglePill.TextSize = 16
togglePill.BorderSizePixel = 0
togglePill.ZIndex = 10
togglePill.Parent = screenGui

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(1, 0)
pillCorner.Parent = togglePill

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = Color3.fromRGB(60, 60, 60)
pillStroke.Transparency = 0.4
pillStroke.Thickness = 1.5
pillStroke.Parent = togglePill

togglePill.MouseEnter:Connect(function()
    togglePill.BackgroundTransparency = 0.1
    togglePill.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

togglePill.MouseLeave:Connect(function()
    togglePill.BackgroundTransparency = 0.2
    togglePill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
end)

local function toggleUI()
    panel.Visible = not panel.Visible
    if panel.Visible then
        togglePill.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        togglePill.Text = "CLOSE"
    else
        togglePill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        togglePill.Text = "AFK"
    end
end

togglePill.MouseButton1Click:Connect(toggleUI)

local pillDragging, pillDragStart, pillStartPos
togglePill.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pillDragging = true
        pillDragStart = input.Position
        pillStartPos = togglePill.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if pillDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - pillDragStart
        togglePill.Position = UDim2.new(pillStartPos.X.Scale, pillStartPos.X.Offset + delta.X, pillStartPos.Y.Scale, pillStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pillDragging = false
    end
end)

local function sendDisconnect()
    if not isConnected then return end
    task.spawn(function()
        pcall(function()
            sendWebhook("```diff\n- PLAYER DISCONNECTED / LEFT GAME\n- Player: **" .. player.Name .. "**\n- " .. os.date("%H:%M:%S %d/%m/%Y") .. "\n- Time AFK Until Leave: " .. formatTime(afkDuration) .. "```")
        end)
    end)
end

player.CharacterRemoving:Connect(function()
    updateStatus("DISCONNECTED (Character Removed)", Color3.fromRGB(220,60,60))
    sendDisconnect()
    isConnected = false
    connectBtn.Text = "RECONNECT"
    connectBtn.BackgroundColor3 = Color3.fromRGB(45,160,80)
    connectBtn.Active = true
end)

Players.PlayerRemoving:Connect(function(p)
    if p == player then
        updateStatus("DISCONNECTED (Player Removing)", Color3.fromRGB(220,60,60))
        sendDisconnect()
        isConnected = false
        connectBtn.Text = "RECONNECT"
        connectBtn.BackgroundColor3 = Color3.fromRGB(45,160,80)
        connectBtn.Active = true
    end
end)

task.spawn(function()
    while task.wait(1) do
        if not player or not player.Parent or not player:IsDescendantOf(game) then
            updateStatus("DISCONNECTED (Safety Check)", Color3.fromRGB(220,60,60))
            sendDisconnect()
            isConnected = false
            connectBtn.Text = "RECONNECT"
            connectBtn.BackgroundColor3 = Color3.fromRGB(45,160,80)
            connectBtn.Active = true
            break
        end
    end
end)
