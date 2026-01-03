local DirectionGizmo = require("./gizmos/DirectionGizmo")
local reflect = require("../reflect")
local types = require("../types")

local ReflectionReposition = {} :: types.Reposition
ReflectionReposition.id = "reflection"
ReflectionReposition.title = "Reflection"
ReflectionReposition.describedBy = "reflection at your mouse"

function ReflectionReposition.update(_, now, isGizmos)
	local reflection = reflect(now.mouseDirection, Vector3.new(0, 1, 0))
	local direction = CFrame.lookAt(now.mousePosition, now.mousePosition + reflection).LookVector

	if isGizmos then
		DirectionGizmo(now.mousePosition, direction)
	end

	return direction
end

return ReflectionReposition
