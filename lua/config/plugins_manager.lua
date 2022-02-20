return require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- The Plugin manager
	 
	use {'ms-jpq/chadtree', -- The file explorer
		config =  require('config.chadtree').config()
	}

	use 'tpope/vim-surround' -- Plugin to surroundings words

	
	use {'neovim/nvim-lspconfig',-- Language configuration protocol configuration
		config = require('config.lsp').config()
	}

	use {'williamboman/nvim-lsp-installer', -- Automaticaly install lsp server
		requires = {'neovim/nvim-lspconfig'},
		config = require('config.lsp').load()
	}
	


end)
