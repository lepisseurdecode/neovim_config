local project_files = require'overseer.template.cmake.utils.list_dir'
local cmake_file_api = require'overseer.template.cmake.utils.cmake_file_api'
local utils = require'overseer.template.cmake.utils.cmake'

local function translate_type(type)
	if 'FILEPATH' == type or 'STRING' == type or 'PATH' == type then
		return 'string'
	elseif 'BOOL' == type then
		return 'boolean'
	else
		return 'string'
	end
end

local function create_build_params(project_datas, cmake_data, params, get_order)
	params['build_settings----------'] = {
		desc = 'Build parameters category',
		type = 'string',
		optional = true,
		order = get_order()
	}

	local config = utils.get_config(project_datas)

	if cmake_data:multi_config_generator() then
		params['build_config'] = {
			name = 'Build Config',
			desc = 'Available: ' .. table.join(cmake_data:availables_configuration(), ', ')
			type = 'enum',
			choices = cmake_data:availables_configuration(),
			order = get_order(),
			optional = false
			default = config
		}
	else
		params['build_config'] = {
			name = 'Build Config',
			desc = 'Typicaly is Debug, Release, RelWithDebInfo or MinSizeRel' 
			type = 'string',
			order = get_order(),
			optional = false
			default = config
		}
	end

	local filtred_target = utils.filter_targets(cmake_data:targets())
	local current_target = project_datas:target() or 'All'

	local available = {'All'}
	for target, data in pairs(filtred_target) do
		for target_config, _ in pair(data.config) do
			if target_config == config then
				available[#available + 1] = target
			end
		end
	end

	res['target'] = {
		name = 'target',
		type = 'enum',
		choices = available,
		order = order,
		desc = 'available for '.. config ..': ' .. table.concat(available, ', '),
		default = current_target,
	}
end

local function set_build_params(project_datas, cmake_data, params)
	local res = {}
	if params.build_config ~= project_datas:config() then
		project_datas:set_config(params.build_config)
		if cmake_data:multi_config_generator then
			res = {'-DCMAKE_BUILD_TYPE=' .. params.build_config}
		end
	end

	if 'All' == params.target then
		if nil ~= project_datas:target() then
			project_datas:set_target(nil)
		end
	elseif project_datas:target() ~= params.target then
		project_datas:set_target(params.target)
	end

	return res
end

local function create_run_params(project_datas, cmake_data, params)
local function format_var_cache(project_datas, cmake_data)
	local res = {}
	local order = 0

	local function get_order()
		order = order + 1
		return order
	end

	create_build_params(project_datas, cmake_data, res, get_order)

	res['run_settings------------'] = {
		desc = 'Config parameters category',
		type = 'string',
		order = get_order(),
		optional = true,
	}
	res['launch_params'] = {
		desc = 'list of launch parameters with ; separator',
		type = 'list',
		subtype = {
			type = 'string',
		},
		order = get_order(),
		optional = true,
	}
	res['working_directory'] = {
		desc = 'Path to the working directory',
		type = 'string',
		order = get_order(),
		optional = true,
	}
	res['env_var'] = {
		desc = 'List of <environment variables>[+]=<value+..> with ; separator',
		type = 'list',
		subtype = {
			type = 'string',
		},
		delimiter = ';',
		order = get_order(),
		optional = true,
		validate = function(params)
			for _, param in pairs(params) do
				if 2 ~= table.maxn(vim.split(param, '=')) then
					return false
				end
			end
			return true
		end
	}
	local env_var = project_datas:variables_environment()
	if nil ~= env_var then
		res.env_var.default = {}
		for key, values in pairs(env_var) do
			local operator = '='
			local param = {}
			for _, var in pairs(values) do
				if key == var then
					operator = '+='
				else
					table.insert(param, var)
				end
			end
			table.insert(res.env_var.default, key .. operator .. table.concat(param, '+'))
		end
	end
	res['install_settings--------'] = {
		desc = 'Install parameters category',
		type = 'string',
		order = get_order(),
		optional = true,
	}
	res['prefix'] = {
		desc = 'path to the install prefix dir',
		type = 'string',
		order = get_order(),
		optional = true,
	}
	res['config_settings---------'] = {
		desc = 'Config parameters category',
		type = 'string',
		order = get_order(),
		optional = true,
	}
	for _, cached_var in ipairs(cmake_data:cached_variables()) do
		local param = {}
		if 'CMAKE_CONFIGURATION_TYPES' == cached_var.name  or 'CMAKE_BUILD_TYPE' == cached_var.name then
			goto continue
		end

		param.name = cached_var.name
		param.type = translate_type(cached_var.type)
		param.desc = cached_var.help_string
		param.default = cached_var.value
		param.order = get_order()
		res[param.name] = param
		::continue::
	end
end

local function translate_value(value)
	local res = value
	if type(value) == "boolean" then
		return res and "TRUE" or "FALSE"
	end
	return res
end


return {
	generator = function(_, cb)
		local project_datas = project_files.get()
		local current_dir = project_datas:current()
		local cmake_data = cmake_file_api.get(current_dir)
		cb({require'overseer'.wrap_template({
			name = 'Settings',
			desc = 'Settings of the build directory ' .. current_dir,
			params = format_var_cache(project_datas, cmake_data),
			builder = function (params)
				local args = {'.', '-B', current_dir}
				for key, value in pairs(params) do
					for _, cached_var in ipairs(cmake_data:cached_variables()) do
						if key == cached_var.name and value ~= cached_var.value then
							table.insert(args, '-D'..key..'='.. translate_value(value))
						end
					end
				end

				if nil ~= params.new_cached_vars then
					for _, var in ipairs(params.new_cached_vars) do
						table.insert(args, '-D' .. var)
					end
				end

				local need_write = false
				if nil ~= params.build_config and params.build_config ~= project_datas:config() then
					project_datas:set_config(params.build_config)
					need_write = true
				end

				if nil ~= params.target and params.target ~= project_datas:target() then
					project_datas:set_target(params.target)
					need_write = true
				end
				if nil ~= params.launch_params then
					project_datas:set_launch_params(params.launch_params)
					need_write = true
				end

				if nil ~= params.env_var then
					local res = {}
					for _, var in pairs(params.env_var) do
						local v = vim.split(var, '=')
						local values = {}
						if vim.endswith(v[1], '+') then
							v[1] = v[1]:sub(1, -2)
							table.insert(values, v[1])
						end
						for _, val in pairs(vim.split(v[2], '+')) do
							table.insert(values, val)
						end

						res[v[1]] = values
					end
					if vim.json.encode(res) ~= vim.json.encode(project_datas.variables_environment()) then
						project_datas:set_variables_environment(res)
						need_write = true
					end
				end

				if need_write then
					project_datas:write()
				end

				return {
					cmd = {'cmake'},
					args = args,
					components = {
						{'on_output_quickfix', set_diagnostics = true},
						'default',
					}
				}
			end
		})})
	end,
	condition = {
		callback = function(search)
			local project_data = project_files.get()
			local current = project_data:current()
			return (not project_data:empty()) and nil ~= current and utils.has_cmakelists(search) and cmake_file_api.exists(current)
		end
	}
}
