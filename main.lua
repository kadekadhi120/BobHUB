local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Title of the library", IntroIcon = "BobHub",HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

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

--value
_G.spyHeler = true
_G.SpeedEnabled = true
_G.TargetSpeed = 16
_G.JumpPowerEnabled = true
_G.TargetJumpPower = 50
_G.flyEnabled = false
_G.flySpeed = 50
	
--Tabs
local Player = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Helper = Window:MakeTab({
	Name = "Helper",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--button
Helper:AddButton({
    Name = "Enable Spy Helper",
    Callback = function(Value)
        if Value then
            SpyHelper()
            OrionLib:MakeNotification({
                Name = "Spy Active",
                Content = "Remote Spy has been loaded.",
                Time = 5
            })
        end
    end    
})

--toggle
Player:AddToggle({
	Name = "Fly",
	Default = false,
	Callback = function(Value)
		if Value then
			_G.flyEnabled = Value
			Fly()
		end
	end    
})

--slider
Player:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(Value)
        _G.TargetSpeed = Value
    end    
})
Player:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(Value)
        _G.TargetJumpPower = Value
    end    
})
Player:AddSlider({
	Name = "Fly Speed",
	Min = 50,
	Max = 500,
	Default = 50,
	Callback = function(Value)
		_G.flySpeed = Value
	end    
})

function SpyHelper()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
end

task.spawn(function()
    while _G.SpeedEnabled do
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum and hum.WalkSpeed ~= _G.TargetSpeed then
            hum.WalkSpeed = _G.TargetSpeed
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while _G.JumpPowerEnabled do
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hum then
            if not hum.UseJumpPower then
                hum.UseJumpPower = true
            end

            -- Update the power if it doesn't match your target
            if hum.JumpPower ~= _G.TargetJumpPower then
                hum.JumpPower = _G.TargetJumpPower
            end
        end
        task.wait(0.1)
    end
end)

function Fly()
    local player = game.Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    
    local flying = false
    local bv = nil
    local bg = nil

    -- Keyboard Listener
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E and _G.flyEnabled then
            flying = not flying
            
            if flying then
                hum.PlatformStand = true
                bg = Instance.new("BodyGyro", root)
                bg.Name = "FlyGyro"
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.P = 9e4
                bg.cframe = root.CFrame
                
                bv = Instance.new("BodyVelocity", root)
                bv.Name = "FlyVelocity"
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.velocity = Vector3.new(0, 0, 0)
            else
                hum.PlatformStand = false
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
        end
    end)

    -- Movement Logic
    game:GetService("RunService").RenderStepped:Connect(function()
        if flying and _G.flyEnabled and bv and bg then
            local direction = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera.CFrame

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.RightVector end

            -- FIX: We use _G.flySpeed directly here so the slider works
            if direction.Magnitude > 0 then
                bv.velocity = direction.Unit * _G.flySpeed
            else
                bv.velocity = Vector3.new(0, 0.1, 0)
            end

            bg.cframe = camera
        elseif not _G.flyEnabled and flying then
            flying = false
            hum.PlatformStand = false
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end)
end