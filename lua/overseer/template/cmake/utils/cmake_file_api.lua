local M = {}
local api_dir = '%s/.cmake/api/v1/%s'
local reply_dir = '%s/.cmake/api/v1/reply/'
local client_name = 'overseer.cmake'

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
	if nil == datas then
		return {}
	end
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
	res.generator = datas.cmake.generator
	return res
end




local function get_cache_variables(cache_file)
	 local datas = file_to_table(cache_file)
		if nil == datas then
			return {}
		end
	 local res = {}
	 for _, value in pairs(datas.entries) do
	 	if "INTERNAL" == value.type and "STATIC" == value.type then
			goto continue
		end

		local entry = {type = value.type}

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
					goto continue
				end
			end
		end
		res[value.name] = entry
		::continue::
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
		local config
		if nil ~= value.name and "" ~= value.name  then
			config = value.name
		else
			goto next_config
		end

		for _, target in pairs(value.targets) do
			local target_files = file_to_table(string.format(reply_dir, build_dir) .. target.jsonFile)
			if nil == target_files then
				goto next_target
			end

			if nil == res[target.name] then
				res[target.name] = {
					type = target_files.type,
					name = target.name,
					config = {}
				}
			end

			local nameOnDisk = target_files.nameOnDisk
			for _, artifact in pairs(target_files.artifacts or {}) do
				if vim.endswith(artifact.path, nameOnDisk) then
					res[target.name].config[config] = {bin = build_dir .. '/' .. artifact.path}
					break
				end
			end

			::next_target::
		end
		::next_config::
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
	res.multi_config_generator = function(self)
		return self.prvt.index.generator.multiConfig
	end

	res.availables_configurations = function(self)
		if not self.prvt.index.generator.multiConfig then
			return nil
		end

		if self.prvt.availables_configurations then
			return self.prvt.availables_configurations 
		end

		self.prvt.availables_configurations = {'Debug', 'Release', 'RelWithDebInfo', 'MinSizeRel'}

		local cached_var = self:cached_variables()
		if nil ~= cached_var.CMAKE_CONFIGURATION_TYPES then
			self.prvt.availables_configurations = vim.split(cached_var.CMAKE_CONFIGURATION_TYPES.value, ';')
		end

		return self.prvt.availables_configurations
	end

	res.executables = function(self)
		if nil ~= self.prvt.executables then
			return self.prvt.executables
		end
		self.prvt.executables = {}
		for target, data in pairs(self:targets()) do
			if 'EXECUTABLE' == data.type then
				self.prvt.executables[target] = data
			end
		end
		return self.prvt.executables
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
	local res = vim.json.encode({requests = datas})

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

function M.exists(build_dir)
	return nil ~= find_index('./' .. string.format(reply_dir, build_dir))
end

return M
