local project_files = require'overseer.template.cmake.utils.project_file'
local cmake_file_api = require'overseer.template.cmake.utils.cmake_file_api'
local utils = require'overseer.template.cmake.utils.utils'

return {
	generator = function(_, cb)
		local project_datas = project_files.get()
		local cmake_data = cmake_file_api.get(project_datas:current())
		cb({require'overseer'.wrap_template({
			name = 'run',
			builder = function()
				local build_dir = project_datas:current()
				local res = {
					components = {
						{'on_output_quickfix', set_diagnostics = true},
						'default',
					}
				}
				local cmd = utils.get_bin(project_datas, cmake_data)
				if 'Windows_NT' == vim.loop.os_uname().sysname then
					res.cmd,_ = string.gsub(cmd, '/', [[\]])
					local env = {}
					for key, values in pairs(project_datas:variables_environment() or {}) do
						local val = {}
						for _, v in pairs(values) do
							if key == v then
								table.insert(val, '%' .. v .. '%')
							else
								table.insert(val, v)
							end
						end
						env[key] = table.concat(val,';')
					end
					res.env = env
				end

				res.args = {}
				for _, param in pairs(project_datas:launch_params() or {}) do
					table.insert(res.args, param)
				end
				res.wd = project_datas:working_directory()
				return res
			end
		})})
	end,
	condition = {
		callback = function(search)
			local project_datas = project_files.get()
			if not utils.has_cmakelists(search) or project_datas:empty() or nil == project_datas:current() then
				return false
			end
			local cmake_data = cmake_file_api.get(project_datas:current())
			return nil ~= utils.get_bin(project_datas, cmake_data)
		end
	}
}
