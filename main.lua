--============================================================
-- VOID HUB - ULTIMATE MM2 MASTER EDITION
-- (MUSIC PLAYER, FLY, INFINITE JUMP, ESP RADAR, CAMERA LOCK, SPEED CONTROLLER)
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Workspace = game.Workspace

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- 1. إعدادات الإنترو والموسيقى (الأيدي الأساسي المرفق)
--============================================================

local DEFAULT_MUSIC_ID = "82757474758500"
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

-- واجهة الإنترو البصرية
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
introSubtitle.Text = "MM2 ULTIMATE MASTER"
introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
introSubtitle.TextTransparency = 1
introSubtitle.TextScaled = true
introSubtitle.Font = Enum.Font.GothamBold
introSubtitle.ZIndex = 20
introSubtitle.Parent = background

--============================================================
-- 2. المنيو الرئيسية الكاملة (تحتوي على زر تعلية وتوطية السرعة، رادار بعيد المدى، وكاميرا لوك للمجرم)
--============================================================

local function createVoidHubMainUI()
	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "VoidHubMainUI"
	mainGui.ResetOnSpawn = false
	mainGui.Parent = PlayerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(340, 680)
	mainFrame.Position = UDim2.fromScale(0.1, 0.06)
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
	title.Text = "VOID HUB - ULTIMATE MM2"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = title

	local function createButton(name, posY)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 30)
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
		box.Size = UDim2.new(0.9, 0, 0, 30)
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

	-- الأزرار الرئيسية في القائمة
	local flyBtn = createButton("Toggle Fly: OFF", 45)
	local noclipBtn = createButton("Toggle Noclip: OFF", 78)
	local infJumpBtn = createButton("Infinite Jump (القفز اللانهائي): OFF", 111)
	local touchFlingBtn = createButton("Touch Fling (طرد باللمس): OFF", 144)
	local mm2RadarBtn = createButton("MM2 Long-Range Radar (رادار بعيد المدى): OFF", 177)
	local lockMurdererBtn = createButton("Lock on Murderer (كاميرا لوك على المجرم): OFF", 210)

	-- قسم التحكم بالسرعة (توسيع وتقليل السرعة بدقة دون إثقال الجهاز)
	local speedTitle = Instance.new("TextLabel")
	speedTitle.Size = UDim2.new(0.9, 0, 0, 20)
	speedTitle.Position = UDim2.new(0.05, 0, 0, 243)
	speedTitle.BackgroundTransparency = 1
	speedTitle.Text = "--- Speed Controller (تحكم السرعة) ---"
	speedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	speedTitle.Font = Enum.Font.GothamBold
	speedTitle.TextSize = 11
	speedTitle.Parent = mainFrame

	local speedUpBtn = createButton("زيادة السرعة (+ Speed)", 266)
	speedUpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
	local speedDownBtn = createButton("تقليل السرعة (- Speed)", 300)
	speedDownBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)

	-- قسم قائمة الأغاني (Music Hub) والأيدي المطلوب
	local musicTitle = Instance.new("TextLabel")
	musicTitle.Size = UDim2.new(0.9, 0, 0, 20)
	musicTitle.Position = UDim2.new(0.05, 0, 0, 335)
	musicTitle.BackgroundTransparency = 1
	musicTitle.Text = "--- Music Player Hub (قائمة الأغاني) ---"
	musicTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	musicTitle.Font = Enum.Font.GothamBold
	musicTitle.TextSize = 11
	musicTitle.Parent = mainFrame

	local musicBox = createTextBox("اكتب أيدي الأغنية هنا...", 358)
	musicBox.Text = DEFAULT_MUSIC_ID

	local playCustomBtn = createButton("تشغيل الأغنية المكتوبة (Play ID)", 393)
	local stopMusicBtn = createButton("إيقاف الأغنية (Stop Music)", 428)
	stopMusicBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)

	local closeBtn = createButton("Close Menu", 635)
	closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

	closeBtn.MouseButton1Click:Connect(function()
		mainGui:Destroy()
	end)

	--============================================================
	-- تنفيذ وظائف السكربتات داخل اللعبة
	--============================================================

	-- 1. الطيران (Fly)
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

	-- 2. اختراق الجدران (Noclip)
	local noclipping = false
	noclipBtn.MouseButton1Click:Connect(function()
		noclipping = not noclipping
		noclipBtn.Text = "Toggle Noclip: " .. (noclipping and "ON" or "OFF")
	end)

	RunService.Stepped:Connect(function()
		if noclipping and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)

	-- 3. القفز اللانهائي (Infinite Jump)
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

	-- 4. طرد اللاعبين باللمس (Touch Fling)
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

	-- 5. نظام السرعة القابل للزيادة والتنقيص (Speed Controller)
	local currentSpeedMultiplier = 16 -- السرعة الافتراضية للعبة
	speedUpBtn.MouseButton1Click:Connect(function()
		currentSpeedMultiplier = currentSpeedMultiplier + 4
		speedUpBtn.Text = "Speed: " .. currentSpeedMultiplier
	end)

	speedDownBtn.MouseButton1Click:Connect(function()
		if currentSpeedMultiplier > 8 then
			currentSpeedMultiplier = currentSpeedMultiplier - 4
		end
		speedDownBtn.Text = "Speed: " .. currentSpeedMultiplier
	end)

	RunService.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = player.Character.Humanoid
			if hum.MoveDirection.Magnitude > 0 and currentSpeedMultiplier ~= 16 then
				player.Character:TranslateBy(hum.MoveDirection * (currentSpeedMultiplier - 16) * RunService.Heartbeat:Wait())
			end
		end
	end)

	-- 6. رادار بعيد المدى وكشف اللاعبين فوق رؤوسهم بغض النظر عن المسافة (بدون إثقال الجهاز)
	local mm2RadarActive = false
	local espHighlights = {}
	local espBillboards = {}

	mm2RadarBtn.MouseButton1Click:Connect(function()
		mm2RadarActive = not mm2RadarActive
		mm2RadarBtn.Text = "MM2 Radar: " .. (mm2RadarActive and "ON" or "OFF")

		if not mm2RadarActive then
			for _, h in pairs(espHighlights) do if h then h:Destroy() end end
			for _, b in pairs(espBillboards) do if b then b:Destroy() end end
			espHighlights = {}
			espBillboards = {}
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
						if name:find("knife") or name:find("blade") then return true end
					end
					return false
				end
				for _, t in pairs(char:GetChildren()) do if checkTool(t) then return p end end
				if backpack then
					for _, t in pairs(backpack:GetChildren()) do if checkTool(t) then return p end end
				end
			end
		end
		return nil
	end

	-- تحديث الرادار كل فترة وجيزة لتخفيف الضغط على الجهاز تماماً
	task.spawn(function()
		while true do
			if mm2RadarActive then
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
						local char = p.Character
						local head = char.Head
						local role = "Innocent"
						local backpack = p:FindFirstChild("Backpack")

						local function checkTool(tool)
							if tool:IsA("Tool") then
								local name = string.lower(tool.Name)
								if name:find("knife") or name:find("blade") then role = "Murderer"
								elseif name:find("gun") or name:find("revolver") then role = "Sheriff" end
							end
						end
						for _, t in pairs(char:GetChildren()) do checkTool(t) end
						if backpack then for _, t in pairs(backpack:GetChildren()) do checkTool(t) end end

						-- إبراز اللاعب (Highlight)
						local highlight = char:FindFirstChild("VoidMM2Highlight")
						if not highlight then
							highlight = Instance.new("Highlight")
							highlight.Name = "VoidMM2Highlight"
							highlight.Parent = char
							espHighlights[p] = highlight
						end

						-- لافتة الاسم والدور فوق الرأس (تظهر حتى لو كان اللاعب بعيداً جداً)
						local billboard = head:FindFirstChild("VoidMM2Tag")
						if not billboard then
							billboard = Instance.new("BillboardGui")
							billboard.Name = "VoidMM2Tag"
							billboard.Size = UDim2.fromOffset(200, 50)
							billboard.StudsOffset = Vector3.new(0, 2.5, 0)
							billboard.AlwaysOnTop = true
							billboard.Parent = head
							espBillboards[p] = billboard

							local txt = Instance.new("TextLabel")
							txt.Name = "TagText"
							txt.Size = UDim2.fromScale(1, 1)
							txt.BackgroundTransparency = 1
							txt.TextScaled = true
							txt.Font = Enum.Font.GothamBold
							txt.TextColor3 = Color3.fromRGB(255, 255, 255)
							txt.TextStrokeTransparency = 0
							txt.Parent = billboard
						end

						local txtLabel = billboard:FindFirstChild("TagText")
						if txtLabel then
							txtLabel.Text = p.Name .. " [" .. role .. "]"
						end

						if role == "Murderer" then
							highlight.FillColor = Color3.fromRGB(255, 0, 0)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							if txtLabel then txtLabel.TextColor3 = Color3.fromRGB(255, 0, 0) end
						elseif role == "Sheriff" then
							highlight.FillColor = Color3.fromRGB(0, 0, 255)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							if txtLabel then txtLabel.TextColor3 = Color3.fromRGB(0, 150, 255) end
						else
							highlight.FillColor = Color3.fromRGB(0, 255, 0)
							highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
							if txtLabel then txtLabel.TextColor3 = Color3.fromRGB(0, 255, 0) end
						end
					end
				end
			end
			task.wait(0.5) -- تحديث منخفض الاستهلاك للحفاظ على كفاءة وقوة الجهاز
		end
	end)

	-- 7. كاميرا لوك على المجرم فقط (Camera Lock on Murderer)
	local lockMurdererActive = false

	lockMurdererBtn.MouseButton1Click:Connect(function()
		lockMurdererActive = not lockMurdererActive
		lockMurdererBtn.Text = "Lock on Murderer: " .. (lockMurdererActive and "ON" or "OFF")
	end)

	RunService.RenderStepped:Connect(function()
		if lockMurdererActive then
			local murderer = getMurderer()
			if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
				Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, murderer.Character.HumanoidRootPart.Position)
			end
		end
	end)

	-- 8. إدارة وتشغيل الأغاني (Music Hub)
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
		local customId = musicBox.Text ~= "" and musicBox.Text or DEFAULT_MUSIC_ID
		playMusicById(customId)
		playCustomBtn.Text = "Playing ID: " .. customId
		task.delay(2, function()
			playCustomBtn.Text = "تشغيل الأغنية المكتوبة (Play ID)"
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
-- تشغيل الأغنية الافتراضية المطلوبة عند الإقلاع
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
-- إنهاء الإنترو وفتح القائمة الرئيسية
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
