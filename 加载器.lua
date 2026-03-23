-- VIP用户名单（请在此处添加VIP用户名）
local VIP_USERS = {
    "xiaoxi_919",  -- 示例用户1
    "byXUNHAN_BYPASS",  -- 示例用户2
    "XHBYPASS",  -- 示例用户3
    -- 在此处添加更多VIP用户名
}

-- 获取当前玩家用户名
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerName = localPlayer.Name

-- 检查是否为VIP用户
local isVIP = false
for _, vipName in ipairs(VIP_USERS) do
    if vipName == playerName then
        isVIP = true
        break
    end
end

local Tween = game:GetService('TweenService') 
local ScriptScreen = Instance.new('ScreenGui', game.Players.LocalPlayer.PlayerGui)
ScriptScreen.Name = "BaiMoScriptGUI"

-- 根据VIP状态设置不同的颜色主题
local VIP_COLORS = {
    Background = isVIP and Color3.new(0.1, 0.05, 0.15) or Color3.new(0, 0, 0),
    Gradient1 = isVIP and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 150, 255),
    Gradient2 = isVIP and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(0, 255, 255),
    TextColor = isVIP and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255),
    VIPBadgeColor = Color3.fromRGB(255, 215, 0),
    NormalBadgeColor = Color3.fromRGB(150, 150, 150)
}

-- 创建主框架
local Main = Instance.new('Frame', ScriptScreen)
Main.BackgroundTransparency = 0.5
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.4, 0)
Main.Name = 'Main'
Main.BackgroundColor3 = VIP_COLORS.Background
Main.Size = UDim2.new(0, 500, 0, 300)

local MainC = Instance.new('UICorner', Main)
MainC.CornerRadius = UDim.new(0.05, 0)

local MainS = Instance.new('UIStroke', Main)
MainS.Color = Color3.fromRGB(255, 255, 255)
MainS.Thickness = 3

-- 流光边框效果
local gradient1 = Instance.new('UIGradient', MainS)
gradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, VIP_COLORS.Gradient1),
    ColorSequenceKeypoint.new(1, VIP_COLORS.Gradient2)
}

-- VIP专属边框闪烁效果
if isVIP then
    task.spawn(function()
        while Main and Main.Parent do
            gradient1.Rotation += 3  -- VIP旋转更快
            -- VIP边框闪烁
            MainS.Transparency = 0.3 + math.sin(tick() * 2) * 0.2
            task.wait()
        end
    end)
else
    task.spawn(function()
        while Main and Main.Parent do
            gradient1.Rotation += 1  -- 普通用户旋转较慢
            task.wait()
        end
    end)
end

-- VIP标识（徽章）
local VIPTag = Instance.new('Frame', Main)
VIPTag.BackgroundColor3 = VIP_COLORS.VIPBadgeColor
VIPTag.Size = UDim2.new(0, 100, 0, 30)
VIPTag.Position = UDim2.new(1, -110, 0, 10)
VIPTag.BackgroundTransparency = isVIP and 0.2 or 0.7
VIPTag.Name = 'VIPTag'

local VIPTagCorner = Instance.new('UICorner', VIPTag)
VIPTagCorner.CornerRadius = UDim.new(0.2, 0)

local VIPTagStroke = Instance.new('UIStroke', VIPTag)
VIPTagStroke.Color = isVIP and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(150, 150, 150)
VIPTagStroke.Thickness = 2

local VIPTagLabel = Instance.new('TextLabel', VIPTag)
VIPTagLabel.Size = UDim2.new(1, 0, 1, 0)
VIPTagLabel.BackgroundTransparency = 1
VIPTagLabel.Text = isVIP and "✨ VIP用户 ✨" or "普通用户"
VIPTagLabel.TextColor3 = isVIP and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(150, 150, 150)
VIPTagLabel.Font = Enum.Font.GothamBold
VIPTagLabel.TextSize = 14
VIPTagLabel.TextScaled = true

-- VIP专属徽章动画
if isVIP then
    task.spawn(function()
        while VIPTag and VIPTag.Parent do
            VIPTagStroke.Transparency = 0.3 + math.sin(tick() * 3) * 0.3
            VIPTag.BackgroundTransparency = 0.2 + math.sin(tick() * 2) * 0.15
            task.wait()
        end
    end)
end

-- 标题
local Title1 = Instance.new('TextLabel', Main)
Title1.Text = 'by小西制作此脚本'
Title1.TextSize = 40
Title1.BackgroundTransparency = 1
Title1.TextColor3 = VIP_COLORS.TextColor
Title1.AnchorPoint = Vector2.new(0.5, 0.5)
Title1.Position = UDim2.new(0.5, 0, 0.3, 0)
Title1.Font = Enum.Font.GothamBold

-- VIP专属标题效果
if isVIP then
    task.spawn(function()
        while Title1 and Title1.Parent do
            Title1.TextColor3 = Color3.fromHSV(math.sin(tick() * 0.5) * 0.5 + 0.5, 0.8, 1)
            task.wait(0.1)
        end
    end)
end

-- 玩家欢迎语
local Title2 = Instance.new('TextLabel', Main)
Title2.Text = '尊贵的' .. (isVIP and '小西作者 ' or 'by小西 ') .. game.Players.LocalPlayer.Name
Title2.TextSize = 22
Title2.BackgroundTransparency = 1
Title2.TextColor3 = VIP_COLORS.TextColor
Title2.AnchorPoint = Vector2.new(0.5, 0.5)
Title2.Position = UDim2.new(0.5, 0, 0.5, 0)
Title2.Font = isVIP and Enum.Font.GothamBold or Enum.Font.Gotham

-- VIP用户显示额外特权信息
if isVIP then
    local VIPPrivilege = Instance.new('TextLabel', Main)
    VIPPrivilege.Text = '🎁 尊享VIP特权 | ⚡ 极速加载 | 🌟 专属效果'
    VIPPrivilege.TextSize = 16
    VIPPrivilege.BackgroundTransparency = 1
    VIPPrivilege.TextColor3 = Color3.fromRGB(255, 215, 0)
    VIPPrivilege.AnchorPoint = Vector2.new(0.5, 0.5)
    VIPPrivilege.Position = UDim2.new(0.5, 0, 0.6, 0)
    VIPPrivilege.Font = Enum.Font.Gotham
    
    -- 特权信息闪烁效果
    task.spawn(function()
        while VIPPrivilege and VIPPrivilege.Parent do
            VIPPrivilege.TextTransparency = 0.2 + math.sin(tick() * 2) * 0.3
            task.wait(0.1)
        end
    end)
end

local Title3 = Instance.new('TextLabel', Main)
Title3.Text = isVIP and '欢迎使用VIP专属版XIAOXI脚本[BaiMo-Script]' or '欢迎使用XIAOXI脚本[BaiMo-Script]'
Title3.TextSize = 20
Title3.BackgroundTransparency = 1
Title3.TextColor3 = VIP_COLORS.TextColor
Title3.AnchorPoint = Vector2.new(0.5, 0.5)
Title3.Position = isVIP and UDim2.new(0.5, 0, 0.7, 0) or UDim2.new(0.5, 0, 0.75, 0)
Title3.Font = isVIP and Enum.Font.GothamBold or Enum.Font.Gotham

-- 加载条主框架
local LoadMain = Instance.new('Frame', ScriptScreen)
LoadMain.BackgroundTransparency = 0.5
LoadMain.AnchorPoint = Vector2.new(0.5, 0.5)
LoadMain.Position = UDim2.new(0.5, 0, isVIP and 0.8 or 0.66, 0)
LoadMain.Name = 'LoadMain'
LoadMain.BackgroundColor3 = VIP_COLORS.Background
LoadMain.Size = isVIP and UDim2.new(0, 450, 0, 40) or UDim2.new(0, 500, 0, 50)

local LoadMainC = Instance.new('UICorner', LoadMain)
LoadMainC.CornerRadius = UDim.new(0.08, 0)

local LoadMainS = Instance.new('UIStroke', LoadMain)
LoadMainS.Color = Color3.fromRGB(255, 255, 255)
LoadMainS.Thickness = 3

local gradient2 = Instance.new('UIGradient', LoadMainS)
gradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, VIP_COLORS.Gradient1),
    ColorSequenceKeypoint.new(1, VIP_COLORS.Gradient2)
}

-- 加载条边框动画
if isVIP then
    task.spawn(function()
        while LoadMain and LoadMain.Parent do
            gradient2.Rotation += 2
            LoadMainS.Transparency = 0.2 + math.sin(tick() * 2.5) * 0.2
            task.wait()
        end
    end)
else
    task.spawn(function()
        while LoadMain and LoadMain.Parent do
            gradient2.Rotation += 1
            task.wait()
        end
    end)
end

-- 加载填充条
local LoadFillMain = Instance.new('Frame', LoadMain)
LoadFillMain.BackgroundTransparency = 0.5
LoadFillMain.Name = 'LoadMain'
LoadFillMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadFillMain.Size = UDim2.new(0, 0, 1, 0)

local LoadFillMainC = Instance.new('UICorner', LoadFillMain)
LoadFillMainC.CornerRadius = UDim.new(0.08, 0)

local gradient3 = Instance.new('UIGradient', LoadFillMain)
gradient3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, VIP_COLORS.Gradient1),
    ColorSequenceKeypoint.new(1, VIP_COLORS.Gradient2)
}

-- VIP用户填充条渐变旋转
if isVIP then
    task.spawn(function()
        while LoadFillMain and LoadFillMain.Parent do
            gradient3.Rotation += 3
            task.wait()
        end
    end)
else
    task.spawn(function()
        while LoadFillMain and LoadFillMain.Parent do
            gradient3.Rotation += 1
            task.wait()
        end
    end)
end

-- 状态文本
local LoadState = Instance.new('TextLabel', Main)
LoadState.Text = isVIP and '🌟 VIP专属加速加载中...' or '正在加载玩家信息...'
LoadState.TextSize = 18
LoadState.BackgroundTransparency = 1
LoadState.TextColor3 = VIP_COLORS.TextColor
LoadState.AnchorPoint = Vector2.new(0.5, 0.5)
LoadState.Position = isVIP and UDim2.new(0.5, 0, 0.9, 0) or UDim2.new(0.5, 0, 1.3, 0)
LoadState.Font = isVIP and Enum.Font.GothamBold or Enum.Font.Gotham

-- VIP用户状态文本闪烁效果
if isVIP then
    task.spawn(function()
        while LoadState and LoadState.Parent do
            LoadState.TextTransparency = 0.1 + math.sin(tick() * 2) * 0.2
            task.wait(0.1)
        end
    end)
end

-- VIP用户显示加载百分比
local LoadPercent = nil
if isVIP then
    LoadPercent = Instance.new('TextLabel', LoadMain)
    LoadPercent.Size = UDim2.new(1, 0, 1, 0)
    LoadPercent.BackgroundTransparency = 1
    LoadPercent.Text = '0%'
    LoadPercent.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadPercent.Font = Enum.Font.GothamBold
    LoadPercent.TextSize = 16
    LoadPercent.TextStrokeTransparency = 0.5
end

-- VIP加载进度更新函数
local function updateVIPLoadPercent(percent)
    if isVIP and LoadPercent then
        LoadPercent.Text = math.floor(percent * 100) .. '%'
        -- VIP百分比颜色渐变
        LoadPercent.TextColor3 = Color3.fromHSV(percent * 0.3, 0.8, 1)
    end
end

-- ============ VIP自动关闭计时器 ============
local AutoCloseTimer = nil
local CountdownLabel = nil

