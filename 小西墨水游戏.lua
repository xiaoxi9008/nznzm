game.StarterGui:SetCore("SendNotification", {
    Title = "XIAOXI检测中",
    Text = "正在为你自动检测服务器...",
    Duration = 3 
})
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()

getgenv().TransparencyEnabled = getgenv().TransparencyEnabled or false

-- 全局变量
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local lplr = Players.LocalPlayer
local camera = workspace.CurrentCamera

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

-- 弹出欢迎信息
WindUI:Popup({
    Title = gradient("RTaO HUB - Ink Game", Color3.fromHex("FF69B4"), Color3.fromHex("FFB6C1")),
    Icon = "sparkles",
    Content = "欢迎使用RTaO HUB\n墨水游戏全功能版\n作者：RTaO TEAM",
    Buttons = {
        {
            Title = "开始体验",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

-- 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "<font color='#FF69B4'>R</font><font color='#FF7EB8'>T</font><font color='#FF96BE'>a</font><font color='#FFAEC4'>O</font><font color='#FFC6CA'> </font><font color='#FFDED0'>H</font><font color='#FFF6D6'>U</font><font color='#FFE6C4'>B</font>",
    Icon = "rbxassetid://4483362748",
    IconTransparency = 1,
    Author = "RTaO TEAM",
    Folder = "RTaOHUB_InkGame_Data",
    Size = UDim2.fromOffset(750, 550),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 220,
    HasOutline = true,
    ScrollBarEnabled = true
})

Window:Tag({
    Title = "墨水游戏",
    Color = Color3.fromHex("FF69B4")
})
Window:Tag({
    Title = "全功能版",
    Color = Color3.fromHex("FFB6C1")
})

-- 修改主题颜色
WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

-- 创建打开按钮样式
Window:EditOpenButton({
    Title = "RTaO HUB",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 188, 217)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 105, 180))
    }),
    Draggable = true,
})

Window:SetToggleKey(Enum.KeyCode.RightShift, true)

-- ==================== 数据结构 ====================
local Script = {
    GameStateChanged = Instance.new("BindableEvent"),
    GameState = "unknown",
    Services = {},
    Maid = {Tasks = {}},
    Connections = {},
    Functions = {},
    ESPTable = {
        Player = {},
        Seeker = {},
        Hider = {},
        Guard = {},
        Door = {},
        None = {},
        Key = {},
    },
    Temp = {}
}

function Script.Maid:Clean()
    for _, task in ipairs(self.Tasks) do
        pcall(function()
            if typeof(task) == "RBXScriptConnection" then
                task:Disconnect()
            elseif typeof(task) == "Instance" then
                task:Destroy()
            elseif typeof(task) == "function" then
                task()
            end
        end)
    end
    table.clear(self.Tasks)
    self.Tasks = {}
end

function Script.Functions.Alert(message, duration)
    WindUI:Notify({
        Title = "RTaO HUB",
        Content = message,
        Icon = "bell",
        Duration = duration or 5
    })
end

function Script.Functions.Warn(message)
    warn("WARN - RTaOHUB:", message)
end

function Script.Functions.DistanceFromCharacter(position)
    if typeof(position) == "Instance" then
        position = position:GetPivot().Position
    end
    local rootPart = lplr.Character and (lplr.Character:FindFirstChild("HumanoidRootPart") or lplr.Character:FindFirstChild("Torso"))
    if rootPart then
        return (rootPart.Position - position).Magnitude
    end
    return (camera.CFrame.Position - position).Magnitude
end

function Script.Functions.SafeRequire(module)
    if Script.Temp[tostring(module)] then return Script.Temp[tostring(module)] end
    local suc, err = pcall(function()
        return require(module)
    end)
    if not suc then
        Script.Functions.Warn("[SafeRequire]: Failure loading "..tostring(module))
    else
        Script.Temp[tostring(module)] = err
    end
    return suc and err
end

function Script.Functions.ExecuteClick()
    local args = {"Clicked"}
    game:GetService("ReplicatedStorage"):WaitForChild("Replication"):WaitForChild("Event"):FireServer(unpack(args))
end

function Script.Functions.CompleteDalgonaGame()
    Script.Functions.ExecuteClick()
    local args = {{Completed = true}}
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DALGONATEMPREMPTE"):FireServer(unpack(args))
end

function Script.Functions.PullRope(perfect)
    local args = {{PerfectQTE = perfect or true}}
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer(unpack(args))
end

function Script.Functions.GetRootPart()
    if not lplr.Character then return end
    return lplr.Character:WaitForChild("HumanoidRootPart", 10)
end

function Script.Functions.GetHumanoid()
    if not lplr.Character then return end
    return lplr.Character:WaitForChild("Humanoid", 10)
end

local tools = {"Fork", "Bottle", "Knife"}
function Script.Functions.GetFork()
    local res
    for _, index in pairs(tools) do
        local tool = lplr.Character:FindFirstChild(index) or (lplr:FindFirstChild("Backpack") and lplr.Backpack:FindFirstChild(index))
        if tool then
            res = tool
            break
        end
    end
    return res
end

function Script.Functions.FireForkRemote()
    local fork = Script.Functions.GetFork()
    if not fork then return end
    
    if fork.Parent.Name == "Backpack" then
        lplr.Character.Humanoid:EquipTool(fork)
    end
    
    fork = Script.Functions.GetFork()
    if not fork then return end
    
    local args = {"UsingMoveCustom", fork, [4] = {Clicked = true}}
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UsedTool"):FireServer(unpack(args))
    
    local args2 = {"UsingMoveCustom", fork, true, {Clicked = true}}
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UsedTool"):FireServer(unpack(args2))
end

function Script.Functions.JoinDiscordServer()
    local sInvite = "https://dsc.gg/dyhub"
    local function getInviteCode(s)
        for i = #s, 1, -1 do
            local char = s:sub(i, i)
            if char == "/" then
                return s:sub(i + 1, #s)
            end
        end
        return s
    end
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(request({
            Url = "https://ptb.discord.com/api/invites/".. getInviteCode(sInvite),
            Method = "GET"
        }).Body)
    end)
    if success and result then
        pcall(function()
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
                Body = HttpService:JSONEncode({cmd = "INVITE_BROWSER", args = {code = result.code}, nonce = HttpService:GenerateGUID(false)})
            })
        end)
    end
    pcall(function() setclipboard("dsc.gg/dyhub") end)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RTaO HUB Discord",
        Text = "Copied to clipboard (dsc.gg/dyhub)",
        Duration = 10,
    })
end

function Script.Functions.GetDalgonaRemote()
    return game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("DALGONATEMPREMPTE")
end

function Script.Functions.FixCamera()
    if workspace.CurrentCamera then
        pcall(function() workspace.CurrentCamera:Destroy() end)
    end
    local new = Instance.new("Camera")
    new.Parent = workspace
    workspace.CurrentCamera = new
    new.CameraType = Enum.CameraType.Custom
    if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
        new.CameraSubject = lplr.Character.Humanoid
    end
