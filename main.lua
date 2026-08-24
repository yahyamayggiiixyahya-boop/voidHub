-- MVP HUB RED EDITION | optimized visual build
local BG         = Color3.fromRGB(8, 0, 0)
local SIDEBAR_BG = Color3.fromRGB(14, 0, 0)
local CARD_BG    = Color3.fromRGB(28, 0, 0)
local CARD_HOV   = Color3.fromRGB(70, 8, 8)
local KB_BG      = Color3.fromRGB(180, 0, 0)

local WHITE      = Color3.fromRGB(255, 55, 55)
local DIM        = Color3.fromRGB(220, 70, 70)
local DIM2       = Color3.fromRGB(18, 0, 0)

local BORDER     = Color3.fromRGB(120, 10, 10)
local BORDER2    = Color3.fromRGB(180, 25, 25)
local OPTION_TRANSPARENCY = 0.42
local OPTION_HOVER_TRANSPARENCY = 0.22
local TAB_TRANSPARENCY = 0.35
local TAB_HOVER_TRANSPARENCY = 0.16
local INPUT_TRANSPARENCY = 0.24

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    env.__MVP_HIGH_PING_RUN = (env.__MVP_HIGH_PING_RUN or 0) + 1
    local thisRun = env.__MVP_HIGH_PING_RUN
    env.__MVP_INTRO_FINISHED_RUN = 0
    local shown = false

    local function getPingMilliseconds()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
            if not pingItem then
                return nil
            end

            local numericValue
            pcall(function()
                numericValue = pingItem:GetValue()
            end)
            if type(numericValue) == "number" then
                return numericValue
            end

            local valueString = pingItem:GetValueString()
            return tonumber(tostring(valueString):match("[%d%.]+"))
        end)
        return ok and tonumber(value) or nil
    end

    local function showHighPingAlert()
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")

        pcall(function()
            local old = CoreGui:FindFirstChild("MVPHighPingAlert")
            if old then old:Destroy() end
        end)
        pcall(function()
            local old = playerGui and playerGui:FindFirstChild("MVPHighPingAlert")
            if old then old:Destroy() end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "MVPHighPingAlert"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = false
        gui.DisplayOrder = 10000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local parented = pcall(function()
            gui.Parent = CoreGui
        end)
        if not parented or not gui.Parent then
            gui.Parent = playerGui
        end
        if not gui.Parent then
            gui:Destroy()
            return
        end

        local bar = Instance.new("Frame")
        bar.Name = "AlertBar"
        bar.AnchorPoint = Vector2.new(0.5, 0)
        bar.Position = UDim2.new(0.5, 0, 0, -44)
        bar.Size = UDim2.new(0, 310, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        bar.BackgroundTransparency = 0.06
        bar.BorderSizePixel = 0
        bar.ClipsDescendants = true
        bar.ZIndex = 100
        bar.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = bar

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 30, 30)
        stroke.Transparency = 0.2
        stroke.Thickness = 1
        stroke.Parent = bar

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0)),
        })
        gradient.Parent = bar

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = "high ping! Your ping is more than 150."
        label.TextColor3 = Color3.fromRGB(255, 55, 55)
        label.TextSize = 13
        label.TextStrokeColor3 = Color3.fromRGB(50, 0, 0)
        label.TextStrokeTransparency = 0.55
        label.TextWrapped = false
        label.TextScaled = false
        label.ZIndex = 102
        label.Parent = bar

        local slideIn = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 10)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        task.wait(2)

        local slideOut = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -44)}
        )
        slideOut:Play()
        slideOut.Completed:Wait()
        gui:Destroy()
    end

    while env.__MVP_HIGH_PING_RUN == thisRun and env.__MVP_INTRO_FINISHED_RUN ~= thisRun do
        task.wait(0.1)
    end

    while env.__MVP_HIGH_PING_RUN == thisRun and not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true
            showHighPingAlert()
            break
        end
        task.wait(1)
    end
end)

