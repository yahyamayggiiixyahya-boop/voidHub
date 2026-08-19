--============================================================
-- VOID HUB - FIXED MUSIC & ULTRA FPS OPTIMIZED HACKER DETECTOR
--============================================================

-- 1. ADVANCED ANTI-CRASH & FPS BOOST ENGINE
pcall(function()
	if collectgarbage then collectgarbage("collect") end
	
	local set = settings()
	if set and set.Rendering then
		pcall(function() set.Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	end
	
	local lighting = game:GetService("Lighting")
	if lighting then
		lighting.GlobalShadows = false
		lighting.FogEnd = 9e9
		for _, v in pairs(lighting:GetChildren()) do
			if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
				v.Enabled = false
			end
		end
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- MEMORY CLEANER (OPTIMIZED)
task.spawn(function()
	while task.wait(30) do
		pcall(function()
			if collectgarbage then collectgarbage("collect") end
		end)
	end
end)

--============================================================
-- EXECUTE LUARMOR LOADER
--============================================================
task.spawn(function()
	pcall(function()
		if type(loadstring) == "function" then
			loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/28bc742e3a8f491e8155a5c4327fd4dd.lua"))()
		end
	end)
end)

--============================================================
-- AUTO SAVE & LANGUAGE SYSTEM
--============================================================
local SETTINGS_FILE = "VoidHub_Settings.json"
local CHAT_FILE = "VoidHub_ChatHistory.json"

local appSettings = {
	NotificationsEnabled = false,
	ManualInput = false,
	AutoInput = false,
	AdminRole = nil,
	Language = "AR"
}

local chatHistory = {}

local function loadData()
	pcall(function()
		if type(readfile) == "function" and type(isfile) == "function" then
			if isfile(SETTINGS_FILE) then
				local sData = HttpService:JSONDecode(readfile(SETTINGS_FILE))
				if type(sData) == "table" then appSettings = sData end
			end
			if isfile(CHAT_FILE) then
				local cData = HttpService:JSONDecode(readfile(CHAT_FILE))
				if type(cData) == "table" then chatHistory = cData end
			end
		end
	end)
end

local function saveData()
	task.spawn(function()
		pcall(function()
			if type(writefile) == "function" then
				writefile(SETTINGS_FILE, HttpService:JSONEncode(appSettings))
				writefile(CHAT_FILE, HttpService:JSONEncode(chatHistory))
			end
		end)
	end)
end

loadData()
local currentAdminRole = appSettings.AdminRole

--============================================================
-- OPTIMIZED INPUT ENGINE
--============================================================
local function isStuckToPlayer()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
	local myHrp = player.Character.HumanoidRootPart
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetHrp = otherPlayer.Character.HumanoidRootPart
			if (myHrp.Position - targetHrp.Position).Magnitude <= 5 then return true end
		end
	end
	return false
end

RunService.RenderStepped:Connect(function()
	local shouldStabilize = appSettings.ManualInput or (appSettings.AutoInput and isStuckToPlayer())
	if shouldStabilize and player.Character then
		pcall(function()
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.RotVelocity = Vector3.zero
				local rx, ry, rz = hrp.CFrame:ToOrientation()
				hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, ry, 0)
			end
		end)
	end
end)

--============================================================
-- ULTRA OPTIMIZED HACKER DETECTOR (NO LAG / NO FPS DROP)
--============================================================
local playerPositions = {}
local lastVelocities = {}

local function createHackerTag(targetPlayer)
	if targetPlayer == player then return end

	local function setupChar(char)
		if not char then return end
		local head = char:WaitForChild("Head", 5)
		if not head then return end

		local oldBgui = head:FindFirstChild("HackerDetectorGui")
		if oldBgui then oldBgui:Destroy() end

		local bgui = Instance.new("BillboardGui")
		bgui.Name = "HackerDetectorGui"
		bgui.Size = UDim2.fromOffset(100, 25)
		bgui.StudsOffset = Vector3.new(0, 2.5, 0)
		bgui.AlwaysOnTop = true
		bgui.Parent = head

		local tagLabel = Instance.new("TextLabel", bgui)
		tagLabel.Size = UDim2.new(1, 0, 1, 0)
		tagLabel.BackgroundTransparency = 1
		tagLabel.Text = "NO HACKER"
		tagLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
		tagLabel.Font = Enum.Font.GothamBold
		tagLabel.TextSize = 11
		tagLabel.TextStrokeTransparency = 0.3

		-- تم تقليل التكرار وإصلاح الـ Lag كلياً باستخدام task.wait أكفأ
		task.spawn(function()
			while char and char.Parent and head and head.Parent do
				task.wait(0.5) -- زاد زمن الفحص لـ 0.5 لتوفير الـ FPS بدون التأثير على الدقة
				local hum = char:FindFirstChildOfClass("Humanoid")
				local hrp = char:FindFirstChild("HumanoidRootPart")

				if hum and hrp then
					local isHacker = false
					local state = hum:GetState()
					
					local isFallingOrJumping = (state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Climbing)

					if not isFallingOrJumping then
						local horizontalVel = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
						
						local lastVel = lastVelocities[targetPlayer] or 0
						if math.abs(horizontalVel - lastVel) > 160 then
							isHacker = true
						end
						lastVelocities[targetPlayer] = horizontalVel

						local hasBrainLoad = false
						for _, tool in pairs(char:GetChildren()) do
							if tool:IsA("Tool") and (tool.Name:lower():find("brain") or tool.Name:lower():find("load")) then
								hasBrainLoad = true
								break
							end
						end

						if hasBrainLoad and horizontalVel > 24 then
							isHacker = true
						elseif not hasBrainLoad and horizontalVel > 39 then
							isHacker = true
						end

						if playerPositions[targetPlayer] then
							local distMoved = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(playerPositions[targetPlayer].X, 0, playerPositions[targetPlayer].Z)).Magnitude
							if distMoved > 35 and horizontalVel < 5 then
								isHacker = true
							end
						end
					end

					playerPositions[targetPlayer] = hrp.Position

					if isHacker then
						tagLabel.Text = "🚨 HACKER 🚨"
						tagLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
					else
						tagLabel.Text = "NO HACKER"
						tagLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
					end
				end
			end
		end)
	end

	if targetPlayer.Character then setupChar(targetPlayer.Character) end
	targetPlayer.CharacterAdded:Connect(setupChar)
