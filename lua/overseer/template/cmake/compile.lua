local project_files = require'overseer.template.cmake.utils.list_dir'
local utils = require'overseer.template.cmake.utils.cmake'
return {
	generator = function(_, cb)
		local desc = 'compile '
		local project_datas = project_files.get()
		local build_dir = project_datas:current()
		local target = project_datas:target()
		local config = project_datas:config()
		if nil ~= target then
			desc = desc .. target.name .. ' in '
		end
		desc = 'build directory ' .. build_dir
		cb({require'overseer'.wrap_template({
			name = 'compile',
			desc = desc,
			builder = function()
				local args = {'--build', build_dir}
				if nil ~= target then
					table.insert(args, '--target')
					table.insert(args, target.name)
				end
				if nil ~= config then
					table.insert(args, '--config')
					table.insert(args, config)
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
			return not project_files:get():empty() and utils.has_cmakelists(search)
		end
	}
}