do
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local SoundService = game:GetService("SoundService")
    local HttpService = game:GetService("HttpService")

    local noIntroSaved = false
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile("CRYON_DUELS_V8_CONFIG.json") then
            local decoded = HttpService:JSONDecode(readfile("CRYON_DUELS_V8_CONFIG.json"))
            if type(decoded) == "table" then
                if decoded.noIntro ~= nil then
                    noIntroSaved = decoded.noIntro == true
                elseif decoded.introEnabled ~= nil then
                    noIntroSaved = decoded.introEnabled ~= true
                end
            end
        end
    end)
    local sharedEnv = (getgenv and getgenv()) or _G
    sharedEnv.__MVP_NO_INTRO_SAVED = noIntroSaved

    for _, n in ipairs({"MVPIntro", "CryonHoneypotGui", "AdaptIntro", "AdaptHoneypotGui"}) do
        pcall(function()
            local old = CoreGui:FindFirstChild(n)
            if old then old:Destroy() end
        end)
    end

    if noIntroSaved then
        -- skip intro: unblock high-ping watcher
        sharedEnv.__MVP_INTRO_FINISHED_RUN = sharedEnv.__MVP_HIGH_PING_RUN or 0
    end

    if not noIntroSaved then
        local introDone = Instance.new("BindableEvent")
        local introScreenGui = Instance.new("ScreenGui")
        introScreenGui.Name = "MVPIntro"
        introScreenGui.ResetOnSpawn = false
        introScreenGui.IgnoreGuiInset = true
        introScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        introScreenGui.DisplayOrder = 999999
        pcall(function() introScreenGui.Parent = game:GetService("CoreGui") end)
        if not introScreenGui.Parent then
            local lp = game:GetService("Players").LocalPlayer
            if lp then introScreenGui.Parent = lp:WaitForChild("PlayerGui") end
        end
        local screenGui = introScreenGui
        local introFinished = false
        local introSound
        local introLayer

        local function finishIntro()
            if introFinished then return end
            introFinished = true
            pcall(function()
                if introSound then
                    introSound:Stop()
                    introSound:Destroy()
                    introSound = nil
                end
            end)
            pcall(function()
                if introLayer then
                    introLayer:Destroy()
                    introLayer = nil
                end
            end)
            pcall(function() introDone:Fire() end)
            -- ðŸ”¥ ESTA ES LA LÃNEA CLAVE QUE FALTABA:
            local env = (getgenv and getgenv()) or _G
            env.__MVP_INTRO_FINISHED_RUN = env.__MVP_HIGH_PING_RUN
        end

        task.delay(7.0, finishIntro)

        -- Intro music: BIA - WE ON GO
        introSound = Instance.new("Sound")
        introSound.Name = "MVPIntroSound"
        introSound.Volume = 1
        introSound.Looped = false
        introSound.Parent = game:GetService("SoundService")

        local function startIntroMusic()
            if not introSound or not introSound.Parent then return end
            task.spawn(function()
                local fileName = "mvp_intro_weongo.mp3"
                local urls = {
                    "https://ia601009.us.archive.org/21/items/we-on-go/WE%20ON%20GO.mp3",
                    "https://archive.org/download/we-on-go/WE%20ON%20GO.mp3",
                }
                local assetFn = getcustomasset or getsynasset

                local function isValidMp3(data)
                    if type(data) ~= "string" or #data < 10000 then return false end
                    local h = data:sub(1, 64):lower()
                    if h:find("<html", 1, true) or h:find("<!doctype", 1, true) then return false end
                    return data:sub(1, 3) == "ID3" or data:byte(1) == 0xFF or #data > 100000
                end

                local function fetch(url)
                    local data
                    pcall(function()
                        local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
                        if type(req) == "function" then
                            local res = req({
                                Url = url,
                                Method = "GET",
                                Headers = {["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,*/*"},
                            })
                            if type(res) == "table" then
                                data = res.Body or res.body
                            end
                        end
                    end)
                    if not isValidMp3(data) then
                        pcall(function()
                            data = game:HttpGet(url, true)
                        end)
                    end
                    return isValidMp3(data) and data or nil
                end

                local assetId = nil
                pcall(function()
                    if type(isfile) == "function" and isfile(fileName) and type(assetFn) == "function" then
                        local ok, a = pcall(assetFn, fileName)
                        if ok and a then assetId = a end
                    end
                end)

                if not assetId then
                    for _, url in ipairs(urls) do
                        local data = fetch(url)
                        if data then
                            pcall(function()
                                if type(writefile) == "function" then
                                    writefile(fileName, data)
                                end
                            end)
                            if type(assetFn) == "function" then
                                local ok, a = pcall(assetFn, fileName)
                                if ok and a then
                                    assetId = a
                                    break
                                end
                            end
                        end
                    end
                end

                if not assetId then
                    warn("[MVP Intro] No se pudo cargar WE ON GO")
                    return
                end

                pcall(function()
                    introSound.SoundId = assetId
                    introSound.Volume = 1
                    introSound:Play()
                    local t0 = os.clock()
                    while not introSound.IsLoaded and os.clock() - t0 < 4 do
                        task.wait()
                    end
                    introSound.TimePosition = 0
                end)
            end)
        end
        -- Arranca la mÃºsica en cuanto se arma la intro
        startIntroMusic()

        introLayer = Instance.new("Frame")
        introLayer.Name = "MVPIntro"
        introLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introLayer.BackgroundTransparency = 1
        introLayer.BorderSizePixel = 0
        introLayer.Size = UDim2.fromScale(1, 1)
        introLayer.Position = UDim2.fromScale(0, 0)
        introLayer.ClipsDescendants = true
        introLayer.ZIndex = 1000
        introLayer.Parent = screenGui

        -- BotÃ³n OMITIR (abajo a la derecha)
        local skipBtn = Instance.new("TextButton")
        skipBtn.Name = "SkipIntroBtn"
        skipBtn.AnchorPoint = Vector2.new(1, 1)
        skipBtn.Position = UDim2.new(1, -18, 1, -18)
        skipBtn.Size = UDim2.new(0, 92, 0, 32)
        skipBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        skipBtn.BackgroundTransparency = 0.2
        skipBtn.BorderSizePixel = 0
        skipBtn.Text = "OMITIR"
        skipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        skipBtn.Font = Enum.Font.GothamBold
        skipBtn.TextSize = 13
        skipBtn.ZIndex = 1100
        skipBtn.AutoButtonColor = false
        skipBtn.Parent = introLayer
        local skipCorner = Instance.new("UICorner")
        skipCorner.CornerRadius = UDim.new(0, 8)
        skipCorner.Parent = skipBtn
        local skipStroke = Instance.new("UIStroke")
        skipStroke.Color = Color3.fromRGB(255, 40, 40)
        skipStroke.Thickness = 1.2
        skipStroke.Transparency = 0.35
        skipStroke.Parent = skipBtn
        skipBtn.MouseEnter:Connect(function()
            TweenService:Create(skipBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.08,
                BackgroundColor3 = Color3.fromRGB(160, 0, 0)
            }):Play()
        end)
        skipBtn.MouseLeave:Connect(function()
            TweenService:Create(skipBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.25,
                BackgroundColor3 = Color3.fromRGB(120, 0, 0)
            }):Play()
        end)
        skipBtn.MouseButton1Click:Connect(function()
            finishIntro()
        end)

        local introImage = Instance.new("ImageLabel")
        introImage.Name = "IntroBackground"
        introImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introImage.BackgroundTransparency = 1
        introImage.BorderSizePixel = 0
        introImage.AnchorPoint = Vector2.new(0.5, 0.5)
        introImage.Position = UDim2.fromScale(0.5, 0.5)
        introImage.Size = UDim2.fromScale(1.08, 1.08)
        introImage.Image = "rbxassetid://117085976067902"
        introImage.ScaleType = Enum.ScaleType.Crop
        introImage.ImageColor3 = Color3.fromRGB(160, 160, 160)
        introImage.ImageTransparency = 0.58
        introImage.ZIndex = 1001
        introImage.Parent = introLayer

        local introShade = Instance.new("Frame")
        introShade.Name = "DarkShade"
        introShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introShade.BackgroundTransparency = 0.55
        introShade.BorderSizePixel = 0
        introShade.Size = UDim2.fromScale(1, 1)
        introShade.ZIndex = 1002
        introShade.Parent = introLayer

        local introVignette = Instance.new("ImageLabel")
        introVignette.Name = "Vignette"
        introVignette.BackgroundTransparency = 1
        introVignette.Size = UDim2.fromScale(1, 1)
        introVignette.Image = "rbxassetid://4576475446"
        introVignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
        introVignette.ImageTransparency = 0.72
        introVignette.ScaleType = Enum.ScaleType.Stretch
        introVignette.ZIndex = 1003
        introVignette.Parent = introLayer

        local scanlineHolder = Instance.new("Frame")
        scanlineHolder.Name = "Scanlines"
        scanlineHolder.BackgroundTransparency = 1
        scanlineHolder.Size = UDim2.fromScale(1, 1)
        scanlineHolder.ZIndex = 1004
        scanlineHolder.Parent = introLayer
        for y = 0, 1, 0.085 do
            local line = Instance.new("Frame")
            line.BorderSizePixel = 0
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.99
            line.Position = UDim2.fromScale(0, y)
            line.Size = UDim2.new(1, 0, 0, 1)
            line.ZIndex = 1004
            line.Parent = scanlineHolder
        end

        local introContent = Instance.new("Frame")
        introContent.Name = "IntroContent"
        introContent.AnchorPoint = Vector2.new(0.5, 0.5)
        introContent.BackgroundTransparency = 1
        introContent.Position = UDim2.fromScale(0.5, 0.5)
        introContent.Size = UDim2.new(0.96, 0, 0, 180)
        introContent.ZIndex = 1005
        introContent.Parent = introLayer

        local function makeIntroText(name, color, transparency, zindex)
            local label = Instance.new("TextLabel")
            label.Name = name
            label.BackgroundTransparency = 1
            label.AnchorPoint = Vector2.new(0.5, 0.5)
            label.Position = UDim2.fromScale(0.5, 0.5)
            label.Size = UDim2.new(1, -12, 0, 110)
            label.Font = Enum.Font.GothamBlack
            label.Text = "â†»  MVP  â†»"
            label.TextColor3 = color
            label.TextSize = 58
            label.TextTransparency = transparency
            label.TextStrokeColor3 = Color3.fromRGB(45, 0, 0)
            label.TextStrokeTransparency = 0.18
            label.ZIndex = zindex
            label.Parent = introContent
            return label
        end

        local introGlitchDark = makeIntroText("GlitchDark", Color3.fromRGB(20, 20, 20), 1, 1005)
        local introGlitchBright = makeIntroText("GlitchBright", Color3.fromRGB(230, 230, 230), 1, 1006)
        local introTitleGlow = makeIntroText("IntroTitleGlow", Color3.fromRGB(0, 0, 0), 1, 1007)
        introTitleGlow.TextSize = 64
        introTitleGlow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        introTitleGlow.TextStrokeTransparency = 0.35

        local introTitle = makeIntroText("IntroTitle", Color3.fromRGB(255, 255, 255), 1, 1008)
        local introTitleGradient = Instance.new("UIGradient")
        introTitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245)),
            ColorSequenceKeypoint.new(0.76, Color3.fromRGB(220, 220, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        })
        introTitleGradient.Offset = Vector2.new(-1, 0)
        introTitleGradient.Parent = introTitle

        local introVsGlow = Instance.new("TextLabel")
        introVsGlow.Name = "IntroVsGlow"
        introVsGlow.BackgroundTransparency = 1
        introVsGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        introVsGlow.Position = UDim2.new(0.5, 0, 0.72, -70)
        introVsGlow.Size = UDim2.new(0.62, 0, 0, 76)
        introVsGlow.Font = Enum.Font.GothamBlack
        introVsGlow.Text = "VS"
        introVsGlow.TextColor3 = Color3.fromRGB(0, 0, 0)
        introVsGlow.TextSize = 58
        introVsGlow.TextTransparency = 1
        introVsGlow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        introVsGlow.TextStrokeTransparency = 1
        introVsGlow.ZIndex = 1007
        introVsGlow.Parent = introContent

        local introVs = introVsGlow:Clone()
        introVs.Name = "IntroVs"
        introVs.TextColor3 = Color3.fromRGB(255, 255, 255)
        introVs.TextSize = 54
        introVs.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        introVs.ZIndex = 1010
        introVs.Parent = introContent

        local introVsGhost = introVs:Clone()
        introVsGhost.Name = "IntroVsGhost"
        introVsGhost.TextColor3 = Color3.fromRGB(40, 40, 40)
        introVsGhost.ZIndex = 1009
        introVsGhost.Parent = introContent

        local function titleEntrance()
            local finalPos = UDim2.fromScale(0.5, 0.5)
            introTitle.Position = UDim2.new(0.5, -95, 0.5, 0)
            introTitleGlow.Position = UDim2.new(0.5, 85, 0.5, 0)
            introGlitchBright.Position = UDim2.new(0.5, 125, 0.5, -7)
            introGlitchDark.Position = UDim2.new(0.5, -125, 0.5, 7)
            introTitle.Rotation = -5
            introTitleGlow.Rotation = 5
            introTitle.TextTransparency = 1
            introTitleGlow.TextTransparency = 1
            introGlitchBright.TextTransparency = 0.3
            introGlitchDark.TextTransparency = 0.42

            TweenService:Create(introTitle, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0
            }):Play()
            TweenService:Create(introTitleGlow, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0.58
            }):Play()
            TweenService:Create(introGlitchBright, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 8, 0.5, -2)
            }):Play()
            TweenService:Create(introGlitchDark, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -8, 0.5, 2)
            }):Play()

            for _ = 1, 9 do
                local dx = math.random(-16, 16)
                local dy = math.random(-4, 4)
                introTitle.Position = UDim2.new(0.5, dx, 0.5, dy)
                introTitleGlow.Position = UDim2.new(0.5, -dx * 0.35, 0.5, -dy)
                introGlitchBright.Position = UDim2.new(0.5, dx + 8, 0.5, dy - 2)
                introGlitchDark.Position = UDim2.new(0.5, dx - 8, 0.5, -dy + 2)
                task.wait(0.025)
            end

            introTitle.Position = finalPos
            introTitleGlow.Position = finalPos
            introGlitchBright.TextTransparency = 1
            introGlitchDark.TextTransparency = 1
        end

        local function vsImpactGlitch()
            introVs.Position = UDim2.new(0.5, 0, 0.72, -68)
            introVsGlow.Position = introVs.Position
            introVsGhost.Position = UDim2.new(0.5, -8, 0.72, -62)
            introVs.TextTransparency = 0
            introVsGlow.TextTransparency = 0.58
            introVsGlow.TextStrokeTransparency = 0.48
            introVsGhost.TextTransparency = 0.42
            introVs.Rotation = -8
            introVsGlow.Rotation = 7
            introVsGhost.Rotation = -12

            local impactPos = UDim2.new(0.5, 0, 0.72, 18)
            TweenService:Create(introVs, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGlow, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGhost, TweenInfo.new(0.31, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -10, 0.72, 24), Rotation = 0
            }):Play()
            task.wait(0.30)

            for _ = 1, 13 do
                local dx = math.random(-12, 12)
                local dy = math.random(-5, 5)
                introVs.Position = UDim2.new(0.5, dx, 0.72, 18 + dy)
                introVsGlow.Position = UDim2.new(0.5, -dx * 0.45, 0.72, 18 - dy)
                introVsGhost.Position = UDim2.new(0.5, dx - 7, 0.72, 18 - dy)
                introVs.TextTransparency = math.random(0, 10) / 100
                introVsGlow.TextTransparency = math.random(40, 68) / 100
                introVsGhost.TextTransparency = math.random(25, 58) / 100
                task.wait(math.random(2, 4) / 100)
            end
            introVs.Position = impactPos
            introVsGlow.Position = impactPos
            introVsGhost.Position = impactPos
            introVs.TextTransparency = 0
            introVsGlow.TextTransparency = 0.60
            introVsGhost.TextTransparency = 1
        end

        local glitchSlices = {}
        for i = 1, 12 do
            local slice = Instance.new("Frame")
            slice.Name = "GlitchSlice_" .. i
            slice.BorderSizePixel = 0
            slice.BackgroundColor3 = i % 3 == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            slice.BackgroundTransparency = 1
            slice.AnchorPoint = Vector2.new(0.5, 0.5)
            slice.Position = UDim2.fromScale(0.5, 0.5)
            slice.Size = UDim2.new(0.5, 0, 0, 2)
            slice.ZIndex = 1009
            slice.Parent = introLayer
            table.insert(glitchSlices, slice)
        end

        for i = 1, 22 do
            local spark = Instance.new("Frame")
            spark.Name = "IntroSpark_" .. i
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            spark.BackgroundTransparency = 1
            spark.BorderSizePixel = 0
            spark.Size = UDim2.new(0, 1 + (i % 3), 0, 1 + (i % 3))
            spark.Position = UDim2.fromScale((i * 0.173) % 1, 1.04)
            spark.ZIndex = 1004
            spark.Parent = introLayer
            local sparkCorner = Instance.new("UICorner")
            sparkCorner.CornerRadius = UDim.new(1, 0)
            sparkCorner.Parent = spark
            task.spawn(function()
                while spark.Parent do
                    spark.Position = UDim2.fromScale(math.random(), 1.04)
                    spark.BackgroundTransparency = 0.62 + math.random() * 0.20
                    local rise = TweenService:Create(spark, TweenInfo.new(2.4 + math.random() * 2.5, Enum.EasingStyle.Linear), {
                        Position = UDim2.fromScale(math.clamp(spark.Position.X.Scale + (math.random() - 0.5) * 0.18, 0, 1), -0.04),
                        BackgroundTransparency = 1
                    })
                    rise:Play()
                    rise.Completed:Wait()
                end
            end)
        end

        local function glitchBurst(strength, duration)
            local started = os.clock()
            while introLayer.Parent and os.clock() - started < duration do
                local x = math.random(-strength, strength)
                local y = math.random(-math.max(1, math.floor(strength * 0.35)), math.max(1, math.floor(strength * 0.35)))
                introTitle.Position = UDim2.new(0.5, x, 0.5, y)
                introTitleGlow.Position = UDim2.new(0.5, -x * 0.35, 0.5, -y)
                introGlitchBright.Position = UDim2.new(0.5, x + math.random(2, 7), 0.5, y)
                introGlitchDark.Position = UDim2.new(0.5, x - math.random(3, 9), 0.5, -y)
                introGlitchBright.TextTransparency = math.random(15, 48) / 100
                introGlitchDark.TextTransparency = math.random(30, 62) / 100
                introTitle.TextTransparency = math.random(0, 12) / 100
                introTitleGlow.TextTransparency = math.random(38, 68) / 100

                if math.random() > 0.35 then
                    local slice = glitchSlices[math.random(1, #glitchSlices)]
                    slice.Position = UDim2.new(0.5, math.random(-45, 45), 0.5, math.random(-42, 42))
                    slice.Size = UDim2.new(math.random(24, 88) / 100, 0, 0, math.random(1, 4))
                    slice.BackgroundTransparency = math.random(8, 45) / 100
                end
                task.wait(math.random(2, 5) / 100)
                for _, slice in ipairs(glitchSlices) do
                    slice.BackgroundTransparency = 1
                end
            end
            introTitle.Position = UDim2.fromScale(0.5, 0.5)
            introTitleGlow.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchDark.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.TextTransparency = 1
            introGlitchDark.TextTransparency = 1
            introTitle.TextTransparency = 0
            introTitleGlow.TextTransparency = 0.58
        end

        task.spawn(function()
            local ok, err = xpcall(function()
            -- 1) Todo negro + mÃºsica al ejecutar
            introLayer.BackgroundTransparency = 0
            introLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            introImage.ImageTransparency = 1
            introShade.BackgroundTransparency = 1
            introVignette.ImageTransparency = 1
            for _, label in ipairs({introTitle, introTitleGlow, introGlitchBright, introGlitchDark, introVs, introVsGlow, introVsGhost}) do
                pcall(function()
                    label.TextTransparency = 1
                    label.TextStrokeTransparency = 1
                end)
            end
            startIntroMusic()
            task.wait(0.25)

            -- 2) Negro â†’ transparente (se va abriendo)
            TweenService:Create(introLayer, TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.55
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.62,
                Size = UDim2.fromScale(1.0, 1.0)
            }):Play()
            task.wait(0.80)

            -- 3) (Sonido de motosierra eliminado)

            -- 4) MVP vs entra por los costados + sonido de espada (libera la espada)
            introTitle.Text = "MVP"
            introTitleGlow.Text = "MVP"
            introGlitchBright.Text = "MVP"
            introGlitchDark.Text = "MVP"
            introVs.Text = "vs"
            introVsGlow.Text = "vs"
            introVsGhost.Text = "vs"

            -- Sonido de espada eliminado

            -- MVP desde la izquierda
            for _, label in ipairs({introTitle, introTitleGlow, introGlitchBright, introGlitchDark}) do
                label.Position = UDim2.new(0.5, -220, 0.5, 0)
                label.TextTransparency = 1
                label.TextStrokeTransparency = 1
            end
            -- vs desde la derecha
            for _, label in ipairs({introVs, introVsGlow, introVsGhost}) do
                label.Position = UDim2.new(0.5, 220, 0.5, 40)
                label.TextTransparency = 1
                label.TextStrokeTransparency = 1
            end

            for _, label in ipairs({introTitle, introTitleGlow}) do
                TweenService:Create(label, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.fromScale(0.5, 0.5),
                    TextTransparency = (label == introTitleGlow) and 0.55 or 0,
                    TextStrokeTransparency = (label == introTitleGlow) and 0.4 or 0.15
                }):Play()
            end
            for _, label in ipairs({introVs, introVsGlow}) do
                TweenService:Create(label, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0.5, 40),
                    TextTransparency = (label == introVsGlow) and 0.55 or 0,
                    TextStrokeTransparency = (label == introVsGlow) and 0.4 or 0.15
                }):Play()
            end
            task.wait(0.50)

            -- Fondo de portada mÃ¡s visible
            TweenService:Create(introLayer, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(8, 0, 0),
                BackgroundTransparency = 0.28
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.40
            }):Play()
            TweenService:Create(introShade, TweenInfo.new(0.4), {BackgroundTransparency = 0.88}):Play()

            titleEntrance()
            glitchBurst(9, 0.18)
            task.wait(0.06)
            vsImpactGlitch()

            task.spawn(function()
                local offset = -1
                for _ = 1, 50 do
                    offset = offset + 0.035
                    if offset > 1 then offset = -1 end
                    introTitleGradient.Offset = Vector2.new(offset, 0)
                    task.wait(0.016)
                end
            end)

            TweenService:Create(introContent, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1.02, 0, 0, 198)
            }):Play()
            task.wait(0.10)
            glitchBurst(10, 0.16)
            task.wait(0.08)

            -- Cierre rÃ¡pido
            glitchBurst(14, 0.18)
            TweenService:Create(introContent, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1.10, 0, 0, 208)
            }):Play()
            for _, label in ipairs({introTitle, introTitleGlow, introVs, introVsGlow, introVsGhost}) do
                TweenService:Create(label, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 1, TextStrokeTransparency = 1
                }):Play()
            end
            task.wait(0.14)
            TweenService:Create(introLayer, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 1,
                Size = UDim2.fromScale(1.05, 1.05)
            }):Play()
            TweenService:Create(introShade, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(introVignette, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 1
            }):Play()
            task.wait(0.12)
            end, debug.traceback)
            if not ok then
                warn("[MVP Intro] Animation error: " .. tostring(err))
            end
            finishIntro()
        end)
        introDone.Event:Wait()
        introDone:Destroy()
        pcall(function()
            if introScreenGui and introScreenGui.Parent then introScreenGui:Destroy() end
        end)

    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

