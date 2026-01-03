local LineGizmo = require("./gizmos/LineGizmo")
local types = require("../types")

local ShadowReposition = {} :: types.Reposition
ShadowReposition.id = "shadow"
ShadowReposition.title = "Shadow"
ShadowReposition.describedBy = "moving shadows with your cursor"

function ShadowReposition.update(initial, now, isGizmos)
	local negative = (now.mousePosition - initial.mousePosition)
	local otherDistance = (now.cameraPosition - initial.mousePosition).Magnitude

	if isGizmos then
		LineGizmo(initial.mouseTransform, now.mouseTransform)
	end

	return CFrame.lookAt(initial.mousePosition - initial.sunDirection * otherDistance, initial.mousePosition - negative).LookVector
end

return ShadowReposition
