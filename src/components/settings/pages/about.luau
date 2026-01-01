local Iris = require("@pkgs/Iris")
local assets = require("@src/assets")
local types = require("@src/components/settings/types")

local manifest = require(script:FindFirstAncestor("Rocket").include.manifest)

local about = {} :: types.SettingPage
about.id = "about"
about.title = "About"
about.tabIcon = assets.icons.rocket
about.extensionIcon = assets.extensions.settings.about

function about.render()
	Iris.Text({ `Rocket v{manifest.version}` })
end

return about
