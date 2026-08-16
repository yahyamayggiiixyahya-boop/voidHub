--============================================================
-- VOID HUB - MM2 MASTER EDITION (MUSIC HUB, FLY, INFINITE JUMP, ESP/RADAR, LOCK MURDERER)
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- 1. INTRO SETTINGS & MUSIC PLAYER
--============================================================

local DEFAULT_MUSIC_ID = "82757474758500" -- الأيدي الأساسي الذي أرسلته
local IMAGES = {
	"rbxassetid://129700697019613",
	"rbxassetid://108697485255882",
	"rbxassetid://71211662493854",
	"rbxassetid://118953269416540"
}

for _, name in ipairs({"VoidHubIntro", "VoidHubMainUI"}) do
	local old = PlayerGui:FindFirstChild(name)
	if old then old:Destroy() end
end

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
		if i ~= lastImage then table.insert(choices, i) end
	end
	imageIndex = choices[math.random(1, #choices)]
end
shared.VoidHub_LastImage = imageIndex
local IMAGE_ID = IMAGES[imageIndex]

local introActive = true
local introFinished = false
local backgroundMusic = nil

--============================================================
-- بناء واجهة الإنترو
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "VoidHubIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

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
introSubtitle.Text = "MM2 + MUSIC HUB"
introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
introSubtitle.TextTransparency = 1
introSubtitle.TextScaled = true
introSubtitle.Font = Enum.Font.GothamBold
introSubtitle.ZIndex = 20
introSubtitle.Parent = background

--============================================================
-- المنيو الرئيسية الكبرى (تحتوي على قائمة الميوزك المتقدمة والأزرار)
--============================================================

local function createVoidHubMainUI()
	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "VoidHubMainUI"
	mainGui.ResetOnSpawn = false
	mainGui.Parent = PlayerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(340, 660)
	mainFrame.Position = UDim2.fromScale(0.1, 0.08)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = mainGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	title.Text = "VOID HUB - MM2 MASTER + MUSIC"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = title

	local function createButton(name, posY)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 32)
		btn.Position = UDim2.new(0.05, 0, 0, posY)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		btn.Text = name
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.Parent = mainFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = btn
		return btn
	end

	local function createTextBox(placeholder, posY)
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(0.9, 0, 0, 32)
		box.Position = UDim2.new(0.05, 0, 0, posY)
		box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		box.PlaceholderText = placeholder
		box.Text = ""
		box.TextColor3 = Color3.fromRGB(255, 255, 255)
		box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		box.Font = Enum.Font.Gotham
		box.TextSize = 12
		box.Parent = mainFrame

		local boxCorner = Instance.new("UICorner")
		boxCorner.CornerRadius = UDim.new(0, 8)
		boxCorner.Parent = box
		return box
	end

	-- الأزرار الأساسية للتحكم باللعبة
	local flyBtn = createButton("Toggle Fly: OFF", 45)
	local noclipBtn = createButton("Toggle Noclip: OFF", 80)
	local speedBtn = createButton("Toggle Speed 3000: OFF", 115)
	local infJumpBtn = createButton("Infinite Jump (القفز اللانهائي): OFF", 150)
	local touchFlingBtn = createButton("Touch Fling (طرد باللمس): OFF", 185)
	local mm2RadarBtn = createButton("MM2 Roles Radar (كشف المجرم): OFF", 220)
	local lockMurdererBtn = createButton("Lock on Murderer (كاميرا لوك على المجرم): OFF", 255)

	-- قسم قائمة الأغاني والميوزك (Music Hub)
	local musicTitle = Instance.new("TextLabel")
	musicTitle.Size = UDim2.new(0.9, 0, 0, 25)
	musicTitle.Position = UDim2.new(0.05, 0, 0, 292)
	musicTitle.BackgroundTransparency = 1
	musicTitle.Text = "--- Music Player Hub (قائمة الأغاني) ---"
	musicTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	musicTitle.Font = Enum.Font.GothamBold
	musicTitle.TextSize = 11
	musicTitle.Parent = mainFrame

	local musicBox = createTextBox("اكتب أو الصق أيدي الأغنية هنا...", 320)
	musicBox.Text = DEFAULT_MUSIC_ID -- وضع الأيدي الذي أرسلته افتراضياً في الخانة لسهولة التشغيل

	local playCustomBtn = createButton("تشغيل الأغنية المكتوبة (Play ID)", 358)
	local playDefaultBtn = createButton("تشغيل الأغنية الخاصة بك الأساسية", 395)
	local stopMusicBtn = createButton("إيقاف الأغنية (Stop Music)", 432)
	stopMusicBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)

	local closeBtn = createButton("Close Menu", 615)
	closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

	closeBtn.MouseButton1Click:Connect(function()
		mainGui:Destroy()
	end)

	--============================================================
	-- تشغيل السكربتات والوظائف للعبة
	--============================================================

	-- 1. الطيران
	local flying = false
	local fspeed = 60
	local bg, bv

	flyBtn.MouseButton1Click:Connect(function()
		flying = not flying
		flyBtn.Text = "Toggle Fly: " .. (flying and "ON" or "OFF")
		local char = player.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		local hrp = char.HumanoidRootPart
		
		if flying then
			bg = Instance.new("BodyGyro")
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e4, 9e4, 9e4)
			bg.cframe = hrp.CFrame
			bg.Parent = hrp

			bv = Instance.new("BodyVelocity")
			bv.velocity = Vector3.new(0, 0, 0)
			bv.maxForce = Vector3.new(9e4, 9e4, 9e4)
			bv.Parent = hrp

			task.spawn(function()
				while flying and char and char:FindFirstChild("Humanoid") do
					local cam = workspace.CurrentCamera
					local vel = Vector3.new()
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CoordinateFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CoordinateFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CoordinateFrame.RightVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CoordinateFrame.RightVector end
					bv.velocity = vel * fspeed
					bg.cframe = cam.CoordinateFrame
					RunService.RenderStepped:Wait()
				end
				if bg then bg:Destroy() end
				if bv then bv:Destroy() end
			end)
		else
			if bg then bg:Destroy() end
			if bv then bv:Destroy() end
		end
	end)

	-- 2. اختراق الجدران
	local noclipping = false
	noclipBtn.MouseButton1Click:Connect(function()
		noclipping = not noclipping
		noclipBtn.Text = "Toggle Noclip: " .. (noclipping and "ON" or "OFF")
	end)

	RunService.Stepped:Connect(function()
		if noclipping and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)

	-- 3. السرعة الخارقة
	local speedEnabled = false
	speedBtn.MouseButton1Click:Connect(function()
		speedEnabled = not speedEnabled
		speedBtn.Text = "Toggle Speed 3000: " .. (speedEnabled and "ON" or "OFF")
	end)

	RunService.Heartbeat:Connect(function()
		if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
			local humanoid = player.Character.Humanoid
			if humanoid.MoveDirection.Magnitude > 0 then
				player.Character:TranslateBy(humanoid.MoveDirection * 3000 * RunService.Heartbeat:Wait())
			end
		end
	end)

	-- 4. القفز اللانهائي (Infinite Jump)
	local infJumpEnabled = false
	infJumpBtn.MouseButton1Click:Connect(function()
		infJumpEnabled = not infJumpEnabled
		infJumpBtn.Text = "Infinite Jump: " .. (infJumpEnabled and "ON" or "OFF")
	end)

	UserInputService.JumpRequest:Connect(function()
		if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	-- 5. طرد اللاعبين باللمس
	local flingEnabled = false
	touchFlingBtn.MouseButton1Click:Connect(function()
		flingEnabled = not flingEnabled
		touchFlingBtn.Text = "Touch Fling: " .. (flingEnabled and "ON" or "OFF")
	end)

	RunService.Heartbeat:Connect(function()
		if flingEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local vel = hrp.Velocity
			hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
		end
	end)

	-- 6. رادار MM2 وكشف الأدوار
	local mm2RadarActive = false
	local espHighlights = {}

	mm2RadarBtn.MouseButton1Click:Connect(function()
		mm2RadarActive = not mm2RadarActive
		mm2RadarBtn.Text = "MM2 Roles Radar: " .. (mm2RadarActive and "ON" or "OFF")

		if not mm2RadarActive then
			for _, h in pairs(espHighlights) do
				if h then h:Destroy() end
			end
			espHighlights = {}
		end
	end)

	local function getMurderer()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local char = p.Character
				local backpack = p:FindFirstChild("Backpack")
				
				local function checkTool(tool)
					if tool:IsA("Tool") then
						local name = string.lower(tool.Name)
						if name:find("knife") or name:find("blade") then
							return true
						end
					end
					return false
				end

				for _, t in pairs(char:GetChildren()) do
					if checkTool(t) then return p end
				end
				if backpack then
					for _, t in pairs(backpack:GetChildren()) do
						if checkTool(t) then return p end
					end
				end
			end
		end
		return nil
	end

	RunService.RenderStepped:Connect(function()
		if not mm2RadarActive then return end

		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local char = p.Character
				local role = "Innocent"
				local backpack = p:FindFirstChild("Backpack")
				
				local function checkTool(tool)
					if tool:IsA("Tool") then
						local name = string.lower(tool.Name)
						if name:find("knife") or name:find("blade") then
							role = "Murderer"
						elseif name:find("gun") or name:find("revolver") then
							role = "Sheriff"
						end
					end
				end

				for _, t in pairs(char:GetChildren()) do checkTool(t) end
				if backpack then
					for _, t in pairs(backpack:GetChildren()) do checkTool(t) end
				end

				local highlight = char:FindFirstChild("VoidMM2Highlight")
				if not highlight then
					highlight = Instance.new("Highlight")
					highlight.Name = "VoidMM2Highlight"
					highlight.Parent = char
					espHighlights[p] = highlight
				end

				if role == "Murderer" then
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				elseif role == "Sheriff" then
					highlight.FillColor = Color3.fromRGB(0, 0, 255)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				else
					highlight.FillColor = Color3.fromRGB(0, 255, 0)
					highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
				end
			end
		end
	end)

	-- 7. كاميرا لوك تلقائية على المجرم فقط
	local lockMurdererActive = false

	lockMurdererBtn.MouseButton1Click:Connect(function()
		lockMurdererActive = not lockMurdererActive
		lockMurdererBtn.Text = "Lock on Murderer: " .. (lockMurdererActive and "ON" or "OFF")
	end)

	RunService.RenderStepped:Connect(function()
		if lockMurdererActive then
			local murderer = getMurderer()
			if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
				workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, murderer.Character.HumanoidRootPart.Position)
			end
		end
	end)

	-- 8. إدارة وتشغيل الأغاني من القائمة
	local activeMusic = nil

	local function playMusicById(id)
		if activeMusic then
			pcall(function() activeMusic:Stop(); activeMusic:Destroy() end)
		end
		
		activeMusic = Instance.new("Sound")
		activeMusic.Name = "VoidHubUserMusic"
		activeMusic.SoundId = "rbxassetid://" .. tostring(id)
		activeMusic.Volume = 1
		activeMusic.Looped = true
		activeMusic.Parent = SoundService
		
		pcall(function() activeMusic:Play() end)
	end

	playCustomBtn.MouseButton1Click:Connect(function()
		local customId = musicBox.Text
		if customId ~= "" then
			playMusicById(customId)
			playCustomBtn.Text = "Playing ID: " .. customId
			task.delay(2, function()
				playCustomBtn.Text = "تشغيل الأغنية المكتوبة (Play ID)"
			end)
		end
	end)

	playDefaultBtn.MouseButton1Click:Connect(function()
		playMusicById(DEFAULT_MUSIC_ID)
		playDefaultBtn.Text = "Playing Your Song!"
		task.delay(2, function()
			playDefaultBtn.Text = "تشغيل الأغنية الخاصة بك الأساسية"
		end)
	end)

	stopMusicBtn.MouseButton1Click:Connect(function()
		if activeMusic then
			pcall(function() activeMusic:Stop(); activeMusic:Destroy() end)
			activeMusic = nil
		end
		stopMusicBtn.Text = "Music Stopped!"
		task.delay(2, function()
			stopMusicBtn.Text = "إيقاف الأغنية (Stop Music)"
		end)
	end)
