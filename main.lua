--============================================================
-- VOID HUB - ULTIMATE CUSTOM EDITION (صور اللاعبين + الرادار الآمن + الانتقال)
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
-- نظام منع الطرد (Anti-Kick خفيف وصامت داخلياً)
--============================================================
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                if method and method:lower() == "kick" and self == player then
                    return nil
                end
                return oldNamecall(self, ...)
            end
            setreadonly(mt, true)
        end
    end)
end)

--============================================================
-- 1. إعدادات الإنترو والموسيقى
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

local imageIndex = math.random(1, #IMAGES)
local IMAGE_ID = IMAGES[imageIndex]

local introActive = true
local introFinished = false
local backgroundMusic = nil

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
introSubtitle.Text = "ULTIMATE PLAYER RADAR & TP"
introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
introSubtitle.TextTransparency = 1
introSubtitle.TextScaled = true
introSubtitle.Font = Enum.Font.GothamBold
introSubtitle.ZIndex = 20
introSubtitle.Parent = background

--============================================================
-- 2. واجهة التحكم الرئيسية
--============================================================

local function createVoidHubMainUI()
	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "VoidHubMainUI"
	mainGui.ResetOnSpawn = false
	mainGui.Parent = PlayerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(360, 680)
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
	title.Text = "VOID HUB - PLAYER RADAR & TP"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
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

	-- الأزرار الأساسية
	local flyBtn = createButton("Toggle Safe Fly (طيران آمن مانع للكيك): OFF", 45)
	local noclipBtn = createButton("Toggle Noclip: OFF", 78)
	local radarBtn = createButton("Player Image & Distance Radar (رادار الصور والأمتار): OFF", 111)
	
	-- قسم الانتقال بأول 3 أحرف (أو أول حرفين)
	local tpTitle = Instance.new("TextLabel")
	tpTitle.Size = UDim2.new(0.9, 0, 0, 20)
	tpTitle.Position = UDim2.new(0.05, 0, 0, 146)
	tpTitle.BackgroundTransparency = 1
	tpTitle.Text = "--- Teleport (اكتب أول 3 حروف من اسم اللاعب) ---"
	tpTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	tpTitle.Font = Enum.Font.GothamBold
	tpTitle.TextSize = 11
	tpTitle.Parent = mainFrame

	local targetBox = createTextBox("اكتب أول 3 حروف من الاسم هنا...", 168)
	local tpBtn = createButton("الانتقال الفوري لعند الولد (Teleport)", 203)
	tpBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 100)

	-- قسم التحكم بالسرعة (زيادة وإنقاص بحرية)
	local speedTitle = Instance.new("TextLabel")
	speedTitle.Size = UDim2.new(0.9, 0, 0, 20)
	speedTitle.Position = UDim2.new(0.05, 0, 0, 240)
	speedTitle.BackgroundTransparency = 1
	speedTitle.Text = "--- Speed Controller (زيادة ونقصان السرعة) ---"
	speedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	speedTitle.Font = Enum.Font.GothamBold
	speedTitle.TextSize = 11
	speedTitle.Parent = mainFrame

	local speedUpBtn = createButton("زيادة السرعة (+ Speed)", 263)
	speedUpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
	local speedDownBtn = createButton("تقليل السرعة (- Speed)", 297)
	speedDownBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)

	-- قسم مشغل الموسيقى
	local musicTitle = Instance.new("TextLabel")
	musicTitle.Size = UDim2.new(0.9, 0, 0, 20)
	musicTitle.Position = UDim2.new(0.05, 0, 0, 332)
	musicTitle.BackgroundTransparency = 1
	musicTitle.Text = "--- Music Player Hub ---"
	musicTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	musicTitle.Font = Enum.Font.GothamBold
	musicTitle.TextSize = 11
	musicTitle.Parent = mainFrame

	local musicBox = createTextBox("اكتب أيدي الأغنية هنا...", 355)
	musicBox.Text = DEFAULT_MUSIC_ID

	local playCustomBtn = createButton("تشغيل الأغنية المكتوبة (Play ID)", 390)
	local stopMusicBtn = createButton("إيقاف الأغنية (Stop Music)", 425)
	stopMusicBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)

	local closeBtn = createButton("Close Menu", 635)
	closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

	closeBtn.MouseButton1Click:Connect(function()
		mainGui:Destroy()
	end)

	--============================================================
	-- تنفيذ السكربتات المخصصة
	--============================================================

	-- 1. الطيران الآمن المانع للكيك (Micro-CFrame)
	local flying = false
	local fspeed = 1.2

	flyBtn.MouseButton1Click:Connect(function()
		flying = not flying
		flyBtn.Text = "Toggle Safe Fly: " .. (flying and "ON" or "OFF")
	end)

	RunService.RenderStepped:Connect(function(dt)
		if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local cam = workspace.CurrentCamera
			local moveDirection = Vector3.new()
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
			
			if moveDirection.Magnitude > 0 then
				hrp.CFrame = hrp.CFrame + (moveDirection.Unit * fspeed * 2)
				hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end
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

	-- 3. رادار الأمتار + عرض صورة الولد فوق رأسه مباشرة مع اسمه والمسافة
	local radarActive = false
	local espBillboards = {}

	radarBtn.MouseButton1Click:Connect(function()
		radarActive = not radarActive
		radarBtn.Text = "Player Image & Distance Radar: " .. (radarActive and "ON" or "OFF")

		if not radarActive then
			for _, b in pairs(espBillboards) do if b then b:Destroy() end end
			espBillboards = {}
		end
	end)

	task.spawn(function()
		while true do
			if radarActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local myPos = player.Character.HumanoidRootPart.Position
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
						local char = p.Character
						local head = char.Head
						local hrp = char.HumanoidRootPart
						local distance = math.floor((hrp.Position - myPos).Magnitude)

						-- جلب صورة اللاعب (Avatar Thumbnail)
						local success, content = pcall(function()
							return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
						end)
						local thumbUrl = success and content or ""

						local billboard = head:FindFirstChild("VoidPlayerRadarTag")
						if not billboard then
							billboard = Instance.new("BillboardGui")
							billboard.Name = "VoidPlayerRadarTag"
							billboard.Size = UDim2.fromOffset(140, 60)
							billboard.StudsOffset = Vector3.new(0, 3, 0)
							billboard.AlwaysOnTop = true
							billboard.Parent = head
							espBillboards[p] = billboard

							-- صورة الولد
							local imgLabel = Instance.new("ImageLabel")
							imgLabel.Name = "PlayerImage"
							imgLabel.Size = UDim2.fromOffset(36, 36)
							imgLabel.Position = UDim2.new(0.5, -18, 0, 0)
							imgLabel.BackgroundTransparency = 1
							imgLabel.Image = thumbUrl
							imgLabel.Parent = billboard

							local imgCorner = Instance.new("UICorner")
							imgCorner.CornerRadius = UDim.new(1, 0)
							imgCorner.Parent = imgLabel

							-- النص (الاسم والمسافة بالأمتار)
							local txt = Instance.new("TextLabel")
							txt.Name = "TagText"
							txt.Size = UDim2.new(1, 0, 0, 20)
							txt.Position = UDim2.new(0, 0, 0, 38)
							txt.BackgroundTransparency = 1
							txt.TextScaled = true
							txt.Font = Enum.Font.GothamBold
							txt.TextColor3 = Color3.fromRGB(0, 255, 255)
							txt.TextStrokeTransparency = 0
							txt.Parent = billboard
						end

						local txtLabel = billboard:FindFirstChild("TagText")
						if txtLabel then
							txtLabel.Text = p.Name .. " [" .. distance .. "m]"
						end
					end
				end
			end
			task.wait(0.4)
		end
	end)

	-- 4. زر الانتقال (Teleport) بأول 3 أحرف من اسم الولد
	tpBtn.MouseButton1Click:Connect(function()
		local query = string.lower(targetBox.Text)
		if query == "" then return end
		local targetPlayer = nil
		
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				local pName = string.lower(p.Name)
				local pDisplayName = string.lower(p.DisplayName)
				-- التحقق من أول 3 أحرف أو الاسم كاملاً
				if pName:sub(1, #query) == query or pDisplayName:sub(1, #query) == query or pName:find(query) then
					targetPlayer = p
					break
				end
			end
		end

		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				tpBtn.Text = "Done! Teleported to " .. targetPlayer.Name
				task.delay(2, function()
					tpBtn.Text = "الانتقال الفوري لعند الولد (Teleport)"
				end)
			end
		else
			tpBtn.Text = "Player Not Found!"
			task.delay(2, function()
				tpBtn.Text = "الانتقال الفوري لعند الولد (Teleport)"
			end)
		end
	end)

	-- 5. نظام السرعة (زيادة ونقصان السرعة بحرية)
	local currentSpeedMultiplier = 16
	speedUpBtn.MouseButton1Click:Connect(function()
		currentSpeedMultiplier = currentSpeedMultiplier + 4
		speedUpBtn.Text = "Speed: " .. currentSpeedMultiplier
	end)

	speedDownBtn.MouseButton1Click:Connect(function()
		if currentSpeedMultiplier > 8 then
			currentSpeedMultiplier = currentSpeedMultiplier - 4
		end
		speedUpBtn.Text = "Speed: " .. currentSpeedMultiplier
	end)

	RunService.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = player.Character.Humanoid
			if hum.MoveDirection.Magnitude > 0 and currentSpeedMultiplier ~= 16 then
				player.Character:TranslateBy(hum.MoveDirection * (currentSpeedMultiplier - 16) * RunService.Heartbeat:Wait())
			end
		end
	end)

	-- 6. مشغل الأغاني
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
		playCustomBtn.Text = "Playing ID!"
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
-- تشغيل الموسيقى والإنترو
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

TweenService:Create(image, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
TweenService:Create(image, TweenInfo.new(18, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(1.18, 1.18)}):Play()

task.wait(1.5)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.9, 0.18), TextTransparency = 0}):Play()
TweenService:Create(titleStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()

task.wait(1.5)
TweenService:Create(introSubtitle, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

task.wait(5)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(introSubtitle, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(titleStroke, TweenInfo.new(1), {Transparency = 1}):Play()
TweenService:Create(image, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
TweenService:Create(dark, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()

if backgroundMusic and backgroundMusic.Parent then
	pcall(function()
		TweenService:Create(backgroundMusic, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Volume = 0}):Play()
	end)
end

task.wait(1.6)
finishIntro()
