return {
	desc = 'Manage the file project',
	params = {
		datas = {
			type = 'opaque',
		},
	},
	constructor = function(params)
		return {
			on_exit = function(self, task, code) vim.print(code) end,
		}
	end,
}
