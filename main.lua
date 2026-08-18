-- ==========================================
-- Void Hub - Intro, Precise Aimbot & Loader
-- Developed for: Yahya, Omar & Khalil
-- ==========================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local LP = Players.LocalPlayer

-- Global State Variables
local autoBatEnabled = false
local batV2Enabled = false
local laggerModeEnabled = false
local aimbotLaggerSpeed = 42
local aimbotConn = nil
local aimbotV2Conn = nil
local batV2AimbotConn = nil

-- Helper Functions
local function getBatAimbotChaseSpeed()
    return laggerModeEnabled and aimbotLaggerSpeed or 58
end

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

-- ============================================
-- Void Hub AIMBOT V1 (Laser Precision / Zero Miss)
-- ============================================
local function startBatAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    autoBatEnabled = true
    
    local char = LP.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    humanoid.AutoRotate = false

    local function getNearestPlayer()
        local c = LP.Character; if not c then return nil end
        local r = c:FindFirstChild("HumanoidRootPart"); if not r then return nil end
        local myPos = r.Position; local nearestDist = math.huge; local nearestPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local otherRoot = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if otherRoot and hum and hum.Health > 0 then 
                    local dist = (myPos - otherRoot.Position).Magnitude
                    if dist < nearestDist then nearestDist = dist; nearestPlayer = p end 
                end
            end
        end
        return nearestPlayer
    end

    aimbotConn = RunService.RenderStepped:Connect(function(dt)
        if not autoBatEnabled then 
            if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
            return 
        end
        
        local targetPlayer = getNearestPlayer()
        if not targetPlayer or not targetPlayer.Character then return end
        
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        local targetPos = targetRoot.Position
        local targetVel = targetRoot.AssemblyLinearVelocity
        local myPos = rootPart.Position

        -- مسطرة بالملي: التنبؤ والتوجيه المباشر بدون تفويت ضربات
        local predictPos = targetPos + (targetVel * 0.15)
        local direction = predictPos - myPos
        local dist = direction.Magnitude

        if dist > 0.1 then
            rootPart.CFrame = CFrame.lookAt(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z))
        end

        local chaseSpeed = getBatAimbotChaseSpeed()
        if dist > 1.5 then
            rootPart.AssemblyLinearVelocity = Vector3.new(direction.Unit.X * chaseSpeed, rootPart.AssemblyLinearVelocity.Y, direction.Unit.Z * chaseSpeed)
        else
            rootPart.AssemblyLinearVelocity = Vector3.new(targetVel.X, rootPart.AssemblyLinearVelocity.Y, targetVel.Z)
        end

        if dist <= 12 then
            local bat = findBat()
            if bat then
                if bat.Parent ~= char and humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
                pcall(function() bat:Activate() end)
            end
        end
    end)
end

local function stopBatAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    autoBatEnabled = false
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

-- ============================================
-- Void Hub AIMBOT V2 (Nova Perfect Lock)
-- ============================================
local batV2State = { autoBatToggled = false, hittingCooldown = false }

local function getClosestTargetV2()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then 
                    minDist = dist
                    closest = tRoot 
                end
            end
        end
    end
    return closest
end

local function tryHitBatV2()
    if batV2State.hittingCooldown then return end
    batV2State.hittingCooldown = true
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local tool = findBat()
        if tool then
            if tool.Parent ~= c and hum then pcall(function() hum:EquipTool(tool) end) end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) else pcall(function() tool:Activate() end) end
        end
    end)
    task.delay(0.05, function() batV2State.hittingCooldown = false end)
end

local function startBatAimbotV2()
    if aimbotV2Conn then aimbotV2Conn:Disconnect(); aimbotV2Conn = nil end
    autoBatEnabled = true
    batV2State.autoBatToggled = true
    
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = false end

    aimbotV2Conn = RunService.RenderStepped:Connect(function()
        if not batV2State.autoBatToggled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        
        local target = getClosestTargetV2()
        if not target then return end

        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + (targetVel * 0.14)
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        
        local chaseSpeed = getBatAimbotChaseSpeed()
        local yVel = math.clamp((targetPos.Y + 2.5 - myPos.Y) * 15, -60, 90)
        
        root.AssemblyLinearVelocity = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.CFrame = CFrame.lookAt(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z))

        if (targetPos - myPos).Magnitude < 11 then
            tryHitBatV2()
        end
    end)
end

local function stopBatAimbotV2()
    if aimbotV2Conn then aimbotV2Conn:Disconnect(); aimbotV2Conn = nil end
    batV2State.autoBatToggled = false
    autoBatEnabled = false
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

-- ============================================
-- Void Hub TP BAT (Instant Lock Teleport)
-- ============================================
local function startBatV2()
    if batV2AimbotConn then batV2AimbotConn:Disconnect() end
    batV2Enabled = true
    
    batV2AimbotConn = RunService.Heartbeat:Connect(function()
        if not batV2Enabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        
        local target = getClosestTargetV2()
        if target then
            local targetPos = target.Position + Vector3.new(0, 0.8, 0)
            if (root.Position - targetPos).Magnitude > 2 then
                root.CFrame = CFrame.new(targetPos)
            end
            tryHitBatV2()
        end
    end)
end

local function stopBatV2()
    if batV2AimbotConn then batV2AimbotConn:Disconnect(); batV2AimbotConn = nil end
    batV2Enabled = false
end

