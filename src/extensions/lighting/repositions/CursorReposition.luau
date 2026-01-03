local types = require("../types")

local CursorReposition = {} :: types.Reposition
CursorReposition.id = "cursor"
CursorReposition.title = "Cursor"
CursorReposition.describedBy = "your cursor's position"

function CursorReposition.update(_, now)
	return now.mousePosition
end

return CursorReposition