end

function Script.Functions.TeleportSafe()
    if not lplr.Character then return end
    local call = Script.Temp.AntiFlingActive
    if Script.Temp.AntiFlingActive then
        Script.Temp.PauseAntiFling = true
    end
    lplr.Character:PivotTo(CFrame.new(Vector3.new(-108, 329.1, 462.1)))
    if call then
        task.delay(0.5, function() Script.Temp.PauseAntiFling = nil end)
    end
end

function Script.Functions.WinRLGL()
    if not lplr.Character then return end
    local call = Script.Temp.AntiFlingActive
    if Script.Temp.AntiFlingActive then
        Script.Temp.PauseAntiFling = true
    end
    lplr.Character:PivotTo(CFrame.new(Vector3.new(-100.8, 1030, 115)))
    if call then
        task.delay(0.5, function() Script.Temp.PauseAntiFling = nil end)
    end
end

function Script.Functions.WinGlassBridge()
    if not lplr.Character then return end
    local call = Script.Temp.AntiFlingActive
    if Script.Temp.AntiFlingActive then
        Script.Temp.PauseAntiFling = true
    end
    lplr.Character:PivotTo(CFrame.new(Vector3.new(-203.9, 520.7, -1534.3485)))
    if call then
        task.delay(0.5, function() Script.Temp.PauseAntiFling = nil end)
    end
end

function Script.Functions.RevealGlassBridge()
    local EffectsModule = Script.Functions.SafeRequire(ReplicatedStorage.Modules.Effects) or {
        AnnouncementTween = function(args)
            Script.Functions.Alert(args.AnnouncementDisplayText, args.DisplayTime)
        end
    }
    
    local glassHolder = workspace:FindFirstChild("GlassBridge") and workspace.GlassBridge:FindFirstChild("GlassHolder")
    if not glassHolder then
        Script.Functions.Warn("GlassHolder not found")
        return
    end
    
    for _, tilePair in pairs(glassHolder:GetChildren()) do
        for _, tileModel in pairs(tilePair:GetChildren()) do
            if tileModel:IsA("Model") and tileModel.PrimaryPart then
                local primaryPart = tileModel.PrimaryPart
                local isBreakable = primaryPart:GetAttribute("exploitingisevil") == true
                local targetColor = isBreakable and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                
                for _, part in pairs(tileModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        TweenService:Create(part, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                            Transparency = 0.5,
                            Color = targetColor
                        }):Play()
                    end
                end
                
                local highlight = Instance.new("Highlight")
                highlight.FillColor = targetColor
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0.5
                highlight.Parent = tileModel
            end
        end
    end
    
    EffectsModule.AnnouncementTween({
        AnnouncementOneLine = true,
        FasterTween = true,
        DisplayTime = 10,
        AnnouncementDisplayText = "[RTaO HUB]: Safe tiles are green, breakable tiles are red!"
    })
end

function Script.Functions.BypassRagdoll()
    local character = lplr.Character
    if not character then return end
    local Humanoid = character:FindFirstChild("Humanoid")
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local Torso = character:FindFirstChild("Torso")
    if not (Humanoid and HumanoidRootPart and Torso) then return end
    
    Humanoid.PlatformStand = false
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
    for _, state in pairs({
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Seated,
        Enum.HumanoidStateType.Swimming,
        Enum.HumanoidStateType.Flying,
        Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Ragdoll
    }) do
        Humanoid:SetStateEnabled(state, false)
    end
    
    for _, obj in pairs(HumanoidRootPart:GetChildren()) do
        if obj:IsA("BallSocketConstraint") or obj.Name:match("^CacheAttachment") then
            obj:Destroy()
        end
    end
    
    local joints = {"Left Hip", "Left Shoulder", "Neck", "Right Hip", "Right Shoulder"}
    for _, jointName in pairs(joints) do
        local motor = Torso:FindFirstChild(jointName)
        if motor and motor:IsA("Motor6D") and not motor.Part0 then
            motor.Part0 = Torso
        end
    end
    
    for _, folderName in pairs({"Ragdoll", "Stun", "RotateDisabled", "RagdollWakeupImmunity", "InjuredWalking"}) do
        local folder = character:FindFirstChild(folderName)
        if folder then folder:Destroy() end
    end
    
    local LocalRagdolls = workspace.Effects:FindFirstChild("LocalRagdolls")
    if LocalRagdolls then
        local ragdollModel = LocalRagdolls:FindFirstChild(lplr.Name)
        if ragdollModel then ragdollModel:Destroy() end
    end
end

