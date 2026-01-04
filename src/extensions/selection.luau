local Selection = game:GetService("Selection")

local Extension = require("@src/Extension")
local Iris = require("@src/Iris")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-selection",
	title = "Selection",
	description = "Selection utilities.",
	icon = { Image = assets.extensions.selection },
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "select-children",
	title = "Select Children",
	description = "Selects children of the current selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
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
	description = "Selects descendants of the current selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
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
	id = "select-just-children",
	title = "Select Just Children",
	description = "Selects only the children of the current selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		local newSelection = {}
		for _, selected in Selection:Get() do
			local children = selected:GetChildren()
			table.move(children, 1, #children, #newSelection + 1, newSelection)
		end
		Selection:Set(newSelection)
	end,
})

ext:newCommand({
	id = "select-just-descendants",
	title = "Select Just Descendants",
	description = "Selects only the descendants of the current selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		local newSelection = {}
		for _, selected in Selection:Get() do
			local descendants = selected:GetDescendants()
			table.move(descendants, 1, #descendants, #newSelection + 1, newSelection)
		end
		Selection:Set(newSelection)
	end,
})

ext:newCommand({
	id = "select-just-first",
	title = "Select Just First",
	description = "Reduce to just your first selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		Selection:Set({ Selection:Get()[1] })
	end,
})

ext:newCommand({
	id = "select-just-last",
	title = "Select Just Last",
	description = "Reduce to just your last selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		local oldSelection = Selection:Get()
		Selection:Set({ oldSelection[#oldSelection] })
	end,
})

ext:newCommand({
	id = "deselect-all",
	title = "Deselect All",
	description = "Clears your selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		ctx:setSelection({})
	end,
})

ext:newCommand({
	id = "destroy-selection",
	title = "Destroy Selection",
	description = "Destroys the selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		for _, instance in ctx:getSelection() do
			pcall(game.Destroy, instance)
		end
	end,
})

ext:newCommand({
	id = "destroy-just-children",
	title = "Destroy Just Children",
	description = "Destroys just the children of the current selection.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		for _, parent in ctx:getSelection() do
			for _, children in parent:GetChildren() do
				pcall(game.Destroy, children)
			end
		end
	end,
})

ext:newCommand({
	id = "rename-selection",
	title = "Rename Selection",
	description = "Renames the current selection to the given pattern.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
	end,

	renderInViewport = function(ctx: Extension.CommandContext)
		local window = Iris.Window({ "Rename Selection" })
		if window.closed() then
			Iris.End()
			ctx:cleanup()
			return
		end

		Iris.InputText({ "Rename to..." })

		Iris.End()
	end,
})

return ext