if isVIP then
    -- 创建倒计时显示标签
    CountdownLabel = Instance.new('TextLabel', Main)
    CountdownLabel.Size = UDim2.new(0, 150, 0, 25)
    CountdownLabel.Position = UDim2.new(0.5, -75, 0.95, 0)
    CountdownLabel.BackgroundTransparency = 0.8
    CountdownLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CountdownLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    CountdownLabel.Font = Enum.Font.GothamBold
    CountdownLabel.TextSize = 14
    CountdownLabel.Text = "自动关闭倒计时: 5秒"
    CountdownLabel.Visible = false
    
    local CountdownCorner = Instance.new('UICorner', CountdownLabel)
    CountdownCorner.CornerRadius = UDim.new(0.2, 0)
    
    local CountdownStroke = Instance.new('UIStroke', CountdownLabel)
    CountdownStroke.Color = Color3.fromRGB(255, 215, 0)
    CountdownStroke.Thickness = 2
end

-- VIP自动关闭函数
local function startAutoCloseTimer(seconds)
    if not isVIP then return end
    
    CountdownLabel.Visible = true
    
    local remainingTime = seconds
    AutoCloseTimer = task.spawn(function()
        while remainingTime > 0 and CountdownLabel and CountdownLabel.Parent do
            CountdownLabel.Text = string.format("⏰ 自动关闭倒计时: %d秒", remainingTime)
            
            -- 最后3秒闪烁
            if remainingTime <= 3 then
                CountdownLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                CountdownLabel.BackgroundTransparency = 0.3 + math.sin(tick() * 10) * 0.3
            end
            
            remainingTime -= 1
            task.wait(1)
        end
        
        if CountdownLabel and CountdownLabel.Parent then
            -- 执行关闭动画
            CountdownLabel.Text = "🎉 加载完成，正在关闭..."
            CountdownLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- VIP关闭特效
            task.spawn(function()
                for i = 1, 5 do
                    CountdownLabel.BackgroundTransparency = 0.2 + math.sin(tick() * 20) * 0.3
                    task.wait(0.05)
                end
            end)
            
            task.wait(0.5)
            
            -- 执行优雅的关闭动画
            local fadeOutTime = 0.8
            Tween:Create(Main, TweenInfo.new(fadeOutTime), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            Tween:Create(LoadMain, TweenInfo.new(fadeOutTime), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            Tween:Create(LoadFillMain, TweenInfo.new(fadeOutTime), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            Tween:Create(CountdownLabel, TweenInfo.new(fadeOutTime), {
                BackgroundTransparency = 1,
                TextTransparency = 1
            }):Play()
            
            -- 所有文本元素淡出
            local textElements = {Title1, Title2, Title3, LoadState, VIPPrivilege}
            for _, element in pairs(textElements) do
                if element and element.Parent then
                    Tween:Create(element, TweenInfo.new(fadeOutTime), {
                        TextTransparency = 1
                    }):Play()
                end
            end
            
            if VIPTag and VIPTag.Parent then
                Tween:Create(VIPTag, TweenInfo.new(fadeOutTime), {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                }):Play()
            end
            
            -- 等待动画完成
            task.wait(fadeOutTime + 0.1)
            
            -- 清理所有UI元素
            Main:Destroy()
            LoadMain:Destroy()
            LoadFillMain:Destroy()
            if CountdownLabel then CountdownLabel:Destroy() end
            if VIPTag then VIPTag:Destroy() end
            
            print("[VIP系统] 界面已自动关闭")
        end
    end)
end

-- VIP手动跳过按钮
local SkipButton = nil
if isVIP then
    SkipButton = Instance.new('TextButton', Main)
    SkipButton.Size = UDim2.new(0, 120, 0, 35)
    SkipButton.Position = UDim2.new(0.5, -60, 1.1, 0)
    SkipButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    SkipButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    SkipButton.Font = Enum.Font.GothamBold
    SkipButton.TextSize = 14
    SkipButton.Text = "⏭️ 立即跳过"
    SkipButton.Visible = false
    SkipButton.BorderSizePixel = 0
    
    local SkipCorner = Instance.new('UICorner', SkipButton)
    SkipCorner.CornerRadius = UDim.new(0.2, 0)
    
    SkipButton.MouseButton1Click:Connect(function()
        if AutoCloseTimer then
            task.cancel(AutoCloseTimer)
            AutoCloseTimer = nil
        end
        
        -- 立即关闭特效
        SkipButton.Text = "🎯 正在关闭..."
        SkipButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        
        -- 立即执行关闭动画
        startAutoCloseTimer(0)
    end)
    
    -- 按钮悬停效果
    SkipButton.MouseEnter:Connect(function()
        SkipButton.BackgroundColor3 = Color3.fromRGB(255, 230, 100)
    end)
    
    SkipButton.MouseLeave:Connect(function()
        SkipButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end)
end

-- ============ 加载动画序列 ============

-- VIP用户有更快的加载速度
local loadTimeMultiplier = isVIP and 0.8 or 1  -- VIP加载速度提升20%

-- 第一阶段加载
task.wait(0.5)
Tween:Create(LoadFillMain, TweenInfo.new(1 * loadTimeMultiplier), {Size = UDim2.new(0.2, 0, 1, 0)}):Play()
updateVIPLoadPercent(0.2)

-- VIP用户特殊音效（可选）
if isVIP and game:GetService("SoundService") then
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://3570574687"  -- VIP加载音效
        sound.Volume = 0.2
        sound.Parent = game.Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end)
end

task.wait(1 * loadTimeMultiplier)
LoadState.Text = isVIP and '✨ 正在加载VIP专属界面...' or '正在加载脚本界面...'
Tween:Create(LoadFillMain, TweenInfo.new(0.7 * loadTimeMultiplier), {Size = UDim2.new(0.5, 0, 1, 0)}):Play()
updateVIPLoadPercent(0.5)

task.wait(0.7 * loadTimeMultiplier)
LoadState.Text = isVIP and '⚡ 正在加载VIP特权项目...' or '正在加载项目...'
Tween:Create(LoadFillMain, TweenInfo.new(0.6 * loadTimeMultiplier), {Size = UDim2.new(1, 0, 1, 0)}):Play()
updateVIPLoadPercent(1)

task.wait(0.7 * loadTimeMultiplier)
LoadState.Text = isVIP and '🎉 VIP加载完成! 欢迎尊贵用户!' or '加载完成!'
updateVIPLoadPercent(1)

-- VIP用户完成特效
if isVIP then
    -- VIP完成闪烁效果
    for i = 1, 3 do
        LoadState.TextColor3 = Color3.fromRGB(255, 215, 0)
        task.wait(0.1)
        LoadState.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(0.1)
    end
    
    LoadState.Text = '🎊 XIAOXI脚本[BaiMo-Script] 已准备就绪'
    LoadState.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    -- 显示跳过按钮
    if SkipButton then
        SkipButton.Visible = true
        Tween:Create(SkipButton, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -60, 0.85, 0)
        }):Play()
    end
    
    -- VIP徽章缩小并移动到右上角
    Tween:Create(VIPTag, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 80, 0, 25),
        Position = UDim2.new(1, -85, 0, 5)
    }):Play()
    
    -- 启动自动关闭倒计时（5秒后自动关闭）
    task.wait(1)  -- 等待1秒让用户看到完成状态
    startAutoCloseTimer(5)
    
    -- VIP完成音效
    if game:GetService("SoundService") then
        task.spawn(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9118340725"  -- 完成音效
            sound.Volume = 0.3
            sound.Parent = game.Workspace
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 3)
        end)
    end
else
    -- 普通用户流程
    task.wait(0.5)
    Title1:Destroy()
    Title2:Destroy()
    Title3:Destroy()
    LoadState:Destroy()
    if VIPTag then VIPTag:Destroy() end
    
    Tween:Create(Main, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    Tween:Create(LoadFillMain, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    Tween:Create(LoadMain, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.5)
    Main:Destroy()
    LoadMain:Destroy()
    LoadFillMain:Destroy()
    print("[系统] 普通用户加载完成")
end

-- 输出用户状态信息
print("=================================")
print("XIAOXI脚本[BaiMo-Script] 加载系统")
print("用户: " .. playerName)
print("VIP状态: " .. (isVIP and "尊贵VIP用户" or "普通用户"))
print("加载时间: " .. (isVIP and "加速完成" or "标准完成"))
if isVIP then
    print("自动关闭: 5秒后自动关闭界面")
    print("操作提示: 可点击'立即跳过'按钮提前关闭")
end
print("=================================")

-- VIP用户额外提示
if isVIP then
    -- 在聊天框发送VIP提示
    task.spawn(function()
        task.wait(3)
        local message = "🎉 VIP加载完成! 脚本界面将在倒计时结束后自动关闭。"
        if game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
            -- 创建一个通知
            local notification = Instance.new("ScreenGui")
            notification.Name = "VIPNotification"
            notification.Parent = game:GetService("Players").LocalPlayer.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 50)
            frame.Position = UDim2.new(0.5, -150, 0.1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            frame.BackgroundTransparency = 0.3
            frame.Parent = notification
            
            local corner = Instance.new("UICorner", frame)
            corner.CornerRadius = UDim.new(0.1, 0)
            
            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = Color3.fromRGB(255, 215, 0)
            stroke.Thickness = 2
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 1, -10)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = message
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextWrapped = true
            label.Parent = frame
            
            -- 3秒后淡出
            task.wait(3)
            Tween:Create(frame, TweenInfo.new(1), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -150, 0, -100)
            }):Play()
            Tween:Create(stroke, TweenInfo.new(1), {
                Transparency = 1
            }):Play()
            Tween:Create(label, TweenInfo.new(1), {
                TextTransparency = 1
            }):Play()
            
            task.wait(1)
            notification:Destroy()
        end
    end)
end
game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "因为你检测到可执行加载器",
  Text = "正在启动XIAOXI加载器",
  Icon = "rbxassetid://123691280552142",
  Duration = 1,
  Callback = bindable,
  Button1 = "谢谢使用🤑",
  Button2 = "本脚本为工益",
})
wait(1.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "不打算付费",
  Text = "卡密进群获取🤔 ",
  Icon = "rbxassetid://123691280552142",
  Duration = 1,
  Callback = bindable,
  Button1 = "qq群：705378396",
  Button2 = "作者qq：3574769415",
})
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
    Icon = "rbxassetid://123691280552142",
    Author = "by小西制作",
    AuthorImage = 90840643379863,
    Folder = "CloudHub",
    Size = UDim2.fromOffset(560, 360),
    KeySystem = {
        Key = { "小西", "小西nb", "宇星辰", "阵雨眉目" }, 
        Note = "请输入卡密",
        SaveKey = false,
    },
    Transparent = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/Video_1773632365272_24.mp4",
    User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己",
                    Content = "没什么", 
                    Duration = 1,
                    Icon = "4483362748"
                })
            end,
            Anonymous = false
        },
})

Window:Tag({
    Title = "加载器",
    Color = Color3.fromHex("FF69B4")
})

WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)  
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)  

local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    
    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame
    
    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet
    
    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule
    
    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local themes_list = {"Dark", "Light", "Mocha", "Aqua"}
    currentThemeIndex = (currentThemeIndex % #themes_list) + 1
    local newTheme = themes_list[currentThemeIndex]
    WindUI:SetTheme(newTheme)
    WindUI:Notify({
        Title = "主题已切换",
        Content = "当前主题: "..newTheme,
        Duration = 2
    })
end, 990)

WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))
    }), "palette"},
    
    ["樱花粉1"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))
    }), "candy"},

    ["樱花粉2"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FED0E0")),
        ColorSequenceKeypoint.new(0.2, Color3.fromHex("FDBAD2")),
        ColorSequenceKeypoint.new(0.4, Color3.fromHex("FCA5C5")),
        ColorSequenceKeypoint.new(0.6, Color3.fromHex("FB8FB7")),
        ColorSequenceKeypoint.new(0.8, Color3.fromHex("FA7AA9")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("F9649B"))
    }), "waves"},
}

Window:EditOpenButton(
    {
        Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
        Icon = "rbxassetid://123691280552142",
        CornerRadius = UDim.new(0, 13),
        StrokeThickness = 4,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 19, 19)),ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 60, 129))}),
        Draggable = true
    }
)

local function createRainbowBorder(window, colorScheme, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        existingStroke:Destroy()
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or "樱花粉2"]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["樱花粉2"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    
    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end


function Tab(a)
    return Window:Tab({Title = a, Icon = "eye"})
end

function Button(a, b, c)
    return a:Button({Title = b, Callback = c})
end

function Toggle(a, b, c, d)
    return a:Toggle({Title = b, Value = c, Callback = d})
end

function Slider(a, b, c, d, e, f)
    return a:Slider({Title = b, Step = 1, Value = {Min = c, Max = d, Default = e}, Callback = f})
end

function Dropdown(a, b, c, d, e)
    return a:Dropdown({Title = b, Values = c, Value = d, Callback = e})
end

function Input(a, b, c, d, e, f)
    return a:Input({
        Title = b,
        Desc = c or "",
        Value = d or "",
        Placeholder = e or "",
        Callback = f
    })
end

local Taba = Tab("首页")
local Tabjb = Tab("支持服务器")
local Tab5 = Tab("音乐")
local Tabb = Tab("设置")

local player = game.Players.LocalPlayer

Taba:Paragraph({
    Title = "欢迎使用XIAIXI脚本",
    Desc = "作者：小西｜ UI提供：鱼腥草｜\n版本：v4.0.0\n\n一个功能强大的脚本😭",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/1357873301.jpg",
    ThumbnailSize = 170
})

Taba:Divider()

Taba:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用XIAOXI",
            Icon = "heart",
            Duration = 3
        })
    end
})
Taba:Paragraph({
    Title = "此脚本为免费⭕钱和作者无关",
    Desc = [[ ]],
    Image = "eye",
    ImageSize = 24,
    Color = Color3.fromHex("#000000"),
    BackgroundColor3 = Color3.fromHex("#000000"),
    BackgroundTransparency = 0.2,
    OutlineColor = Color3.fromHex("#000000"),
    OutlineThickness = 1,
    Padding = UDim.new(0, 1)
})
Taba:Paragraph({
    Title = "计划50个服务器😋😋",
    Desc = [[ ]],
    Image = "eye",
    ImageSize = 24,
    Color = Color3.fromHex("#000000"),
    BackgroundTransparency = 1,
    OutlineColor = Color3.fromHex("#FFFFFF"),
    OutlineThickness = 1,
    Padding = UDim.new(0, 1)
})





Button(Tabjb, "点击此处复制小西私人qq以提供你的脚本", function()
    setclipboard("3574769415")
end)

Button(Tabjb, "正在寻求", function() 
        FengYu_HUB = "正在寻求"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/xiaoxi9008.github.io/refs/heads/main/SX%E9%80%9A%E7%BC%89%E6%BA%90%E7%A0%81%EF%BC%88KENNY%EF%BC%89.lua"))() 
end)

Button(Tabjb, "终极战场", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/Kanl%E6%9C%80%E6%96%B0%E7%BB%88%E6%9E%81%E6%88%98%E5%9C%BA%E6%BA%90%E7%A0%81.lua"))()
end)

Button(Tabjb, "偷走一粒红", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/%E5%81%B7%E8%B5%B0%E8%84%91%E7%BA%A2.lua"))() 
end)

Button(Tabjb, "自然灾害", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/%E8%87%AA%E7%84%B6%E7%81%BE%E5%AE%B3.lua"))() 
end)

Button(Tabjb, "99个森林夜", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/99%E5%A4%9C.lua"))() 
end)

Button(Tabjb, "忍者传奇", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/%E5%BF%8D%E8%80%85%E4%BC%A0%E5%A5%87.lua"))()
end)

Button(Tabjb, "种植花园", function() 
        Pikon_script = "by小西"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/%E7%A7%8D%E6%A4%8D%E8%8A%B1%E5%9B%AD.lua"))()
end)

Button(Tabjb, "被遗弃", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/%E8%A2%AB%E9%81%97%E5%BC%83.lua"))()
end)

Button(Tabjb, "doors", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/doors.lua"))()
end)

Button(Tabjb, "墨水", function() 
        KG_SCRIPT = "卡密：小西nb"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/moshui.lua"))()
end)

Button(Tabjb, "OhioV3未完善", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/1.lua"))()
end)

Button(Tabjb, "OhioV2可以配的V3一起玩", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/SX%E4%BF%84%E4%BA%A5%E4%BF%84%E5%B7%9EV5%E6%BA%90%E7%A0%81(1).lua"))() 
end)

Button(Tabjb, "NOL老版本", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/NOL%E5%8A%A0%E8%BD%BD%E5%99%A8.lua"))()
end)

Button(Tabjb, "NOL提供的被遗弃Bug太多了", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Xiaoxi/refs/heads/main/NOL-%E4%BB%98%E8%B4%B9%E7%89%88%E6%9C%80%E6%96%B0%E6%BA%90%E7%A0%81.lua"))() 
end)

Button(Tabjb, "粉丝猪的秘密", function()
    setclipboard("皮炎超旋风暴我的皮燕突然自主启动为超频涡轮形态，每秒钟旋转达到惊人的十二万九千六百转，喷出的气流直接形成了小型龙卷风将整个房间卷得一片狼藉，隔壁邻居愤怒地拍门大吼：“谁家直升机又在厕所坠毁了？！”我绝望地试图用定制钛合金肛塞堵住风暴眼，它却瞬间被超高温金属射流熔成了一滩发光的钢水，最终我的臀部在一道突破音障的尖锐爆鸣中，化为璀璨的星际尘埃，只留下地板上一个完美圆形灼刻图案和弥漫不散的哲学气息。我的皮燕，毫无预兆地，启动了。不是以往那种带着尴尬湿气的普通排气，也不是偶尔失控的连环闷响。这一次，是清晰无误的、机械嵌合般的“咔嗒”一声自体内传来，仿佛某个沉睡的远古协议被瞬间激活。紧接着，一股冰冷而暴戾的漩涡感在尾椎底部成形，急速扩张。嗡——”低鸣在零点一秒内爬升到令人牙酸的尖啸。我能感觉到，不是气体在排出，而是那入口本身，成了风暴的源头，成了引擎的核心。超频涡轮形态——这六个字毫无道理却无比精准地砸进我的脑海。视野边缘似乎出现了幻觉般的红色读数：转速每秒十二万九千六百转，还在飙升。“不……停下！”哀求被更狂暴的声响吞没。第一股喷出的气流就不是气流，它呈螺旋状，灰白中夹杂着难以描述的复杂颜色，刚离开躯体就疯狂抽取周围的空气。纸巾盒率先被扯碎，白絮还没飘散就被吸入那不断扩大的气旋。椅子哀嚎着刮擦地板，斜着撞过来，我踉跄躲开，眼睁睁看着它连同半张地毯、几只笔、一个空可乐罐，一起被卷进我那臀部后方诞生的、越来越清晰的小型龙卷风里。房间不再是房间，成了一个正在被离心力撕扯、搅拌的灾难现场。书本飞舞，窗帘笔直地绷向风暴中心，玻璃窗发出可怕的呻吟。“砰！砰！砰！”沉重的砸门声穿透风暴的轰鸣，隔壁那暴躁老哥的吼叫变形而遥远：“谁家直升机又在厕所坠毁了？！ 还让不让人——”他的声音戛然而止，或许是被一块飞过去的鼠标垫糊在了脸上。绝望像冰水浇头。得堵住它！我连滚爬爬，扑向书桌抽屉最深处，那里有一个冰冷沉重的物件——为极端情况（我从未想过真有用上的一天）定制的钛合金肛塞，流线型，表面抛光得像颗黑色的毒苹果。我颤抖着，背对那吞噬一切的风暴眼，试图将它按向那疯狂的漩涡。接触，只在一瞬。没有阻塞感，没有摩擦声。只有一道耀眼至极的超高温金属射流，像星球初诞时的光芒，从塞子与风暴眼的接触点迸发出来。定制钛合金，足以承受火箭发动机尾焰的材料，连挣扎都没有，就在我手中无声地熔解、汽化，化作一滩炽白滚烫、滴落时嘶嘶作响的钢水，在地板上蚀出冒烟的小坑。热风灼伤了我的手背，刺痛却远不及心底的冰凉。转速，突破了某个临界点。房间里的空气被彻底抽干，又在瞬间被压缩、电离。所有未被固定的物体都漂浮起来，环绕着我，环绕着那个已经成为纯粹能量漩涡的臀部，疯狂旋转。墙壁出现裂纹，灯管炸裂成粉末。我感到自己的身体在瓦解，不是疼痛，而是一种被绝对力量从分子层面撕裂的虚无感。然后，是寂静。极致的喧嚣坍缩成的、令人灵魂冻结的寂静。紧接着——“咻——————！！！”突破音障的尖锐爆鸣。不是从耳朵传入，而是直接从我的骨骼、我的脑髓深处炸开。视野被纯白充斥。在那毁灭性的白光中，我最后“看”到的，是我的臀部，我身体的一部分，连同那肆虐的涡轮风暴，在一阵无法形容的璀璨迸发中，彻底分解，化为最细微的、闪烁着星光的尘埃——星际尘埃。它们旋转着，扩散着，带着我最后一缕意识，飘散在已然不存在的房间空气中。白光褪去。轰鸣消失。一切都静止了。我……我还站着？不，没有实体感。只有视觉残存，如同幽灵俯瞰着灾难现场。原本是房间的地方，只剩一片空荡的狼藉，中央地板上，是一个完美圆形的灼刻图案，边缘光滑如镜，深入混凝土数寸，图案纹理复杂，仿佛某种异星文明的符印，散发着微弱的热辐射与……一种难以言喻的、混合了硫磺、臭氧与过度思考后的虚无感的哲学气息，袅袅弥漫。隔壁的砸门声，再也没有响起")
end)

Button(Tabjb, "之前的墨水不知道还能用不能", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/-v91/refs/heads/main/%E5%A2%A8%E6%B0%B4%E5%B0%8F%E6%BA%AA%E8%84%9A%E6%9C%AC.lua"))() 
end)

Button(Tabjb, "dig服务器", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/dig.lua"))() 
end)

Button(Tabjb, "刀刃球", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E5%88%80%E5%88%83%E7%90%83.lua"))() 
end)

Button(Tabjb, "植物大战脑红", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%A4%8D%E7%89%A9%E5%A4%A7%E6%88%98%E8%84%91%E7%BA%A2.lua"))() 
end)

Button(Tabjb, "力量传奇", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E5%8A%9B%E9%87%8F%E4%BC%A0%E5%A5%87.lua"))() 
end)

Button(Tabjb, "在超市一周", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E5%9C%A8%E8%B6%85%E5%B8%82%E7%94%9F%E6%B4%BB%E4%B8%80%E5%91%A8.lua"))() 
end)

Button(Tabjb, "建造你的基地", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E5%BB%BA%E9%80%A0%E4%BD%A0%E7%9A%84%E5%9F%BA%E5%9C%B0.lua"))() 
end)

Button(Tabjb, "恶魔学", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%81%B6%E9%AD%94%E5%AD%A6.lua"))() 
end)

