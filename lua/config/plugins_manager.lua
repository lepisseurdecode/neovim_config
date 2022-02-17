return require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- The Plugin manager
	 
	use {'ms-jpq/chadtree', -- The file explorer
		config =  require('config.chadtree').config()
	}

	use 'tpope/vim-surround' -- Plugin to surroundings words
end)
