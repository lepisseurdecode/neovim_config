local json = require'overseer.template.cmake.utils.json'
local M = {}
local api_dir = '%s/.cmake/api/v1/%s'
local reply_dir = '%s/.cmake/api/v1/reply/'
local client_name = 'overseer.cmake'
M.build_dir = 'build'

local function file_to_table(path)
	local file = io.open(path, 'r')
	if nil == file then
		return nil
	end
	local content = file:read('a*')
	file:close()
	return vim.json.decode(content)
end

local function find_index(path)
	local dir = vim.loop.fs_scandir(path)
	if nil == dir then
		return nil
	end
	local file = vim.loop.fs_scandir_next(dir)
	while nil ~= file or fail ~= file do
		if string.find(file, 'index') ~= nil then
			return file
		end
		file = vim.loop.fs_scandir_next(dir)
	end
	return nil
end

local function read_index(build_dir)
	local path = string.format(reply_dir, build_dir)
	local index = find_index('./'..path)
	if nil == index then
		return {}
	end

	local datas = file_to_table(path .. index)
	local responses = datas.reply['client-' .. client_name]['query.json'].responses
	local res = {}
	for _, value in pairs(responses) do
		local kind = value.kind
		local function add_to_res(kind_name)
			if kind_name == kind then
				res[kind_name] = path .. value.jsonFile
			end
		end
		add_to_res('cache')
		add_to_res('codemodel')
		add_to_res('toolchains')
		add_to_res('cmakeFiles')
	end
	return res
end




local function get_cache_variables(cache_file)
	 local datas = file_to_table(cache_file)
		if nil == datas then
			return {}
		end
	 local res = {}
	 for _, value in pairs(datas.entries) do
	 	if "INTERNAL" ~= value.type and "STATIC" ~= value.type then
	 		local entry = {}
	 		local skip = false
	 		entry.name = value.name
	 		entry.type = value.type
	 		if 'BOOL' == entry.type then
	 			entry.value = "TRUE" == value.value or "ON" == value.value
	 		else
	 			entry.value = value.value
	 		end
	 		if nil ~= value.properties then
	 			for _, prop in pairs(value.properties) do
	 				if "HELPSTRING" == prop.name then
	 					entry.help_string = prop.value
	 				elseif 'ADVANCED' == prop.name then
	 					skip = true
	 				end
	 			end
	 		end
	 		if not skip then
	 			table.insert(res, entry)
	 		end
	 	end
	 end
	 return res
end


local function get_targets(build_dir ,codemodel)

	local datas = file_to_table(codemodel)
	if nil == datas then
		return {}
	end
	local res = {}
	for _, value in pairs(datas.configurations) do
		local data = {}
		if nil ~= value.name and "" ~= value.name  then
			data.config = value.name
		end
		data.targets = {}
		for _, target in pairs(value.targets) do
			local target_files = file_to_table(string.format(reply_dir, build_dir) .. target.jsonFile)
			local target_data = {}
			if nil == target_files then
				goto continue
			end

			target_data = {
				name = target.name,
				type = target_files.type,
			}

			local nameOnDisk = target_files.nameOnDisk
			for _, artifact in pairs(target_files.artifacts or {}) do
				if vim.endswith(artifact.path, nameOnDisk) then
					target_data.bin = build_dir .. '/' .. artifact.path
					break
				end
			end

			table.insert(data.targets, target_data)
		    ::continue::
		end
		table.insert(res, data)
	end
	return res
end

function M.get(build_dir)
	local res = {}
	res.prvt = {}
	res.prvt.build_dir = build_dir
	res.prvt.index = read_index(build_dir)
	res.cached_variables = function(self)
		if nil ~= self.prvt.cached_variables then
			return self.prvt.cached_variables
		end
		if nil == self.prvt.index.cache then
			return {}
		end
		self.prvt.cached_variables = get_cache_variables(self.prvt.index.cache)
		return self.prvt.cached_variables
	end
	res.targets = function(self)
		if nil ~= self.prvt.targets then
			return self.prvt.targets
		end
		if nil == self.prvt.index.codemodel then
			return {}
		end
		self.prvt.targets = get_targets(self.prvt.build_dir, self.prvt.index.codemodel)
		return self.prvt.targets
	end
	return res
end

function M.write_query(build_dir, cache, codemodel, toolchains, cmake_files)
	local datas = {}
	local function insert(name, version)
		table.insert(datas, table.maxn(datas) + 1, {kind = name, version = version})
	end
	if cache then
		insert("cache", 2)
	end
	if codemodel then
		insert("codemodel", 2)
	end
	if toolchains then
		insert("toolchains", 1)
	end
	if cmake_files then
		insert("cmakeFiles", 1)
	end
	local res = json.encode({requests = datas})

	local path = string.format(api_dir, build_dir, string.format('query/client-%s/', client_name))

	local tmp = ''
	for str in string.gmatch(path, '([^/]+)') do
		tmp = tmp .. str .. '/'
		if vim.loop.fs_stat(tmp) == nil then
			vim.loop.fs_mkdir(tmp, 777)
		end
	end
	local file = io.open( path .. 'query.json', 'w')
	file:write(res)
	file:close()
end
return M
