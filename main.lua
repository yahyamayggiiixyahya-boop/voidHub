-- ==========================================
-- Void Hub - Intro, Brainrot Speed & Soft Anti-Kick
-- Developed for: Yahya, Omar & Khalil
-- ==========================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. نظام حماية خفيف ضد الطرد (Soft Anti-Kick)
-- ==========================================
local function applySoftAntiKick()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

applySoftAntiKick()

-- ==========================================
-- 2. نظام الضبط المباشر للسرعة عند مسك Brainrot فقط
-- ==========================================
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum then
                local isHoldingBrainrot = false
                
                -- فحص الأدوات الممسوكة في اليد
                for _, item in pairs(char:GetChildren()) do
                    if item:IsA("Tool") then
                        local itemName = string.lower(item.Name)
                        if string.find(itemName, "brainrot") or string.find(itemName, "brain rot") or string.find(itemName, "steal") then
                            isHoldingBrainrot = true
                            break
                        end
                    end
                end
                
                -- فحص حالة الحمل
                if char:FindFirstChild("StealBrainrot") or char:GetAttribute("CarryingBrainrot") == true then
                    isHoldingBrainrot = true
                end

                -- تقليل السرعة عند مسك الـ Brainrot لمنع الطرد
                if isHoldingBrainrot then
                    hum.WalkSpeed = 27.5
                else
                    if hum.WalkSpeed >= 61 then
                        hum.WalkSpeed = 58
                    end
                end
            end
        end
    end)
end)

-- ==========================================
-- 3. واجهة الانترو وموسيقى البيانو المعتمدة
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
ScreenGui.Parent = game:GetService("CoreGui")
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

-- موسيقى الانترو
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
