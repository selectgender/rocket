local LineGizmo = require("./gizmos/LineGizmo")
local types = require("../types")

local LineReposition = {} :: types.Reposition
LineReposition.id = "line"
LineReposition.title = "Line"
LineReposition.describedBy = "a line that shadows will follow"

function LineReposition.update(initial, now, isGizmos)
	local transform = CFrame.lookAt(now.mouseTransform.Position, initial.mouseTransform.Position)
	if isGizmos then
		LineGizmo(initial.mouseTransform, now.mouseTransform)
	end
	return transform.LookVector
end

return LineReposition
