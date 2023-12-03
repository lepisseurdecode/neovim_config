local project_files = require'overseer.template.cmake.utils.project_file'
local cmake_file_api = require'overseer.template.cmake.utils.cmake_file_api'
local utils = require'overseer.template.cmake.utils.utils'

return {
	generator = function(_, cb)
		cb({require'overseer'.wrap_template({
			name = 'install',
			builder = function()
				local project_datas = project_files.get()
				local cmake_data = cmake_file_api.get(project_datas:current())
				local args = {'--install', project_datas:current()}
				if cmake_data:multi_config_generator() then
					args[#args + 1] = '--config'
					args[#args + 1] = utils.get_config(project_datas, cmake_data)
				end
				if nil ~= project_datas:install_prefix() then
					args[#args + 1] = '--prefix'
					args[#args + 1] = project_datas:install_prefix()
				end
				return {
					cmd = 'cmake',
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
			local project_datas = project_files.get()
			return utils.has_cmakelists(search) and not project_datas:empty() and nil ~= project_datas:current()
		end
	}
}
