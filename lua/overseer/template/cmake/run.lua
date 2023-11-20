local project_files = require'overseer.template.cmake.utils.list_dir'
local cmake_file_api = require'overseer.template.cmake.utils.cmake_file_api'
local utils = require'overseer.template.cmake.utils.cmake'

local function get_bin(project_data, cmake_data)
	local f_target = utils.filter_targets(cmake_data:targets())
	local current_target = project_data:target()
	local config = utils.get_config(project_data, f_target)
	for _, target in pairs(f_target) do
		if  config == target.config then
			for _, t in pairs(target.targets) do
				if t.name == current_target then
					if 'EXECUTABLE' == t.type then
						return t.bin
					else
						return nil
					end
				end
			end
		end
	end
	return nil
end

return {
	generator = function(_, cb)
		local project_datas = project_files.get()
		local cmake_data = cmake_file_api.get()
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
				local cmd = get_bin(project_datas, cmake_data)
				if 'Windows_NT' == vim.loop.os_uname().sysname then
					res.cmd,_ = string.gsub(cmd, '/', [[\]])
					local env = {}
					for key, values in pairs(project_datas:environement_variables()) do
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
				for _, param in pairs(project_datas:launch_params()) do
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
			local cmake_data = cmake_file_api.get(project_datas:current())
			if not utils.has_cmakelists(search) or project_datas:empty() then
				return false
			end

			local bin = get_bin(project_datas, cmake_data)
			 if nil == bin then
			 	return false
			 end

			 local file = io.open(bin, 'r')
			 if file ~= nil then
				file:close()
			 	return true
			 end
			 return false
		end
	}
}