Button(Tabjb, "成为乞丐", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%88%90%E4%B8%BA%E4%B9%9E%E4%B8%90.lua"))() 
end)

Button(Tabjb, "战争大亨", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%88%98%E4%BA%89%E5%A4%A7%E4%BA%A8.lua"))() 
end)

Button(Tabjb, "极速传奇", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))() 
end)

Button(Tabjb, "汽车营销", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%B1%BD%E8%BD%A6%E8%90%A5%E9%94%80%E5%A4%A7%E4%BA%A8.lua"))() 
end)

Button(Tabjb, "河北唐县", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E6%A8%A1%E4%BB%BF%E8%80%85.lua"))() 
end)

Button(Tabjb, "🚀发射模拟器", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%81%AB%E7%AE%AD%E5%8F%91%E5%B0%84%E6%A8%A1%E6%8B%9F%E5%99%A8.lua"))() 
end)

Button(Tabjb, "矿井", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%9F%BF%E4%BA%95.lua"))() 
end)

Button(Tabjb, "77汉堡🤓", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%B4%A7%E6%80%A5%E6%B1%89%E5%A0%A1.lua"))() 
end)

Button(Tabjb, "躲避", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E8%BA%B2%E9%81%BF.lua"))() 
end)

Button(Tabjb, "掉鱼模拟器", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E9%92%93%E9%B1%BC%E6%A8%A1%E6%8B%9F%E5%99%A8.lua"))() 
end)

Button(Tabjb, "隐藏或死亡", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E9%9A%90%E8%97%8F%E6%88%96%E6%AD%BB%E4%BA%A1.lua"))() 
end)

Button(Tabjb, "鱼", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E9%B1%BC.lua"))() 
end)
Button(Tabjb, "XIAOXI自瞄推荐闪光", function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E5%B0%8F%E8%A5%BF%E8%87%AA%E7%9E%84.lua"))() 
end)

Tabjb:Button({
    Title = "执行脚本并关闭",
    Callback = function()
    local originalUI = WindUI:Unload()
        ---↓↓↓↓↓服务器源码
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local cloneref = cloneref or function(instance) return instance end

local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        if RunService:IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()
        end
    end
end

local ESPEnabled = false
local ESP_ScreenGui = nil
local ESPFolder = nil
local ESPNameColor = Color3.fromRGB(0, 255, 127)
local ESPBodyColor = Color3.fromRGB(0, 255, 127)
local ESPNameSize = 14
local ESPRainbowEnabled = false
local ESPRainbowSpeed = 5
local CurrentESPHue = 0
local ESPTeamCheck = false

local BackstabCheckEnabled = false
local BackstabCooldown = 0
local BACKSTAB_COOLDOWN_TIME = 3
local DeathCheckEnabled = false

local InfiniteJumpEnabled = false
local JumpConnection = nil
local SpeedEnabled = false
local SpeedValue = 1
local SpeedConnection = nil
local GravityLoop = nil
local originalGravity = workspace.Gravity

local NightVisionEnabled = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

local RainbowUIEnabled = false
local RainbowUIScreenGui = nil
local StatusIndicator = nil
local animationConnection = nil

local AimSettings = {
    Enabled = false,
    FOV = 100,
    Smoothness = 10,
    CrosshairDistance = 5,
    FOVColor = Color3.fromRGB(0, 255, 0),
    FriendCheck = true,
    WallCheck = true,
    TargetPlayer = nil,
    TargetAll = true,
    FOVRainbowEnabled = true,
    FOVRainbowSpeed = 8,
    FOVEnabled = true
}

local DrawingObjects = {}
local AimConnection = nil
local FOVCircle = nil
local TargetPlayers = {}
local CurrentFOVHue = 0
local CurrentTarget = nil

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

local AimBlacklist = {}
local AimTeamCheck = false
local AimTargetPart = "头"
local ESPMaxDistance = 1000

local blacklistInput

local function GetRainbowColor(hue)
    hue = hue % 1
    local r, g, b
    local i = math.floor(hue * 6)
    local f = hue * 6 - i
    local p = 1
    local q = 1 - f
    local t = f
    if i % 6 == 0 then r, g, b = 1, t, p
    elseif i % 6 == 1 then r, g, b = q, 1, p
    elseif i % 6 == 2 then r, g, b = p, 1, t
    elseif i % 6 == 3 then r, g, b = p, q, 1
    elseif i % 6 == 4 then r, g, b = t, p, 1
    else r, g, b = 1, p, q end
    return Color3.new(r, g, b)
end

local function InitESP()
    ESP_ScreenGui = Instance.new("ScreenGui")
    ESP_ScreenGui.Name = "PlayerESP_System"
    ESP_ScreenGui.ResetOnSpawn = false
    ESP_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ESP_ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "PlayerESPFolder"
    ESPFolder.Parent = ESP_ScreenGui
end

local function UpdateESPColors()
    if not ESPEnabled or not ESPFolder then return end
    pcall(function()
        for _, child in ipairs(ESPFolder:GetChildren()) do
            if child:IsA("BillboardGui") then
                local nameLabel = child:FindFirstChild("NameLabel")
                if nameLabel then
                    nameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
                    nameLabel.TextSize = ESPNameSize
                end
            elseif child:IsA("Highlight") then
                child.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
                child.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
            end
        end
    end)
end

local function UpdateESPNameSize()
    if not ESPEnabled or not ESPFolder then return end
    pcall(function()
        for _, child in ipairs(ESPFolder:GetChildren()) do
            if child:IsA("BillboardGui") then
                local nameLabel = child:FindFirstChild("NameLabel")
                if nameLabel then
                    nameLabel.TextSize = ESPNameSize
                end
            end
        end
    end)
end

local function CreatePlayerESP(player)
    if player == LocalPlayer or not ESPEnabled then return end
    pcall(function()
        local character = player.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        local existingESP = ESPFolder:FindFirstChild(player.Name)
        if existingESP then existingESP:Destroy() end
        local ESPGui = Instance.new("BillboardGui")
        ESPGui.Name = player.Name
        ESPGui.Adornee = humanoidRootPart
        ESPGui.Size = UDim2.new(0, 100, 0, 40)
        ESPGui.StudsOffset = Vector3.new(0, 3, 0)
        ESPGui.AlwaysOnTop = true
        ESPGui.MaxDistance = 10000
        ESPGui.Enabled = true
        ESPGui.Parent = ESPFolder
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextSize = ESPNameSize
        NameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
        NameLabel.TextStrokeTransparency = 0.5
        NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        NameLabel.Text = player.Name
        NameLabel.Parent = ESPGui
        local DistanceLabel = Instance.new("TextLabel")
        DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.TextSize = 12
        DistanceLabel.TextColor3 = Color3.fromRGB(240, 255, 245)
        DistanceLabel.TextStrokeTransparency = 0.5
        DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        DistanceLabel.Name = "DistanceLabel"
        DistanceLabel.Parent = ESPGui
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name .. "_Highlight"
        Highlight.Adornee = character
        Highlight.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        Highlight.FillTransparency = 0.7
        Highlight.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Enabled = true
        Highlight.Parent = ESPFolder
    end)
end

local function CheckBackstabThreat()
    if not BackstabCheckEnabled then return end
    if BackstabCooldown > 0 then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myPosition = myHRP.Position
        local myCFrame = myHRP.CFrame
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if hrp and humanoid and humanoid.Health > 0 then
                    local enemyPosition = hrp.Position
                    local distance = (myPosition - enemyPosition).Magnitude
                    if distance < 30 then
                        local toEnemy = (enemyPosition - myPosition).Unit
                        local myForward = myCFrame.LookVector
                        local dotProduct = toEnemy:Dot(myForward)
                        if dotProduct < 0.5 then
                            WindUI:Notify({
                                Title = "有傻逼瞄你",
                                Content = "😒：" .. player.Name,
                                Icon = "alert-triangle",
                                Color = Color3.fromRGB(255, 100, 100),
                                Duration = 5
                            })
                            BackstabCooldown = BACKSTAB_COOLDOWN_TIME
                            break
                        end
                    end
                end
            end
        end
    end)
end

local function SetupDeathDetection()
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        pcall(function()
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                if DeathCheckEnabled then
                    WindUI:Notify({
                        Title = "死亡提醒",
                        Content = "孩子重开吧😒",
                        Icon = "skull",
                        Color = Color3.fromRGB(255, 0, 0),
                        Duration = 8
                    })
                end
            end)
        end)
    end)
    if LocalPlayer.Character then
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    if DeathCheckEnabled then
                        WindUI:Notify({
                            Title = "死亡提醒",
                            Content = "孩子重开吧😒",
                            Icon = "skull",
                            Color = Color3.fromRGB(255, 0, 0),
                            Duration = 8
                        })
                    end
                end)
            end
        end)
    end
end

local function UpdateESP()
    if not ESPEnabled then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if not espGui then
                            CreatePlayerESP(player)
                            espGui = ESPFolder:FindFirstChild(player.Name)
                        end
                        if espGui then
                            local distance = (myHRP.Position - hrp.Position).Magnitude
                            local distanceLabel = espGui:FindFirstChild("DistanceLabel")
                            if distanceLabel then
                                distanceLabel.Text = string.format("%.0f studs", distance)
                            end
                            if distance > ESPMaxDistance then
                                espGui.Enabled = false
                                local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                if highlight then highlight.Enabled = false end
                            else
                                local teamHide = false
                                if ESPTeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
                                    teamHide = true
                                end
                                if teamHide then
                                    espGui.Enabled = false
                                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                    if highlight then highlight.Enabled = false end
                                else
                                    espGui.Enabled = true
                                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                    if highlight then highlight.Enabled = true end
                                end
                            end
                        end
                    else
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if espGui then espGui:Destroy() end
                        local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                        if highlight then highlight:Destroy() end
                    end
                else
                    local esp = ESPFolder:FindFirstChild(player.Name)
                    if esp then esp:Destroy() end
                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end)
end

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        pcall(function()
            if not ESP_ScreenGui then InitESP() end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreatePlayerESP(player)
                end
            end
            WindUI:Notify({
                Title = "透视",
                Content = "玩家透视已开启",
                Icon = "eye",
            })
        end)
    else
        pcall(function()
            if ESPFolder then
                for _, esp in ipairs(ESPFolder:GetChildren()) do
                    esp:Destroy()
                end
            end
            WindUI:Notify({
                Title = "透视",
                Content = "玩家透视已关闭",
                Icon = "eye",
            })
        end)
    end
end

InitESP()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if ESPEnabled then
        pcall(function()
            if ESPFolder then
                for _, esp in ipairs(ESPFolder:GetChildren()) do
                    esp:Destroy()
                end
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreatePlayerESP(player)
                end
            end
        end)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            pcall(function()
                CreatePlayerESP(player)
            end)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    pcall(function()
        if ESPFolder then
            local espGui = ESPFolder:FindFirstChild(player.Name)
            if espGui then espGui:Destroy() end
            local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
            if highlight then highlight:Destroy() end
        end
        if CurrentTarget == player then
            CurrentTarget = nil
        end
        for i, name in ipairs(AimBlacklist) do
            if name == player.Name then
                table.remove(AimBlacklist, i)
                break
            end
        end
        if blacklistInput and blacklistInput.SetValue then
            blacklistInput:SetValue(table.concat(AimBlacklist, ", "))
        end
    end)
end)

local function heartBeatLoop(deltaTime)
    pcall(function()
        UpdateESP()
        if ESPRainbowEnabled then
            CurrentESPHue = CurrentESPHue + deltaTime * ESPRainbowSpeed / 10
            UpdateESPColors()
        end
        if BackstabCooldown > 0 then
            BackstabCooldown = BackstabCooldown - deltaTime
        end
        CheckBackstabThreat()
    end)
