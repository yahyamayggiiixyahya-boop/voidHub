--============================================================
-- VOID HUB PRO - FINAL FIXED VERSION
--============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer

-- [1] أنترو خفيف وسريع (مش بيعلق)
local function RunIntro()
    local success, err = pcall(function()
        local gui = Instance.new("ScreenGui", PlayerGui)
        gui.Name = "VoidIntro"
        
        local f = Instance.new("Frame", gui)
        f.Size = UDim2.fromScale(1,1)
        f.BackgroundColor3 = Color3.fromRGB(0,0,0)
        
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1,0,0.2,0)
        t.Position = UDim2.new(0,0,0.4,0)
        t.Text = "VOID HUB PRO - LOADING..."
        t.TextColor3 = Color3.fromRGB(0, 255, 255)
        t.TextSize = 35
        t.Font = Enum.Font.GothamBold
        t.BackgroundTransparency = 1
        
        -- تشغيل الصوت بأمان
        local s = Instance.new("Sound", f)
        s.SoundId = "rbxassetid://184488349"
        s:Play()
        
        task.wait(2)
        gui:Destroy()
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

-- [4] إضافة الوظائف الأساسية
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

createBtn("Toggle Fly", function()
    pcall(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            if root:FindFirstChild("BodyVelocity") then
                root.BodyVelocity:Destroy()
            else
                local bv = Instance.new("BodyVelocity", root)
                bv.Name = "BodyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 30, 0)
            end
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

-- [5] كتابة حالة المفتاح في الأسفل (3 أيام)
local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1,0,0,30)
footer.Position = UDim2.new(0,0,0.92,0)
footer.Text = "Key Status: Active (3 Days Trial)"
footer.TextColor3 = Color3.fromRGB(0, 255, 100)
footer.TextSize = 12
footer.BackgroundTransparency = 1

-- تشغيل الأنترو
task.spawn(RunIntro)
