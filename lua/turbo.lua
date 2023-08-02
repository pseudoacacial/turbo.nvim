local create_dir = require("turbo.create_dir")
local watch = require("turbo.watch")

local turbo = {}

local function with_defaults(options)
	return {
		depth = options.depth or 3,
		token = options.token,
		project = options.project,
		package = options.package,
		local_path = options.local_path,
	}
end

-- This function is supposed to be called explicitly by users to configure this
-- plugin
function turbo.setup(options)
	turbo.options = with_defaults(options)
	local projectName = turbo.options.project:gsub(" %(%d*%)", "")
	turbo.options.local_path = turbo.options.local_path .. projectName .. "/" .. turbo.options.package
	-- escape space char for URL
	turbo.options.project = turbo.options.project:gsub(" ", "%%20")
	-- escape hash char in pack package name
	turbo.options.package = turbo.options.package:gsub("#", "%%23")
end

function turbo.is_configured()
	return turbo.options ~= nil
end

-- public API

function turbo.download_project()
	if not turbo.is_configured() then
		print("You need to configure this plugin first. Check README for instructions.")
		return
	end
	create_dir.init(turbo.options)
end

function turbo.watch_project()
	if not turbo.is_configured() then
		print("You need to configure this plugin first. Check README for instructions.")
		return
	end
	watch.watch_all(turbo.options)
end

function turbo.unwatch_project()
	watch.unwatch()
end

function turbo.show_options()
	for key, value in turbo.options do
		print(key .. ": " .. value)
	end
	print(turbo.options)
end

turbo.options = nil
return turbo
