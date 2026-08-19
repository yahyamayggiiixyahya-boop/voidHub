-- ============================================================
-- VOID HUB - ULTIMATE CUSTOMIZABLE EDITION (By Yahia)
-- ============================================================
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local ADMIN_CODE = "55"
local complaintsLog = {}
local savedSettings = { chatEnabled = true, customFPS = 60, boostActive = false }

-- نظام حفظ واسترجاع الإعدادات
local saveFileName = "VoidHub_Settings_Yahia.json"
local function saveUserData()
    pcall(function()
        if writefile then
            writefile(saveFileName, HttpService:JSONEncode(savedSettings))
        end
    end)
end

local function loadUserData()
    pcall(function()
        if readfile and isfile and isfile(saveFileName) then
            local data = HttpService:JSONDecode(readfile(saveFileName))
            if data then savedSettings = data end
        end
    end)
end
loadUserData()

-- 1. انترو Void Hub مع زرار Skip
task.spawn(function()
    pcall(function()
        local screenGui = Instance.new("ScreenGui", LP.PlayerGui)
        screenGui.Name = "VoidHubIntro"
        screenGui.IgnoreGuiInset = true

        local frame = Instance.new("Frame", screenGui)
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, 0, 0, 100)
        title.AnchorPoint = Vector2.new(0.5, 0.5)
        title.Position = UDim2.new(0.5, 0, 0.45, 0)
        title.BackgroundTransparency = 1
        title.Text = "VOID HUB"
        title.TextColor3 = Color3.fromRGB(0, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 75

        local skipBtn = Instance.new("TextButton", frame)
        skipBtn.Size = UDim2.new(0, 120, 0, 45)
        skipBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        skipBtn.Position = UDim2.new(0.5, 0, 0.65, 0)
        skipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        skipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        skipBtn.Text = "SKIP [>>]"
        skipBtn.Font = Enum.Font.GothamBold
        skipBtn.TextSize = 14
        Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 8)

        local function closeIntro()
            screenGui:Destroy()
        end

        skipBtn.MouseButton1Click:Connect(closeIntro)
        task.delay(4, closeIntro)
    end)
end)

task.wait(4.2)

-- تشغيل السكريبت الخارجي الأساسي
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/28bc742e3a8f491e8155a5c4327fd4dd.lua"))()
    end)
end)

