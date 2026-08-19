--============================================================
-- VOID HUB - ANTI-CRASH & FAST LOAD + CONTROL PANEL
--============================================================

-- ⚡ 0. ULTRA FAST ANTI-CRASH & MEMORY CLEANER (RUNS IMMEDIATELY)
pcall(function()
	if gcinfo then collectgarbage("collect") end
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	game:GetService("Lighting").GlobalShadows = false
end)

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

--============================================================
-- 1. FAST RUN MAIN EXTERNAL SCRIPT
--============================================================

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/28bc742e3a8f491e8155a5c4327fd4dd.lua"))()
	end)
end)

--============================================================
-- 2. CONTROL PANEL GUI (OPTIMIZED)
--============================================================

local oldGui = PlayerGui:FindFirstChild("VoidHubLagGui")
if oldGui then oldGui:Destroy() end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "VoidHubLagGui"
mainGui.ResetOnSpawn = false
mainGui.Parent = PlayerGui

-- زر فتح القائمة
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(45, 45)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
toggleBtn.Text = "⚙️"
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.ZIndex = 100
toggleBtn.Parent = mainGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 170, 255)
btnStroke.Thickness = 2
btnStroke.Parent = toggleBtn

-- الإطار الرئيسي
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(240, 360)
frame.Position = UDim2.new(0, 65, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = mainGui
frame.Active = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(35, 35, 45)
frameStroke.Thickness = 1.5
frameStroke.Parent = frame

-- إضافة الـ Gradient (خفيف جداً)
local gradient = Instance.new("UIGradient")
gradient.Rotation = 45
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 112, 219)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(135, 206, 235)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 112, 219))
})
gradient.Parent = frame

RunService.RenderStepped:Connect(function()
	gradient.Offset = Vector2.new(math.sin(tick() * 0.5) * 0.5, 0)
end)

-- كود السحب (Draggable)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "VOID HUB CONTROL PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = frame

--============================================================
-- ANTI-CRASH STATUS
--============================================================

local antiCrashBtn = Instance.new("TextButton")
antiCrashBtn.Size = UDim2.new(0.85, 0, 0, 24)
antiCrashBtn.Position = UDim2.new(0.075, 0, 0.08, 0)
antiCrashBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
antiCrashBtn.Text = "ANTI-CRASH: ACTIVE 🚀"
antiCrashBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
antiCrashBtn.Font = Enum.Font.GothamBold
antiCrashBtn.TextSize = 10
antiCrashBtn.Parent = frame

local crashCorner = Instance.new("UICorner")
crashCorner.CornerRadius = UDim.new(0, 6)
crashCorner.Parent = antiCrashBtn

antiCrashBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if gcinfo then collectgarbage("collect") end
	end)
end)

--============================================================
-- SMOOTH GAME TOGGLE
--============================================================

local smoothActive = false
local originalMaterials = {}

local smoothBtn = Instance.new("TextButton")
smoothBtn.Size = UDim2.new(0.85, 0, 0, 24)
smoothBtn.Position = UDim2.new(0.075, 0, 0.16, 0)
smoothBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
smoothBtn.Text = "SMOOTH GAME: OFF ❌"
smoothBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
smoothBtn.Font = Enum.Font.GothamBold
smoothBtn.TextSize = 10
smoothBtn.Parent = frame

local smoothCorner = Instance.new("UICorner")
smoothCorner.CornerRadius = UDim.new(0, 6)
smoothCorner.Parent = smoothBtn

smoothBtn.MouseButton1Click:Connect(function()
	smoothActive = not smoothActive
	if smoothActive then
		smoothBtn.Text = "SMOOTH GAME: ON ⚡"
		smoothBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
		smoothBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		pcall(function()
			for _, v in ipairs(game:GetDescendants()) do
				if v:IsA("BasePart") then
					originalMaterials[v] = v.Material
					v.Material = Enum.Material.SmoothPlastic
					v.Reflectance = 0
				elseif v:IsA("Decal") or v:IsA("Texture") then
					v.Transparency = 1
				elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
					v.Enabled = false
				end
			end
		end)
	else
		smoothBtn.Text = "SMOOTH GAME: OFF ❌"
		smoothBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		smoothBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		pcall(function()
			for part, mat in pairs(originalMaterials) do
				if part and part.Parent then part.Material = mat end
			end
			originalMaterials = {}
			for _, v in ipairs(game:GetDescendants()) do
				if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0
				elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled = true end
			end
		end)
	end
end)

--============================================================
-- FOV CONTROL
--============================================================

local fovValues = {70, 90, 110, 120}
local currentFovIndex = 1

