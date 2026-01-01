local Extension = require("@src/lib/Extension")
local assets = require("@src/assets")
local pages = require("@src/components/settings/pages")
local settings = require("@src/atoms/settings")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-settings",
	title = "Rocket Settings",
	description = "Manage your Rocket Settings",
	icon = { Image = assets.extensions.settings.base },
	authors = { "Team Fireworks" },
})

for _, page in pages do
	ext:newCommand({
		id = `page-{page.title}`,
		title = page.title,
		description = `Open the {page.title} panel in Rocket Settings`,
		icon = { Image = page.extensionIcon },
		run = function()
			settings.currentPage(page)
			settings.isVisible(true)
		end,
	})
end

return ext
