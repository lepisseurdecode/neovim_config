local project_files = require'overseer.template.cmake.utils.list_dir'
local utils = require'overseer.template.cmake.utils.cmake'
local cmake_api = require'overseer.template.cmake.utils.cmake_file_api'

return {
	generator = function(_, cb)
		local project_data = project_files.get()
		local current = project_data:current()
		local name, desc
		local params = {}
		local order = utils.order_generator()
		local default_new_build
		if project_data:count() > 1 then
			name = 'Manage build dir'
			desc = 'Select or create build directory'
			params.current_build_dir = {
				type = 'enum',
				choices = project_data:available_dirs(),
				name = 'Current build dir',
				desc = 'New current build directory (current is ' .. current .. ')',
				order = order:get(),
				default = current
			}
		else
			name = 'Create build dir'
			desc = 'Create new build directory'
			default_new_build = 'build'
		end
		params.new_build_dir = {
			type = 'string',
			name = 'build directory',
			desc = "Path to the new build directory, if it doesn't exist, it will be created",
			order = order:get(),
			default = default_new_build,
			optional = nil == default_new_build,
		}
		params.generator = {
			type = 'enum',
			choices = {
				'default',
				'Visual Studio 16 2019',
				'Visual Studio 17 2022',
				'Visual Studio 17 2022',
				'Visual Studio 9 2008',
				'Borland Makefiles',
				'NMake Makefiles',
				'NMake Makefiles JOM',
				'MSYS Makefiles',
				'MinGW Makefiles',
				'Unix Makefiles',
				'Ninja',
				'Ninja Multi-Config',
				'Watcom WMake',
				'CodeBlocks - MinGW Makefiles',
				'CodeBlocks - NMake Makefiles',
				'CodeBlocks - NMake Makefiles JOB',
				'CodeBlocks - Ninja',
				'CodeBlocks - Unix Makefiles',
				'CodeLite - MinGW Makefiles',
				'CodeLite - NMake Makefiles',
				'CodeLite - Ninja',
				'CodeLite - Unix Makefiles',
				'Eclipse CDT4 - MinGW Makefiles',
				'Eclipse CDT4 - NMake Makefiles',
				'Eclipse CDT4 - Ninja',
				'Eclipse CDT4 - Unix Makefiles',
				'Kate - MinGW Makefiles',
				'Kate - NMake Makefiles',
				'Kate - Ninja',
				'Kate - Unix Makefiles',
				'Sublime Text 2 - MinGW Makefiles',
				'Sublime Text 2 - NMake Makefiles',
				'Sublime Text 2 - Ninja',
				'Sublime Text 2 - Unix Makefiles'
			},
			name = 'Generator',
			desc = 'Generator used in the new build directory',
			order = order:get(),
			default = 'default'
		}
		params.export_compile_command = {
			type = 'boolean',
			name = 'Export compile command',
			desc = "Export compile_command.json for the new directory",
			order = order:get(),
			default = true,
			optional = false,
		}
		params.cmake_bin = {
			type = 'string',
			name = 'cmake binary',
			desc = "Path to the cmake binary for the new directory",
			order = order:get(),
			default = 'cmake',
			optional = false,
		}
		params.cached_vars = utils.new_cached_vars_param(order:get())

		cb({require'overseer'.wrap_template({
			name = name,
			desc = desc,
			params = params,
			builder = function (param)

				local args
				if param.new_build_dir ~= nil then
					args = {'.', '-B', param.new_build_dir}
					if 'default' ~= param.generator then
						table.insert(args, '-G' .. param.generator)
					end
					if param.export_compile_command then
						table.insert(args, '-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE')
					end
					if nil ~= param.cached_vars then
						for _, var in ipairs(param.cached_vars) do
							table.insert(args, '-D' .. var)
						end
					end
					cmake_api.write_query(param.new_build_dir, true, true, true, true)
					project_data:add(param.new_build_dir)
				elseif param.current_build_dir ~= current and param.current_build_dir ~= '' then
					project_data:set_current(param.current_build_dir)
					args = {'.', '-B', param.current_build_dir}
				else
					args = {'.', '-B', current}
				end
				project_data:write()
				return {
					cmd = {'cmake'},
					args = args,
					components = {
						{'on_output_quickfix', set_diagnostics = true},
						'default',
					}
				}
			end,
		})})
	end,
	condition = {
		callback = utils.has_cmakelists
	}
}