end

RunService.Heartbeat:Connect(heartBeatLoop)

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
    Icon = "rbxassetid://4483362748",
    IconTransparency = 1,
    Author = "by小西",
    Folder = "XIAOXI",
    Size = UDim2.fromOffset(200, 395),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/Video_1773198954709_764.mp4",
    ScrollBarEnabled = true
})

Window:Tag({
    Title = "闪光",
    Color = Color3.fromHex("FF69B4")
})
Window:Tag({
    Title = "v1.0.0",
    Color = Color3.fromHex("FFB6C1")
})



WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)  
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)  

local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    
    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame
    
    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet
    
    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule
    
    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local themes_list = {"Dark", "Light", "Mocha", "Aqua"}
    currentThemeIndex = (currentThemeIndex % #themes_list) + 1
    local newTheme = themes_list[currentThemeIndex]
    WindUI:SetTheme(newTheme)
    WindUI:Notify({
        Title = "主题已切换",
        Content = "当前主题: "..newTheme,
        Duration = 2
    })
end, 990)

WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))
    }), "palette"},
    
    ["樱花粉1"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))
    }), "candy"},

    ["樱花粉2"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FED0E0")),
        ColorSequenceKeypoint.new(0.2, Color3.fromHex("FDBAD2")),
        ColorSequenceKeypoint.new(0.4, Color3.fromHex("FCA5C5")),
        ColorSequenceKeypoint.new(0.6, Color3.fromHex("FB8FB7")),
        ColorSequenceKeypoint.new(0.8, Color3.fromHex("FA7AA9")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("F9649B"))
    }), "waves"},
}

Window:EditOpenButton({
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
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

local function createRainbowBorder(window, colorScheme, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        existingStroke:Destroy()
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or "樱花粉2"]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["樱花粉2"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    
    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

local PlayerTab = Window:Tab({  
    Title = "本地玩家",  
    Icon = "crown",  
    Locked = false,
})

do
    PlayerTab:Section({
        Title = "主要功能",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    PlayerTab:Toggle({
        Title = "无限跳跃",
        Desc = "启用后可以无限跳跃",
        Callback = function(enabled)
            InfiniteJumpEnabled = enabled
            if enabled then
                if JumpConnection then
                    JumpConnection:Disconnect()
                end
                JumpConnection = UserInputService.JumpRequest:Connect(function()
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid:ChangeState("Jumping")
                        end
                    end)
                end)
                WindUI:Notify({
                    Title = "无限跳跃",
                    Content = "已开启无限跳跃",
                    Icon = "jump-rope",
                })
            else
                if JumpConnection then
                    JumpConnection:Disconnect()
                    JumpConnection = nil
                end
                WindUI:Notify({
                    Title = "无限跳跃",
                    Content = "已关闭无限跳跃",
                    Icon = "jump-rope",
                })
            end
        end
    })
    PlayerTab:Space()
    PlayerTab:Input({
        Title = "设置重力",
        Desc = "输入重力值 (默认:196" .. tostring(originalGravity) .. ")",
        Placeholder = "输入重力值",
        Callback = function(value)
            local numValue = tonumber(value)
            if numValue then
                if GravityLoop then
                    GravityLoop:Disconnect()
                    GravityLoop = nil
                end
                workspace.Gravity = numValue
                WindUI:Notify({
                    Title = "重力设置",
                    Content = "重力已设置为: " .. tostring(numValue),
                    Icon = "weight",
                })
            else
                WindUI:Notify({
                    Title = "本脚本为免费",
                    Content = "协助者：凌乱",
                    Icon = "alert-circle",
                    Color = Red,
                })
            end
        end
    })
    PlayerTab:Space()
    PlayerTab:Input({
        Title = "设置快速跑步速度",
        Desc = "输入速度 (默认: 1)",
        Placeholder = "输入速度",
        Callback = function(value)
            local numValue = tonumber(value)
            if numValue then
                SpeedValue = numValue
                WindUI:Notify({
                    Title = "速度设置",
                    Content = "速度已设置为: " .. tostring(numValue) .. "速度",
                    Icon = "zap",
                })
            else
                WindUI:Notify({
                    Title = "欢迎使用XIAOXI",
                    Content = "本服务器为闪光",
                    Icon = "alert-circle",
                    Color = Red,
                })
            end
        end
    })
    PlayerTab:Toggle({
        Title = "开启快速跑步",
        Desc = "启用快速跑步功能",
        Callback = function(enabled)
            SpeedEnabled = enabled
            if enabled then
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                end
                SpeedConnection = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local player = LocalPlayer
                        local char = player.Character
                        if char and char:FindFirstChild("Humanoid") then
                            local humanoid = char.Humanoid
                            if humanoid.MoveDirection.Magnitude > 0 then
                                char:TranslateBy(humanoid.MoveDirection * SpeedValue / 2)
                            end
                        end
                    end)
                end)
            else
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                    SpeedConnection = nil
                end
            end
        end
    })
end

local AimTab = Window:Tab({  
    Title = "自瞄设置",  
    Icon = "crown",  
    Locked = false,
})

local function InitializeAimDrawings()
    pcall(function()
        if not FOVCircle then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Thickness = 2
            FOVCircle.Filled = false
            FOVCircle.Radius = AimSettings.FOV
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
            table.insert(DrawingObjects, FOVCircle)
        end
    end)
end

local function UpdateFOVCircle()
    pcall(function()
        if FOVCircle then
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Radius = AimSettings.FOV
            if AimSettings.FOVRainbowEnabled then
                FOVCircle.Color = GetRainbowColor(CurrentFOVHue)
            else
                FOVCircle.Color = AimSettings.FOVColor
            end
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        end
    end)
end

local function CleanupDrawings()
    pcall(function()
        for _, drawing in ipairs(DrawingObjects) do
            if drawing then
                drawing:Remove()
            end
        end
        DrawingObjects = {}
        FOVCircle = nil
    end)
end

local function IsFriend(player)
    if not AimSettings.FriendCheck then
        return false
    end
    local success, result = pcall(function()
        if LocalPlayer:IsFriendsWith(player.UserId) then
            return true
        end
        return false
    end)
    return success and result
end

local function WallCheck(targetPosition, targetCharacter)
    if not AimSettings.WallCheck then
        return true
    end
    local success, result = pcall(function()
        local camera = workspace.CurrentCamera
        local origin = camera.CFrame.Position
        local direction = (targetPosition - origin).Unit
        local distance = (targetPosition - origin).Magnitude
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true
        raycastParams.CollisionGroup = "Default"
        local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
        return raycastResult == nil
    end)
    return success and result
end

local function GetTargetPosition(character, partName)
    if not character then return nil end
    local part
    if partName == "头" then
        part = character:FindFirstChild("Head")
    elseif partName == "上身" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif partName == "左腿" then
        part = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("LeftUpperLeg")
    elseif partName == "右腿" then
        part = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("RightUpperLeg")
    elseif partName == "裆部" then
        part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso")
    elseif partName == "胸部" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    else
        part = character:FindFirstChild("Head")
    end
    return part and part.Position
end

local function GetClosestPlayer()
    local camera = workspace.CurrentCamera
    local mousePos = camera.ViewportSize / 2
    local nearestPlayer = nil
    local shortestDistance = AimSettings.FOV

    if AimSettings.TargetPlayer and not AimSettings.TargetAll then
        local target = Players:FindFirstChild(AimSettings.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if target.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and target.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local humanoid = target.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance <= AimSettings.FOV and WallCheck(targetPos, target.Character) then
                            if not AimSettings.FriendCheck or not IsFriend(target) then
                                CurrentTarget = target
                                return target
                            end
                        end
                    end
                end
            end
        end
        CurrentTarget = nil
        return nil
    end

    if CurrentTarget and CurrentTarget ~= LocalPlayer and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
        if hrp and humanoid and humanoid.Health > 0 then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if CurrentTarget.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and CurrentTarget.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance <= AimSettings.FOV and WallCheck(hrp.Position, CurrentTarget.Character) then
                        if not AimSettings.FriendCheck or not IsFriend(CurrentTarget) then
                            return CurrentTarget
                        end
                    end
                end
            end
        end
    end

    CurrentTarget = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local skip = false
            if AimSettings.FriendCheck and IsFriend(player) then
                skip = true
            end
            if not skip then
                for _, blackName in ipairs(AimBlacklist) do
                    if player.Name == blackName then
                        skip = true
                        break
                    end
                end
            end
            if not skip then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and player.Team == myTeam then
                        skip = true
                    end
                end
            end
            if not skip then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    if WallCheck(humanoidRootPart.Position, player.Character) then
                        local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    if nearestPlayer then
        CurrentTarget = nearestPlayer
    end
    return nearestPlayer
end

local function AimBot()
    if not AimSettings.Enabled then
        return
    end
    pcall(function()
        local camera = workspace.CurrentCamera
        local target = GetClosestPlayer()
        if target and target.Character then
            local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
            local head = target.Character:FindFirstChild("Head")
            local targetPosition = GetTargetPosition(target.Character, AimTargetPart) or (head and head.Position) or (humanoidRootPart and humanoidRootPart.Position)
            if not targetPosition then return end
            if humanoidRootPart then
                local targetVelocity = humanoidRootPart.Velocity
                if AimSettings.CrosshairDistance > 0 then
                    local distance = (targetPosition - camera.CFrame.Position).Magnitude
                    local timeToTarget = distance / 1000
                    targetPosition = targetPosition + (targetVelocity * timeToTarget * AimSettings.CrosshairDistance)
                end
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
            local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / AimSettings.Smoothness)
            camera.CFrame = smoothedCFrame
        end
    end)
end

local function CreateRainbowUI()
    if RainbowUIScreenGui then
        RainbowUIScreenGui:Destroy()
        RainbowUIScreenGui = nil
    end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    RainbowUIScreenGui = Instance.new("ScreenGui")
    RainbowUIScreenGui.Name = "RainbowCircleUI"
    RainbowUIScreenGui.ResetOnSpawn = false
    RainbowUIScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    RainbowUIScreenGui.DisplayOrder = 99999
    RainbowUIScreenGui.IgnoreGuiInset = true
    RainbowUIScreenGui.Enabled = true
    RainbowUIScreenGui.Parent = playerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "RainbowCircle"
    mainFrame.Size = UDim2.new(0, 80, 0, 80)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundTransparency = 1
    mainFrame.ZIndex = 100000
    mainFrame.Parent = RainbowUIScreenGui
    mainFrame.Active = true
    mainFrame.Selectable = true
    mainFrame.Draggable = false
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = mainFrame
    local rainbowBackground = Instance.new("Frame")
    rainbowBackground.Name = "RainbowBackground"
    rainbowBackground.Size = UDim2.new(1, 0, 1, 0)
    rainbowBackground.Position = UDim2.new(0, 0, 0, 0)
    rainbowBackground.BackgroundTransparency = 0
    rainbowBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    rainbowBackground.ZIndex = 100001
    rainbowBackground.Parent = mainFrame
    rainbowBackground.Active = true
    rainbowBackground.Selectable = true
    local rainbowCorner = Instance.new("UICorner")
    rainbowCorner.CornerRadius = UDim.new(1, 0)
    rainbowCorner.Parent = rainbowBackground
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Color = Color3.fromRGB(255, 255, 255)
    rainbowStroke.Thickness = 3
    rainbowStroke.Transparency = 0
    rainbowStroke.Parent = mainFrame
    local innerStroke = Instance.new("UIStroke")
    innerStroke.Name = "InnerStroke"
    innerStroke.Color = Color3.fromRGB(0, 0, 0)
    innerStroke.Thickness = 1
    innerStroke.Transparency = 0.3
    innerStroke.Parent = rainbowBackground
    StatusIndicator = Instance.new("Frame")
    StatusIndicator.Name = "StatusIndicator"
    StatusIndicator.Size = UDim2.new(0, 15, 0, 15)
    StatusIndicator.Position = UDim2.new(1, -18, 1, -18)
    StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusIndicator.BackgroundTransparency = 0
    StatusIndicator.ZIndex = 100002
    StatusIndicator.Parent = mainFrame
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = StatusIndicator
    local indicatorStroke = Instance.new("UIStroke")
    indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
    indicatorStroke.Thickness = 2
    indicatorStroke.Parent = StatusIndicator
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 25)
    statusText.Position = UDim2.new(0, 0, 1, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextStrokeTransparency = 0.3
    statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statusText.TextStrokeTransparency = 0.3
    statusText.ZIndex = 100002
    statusText.Parent = mainFrame
    local clickArea = Instance.new("TextButton")
    clickArea.Name = "ClickArea"
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.Position = UDim2.new(0, 0, 0, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 100003
    clickArea.Parent = mainFrame
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 95, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(144, 238, 144),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 200, 200),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(148, 0, 211),
        Color3.fromRGB(199, 21, 133),
        Color3.fromRGB(255, 20, 147)
    }
    local rainbowColors2 = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(148, 0, 211)
    }
    local timeOffset = 0
    local hoverAmplitude = 4
    local hoverSpeed = 4
    local pulseSpeed = 2
    local pulseAmount = 0.1
    local colorIndex = 1
    local colorIndex2 = 3
    local transitionTime = 0.8
    local transitionTime2 = 0.5
    local elapsedTime = 0
    local elapsedTime2 = 0
    local pulseScale = 1
    local isPulsingOut = true
    if animationConnection then
        animationConnection:Disconnect()
    end
    animationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        pcall(function()
            if not RainbowUIEnabled or not RainbowUIScreenGui or not RainbowUIScreenGui.Parent then
                animationConnection:Disconnect()
                animationConnection = nil
                return
            end
            elapsedTime = elapsedTime + deltaTime
            if elapsedTime >= transitionTime then
                elapsedTime = 0
                colorIndex = colorIndex + 1
                if colorIndex > #rainbowColors then
                    colorIndex = 1
                end
            end
            local nextColorIndex = colorIndex + 1
            if nextColorIndex > #rainbowColors then
                nextColorIndex = 1
            end
            local alpha = elapsedTime / transitionTime
            local currentBgColor = rainbowColors[colorIndex]:Lerp(rainbowColors[nextColorIndex], alpha)
            rainbowBackground.BackgroundColor3 = currentBgColor
            elapsedTime2 = elapsedTime2 + deltaTime
            if elapsedTime2 >= transitionTime2 then
                elapsedTime2 = 0
                colorIndex2 = colorIndex2 + 1
                if colorIndex2 > #rainbowColors2 then
                    colorIndex2 = 1
                end
            end
            local nextColorIndex2 = colorIndex2 + 1
            if nextColorIndex2 > #rainbowColors2 then
                nextColorIndex2 = 1
            end
            local alpha2 = elapsedTime2 / transitionTime2
            local currentStrokeColor = rainbowColors2[colorIndex2]:Lerp(rainbowColors2[nextColorIndex2], alpha2)
            rainbowStroke.Color = currentStrokeColor
            if isPulsingOut then
                pulseScale = pulseScale + deltaTime * pulseSpeed * pulseAmount
                if pulseScale >= 1 + pulseAmount then
                    isPulsingOut = false
                end
            else
                pulseScale = pulseScale - deltaTime * pulseSpeed * pulseAmount
                if pulseScale <= 1 - pulseAmount then
                    isPulsingOut = true
                end
            end
            rainbowBackground.Size = UDim2.new(pulseScale, 0, pulseScale, 0)
            rainbowBackground.Position = UDim2.new((1 - pulseScale) / 2, 0, (1 - pulseScale) / 2, 0)
            timeOffset = timeOffset + deltaTime * hoverSpeed
            local hoverOffset = math.sin(timeOffset) * hoverAmplitude
            mainFrame.Position = UDim2.new(0, 10, 0, 10 + hoverOffset)
            innerStroke.Transparency = 0.2 + 0.3 * math.sin(timeOffset * 2)
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
            if statusText then
                statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
                statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
            end
        end)
    end)
    local function handleClick()
        AimSettings.Enabled = not AimSettings.Enabled
        if AimSettings.Enabled then
            InitializeAimDrawings()
            UpdateFOVCircle()
            if AimConnection then
                AimConnection:Disconnect()
            end
            AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                pcall(function()
                    if AimSettings.FOVRainbowEnabled then
                        CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                    end
                    UpdateFOVCircle()
                    AimBot()
                end)
            end)
        else
            if AimConnection then
                AimConnection:Disconnect()
                AimConnection = nil
            end
            CleanupDrawings()
            CurrentTarget = nil
        end
        if StatusIndicator then
            StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        if statusText then
            statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
            statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
        local originalSize = rainbowBackground.Size
        local originalPosition = rainbowBackground.Position
        local tweenInfo1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local clickScaleUp = TweenService:Create(rainbowBackground, tweenInfo1, {
            Size = originalSize * 0.7,
            Position = UDim2.new(0.15, 0, 0.15, 0)
        })
        local clickScaleDown = TweenService:Create(rainbowBackground, tweenInfo2, {
            Size = originalSize,
            Position = originalPosition
        })
        local originalStrokeColor = rainbowStroke.Color
        local flashTween = TweenService:Create(rainbowStroke, tweenInfo1, {
            Color = Color3.fromRGB(255, 255, 255)
        })
        local revertStroke = TweenService:Create(rainbowStroke, tweenInfo2, {
            Color = originalStrokeColor
        })
        clickScaleUp:Play()
        flashTween:Play()
        clickScaleUp.Completed:Connect(function()
            clickScaleDown:Play()
            revertStroke:Play()
        end)
    end
    clickArea.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 6
        })
        pulseAmount = 0.15
        tween1:Play()
    end)
    mainFrame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 3
        })
        pulseAmount = 0.1
        tween1:Play()
    end)
    rainbowBackground.BackgroundTransparency = 1
    rainbowStroke.Transparency = 1
    local fadeIn = TweenService:Create(rainbowBackground, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    })
    local strokeFadeIn = TweenService:Create(rainbowStroke, TweenInfo.new(0.5), {
        Transparency = 0
    })
    task.wait(0.2)
    fadeIn:Play()
    strokeFadeIn:Play()
    return true
