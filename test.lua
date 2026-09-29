local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")

lighting.GlobalShadows = false
lighting.FogEnd = 9e9
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

for _, v in pairs(lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterTransparency = 0
    terrain.WaterReflectance = 0
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    end
end
