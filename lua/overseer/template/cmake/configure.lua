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

local function create_build_params(project_datas, cmake_data, params, order)
	params['build_settings----------'] = {
		desc = 'Build parameters category',
		type = 'string',
		optional = true,
		order = order:get()
	}

	local config = utils.get_config(project_datas, cmake_data)

	if cmake_data:multi_config_generator() then
		params['build_config'] = {
			name = 'Build Config',
			desc = 'Available: ' .. table.concat(cmake_data:availables_configuration(), ', '),
			type = 'enum',
			choices = cmake_data:availables_configuration(),
			order = order:get(),
			optional = false,
			default = config
		}
	else
		params['build_config'] = {
			name = 'Build Config',
			desc = 'Typicaly is Debug, Release, RelWithDebInfo or MinSizeRel' ,
			type = 'string',
			order = order:get(),
			optional = false,
			default = config
		}
	end

	local filtred_target = utils.filter_targets(cmake_data:targets())
	local current_target = project_datas:target() or 'All'

	local available = {'All'}
	for target, data in pairs(filtred_target) do
		for target_config, _ in pairs(data.config) do
			if target_config == config then
				available[#available + 1] = target
			end
		end
	end

	params['target'] = {
		name = 'target',
		type = 'enum',
		choices = available,
		order = order:get(),
		desc = 'available for '.. config ..': ' .. table.concat(available, ', '),
		default = current_target,
	}
end

local function set_build(project_datas, cmake_data, params)
	local res = {}
	project_datas:set_config(params.build_config)

	if params.build_config ~= project_datas:config() and cmake_data:multi_config_generator() then
		res = {'-DCMAKE_BUILD_TYPE=' .. params.build_config}
	end

	if 'All' == params.target then
		project_datas:set_target(nil)
	else
		project_datas:set_target(params.target)
	end

	return res
end

local function create_run_params(project_datas, params, order)
	params['run_settings------------'] = {
		desc = 'Config parameters category',
		type = 'string',
		order = order:get(),
		optional = true,
	}
	params['launch_params'] = {
		desc = 'list of launch parameters with ; separator',
		type = 'list',
		subtype = {
			type = 'string',
		},
		delimiter = ';',
		order = order:get(),
		optional = true,
		default = project_datas:launch_params()
	}
	params['working_directory'] = {
		desc = 'Path to the working directory',
		type = 'string',
		order = order:get(),
		optional = true,
		default = project_datas:working_directory()
	}
	params['env_var'] = {
		desc = 'List of <environment variables>[+]=<value+..> with ; separator',
		type = 'list',
		subtype = {
			type = 'string',
		},
		delimiter = ';',
		order = order:get(),
		optional = true,
		default = project_datas:env_var(),
		validate = function(param)
			for _, p in pairs(param) do
				if 2 ~= #vim.split(p, '=') then
					return false
				end
			end
			return true
		end,
	}
	local env_var = project_datas:variables_environment()
	if nil ~= env_var then
		params.env_var.default = {}
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
			table.insert(params.env_var.default, key .. operator .. table.concat(param, '+'))
		end
	end
end

local function set_run(project_datas, params)
	project_datas:set_launch_params(params.launch_params)
	project_datas:set_working_directory(params.working_directory)
	project_datas:set_variables_environment(params.env_var)
end

local function create_install_params(project_data, params, order)
	params['install_settings--------'] = {
		desc = 'Install parameters category',
		type = 'string',
		order = order:get(),
		optional = true,
	}
	params['prefix'] = {
		desc = 'path to the install prefix dir',
		type = 'string',
		order = order:get(),
		optional = true,
		default = project_data:install_prefix()
	}
end

local function set_install(project_datas, params)
	project_datas:set_install_prefix(params.prefix)
end

local function create_cached_variables_params(cmake_data, params, order)
	
	params['config_settings---------'] = {
		desc = 'Config parameters category',
		type = 'string',
		order = order:get(),
		optional = true,
	}

	for name, cached_var in pairs(cmake_data:cached_variables()) do
		local param = {}
		if 'CMAKE_CONFIGURATION_TYPES' == name  or 'CMAKE_BUILD_TYPE' == name then
			goto continue
		end

		param.name = name
		param.type = translate_type(cached_var.type)
		param.desc = cached_var.help_string
		param.default = cached_var.value
		param.order = order:get()
		params[name] = param
		::continue::
	end
end

local function set_cached_variables(cmake_data, params)
	local res = {}
	for name, data in pairs(cmake_data:cached_variables()) do
		local value = params[name]
		if type(value) == 'boolean' then
			value = value and 'TRUE' or 'FALSE'
		elseif type(value) == 'table' then
			value = table.concat(value, ';')
		end

		if value ~= data.value then
			local type = ''
			if nil ~= data.type then
				type = ':' .. data.type
			end
			res[#res + 1] = '-D' .. name .. type ..'=' .. value
		end
	end
	return res
end


local function format_var_cache(project_datas, cmake_data)
	local res = {}

	local order = utils.order_generator()

	create_build_params(project_datas, cmake_data, res, order)
	create_run_params(project_datas, res, order)
	create_install_params(project_datas, res, order)
	create_cached_variables_params(cmake_data, res, order)

	return res
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
				set_run(project_datas, params)
				set_install(project_datas, params)
				for _, value in pairs(set_build(project_datas, cmake_data, params)) do
					table.insert(args, value)
				end
				for _, value in pairs(set_cached_variables(cmake_data, params)) do
					table.insert(args, value)
				end
				project_datas:write()

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