end

--============================================================
-- تشغيل الأغنية تلقائياً عند بداية الإنترو
--============================================================

task.spawn(function()
	backgroundMusic = Instance.new("Sound")
	backgroundMusic.Name = "VoidHubIntroMusic"
	backgroundMusic.SoundId = "rbxassetid://" .. DEFAULT_MUSIC_ID
	backgroundMusic.Volume = 0.8
	backgroundMusic.Looped = true
	backgroundMusic.Parent = SoundService
	
	pcall(function() backgroundMusic:Play() end)
end)

--============================================================
-- إنهاء الإنترو وفتح المنيو
--============================================================

local function finishIntro()
	if introFinished then return end
	introFinished = true
	introActive = false

	if backgroundMusic then
		pcall(function()
			TweenService:Create(backgroundMusic, TweenInfo.new(0.35), {Volume = 0}):Play()
		end)
		task.delay(0.4, function()
			pcall(function()
				backgroundMusic:Stop()
				backgroundMusic:Destroy()
			end)
		end)
	end

	pcall(function() gui:Destroy() end)
	createVoidHubMainUI()
end

skip.MouseButton1Click:Connect(finishIntro)

skip.MouseEnter:Connect(function()
	TweenService:Create(skip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
end)

skip.MouseLeave:Connect(function()
	TweenService:Create(skip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
end)

TweenService:Create(image, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
TweenService:Create(image, TweenInfo.new(18, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(1.18, 1.18)}):Play()

task.wait(1.5)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.18), TextTransparency = 0}):Play()
TweenService:Create(titleStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()

task.wait(1)
for i = 1, 18 do
	if not introActive then return end
	introTitle.Position = UDim2.fromScale(0.5 + math.random(-8, 8)/1000, 0.5 + math.random(-8, 8)/1000)
	task.wait(0.025)
end
introTitle.Position = UDim2.fromScale(0.5, 0.5)

TweenService:Create(introSubtitle, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

task.wait(7)
if not introActive then return end

for i = 1, 14 do
	if not introActive then return end
	flash.BackgroundTransparency = 0
	task.wait(0.025)
	flash.BackgroundTransparency = 1
	task.wait(0.065)
end

task.wait(2)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(introSubtitle, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(titleStroke, TweenInfo.new(1), {Transparency = 1}):Play()
TweenService:Create(image, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
TweenService:Create(dark, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()

if backgroundMusic and backgroundMusic.Parent then
	TweenService:Create(backgroundMusic, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Volume = 0}):Play()
end

local finalFade = Instance.new("Frame")
finalFade.Size = UDim2.fromScale(1, 1)
finalFade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
finalFade.BackgroundTransparency = 1
finalFade.BorderSizePixel = 0
finalFade.ZIndex = 1000
finalFade.Parent = gui

TweenService:Create(finalFade, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()

task.wait(1.6)
finishIntro()
