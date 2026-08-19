--============================================================
-- VOID HUB - OPTIMIZED EDITION (CHAT TOGGLE + ADVANCED ESP)
--============================================================

-- 1. تشغيل السكريبت الخاص بك فوراً عند الفتح
task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/28bc742e3a8f491e8155a5c4327fd4dd.lua"))()
	end)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- AUTO SAVE & CONFIG SYSTEM
--============================================================
local SETTINGS_FILE = "VoidHub_Settings.json"
local CHAT_FILE = "VoidHub_ChatHistory.json"

local appSettings = {
	NotificationsEnabled = false,
	ManualInput = false,
	AutoInput = false,
	AdminRole = nil,
	Language = "AR",
	ChatEnabled = true -- خيار التحكم في الشات
}

local chatHistory = {}

local function loadData()
	pcall(function()
		if type(readfile) == "function" and type(isfile) == "function" then
			if isfile(SETTINGS_FILE) then
				local sData = HttpService:JSONDecode(readfile(SETTINGS_FILE))
				if type(sData) == "table" then
					for k, v in pairs(sData) do appSettings[k] = v end
				end
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

--============================================================
-- ANTI-RUBBERBAND & PING STABILIZER
--============================================================
RunService.Heartbeat:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		if hrp.Velocity.Magnitude > 250 then
			hrp.Velocity = Vector3.zero
		end
	end
end)

RunService.Stepped:Connect(function()
	if appSettings.ManualInput and player.Character then
		pcall(function()
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.RotVelocity = Vector3.zero
			end
		end)
	end
end)

--============================================================
-- LIGHTWEIGHT & ACCURATE HACKER DETECTOR (كاشف الهاكر المطور)
--============================================================
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
		bgui.Size = UDim2.fromOffset(120, 30)
		bgui.StudsOffset = Vector3.new(0, 2.8, 0)
		bgui.AlwaysOnTop = true
		bgui.Parent = head

		local tagLabel = Instance.new("TextLabel", bgui)
		tagLabel.Size = UDim2.new(1, 0, 1, 0)
		tagLabel.BackgroundTransparency = 1
		tagLabel.Text = "🟢 NO HACKER"
		tagLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
		tagLabel.Font = Enum.Font.GothamBold
		tagLabel.TextSize = 11
		tagLabel.TextStrokeTransparency = 0.2

		-- فحص دقيق وخفيف جدًا لا يستهلك الرام أو المعالج
		task.spawn(function()
			while char and char.Parent and head and head.Parent do
				task.wait(0.8) -- فحص كل 0.8 ثانية لدقة عالية بدون تقطيع
				local hum = char:FindFirstChildOfClass("Humanoid")
				local hrp = char:FindFirstChild("HumanoidRootPart")

				if hum and hrp then
					local flatVel = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
					local verticalVel = math.abs(hrp.Velocity.Y)

					-- اكتشاف سرعة الحركة الفائقة أو الطيران/الارتفاع الخيالي
					if flatVel > 42 or (verticalVel > 60 and hum:GetState() ~= Enum.HumanoidStateType.Freefall) then
						tagLabel.Text = "🚨 HACKER 🚨"
						tagLabel.TextColor3 = Color3.fromRGB(255, 30, 30)
					else
						tagLabel.Text = "🟢 NO HACKER"
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
-- MAIN GUI CREATION
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

-- UI DRAGGING LOGIC
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

-- TABS BAR
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

-- TAB CONTAINERS
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
	
	tabChat.TextColor3 = (tab == "chat") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
	tabInput.TextColor3 = (tab == "input") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
	tabMusic.TextColor3 = (tab == "music") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
	tabSettings.TextColor3 = (tab == "settings") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
end

tabChat.MouseButton1Click:Connect(function() switchTab("chat") end)
tabInput.MouseButton1Click:Connect(function() switchTab("input") end)
tabMusic.MouseButton1Click:Connect(function() switchTab("music") end)
tabSettings.MouseButton1Click:Connect(function() switchTab("settings") end)

--============================================================
-- MUSIC PLAYER TAB (CATBOX MP3 LINK)
--============================================================
local customSongUrl = "https://files.catbox.moe/jmqv9y.mp3"
local currentSound = nil

local musicLayout = Instance.new("UIListLayout", musicContainer)
musicLayout.Padding = UDim.new(0, 8)

local playMusicBtn = Instance.new("TextButton", musicContainer)
playMusicBtn.Size = UDim2.new(1, 0, 0, 32)
playMusicBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
playMusicBtn.Text = "▶️ تشغيل الأغنية الخاصة"
playMusicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playMusicBtn.Font = Enum.Font.GothamBold
playMusicBtn.TextSize = 8
Instance.new("UICorner", playMusicBtn).CornerRadius = UDim.new(0, 6)

local stopMusicBtn = Instance.new("TextButton", musicContainer)
stopMusicBtn.Size = UDim2.new(1, 0, 0, 32)
stopMusicBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
stopMusicBtn.Text = "🛑 إيقاف الأغنية"
stopMusicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopMusicBtn.Font = Enum.Font.GothamBold
stopMusicBtn.TextSize = 8
Instance.new("UICorner", stopMusicBtn).CornerRadius = UDim.new(0, 6)

playMusicBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if currentSound then
			currentSound:Stop()
			currentSound:Destroy()
			currentSound = nil
		end
		
		local soundAssetId = customSongUrl
		if type(getcustomasset) == "function" and type(writefile) == "function" then
			local filename = "VoidCustomSong.mp3"
			if not isfile or not isfile(filename) then
				local audioData = game:HttpGet(customSongUrl)
				writefile(filename, audioData)
			end
			soundAssetId = getcustomasset(filename)
		end

		currentSound = Instance.new("Sound")
		currentSound.SoundId = soundAssetId
		currentSound.Volume = 2
		currentSound.Looped = true
		currentSound.Parent = workspace
		currentSound:Play()
	end)
