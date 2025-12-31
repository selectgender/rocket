local Charm = require("@pkgs/Charm")
local fzy = require("@src/vendor/fzy")
local Extension = require("@src/lib/Extension")

local palette = {}
palette.isVisible = Charm.atom(true)
palette.isFocused = Charm.atom(true)
palette.search = Charm.atom("")

--[[
const searchNow = search();
		let extenstionHaystack = table.clone(extensionNames);
		if (searchNow !== "") {
			const results = fzy.filter(searchNow, extensionNames, false);
			table.sort(results, (lhs, rhs) => lhs[2] < rhs[2]);
			extenstionHaystack = table.create(results.size());
			for (const [idx] of results) extenstionHaystack.push(extensionNames[idx - 1]);
		}
		return extenstionHaystack;
]]

palette.searchResults = Charm.computed(function()
	local search = palette.search()
	local allCommands = Extension.allCommands()
	local haystack = table.clone(allCommands)
	if search ~= "" then
		local results = fzy.filter(search, Extension.commandTitles(), false)
		table.sort(results, function(lhs: { number }, rhs: { number })
			return lhs[3] < rhs[3]
		end)
		haystack = table.create(#results)
		for _, result in results do
			table.insert(haystack, allCommands[result[1]])
		end
	end
	return haystack
end)

return table.freeze(palette)