end

local function ToggleRainbowUI(state)
    RainbowUIEnabled = state
    if state then
        local success = CreateRainbowUI()
        if success then
            WindUI:Notify({
                Title = "自瞄快捷UI",
                Content = "快捷UI 让你秒人更加高效",
                Icon = "sparkles",
            })
        end
    else
        if RainbowUIScreenGui then
            RainbowUIScreenGui:Destroy()
            RainbowUIScreenGui = nil
        end
        WindUI:Notify({
            Title = "自瞄快捷UI",
            Content = "快捷UI已隐藏",
            Icon = "sparkles",
        })
    end
end

do
    AimTab:Section({
        Title = "自瞄设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Toggle({
        Title = "启用自瞄",
        Desc = "开启/关闭自瞄功能",
        Callback = function(enabled)
            AimSettings.Enabled = enabled
            if enabled then
                InitializeAimDrawings()
                UpdateFOVCircle()
                if AimConnection then
                    AimConnection:Disconnect()
                end
                AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    pcall(function()
                        if AimSettings.FOVRainbowEnabled then
                            CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                        end
                        UpdateFOVCircle()
                        AimBot()
                    end)
                end)
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已开启",
                    Icon = "crosshair",
                })
            else
                if AimConnection then
                    AimConnection:Disconnect()
                    AimConnection = nil
                end
                CleanupDrawings()
                CurrentTarget = nil
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已关闭",
                    Icon = "crosshair",
                })
            end
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "自瞄快捷UI",
        Desc = "快捷UI 让你秒人更加高效",
        Callback = function(enabled)
            ToggleRainbowUI(enabled)
        end
    })
    AimTab:Toggle({
        Title = "FOV开关",
        Desc = "显示自瞄范围圆圈",
        Value = AimSettings.FOVEnabled,
        Callback = function(enabled)
            AimSettings.FOVEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Toggle({
        Title = "FOV彩虹效果",
        Desc = "开启FOV圆圈彩虹效果",
        Value = AimSettings.FOVRainbowEnabled,
        Callback = function(enabled)
            AimSettings.FOVRainbowEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Slider({
        Title = "FOV彩虹速度",
        Desc = "调整彩虹流动的速度",
        Value = {
            Min = 1,
            Max = 20,
            Default = AimSettings.FOVRainbowSpeed,
        },
        Callback = function(value)
            AimSettings.FOVRainbowSpeed = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄范围 (FOV)",
        Desc = "设置自瞄FOV大小",
        Value = {
            Min = 50,
            Max = 500,
            Default = AimSettings.FOV,
        },
        Callback = function(value)
            AimSettings.FOV = value
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄平滑度",
        Desc = "数值越小越强锁",
        Value = {
            Min = 1,
            Max = 50,
            Default = AimSettings.Smoothness,
        },
        Callback = function(value)
            AimSettings.Smoothness = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "预判距离",
        Desc = "设置预判距离(需要强锁直接调到0-3)",
        Value = {
            Min = 0,
            Max = 20,
            Default = AimSettings.CrosshairDistance,
        },
        Callback = function(value)
            AimSettings.CrosshairDistance = value
        end
    })
    AimTab:Space()
    AimTab:Colorpicker({
        Title = "FOV圆圈颜色",
        Desc = "彩虹模式关闭时生效",
        Default = AimSettings.FOVColor,
        Callback = function(color)
            AimSettings.FOVColor = color
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "好友检测",
        Desc = "不秒好友",
        Value = AimSettings.FriendCheck,
        Callback = function(enabled)
            AimSettings.FriendCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "墙壁检测",
        Desc = "开启墙壁检测 避免自瞄乱飞",
        Value = AimSettings.WallCheck,
        Callback = function(enabled)
            AimSettings.WallCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "队伍检测",
        Desc = "不攻击同队队友",
        Value = AimTeamCheck,
        Callback = function(enabled)
            AimTeamCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "目标自瞄模式",
        Desc = "开启后可以选择目标进行制裁",
        Value = false,
        Callback = function(enabled)
            AimSettings.TargetAll = not enabled
            CurrentTarget = nil
        end
    })
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    local targetDropdown = AimTab:Dropdown({
        Title = "选择目标玩家",
        Desc = "选择要自瞄的玩家",
        Values = playerList,
        Value = nil,
        AllowNone = true,
        Callback = function(selected)
            AimSettings.TargetPlayer = selected
            CurrentTarget = nil
        end
    })
    Players.PlayerAdded:Connect(function(player)
        table.insert(playerList, player.Name)
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        for i, name in ipairs(playerList) do
            if name == player.Name then
                table.remove(playerList, i)
                break
            end
        end
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    AimTab:Space()
    AimTab:Section({
        Title = "自瞄部位设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Dropdown({
        Title = "自瞄部位",
        Desc = "选择要瞄准的身体部位",
        Values = {"头", "上身", "左腿", "右腿", "鸡巴", "奶子"},
        Value = AimTargetPart,
        Callback = function(selected)
            AimTargetPart = selected
        end
    })
    AimTab:Space()
    AimTab:Section({
        Title = "黑名单管理",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    blacklistInput = AimTab:Input({
        Title = "自瞄黑名单",
        Desc = "输入不攻击的玩家名字，多个用逗号分隔",
        Placeholder = "例如: Player1,Player2,Player3",
        Callback = function(value)
            local names = {}
            for name in string.gmatch(value, "[^,]+") do
                name = name:match("^%s*(.-)%s*$")
                if name ~= "" then
                    table.insert(names, name)
                end
            end
            AimBlacklist = names
        end
    })
    AimTab:Button({
        Title = "添加当前目标到黑名单",
        Justify = "Center",
        Callback = function()
            if CurrentTarget and CurrentTarget.Name then
                local targetName = CurrentTarget.Name
                for _, name in ipairs(AimBlacklist) do
                    if name == targetName then
                        WindUI:Notify({
                            Title = "黑名单",
                            Content = targetName .. " 已在黑名单中",
                            Icon = "info",
                        })
                        return
                    end
                end
                table.insert(AimBlacklist, targetName)
                local newValue = table.concat(AimBlacklist, ", ")
                if blacklistInput and blacklistInput.SetValue then
                    blacklistInput:SetValue(newValue)
                else
                    WindUI:Notify({
                        Title = "黑名单",
                        Content = "已添加 " .. targetName .. "，请手动更新输入框",
                        Icon = "info",
                    })
                end
            else
                WindUI:Notify({
                    Title = "黑名单",
                    Content = "没有当前目标",
                    Icon = "alert-circle",
                })
            end
        end
    })
    AimTab:Space()
    AimTab:Button({
        Title = "清空白名单",
        Justify = "Center",
        Callback = function()
            AimBlacklist = {}
            if blacklistInput and blacklistInput.SetValue then
                blacklistInput:SetValue("")
            end
            WindUI:Notify({
                Title = "黑名单",
                Content = "黑名单已清空",
                Icon = "check",
            })
        end
    })
    AimTab:Space()
    local statusText = "自瞄状态: 未启用"
    if AimSettings.Enabled then
        statusText = "自瞄状态: 已启用 模式: " .. (AimSettings.TargetAll and "全部玩家" or "目标玩家")
    end
    AimTab:Section({
        Title = statusText,
        TextSize = 14,
        FontWeight = Enum.FontWeight.Medium,
        TextColor = AimSettings.Enabled and Green or Grey,
    })
    local QuickSettings = AimTab:Group({})
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹有延迟类]",
        Desc = "FOV99 平滑1 预判0.96",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 99
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0.96
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用近距离设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹无延迟]",
        Desc = "FOV120, 平滑1 预判0",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 120
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用强锁设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 平滑类[]",
        Desc = "FOV130 平滑6 预判1",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 130
            AimSettings.Smoothness = 6
            AimSettings.CrosshairDistance = 1
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用远距离设置",
                Icon = "settings",
            })
        end
    })
end

local OtherTab = Window:Tab({  
    Title = "绘制功能",  
    Icon = "crown",  
    Locked = false,
})

do
    OtherTab:Section({
        Title = "ESP",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    OtherTab:Toggle({
        Title = "玩家透视 (ESP)",
        Desc = "显示玩家描边和距离",
        Callback = function(enabled)
            ToggleESP(enabled)
        end
    })
    OtherTab:Space()
    OtherTab:Colorpicker({
        Title = "ESP玩家名字颜色",
        Desc = "设置玩家名字显示颜色",
        Default = ESPNameColor,
        Callback = function(color)
            ESPNameColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Colorpicker({
        Title = "ESP身体绘制颜色",
        Desc = "设置玩家身体颜色",
        Default = ESPBodyColor,
        Callback = function(color)
            ESPBodyColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP玩家名字大小",
        Desc = "设置玩家名字的文本大小",
        Value = {
            Min = 8,
            Max = 24,
            Default = ESPNameSize,
        },
        Callback = function(value)
            ESPNameSize = value
            if ESPEnabled then
                UpdateESPNameSize()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "ESP彩虹渐变",
        Desc = "开启透视彩虹效果",
        Callback = function(enabled)
            ESPRainbowEnabled = enabled
            if ESPEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP彩虹速度",
        Desc = "调整彩虹的速度",
        Value = {
            Min = 1,
            Max = 10,
            Default = ESPRainbowSpeed,
        },
        Callback = function(value)
            ESPRainbowSpeed = value
        end
    })
    OtherTab:Space()
    OtherTab:Slider({
        Title = "ESP最大显示距离",
        Desc = "设置ESP显示的最大距离（单位：studs）",
        Value = {
            Min = 50,
            Max = 10000,
            Default = ESPMaxDistance,
        },
        Callback = function(value)
            ESPMaxDistance = value
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "队伍检测",
        Desc = "开启后只显示敌方队伍",
        Value = ESPTeamCheck,
        Callback = function(enabled)
            ESPTeamCheck = enabled
            if ESPEnabled then
                UpdateESP()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "偷袭检测提醒",
        Desc = "检测背后或侧面的敌人并提醒",
        Callback = function(enabled)
            BackstabCheckEnabled = enabled
            WindUI:Notify({
                Title = "偷袭检测",
                Content = enabled and "偷袭检测已开启" or "偷袭检测已关闭",
                Icon = "shield-alert",
            })
        end
    })
    OtherTab:Toggle({
        Title = "死亡提醒",
        Desc = "玩家死亡时显示提醒消息",
        Callback = function(enabled)
            DeathCheckEnabled = enabled
            if enabled then
                SetupDeathDetection()
            end
            WindUI:Notify({
                Title = "死亡提醒",
                Content = enabled and "死亡提醒已开启" or "死亡提醒已关闭",
                Icon = "heart",
            })
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "夜视模式",
        Desc = "开启夜间模式",
        Callback = function(enabled)
            NightVisionEnabled = enabled
            if enabled then
                originalBrightness = Lighting.Brightness
                originalAmbient = Lighting.Ambient
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(200, 200, 200)
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已开启",
                    Icon = "moon",
                })
            else
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = Color3.fromRGB(0.5, 0.5, 0.5)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已关闭",
                    Icon = "moon",
                })
            end
        end
    })
end

local MusicTab = Window:Tab({
    Title = "音乐库",
    Icon = "crown",
    Locked = false,
})

local activeSounds = {}
local customMusic = nil
local customMusicPlaying = false

do
    MusicTab:Section({
        Title = "音乐库",
        TextSize = 20,
        FontWeight = Enum.FontWeight.Bold,
    })
end

-- 添加按钮到音乐库标签页
MusicTab:Button({
    Title = "网易云音乐",
    Callback = function()
        print("脚本执行了")
        loadstring(game:HttpGet("       "))() 
    end
})

local KillTab = Window:Tab({  
    Title = "杀戮与主要",  
    Icon = "crown",  
    Locked = false,
})        

local originalFire = nil

KillTab:Toggle({
    Title = "子追(美国子弹)",
    Value = false,
    Callback = function(state)
        local bullet_handler = require(game:GetService("ReplicatedStorage").ModuleScripts.GunModules.BulletHandler)
        
        if state then
            if not originalFire then
                originalFire = bullet_handler.Fire
            end

            local function get_closest_target(range)
                local players = game:GetService("Players")
                local local_player = players.LocalPlayer
                local camera = workspace.CurrentCamera
                local closest_part, closest_distance = nil, range

                for _, player in ipairs(players:GetPlayers()) do
                    if player ~= local_player then
                        local character = player.Character
                        if character then
                            local humanoid = character:FindFirstChild("Humanoid")
                            local head = character:FindFirstChild("Head")
                            if head and humanoid and humanoid.Health > 0 then
                                local screen_position, on_screen = camera:WorldToViewportPoint(head.Position)
                                if on_screen then
                                    local distance = (Vector2.new(screen_position.X, screen_position.Y) - camera.ViewportSize / 2).Magnitude
                                    if distance < closest_distance then
                                        closest_part = head
                                        closest_distance = distance
                                    end
                                end
                            end
                        end
                    end
                end
                return closest_part
            end

            bullet_handler.Fire = function(data)
                local closest = get_closest_target(999)
                if closest then
                    data.Force = data.Force * 1000
                    data.Direction = (closest.Position - data.Origin).Unit
                end
                return originalFire(data)
            end
        else
            if originalFire then
                bullet_handler.Fire = originalFire
            end
        end
    end
})

local autoLobbyEnabled = false
local autoLobbyThread = nil

KillTab:Toggle({
    Title = "自动加入对战",
    Value = false,
    Callback = function(state)
        autoLobbyEnabled = state

        if state and not autoLobbyThread then
            autoLobbyThread = coroutine.wrap(function()
                while autoLobbyEnabled do
                    task.wait()

                    local ok, viewModel = pcall(function()
                        return workspace:FindFirstChild("ViewModel")
                    end)

                    if ok and viewModel == nil then
                        game:GetService("ReplicatedStorage").Remotes.Command:FireServer("Lobby")
                        task.wait(0.35)
                        game:GetService("ReplicatedStorage").Remotes.Command:FireServer("Play")
                        task.wait(0.35)
                    end
                end
                autoLobbyThread = nil
            end)

            autoLobbyThread()
        elseif not state and autoLobbyThread then
            autoLobbyThread = nil
        end
    end
})

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local currentTarget = nil
    local lastShotTime = 0
    local connection = nil

    local function getVisiblePart(targetCharacter)
        if not targetCharacter or not LocalPlayer.Character then return nil end
        local localCharacter = LocalPlayer.Character
        local humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return nil end
        local partNames = {"Head","UpperTorso","Torso","LowerTorso","HumanoidRootPart"}
        local bestPart = nil
        local bestPosition = nil
        local bestOrigin = nil
        local minDistance = math.huge
        for _, partName in ipairs(partNames) do
            local part = targetCharacter:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                local targetPosition = part.Position
                for height = 0, 10.5, 2 do
                    local startPos = humanoidRootPart.Position + Vector3.new(0, height, 0)
                    local direction = (targetPosition - startPos).Unit
                    local forwardPos = startPos + direction * 2.5
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {localCharacter, Camera}
                    rayParams.IgnoreWater = true
                    local ray = Workspace:Raycast(forwardPos, targetPosition - forwardPos, rayParams)
                    if not ray or ray.Instance:IsDescendantOf(targetCharacter) or ray.Instance.Transparency >= 0.9 then
                        local distance = (targetPosition - forwardPos).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            bestPart = part
                            bestPosition = targetPosition
                            bestOrigin = forwardPos
                        end
                    end
                end
            end
        end
        return bestPart, bestPosition, bestOrigin
    end

    local function isDead(player)
        if not player or not player.Character then return true end
        local humanoid = player.Character:FindFirstChild("Humanoid")
        return not humanoid or humanoid.Health <= 0
    end

    local function playShootSound()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://6534948092"
        sound.Volume = 1
        sound.Parent = Camera
        sound.PlayOnRemove = true
        sound:Destroy()
    end

    local function createBeam(startPos, endPos)
        local part1 = Instance.new("Part")
        part1.Anchored = true
        part1.CanCollide = false
        part1.Transparency = 1
        part1.Size = Vector3.new(0.1, 0.1, 0.1)
        part1.Position = startPos
        part1.Parent = Workspace

        local part2 = Instance.new("Part")
        part2.Anchored = true
        part2.CanCollide = false
        part2.Transparency = 1
        part2.Size = Vector3.new(0.1, 0.1, 0.1)
        part2.Position = endPos
        part2.Parent = Workspace

        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = part1
        local attachment2 = Instance.new("Attachment")
        attachment2.Parent = part2

        local beam1 = Instance.new("Beam")
        beam1.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
        beam1.Transparency = NumberSequence.new(0)
        beam1.Width0 = 0.25
        beam1.Width1 = 0.25
        beam1.Texture = "rbxassetid://7136858729"
        beam1.TextureSpeed = 0.8
        beam1.TextureMode = Enum.TextureMode.Wrap
        beam1.Brightness = 1
        beam1.LightEmission = 0
        beam1.FaceCamera = true
        beam1.Attachment0 = attachment1
        beam1.Attachment1 = attachment2
        beam1.Parent = part1

        local beam2 = Instance.new("Beam")
        beam2.Color = ColorSequence.new(Color3.fromRGB(180, 200, 255))
        beam2.Transparency = NumberSequence.new(0.4)
        beam2.Width0 = 0.12
        beam2.Width1 = 0.12
        beam2.Texture = "rbxassetid://7136858729"
        beam2.TextureSpeed = 1.2
        beam2.TextureMode = Enum.TextureMode.Wrap
        beam2.Brightness = 1.2
        beam2.LightEmission = 0.6
        beam2.FaceCamera = true
        beam2.Attachment0 = attachment1
        beam2.Attachment1 = attachment2
        beam2.Parent = part1

        local shaking = true
        task.spawn(function()
            while shaking and part1 and part1.Parent do
                attachment1.Position = Vector3.new(math.random(-3, 3) / 100, math.random(-3, 3) / 100, math.random(-3, 3) / 100)
                attachment2.Position = Vector3.new(math.random(-3, 3) / 100, math.random(-3, 3) / 100, math.random(-3, 3) / 100)
                task.wait(0.02)
            end
        end)

        task.delay(math.random(10, 40) / 10, function()
            shaking = false
            for i = 0, 1, 0.05 do
                if not part1 or not part1.Parent then break end
                beam1.Transparency = NumberSequence.new(i)
                beam2.Transparency = NumberSequence.new(0.4 + i * 0.6)
                task.wait(0.03)
            end
            pcall(function() part1:Destroy() end)
            pcall(function() part2:Destroy() end)
        end)
    end

    local function shoot(player, targetPart, targetPos, origin)
        local currentTime = tick()
        if currentTime - lastShotTime < 0.56 then return false end

        local character = LocalPlayer.Character
        if not character or not targetPart or not origin then return false end

        local direction = (targetPos - origin).Unit
        local time = tick()
        local cframe = CFrame.lookAt(origin, targetPos)

        local clientRemotes = LocalPlayer:FindFirstChild("ClientRemotes")
        if clientRemotes then
            pcall(function() clientRemotes.CheckFire:FireServer(time, origin) end)
            pcall(function() clientRemotes.CheckShot:FireServer(0, 0, 1, 0.8, cframe, targetPos, targetPart, 11, time) end)
            pcall(function() clientRemotes.Reload:FireServer() end)
        end

        local gun = ReplicatedStorage:FindFirstChild("ModuleScripts")
        if gun then
            gun = gun:FindFirstChild("GunModules")
            if gun then
                gun = gun:FindFirstChild("Remote")
                if gun then
                    pcall(function() gun.ProjectileRender:FireServer(time, character, origin, direction * 999999, 360, 0, Vector3.zero, 5, "Bullet") end)
                    pcall(function() gun.ProjectileFinished:FireServer(time, CFrame.new(targetPos), "Gib_T", false, 15, "rbxassetid://2814354338") end)
                end
            end
        end

        createBeam(origin, targetPos)
        playShootSound()
        lastShotTime = currentTime

        return true
    end

    local function getVisibleTargets()
        local targets = {}
        local character = LocalPlayer.Character
        if not character then return targets end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return targets end

        local origin = humanoidRootPart.Position

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not isDead(player) and player.Character then
                local visiblePart, visiblePos, originPos = getVisiblePart(player.Character)
                if visiblePart and visiblePos and originPos then
                    table.insert(targets, {
                        player = player,
                        distance = (visiblePos - origin).Magnitude,
                        part = visiblePart,
                        position = visiblePos,
                        origin = originPos
                    })
                end
            end
        end

        table.sort(targets, function(a, b) return a.distance < b.distance end)
        return targets
    end

    KillTab:Toggle({
        Title = "ragebot",
        Value = false,
        Callback = function(state)
            if state then
                if not connection then
                    connection = RunService.Heartbeat:Connect(function()
                        pcall(function()
                            if currentTarget and not isDead(currentTarget) then
                                local targetChar = currentTarget.Character
                                if targetChar then
                                    local visiblePart, visiblePos, origin = getVisiblePart(targetChar)
                                    if visiblePart and visiblePos and origin then
                                        shoot(currentTarget, visiblePart, visiblePos, origin)
                                    else
                                        currentTarget = nil
                                    end
                                end
                            else
                                currentTarget = nil
                            end

                            if not currentTarget then
                                local targets = getVisibleTargets()
                                if #targets > 0 then
                                    currentTarget = targets[1].player
                                end
                            end
                        end)
                    end)
                end
            else
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                currentTarget = nil
                lastShotTime = 0
            end
        end
    })
end

local AboutTab = Window:Tab({  
    Title = "关于作者",  
    Icon = "crown",  
    Locked = false,
})

do
    AboutTab:Paragraph({
    Title = "欢迎使用XIAIXI脚本",
    Desc = "作者：小西｜ 源码提供：梅西（凌乱）｜\n版本：v4.0.0\n\n一个功能强大的脚本",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/1357873301.jpg",
    ThumbnailSize = 170
})

Taba:Divider()

AboutTab:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用XIAOXI",
            Icon = "heart",
            Duration = 3
        })
    end
})
AboutTab:Paragraph({
    Title = "此脚本为凌乱协助",
    Desc = [[ ]],
    Image = "eye",
    ImageSize = 24,
    Color = Color3.fromHex("#000000"),
    BackgroundColor3 = Color3.fromHex("#000000"),
    BackgroundTransparency = 0.2,
    OutlineColor = Color3.fromHex("#000000"),
    OutlineThickness = 1,
    Padding = UDim.new(0, 1)
})
    AboutTab:Space({ Columns = 2 })
    AboutTab:Button({
        Title = "销毁UI",
        Color = Red,
        Justify = "Center",
        Callback = function()
            pcall(function()
                if JumpConnection then
                    JumpConnection:Disconnect()
                end
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                end
                if AimConnection then
                    AimConnection:Disconnect()
                end
                CleanupDrawings()
                if RainbowUIScreenGui then
                    RainbowUIScreenGui:Destroy()
                end
                workspace.Gravity = originalGravity
                if NightVisionEnabled then
                    Lighting.Brightness = originalBrightness
                    Lighting.Ambient = originalAmbient
                end
                if ESPEnabled then
                    ToggleESP(false)
                end
                Window:Destroy()
            end)
        end
    })
    AboutTab:Space()
    AboutTab:Button({
        Title = "重置所有配置",
        Color = Yellow,
        Justify = "Center",
        Callback = function()
            pcall(function()
                AimSettings = {
                    Enabled = false,
                    FOV = 100,
                    Smoothness = 10,
                    CrosshairDistance = 5,
                    FOVColor = Color3.fromRGB(0, 255, 0),
                    FriendCheck = true,
                    WallCheck = true,
                    TargetPlayer = nil,
                    TargetAll = true,
                    FOVRainbowEnabled = true,
                    FOVRainbowSpeed = 8,
                    FOVEnabled = true
                }
                ESPNameColor = Color3.fromRGB(0, 255, 127)
                ESPBodyColor = Color3.fromRGB(0, 255, 127)
                ESPNameSize = 14
                ESPRainbowEnabled = false
                ESPRainbowSpeed = 5
                CurrentESPHue = 0
                RainbowUIEnabled = false
                BackstabCheckEnabled = false
                DeathCheckEnabled = false
                CurrentTarget = nil
                ESPTeamCheck = false
                if RainbowUIScreenGui then
                    RainbowUIScreenGui:Destroy()
                    RainbowUIScreenGui = nil
                end
                workspace.Gravity = originalGravity
                if NightVisionEnabled then
                    Lighting.Brightness = originalBrightness
                    Lighting.Ambient = originalAmbient
                    NightVisionEnabled = false
                end
                if ESPEnabled then
                    ToggleESP(false)
                end
                WindUI:Notify({
                    Title = "重置",
                    Content = "所有设置已重置",
                    Icon = "refresh-cw",
                })
            end)
        end
    })
