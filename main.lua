--============================================================
-- VOID HUB PRO - FINAL UPDATED VERSION WITH SONG & SKIP
--============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer

-- [1] أنترو احترافي طويل مع أغنية وزرار سكيب
local function RunIntro()
    local success, err = pcall(function()
        local gui = Instance.new("ScreenGui", PlayerGui)
        gui.Name = "VoidIntro"
        gui.IgnoreGuiInset = true
        
        local f = Instance.new("Frame", gui)
        f.Size = UDim2.fromScale(1,1)
        f.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        
        -- تشغيل الأغنية/الموسيقى
        local s = Instance.new("Sound", f)
        s.SoundId = "rbxassetid://184488349" -- موسيقى الأنترو
        s.Volume = 2
        s:Play()
        
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1,0,0,100)
        t.Position = UDim2.new(0,0,0.45,0)
        t.Text = "VOID HUB PRO"
        t.TextColor3 = Color3.fromRGB(0, 255, 255)
        t.TextSize = 50
        t.Font = Enum.Font.GothamBold
        t.BackgroundTransparency = 1
        t.TextTransparency = 1
        
        -- زرار السكيب (التخطي)
        local skipBtn = Instance.new("TextButton", f)
        skipBtn.Size = UDim2.new(0, 120, 0, 40)
        skipBtn.Position = UDim2.new(0.85, 0, 0.9, 0)
        skipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        skipBtn.Text = "Skip Intro ⏩"
        skipBtn.TextColor3 = Color3.new(1,1,1)
        skipBtn.Font = Enum.Font.GothamBold
        skipBtn.TextSize = 14
        Instance.new("UICorner", skipBtn)
        
        local skipped = false
        skipBtn.MouseButton1Click:Connect(function()
            skipped = true
            s:Stop()
            gui:Destroy()
        end)
        
        -- ظهور تدريجي للكلمة
        for i = 1, 0, -0.1 do
            if skipped then return end
            t.TextTransparency = i
            task.wait(0.04)
        end
        
        -- مدة الانتظار (الأنترو طويل شوية زي ما طلبت)
        for i = 1, 40 do
            if skipped then return end
            task.wait(0.1)
        end
        
        -- اختفاء تدريجي
        for i = 0, 1, 0.1 do
            if skipped then return end
            t.TextTransparency = i
            task.wait(0.03)
        end
        
        if not skipped then
            gui:Destroy()
        end
    end)
    if not success then warn("Intro error: " .. tostring(err)) end
end

-- [2] المنيو الرئيسي
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "VoidHubMain"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 520)
frame.Position = UDim2.new(0.02, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.Text = "VOID HUB PRO"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- [3] زر إنشاء الأزرار تلقائياً
local btnCount = 0
local function createBtn(text, func)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 50 + (btnCount * 45))
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
    btnCount = btnCount + 1
end

-- [4] الوظائف
createBtn("Spawn All Vehicles", function()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage
        for _, v in pairs(remotes:GetChildren()) do
            if v:IsA("RemoteEvent") and (v.Name:lower():find("spawn")) then
                v:FireServer("CarPack_All")
            end
        end
    end)
end)

-- الطيران المظبوط
local flying = false
local flyConnection
createBtn("Toggle Fly", function()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        flying = not flying
        if flying then
            humanoid.PlatformStand = true
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "VoidFlyVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "VoidFlyGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.CFrame = root.CFrame

            flyConnection = RunService.RenderStepped:Connect(function()
                if not flying or not root.Parent then return end
                local cam = workspace.CurrentCamera
                if humanoid.MoveDirection.Magnitude > 0 then
                    bv.Velocity = cam.CFrame.LookVector * 50
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                bg.CFrame = cam.CFrame
            end)
        else
            if root:FindFirstChild("VoidFlyVelocity") then root.VoidFlyVelocity:Destroy() end
            if root:FindFirstChild("VoidFlyGyro") then root.VoidFlyGyro:Destroy() end
            if flyConnection then flyConnection:Disconnect() end
            humanoid.PlatformStand = false
        end
    end)
end)

createBtn("Noclip (Wall Hack)", function()
    pcall(function()
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end)
end)

createBtn("Play Background Music", function()
    pcall(function()
        local s = Instance.new("Sound", workspace)
        s.SoundId = "rbxassetid://139982007364841"
        s:Play()
    end)
end)

-- [5] الفوتر
local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1,0,0,30)
footer.Position = UDim2.new(0,0,0.92,0)
footer.Text = "Key Status: Active (3 Days Trial)"
footer.TextColor3 = Color3.fromRGB(0, 255, 100)
footer.TextSize = 12
footer.BackgroundTransparency = 1

-- تشغيل الأنترو
task.spawn(RunIntro)