;(function()
local NS, CS, LS, LS2 = 31, 60, 15, 24.5

local laggerPhase = 0 -- 0=off, 1=lagger, 2=lagger carry

local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	speedProfile = "Normal",
	profileLaggerNormalSpeed = 40,
	profileLaggerCarrySpeed = 20,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	hitboxFollowerEnabled = false,
	guiVisible = true,
	noIntro = (((getgenv and getgenv()) or _G).__MVP_NO_INTRO_SAVED == true),
	introEnabled = (((getgenv and getgenv()) or _G).__MVP_NO_INTRO_SAVED ~= true), selectedIntroMusic = 1,
	isStealing = false, stealStartTime = nil, lastStealTick = 0,
	lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	tpBatEnabled = false,
	unwalkEnabled = false,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
	darkModeEnabled = false, skyStyle = "Off",
	backgroundAssetId = "117085976067902",
	backgroundAssetIds = {
		"117085976067902",
	},
	imageChoiceVisuals = {},
}

local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local autoSavePositions = function() end  -- no-op, MobilePanel removed
local mobilePanelStyle = "darkhub"
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}
local mobileButtonDefaultPositions = {}
local BTN_POSITIONS_DH = {
	Drop       = UDim2.new(1, -298, 1, -334),
	AutoLeft   = UDim2.new(1, -144, 1, -334),
	AutoBat    = UDim2.new(1, -298, 1, -270),
	AutoRight  = UDim2.new(1, -144, 1, -270),
	TPDown     = UDim2.new(1, -298, 1, -206),
	Speed      = UDim2.new(1, -144, 1, -206),
	Lagger     = UDim2.new(1, -144, 1, -142),
}

