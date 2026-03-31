local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()

getgenv().TransparencyEnabled = getgenv().TransparencyEnabled or false





local function gradient(text, startColor, endColor)
    local result, chars = "", {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        chars[#chars + 1] = uchar
    end
    
    for i = 1, #chars do
        local t = (i - 1) / math.max(#chars - 1, 1)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255), 
            math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255), 
            math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255), 
            chars[i])
    end
    return result
end

local themes = {"Dark", "Light", "Mocha", "Aqua"}
local currentThemeIndex = 1

-- 弹出欢迎信息
WindUI:Popup({
    Title = gradient("NOLSAKEN Demo", Color3.fromHex("FFB6C1"), Color3.fromHex("FF69B4")),
    Icon = "sparkles",
    Content = "欢迎使用NOL WIND UI\n作者：Yuxingchen｜鱼腥草｜宇星辰",
    Buttons = {
        {
            Title = "开始体验",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>N</font><font color='#FFA0B5'>O</font><font color='#FF8AA9'>L</font><font color='#FF749D'> </font><font color='#FF5E91'>S</font><font color='#FF4885'>C</font><font color='#FF3279'>R</font><font color='#FF66B2'>I</font><font color='#FF7EB8'>P</font><font color='#FF96BE'>T</font><font color='#FFAEC4'></font>",
    Icon = "rbxassetid://4483362748",
    IconTransparency = 1,
    Author = "Yuxingchen",
    Folder = "NOLSAKEN_Data",
    Size = UDim2.fromOffset(700, 500),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 220,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/Potato5466794/LUAUmisc/refs/heads/main/Video_1771590934859_662.mp4",---背景
    ScrollBarEnabled = true
})

Window:Tag({
    Title = "示例",
    Color = Color3.fromHex("FF69B4")
})
Window:Tag({
    Title = "樱花粉主题",
    Color = Color3.fromHex("FFB6C1")
})



-- 通过主题设置按钮边框
WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)  -- 按钮文字颜色
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)  -- 按钮边框颜色

-- 或者直接修改UI样式表
local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    
    -- 创建样式表
    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame
    
    -- 创建样式规则
    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet
    
    -- 设置边框样式
    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule
    
    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

-- 主题切换按钮
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

-- 修改主题颜色
WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

-- 彩虹边框颜色方案
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
    Title = "Wind NOL",
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

-- 创建彩虹边框函数
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

-- 边框动画函数
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

-- 初始化边框动画
local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

Window:SetToggleKey(Enum.KeyCode.F, true)

-- 创建选项卡
local Tabs = {
    Main = Window:Tab({ Title = "主页", Icon = "home" }),
    Elements = Window:Tab({ Title = "UI元素", Icon = "layout-grid" }),
    Settings = Window:Tab({ Title = "设置", Icon = "settings" }),
    Config = Window:Tab({ Title = "配置", Icon = "save" })
}

-- ==================== 主页内容 ====================
Tabs.Main:Paragraph({
    Title = "欢迎使用NOLSAKEN",
    Desc = "作者：Yuxingchen｜鱼腥草｜宇星辰\n版本：v2.0.0\n\n一个功能强大的UI库示例",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/Potato5466794/LUAUmisc/refs/heads/main/20260224_120008319.webp",
    ThumbnailSize = 170
})

Tabs.Main:Divider()

Tabs.Main:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用NOLSAKEN UI",
            Icon = "heart",
            Duration = 3
        })
    end
})

-- ==================== UI元素选项卡 ====================
local elementSection = Tabs.Elements:Section({ Title = "基础元素演示", Icon = "box", Opened = true })

