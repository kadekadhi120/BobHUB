if game.PlaceId == 124473577469410 then
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "BobHub | Be a Lucky Block", 
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
_G.autoSpecialEnabled = false

-- Variabel kontrol agar tidak double loop (Anti-Crash)
local SpecialLoop = false

-- [[ FUNCTIONS ]] --
function autoSpecial()
    if SpecialLoop then return end
    SpecialLoop = true
    
    local RS = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("RunningService"):WaitForChild("RF")

    while _G.autoSpecialEnabled do
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            -- TAHAP 1: Teleport Awal & Remote Pertama (Sesuai script manualmu)
            hrp.CFrame = CFrame.new(651, 53, -2123)
            print("Teleport Awal Berhasil!")
            
            pcall(function()
                RS:WaitForChild("StartRun"):InvokeServer()
                RS:WaitForChild("StartMove"):InvokeServer()
                task.wait(0.1)
                RS:WaitForChild("OpenLuckyBlock"):InvokeServer("base14")
            end)
            
            task.wait(1)

            -- TAHAP 2: Gunakan task.spawn (Sama persis seperti versi manualmu)
            task.spawn(function()
                pcall(function()
                    RS:WaitForChild("StartRun"):InvokeServer()
                    RS:WaitForChild("StartMove"):InvokeServer()
                    task.wait(0.1)
                    RS:WaitForChild("OpenLuckyBlock"):InvokeServer("base14")
                    task.wait(0.5)
                    local cframeArgs = {CFrame.new(670.9, 42.1, -2054.5)}
                    RS:WaitForChild("UpdateCFrame"):InvokeServer(unpack(cframeArgs))
                end)
            end)

            -- TAHAP 3: Tunggu Teleport Akhir (Sesuai script manualmu: 4 detik)
            task.wait(4)
            
            -- Cek ulang karakter (takutnya mati saat nunggu 4 detik)
            char = game.Players.LocalPlayer.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp and _G.autoSpecialEnabled then
                hrp.CFrame = CFrame.new(732, 38, -2121)
                print("Teleport Spawn Berhasil!")
            end
            
            task.wait(2) 
        else
            task.wait(1)
        end
    end
    SpecialLoop = false
end

function SpyHelper()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
end



-- [[ TABS ]] --

local AutoFarm = Window:MakeTab({ Name = "Auto Farm", Icon = "rbxassetid://4483345998" })
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://4483345998" })
local Helper = Window:MakeTab({ Name = "Helper", Icon = "rbxassetid://4483345998" })

-- [[ AUTO FARM ]] --
AutoFarm:AddToggle({
    Name = "Auto Special",
    Default = false,
    Callback = function(Value)
        _G.autoSpecialEnabled = Value
        if Value then
            task.spawn(autoSpecial)
        end
    end    
})

-- [[ PLAYER ]] --

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



end


OrionLib:Init()