end

game:BindToClose(function()
    pcall(function()
        CleanupDrawings()
        if JumpConnection then
            JumpConnection:Disconnect()
        end
        if SpeedConnection then
            SpeedConnection:Disconnect()
        end
        if AimConnection then
            AimConnection:Disconnect()
        end
        if ESPEnabled then
            ToggleESP(false)
        end
        if RainbowUIScreenGui then
            RainbowUIScreenGui:Destroy()
        end
        workspace.Gravity = originalGravity
        if NightVisionEnabled then
            Lighting.Brightness = originalBrightness
            Lighting.Ambient = originalAmbient
        end
    end)
end)

coroutine.wrap(function()
    while true do
        task.wait(5)
        pcall(function()
            if ESPEnabled then
                if ESPFolder then
                    for _, child in ipairs(ESPFolder:GetChildren()) do
                        child:Destroy()
                    end
                end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        CreatePlayerESP(player)
                    end
                end
            end
            CurrentTarget = nil
        end)
    end
end)()

if WindUI and WindUI.InitComplete then
    WindUI.InitComplete:Wait()
end

WindUI:Notify({
    Title = "pvp",
    Content = "TnineHub!",
    Icon = "check-circle",
    Duration = 5,
})
    ---↑↑↑↑↑↑服务器源码
        task.wait(0.5)----等待时间
        
      
        if originalUI then
            originalUI:Unload()  ----加载完删除加载器ui
        end
    end,
    
    Tooltip = '加载该服务器',
    DoubleClick = false,----双击加载，关闭将true改为false
    Disabled = false,
    Visible = true
})



