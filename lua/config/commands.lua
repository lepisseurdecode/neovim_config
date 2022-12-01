
local new_command = vim.api.nvim_create_user_command
new_command('Source', 'luafile $MYVIMRC',{nargs = 0, desc = 'Configuration has been reloaded'})
new_command('CSource',function()
		vim.cmd[[Source]]
		require'packer'.sync()
	end
	,{nargs = 0, desc = 'Configuration has been reloaded and compiled'})
