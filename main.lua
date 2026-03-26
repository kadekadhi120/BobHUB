local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "BobHub | [⚡] Hyper Speed Runner", 
    IntroEnabled = true,
    IntroText = '<font color="#5e00f5">Welcome to BobHub</font>',
    IntroIcon = "rbxassetid://6031289136", 
    HidePremium = false, SaveConfig = true, 
    ConfigFolder = "BobHub",

})

--[[
Name = <string> - The name of the UI.
HidePremium = <bool> - Whether or not the user details shows Premium status or not.
SaveConfig = <bool> - Toggles the config saving in the UI.
ConfigFolder = <string> - The name of the folder where the configs are saved.
IntroEnabled = <bool> - Whether or not to show the intro animation.
IntroText = <string> - Text to show in the intro animation.
IntroIcon = <string> - URL to the image you want to use in the intro animation.
Icon = <string> - URL to the image you want displayed on the window.
CloseCallback = <function> - Function to execute when the window is closed.
]]


-- [[ GLOBAL VALUES ]] --
local player = game.Players.LocalPlayer
_G.TargetSpeed = 16
_G.TargetJumpPower = 50
_G.flyEnabled = false
_G.flySpeed = 50
_G.autoLevelEnabled = false
_G.autoMoneyEnabled = false
_G.autoRebirthEnabled = false

-- Variabel kontrol agar tidak double loop (Anti-Crash)
local levelLoop = false
local moneyLoop = false
local rebirthLoop = false

-- [[ FUNCTIONS ]] --

function SpyHelper()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
end

function AutoLevel()
    if levelLoop then return end
    levelLoop = true
    while _G.autoLevelEnabled do
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("StepTaken") then
            remote.StepTaken:FireServer(2000, false)
        end
        task.wait(0.1)
    end
    levelLoop = false
end

function AutoMoney()
    if moneyLoop then return end
    moneyLoop = true
    while _G.autoMoneyEnabled do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-3, 14, -9077)
        end
        task.wait(2)
    end
    moneyLoop = false
end

function AutoRebirth()
    if rebirthLoop then return end
    rebirthLoop = true
    while _G.autoRebirthEnabled do
  local args = {"free"}
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("RequestRebirth")
            :FireServer(unpack(args))
        
        task.wait(20)
    end
    rebirthLoop = false
end

-- [[ TABS ]] --

local AutoFarm = Window:MakeTab({ Name = "Auto Farm", Icon = "rbxassetid://4483345998" })
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://4483345998" })
local Helper = Window:MakeTab({ Name = "Helper", Icon = "rbxassetid://4483345998" })

-- [[ AUTO FARM ]] --
AutoFarm:AddToggle({
    Name = "Auto Level",
    Default = false,
    Callback = function(Value)
        _G.autoLevelEnabled = Value
        if Value then task.spawn(AutoLevel) end
    end    
})

AutoFarm:AddToggle({
    Name = "Auto Money",
    Default = false,
    Callback = function(Value)
        _G.autoMoneyEnabled = Value
        if Value then task.spawn(AutoMoney) end
    end    
})

AutoFarm:AddToggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(Value)
        _G.autoRebirthEnabled = Value
        if Value then task.spawn(AutoRebirth) end
    end    
})

-- [[ PLAYER ]] --

PlayerTab:AddToggle({
    Name = "Fly (Press E to Fly)",
    Default = false,
    Callback = function(Value)
        _G.flyEnabled = Value
    end    
})

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 50, Max = 500, Default = 50,
    Callback = function(Value) 
        _G.flySpeed = Value 
    end    
})

PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16, Max = 250, Default = 16,
    Callback = function(Value) 
        _G.TargetSpeed = Value 
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50, Max = 500, Default = 50,
    Callback = function(Value) 
        _G.TargetJumpPower = Value 
    end    
})

-- [[ HELPER ]] --

Helper:AddButton({
    Name = "Enable Spy Helper",
    Callback = function()
        SpyHelper()
        OrionLib:MakeNotification({
            Name = "Spy Active",
            Content = "Remote Spy has been loaded.",
            Time = 5
        })
    end    
})

-- [[ BACKGROUND LOOPS ]] --

-- Loop untuk Speed & Jump (Selalu Jalan)
task.spawn(function()
    while true do
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = _G.TargetSpeed
            hum.UseJumpPower = true
            hum.JumpPower = _G.TargetJumpPower
        end
        task.wait(0.1)
    end
end)

-- Sistem Fly (Inisialisasi Sekali)
local function InitFly()
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local flying = false
    local bv, bg

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.E and _G.flyEnabled then
            flying = not flying
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            if flying then
                player.Character.Humanoid.PlatformStand = true
                bg = Instance.new("BodyGyro", root)
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.P = 9e4
                bv = Instance.new("BodyVelocity", root)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            else
                player.Character.Humanoid.PlatformStand = false
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if flying and _G.flyEnabled then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and bv and bg then
                local cam = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                
                bv.velocity = dir.Magnitude > 0 and (dir.Unit * _G.flySpeed) or Vector3.new(0, 0.1, 0)
                bg.cframe = cam
            end
        elseif flying and not _G.flyEnabled then
            flying = false
            if player.Character then player.Character.Humanoid.PlatformStand = false end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end)
end

InitFly()
OrionLib:Init()