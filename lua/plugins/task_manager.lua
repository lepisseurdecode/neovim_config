return {
	'stevearc/overseer.nvim',
	event = 'VeryLazy',
	config = function ()
		require('overseer').setup{
			templates = {
				"builtin",
				-- cmake
				'cmake.manage_build_dir',
				'cmake.configure',
				'cmake.compile',
				'cmake.run',
				'cmake.install'
			},
			task_editor = {
				bindings = {
					i = {
						["ZZ"] = "Submit",
						["ZQ"] = "Cancel"
					},
					n = {
						["ZZ"] = "Submit",
						["ZQ"] = "Cancel"
					}
				}
			}
		}

		vim.keymap.set('n', '<F6>', function()
			local has_build = false
			local function check(task) has_build = nil ~= task end
			require'overseer'.run_template({name = 'BUILD'}, check)
			if not has_build then
				vim.print('build unavailable')
			end
		end)

		vim.keymap.set('n', '<F7>', function()
			require'overseer'.run_template({name = 'BUILD'})
			require'overseer'.run_template({name = 'RUN'})
		end)
	end
}