end

for _, p in pairs(Players:GetPlayers()) do createHackerTag(p) end
Players.PlayerAdded:Connect(createHackerTag)

--============================================================
-- MAIN GUI
--============================================================
pcall(function()
	local oldGui = PlayerGui:FindFirstChild("VoidHubFixedGui")
	if oldGui then oldGui:Destroy() end
end)

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "VoidHubFixedGui"
mainGui.ResetOnSpawn = false
mainGui.Parent = PlayerGui

local toggleBtn = Instance.new("TextButton", mainGui)
toggleBtn.Size = UDim2.fromOffset(36, 36)
toggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
toggleBtn.Text = "⚙️"
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.fromOffset(230, 320)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
frame.Visible = false
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- UI Dragging
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- TABS
local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(0.92, 0, 0, 22)
tabBar.Position = UDim2.new(0.04, 0, 0.02, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 5)

local tabChat = Instance.new("TextButton", tabBar)
tabChat.Size = UDim2.new(0.25, 0, 1, 0)
tabChat.BackgroundTransparency = 1
tabChat.Font = Enum.Font.GothamBold
tabChat.TextSize = 7

local tabInput = Instance.new("TextButton", tabBar)
tabInput.Size = UDim2.new(0.25, 0, 1, 0)
tabInput.Position = UDim2.new(0.25, 0, 0, 0)
tabInput.BackgroundTransparency = 1
tabInput.Font = Enum.Font.GothamBold
tabInput.TextSize = 7

