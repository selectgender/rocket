local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local typeforge = require("@vendor/typeforge")
local Terrain = Workspace:WaitForChild("Terrain")

export type Properties = {
	Color3: Color3,
	Transparency: number,
}

export type PartialProperties = typeforge.Partial<Properties>

local RADIUS = 0.05
local POINT_RADIUS = 0.5
local BASE_PROEPRTIES = {
	Adornee = Terrain,
	AlwaysOnTop = true,
	AdornCullingMode = Enum.AdornCullingMode.Automatic,
	Color3 = Color3.new(1, 1, 1),
	Transparency = 0,
	Visible = false,
	ZIndex = 1,
}

local classPool: { [string]: { Instance } } = {}
local previous: { GuiBase3d }, queue: { GuiBase3d } = {}, {}
local propertyStack: { { [string]: any } } = { BASE_PROEPRTIES }

local Gizmos = {}
Gizmos.RADIUS = RADIUS
Gizmos.POINT_RADIUS = POINT_RADIUS

function Gizmos.pushProperties(delta: PartialProperties)
	table.insert(propertyStack, delta :: { [string]: any })
end

function Gizmos.popProperties()
	if #propertyStack > 1 then
		table.remove(propertyStack)
	end
end

function Gizmos.style(adornment: GuiBase3d)
	for _, properties in propertyStack do
		for property, value in pairs(properties) do
			(adornment :: any)[property] = value
		end
	end
end

function Gizmos.getFolder(): Instance
	local gizmos = CoreGui:FindFirstChild("RocketGizmos") :: Instance
	if not gizmos then
		gizmos = Instance.new("Folder")
		gizmos.Name = "RocketGizmos"
		gizmos.Parent = CoreGui
		gizmos.Archivable = false
	end

	return gizmos
end

function Gizmos.getPooled(class: string): any
	local instancePool = classPool[class]
	if instancePool then
		local pooled = table.remove(instancePool)
		if pooled then
			return pooled
		end
	end

	local pooled = Instance.new(class)
	pooled.Parent = Gizmos.getFolder()
	return pooled
end

function Gizmos.releasePooled(instance: Instance)
	local class = instance.ClassName
	local instancePool = classPool[class]
	if not instancePool then
		instancePool = {}
		classPool[class] = instancePool
	end
	table.insert(instancePool, instance)
end

function Gizmos.destroyPool()
	for index, instances in classPool do
		for instanceIndex, instance in instances do
			instance:Destroy()
			instances[instanceIndex] = nil
		end
		classPool[index] = nil
	end
end

function Gizmos.step()
	for _, adornment in previous do
		adornment.Visible = false
		Gizmos.releasePooled(adornment)
	end

	table.clear(previous)

	for _, adornment in queue do
		adornment.Visible = true
	end

	previous = queue
	queue = {}
end

function Gizmos.drawSphere(transform: CFrame, radius: number?)
	local adornment: SphereHandleAdornment = Gizmos.getPooled("SphereHandleAdornment")
	Gizmos.style(adornment)
	adornment.Radius = radius or RADIUS
	adornment.CFrame = transform
	table.insert(queue, adornment)
end

function Gizmos.drawCylinder(transform: CFrame, height: number, radius: number?)
	local adornment: CylinderHandleAdornment = Gizmos.getPooled("CylinderHandleAdornment")
	Gizmos.style(adornment)
	adornment.CFrame = transform
	adornment.Radius = radius or RADIUS
	adornment.InnerRadius = 0
	adornment.Height = height
	table.insert(queue, adornment)
end

function Gizmos.drawLine(from: Vector3, to: Vector3)
	local distance = (to - from).magnitude
	local adornment: CylinderHandleAdornment = Gizmos.getPooled("CylinderHandleAdornment")
	Gizmos.style(adornment)
	adornment.Radius = RADIUS
	adornment.InnerRadius = 0
	adornment.Height = distance
	adornment.CFrame = CFrame.lookAt(from, to) * CFrame.new(0, 0, -distance * 0.5)
	table.insert(queue, adornment)
end

function Gizmos.drawArrow(from: Vector3, to: Vector3)
	local distance = (to - from).magnitude - POINT_RADIUS
	local orientation = CFrame.lookAt(from, to)

	local adornmentLine: CylinderHandleAdornment = Gizmos.getPooled("CylinderHandleAdornment")
	Gizmos.style(adornmentLine)
	adornmentLine.Radius = RADIUS
	adornmentLine.InnerRadius = 0
	adornmentLine.Height = distance
	adornmentLine.CFrame = orientation * CFrame.new(0, 0, -distance * 0.5)
	table.insert(queue, adornmentLine)

	local adornmentCone: ConeHandleAdornment = Gizmos.getPooled("ConeHandleAdornment")
	Gizmos.style(adornmentCone)
	adornmentCone.Height = POINT_RADIUS
	adornmentCone.Radius = POINT_RADIUS * 0.5
	adornmentCone.CFrame = orientation * CFrame.new(0, 0, -distance)
	table.insert(queue, adornmentCone)
end

return table.freeze(Gizmos)
