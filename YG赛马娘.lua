local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()

local rainbowBorderAnimation = nil
local currentBorderColorScheme = "Sakura Mist"
local borderInitialized = false
local animationSpeed = 2
local borderEnabled = true

local COLOR_SCHEMES = {
    ["Blue White"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["Neon"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))
    }), "sparkles"},
    ["Sakura Mist"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFF5F8")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFE0E9")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"light_cherry"},
}

local colorSchemeNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorSchemeNames, name)
end
table.sort(colorSchemeNames)

local function createRainbowBorder(window, colorScheme)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil
        end
    end

    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end

    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke
    end

    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame

    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["Blue White"][1]
    end
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke

    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end

    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end

    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end

    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end

    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end

    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)

    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    local rainbowStroke = createRainbowBorder(Window, scheme)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function playSound()
end

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>Y</font><font color='#FFA0B5'>G</font>",
    Author = "<font color='#FFA0B5'>Uma Racing</font>",
    Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/qjWYa4nk2uxfW8NYoz5bgluvARZS4nkjdejCvuKdKIwVOnRPNBCwwaMz9XBsn5jd_2048x2048x4017713.png",
    IconTransparency = 1,
    Folder = "YG",
    Size = UDim2.fromOffset(500, 100),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 200,
    HasOutline = true,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/8Wt7bZfoaK9brDb8dgju7fF8h3UwFAz9x9bLLHVKS1hmPkdfDTgubZ99sZG1I9O2_5120x3856x2331578.jpeg",
    BackgroundImageTransparency = 0.425,
})

Window:EditOpenButton({
    Title = "<font color='#FFB6C1'>Y</font><font color='#FFA0B5'>G</font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 188, 217)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 153, 204)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    Draggable = true,
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local function setBorderActive(active)
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then return end
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if active then
        if not rainbowStroke then
            rainbowStroke = createRainbowBorder(Window, currentBorderColorScheme)
        end
        if rainbowStroke then
            rainbowStroke.Enabled = true
            if not rainbowBorderAnimation then
                startBorderAnimation(Window, animationSpeed)
            end
        end
    else
        if rainbowStroke then
            rainbowStroke.Enabled = false
        end
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
    end
end

local function applyBorderState()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then return end
    local shouldBeActive = mainFrame.Visible and borderEnabled
    setBorderActive(shouldBeActive)
end

spawn(function()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then
        repeat
            wait()
            mainFrame = Window.UIElements and Window.UIElements.Main
        until mainFrame
    end
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(applyBorderState)
    applyBorderState()
end)

local Settings = Window:Tab({
    Title = "主要功能",
    Icon = "crown",
})

Settings:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(value)
        infiniteStaminaEnabled = value
        if value then
            -- 开启：挂载钩子
            if not oldNamecall then
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    if getnamecallmethod() == "FireServer" and tostring(self) == "RequestSprintAction" then
                        local args = {...}
                        if args[1] == "SpeedTarget" then
                            args[2] = 0
                            return oldNamecall(self, unpack(args))
                        end
                    end
                    return oldNamecall(self, ...)
                end)
            end
        else
            -- 关闭：恢复原函数
            if oldNamecall then
                hookmetamethod(game, "__namecall", oldNamecall)
                oldNamecall = nil
            end
        end
    end
})

Window:OnClose(function()
end)