end)

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
-- CHAT TAB & CONTROLS
--============================================================
local chatScroll = Instance.new("ScrollingFrame", chatContainer)
chatScroll.Size = UDim2.new(1, 0, 0.8, 0)
chatScroll.Position = UDim2.new(0, 0, 0.05, 0)
chatScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
chatScroll.BorderSizePixel = 0
chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", chatScroll).CornerRadius = UDim.new(0, 5)

local chatLayout = Instance.new("UIListLayout", chatScroll)
chatLayout.Padding = UDim.new(0, 3)

local function renderChatMessage(senderName, userId, text)
	if not appSettings.ChatEnabled then return end -- معطل إذا كان الشات مغلقًا
	pcall(function()
		local msgFrame = Instance.new("Frame", chatScroll)
		msgFrame.Size = UDim2.new(1, -4, 0, 18)
		msgFrame.BackgroundTransparency = 1
		
		local txt = Instance.new("TextLabel", msgFrame)
		txt.Size = UDim2.new(1, 0, 1, 0)
		txt.BackgroundTransparency = 1
		txt.Text = senderName .. ": " .. text
		txt.TextColor3 = Color3.fromRGB(220, 220, 220)
		txt.Font = Enum.Font.Gotham
		txt.TextSize = 7
		txt.TextXAlignment = Enum.TextXAlignment.Left
	end)
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
	if not appSettings.ChatEnabled then return end
	local msg = chatBox.Text
	if msg ~= "" then
		renderChatMessage(player.Name, player.UserId, msg)
		table.insert(chatHistory, {Sender = player.Name, UserId = player.UserId, Text = msg})
		saveData()
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

-- SETTINGS TAB CONTROLS
local settingsLayout = Instance.new("UIListLayout", settingsContainer)
settingsLayout.Padding = UDim.new(0, 6)

local langToggleBtn = Instance.new("TextButton", settingsContainer)
langToggleBtn.Size = UDim2.new(1, 0, 0, 26)
langToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
langToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langToggleBtn.Font = Enum.Font.GothamBold
langToggleBtn.TextSize = 8
Instance.new("UICorner", langToggleBtn).CornerRadius = UDim.new(0, 5)

local chatToggleBtn = Instance.new("TextButton", settingsContainer)
chatToggleBtn.Size = UDim2.new(1, 0, 0, 26)
chatToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chatToggleBtn.Font = Enum.Font.GothamBold
chatToggleBtn.TextSize = 8
Instance.new("UICorner", chatToggleBtn).CornerRadius = UDim.new(0, 5)

local function updateUITexts()
	local isAr = (appSettings.Language == "AR")
	tabChat.Text = isAr and "💬 الشات" or "💬 Chat"
	tabInput.Text = isAr and "🎯 الإدخال" or "🎯 Input"
	tabMusic.Text = isAr and "🎵 أغاني" or "🎵 Music"
	tabSettings.Text = isAr and "⚙️ ضبط" or "⚙️ Set"
	chatBox.PlaceholderText = isAr and "اكتب هنا..." or "Type here..."
	sendBtn.Text = isAr and "إرسال 📩" or "Send 📩"
	manualBtn.Text = isAr and (appSettings.ManualInput and "SUPER INPUT: مفعل 🟢" or "SUPER INPUT: معطل 🔴") 
						or (appSettings.ManualInput and "SUPER INPUT: ON 🟢" or "SUPER INPUT: OFF 🔴")
	langToggleBtn.Text = isAr and "🌐 اللغة: العربية" or "🌐 Language: English"
	
	-- تحديث زرار الشات في السيتنج
	chatToggleBtn.Text = isAr and (appSettings.ChatEnabled and "💬 الشات: مفعل 🟢" or "💬 الشات: معطل 🔴")
							or (appSettings.ChatEnabled and "💬 Chat: Enabled 🟢" or "💬 Chat: Disabled 🔴")
	chatToggleBtn.BackgroundColor3 = appSettings.ChatEnabled and Color3.fromRGB(0, 170, 90) or Color3.fromRGB(180, 40, 40)
	chatContainer.Visible = appSettings.ChatEnabled and (chatContainer.Visible) or false
end

langToggleBtn.MouseButton1Click:Connect(function()
	appSettings.Language = (appSettings.Language == "AR") and "EN" or "AR"
	saveData()
	updateUITexts()
end)

chatToggleBtn.MouseButton1Click:Connect(function()
	appSettings.ChatEnabled = not appSettings.ChatEnabled
	saveData()
	updateUITexts()
end)

toggleBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
updateUITexts()
switchTab("chat")
