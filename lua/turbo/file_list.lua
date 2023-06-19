local function get_file_list(options)
    local CURL_CMD = [[curl -sSL --compressed -X 'GET' -H 'RejectUnauthorized: false' -H 'Content-Type: application/json' -H 'Authorization: Bearer ]] .. options.token .. [[' 'https://adturbo.rtbhouse.biz/api/project/]] .. options.project .. [[/]] .. options.package .. [[/files/list' -o ']] .. options.local_path .. [[/.file_list']]
    os.execute(CURL_CMD)
end

return {
    get_file_list = get_file_list
}