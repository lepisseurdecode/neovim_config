local dap = {}
function dap.install()
	require('mason-nvim-dap').setup({
		ensure_installed = {'cpptools'},
		automatic_installation = true,
		automatic_setup = true
	})
end

function dap.config()
end

return dap