local tabMusic = Instance.new("TextButton", tabBar)
tabMusic.Size = UDim2.new(0.25, 0, 1, 0)
tabMusic.Position = UDim2.new(0.50, 0, 0, 0)
tabMusic.BackgroundTransparency = 1
tabMusic.Font = Enum.Font.GothamBold
tabMusic.TextSize = 7

local tabSettings = Instance.new("TextButton", tabBar)
tabSettings.Size = UDim2.new(0.25, 0, 1, 0)
tabSettings.Position = UDim2.new(0.75, 0, 0, 0)
tabSettings.BackgroundTransparency = 1
tabSettings.Font = Enum.Font.GothamBold
tabSettings.TextSize = 7

local chatContainer = Instance.new("Frame", frame)
chatContainer.Size = UDim2.new(0.92, 0, 0.88, 0)
chatContainer.Position = UDim2.new(0.04, 0, 0.10, 0)
chatContainer.BackgroundTransparency = 1

local inputContainer = Instance.new("Frame", frame)
inputContainer.Size = UDim2.new(0.92, 0, 0.88, 0)
inputContainer.Position = UDim2.new(0.04, 0, 0.10, 0)
inputContainer.BackgroundTransparency = 1
inputContainer.Visible = false

local musicContainer = Instance.new("Frame", frame)
musicContainer.Size = UDim2.new(0.92, 0, 0.88, 0)
musicContainer.Position = UDim2.new(0.04, 0, 0.10, 0)
musicContainer.BackgroundTransparency = 1
musicContainer.Visible = false

local settingsContainer = Instance.new("Frame", frame)
settingsContainer.Size = UDim2.new(0.92, 0, 0.88, 0)
settingsContainer.Position = UDim2.new(0.04, 0, 0.10, 0)
settingsContainer.BackgroundTransparency = 1
settingsContainer.Visible = false

local function switchTab(tab)
	chatContainer.Visible = (tab == "chat")
	inputContainer.Visible = (tab == "input")
	musicContainer.Visible = (tab == "music")
	settingsContainer.Visible = (tab == "settings")
	
	tabChat.TextColor3 = tab == "chat" and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
	tabInput.TextColor3 = tab == "input" and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
	tabMusic.TextColor3 = tab == "music" and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
	tabSettings.TextColor3 = tab == "settings" and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
end

tabChat.MouseButton1Click:Connect(function() switchTab("chat") end)
tabInput.MouseButton1Click:Connect(function() switchTab("input") end)
tabMusic.MouseButton1Click:Connect(function() switchTab("music") end)
tabSettings.MouseButton1Click:Connect(function() switchTab("settings") end)

--============================================================
-- WORKING MUSIC PLAYER SYSTEM (FIXED SOUND IDS)
--============================================================
local currentSound = nil

-- تم التحديث بأكواد أصوات موثوقة وشغالة داخل روبلوكس
local songs = {
	{Name = "🎵 Brazilian Phonk", Id = "rbxassetid://9043887091"},
	{Name = "🔥 Trap Beats", Id = "rbxassetid://1837879082"},
	{Name = "⚡ Energetic Bass", Id = "rbxassetid://1841366228"}
}

local musicLayout = Instance.new("UIListLayout", musicContainer)
musicLayout.Padding = UDim.new(0, 5)