local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	AutoBatV2 = {kb = nil,                      gp = nil},
	TPBat     = {kb = nil,                      gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	Lagger2   = {kb = nil,                      gp = nil},
	InstaReset= {kb = nil,                      gp = nil},
	GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
}

local function kbMatch(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end

local function getProfileNormalSpeed()
	return State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS
end

local function getProfileCarrySpeed()
	return State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS
end

local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
	AutoStealEnabled = false, StealRadius = 10, StealDuration = 1.3,
	Data = {}, plotCache = {}, plotCacheTime = {},
	cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
	autoSteal = nil, antiRag = nil,
	anchor = {}, progress = nil,
}

local safetyPositionIsValid
local startBatAimbot, stopBatAimbot
local function findAnyToolMob()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
local function getClosestPlayerMob2()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil,math.huge end
	local cp,cd=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local tr=p.Character:FindFirstChild("HumanoidRootPart")
			local ph=p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health>0 then
				local d=(root.Position-tr.Position).Magnitude
				if d<cd then cd=d; cp=p end
			end
		end
	end
	return cp,cd
end
local MOB_SWING_COOLDOWN=0.08
local function tryHitBatMob()
	if State.hittingCooldown then return end; State.hittingCooldown=true
	pcall(function()
		local c=LP.Character; if not c then return end
		local hum2=c:FindFirstChildOfClass("Humanoid"); local tool=findAnyToolMob()
		if tool then
			if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
			local remote=tool:FindFirstChildOfClass("RemoteEvent")
			if remote then pcall(function() remote:FireServer() end)
			else pcall(function() tool:Activate() end) end
		end
	end)
	task.delay(MOB_SWING_COOLDOWN,function() State.hittingCooldown=false end)