-- 2. واجهة التحكم الرئيسية
task.spawn(function()
    pcall(function()
        local guiName = "VoidHubCustomMenu"
        if LP.PlayerGui:FindFirstChild(guiName) then
            LP.PlayerGui[guiName]:Destroy()
        end

        local screenGui = Instance.new("ScreenGui", LP.PlayerGui)
        screenGui.Name = guiName
        screenGui.IgnoreGuiInset = true
        screenGui.ResetOnSpawn = false

        -- زر الفتح والإغلاق
        local toggleBtn = Instance.new("TextButton", screenGui)
        toggleBtn.Size = UDim2.new(0, 110, 0, 38)
        toggleBtn.Position = UDim2.new(0, 20, 0, 20)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.Text = "Void Menu"
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 13
        toggleBtn.ZIndex = 5
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

        -- الإطار الرئيسي الشفاف
        local mainFrame = Instance.new("Frame", screenGui)
        mainFrame.Size = UDim2.new(0, 320, 0, 360)
        mainFrame.Position = UDim2.new(0, 20, 0, 70)
        mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        mainFrame.BackgroundTransparency = 0.25
        mainFrame.BorderSizePixel = 0
        mainFrame.Visible = false
        mainFrame.ZIndex = 2
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke", mainFrame)
        stroke.Color = Color3.fromRGB(0, 255, 255)
        stroke.Thickness = 1.5

        toggleBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
        end)

        -- العنوان
        local titleLabel = Instance.new("TextLabel", mainFrame)
        titleLabel.Size = UDim2.new(1, 0, 0, 35)
        titleLabel.BackgroundColor3 = Color3.fromRGB(0, 90, 140)
        titleLabel.BackgroundTransparency = 0.3
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Text = "VOID HUB - SYSTEM"
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.ZIndex = 3
        Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 12)

        -- التبويبات
        local function createTab(name, xPos)
            local b = Instance.new("TextButton", mainFrame)
            b.Size = UDim2.new(0, 95, 0, 28)
            b.Position = UDim2.new(0, xPos, 0, 42)
            b.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Text = name
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 11
            b.ZIndex = 3
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            return b
        end

        local tabChat = createTab("💬 الشات والشكاوى", 10)
        local tabBoost = createTab("🚀 بوست والفريمات", 112)
        local tabSettings = createTab("⚙️ إعدادات الأدمن", 214)

        local function createPage()
            local p = Instance.new("Frame", mainFrame)
            p.Size = UDim2.new(1, -20, 1, -85)
            p.Position = UDim2.new(0, 10, 0, 75)
            p.BackgroundTransparency = 1
            p.Visible = false
            p.ZIndex = 3
            return p
        end

        local pageChat = createPage()
        local pageBoost = createPage()
        local pageSettings = createPage()

        pageChat.Visible = true

        tabChat.MouseButton1Click:Connect(function() pageChat.Visible = true; pageBoost.Visible = false; pageSettings.Visible = false end)
        tabBoost.MouseButton1Click:Connect(function() pageChat.Visible = false; pageBoost.Visible = true; pageSettings.Visible = false end)
        tabSettings.MouseButton1Click:Connect(function() pageChat.Visible = false; pageBoost.Visible = false; pageSettings.Visible = true end)

        -- ========================================================
        -- 1. الشات والذكاء الاصطناعي (مع إمكانية القفل الكامل)
        -- ========================================================
        local chatContainer = Instance.new("Frame", pageChat)
        chatContainer.Size = UDim2.new(1, 0, 1, 0)
        chatContainer.BackgroundTransparency = 1
        chatContainer.ZIndex = 4

        local chatLog = Instance.new("TextLabel", chatContainer)
        chatLog.Size = UDim2.new(1, 0, 0, 175)
        chatLog.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
        chatLog.BackgroundTransparency = 0.4
        chatLog.TextColor3 = Color3.fromRGB(200, 240, 255)
        chatLog.Text = "🤖 بوت فوايد: أهلاً يا يحيى! اكتب سؤالك أو شكوتك هنا."
        chatLog.Font = Enum.Font.Gotham
        chatLog.TextSize = 11
        chatLog.TextWrapped = true
        chatLog.TextXAlignment = Enum.TextXAlignment.Left
        chatLog.TextYAlignment = Enum.TextYAlignment.Top
        chatLog.ZIndex = 4
        Instance.new("UICorner", chatLog).CornerRadius = UDim.new(0, 6)

        local chatInput = Instance.new("TextBox", chatContainer)
        chatInput.Size = UDim2.new(1, -70, 0, 35)
        chatInput.Position = UDim2.new(0, 0, 0, 185)
        chatInput.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
        chatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        chatInput.PlaceholderText = "اكتب رسالتك هنا..."
        chatInput.Text = ""
        chatInput.Font = Enum.Font.Gotham
        chatInput.TextSize = 11
        chatInput.ZIndex = 5
        Instance.new("UICorner", chatInput).CornerRadius = UDim.new(0, 6)

        local sendBtn = Instance.new("TextButton", chatContainer)
        sendBtn.Size = UDim2.new(0, 60, 0, 35)
        sendBtn.Position = UDim2.new(1, -60, 0, 185)
        sendBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
        sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sendBtn.Text = "إرسال"
        sendBtn.Font = Enum.Font.GothamBold
        sendBtn.TextSize = 11
        sendBtn.ZIndex = 5
        Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)

        sendBtn.MouseButton1Click:Connect(function()
            if not savedSettings.chatEnabled then return end
            local txt = chatInput.Text
            if txt == "" then return end
            
            table.insert(complaintsLog, LP.Name .. ": " .. txt)
            saveUserData()

            chatLog.Text = "أنت: " .. txt .. "\n\n🤖 البوت: تم استلام رسالتك وتسجيلها للأدمن بنجاح."
            chatInput.Text = ""
        end)

        -- ========================================================
        -- 2. قسم بوست الفريمات والتحكم الحر في اللوك (Custom FPS Lock)
        -- ========================================================
        local fpsTitle = Instance.new("TextLabel", pageBoost)
        fpsTitle.Size = UDim2.new(1, 0, 0, 25)
        fpsTitle.Position = UDim2.new(0, 0, 0, 5)
        fpsTitle.BackgroundTransparency = 1
        fpsTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
        fpsTitle.Text = "حدد عدد الفريمات المطلوبة (مثلاً 30, 60, 120):"
        fpsTitle.Font = Enum.Font.GothamBold
        fpsTitle.TextSize = 11
        fpsTitle.TextXAlignment = Enum.TextXAlignment.Left
        fpsTitle.ZIndex = 4

        local fpsInputBox = Instance.new("TextBox", pageBoost)
        fpsInputBox.Size = UDim2.new(1, -100, 0, 35)
        fpsInputBox.Position = UDim2.new(0, 0, 0, 35)
        fpsInputBox.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
        fpsInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        fpsInputBox.Text = tostring(savedSettings.customFPS)
        fpsInputBox.PlaceholderText = "اكتب رقم الفريمات..."
        fpsInputBox.Font = Enum.Font.GothamBold
        fpsInputBox.TextSize, fpsInputBox.ZIndex = 12, 5
        Instance.new("UICorner", fpsInputBox).CornerRadius = UDim.new(0, 6)

        local applyFpsBtn = Instance.new("TextButton", pageBoost)
        applyFpsBtn.Size = UDim2.new(0, 90, 0, 35)
        applyFpsBtn.Position = UDim2.new(1, -90, 0, 35)
        applyFpsBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
        applyFpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        applyFpsBtn.Text = "تطبيق اللوك"
        applyFpsBtn.Font = Enum.Font.GothamBold
        applyFpsBtn.TextSize, applyFpsBtn.ZIndex = 11, 5
        Instance.new("UICorner", applyFpsBtn).CornerRadius = UDim.new(0, 6)

        local skyBoostBtn = Instance.new("TextButton", pageBoost)
        skyBoostBtn.Size = UDim2.new(1, 0, 0, 40)
        skyBoostBtn.Position = UDim2.new(0, 0, 0, 85)
        skyBoostBtn.BackgroundColor3 = savedSettings.boostActive and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(20, 30, 45)
        skyBoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        skyBoostBtn.Text = savedSettings.boostActive and "إزالة السما والجرافيك الثقيل: [ON]" or "إزالة السما والجرافيك الثقيل: [OFF]"
        skyBoostBtn.Font = Enum.Font.GothamBold
        skyBoostBtn.TextSize, skyBoostBtn.ZIndex = 11, 4
        Instance.new("UICorner", skyBoostBtn).CornerRadius = UDim.new(0, 8)

        local renderConn = nil
        local function applyFPSLock(val)
            local target = tonumber(val) or 60
            savedSettings.customFPS = target
            saveUserData()
            if setfpscap then setfpscap(target) end
            
            if renderConn then renderConn:Disconnect() end
            local interval = 1 / target
            local lastT = tick()
            renderConn = RunService.RenderStepped:Connect(function()
                local now = tick()
                local diff = now - lastT
                if diff < interval then
                    task.wait(interval - diff)
                end
                lastT = tick()
            end)
        end

        applyFpsBtn.MouseButton1Click:Connect(function()
            applyFPSLock(fpsInputBox.Text)
        end)

        skyBoostBtn.MouseButton1Click:Connect(function()
            savedSettings.boostActive = not savedSettings.boostActive
            saveUserData()
            if savedSettings.boostActive then
                skyBoostBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                skyBoostBtn.Text = "إزالة السما والجرافيك الثقيل: [ON]"
                Lighting.GlobalShadows = false
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("PostEffect") then v:Destroy() end
                end
            else
                skyBoostBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
                skyBoostBtn.Text = "إزالة السما والجرافيك الثقيل: [OFF]"
                Lighting.GlobalShadows = true
            end
        end)

        -- ========================================================
        -- 3. إعدادات الأدمن (كود 55 لفتح الشكاوى وقفل الشات)
        -- ========================================================
        local adminTitle = Instance.new("TextLabel", pageSettings)
        adminTitle.Size = UDim2.new(1, 0, 0, 30)
        adminTitle.Position = UDim2.new(0, 0, 0, 5)
        adminTitle.BackgroundTransparency = 1
        adminTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
        adminTitle.Text = "كود الأدمن العام هو: [ 55 ]"
        adminTitle.Font = Enum.Font.GothamBold
        adminTitle.TextSize = 11
        adminTitle.TextXAlignment = Enum.TextXAlignment.Left
        adminTitle.ZIndex = 4

        local adminBox = Instance.new("TextBox", pageSettings)
        adminBox.Size = UDim2.new(1, 0, 0, 32)
        adminBox.Position = UDim2.new(0, 0, 0, 35)
        adminBox.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
        adminBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        adminBox.PlaceholderText = "اكتب كود 55 هنا..."
        adminBox.Text = ""
        adminBox.Font = Enum.Font.Gotham
        adminBox.TextSize = 12
        adminBox.ZIndex = 5
        Instance.new("UICorner", adminBox).CornerRadius = UDim.new(0, 6)

        -- زر قفل الشات بالكامل (يظهر فقط عند كتابة الكود الصحيح)
        local toggleChatBtn = Instance.new("TextButton", pageSettings)
        toggleChatBtn.Size = UDim2.new(1, 0, 0, 35)
        toggleChatBtn.Position = UDim2.new(0, 0, 0, 75)
        toggleChatBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        toggleChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleChatBtn.Text = savedSettings.chatEnabled and "قفل الشات من السكريبت كله: [مفتوح]" or "فتح الشات من السكريبت كله: [مقفل]"
        toggleChatBtn.Font = Enum.Font.GothamBold
        toggleChatBtn.TextSize, toggleChatBtn.Visible, toggleChatBtn.ZIndex = 11, false, 5
        Instance.new("UICorner", toggleChatBtn).CornerRadius = UDim.new(0, 6)

        toggleChatBtn.MouseButton1Click:Connect(function()
            savedSettings.chatEnabled = not savedSettings.chatEnabled
            saveUserData()
            chatContainer.Visible = savedSettings.chatEnabled
            if savedSettings.chatEnabled then
                toggleChatBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
                toggleChatBtn.Text = "قفل الشات من السكريبت كله: [مفتوح]"
            else
                toggleChatBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                toggleChatBtn.Text = "فتح الشات من السكريبت كله: [مقفل]"
            end
        end)

        local adminOutput = Instance.new("TextLabel", pageSettings)
        adminOutput.Size = UDim2.new(1, 0, 0, 100)
        adminOutput.Position = UDim2.new(0, 0, 0, 115)
        adminOutput.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
        adminOutput.BackgroundTransparency = 0.4
        adminOutput.TextColor3 = Color3.fromRGB(255, 215, 0)
        adminOutput.Text = "🔒 أدخل الكود (55) لفتح لوحة التحكم وقفل الشات."
        adminOutput.Font = Enum.Font.Gotham
        adminOutput.TextSize = 11
        adminOutput.TextWrapped = true
        adminOutput.TextXAlignment = Enum.TextXAlignment.Left
        adminOutput.TextYAlignment = Enum.TextYAlignment.Top
        adminOutput.ZIndex = 4
        Instance.new("UICorner", adminOutput).CornerRadius = UDim.new(0, 6)

        adminBox:GetPropertyChangedSignal("Text"):Connect(function()
            if adminBox.Text == ADMIN_CODE then
                toggleChatBtn.Visible = true
                if #complaintsLog > 0 then
                    adminOutput.Text = "👑 لوحة الأدمن نشطة:\n" .. table.concat(complaintsLog, "\n")
                else
                    adminOutput.Text = "👑 لوحة الأدمن نشطة: لا توجد شكاوى حتى الآن."
                end
            else
                toggleChatBtn.Visible = false
                adminOutput.Text = "❌ الكود خطأ! الكود هو (55)."
            end
        end)

        -- تطبيق الإعدادات المحفوظة عند التشغيل
        chatContainer.Visible = savedSettings.chatEnabled
        if savedSettings.customFPS then
            applyFPSLock(savedSettings.customFPS)
        end
    end)
end)
