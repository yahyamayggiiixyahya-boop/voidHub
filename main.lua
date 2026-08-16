--============================================================
-- VOID HUB - MM2 ULTIMATE PRO EDITION (مخصص للعبة Murder Mystery 2)
-- التعديلات الجديدة: زر إخفاء/إظهار القائمة (Minimize/Maximize)، تصغير حجم القائمة، أزرار الططيير والتليبورت للمسدس والمجرم والشريف
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
-- نظام الحماية ومنع الطرد (Anti-Kick)
--============================================================
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = function(self, ...)
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

-- دالة مساعدة للبحث عن المجرم (Murderer) والشريف (Sheriff) والمسدس الساقط في ماب MM2
local function getMM2Roles()
    local murderer, sheriff
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                murderer = p
            end
            if p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                sheriff = p
            end
        end
    end
    local droppedGun = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then
            droppedGun = obj
            break
        end
    end
    return murderer, sheriff, droppedGun
end

--============================================================
-- 1. واجهة الإنترو والموسيقى
--============================================================

local DEFAULT_MUSIC_ID = "82757474758500"
local IMAGES = {
	"rbxassetid://129700697019613",
	"rbxassetid://108697485255882",
	"rbxassetid://71211662493854",
	"rbxassetid://118953269416540"
}

for _, name in ipairs({"VoidHubIntro", "VoidHubMM2UI"}) do
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
introTitle.Text = "VOID HUB: MM2"
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
introSubtitle.Text = "MURDER MYSTERY 2 PRO EDITION"
introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
introSubtitle.TextTransparency = 1
introSubtitle.TextScaled = true
introSubtitle.Font = Enum.Font.GothamBold
introSubtitle.ZIndex = 20
introSubtitle.Parent = background

--============================================================
-- 2. واجهة التحكم الرئيسية المصححة (بحجم أصغر، مع زر تصغير/إخفاء Open/Close)
--============================================================