end
local _aimbotTarget = nil

local function findBat()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

local function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end

stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
	State.hittingCooldown = false
	_autoBatTarget = nil
	_autoBatEquippedThisRun = false

	if State._hitboxFollower and State._hitboxFollower.pausedByBatAim then
		State._hitboxFollower.pausedByBatAim = false
		if State.hitboxFollowerEnabled and not State.tpBatEnabled then
			State._hitboxFollower.start()
		end
	end
end

startBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect() end
	_autoBatEquippedThisRun = false

	if State._hitboxFollower and State.hitboxFollowerEnabled then
		State._hitboxFollower.pausedByBatAim = true
		State._hitboxFollower.stop()
	end

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end

	Conns.aimbot = RunService.RenderStepped:Connect(function(dt)
		if not State.autoBatToggled then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local target = getClosestTarget()
		if not target then
			hum.AutoRotate = true
			return
		end
		_aimbotTarget = target

		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position

		local predictPos = targetPos + targetVel * 0.14
		predictPos = predictPos + target.CFrame.LookVector * 0.3

		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
		local chaseSpeed = 60 -- Velocidad fija requerida en 60

		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then
			yVel = math.max(yVel, 13)
		end
		yVel = math.clamp(yVel, -70, 110)

		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local curCF  = root.CFrame
			local diffCF = curCF:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			local tiltSpeed = 42
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
			)
		end

		if State.autoSwingEnabled then
			local bat = char:FindFirstChildOfClass("Tool")
			if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
				pcall(function() bat:Activate() end)
			end
		end
	end)
