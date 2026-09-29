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
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

Lighting.GlobalShadows = false
Lighting.FogEnd = 100000
Lighting.Brightness = 1

settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
Workspace.StreamingEnabled = true

local function optimizeInstance(obj)
	if obj:IsA("BasePart") or obj:IsA("MeshPart") then
		obj.Material = Enum.Material.SmoothPlastic
		obj.CastShadow = false
		obj.Reflectance = 0
	elseif obj:IsA("ParticleEmitter") then
		-- ลดจำนวนและย่อขนาดพาร์ติเคิลสกิลให้เหลือแค่นิดเดียว ไม่ให้หายไปหมด
		obj.Rate = math.clamp(obj.Rate * 0.2, 1, 5)
		if obj.Size then
			local numSeq = obj.Size
			local keypoints = numSeq.Keypoints
			local newKeypoints = {}
			for _, kp in ipairs(keypoints) do
				table.insert(newKeypoints, NumberSequenceKeypoint.new(kp.Time, kp.Value * 0.5, kp.Envelope * 0.5))
			end
			obj.Size = NumberSequence.new(newKeypoints)
		end
	elseif obj:IsA("Trail") or obj:IsA("Beam") then
		-- ย่อความกว้างของหางสกิลและบีมลงครึ่งหนึ่ง
		obj.Width0 = obj.Width0 * 0.5
		obj.Width1 = obj.Width1 * 0.5
	elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
		obj.Enabled = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 1
	elseif obj:IsA("SurfaceLight") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
		obj.Enabled = false
	end
end

for _, descendant in ipairs(Workspace:GetDescendants()) do
	optimizeInstance(descendant)
end

Workspace.DescendantAdded:Connect(optimizeInstance)
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

Lighting.GlobalShadows = false
Lighting.FogEnd = 999999
Lighting.Brightness = 0
Lighting.ClockTime = 14

settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
Workspace.StreamingEnabled = true

local function destroyEverything(obj)
	if obj:IsA("BasePart") or obj:IsA("MeshPart") then
		obj.Material = Enum.Material.SmoothPlastic
		obj.CastShadow = false
		obj.Reflectance = 0
		obj.Color = Color3.fromRGB(150, 150, 150)
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
		obj:Destroy()
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj:Destroy()
	elseif obj:IsA("SurfaceLight") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
		obj:Destroy()
	elseif obj:IsA("Explosion") then
		obj.Visible = false
	end
end

for _, descendant in ipairs(Workspace:GetDescendants()) do
	pcall(function()
		destroyEverything(descendant)
	end)
end

Workspace.DescendantAdded:Connect(function(obj)
	pcall(function()
		destroyEverything(obj)
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Players.LocalPlayer and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") then
				part:Destroy()
			end
		end
	end
end
