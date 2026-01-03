local Gizmos = require("@src/Gizmos")

local RIGHT_ANGLE = math.pi / 2
local LENGTH = 5

local function DirectionGizmo(mousePosition: Vector3, direction: Vector3)
	Gizmos.pushProperties({ Transparency = 0.5 })

	-- Horizontal line
	Gizmos.drawCylinder(
		CFrame.lookAlong(mousePosition, mousePosition + direction) * CFrame.Angles(0, RIGHT_ANGLE, 0),
		LENGTH * 2
	)

	-- Direction line
	Gizmos.drawCylinder(
		CFrame.lookAlong(mousePosition, mousePosition + direction)
			* CFrame.Angles(RIGHT_ANGLE, 0, 0)
			* CFrame.new(0, 0, LENGTH / 2),
		LENGTH
	)

	-- Normal line
	local normal = 1
	if direction.Y < 0 then
		normal = -1
	end
	Gizmos.drawLine(mousePosition, mousePosition + (Vector3.new(0, normal * LENGTH, 0)))

	Gizmos.popProperties()

	-- Direction arrow
	Gizmos.drawArrow(mousePosition, mousePosition + direction * LENGTH)
end

return DirectionGizmo