Button(Tab5, "网易云音乐", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%BD%91%E6%98%93%E4%BA%91.lua"))()
end)

Button(Tab5, "泡沫", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://93258315043162"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "这个不知道叫什么", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://132913406368504"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "落泪", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://78963341533467"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "山楂树之恋", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://114372452919028"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "哈基米吴老师制作", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://136233212173657"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "看不透", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://100856301638837"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "铜锣湾", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://89795630567186"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "长跑小曲", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://96590819329722"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "呼吸会痛", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://96590819329722"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "雨爱", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://79277371759525"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "堕落", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://98850529016454"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)

Button(Tab5, "这个也不知道叫什么", function()
  
  local r0_168 = Instance.new("Sound")
  r0_168.SoundId = "rbxassetid://80487039269735"
  r0_168.Parent = game.Workspace
  r0_168:Play()
end)
Button(Tabb, "重进服务器", function() 
    game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            game:GetService("Players").LocalPlayer
        )
end)

Tabd:Paragraph({
    Title = "小西空不更新怎么办？",
    Desc = [[我哪有那么多时间]],
    Image = "eye",
    ImageSize = 24,
    Color = Color3.fromHex("#FFFFFF"),
    BackgroundColor3 = Color3.fromHex("#000000"),
    BackgroundTransparency = 0.2,
    OutlineColor = Color3.fromHex("#FFFFFF"),
    OutlineThickness = 1,
    Padding = UDim.new(0, 1)
})

Button(Tabd, "小西私人qq号码[点我复制]", function()
    setclipboard("3574769415")
end)

Button(Tabb, "离开服务器", function() 
    game:Shutdown()
end)


