local Gizmos = require("@src/Gizmos")

local function LineGizmo(from: CFrame, to: CFrame)
	Gizmos.drawSphere(from, Gizmos.RADIUS * 2)
	Gizmos.drawLine(from.Position, to.Position)
	Gizmos.drawSphere(to, Gizmos.RADIUS * 2)
end

return LineGizmo