-- 开关演示
local toggleState = false
local demo1 = elementSection:Toggle({
    Title = "功能开关",
    Desc = "这是一个开关演示",
    Value = false,
    Callback = function(state)
        toggleState = state
        WindUI:Notify({
            Title = "开关状态",
            Content = state and "已开启" or "已关闭",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local coverCheckToggle = elementSection:Toggle({
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

-- 滑块演示
elementSection:Slider({
    Title = "数值调节",
    Desc = "拖动滑块调节数值",
    Value = {
        Min = 0,
        Max = 100,
        Default = 50
    },
    Suffix = "%",
    Callback = function(value)
        print("当前数值:", value)
    end
})

-- 下拉菜单演示
elementSection:Dropdown({
    Title = "选项选择",
    Desc = "从列表中选择一项",
    Values = { "选项 A", "选项 B", "选项 C", "选项 D" },
    Value = "选项 A",
    Callback = function(option)
        WindUI:Notify({
            Title = "已选择",
            Content = "你选择了: "..option,
            Duration = 2
        })
    end
})

elementSection:Divider()

-- 按钮演示
elementSection:Button({
    Title = "点击按钮",
    Icon = "mouse-pointer",
    Desc = "点击触发通知",
    Callback = function()
        WindUI:Notify({
            Title = "按钮点击",
            Content = "你点击了按钮!",
            Icon = "check",
            Duration = 2
        })
    end
})

-- 颜色选择器演示
elementSection:Colorpicker({
    Title = "颜色选择",
    Desc = "选择一个颜色",
    Default = Color3.fromHex("FF69B4"),
    Callback = function(color)
        print("选择的颜色:", color:ToHex())
    end
})

-- 输入框演示
elementSection:Input({
    Title = "文本输入",
    Desc = "输入一些文字",
    Value = "默认文本",
    Callback = function(value)
        print("输入内容:", value)
    end
})

-- ==================== 设置选项卡 ====================
-- 边框设置区域
local borderSection = Tabs.Settings:Section({ Title = "边框设置", Icon = "square", Opened = true })

borderSection:Toggle({
    Title = "启用边框",
    Value = true,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and not borderAnimation then
                    borderAnimation = startBorderAnimation(Window, animationSpeed)
                elseif not value and borderAnimation then
                    borderAnimation:Disconnect()
                    borderAnimation = nil
                end
            end
        end
    end
})

local colorNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorNames, name)
end

borderSection:Dropdown({
    Title = "颜色方案",
    Values = colorNames,
    Value = "樱花粉2",
    Callback = function(value)
        currentColor = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
                if glowEffect then
                    local schemeData = COLOR_SCHEMES[value]
                    if schemeData then
                        glowEffect.Color = schemeData[1]
                    end
                end
            end
        end
    end
})

borderSection:Slider({
    Title = "动画速度",
    Value = {
        Min = 1,
        Max = 10,
        Default = 5,
    },
    Callback = function(value)
        animationSpeed = value
        if borderAnimation then
            borderAnimation:Disconnect()
            borderAnimation = nil
        end
        if borderEnabled then
            borderAnimation = startBorderAnimation(Window, animationSpeed)
        end
    end
})

borderSection:Slider({
    Title = "边框粗细",
    Value = {
        Min = 1,
        Max = 5,
        Default = 2,
    },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
    end
})

borderSection:Slider({
    Title = "圆角大小",
    Value = {
        Min = 0,
        Max = 30,
        Default = 16,
    },
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
    end
})

-- 外观设置区域
local appearanceSection = Tabs.Settings:Section({ Title = "外观设置", Icon = "brush", Opened = true })

local themes_list = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes_list, themeName)
end
table.sort(themes_list)

local themeDropdown = appearanceSection:Dropdown({
    Title = "选择主题",
    Values = themes_list,
    Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "主题已应用",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
    end
})

local transparencySlider = appearanceSection:Slider({
    Title = "透明度",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
    end
})

-- ==================== 配置选项卡 ====================
local configSection = Tabs.Config:Section({ Title = "配置管理", Icon = "settings", Opened = true })

configSection:Paragraph({
    Title = "配置管理器",
    Desc = "保存和加载你的设置",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

configSection:Input({
    Title = "配置名称",
    Value = configName,
    Callback = function(value)
        configName = value
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    
    configSection:Button({
        Title = "保存配置",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            
            configFile:Register("demo1", demo1)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "保存配置", 
                    Content = "已保存为: "..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "保存配置失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    configSection:Button({
        Title = "加载配置",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            
            if loadedData then
                if loadedData.playerData then
                    MyPlayerData = loadedData.playerData
                end
                
                local lastSave = loadedData.lastSave or "未知"
                WindUI:Notify({ 
                    Title = "加载配置", 
                    Content = "已加载: "..configName.."\n上次保存: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                configSection:Paragraph({
                    Title = "玩家数据",
                    Desc = string.format("名称: %s\n等级: %d\n物品: %s", 
                        MyPlayerData.name, 
                        MyPlayerData.level, 
                        table.concat(MyPlayerData.inventory, ", "))
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "加载配置失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
    
    -- 配置文件列表
    configSection:Button({
        Title = "列出所有配置",
        Icon = "list",
        Callback = function()
            local files = ConfigManager:ListConfigs()
            local fileList = "找到 "..#files.." 个配置:\n"
            for i, file in ipairs(files) do
                fileList = fileList .. i .. ". " .. file .. "\n"
            end
            WindUI:Notify({
                Title = "配置文件列表",
                Content = fileList,
                Duration = 5
            })
        end
    })
else
    configSection:Paragraph({
        Title = "配置管理器不可用",
        Desc = "此功能需要ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

-- 关于信息
local aboutSection = Tabs.Config:Section({ Title = "关于" })
aboutSection:Paragraph({
    Title = "Created with ❤️",
    Desc = "github.com/Footagesus/WindUI\n改编：Yuxingchen\n\nNOLSAKEN UI v2.0.0",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "复制链接",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://github.com/Footagesus/WindUI")
                WindUI:Notify({
                    Title = "已复制!",
                    Content = "GitHub链接已复制到剪贴板",
                    Duration = 2
                })
            end
        }
    }
})

-- 窗口关闭清理
Window:OnClose(function()
    print("窗口关闭")
    
    if borderAnimation then
        borderAnimation:Disconnect()
        borderAnimation = nil
    end
    
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("配置已自动保存")
    end
end)

Window:OnDestroy(function()
    print("窗口已销毁")
end)