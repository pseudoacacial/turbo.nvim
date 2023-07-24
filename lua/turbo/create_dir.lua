local fs = require("turbo.fs")
local json = require("turbo.dkjson")
local file_list = require("turbo.file_list")
local a = require("plenary.async")
local options = {}

local function populate()
	local CURL_CMD = [[curl -sSL --compressed -X 'POST' -H 'Content-Type: application/json' -H 'RejectUnauthorized: false' -H 'Authorization: Bearer ]]
		.. options.token
		.. [[' --data-raw '{"filePath": "__FILEPATH__"}' 'https://adturbo.rtbhouse.biz/api/project/]]
		.. options.project
		.. [[/]]
		.. options.package
		.. [[/files/fetch' -o ']]
		.. options.local_path
		.. [[__FILEPATH__']]
	local JSON_PATH = options.local_path .. "/.file_list"

	fs.create_dir(options.local_path)
	vim.cmd("tcd " .. options.local_path)

	-- require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })

	file_list.get_file_list(options)
	local file = io.open(JSON_PATH, "r")
	local content = file:read("*a")
	file:close()
	local files_and_dirs_table = json.decode(content)
	for index, value in ipairs(files_and_dirs_table.directories) do
		fs.create_dir(options.local_path .. "/" .. value)
	end
	for index, value in ipairs(files_and_dirs_table.files) do
		local command = CURL_CMD:gsub("__FILEPATH__", "/" .. value)
		a.run(function()
			os.execute(command)
		end, function()
			print("downloaded " .. value)
		end)
	end
end

local function init(options_arg)
	options = options_arg
	print("Downloading project " .. options.project .. " to " .. options.local_path)
	a.run(populate, function()
		print("Finished downloading project " .. options.project .. " to " .. options.local_path)
	end)
end

return {
	init = init,
}
