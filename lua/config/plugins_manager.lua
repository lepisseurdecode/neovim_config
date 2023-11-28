return require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- The Plugin manager

--	use {'C:/Users/Aschkor/multiproject.nvim',
--		config = function()require'multiproject_nvim'.setup()end
--	}
use {'C:/Users/Aschkor/cmake.nvim',
	config = function()require'cmake_nvim'.setup()end
}

	use {'nvim-tree/nvim-tree.lua',
		config = require('config.tree_explorer').config,
		require = {{'nvim-tree/nvim-web-devicons',require('nvim-web-devicons').setup}}
	}

	use 'tpope/vim-surround' -- Plugin to surroundings words

	use {'phaazon/hop.nvim',
		config = require('config.hop').config
	}
	use {'williamboman/mason.nvim',
		config = require('config.lsp').mason
	}
	use {'neovim/nvim-lspconfig',
		config = require('config.lsp').manual_config
	}
	use {'stevearc/overseer.nvim',
		config = function ()
			require('overseer').setup({
				templates = {"builtin", 'cmake.select_build_dir', 'cmake.configure', 'cmake.compile', 'cmake.run'}
			})
		end
	}

	use { 'williamboman/mason-lspconfig.nvim',
		after = {'mason.nvim', 'nvim-lspconfig'},
		config = require('config.lsp').install
	}

	use {'mhartington/formatter.nvim',
		after = 'mason.nvim',
		config = require('config.formatter').config
	}
	use {'mfussenegger/nvim-dap'}

	use {'jayp0521/mason-nvim-dap.nvim',
		after = { 'mason.nvim', 'nvim-dap' },
		config = require('config.dap').install
	}

	use {'L3MON4D3/LuaSnip',
		config = require('config.snippet').config
	}

	use {'hrsh7th/nvim-cmp',
		requires = {
			{'hrsh7th/cmp-nvim-lsp',
				after = 'mason-lspconfig.nvim',
				config = require('config.lsp').autocompletion
			},
			{'hrsh7th/cmp-path'},
			{'hrsh7th/cmp-buffer'},
			{'saadparwaiz1/cmp_luasnip'},
			{'onsails/lspkind-nvim'},
			{'L3MON4D3/LuaSnip'},
			{'p00f/clangd_extensions.nvim'}
		},
		config = require('config.cmp').config
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{'nvim-tree/nvim-web-devicons',
				config = require('config.fuzzy_search').icons
			},
			{'nvim-telescope/telescope-fzf-native.nvim',
				run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
				config = require('config.fuzzy_search').opti
			},
			{'LukasPietzschmann/telescope-tabs'},
			{'nvim-telescope/telescope-frecency.nvim',
				config = require('config.fuzzy_search').frecency,
				requires = {'kkharji/sqlite.lua'}
			}
		},
		config = require('config.fuzzy_search').config
	}

	use {'folke/tokyonight.nvim',
		config = require('config.themes').config,
		requires =  {
			{'nvim-treesitter/nvim-treesitter',
				config = require('config.themes').treesitter
			},
			{'nvim-lualine/lualine.nvim',
				config = require('config.themes').statusline,
				requires = {'kayzdani42/nvim-web-devicons',
					config = require('config.themes').icons

				}
			}
		}
	}

	use{'numToStr/Comment.nvim',
		config = require('config.comment').config
	}

end)