local fovBtn = Instance.new("TextButton")
fovBtn.Size = UDim2.new(0.85, 0, 0, 24)
fovBtn.Position = UDim2.new(0.075, 0, 0.24, 0)
fovBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
fovBtn.Text = "CAMERA FOV: 70 (DEFAULT)"
fovBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fovBtn.Font = Enum.Font.GothamBold
fovBtn.TextSize = 10
fovBtn.Parent = frame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovBtn

fovBtn.MouseButton1Click:Connect(function()
	currentFovIndex = (currentFovIndex % #fovValues) + 1
	local selectedFov = fovValues[currentFovIndex]
	Camera.FieldOfView = selectedFov
	fovBtn.Text = "CAMERA FOV: " .. tostring(selectedFov) .. (selectedFov == 70 and " (DEFAULT)" or "")
end)

--============================================================
-- ANTI-RESET v2
--============================================================

local antiResetBtn = Instance.new("TextButton")
antiResetBtn.Size = UDim2.new(0.85, 0, 0, 24)
antiResetBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
antiResetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
antiResetBtn.Text = "ANTI-RESET v2: ACTIVE 🛡️"
antiResetBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
antiResetBtn.Font = Enum.Font.GothamBold
antiResetBtn.TextSize = 10
antiResetBtn.Parent = frame

local antiResetCorner = Instance.new("UICorner")
antiResetCorner.CornerRadius = UDim.new(0, 6)
antiResetCorner.Parent = antiResetBtn

antiResetBtn.MouseButton1Click:Connect(function()
	pcall(function()
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end
	end)
end)

--============================================================
-- PING STABILIZER
--============================================================

local pingBtn = Instance.new("TextButton")
pingBtn.Size = UDim2.new(0.85, 0, 0, 24)
pingBtn.Position = UDim2.new(0.075, 0, 0.40, 0)
pingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
pingBtn.Text = "PING STABILIZER: ON 🌐"
pingBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
pingBtn.Font = Enum.Font.GothamBold
pingBtn.TextSize = 10
pingBtn.Parent = frame

local pingCorner = Instance.new("UICorner")
pingCorner.CornerRadius = UDim.new(0, 6)
pingCorner.Parent = pingBtn

pingBtn.MouseButton1Click:Connect(function()
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)
end)

--============================================================
-- MUSIC PLAYER
--============================================================

local SONGS = {
	{Name = "Track 1", Url = "https://files.catbox.moe/nynv9p.mp3", File = "Void_Song_1.mp3"},
	{Name = "Track 2", Url = "https://files.catbox.moe/jmqv9y.mp3", File = "Void_Song_2.mp3"},
	{Name = "Track 3 (فرفوشة)", Url = "https://files.catbox.moe/0mvc4o.mp3", File = "Void_Song_3.mp3"}
}

local currentTrack = 1
local soundInstance = nil

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0.85, 0, 0, 26)
playBtn.Position = UDim2.new(0.075, 0, 0.50, 0)
playBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
playBtn.Text = "PLAY MUSIC 🔊"
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 10
playBtn.Parent = frame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 6)
playCorner.Parent = playBtn

local changeBtn = Instance.new("TextButton")
changeBtn.Size = UDim2.new(0.85, 0, 0, 24)
changeBtn.Position = UDim2.new(0.075, 0, 0.59, 0)
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
pingLabel.Position = UDim2.new(0, 0, 0.90, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "🚀 ANTI-CRASH & FAST LOAD ON"
pingLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 9
pingLabel.Parent = frame

local function loadAudioTrack(trackIdx)
	if soundInstance then
		soundInstance:Stop()
		soundInstance:Destroy()
		soundInstance = nil
	end
	
	local trackData = SONGS[trackIdx]
	local asset
	pcall(function()
		if isfile and isfile(trackData.File) then asset = getcustomasset(trackData.File) end
	end)
	if not asset then
		task.spawn(function()
			local success, data = pcall(function() return game:HttpGet(trackData.Url) end)
			if success and data and #data > 1000 then
				pcall(function() writefile(trackData.File, data) end)
				pcall(function() asset = getcustomasset(trackData.File) end)
			end
		end)
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
	if not soundInstance then loadAudioTrack(currentTrack) end
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
	currentTrack = (currentTrack % #SONGS) + 1
	changeBtn.Text = "CHANGE TRACK 🔀 (Track " .. tostring(currentTrack) .. ")"
	loadAudioTrack(currentTrack)
	if soundInstance then
		soundInstance:Play()
		playBtn.Text = "PAUSE MUSIC 🔇"
		playBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	end
end)

toggleBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

--============================================================
-- 3. SPEED LIMITER & AUTO MEMORY CLEAN
--============================================================

RunService.Heartbeat:Connect(function()
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and hum.WalkSpeed > 65 then
			hum.WalkSpeed = 65
		end
	end
end)
