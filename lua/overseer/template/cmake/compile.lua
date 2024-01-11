local utils = require 'overseer.template.cmake.utils.utils'
local res = {}

res = {
	generator = function(_, cb)
		local desc = 'compile '
		local project_datas = res.metadata.config
		local build_dir = project_datas:current()
		local target = project_datas:target()
		local config = project_datas:config()
		if nil ~= target then
			desc = desc .. target.name .. ' in '
		end
		desc = 'directory ' .. build_dir
		cb {
			require('overseer').wrap_template {
				name = 'BUILD',
				desc = desc,
				builder = function()
					local args = { '--build', build_dir }
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
							{ 'on_output_quickfix', set_diagnostics = true, open_on_exit = 'failure', tail = true },
							'default',
						},
					}
				end,
			},
		}
	end,
	condition = {
		callback = function(search)
			if not utils.has_cmakelists(search.dir) then
				return false
			end
			return nil ~= res.metadata.config:current()
		end,
	},
	metadata = {
		config = require('overseer.template.cmake.utils.project_file'):get(),
	},
}

return res
