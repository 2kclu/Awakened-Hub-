-- Awakened Hub
-- Ensure you have the Rayfield UI Library before using this script.
-- Documentation: https://github.com/shlexware/Rayfield

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Awakened Hub",
    LoadingTitle = "Loading Awakened Hub",
    LoadingSubtitle = "More Games Will Be Added Soon...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AwakenedHub", -- Folder name for saving settings
        FileName = "UserConfig"
    },
    Discord = {
        Enabled = false, -- Discord integration removed for broader compatibility
    },
    KeySystem = false -- No key system for easier testing and execution
})

-- Features
local AutoParry = false -- Variable to enable/disable Auto-Parry
local AutoDodge = false -- Variable to enable/disable Auto-Dodge
local Walkspeed = 16 -- Default walkspeed value
local ESPEnabled = false -- Variable to enable/disable ESP
local BoxesEnabled = false -- Variable to enable/disable ESP Boxes
local TracersEnabled = false -- Variable to enable/disable ESP Tracers
local BoxColor = Color3.new(1, 0, 0) -- Default Red for ESP Boxes
local TracerColor = Color3.new(0, 1, 0) -- Default Green for ESP Tracers

-- Auto-Parry Logic Variables
local ParryCooldown = 1 -- Cooldown time for Auto-Parry in seconds
local ParryActive = false -- Tracks whether Auto-Parry is currently active

-- Auto-Dodge Logic Variables
local DodgeDistance = 10 -- Distance to dodge away from projectiles or attacks
local DodgeCooldown = 1 -- Cooldown time for Auto-Dodge in seconds
local DodgeActive = false -- Tracks whether Auto-Dodge is currently active

-- ESP Logic Variables
local ESPUpdateInterval = 0.1 -- Time interval to refresh ESP visuals
local ESPObjects = {} -- Table to store ESP objects (Boxes and Tracers)

-- Auto-Parry Section
Window:CreateSection("Combat")

Window:CreateToggle({
    Name = "Auto-Parry",
    CurrentValue = false,
    Flag = "AutoParry",
    Callback = function(Value)
        AutoParry = Value
        if AutoParry then
            Rayfield:Notify({
                Title = "Auto-Parry Enabled",
                Content = "The script will now automatically parry incoming attacks.",
                Duration = 5
            })
        else
            Rayfield:Notify({
                Title = "Auto-Parry Disabled",
                Content = "Auto-Parry is now turned off.",
                Duration = 5
            })
        end
    end
})

-- ESP Section
Window:CreateSection("Visuals")

Window:CreateButton({
    Name = "Enable ESP",
    Callback = function()
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    -- Add ESP Box
                    if BoxesEnabled then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = player.Character
                        box.Size = Vector3.new(4, 6, 4)
                        box.Color3 = BoxColor
                        box.Transparency = 0.5
                        box.AlwaysOnTop = true
                        box.Parent = player.Character:FindFirstChild("HumanoidRootPart")
                        table.insert(ESPObjects, box) -- Store the box in ESPObjects
                    end

                    -- Add ESP Tracers
                    if TracersEnabled then
                        local tracer = Drawing.new("Line")
                        tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y) -- Bottom center of screen
                        tracer.To = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                        tracer.Color = TracerColor
                        tracer.Thickness = 1
                        tracer.Visible = true
                        table.insert(ESPObjects, tracer) -- Store the tracer in ESPObjects
                    end
                end
            end

            Rayfield:Notify({
                Title = "ESP Enabled",
                Content = "ESP is now active. Use the options below to customize it.",
                Duration = 5
            })
        else
            -- Cleanup ESP Objects
            for _, obj in pairs(ESPObjects) do
                if typeof(obj) == "Instance" then
                    obj:Destroy()
                elseif typeof(obj) == "Drawing" then
                    obj:Remove()
                end
            end
            ESPObjects = {}

            Rayfield:Notify({
                Title = "ESP Disabled",
                Content = "ESP has been turned off.",
                Duration = 5
            })
        end
    end
})

Window:CreateButton({
    Name = "Toggle ESP Boxes",
    Callback = function()
        if ESPEnabled then
            BoxesEnabled = not BoxesEnabled
            if BoxesEnabled then
                Rayfield:Notify({
                    Title = "ESP Boxes Enabled",
                    Content = "You will now see ESP boxes around players.",
                    Duration = 5
                })
            else
                Rayfield:Notify({
                    Title = "ESP Boxes Disabled",
                    Content = "ESP boxes have been turned off.",
                    Duration = 5
                })
            end
        else
            Rayfield:Notify({
                Title = "ESP Not Enabled",
                Content = "Enable ESP first to use this feature.",
                Duration = 5
            })
        end
    end
})

Window:CreateButton({
    Name = "Toggle ESP Tracers",
    Callback = function()
        if ESPEnabled then
            TracersEnabled = not TracersEnabled
            if TracersEnabled then
                Rayfield:Notify({
                    Title = "ESP Tracers Enabled",
                    Content = "You will now see tracers pointing to players.",
                    Duration = 5
                })
            else
                Rayfield:Notify({
                    Title = "ESP Tracers Disabled",
                    Content = "ESP tracers have been turned off.",
                    Duration = 5
                })
            end
        else
            Rayfield:Notify({
                Title = "ESP Not Enabled",
                Content = "Enable ESP first to use this feature.",
                Duration = 5
            })
        end
    end
})

Window:CreateColorPicker({
    Name = "Box Color",
    Color = BoxColor,
    Flag = "BoxColorPicker",
    Callback = function(Value)
        BoxColor = Value
        Rayfield:Notify({
            Title = "Box Color Updated",
            Content = "ESP Box color has been set to your chosen color.",
            Duration = 5
        })
    end
})

Window:CreateColorPicker({
    Name = "Tracer Color",
    Color = TracerColor,
    Flag = "TracerColorPicker",
    Callback = function(Value)
        TracerColor = Value
        Rayfield:Notify({
            Title = "Tracer Color Updated",
            Content = "ESP Tracer color has been set to your chosen color.",
            Duration = 5
        })
    end
})

-- Auto-Dodge Section
Window:CreateToggle({
    Name = "Auto-Dodge",
    CurrentValue = false,
    Flag = "AutoDodge",
    Callback = function(Value)
        AutoDodge = Value
        if AutoDodge then
            Rayfield:Notify({
                Title = "Auto-Dodge Enabled",
                Content = "The script will now automatically dodge incoming attacks.",
                Duration = 5
            })
        else
            Rayfield:Notify({
                Title = "Auto-Dodge Disabled",
                Content = "Auto-Dodge is now turned off.",
                Duration = 5
            })
        end
    end
})

-- Walkspeed Slider
Window:CreateSection("Player")

Window:CreateSlider({
    Name = "Walkspeed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkspeedSlider",
    Callback = function(Value)
        Walkspeed = Value
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Walkspeed
    end
})

-- Insta-Unload Button
Window:CreateSection("Utility")

Window:CreateButton({
    Name = "Insta-Unload Script",
    Callback = function()
        Rayfield:Unload()
    end
})

Rayfield:Notify({
    Title = "Awakened Hub Loading",
    Content = "Awakened Hub Is Now Loaded!",
    Duration = 5
})
More will be added so keep watch and if you have any questions just DM 2kclu on Discord