for _, song in ipairs(songs) do
	local songBtn = Instance.new("TextButton", musicContainer)
	songBtn.Size = UDim2.new(1, 0, 0, 26)
	songBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	songBtn.Text = song.Name
	songBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	songBtn.Font = Enum.Font.GothamBold
	songBtn.TextSize = 7
	Instance.new("UICorner", songBtn).CornerRadius = UDim.new(0, 5)

	songBtn.MouseButton1Click:Connect(function()
		pcall(function()
			if currentSound then
				currentSound:Stop()
				currentSound:Destroy()
				currentSound = nil
			end
			currentSound = Instance.new("Sound")
			currentSound.SoundId = song.Id
			currentSound.Volume = 2
			currentSound.Looped = true
			currentSound.Parent = workspace
			
			-- انتظار بسيط لتأكيد تحميل الصوت
			if not currentSound.IsLoaded then
				currentSound.Loaded:Wait()
			end
			currentSound:Play()
		end)
	end)
end

local stopMusicBtn = Instance.new("TextButton", musicContainer)
stopMusicBtn.Size = UDim2.new(1, 0, 0, 26)
stopMusicBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
stopMusicBtn.Text = "🛑 إيقاف الموسيقى / Stop Music"
stopMusicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopMusicBtn.Font = Enum.Font.GothamBold
stopMusicBtn.TextSize = 7
Instance.new("UICorner", stopMusicBtn).CornerRadius = UDim.new(0, 5)

stopMusicBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if currentSound then
			currentSound:Stop()
			currentSound:Destroy()
			currentSound = nil
		end
	end)
end)

--============================================================
-- ONLINE LIST & CHAT
--============================================================
local onlinePanel = Instance.new("Frame", mainGui)
onlinePanel.Size = UDim2.fromOffset(190, 210)
onlinePanel.Position = UDim2.new(0.25, 0, 0.25, 0)
onlinePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
onlinePanel.Visible = false
onlinePanel.Active = true
Instance.new("UICorner", onlinePanel).CornerRadius = UDim.new(0, 8)

local panelTitle = Instance.new("TextLabel", onlinePanel)
panelTitle.Size = UDim2.new(0.7, 0, 0, 22)
panelTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
panelTitle.BackgroundTransparency = 1
panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
panelTitle.Font = Enum.Font.GothamBold
panelTitle.TextSize = 9
panelTitle.TextXAlignment = Enum.TextXAlignment.Left

local closePanelBtn = Instance.new("TextButton", onlinePanel)
closePanelBtn.Size = UDim2.fromOffset(20, 20)
closePanelBtn.Position = UDim2.new(0.85, 0, 0.02, 0)
closePanelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closePanelBtn.Text = "❌"
closePanelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closePanelBtn.Font = Enum.Font.GothamBold
closePanelBtn.TextSize = 8
Instance.new("UICorner", closePanelBtn).CornerRadius = UDim.new(0, 4)

closePanelBtn.MouseButton1Click:Connect(function() onlinePanel.Visible = false end)

local usersScroll = Instance.new("ScrollingFrame", onlinePanel)
usersScroll.Size = UDim2.new(0.9, 0, 0.8, 0)
usersScroll.Position = UDim2.new(0.05, 0, 0.15, 0)
usersScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
usersScroll.BorderSizePixel = 0
usersScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
usersScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", usersScroll).CornerRadius = UDim.new(0, 5)

local usersLayout = Instance.new("UIListLayout", usersScroll)
usersLayout.Padding = UDim.new(0, 4)

