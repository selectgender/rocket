local Selection = game:GetService("Selection")

local Extension = require("@src/lib/Extension")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-selection",
	title = "Selection",
	description = "Selection utilities",
	icon = "",
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "select-children",
	title = "Select Children",
	description = "Wow",

	run = function()
		local oldSelection = Selection:Get()
		local newSelection = table.clone(oldSelection)
		for _, selected in oldSelection do
			local children = selected:GetChildren()
			table.move(children, 1, #children, #newSelection + 1, newSelection)
		end
		Selection:Set(newSelection)
	end,
})

ext:newCommand({
	id = "select-descendants",
	title = "Select Descendants",
	description = "Wow",

	run = function()
		local oldSelection = Selection:Get()
		local newSelection = table.clone(oldSelection)
		for _, selected in oldSelection do
			local descendants = selected:GetDescendants()
			table.move(descendants, 1, #descendants, #newSelection + 1, newSelection)
		end
		Selection:Set(newSelection)
	end,
})

ext:newCommand({
	id = "pick-children",
	title = "Pick Children",
	description = "Wow",

	run = function()
		local newSelection = {}
		for _, selected in Selection:Get() do
			local children = selected:GetChildren()
			table.move(children, 1, #children, #newSelection + 1, newSelection)
		end
		Selection:Set(newSelection)
	end,
})

ext:newCommand({
	id = "pick-descendants",
	title = "Pick Descendants",
	description = "Wow",

	run = function()
		local newSelection = {}
		for _, selected in Selection:Get() do
			local descendants = selected:GetDescendants()
			table.move(descendants, 1, #descendants, #newSelection + 1, newSelection)
		end
		Selection:Set(newSelection)
	end,
})

ext:newCommand({
	id = "deselect-all",
	title = "Deselect All",
	description = "Wow",

	run = function()
		Selection:Set({})
	end,
})

return ext