function Script.Functions.BypassDalgonaGame()
    local SharedFunctions = Script.Functions.SafeRequire(ReplicatedStorage.Modules.SharedFunctions)
    local character = lplr.Character
    local HumanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local Humanoid = character and character:FindFirstChild("Humanoid")
    local PlayerGui = lplr.PlayerGui
    local DebrisBD = lplr:WaitForChild("DebrisBD")
    local CurrentCamera = workspace.CurrentCamera
    local EffectsFolder = workspace:FindFirstChild("Effects")
    local ImpactFrames = PlayerGui:FindFirstChild("ImpactFrames")
    
    local shapeModel, outlineModel, pickModel, redDotModel
    if EffectsFolder then
        for _, obj in pairs(EffectsFolder:GetChildren()) do
            if obj:IsA("Model") and obj.Name:match("Outline$") then
                outlineModel = obj
            elseif obj:IsA("Model") and not obj.Name:match("Outline$") and obj.Name ~= "Pick" and obj.Name ~= "RedDot" then
                shapeModel = obj
            elseif obj.Name == "Pick" then
                pickModel = obj
            elseif obj.Name == "RedDot" then
                redDotModel = obj
            end
        end
    end
    
    local progressBar = ImpactFrames and ImpactFrames:FindFirstChild("ProgressBar")
    local pickViewportModel
    
    if ImpactFrames then
        for _, obj in pairs(ImpactFrames:GetChildren()) do
            if obj:IsA("ViewportFrame") and obj:FindFirstChild("PickModel") then
                pickViewportModel = obj.PickModel
                break
            end
        end
    end
    
    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
    local DalgonaRemote = Remotes:WaitForChild("DALGONATEMPREMPTE")
    
    task.spawn(function()
        if SharedFunctions then
            SharedFunctions.CreateFolder(lplr, "RecentGameStartedMessage", 0.01)
        end
        
        if shapeModel and shapeModel:FindFirstChild("shape") then
            TweenService:Create(shapeModel.shape, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                Position = shapeModel.shape.Position + Vector3.new(0, 0.5, 0)
            }):Play()
        end
        
        if shapeModel then
            for _, part in pairs(shapeModel:GetChildren()) do
                if part.Name == "DalgonaClickPart" and part:IsA("BasePart") then
                    TweenService:Create(part, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                        Transparency = 1
                    }):Play()
                end
            end
        end
        
        if pickModel and pickModel.Parent then
            TweenService:Create(pickModel, TweenInfo.new(2, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
        end
        if redDotModel and redDotModel.Parent then
            TweenService:Create(redDotModel, TweenInfo.new(2, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
        end
        
        if pickViewportModel then
            for _, part in pairs(pickViewportModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    TweenService:Create(part, TweenInfo.new(2, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
                end
            end
        end
        
        if HumanoidRootPart then
            TweenService:Create(CurrentCamera, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                CFrame = HumanoidRootPart.CFrame * CFrame.new(0.0841674805, 8.45438766, 6.69675446)
            }):Play()
        end
        
        if SharedFunctions then
            SharedFunctions.Invisible(character, 0, true)
        end
        
        DalgonaRemote:FireServer({Success = true})
        
        task.wait(2)
        for _, obj in pairs({shapeModel, outlineModel, pickModel, redDotModel, progressBar}) do
            if obj and obj.Parent then obj:Destroy() end
        end
        
        UserInputService.MouseIconEnabled = true
        if PlayerGui:FindFirstChild("Hotbar") and PlayerGui.Hotbar:FindFirstChild("Backpack") then
            TweenService:Create(PlayerGui.Hotbar.Backpack, TweenInfo.new(1.5, Enum.EasingStyle.Circular), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
        if progressBar then
            DebrisBD:Fire(progressBar, 2)
            TweenService:Create(progressBar, TweenInfo.new(1.5, Enum.EasingStyle.Circular), {
                Position = UDim2.new(progressBar.Position.X.Scale, 0, progressBar.Position.Y.Scale + 1, 0)
            }):Play()
        end
        
        CurrentCamera.CameraType = Enum.CameraType.Custom
        if Humanoid then
            CurrentCamera.CameraSubject = Humanoid
        end
    end)
end

function Script.Functions.GetHider()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lplr then continue end
        if not plr.Character then continue end
        if not plr:GetAttribute("IsHider") then continue end
        if plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            return plr.Character
        end
    end
end

function Script.Functions.CheckPlayersVisibility()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    if part.Transparency >= 0.99 or part.LocalTransparencyModifier >= 0.99 then
                        part.Transparency = 0
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end
end

-- ==================== ESP系统 ====================
function Script.Functions.ESP(args)
    if not args.Object then return Script.Functions.Warn("ESP Object is nil") end
    
    local ESPManager = {
        Object = args.Object,
        Text = args.Text or "No Text",
        Color = args.Color or Color3.new(),
        Offset = args.Offset or Vector3.zero,
        Type = args.Type or "None",
        Highlights = {},
        Humanoid = nil,
        RSConnection = nil,
        Connections = {}
    }
    
    local tableIndex = #Script.ESPTable[ESPManager.Type] + 1
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = ESPManager.Object
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = ESPManager.Color
    highlight.FillTransparency = Script.Temp.ESPFillTransparency or 0.75
    highlight.OutlineColor = ESPManager.Color
    highlight.OutlineTransparency = Script.Temp.ESPOutlineTransparency or 0
    highlight.Enabled = Script.Temp.ESPHighlight or true
    highlight.Parent = ESPManager.Object
    table.insert(ESPManager.Highlights, highlight)
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = args.TextParent or ESPManager.Object
    billboardGui.AlwaysOnTop = true
    billboardGui.ClipsDescendants = false
    billboardGui.Size = UDim2.new(0, 1, 0, 1)
    billboardGui.StudsOffset = ESPManager.Offset
    billboardGui.Parent = args.TextParent or ESPManager.Object
    
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Oswald
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = ESPManager.Text
    textLabel.TextColor3 = ESPManager.Color
    textLabel.TextSize = Script.Temp.ESPTextSize or 22
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.75
    textLabel.Parent = billboardGui
    
    function ESPManager.SetColor(newColor)
        ESPManager.Color = newColor
        for _, h in pairs(ESPManager.Highlights) do
            h.FillColor = newColor
            h.OutlineColor = newColor
        end
        textLabel.TextColor3 = newColor
    end
    
    function ESPManager.Destroy()
        if ESPManager.RSConnection then ESPManager.RSConnection:Disconnect() end
        for _, h in pairs(ESPManager.Highlights) do h:Destroy() end
        if billboardGui then billboardGui:Destroy() end
        if Script.ESPTable[ESPManager.Type][tableIndex] then
            Script.ESPTable[ESPManager.Type][tableIndex] = nil
        end
        for _, conn in pairs(ESPManager.Connections) do pcall(function() conn:Disconnect() end) end
    end
    
    ESPManager.RSConnection = RunService.RenderStepped:Connect(function()
        if not ESPManager.Object or not ESPManager.Object:IsDescendantOf(workspace) then
            ESPManager.Destroy()
            return
        end
        for _, h in pairs(ESPManager.Highlights) do
            h.Enabled = Script.Temp.ESPHighlight or true
            h.FillTransparency = Script.Temp.ESPFillTransparency or 0.75
            h.OutlineTransparency = Script.Temp.ESPOutlineTransparency or 0
        end
        textLabel.TextSize = Script.Temp.ESPTextSize or 22
        if Script.Temp.ESPDistance then
            textLabel.Text = string.format("%s\n[%s]", ESPManager.Text, math.floor(Script.Functions.DistanceFromCharacter(ESPManager.Object)))
        else
            textLabel.Text = ESPManager.Text
        end
    end)
    
    function ESPManager.GiveSignal(signal)
        table.insert(ESPManager.Connections, signal)
    end
    
    Script.ESPTable[ESPManager.Type][tableIndex] = ESPManager
    return ESPManager
end

function Script.Functions.PlayerESP(player)
    if not (player.Character and player.Character.PrimaryPart and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0) then return end
    local playerEsp = Script.Functions.ESP({
        Type = "Player",
        Object = player.Character,
        Text = string.format("%s [%s]", player.DisplayName, player.Character.Humanoid.Health),
        TextParent = player.Character.PrimaryPart,
        Color = Script.Temp.PlayerEspColor or Color3.fromRGB(255, 255, 255)
    })
    playerEsp.GiveSignal(player.Character.Humanoid.HealthChanged:Connect(function(newHealth)
        if newHealth > 0 then
            playerEsp.Text = string.format("%s [%s]", player.DisplayName, newHealth)
        else
            playerEsp.Destroy()
        end
    end))
end

function Script.Functions.GuardESP(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        Script.Functions.ESP({
            Object = character,
            Text = "Guard",
            Color = Script.Temp.GuardEspColor or Color3.fromRGB(200, 100, 200),
            Offset = Vector3.new(0, 3, 0),
            Type = "Guard"
        })
    end
end

function Script.Functions.SeekerESP(player)
    if player:GetAttribute("IsHunter") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        Script.Functions.ESP({
            Object = player.Character,
            Text = player.Name .. " (Seeker)",
            Color = Script.Temp.SeekerEspColor or Color3.fromRGB(255, 0, 0),
            Offset = Vector3.new(0, 3, 0),
            Type = "Seeker"
        })
    end
end

function Script.Functions.HiderESP(player)
    if player:GetAttribute("IsHider") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local esp = Script.Functions.ESP({
            Object = player.Character,
            Text = player.Name .. " (Hider)",
            Color = Script.Temp.HiderEspColor or Color3.fromRGB(0, 255, 0),
            Offset = Vector3.new(0, 3, 0),
            Type = "Hider"
        })
        player:GetAttributeChangedSignal("IsHider"):Once(function()
            if not player:GetAttribute("IsHider") then esp.Destroy() end
        end)
    end
end

function Script.Functions.KeyESP(key)
    if key:IsA("Model") and key.PrimaryPart then
        Script.Functions.ESP({
            Object = key,
            Text = key.Name .. " (Key)",
            Color = Script.Temp.KeyEspColor or Color3.fromRGB(255, 255, 0),
            Offset = Vector3.new(0, 1, 0),
            Type = "Key"
        })
    end
end

function Script.Functions.DoorESP(door)
    if door:IsA("Model") and door.Name == "FullDoorAnimated" and door.PrimaryPart then
        local keyNeeded = door:GetAttribute("KeyNeeded") or "None"
        Script.Functions.ESP({
            Object = door,
            Text = "Door (Key: " .. keyNeeded .. ")",
            Color = Script.Temp.DoorEspColor or Color3.fromRGB(0, 128, 255),
            Offset = Vector3.new(0, 2, 0),
            Type = "Door"
        })
    end
end

-- ==================== 创建选项卡 ====================
local Tabs = {
    Main = Window:Tab({ Title = "主页", Icon = "home" }),
    Combat = Window:Tab({ Title = "战斗", Icon = "sword" }),
    ESP = Window:Tab({ Title = "透视", Icon = "eye" }),
    Movement = Window:Tab({ Title = "移动", Icon = "wind" }),
    Misc = Window:Tab({ Title = "其他", Icon = "settings" }),
    Config = Window:Tab({ Title = "配置", Icon = "save" })
}

-- ==================== 主页内容 ====================
Tabs.Main:Paragraph({
    Title = "RTaO HUB - Ink Game",
    Desc = "版本: 2.0\n作者: RTaO TEAM\n\n一个功能强大的墨水游戏辅助工具",
    ImageSize = 50,
    ThumbnailSize = 170
})

Tabs.Main:Divider()

local infoGroup = Tabs.Main:Section({ Title = "信息", Icon = "info", Opened = true })
infoGroup:Button({
    Title = "加入Discord服务器",
    Icon = "message-circle",
    Callback = function()
        Script.Functions.JoinDiscordServer()
        Script.Functions.Alert("已复制邀请链接到剪贴板", 3)
    end
})
infoGroup:Button({
    Title = "卸载脚本",
    Icon = "x-circle",
    Variant = "Danger",
    Callback = function() Window:Destroy() end
})

-- ==================== 战斗选项卡 ====================
local combatGroup = Tabs.Combat:Section({ Title = "战斗功能", Icon = "sword", Opened = true })

local autowinState = false
combatGroup:Toggle({
    Title = "自动获胜 (所有游戏)",
    Desc = "自动完成当前进行的游戏",
    Value = false,
    Callback = function(state)
        autowinState = state
        Script.Functions.Alert(state and "自动获胜已启用" or "自动获胜已禁用", 3)
        if state then
            Script.Functions.HandleAutowin()
        end
    end
})

local killauraState = false
combatGroup:Toggle({
    Title = "杀戮光环",
    Desc = "自动攻击附近的敌人",
    Value = false,
    Callback = function(state)
        killauraState = state
        if state then
            local fork = Script.Functions.GetFork()
            if not fork then
                Script.Functions.Alert("未找到武器!", 3)
                killauraState = false
                return
            end
            task.spawn(function()
                repeat
                    task.wait(0.5)
                    Script.Functions.FireForkRemote()
                until not killauraState
            end)
        end
        Script.Functions.Alert(state and "杀戮光环已启用" or "杀戮光环已禁用", 3)
    end
})

local flingAuraState = false
combatGroup:Toggle({
    Title = "投掷光环",
    Desc = "将玩家投掷出去",
    Value = false,
    Callback = function(state)
        flingAuraState = state
        if state then
            Script.Temp.FlingAuraActive = true
            local function setNoclip(state)
                if noclipState ~= state then noclipState = state end
            end
            setNoclip(true)
            task.spawn(function()
                local movel = 0.1
                while flingAuraState do
                    local character = lplr.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
                    if character and root then
                        local originalVel = root.Velocity
                        root.Velocity = originalVel * 10000 + Vector3.new(0, 10000, 0)
                        RunService.RenderStepped:Wait()
                        if character and root then
                            root.Velocity = originalVel
                        end
                        RunService.Stepped:Wait()
                        if character and root then
                            root.Velocity = originalVel + Vector3.new(0, movel, 0)
                            movel = -movel
                        end
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        else
            Script.Temp.FlingAuraActive = false
        end
        Script.Functions.Alert(state and "投掷光环已启用" or "投掷光环已禁用", 3)
    end
})

local antiFlingState = false
combatGroup:Toggle({
    Title = "反投掷保护",
    Desc = "防止被投掷",
    Value = false,
    Callback = function(state)
        antiFlingState = state
        if state then
            Script.Temp.PauseAntiFling = nil
            Script.Temp.AntiFlingActive = true
            Script.Temp.AntiFlingLoop = task.spawn(function()
                local lastSafeCFrame = nil
                while antiFlingState do
                    if Script.Temp.PauseAntiFling then task.wait(0.1) end
                    local character = lplr.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
                    if root then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BodyMover") or part:IsA("BodyVelocity") or part:IsA("BodyGyro") then
                                part:Destroy()
                            end
                        end
                        local maxVel = 100
                        local vel = root.Velocity
                        if vel.Magnitude > maxVel then
                            root.Velocity = Vector3.new(math.clamp(vel.X, -maxVel, maxVel), math.clamp(vel.Y, -maxVel, maxVel), math.clamp(vel.Z, -maxVel, maxVel))
                        end
                        if not lastSafeCFrame or (root.Position - lastSafeCFrame.Position).Magnitude < 20 then
                            lastSafeCFrame = root.CFrame
                        elseif (root.Position - lastSafeCFrame.Position).Magnitude > 50 then
                            root.CFrame = lastSafeCFrame
                            root.Velocity = Vector3.zero
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            Script.Temp.AntiFlingActive = false
            if Script.Temp.AntiFlingLoop then task.cancel(Script.Temp.AntiFlingLoop) end
        end
        Script.Functions.Alert(state and "反投掷保护已启用" or "反投掷保护已禁用", 3)
    end
})

-- 红绿灯/绿光游戏
local rlglGroup = Tabs.Combat:Section({ Title = "红绿灯游戏", Icon = "traffic-cone", Opened = true })

rlglGroup:Button({
    Title = "完成红绿灯游戏",
    Icon = "flag",
    Callback = function()
        if not workspace:FindFirstChild("RedLightGreenLight") then
            Script.Functions.Alert("游戏未运行", 3)
            return
        end
        Script.Functions.WinRLGL()
        Script.Functions.Alert("已完成红绿灯游戏", 3)
    end
})

rlglGroup:Button({
    Title = "移除受伤行走效果",
    Icon = "heart",
    Callback = function()
        if lplr.Character and lplr.Character:FindFirstChild("InjuredWalking") then
            lplr.Character.InjuredWalking:Destroy()
        end
        Script.Functions.BypassRagdoll()
        Script.Functions.Alert("已移除受伤行走效果", 3)
    end
})

-- 焦糖饼游戏
local dalgonaGroup = Tabs.Combat:Section({ Title = "焦糖饼游戏", Icon = "cookie", Opened = true })

dalgonaGroup:Button({
    Title = "完成焦糖饼游戏",
    Icon = "check-circle",
    Callback = function()
        if not Script.Functions.GetDalgonaRemote() then
            Script.Functions.Alert("游戏尚未开始", 3)
            return
        end
        Script.Functions.CompleteDalgonaGame()
        Script.Functions.BypassDalgonaGame()
        Script.Functions.FixCamera()
        Script.Functions.Alert("已完成焦糖饼游戏", 3)
        task.spawn(function()
            repeat 
                task.wait(1)
                Script.Functions.CheckPlayersVisibility()
            until not Script.Functions.GetDalgonaRemote()
        end)
    end
})

-- 拔河游戏
local tugGroup = Tabs.Combat:Section({ Title = "拔河游戏", Icon = "users", Opened = true })

local autoPullState = false
tugGroup:Toggle({
    Title = "自动拉绳",
    Value = false,
    Callback = function(state)
        autoPullState = state
        if state then
            task.spawn(function()
                repeat
                    Script.Functions.PullRope(perfectPullState)
                    task.wait()
                until not autoPullState
            end)
        end
        Script.Functions.Alert(state and "自动拉绳已启用" or "自动拉绳已禁用", 3)
    end
})

local perfectPullState = true
tugGroup:Toggle({
    Title = "完美拉绳",
    Value = true,
    Callback = function(state)
        perfectPullState = state
        Script.Functions.Alert(state and "完美拉绳已启用" or "完美拉绳已禁用", 3)
    end
})

-- 玻璃桥游戏
local glassGroup = Tabs.Combat:Section({ Title = "玻璃桥游戏", Icon = "square", Opened = true })

glassGroup:Button({
    Title = "完成玻璃桥游戏",
    Icon = "flag",
    Callback = function()
        if not workspace:FindFirstChild("GlassBridge") then
            Script.Functions.Alert("游戏未运行", 3)
            return
        end
        Script.Functions.WinGlassBridge()
        Script.Functions.Alert("已完成玻璃桥游戏", 3)
    end
})

glassGroup:Button({
    Title = "揭示玻璃桥",
    Icon = "eye",
    Callback = function()
        if not workspace:FindFirstChild("GlassBridge") then
            Script.Functions.Alert("游戏未运行", 3)
            return
        end
        Script.Functions.RevealGlassBridge()
        Script.Functions.Alert("已揭示玻璃桥", 3)
    end
})

-- 捉迷藏游戏
local hideSeekGroup = Tabs.Combat:Section({ Title = "捉迷藏游戏", Icon = "user", Opened = true })

hideSeekGroup:Button({
    Title = "传送到躲藏者",
    Icon = "target",
    Callback = function()
        if not lplr.Character then return end
        if Script.GameState ~= "HideAndSeek" then 
            Script.Functions.Alert("游戏未运行!", 3)
            return
        end
        local hider = Script.Functions.GetHider()
        if not hider then
            Script.Functions.Alert("未找到躲藏者", 3)
            return 
        end
        lplr.Character:PivotTo(hider:GetPrimaryPartCFrame())
        Script.Functions.Alert("已传送到躲藏者", 3)
    end
})

-- 米格尔游戏
local mingleGroup = Tabs.Combat:Section({ Title = "米格尔游戏", Icon = "users", Opened = true })

local autoMingleState = false
mingleGroup:Toggle({
    Title = "自动米格尔QTE",
    Value = false,
    Callback = function(state)
        autoMingleState = state
        if state then
            Script.Temp.AutoMingleQTEActive = true
            Script.Temp.AutoMingleQTEThread = task.spawn(function()
                while autoMingleState do
                    local character = lplr.Character
                    if character then
                        for _, obj in pairs(character:GetChildren()) do
                            if obj:IsA("RemoteEvent") and obj.Name == "RemoteForQTE" then
                                pcall(function() obj:FireServer() end)
                                break
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if Script.Temp.AutoMingleQTEThread then task.cancel(Script.Temp.AutoMingleQTEThread) end
        end
        Script.Functions.Alert(state and "自动米格尔QTE已启用" or "自动米格尔QTE已禁用", 3)
    end
})

-- 叛军游戏
local rebelGroup = Tabs.Combat:Section({ Title = "叛军游戏", Icon = "shield", Opened = true })

local expandHitboxState = false
rebelGroup:Toggle({
    Title = "扩大守卫命中框",
    Value = false,
    Callback = function(state)
        expandHitboxState = state
        local processedModels = {}
        local TARGET_SIZE = Vector3.new(4, 4, 4)
        local DEFAULT_SIZE = Vector3.new(1, 1, 1)
        
        if state then
            task.spawn(function()
                repeat
                    local liveFolder = workspace:FindFirstChild("Live")
                    if not expandHitboxState or not liveFolder then return end
                    for _, model in ipairs(liveFolder:GetChildren()) do
                        if not processedModels[model] and not Players:FindFirstChild(model.Name) then
                            local head = model:FindFirstChild("Head")
                            if head and head:IsA("BasePart") then
                                processedModels[model] = head
                            end
                        end
                    end
                    for model, head in pairs(processedModels) do
                        if model and model.Parent and head and head.Parent then
                            if head.Size ~= TARGET_SIZE then
                                head.Size = TARGET_SIZE
                                head.CanCollide = false
                            end
                        else
                            processedModels[model] = nil
                        end
                    end
                    task.wait(3)
                until not expandHitboxState
            end)
        end
        Script.Functions.Alert(state and "扩大守卫命中框已启用" or "扩大守卫命中框已禁用", 3)
    end
})

-- ==================== 透视选项卡 ====================
local espSettingsGroup = Tabs.ESP:Section({ Title = "透视设置", Icon = "eye", Opened = true })

espSettingsGroup:Toggle({
    Title = "启用高亮",
    Value = true,
    Callback = function(state) Script.Temp.ESPHighlight = state end
})

espSettingsGroup:Toggle({
    Title = "显示距离",
    Value = true,
    Callback = function(state) Script.Temp.ESPDistance = state end
})

espSettingsGroup:Slider({
    Title = "填充透明度",
    Value = { Min = 0, Max = 1, Default = 0.75 },
    Step = 0.05,
    Callback = function(value) Script.Temp.ESPFillTransparency = value end
})

espSettingsGroup:Slider({
    Title = "轮廓透明度",
    Value = { Min = 0, Max = 1, Default = 0 },
    Step = 0.05,
    Callback = function(value) Script.Temp.ESPOutlineTransparency = value end
})

espSettingsGroup:Slider({
    Title = "文字大小",
    Value = { Min = 16, Max = 32, Default = 22 },
    Callback = function(value) Script.Temp.ESPTextSize = value end
})

local playerEspGroup = Tabs.ESP:Section({ Title = "玩家透视", Icon = "user", Opened = true })

local playerEspState = false
playerEspGroup:Toggle({
    Title = "玩家透视",
    Value = false,
    Callback = function(state)
        playerEspState = state
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= lplr then
                    Script.Functions.PlayerESP(player)
                end
            end
        else
            for _, esp in pairs(Script.ESPTable.Player) do
                pcall(function() esp.Destroy() end)
            end
        end
    end
})

playerEspGroup:Colorpicker({
    Title = "玩家颜色",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color) 
        Script.Temp.PlayerEspColor = color
        for _, esp in pairs(Script.ESPTable.Player) do
            pcall(function() esp.SetColor(color) end)
        end
    end
})

local guardEspState = false
playerEspGroup:Toggle({
    Title = "守卫透视",
    Value = false,
    Callback = function(state)
        guardEspState = state
        if state then
            local live = workspace:FindFirstChild("Live")
            if live then
                for _, descendant in pairs(live:GetChildren()) do
                    if descendant:IsA("Model") and descendant.Parent and descendant.Parent.Name == "Live" and descendant:FindFirstChild("TypeOfGuard") then
                        if string.find(descendant.Name, "Guard") then
                            Script.Functions.GuardESP(descendant)
                        end
                    end
                end
            end
        else
            for _, esp in pairs(Script.ESPTable.Guard) do
                pcall(function() esp.Destroy() end)
            end
        end
    end
})

playerEspGroup:Colorpicker({
    Title = "守卫颜色",
    Default = Color3.fromRGB(200, 100, 200),
    Callback = function(color) 
        Script.Temp.GuardEspColor = color
        for _, esp in pairs(Script.ESPTable.Guard) do
            pcall(function() esp.SetColor(color) end)
        end
    end
})

local hideSeekEspGroup = Tabs.ESP:Section({ Title = "捉迷藏透视", Icon = "eye-off", Opened = true })

local seekerEspState = false
hideSeekEspGroup:Toggle({
    Title = "追踪者透视",
    Value = false,
    Callback = function(state)
        seekerEspState = state
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                Script.Functions.SeekerESP(player)
            end
        else
            for _, esp in pairs(Script.ESPTable.Seeker) do
                pcall(function() esp.Destroy() end)
            end
        end
    end
})

hideSeekEspGroup:Colorpicker({
    Title = "追踪者颜色",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color) 
        Script.Temp.SeekerEspColor = color
        for _, esp in pairs(Script.ESPTable.Seeker) do
            pcall(function() esp.SetColor(color) end)
        end
    end
})

local hiderEspState = false
hideSeekEspGroup:Toggle({
    Title = "躲藏者透视",
    Value = false,
    Callback = function(state)
        hiderEspState = state
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                Script.Functions.HiderESP(player)
            end
        else
            for _, esp in pairs(Script.ESPTable.Hider) do
                pcall(function() esp.Destroy() end)
            end
        end
    end
})

hideSeekEspGroup:Colorpicker({
    Title = "躲藏者颜色",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color) 
        Script.Temp.HiderEspColor = color
        for _, esp in pairs(Script.ESPTable.Hider) do
            pcall(function() esp.SetColor(color) end)
        end
    end
})

local keyEspState = false
hideSeekEspGroup:Toggle({
    Title = "钥匙透视",
    Value = false,
    Callback = function(state)
        keyEspState = state
        if state then
            local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
            if hideAndSeekMap then
                local keysFolder = hideAndSeekMap:FindFirstChild("KEYS")
                if keysFolder then
                    for _, key in pairs(keysFolder:GetChildren()) do
                        Script.Functions.KeyESP(key)
                    end
                end
            end
        else
            for _, esp in pairs(Script.ESPTable.Key) do
                pcall(function() esp.Destroy() end)
            end
        end
    end
})

hideSeekEspGroup:Colorpicker({
    Title = "钥匙颜色",
    Default = Color3.fromRGB(255, 255, 0),
    Callback = function(color) 
        Script.Temp.KeyEspColor = color
        for _, esp in pairs(Script.ESPTable.Key) do
            pcall(function() esp.SetColor(color) end)
        end
    end
})

local doorEspState = false
hideSeekEspGroup:Toggle({
    Title = "门透视",
    Value = false,
    Callback = function(state)
        doorEspState = state
        if state then
            local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
            if hideAndSeekMap then
                local newFixedDoors = hideAndSeekMap:FindFirstChild("NEWFIXEDDOORS")
                if newFixedDoors then
                    for _, floor in pairs(newFixedDoors:GetChildren()) do
                        if floor.Name:match("^Floor") then
                            for _, door in pairs(floor:GetChildren()) do
                                Script.Functions.DoorESP(door)
                            end
                        end
                    end
                end
            end
        else
            for _, esp in pairs(Script.ESPTable.Door) do
                pcall(function() esp.Destroy() end)
            end
        end
    end
})

hideSeekEspGroup:Colorpicker({
    Title = "门颜色",
    Default = Color3.fromRGB(0, 128, 255),
    Callback = function(color) 
        Script.Temp.DoorEspColor = color
        for _, esp in pairs(Script.ESPTable.Door) do
            pcall(function() esp.SetColor(color) end)
        end
    end
})

-- ==================== 移动选项卡 ====================
local moveGroup = Tabs.Movement:Section({ Title = "移动功能", Icon = "wind", Opened = true })

local speedState = false
local speedValue = 16
moveGroup:Toggle({
    Title = "加速",
    Value = false,
    Callback = function(state)
        speedState = state
        if state and lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            lplr.Character.Humanoid.WalkSpeed = speedValue
        elseif not state and lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            lplr.Character.Humanoid.WalkSpeed = 16
        end
        Script.Functions.Alert(state and "加速已启用" or "加速已禁用", 3)
    end
})

moveGroup:Slider({
    Title = "速度值",
    Value = { Min = 0, Max = 300, Default = 16 },
    Callback = function(value)
        speedValue = value
        if speedState and lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            lplr.Character.Humanoid.WalkSpeed = value
        end
    end
})

local noclipState = false
moveGroup:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(state)
        noclipState = state
        if state then
            task.spawn(function()
                repeat
                    if lplr.Character then
                        for _, child in pairs(lplr.Character:GetDescendants()) do
                            if child:IsA("BasePart") then
                                child.CanCollide = false
                            end
                        end
                    end
                    RunService.Heartbeat:Wait()
                until not noclipState
            end)
        else
            if lplr.Character then
                for _, child in pairs(lplr.Character:GetDescendants()) do
                    if child:IsA("BasePart") then
                        child.CanCollide = true
                    end
                end
            end
        end
        Script.Functions.Alert(state and "穿墙已启用" or "穿墙已禁用", 3)
    end
})

local infiniteJumpState = false
moveGroup:Toggle({
    Title = "无限跳跃",
    Value = false,
    Callback = function(state)
        infiniteJumpState = state
        Script.Functions.Alert(state and "无限跳跃已启用" or "无限跳跃已禁用", 3)
    end
})

local flyState = false
local flySpeed = 50
moveGroup:Toggle({
    Title = "飞行",
    Value = false,
    Callback = function(state)
        flyState = state
        local rootPart = Script.Functions.GetRootPart()
        if not rootPart then return end
        
        local humanoid = Script.Functions.GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = state
        end
        
        local flyBody = Script.Temp.FlyBody or Instance.new("BodyVelocity")
        flyBody.Velocity = Vector3.zero
        flyBody.MaxForce = Vector3.one * 9e9
        Script.Temp.FlyBody = flyBody
        Script.Temp.FlyBody.Parent = state and rootPart or nil
        
        if state then
            local controlModule = Script.Functions.SafeRequire(lplr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
            Script.Temp.FlyConnection = RunService.RenderStepped:Connect(function()
                local moveVector = controlModule:GetMoveVector()
                local velocity = -((camera.CFrame.LookVector * moveVector.Z) - (camera.CFrame.RightVector * moveVector.X)) * flySpeed
                if Script.Temp.FlyBody then
                    Script.Temp.FlyBody.Velocity = velocity
                end
            end)
        else
            if Script.Temp.FlyConnection then
                Script.Temp.FlyConnection:Disconnect()
                Script.Temp.FlyConnection = nil
            end
        end
        Script.Functions.Alert(state and "飞行已启用" or "飞行已禁用", 3)
    end
})

moveGroup:Slider({
    Title = "飞行速度",
    Value = { Min = 10, Max = 300, Default = 50 },
    Callback = function(value) flySpeed = value end
})

-- ==================== 其他选项卡 ====================
local miscGroup = Tabs.Misc:Section({ Title = "其他功能", Icon = "settings", Opened = true })

local antiRagdollState = false
miscGroup:Toggle({
    Title = "防倒地 + 无眩晕",
    Value = false,
    Callback = function(state)
        antiRagdollState = state
        if state then
            Script.Functions.BypassRagdoll()
            task.spawn(function()
                repeat
                    task.wait()
                    Script.Functions.BypassRagdoll()
                until not antiRagdollState
            end)
        end
        Script.Functions.Alert(state and "防倒地已启用" or "防倒地已禁用", 3)
    end
})

miscGroup:Button({
    Title = "移除倒地效果",
    Icon = "refresh-cw",
    Callback = function()
        Script.Functions.BypassRagdoll()
        Script.Functions.Alert("已移除倒地效果", 3)
    end
})

miscGroup:Button({
    Title = "修复相机",
    Icon = "camera",
    Callback = function()
        Script.Functions.FixCamera()
        Script.Functions.Alert("相机已修复", 3)
    end
})

miscGroup:Button({
    Title = "传送到安全位置",
    Icon = "map-pin",
    Callback = function()
        if not lplr.Character then
            Script.Functions.Alert("未找到角色", 3)
            return
        end
        Script.Functions.TeleportSafe()
        Script.Functions.Alert("已传送到安全位置", 3)
    end
})

miscGroup:Button({
    Title = "修复玩家可见性",
    Icon = "eye",
    Callback = function()
        Script.Functions.CheckPlayersVisibility()
        Script.Functions.Alert("已修复玩家可见性", 3)
    end
})

local antiAfkState = true
miscGroup:Toggle({
    Title = "反AFK",
    Value = true,
    Callback = function(state)
        antiAfkState = state
        if state then
            Script.Temp.AntiAfkConnection = lplr.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
            end)
        else
            if Script.Temp.AntiAfkConnection then
                Script.Temp.AntiAfkConnection:Disconnect()
            end
        end
        Script.Functions.Alert(state and "反AFK已启用" or "反AFK已禁用", 3)
    end
})

local lowGfxState = false
miscGroup:Toggle({
    Title = "低画质模式",
    Value = false,
    Callback = function(state)
        lowGfxState = state
        if state then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Material ~= Enum.Material.Neon then
                    v.Material = Enum.Material.Plastic
                end
            end
        end
        Script.Functions.Alert(state and "低画质模式已启用" or "低画质模式已禁用", 3)
    end
})

-- ==================== 配置选项卡 ====================
local configGroup = Tabs.Config:Section({ Title = "配置管理", Icon = "save", Opened = true })

configGroup:Paragraph({
    Title = "配置管理器",
    Desc = "保存和加载你的设置",
    Image = "save",
    ImageSize = 20
})

local configName = "default"
configGroup:Input({
    Title = "配置名称",
    Value = configName,
    Callback = function(value) configName = value end
})

configGroup:Button({
    Title = "保存配置",
    Icon = "save",
    Variant = "Primary",
    Callback = function()
        local configData = {
            speedState = speedState,
            speedValue = speedValue,
            noclipState = noclipState,
            infiniteJumpState = infiniteJumpState,
            flyState = flyState,
            flySpeed = flySpeed,
            autowinState = autowinState,
            killauraState = killauraState,
            flingAuraState = flingAuraState,
            antiFlingState = antiFlingState,
            autoPullState = autoPullState,
            perfectPullState = perfectPullState,
            autoMingleState = autoMingleState,
            expandHitboxState = expandHitboxState,
            antiRagdollState = antiRagdollState,
            antiAfkState = antiAfkState,
            lowGfxState = lowGfxState,
            playerEspState = playerEspState,
            guardEspState = guardEspState,
            seekerEspState = seekerEspState,
            hiderEspState = hiderEspState,
            keyEspState = keyEspState,
            doorEspState = doorEspState,
            espHighlight = Script.Temp.ESPHighlight,
            espDistance = Script.Temp.ESPDistance,
            espFillTransparency = Script.Temp.ESPFillTransparency,
            espOutlineTransparency = Script.Temp.ESPOutlineTransparency,
            espTextSize = Script.Temp.ESPTextSize
        }
        writefile("RTaOHUB_InkGame_" .. configName .. ".json", game:GetService("HttpService"):JSONEncode(configData))
        Script.Functions.Alert("配置已保存: " .. configName, 3)
    end
})

configGroup:Button({
    Title = "加载配置",
    Icon = "folder",
    Callback = function()
        local file = "RTaOHUB_InkGame_" .. configName .. ".json"
        if isfile(file) then
            local data = game:GetService("HttpService"):JSONDecode(readfile(file))
            if data.speedState then speedState = data.speedState end
            if data.speedValue then speedValue = data.speedValue end
            if data.noclipState then noclipState = data.noclipState end
            if data.infiniteJumpState then infiniteJumpState = data.infiniteJumpState end
            if data.flyState then flyState = data.flyState end
            if data.flySpeed then flySpeed = data.flySpeed end
            if data.autowinState then autowinState = data.autowinState end
            if data.killauraState then killauraState = data.killauraState end
            if data.flingAuraState then flingAuraState = data.flingAuraState end
            if data.antiFlingState then antiFlingState = data.antiFlingState end
            if data.autoPullState then autoPullState = data.autoPullState end
            if data.perfectPullState then perfectPullState = data.perfectPullState end
            if data.autoMingleState then autoMingleState = data.autoMingleState end
            if data.expandHitboxState then expandHitboxState = data.expandHitboxState end
            if data.antiRagdollState then antiRagdollState = data.antiRagdollState end
            if data.antiAfkState then antiAfkState = data.antiAfkState end
            if data.lowGfxState then lowGfxState = data.lowGfxState end
            if data.playerEspState then playerEspState = data.playerEspState end
            if data.guardEspState then guardEspState = data.guardEspState end
            if data.seekerEspState then seekerEspState = data.seekerEspState end
            if data.hiderEspState then hiderEspState = data.hiderEspState end
            if data.keyEspState then keyEspState = data.keyEspState end
            if data.doorEspState then doorEspState = data.doorEspState end
            if data.espHighlight then Script.Temp.ESPHighlight = data.espHighlight end
            if data.espDistance then Script.Temp.ESPDistance = data.espDistance end
            if data.espFillTransparency then Script.Temp.ESPFillTransparency = data.espFillTransparency end
            if data.espOutlineTransparency then Script.Temp.ESPOutlineTransparency = data.espOutlineTransparency end
            if data.espTextSize then Script.Temp.ESPTextSize = data.espTextSize end
            Script.Functions.Alert("配置已加载: " .. configName, 3)
        else
            Script.Functions.Alert("配置不存在: " .. configName, 3)
        end
    end
})

configGroup:Button({
    Title = "列出所有配置",
    Icon = "list",
    Callback = function()
        local files = listfiles()
        local list = "配置文件列表:\n"
        for _, file in pairs(files) do
            if string.match(file, "RTaOHUB_InkGame_") then
                list = list .. file .. "\n"
            end
        end
        Script.Functions.Alert(list, 10)
    end
})

-- ==================== 游戏状态监听 ====================
function Script.Functions.HandleAutowin()
    if not autowinState then return end
    
    pcall(function()
        Script.GameState = workspace.Values.CurrentGame.Value
    end)
    
    if Script.GameState == "RedLightGreenLight" then
        Script.Functions.WinRLGL()
        Script.Functions.Alert("[自动获胜]: 红绿灯游戏", 3)
    elseif Script.GameState == "Mingle" then
        if not autoMingleState then
            autoMingleState = true
        end
        Script.Functions.Alert("[自动获胜]: 米格尔游戏", 3)
    elseif Script.GameState == "TugOfWar" then
        if not autoPullState then
            autoPullState = true
        end
        Script.Functions.Alert("[自动获胜]: 拔河游戏", 3)
    elseif Script.GameState == "GlassBridge" then
        Script.Functions.RevealGlassBridge()
        Script.Functions.WinGlassBridge()
        Script.Functions.Alert("[自动获胜]: 玻璃桥游戏", 3)
    elseif Script.GameState == "HideAndSeek" then
        if lplr:GetAttribute("IsHider") then
            Script.Functions.TeleportSafe()
        end
        Script.Functions.Alert("[自动获胜]: 捉迷藏游戏", 3)
    elseif Script.GameState == "LightsOut" then
        Script.Functions.TeleportSafe()
        Script.Functions.Alert("[自动获胜]: 熄灯游戏", 3)
    elseif Script.GameState == "Dalgona" then
        task.spawn(function()
            repeat task.wait() until Script.Functions.GetDalgonaRemote() or not autowinState
            if not autowinState then return end
            task.wait(3)
            Script.Functions.CompleteDalgonaGame()
            Script.Functions.BypassDalgonaGame()
            Script.Functions.FixCamera()
        end)
        Script.Functions.Alert("[自动获胜]: 焦糖饼游戏", 3)
    else
        Script.Functions.Alert("[自动获胜]: 等待下一个游戏...", 3)
    end
end

-- 监听游戏状态变化
pcall(function()
    workspace:WaitForChild("Values"):WaitForChild("CurrentGame"):GetPropertyChangedSignal("Value"):Connect(function()
        Script.GameState = workspace.Values.CurrentGame.Value
        if autowinState then
            Script.Functions.HandleAutowin()
        end
    end)
end)

-- 监听无限跳跃
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpState and lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
        lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 监听角色添加
lplr.CharacterAdded:Connect(function(char)
    if speedState then
        local hum = char:WaitForChild("Humanoid", 10)
        if hum then hum.WalkSpeed = speedValue end
    end
end)

-- 初始化一些默认值
Script.Temp.ESPHighlight = true
Script.Temp.ESPDistance = true
Script.Temp.ESPFillTransparency = 0.75
Script.Temp.ESPOutlineTransparency = 0
Script.Temp.ESPTextSize = 22
Script.Temp.PlayerEspColor = Color3.fromRGB(255, 255, 255)
Script.Temp.GuardEspColor = Color3.fromRGB(200, 100, 200)
Script.Temp.SeekerEspColor = Color3.fromRGB(255, 0, 0)
Script.Temp.HiderEspColor = Color3.fromRGB(0, 255, 0)
Script.Temp.KeyEspColor = Color3.fromRGB(255, 255, 0)
Script.Temp.DoorEspColor = Color3.fromRGB(0, 128, 255)

Script.Functions.Alert("RTaO HUB - Ink Game 已加载!", 5)
Script.Functions.Alert("按 RightShift 打开菜单", 5)

-- 窗口关闭清理
Window:OnClose(function()
    if Script.Temp.AntiAfkConnection then Script.Temp.AntiAfkConnection:Disconnect() end
    if Script.Temp.FlyConnection then Script.Temp.FlyConnection:Disconnect() end
    if Script.Temp.AntiFlingLoop then task.cancel(Script.Temp.AntiFlingLoop) end
    if Script.Temp.AutoMingleQTEThread then task.cancel(Script.Temp.AutoMingleQTEThread) end
    Script.Functions.Alert("RTaO HUB 已卸载", 3)
end)

Window:OnDestroy(function()
    print("窗口已销毁")
end)