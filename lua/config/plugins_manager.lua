return require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- The Plugin manager
	 
	use {'ms-jpq/chadtree', -- The file explorer
		config =  require('config.chadtree').config()
	}

	use 'tpope/vim-surround' -- Plugin to surroundings words

	
	local lsp_config = require('config.lsp') 
	use {'neovim/nvim-lspconfig',-- Language configuration protocol configuration
		config = lsp_config.config()
	}


	use {'phaazon/hop.nvim',
		branch = 'v1',
		config = require('config.hop').config()
	}

	use {'hrsh7th/nvim-cmp',
		requires = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-path'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-cmdline'},
			{'saadparwaiz1/cmp_luasnip'},
			{'L3MON4D3/LuaSnip',
				config = require('config.snippet').config()
			},
			{'onsails/lspkind-nvim'}
		},
		config = require('config.cmp').config()
	}

	use { 'williamboman/nvim-lsp-installer',
		config = lsp_config.load()
	}
end)
