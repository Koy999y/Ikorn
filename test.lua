--[========================================================]
--[           ULTRA POTATO ENGINE (PRO EDITION)          ]
--[========================================================]

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Configure Lighting environment safely
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    Lighting.FogEnd = 999999
end)

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- Optimized check: Determines if an instance belongs to any player character
local function isProtected(instance)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and (instance == char or instance:IsDescendantOf(char)) then
            return true
        end
    end
    return false
end

-- Efficient processing function for workspace descendants
local function optimizeInstance(v)
    if isProtected(v) then return end

    local className = v.ClassName
    if className == "ParticleEmitter" or className == "Trail" or className == "Fire" or className == "Smoke" or className == "Sparkles" or className == "BillboardGui" then
        v:Destroy()
    elseif className == "MeshPart" then
        v.MeshId = ""
        v.Material = Enum.Material.Plastic
        v.CastShadow = false
    elseif className == "BasePart" then
        v.Material = Enum.Material.SmoothPlastic
        v.CastShadow = false
    end
end

-- Batch processing using task.defer to prevent frame drops/stutter on execution
task.defer(function()
    local descendants = Workspace:GetDescendants()
    local batchSize = 250
    
    for i = 1, #descendants, batchSize do
        for j = i, math.min(i + batchSize - 1, #descendants) do
            pcall(optimizeInstance, descendants[j])
        end
        RunService.Heartbeat:Wait()
    end
end)

-- Real-time listener for newly spawned elements
Workspace.DescendantAdded:Connect(function(v)
    task.spawn(function()
        pcall(optimizeInstance, v)
    end)
end)
