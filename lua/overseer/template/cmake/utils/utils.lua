local M = {}

function M.has_cmakelists(cwd) return M.file_exist(cwd .. '/CMakeLists.txt') end

function M.new_cached_vars_param(order)
	return {
		type = 'list',
		subtype = {
			type = 'string',
		},
		delimiter = ';',
		order = order,
		name = 'New cached variables',
		desc = 'List of cached variable with ; delimiter. <name>[:type]=<value>',
		optional = true,
		validate = function(vars)
			for _, var in ipairs(vars) do
				local res = vim.split(var, '=')
				if table.maxn(res) < 2 then
					-- required'overseer.log':error('Must be in format <name>[:type]=<value> with ; delimiter')
					return false
				end
			end
			return true
		end,
	}
end

function M.get_config(project_data, cmake_data)
	if not cmake_data:multi_config_generator() then
		local cached_variables = cmake_data:cached_variables()
		if nil ~= cached_variables.CMAKE_BUILD_TYPE then
			return cached_variables.CMAKE_BUILD_TYPE.value
		end
	end

	if nil ~= project_data:config() then
		return project_data:config()
	end

	local available = cmake_data:availables_configurations()
	local current_target = project_data:target()
	if nil == current_target and nil ~= available then
		return available[1]
	end

	local executables = cmake_data:executables()

	if not #executables then
		return 'Debug'
	end

	for _, data in pairs(executables) do
		for config, _ in pairs(data.config) do
			return config
		end
	end
end

function M.filter_targets(targets)
	local res = {}
	for target, data in pairs(targets) do
		if 'ALL_BUILD' ~= target and 'ZERO_CHECK' ~= target and 'INTERFACE_LIBRARY' ~= data.type then
			res[target] = data
		end
	end
	return res
end

function M.order_generator()
	return {
		prvt = { count = 0 },
		get = function(self)
			local count = self.prvt.count
			self.prvt.count = self.prvt.count + 1
			return count
		end,
	}
end

function M.read_file(path)
	local stat = vim.loop.fs_stat(path)
	if nil == stat or fail == stat then
		return nil
	end
	local fd = vim.loop.fs_open(path, 'r', 438)
	local res = vim.loop.fs_read(fd, stat.size)
	vim.loop.fs_close(fd)
	return res
end

function M.write_file(path, content)
	local fd = vim.loop.fs_open(path, 'w', 438)
	local res = vim.loop.fs_write(fd, content)
	vim.loop.fs_close(fd)
	return fail ~= res
end

function M.file_exist(path) return nil ~= vim.loop.fs_stat(path) end

function force_symlink(target_path, link_path) vim.loop.fs_symlink(target_path, link_path) end

function M.get_bin(project_datas, cmake_file)
	local configuration = M.get_config(project_datas, cmake_file)
	local target = project_datas:target()
	for t, data in pairs(cmake_file:executables()) do
		if nil == target or target == t then
			for config, config_data in pairs(data.config) do
				if config == configuration and M.file_exist(config_data.bin) then
					return config_data.bin
				end
			end
		end
	end
	return nil
end

function M.symlink_compile_commands_json(project_data)
	local origin = project_data:current() .. '/compile_commands.json'
	if not M.file_exist(origin) then
		return
	end
	local link = './compile_commands.json'
	if M.file_exist(link) then
		os.remove(link)
	end
	vim.loop.fs_symlink(origin, link)
end

return M
