local utils = require'overseer.template.cmake.utils.cmake'
local project_file = require'overseer.template.cmake.utils.list_dir'
local cmake_api = require'overseer.template.cmake.utils.cmake_file_api'

return {
	params = ,
	builder = function(params)
		local args = {'.', '-B', params.build_dir}
		if 'default' ~= params.generator then
			table.insert(args, '-G' .. params.generator)
		end
		if params.export_compile_command then
			table.insert(args, '-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE')
		end
		if nil ~= params.cached_vars then
			for _, var in ipairs(params.cached_vars) do
				table.insert(args, '-D' .. var)
			end
		end
		cmake_api.write_query(params.build_dir, true, true, true, true)
		local file = project_file.get()
		file:add(params.build_dir)
		file:write()

		return {
			cmd = params.cmake_bin,
			args = args,
			components = {
				{'on_output_quickfix', set_diagnostics = true},
				'default',
			}
		}
	end,
	condition = {
		callback = utils.has_cmakelists
	}
}
