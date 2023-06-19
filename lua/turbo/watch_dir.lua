local options = {}
local fwatch = require("fwatch")
local handles = {}
local filename_to_process = nil
local event_processed = true

local function upload_file(path)
	if event_processed == true then
		return nil
	end
	event_processed = true
	filename_to_process = path .. filename_to_process:gsub("~", "")
	print(filename_to_process .. " changed. Uploading.")
	local CURL_CMD = [[curl -sSL --compressed -X 'POST' -H 'Authorization: Bearer ]]
		.. options.token
		.. [[' -F 'file=@]]
		.. options.local_path
		.. [[__FILEPATH__;filename=blob' -F filePath="__FILEPATH__" -F overwrite=true 'https://adturbo.rtbhouse.biz/api/project/]]
		.. options.project
		.. [[/]]
		.. options.package
		.. [[/files/add']]
	local command = CURL_CMD:gsub("__FILEPATH__", filename_to_process)
	-- add error check? this executes the curl command
	-- print(command)
	os.execute(command)
	filename_to_process = nil
end

local function watch(path)
	local handle = fwatch.watch(options.local_path .. path, {
		on_event = function(filename, events, unwatch)
			--    local log = ""
			-- for key, value in pairs(events) do
			-- 	log = log .. key .. " " .. filename .. ","
			-- 	print(log)
			-- end
			event_processed = false
			if filename ~= nil then
				filename_to_process = filename
			end
			-- neovim makes multiple operations when saving the file
			-- scheduling needed so the event only processes once
			vim.schedule(function()
				upload_file(path)
			end)
		end,
		on_error = function(error, unwatch)
			-- disable watcher
			unwatch()
			-- note, print still occurs even though we unwatched *future* events
			print("An error occured: " .. error)
		end,
	})

	table.insert(handles, handle)
end

local function watch_all(options_arg)
	options = options_arg
	-- watch main dir
	watch("/")
	-- watch subdirectories
	for name, type in vim.fs.dir(options.local_path, { depth = options.depth }) do
		if type == "directory" then
			watch("/" .. name .. "/")
		end
	end
	print("watching " .. options.local_path .. " and sudirectories up to " .. options.depth .. " layers deep.")
end

local function unwatch()
	if #handles > 0 then
		for _, v in pairs(handles) do
			fwatch.unwatch(v)
		end
		handles = {}
		print("Stopped watching for changes.")
	else
		print("Nothing to unwatch.")
	end
end

return {
	watch_all = watch_all,
	unwatch = unwatch,
}