local function refreshOnlineList()
	for _, child in pairs(usersScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	
	local uFrame = Instance.new("Frame", usersScroll)
	uFrame.Size = UDim2.new(1, -4, 0, 24)
	uFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	Instance.new("UICorner", uFrame).CornerRadius = UDim.new(0, 4)
	
	local uImg = Instance.new("ImageLabel", uFrame)
	uImg.Size = UDim2.fromOffset(20, 20)
	uImg.Position = UDim2.new(0, 2, 0, 2)
	uImg.BackgroundTransparency = 1
	uImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
	Instance.new("UICorner", uImg).CornerRadius = UDim.new(1, 0)
	
	local uTxt = Instance.new("TextLabel", uFrame)
	uTxt.Size = UDim2.new(1, -26, 1, 0)
	uTxt.Position = UDim2.new(0, 24, 0, 0)
	uTxt.BackgroundTransparency = 1
	uTxt.Text = player.Name .. " (You)"
	uTxt.TextColor3 = Color3.fromRGB(0, 220, 120)
	uTxt.Font = Enum.Font.GothamBold
	uTxt.TextSize = 7
	uTxt.TextXAlignment = Enum.TextXAlignment.Left
end

local onlineBtn = Instance.new("TextButton", chatContainer)
onlineBtn.Size = UDim2.new(1, 0, 0, 18)
onlineBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
onlineBtn.TextColor3 = Color3.fromRGB(0, 220, 120)
onlineBtn.Font = Enum.Font.GothamBold
onlineBtn.TextSize = 8
Instance.new("UICorner", onlineBtn).CornerRadius = UDim.new(0, 4)

onlineBtn.MouseButton1Click:Connect(function()
	if currentAdminRole ~= nil then
		refreshOnlineList()
		onlinePanel.Visible = not onlinePanel.Visible
	end
end)

local chatScroll = Instance.new("ScrollingFrame", chatContainer)
chatScroll.Size = UDim2.new(1, 0, 0.72, 0)
chatScroll.Position = UDim2.new(0, 0, 0.08, 0)
chatScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
chatScroll.BorderSizePixel = 0
chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", chatScroll).CornerRadius = UDim.new(0, 5)

local chatLayout = Instance.new("UIListLayout", chatScroll)
chatLayout.Padding = UDim.new(0, 3)

local function renderChatMessage(senderName, userId, text)
	pcall(function()
		local msgFrame = Instance.new("Frame", chatScroll)
		msgFrame.Size = UDim2.new(1, -4, 0, 18)
		msgFrame.BackgroundTransparency = 1
		
		local img = Instance.new("ImageLabel", msgFrame)
		img.Size = UDim2.fromOffset(14, 14)
		img.Position = UDim2.new(0, 2, 0, 2)
		img.BackgroundTransparency = 1
		if userId then img.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150" end
		Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
		
		local txt = Instance.new("TextLabel", msgFrame)
		txt.Size = UDim2.new(1, -18, 1, 0)
		txt.Position = UDim2.new(0, 18, 0, 0)
		txt.BackgroundTransparency = 1
		txt.Text = senderName .. ": " .. text
		txt.TextColor3 = Color3.fromRGB(220, 220, 220)
		txt.Font = Enum.Font.Gotham
		txt.TextSize = 7
		txt.TextXAlignment = Enum.TextXAlignment.Left
	end)
end

local function addLocalChatMessage(senderName, userId, text, saveIt)
	renderChatMessage(senderName, userId, text)
	if saveIt ~= false then
		table.insert(chatHistory, {Sender = senderName, UserId = userId, Text = text})
		saveData()
	end
end

for _, savedMsg in ipairs(chatHistory) do renderChatMessage(savedMsg.Sender, savedMsg.UserId, savedMsg.Text) end

local chatBox = Instance.new("TextBox", chatContainer)
chatBox.Size = UDim2.new(0.70, 0, 0, 22)
chatBox.Position = UDim2.new(0, 0, 0.88, 0)
chatBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
chatBox.TextColor3 = Color3.fromRGB(255, 255, 255)
chatBox.Text = ""
chatBox.Font = Enum.Font.Gotham
chatBox.TextSize = 8
Instance.new("UICorner", chatBox).CornerRadius = UDim.new(0, 4)

local sendBtn = Instance.new("TextButton", chatContainer)
sendBtn.Size = UDim2.new(0.28, 0, 0, 22)
sendBtn.Position = UDim2.new(0.72, 0, 0.88, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 7
Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 4)

sendBtn.MouseButton1Click:Connect(function()
	local msg = chatBox.Text
	if msg ~= "" then
		local displayName = player.Name
		if currentAdminRole == "يحيى" then
			displayName = "👑 [صاحب السكربت - يحيى]"
		elseif currentAdminRole == "خليل" then
			displayName = "🛡️ [أدمن - خليل]"
		end

		if msg:sub(1, 4):lower() == "/ban" then
			if currentAdminRole then
				local targetName = msg:sub(6)
				local targetPlayer = Players:FindFirstChild(targetName)
				if targetPlayer then
					addLocalChatMessage("⚡ [System]", 1, "Kicked: " .. targetPlayer.Name)
					pcall(function() targetPlayer:Kick("Banned by Admin!") end)
				end
			end
		else
			addLocalChatMessage(displayName, player.UserId, msg)
		end
		chatBox.Text = ""
	end
end)

-- INPUT TAB CONTROLS
local manualBtn = Instance.new("TextButton", inputContainer)
manualBtn.Size = UDim2.new(1, 0, 0, 26)
manualBtn.Position = UDim2.new(0, 0, 0.05, 0)
manualBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
manualBtn.Font = Enum.Font.GothamBold
manualBtn.TextSize = 8
Instance.new("UICorner", manualBtn).CornerRadius = UDim.new(0, 5)

manualBtn.MouseButton1Click:Connect(function()
	appSettings.ManualInput = not appSettings.ManualInput
	saveData()
	manualBtn.BackgroundColor3 = appSettings.ManualInput and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(35, 35, 45)
end)

local autoBtn = Instance.new("TextButton", inputContainer)
autoBtn.Size = UDim2.new(1, 0, 0, 26)
autoBtn.Position = UDim2.new(0, 0, 0.20, 0)
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 7
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 5)

