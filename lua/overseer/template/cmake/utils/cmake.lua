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
					required'overseer.log':error('Must be in format <name>[:type]=<value> with ; delimiter')
					return false
				end
			end
			return true
		end
	}
end

function M.get_config(project_data, targets)
	if nil ~= project_data:config() then
		return project_data:config()
	end
	local current_target = project_data:target()
	local res = nil
	for _, target in pairs(targets) do
		local skip = true
		for _, t in pairs(target) do
			if 'EXECUTABLE' == t.type or t.name == current_target then
				skip = false
			end
		end

		if skip then
			goto continue
		end

		if 'Debug' == target.config  then
			return 'Debug'
		end
		if 'Release' == target.config then
			res = 'Release'
		end
	    ::continue::
	end
	if nil == res then
		return targets[1].config
	end
	return res
end

function M.filter_targets(targets)
	local res = {}
	for _, target in pairs(targets) do
		local config = {
			targets = {},
			config = target.config
		}
		for _, t in pairs(target.targets) do
			if 'ALL_BUILD' ~= t.name and 'ZERO_CHECK' ~= t.name and 'INTERFACE_LIBRARY' ~= t.type then
				table.insert(config.targets, t)
			end
		end
		if #config.targets then
			table.insert(res, config)
		end
	end
	return res
end
function M.get_target(project_data, targets)
	if nil ~= project_data.target then
		return project_data:target()
	end
	local current_config = project_data:config()
	local res
	for _, target in pairs(targets) do
		if current_config == target.config then
			for _, t in pairs(target.targets) do
				if 'EXECUTABLE' == t.type then
					return t.name
				end
			end
			return target.targets[1].name
		end

		if 'Debug' == target.config then
			local tmp
			for _, t in pairs(target.targets) do
				if 'EXECUTABLE' == t.type then
					tmp = t.name
				end
			end
			if nil == tmp then
				tmp = target[1].name
			end
			return tmp
		elseif 'Release' == target.config then
			local tmp
			for _, t in pairs(target.targets) do
				if 'EXECUTABLE' == t.type then
					tmp = t.name
				end
			end
			if nil == tmp then
				tmp = target[1].name
			end
			res = tmp
		end
	end
	if nil == res then
		return targets[1].targets[1].name
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
