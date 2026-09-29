local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 999999
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
end)

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Workspace.StreamingEnabled = true
end)

local function optimizeInstance(obj)
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
        obj.Reflectance = 0
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        obj:Destroy()
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("SurfaceLight") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
        obj:Destroy()
    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    elseif obj:IsA("Highlight") then
        obj.Enabled = false
    end
end

for _, v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        optimizeInstance(v)
    end)
end

Workspace.DescendantAdded:Connect(function(v)
    pcall(function()
        optimizeInstance(v)
    end)
end)