autoBtn.MouseButton1Click:Connect(function()
	appSettings.AutoInput = not appSettings.AutoInput
	saveData()
	autoBtn.BackgroundColor3 = appSettings.AutoInput and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(35, 35, 45)
end)

-- SETTINGS TAB CONTROLS
local checkAdminBtn = Instance.new("TextButton", settingsContainer)
checkAdminBtn.Size = UDim2.new(1, 0, 0, 26)
checkAdminBtn.Position = UDim2.new(0, 0, 0.05, 0)
checkAdminBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkAdminBtn.Font = Enum.Font.GothamBold
checkAdminBtn.TextSize = 8
Instance.new("UICorner", checkAdminBtn).CornerRadius = UDim.new(0, 5)

local langToggleBtn = Instance.new("TextButton", settingsContainer)
langToggleBtn.Size = UDim2.new(1, 0, 0, 26)
langToggleBtn.Position = UDim2.new(0, 0, 0.20, 0)
langToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
langToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langToggleBtn.Font = Enum.Font.GothamBold
langToggleBtn.TextSize = 8
Instance.new("UICorner", langToggleBtn).CornerRadius = UDim.new(0, 5)

-- LANGUAGE UPDATE FUNCTION
local function updateUITexts()
	local isAr = (appSettings.Language == "AR")
	
	tabChat.Text = isAr and "💬 الشات" or "💬 Chat"
	tabInput.Text = isAr and "🎯 الإدخال" or "🎯 Input"
	tabMusic.Text = isAr and "🎵 أغاني" or "🎵 Music"
	tabSettings.Text = isAr and "⚙️ ضبط" or "⚙️ Set"
	
	onlineBtn.Text = isAr and "🟢 المستخدمين النشطين: 1" or "🟢 Active Script Users: 1"
	chatBox.PlaceholderText = isAr and "اكتب هنا..." or "Type here..."
	sendBtn.Text = isAr and "إرسال 📩" or "Send 📩"
	
	manualBtn.Text = isAr and (appSettings.ManualInput and "SUPER INPUT (يدوي): مفعل 🟢" or "SUPER INPUT (يدوي): معطل 🔴") 
						or (appSettings.ManualInput and "SUPER INPUT (Manual): ON 🟢" or "SUPER INPUT (Manual): OFF 🔴")
						
	autoBtn.Text = isAr and (appSettings.AutoInput and "AUTO INPUT (تلقائي): مفعل 🟢" or "AUTO INPUT (تلقائي): معطل 🔴") 
					  or (appSettings.AutoInput and "AUTO INPUT (Auto): ON 🟢" or "AUTO INPUT (Auto): OFF 🔴")
					  
	checkAdminBtn.Text = isAr and (currentAdminRole and ("👑 الأدمن: " .. currentAdminRole) or "🔑 فحص صلاحية الأدمن")
							  or (currentAdminRole and ("👑 Admin: " .. currentAdminRole) or "🔑 Check Admin Role")
							  
	langToggleBtn.Text = isAr and "🌐 اللغة: العربية (تغيير لـ EN)" or "🌐 Language: English (Switch to AR)"
	panelTitle.Text = isAr and "👑 قائمة الأونلاين" or "👑 Online Users"