local function createVoidHubMainUI()
	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "VoidHubMM2UI"
	mainGui.ResetOnSpawn = false
	mainGui.Parent = PlayerGui

	-- زر عائم صغير لإظهار وإخفاء القائمة بالكامل (حتى لا تأخذ مساحة الشاشة)
	local toggleMenuBtn = Instance.new("TextButton")
	toggleMenuBtn.Size = UDim2.fromOffset(100, 35)
	toggleMenuBtn.Position = UDim2.new(0, 15, 0, 15)
	toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	toggleMenuBtn.Text = "📁 Void Menu"
	toggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleMenuBtn.Font = Enum.Font.GothamBold
	toggleMenuBtn.TextSize = 11
	toggleMenuBtn.Active = true
	toggleMenuBtn.Draggable = true
	toggleMenuBtn.Parent = mainGui

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 8)
	toggleCorner.Parent = toggleMenuBtn

	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Color = Color3.fromRGB(100, 100, 200)
	toggleStroke.Thickness = 1
	toggleStroke.Parent = toggleMenuBtn

	-- الإطار الرئيسي للقائمة (تم تصغير الحجم ليكون مناسباً ومرتباً)
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(340, 490)
	mainFrame.Position = UDim2.new(0, 15, 0, 60)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = mainGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 35)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	title.Text = "VOID HUB - MM2 PRO MOD"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize, title.Parent = 12, mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = title

	-- زر إغلاق القائمة من داخلها
	local closeInsideBtn = Instance.new("TextButton")
	closeInsideBtn.Size = UDim2.fromOffset(30, 25)
	closeInsideBtn.Position = UDim2.new(1, -35, 0, 5)
	closeInsideBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
	closeInsideBtn.Text = "X"
	closeInsideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeInsideBtn.Font = Enum.Font.GothamBold
	closeInsideBtn.TextSize = 11
	closeInsideBtn.Parent = title

	local closeInsideCorner = Instance.new("UICorner")
	closeInsideCorner.CornerRadius = UDim.new(0, 6)
	closeInsideCorner.Parent = closeInsideBtn

	closeInsideBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
	end)

	toggleMenuBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)

	-- إنشاء الأزرار بشكل مرتب ومنظم لتوفير مساحة الشاشة
	local function createButton(name, posY)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 28)
		btn.Position = UDim2.new(0.05, 0, 0, posY)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		btn.Text = name
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.Parent = mainFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 7)
		btnCorner.Parent = btn
		return btn
	end

	local function createTextBox(placeholder, posY)
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(0.9, 0, 0, 28)
		box.Position = UDim2.new(0.05, 0, 0, posY)
		box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		box.PlaceholderText = placeholder
		box.Text = ""
		box.TextColor3 = Color3.fromRGB(255, 255, 255)
		box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		box.Font = Enum.Font.Gotham
		box.TextSize = 11
		box.Parent = mainFrame

		local boxCorner = Instance.new("UICorner")
		boxCorner.CornerRadius = UDim.new(0, 7)
		boxCorner.Parent = box
		return box
	end

	-- ترتيب الأزرار والوظائف المطلوبة بدقة
	local antiKillBtn = createButton("حماية تلقائية من المجرم (Auto-Fling Murderer): OFF", 42)
	antiKillBtn.BackgroundColor3 = Color3.fromRGB(110, 30, 30)

	local flyBtn = createButton("الطيران الآمن (Safe Fly): OFF", 74)
	local radarBtn = createButton("رادار الأمتار والصور فوق اللاعبين: OFF", 106)

	-- قسم تطيير المجرم أو الشريف بضغطة زر
	local flingMurderBtn = createButton("تطيير المجرم فوراً (Fling Murderer)", 140)
	flingMurderBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 30)

	local flingSheriffBtn = createButton("تطيير الشريف / صاحب المسدس (Fling Sheriff)", 172)
	flingSheriffBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 140)

	local tpGunBtn = createButton("تليبورت للمسدس (خذ المسدس وارجع فوراً)", 204)
	tpGunBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 80)

	-- قسم البحث بأول 3 حروف والتنقل أو التطيير
	local targetBox = createTextBox("اكتب أول 3 حروف من اسم اللاعب...", 240)
	
	local tpTargetBtn = createButton("الانتقال الفوري للّاعب المحدد (Teleport)", 274)
	tpTargetBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 100)

	local flingTargetBtn = createButton("تطيير اللاعب المكتوب (Fling Target)", 306)
	flingTargetBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 20)

	-- قسم التحكم في السرعة
	local speedUpBtn = createButton("زيادة السرعة (+ Speed)", 342)
	speedUpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
	local speedDownBtn = createButton("تقليل السرعة (- Speed)", 374)
	speedDownBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)

	-- زر إغلاق السكربت بالكامل
	local closeBtn = createButton("إغلاق السكربت وحذف القائمة", 420)
	closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

	closeBtn.MouseButton1Click:Connect(function()
		mainGui:Destroy()
	end)

	--============================================================
	-- تنفيذ الوظائف والبرمجة الداخلية
	--============================================================

	local function flingPlayer(targetPlayer)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetHrp = targetPlayer.Character.HumanoidRootPart
			local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if myHrp then
				local oldPos = myHrp.CFrame
				local startTime = tick()
				local connection
				connection = RunService.Heartbeat:Connect(function()
					if tick() - startTime < 0.8 and targetHrp and myHrp then
						myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 0)
						myHrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
						local bv = Instance.new("BodyVelocity")
						bv.Velocity = Vector3.new(math.random(-5000, 5000), 5000, math.random(-5000, 5000))
						bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						bv.Parent = myHrp
						task.delay(0.1, function() if bv then bv:Destroy() end end)
					else
						connection:Disconnect()
						myHrp.CFrame = oldPos
					end
				end)
			end
		end
	end

	-- 1. زر الحماية التلقائية (إذا حاول المجرم لمسك أو قتلك، يطير المجرم تلقائياً وتنجو)
	local autoAntiKill = false
	antiKillBtn.MouseButton1Click:Connect(function()
		autoAntiKill = not autoAntiKill
		antiKillBtn.Text = "حماية تلقائية من المجرم: " .. (autoAntiKill and "ON" or "OFF")
	end)

	task.spawn(function()
		while true do
			if autoAntiKill and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local murderer, _, _ = getMM2Roles()
				if murderer and murderer ~= player and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (murderer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if dist < 14 then
						flingPlayer(murderer)
					end
				end
			end
			task.wait(0.2)
		end
	end)

	-- 2. الطيران الآمن (Safe Fly)
	local flying = false
	local fspeed = 1.2

	flyBtn.MouseButton1Click:Connect(function()
		flying = not flying
		flyBtn.Text = "الطيران الآمن (Safe Fly): " .. (flying and "ON" or "OFF")
	end)

	RunService.RenderStepped:Connect(function()
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

	-- 3. رادار الأمتار والصور
	local radarActive = false
	local espBillboards = {}

	radarBtn.MouseButton1Click:Connect(function()
		radarActive = not radarActive
		radarBtn.Text = "رادار الأمتار والصور: " .. (radarActive and "ON" or "OFF")

		if not radarActive then
			for _, b in pairs(espBillboards) do if b then b:Destroy() end end
			espBillboards = {}
		end
	end)

	task.spawn(function()
		while true do
			if radarActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local myPos = player.Character.HumanoidRootPart.Position
				local murderer, sheriff, _ = getMM2Roles()

				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
						local char = p.Character
						local head = char.Head
						local hrp = char.HumanoidRootPart
						local distance = math.floor((hrp.Position - myPos).Magnitude)

						local roleText = "[Innocent]"
						local roleColor = Color3.fromRGB(0, 255, 255)
						if p == murderer then
							roleText = "[MURDERER 🔪]"
							roleColor = Color3.fromRGB(255, 50, 50)
						elseif p == sheriff then
							roleText = "[SHERIFF 🔫]"
							roleColor = Color3.fromRGB(50, 150, 255)
						end

						local success, content = pcall(function()
							return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
						end)
						local thumbUrl = success and content or ""

						local billboard = head:FindFirstChild("VoidMM2RadarTag")
						if not billboard then
							billboard = Instance.new("BillboardGui")
							billboard.Name = "VoidMM2RadarTag"
							billboard.Size = UDim2.fromOffset(160, 70)
							billboard.StudsOffset = Vector3.new(0, 3.2, 0)
							billboard.AlwaysOnTop = true
							billboard.Parent = head
							espBillboards[p] = billboard

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

							local txt = Instance.new("TextLabel")
							txt.Name = "TagText"
							txt.Size = UDim2.new(1, 0, 0, 30)
							txt.Position = UDim2.new(0, 0, 0, 38)
							txt.BackgroundTransparency = 1
							txt.TextScaled = true
							txt.Font = Enum.Font.GothamBold
							txt.TextColor3 = roleColor
							txt.TextStrokeTransparency = 0
							txt.Parent = billboard
						end

						local txtLabel = billboard:FindFirstChild("TagText")
						if txtLabel then
							txtLabel.TextColor3 = roleColor
							txtLabel.Text = p.Name .. " " .. roleText .. " [" .. distance .. "m]"
						end
					end
				end
			end
			task.wait(0.4)
		end
	end)

	-- 4. أزرار التطيير الفوري للمجرم والشريف
	flingMurderBtn.MouseButton1Click:Connect(function()
		local murderer, _, _ = getMM2Roles()
		if murderer then
			flingPlayer(murderer)
			flingMurderBtn.Text = "تم تطيير المجرم بنجاح!"
			task.delay(2, function() flingMurderBtn.Text = "تطيير المجرم فوراً (Fling Murderer)" end)
		else
			flingMurderBtn.Text = "المجرم غير متوفر حالياً!"
			task.delay(2, function() flingMurderBtn.Text = "تطيير المجرم فوراً (Fling Murderer)" end)
		end
	end)

	flingSheriffBtn.MouseButton1Click:Connect(function()
		local _, sheriff, _ = getMM2Roles()
		if sheriff then
			flingPlayer(sheriff)
			flingSheriffBtn.Text = "تم تطيير الشريف بنجاح!"
			task.delay(2, function() flingSheriffBtn.Text = "تطيير الشريف / صاحب المسدس (Fling Sheriff)" end)
		else
			flingSheriffBtn.Text = "الشريف غير متوفر حالياً!"
			task.delay(2, function() flingSheriffBtn.Text = "تطيير الشريف / صاحب المسدس (Fling Sheriff)" end)
		end
	end)

	-- 5. تليبورت للمسدس (الذهاب لأخذ المسدس والعودة فوراً للمكان الأصلي)
	tpGunBtn.MouseButton1Click:Connect(function()
		task.spawn(function()
			local _, _, droppedGun = getMM2Roles()
			if droppedGun and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = player.Character.HumanoidRootPart
				local oldPos = hrp.CFrame
				
				hrp.CFrame = droppedGun.CFrame + Vector3.new(0, 2, 0)
				tpGunBtn.Text = "تم أخذ المسدس والرجوع!"
				task.wait(0.3)
				hrp.CFrame = oldPos

				task.delay(2, function()
					tpGunBtn.Text = "تليبورت للمسدس (خذ المسدس وارجع فوراً)"
				end)
			else
				tpGunBtn.Text = "لا يوجد مسدس واقع على الأرض!"
				task.delay(2, function()
					tpGunBtn.Text = "تليبورت للمسدس (خذ المسدس وارجع فوراً)"
				end)
			end
		end)
	end)

	-- 6. البحث بأول 3 حروف والتنقل أو التطيير
	tpTargetBtn.MouseButton1Click:Connect(function()
		local query = string.lower(targetBox.Text)
		if query == "" then return end
		local targetPlayer = nil
		
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				local pName = string.lower(p.Name)
				local pDisplayName = string.lower(p.DisplayName)
				if pName:sub(1, #query) == query or pDisplayName:sub(1, #query) == query or pName:find(query) then
					targetPlayer = p
					break
				end
			end
		end

		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				tpTargetBtn.Text = "تم الانتقال إلى " .. targetPlayer.Name
				task.delay(2, function() tpTargetBtn.Text = "الانتقال الفوري للّاعب المحدد (Teleport)" end)
			end
		else
			tpTargetBtn.Text = "لم يتم العثور على اللاعب!"
			task.delay(2, function() tpTargetBtn.Text = "الانتقال الفوري للّاعب المحدد (Teleport)" end)
		end
	end)

	flingTargetBtn.MouseButton1Click:Connect(function()
		local query = string.lower(targetBox.Text)
		if query == "" then return end
		local targetPlayer = nil
		
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				local pName = string.lower(p.Name)
				local pDisplayName = string.lower(p.DisplayName)
				if pName:sub(1, #query) == query or pDisplayName:sub(1, #query) == query or pName:find(query) then
					targetPlayer = p
					break
				end
			end
		end

		if targetPlayer then
			flingPlayer(targetPlayer)
			flingTargetBtn.Text = "تم تطيير " .. targetPlayer.Name
			task.delay(2, function() flingTargetBtn.Text = "تطيير اللاعب المكتوب (Fling Target)" end)
		end
	end)

	-- 7. السرعة
	local currentSpeedMultiplier = 16
	speedUpBtn.MouseButton1Click:Connect(function()
		currentSpeedMultiplier = currentSpeedMultiplier + 4
		speedUpBtn.Text = "السرعة الحالية: " .. currentSpeedMultiplier
	end)

	speedDownBtn.MouseButton1Click:Connect(function()
		if currentSpeedMultiplier > 8 then
			currentSpeedMultiplier = currentSpeedMultiplier - 4
		end
		speedUpBtn.Text = "السرعة الحالية: " .. currentSpeedMultiplier
	end)

	RunService.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = player.Character.Humanoid
			if hum.MoveDirection.Magnitude > 0 and currentSpeedMultiplier ~= 16 then
				player.Character:TranslateBy(hum.MoveDirection * (currentSpeedMultiplier - 16) * RunService.Heartbeat:Wait())
			end
		end
	end)
end

--============================================================
-- تشغيل الإنترو والموسيقى
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

task.wait(4)
if not introActive then return end

TweenService:Create(introTitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(introSubtitle, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(titleStroke, TweenInfo.new(1), {Transparency = 1}):Play()
TweenService:Create(image, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
TweenService:Create(dark, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()

task.wait(1.6)
finishIntro()
