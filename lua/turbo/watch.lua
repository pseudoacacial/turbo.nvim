local options = {}
local fwatch = require("fwatch")
local handles = {}
local iterator = 0

local function upload_file(path)
	iterator = iterator + 1
	print(iterator .. " - uploading " .. path)
	local CURL_CMD = [[curl -sSL --compressed -X 'POST' -H 'Authorization: Bearer ]]
		.. options.token
		.. [[' -F 'file=@]]
		.. options.local_path
		.. [[__FILEPATH__;filename=blob' -F filePath='__FILEPATH__' -F overwrite=true 'https://adturbo.rtbhouse.biz/api/project/]]
		.. options.project
		.. [[/]]
		.. options.package
		.. [[/files/add']]

	local command = CURL_CMD:gsub("__FILEPATH__", path)
	-- add error check? this executes the curl command
	print("uploading " .. path)
	os.execute(command)
	-- print(path)
end
local function watch(path, directoryArg)
	local directory = directoryArg or false
	local handle = fwatch.watch(options.local_path .. path, {
		-- on_event = function(filename, events, unwatch)
		--    local log = ""
		-- for key, value in pairs(events) do
		-- 	log = log .. key .. " " .. filename .. ","
		-- 	print(log)
		-- end
		on_event = function(filename, events, unwatch)
			-- 'directory' watchers are used for uploading new files
			if directory then
				-- stop if name starts with number
				if string.find(filename, "%d") == 1 then
					return
				end
				-- ignore tildes (~) in file names
				local new_file_name = filename:gsub("~", "")
				-- if file doesnt exist, add watcher to new file and upload it
				if handles[path .. new_file_name] then
					return
				end
				watch(path .. new_file_name)
				vim.defer_fn(function()
					print("DIRECTORY! " .. path .. filename)
					upload_file(path .. filename)
				end, 1000)
			else
				unwatch()
				upload_file(path)
				vim.defer_fn(function()
					watch(path, false)
				end, 1000)
			end
		end,
		on_error = function(error, unwatch)
			-- disable watcher
			unwatch()
			-- note, print still occurs even though we unwatched *future* events
			print("An error occured: " .. error)
		end,
	})
	handles[path] = handle
end

local function watch_all(options_arg)
	options = options_arg
	print(options.local_path)
	vim.cmd("cd " .. options.local_path:gsub("#", "\\#"))
	-- watch main dir
	watch("/", true)
	-- watch subdirectories
	for name, type in vim.fs.dir(options.local_path, { depth = options.depth }) do
		if type == "file" then
			watch("/" .. name, false)
		end
		if type == "directory" then
			watch("/" .. name .. "/", true)
		end
	end
	print("watching " .. options.local_path .. " and sudirectories up to " .. options.depth .. " layers deep.")
end

local function unwatch()
	print("unwatching all")
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