end

State._hitboxFollower = State._hitboxFollower or {
    LOCK_RANGE = 150,
    enabled = false,
    conn = nil,
    pausedByBatAim = false,
}
State._hitboxFollower.pausedByBatAim = State._hitboxFollower.pausedByBatAim == true

function State._hitboxFollower.getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function State._hitboxFollower.tick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local target = State._hitboxFollower.getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    local dist = (target.Position - root.Position).Magnitude
    if dist > State._hitboxFollower.LOCK_RANGE then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    if hum.AutoRotate then hum.AutoRotate = false end

    local targetVel = target.AssemblyLinearVelocity
    local speed = targetVel.Magnitude
    local predictTime = math.clamp(speed / 150, 0.05, 0.2)
    local predictedPos = target.Position + targetVel * predictTime

    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y, predictedPos.Z)
    local toPredict = flatTarget - root.Position

    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function State._hitboxFollower.start()
    State._hitboxFollower.enabled = true
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
    end
    State._hitboxFollower.conn = RunService.RenderStepped:Connect(function()
        if State._hitboxFollower.enabled and not State.autoBatToggled and not State.tpBatEnabled then
            State._hitboxFollower.tick()
        end
    end)
end

function State._hitboxFollower.stop()
    State._hitboxFollower.enabled = false
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
        State._hitboxFollower.conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.hitboxFollowerEnabled and not State.autoBatToggled and not State.tpBatEnabled then
        State._hitboxFollower.stop()
        task.wait(0.2)
        State._hitboxFollower.start()
    elseif State.hitboxFollowerEnabled and (State.autoBatToggled or State.tpBatEnabled) then
        State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true
        State._hitboxFollower.stop()
    end
end)
local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1

local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setSuperJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle, setNoIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual
local setMedusaCounter, setBatCounter, setInstaGrab, setAutoSwingVisual
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil

State._configLoading = false
State._configLoaded = false
State._saveAfterLoad = false
State._saveRequestId = 0
State._lastSaveError = nil
State._configDirty = false
State._positionDirty = false

State._resolveFileFunction = function(name)
	local direct = nil
	if name == "writefile" then direct = writefile
	elseif name == "readfile" then direct = readfile
	elseif name == "isfile" then direct = isfile
	elseif name == "delfile" then direct = delfile
	elseif name == "makefolder" then direct = makefolder
	elseif name == "isfolder" then direct = isfolder end
	if type(direct) == "function" then return direct end

	local environments = {}
	pcall(function()
		if getgenv then table.insert(e