-- ==========================================================
-- Void Hub GUI Panel (قائمة أنيقة وصغيرة ع الشاشة للتحكم)
-- ==========================================================
local function buildVoidAimbotUI()
    if CoreGui:FindFirstChild("VoidAimbotUI") then
        CoreGui:FindFirstChild("VoidAimbotUI"):Destroy()
    end

    local VoidUI = Instance.new("ScreenGui")
    VoidUI.Name = "VoidAimbotUI"
    VoidUI.Parent = CoreGui
    VoidUI.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VoidUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 210, 0, 190)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 170, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Size = UDim2.new(1, -20, 0, 25)
    Title.Font = Enum.Font.FredokaOne
    Title.Text = "Void Hub | Aimbot"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Line = Instance.new("Frame")
    Line.Parent = MainFrame
    Line.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 10, 0, 32)
    Line.Size = UDim2.new(1, -20, 0, 1)

    local function createButton(text, pos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = MainFrame
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        btn.Position = pos
        btn.Size = UDim2.new(1, -20, 0, 32)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 13
        btn.AutoButtonColor = true

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            callback(state)
        end)
        return btn
    end

    createButton("Aimbot V1 (Laser)", UDim2.new(0, 10, 0, 42), function(state)
        if state then startBatAimbot() else stopBatAimbot() end
    end)

    createButton("Aimbot V2 (Nova Lock)", UDim2.new(0, 10, 0, 80), function(state)
        if state then startBatAimbotV2() else stopBatAimbotV2() end
    end)

    createButton("TP Bat (Teleport)", UDim2.new(0, 10, 0, 118), function(state)
        if state then startBatV2() else stopBatV2() end
    end)

    local Footer = Instance.new("TextLabel")
    Footer.Parent = MainFrame
    Footer.BackgroundTransparency = 1
    Footer.Position = UDim2.new(0, 10, 0, 160)
    Footer.Size = UDim2.new(1, -20, 0, 20)
    Footer.Font = Enum.Font.SourceSansItalic
    Footer.Text = "Devs: Yahya | Omar | Khalil"
    Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
    Footer.TextSize = 12
end

-- تشغيل واجهة الأينبوت المصغرة
buildVoidAimbotUI()

-- ==========================================
-- 2. واجهة الانترو وموسيقى البيانو المعتمدة
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CardFrame = Instance.new("Frame")
local CardCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local SubTitle = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")
local SkipButton = Instance.new("TextButton")
local SkipCorner = Instance.new("UICorner")
local Sound = Instance.new("Sound")

ScreenGui.Name = "VoidHubLegendaryIntro"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(135, 206, 235)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 0, 0, 0)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundTransparency = 1

CardFrame.Name = "CardFrame"
CardFrame.Parent = MainFrame
CardFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CardFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CardFrame.Size = UDim2.new(0, 500, 0, 280)
CardFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CardFrame.BackgroundTransparency = 0.85
CardFrame.BorderSizePixel = 0

CardCorner.CornerRadius = UDim.new(0, 16)
CardCorner.Parent = CardFrame

Title.Name = "Title"
Title.Parent = CardFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.1, 0)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Font = Enum.Font.FredokaOne
Title.Text = "VOID HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 55
Title.TextStrokeTransparency = 0.6
Title.TextStrokeColor3 = Color3.fromRGB(0, 100, 160)

SubTitle.Name = "SubTitle"
SubTitle.Parent = CardFrame
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0.32, 0)
SubTitle.Size = UDim2.new(1, 0, 0, 25)
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.Text = "Official Edition"
SubTitle.TextColor3 = Color3.fromRGB(230, 245, 255)
SubTitle.TextSize = 18

Credits.Name = "Credits"
Credits.Parent = CardFrame
Credits.BackgroundTransparency = 1
Credits.Position = UDim2.new(0, 0, 0.5, 0)
Credits.Size = UDim2.new(1, 0, 0, 60)
Credits.Font = Enum.Font.SourceSansBold
Credits.Text = "Developers:\nYahya  |  Omar  |  Khalil"
Credits.TextColor3 = Color3.fromRGB(255, 255, 255)
Credits.TextSize = 24
Credits.TextStrokeTransparency = 0.8

SkipButton.Name = "SkipButton"
SkipButton.Parent = CardFrame
SkipButton.AnchorPoint = Vector2.new(0.5, 0)
SkipButton.Position = UDim2.new(0.5, 0, 0.78, 0)
SkipButton.Size = UDim2.new(0, 160, 0, 40)
SkipButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SkipButton.BackgroundTransparency = 0.2
SkipButton.Font = Enum.Font.GothamBold
SkipButton.Text = "SKIP INTRO ➔"
SkipButton.TextColor3 = Color3.fromRGB(0, 110, 170)
SkipButton.TextSize = 15

SkipCorner.CornerRadius = UDim.new(0, 8)
SkipCorner.Parent = SkipButton

-- ID الموسيقى الشغال والمعتمد لموزارت بيانو
Sound.Name = "IntroSound"
Sound.Parent = ScreenGui
Sound.SoundId = "rbxassetid://1843535552"
Sound.Volume = 1.5
Sound.Looped = false
Sound:Play()

local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0}):Play()

local isEnding = false
local function finishIntro()
    if isEnding then return end
    isEnding = true
    
    if Sound then
        TweenService:Create(Sound, TweenInfo.new(0.5), {Volume = 0}):Play()
    end
    
    local fadeOut = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        if ScreenGui then
            ScreenGui:Destroy()
        end
        
        -- تشغيل اللودر الخاص بك تلقائياً بعد الانترو
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/28bc742e3a8f491e8155a5c4327fd4dd.lua"))()
            end)
            if not success then
                warn("[Void Hub Loader Error]:", err)
            end
        end)
    end)
end

SkipButton.MouseButton1Click:Connect(finishIntro)

task.delay(6.5, function()
    finishIntro()
end)