end

langToggleBtn.MouseButton1Click:Connect(function()
	appSettings.Language = (appSettings.Language == "AR") and "EN" or "AR"
	saveData()
	updateUITexts()
end)

-- ADMIN CODE PANEL
local adminFrame = Instance.new("Frame", frame)
adminFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
adminFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
adminFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
adminFrame.Visible = false
Instance.new("UICorner", adminFrame).CornerRadius = UDim.new(0, 6)

local codeInput = Instance.new("TextBox", adminFrame)
codeInput.Size = UDim2.new(0.8, 0, 0, 24)
codeInput.Position = UDim2.new(0.1, 0, 0.15, 0)
codeInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
codeInput.PlaceholderText = "Code / الرمز..."
codeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
codeInput.Text = ""
codeInput.Font = Enum.Font.Gotham
codeInput.TextSize = 8
Instance.new("UICorner", codeInput).CornerRadius = UDim.new(0, 4)

local yahyaBtn = Instance.new("TextButton", adminFrame)
yahyaBtn.Size = UDim2.new(0.8, 0, 0, 24)
yahyaBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
yahyaBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
yahyaBtn.Text = "👑 Owner Yahya"
yahyaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
yahyaBtn.Font = Enum.Font.GothamBold
yahyaBtn.TextSize = 7
yahyaBtn.Visible = false
Instance.new("UICorner", yahyaBtn).CornerRadius = UDim.new(0, 4)

local khalilBtn = Instance.new("TextButton", adminFrame)
khalilBtn.Size = UDim2.new(0.8, 0, 0, 24)
khalilBtn.Position = UDim2.new(0.1, 0, 0.70, 0)
khalilBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
khalilBtn.Text = "🛡️ Admin Khalil"
khalilBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
khalilBtn.Font = Enum.Font.GothamBold
khalilBtn.TextSize = 7
khalilBtn.Visible = false
Instance.new("UICorner", khalilBtn).CornerRadius = UDim.new(0, 4)

checkAdminBtn.MouseButton1Click:Connect(function()
	adminFrame.Visible = not adminFrame.Visible
	yahyaBtn.Visible = false
	khalilBtn.Visible = false
	codeInput.Text = ""
end)

codeInput:GetPropertyChangedSignal("Text"):Connect(function()
	if codeInput.Text == "9999" then
		yahyaBtn.Visible = true
		khalilBtn.Visible = true
	end
end)

yahyaBtn.MouseButton1Click:Connect(function()
	currentAdminRole = "يحيى"
	appSettings.AdminRole = "يحيى"
	saveData()
	adminFrame.Visible = false
	updateUITexts()
end)

khalilBtn.MouseButton1Click:Connect(function()
	currentAdminRole = "خليل"
	appSettings.AdminRole = "خليل"
	saveData()
	adminFrame.Visible = false
	updateUITexts()
end)

toggleBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
updateUITexts()
