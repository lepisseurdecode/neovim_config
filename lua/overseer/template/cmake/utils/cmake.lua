local M = {}

function M.has_cmakelists(search)
	local dir = vim.loop.fs_scandir(vim.loop.fs_realpath(search.dir))
	local file = vim.loop.fs_scandir_next(dir)
	while nil ~= file or fail ~= file do
		if file == 'CMakeLists.txt' then
			return true
		end
		file = vim.loop.fs_scandir_next(dir)
	end
	return false
end

function M.new_cached_vars_param(order)
	return {
		type = 'list',
		subtype = {
			type = 'string'
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
		end
	}
end

function M.get_config(project_data, cmake_data)

	if nil ~= project_data:config() then
		return project_data:config()
	end

	if not cmake_data:multi_config_generator() then
		for _, cache in pairs(cmake_data:cached_variables()) do
			if 'CMAKE_BUILD_TYPE' == cache.name then
				return cache.value
			end
		end
	end

	local available = cmake_data:availables_configurations()
	local current_target = project_data:target()
	if nil == current_target then
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
	return res
end

function M.order_generator()
	return {
		prvt = {count = 0},
		get = function(self)
			local count = self.prvt.count
			self.prvt.count = self.prvt.count + 1
			return count
		end
	}
end

return M
