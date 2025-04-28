-- Awakened Hub v2

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not getgenv then
    error("Incompatible executor!")
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Screen GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AwakenedHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 500)
Frame.Position = UDim2.new(0, 10, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Chroma Animation Label
local ChromaLabel = Instance.new("TextLabel", Frame)
ChromaLabel.Position = UDim2.new(0, 10, 0, 10)
ChromaLabel.Size = UDim2.new(0, 280, 0, 40)
ChromaLabel.BackgroundTransparency = 1
ChromaLabel.Text = "Awakened Hub"
ChromaLabel.Font = Enum.Font.SourceSansBold
ChromaLabel.TextSize = 28
ChromaLabel.TextStrokeTransparency = 0.5
ChromaLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

-- Chroma Animation
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        ChromaLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end
end)

-- Buttons layout
local ButtonY = 60
local function CreateButton(name, callback, enabled)
    local button = Instance.new("TextButton", Frame)
    button.Size = UDim2.new(0, 280, 0, 40)
    button.Position = UDim2.new(0, 10, 0, ButtonY)
    button.BackgroundColor3 = enabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Text = name
    button.MouseButton1Click:Connect(callback)
    
    ButtonY = ButtonY + 50
    return button
end

-- Variables
local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local BoxColor = Color3.fromRGB(255, 0, 0)
local TracerColor = Color3.fromRGB(255, 0, 0)
local AutoParryEnabled = false
local AutoDodgeEnabled = false
local WalkSpeedValue = 16

-- ESP creation
function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    local highlight = Instance.new("Highlight", player.Character)
    highlight.FillColor = BoxColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

    if ESPEnabled then
        local tracer = Instance.new("Part", player.Character)
        tracer.Size = Vector3.new(0.2, 0.2, (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        tracer.Anchored = true
        tracer.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, player.Character.HumanoidRootPart.Position)
        tracer.Color = TracerColor
    end
end

-- Auto-Parry
CreateButton("Toggle Auto-Parry", function()
    AutoParryEnabled = not AutoParryEnabled
end)

RunService.RenderStepped:Connect(function()
    if not AutoParryEnabled then return end
    local Ball = workspace:FindFirstChild("Ball")
    if Ball and Ball:FindFirstChild("Velocity") then
        local distance = (Ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance < 25 and Ball.Velocity.Magnitude > 10 then
            local args = {[1] = true}
            game:GetService("ReplicatedStorage").Remotes.Parry:FireServer(unpack(args))
        end
    end
end)

-- Auto-Dodge
CreateButton("Toggle Auto-Dodge", function()
    AutoDodgeEnabled = not AutoDodgeEnabled
end)

RunService.RenderStepped:Connect(function()
    if not AutoDodgeEnabled then return end
    local Ball = workspace:FindFirstChild("Ball")
    if Ball then
        local distance = (Ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance < 20 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 5)
        end
    end
end)

-- WalkSpeed Slider
CreateButton("WalkSpeed", function()
    local input = tonumber(game:GetService("Players").LocalPlayer:PromptInput("Enter WalkSpeed (1-200):"))
    if input and input >= 1 and input <= 200 then
        WalkSpeedValue = input
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
        end
    end
end)

-- ESP Toggles
local espButton = CreateButton("Toggle ESP", function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        espBoxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        espTracerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        espBoxButton.TextColor3 = Color3.fromRGB(100, 100, 100)
        espTracerButton.TextColor3 = Color3.fromRGB(100, 100, 100)
        espBoxButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espTracerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end, true)

local espBoxButton = CreateButton("Toggle Boxes", function()
    if ESPEnabled then
        -- Toggle Boxes logic here
    end
end, false)

local espTracerButton = CreateButton("Toggle Tracers", function()
    if ESPEnabled then
        -- Toggle Tracers logic here
    end
end, false)

-- Set Colors
CreateButton("Set ESP Color", function()
    local input = game:GetService("Players").LocalPlayer:PromptInput("Enter RGB (e.g., 255,0,0):")
    if input then
        local r, g, b = string.match(input, "(%d+),(%d+),(%d+)")
        if r and g and b then
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
            if r and g and b and r <= 255 and g <= 255 and b <= 255 then
                ESPColor = Color3.fromRGB(r, g, b)
            end
        end
    end
end)

CreateButton("Set Box Color", function()
    local input = game:GetService("Players").LocalPlayer:PromptInput("Enter RGB (e.g., 255,0,0):")
    if input then
        local r, g, b = string.match(input, "(%d+),(%d+),(%d+)")
        if r and g and b then
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
            if r and g and b and r <= 255 and g <= 255 and b <= 255 then
                BoxColor = Color3.fromRGB(r, g, b)
            end
        end
    end
end)

CreateButton("Set Tracer Color", function()
    local input = game:GetService("Players").LocalPlayer:PromptInput("Enter RGB (e.g., 255,0,0):")
    if input then
        local r, g, b = string.match(input, "(%d+),(%d+),(%d+)")
        if r and g and b then
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
            if r and g and b and r <= 255 and g <= 255 and b <= 255 then
                TracerColor = Color3.fromRGB(r, g, b)
            end
        end
    end
end)

-- Unload Awakened Hub
CreateButton("Unload Awakened Hub", function()
    ScreenGui:Destroy()
end)

-- QUICK UNLOAD
CreateButton("QUICK UNLOAD", function()
    LocalPlayer:Kick("Quick Unloaded!")
end)

print("Awakened Hub v2 Loaded Successfully.")

More Will Be added so keep watch and if you have any questions just DM 2kclu on Discord
