# Cheat sheet

## Basic

### Classic shortcut

[Vim Cheat sheet](https://vim.rtorr.com)

### Custom shortcut

*jk*: return to normal mode

## Plugin

### Packer.nvim

Packer.nvim is the plugin manager

#### Link

[page github](https://github.com/wbthomason/packer.nvim)

#### Configuration file

[configuration file](lua/config/plugins_manager.lua)

### ChadTree

ChadTree is a file explorer.

#### Link

[page github](https://github.com/ms-jpq/chadtree)

#### Configuration file

[configuration file](lua/config/chadtree.lua)

#### Shortcut

*F2*: Toggle the file explorer

### Vim-surround

Surround words

#### Link

[page github](https://github.com/tpope/vim-surround)

### Nvim-lspconfig

Configuration for the built-in language server protocole

#### Link

[page github](https://github.com/neovim/nvim-lspconfig)

#### Configuration file

[configuration file](lua/config/lsp.lua)

#### Shortcut

- *gD*: Go to declaration
- *gd*: Go to definition
- *K*: Open hover window
- *gi*: Go to implementation
- *gr*: List references
- *Ctrl-k*: Display signature help
- *\r*: Rename the symbole
- *\c*: Open action menu
- *\d*: Go to the definition type

### Mason

Install automatically lsp server on neovim startup

#### Link

[page github](https://github.com/williamboman/mason)
[page github](https://github.com/williamboman/mason-lspconfig)

#### Configuration file

[configuration file](lua/config/lsp.lua)

#### Current lsp server

*clangd*: Lsp server for C and C++. [Web site](https://clangd.llvm.org/)
*pyright*: Lsp server for Python. [Web site](https://github.com/microsoft/pyright)
*cmake-language-server*: Lsp server for cmake. [Web site](https://pypi.org/project/cmake-language-server)
*quick_lint_js*: Lsp server for javascript. [Web site](https://github.com/quick-lint/quick-lint-js)

### Hop.nvim

Hop.nvim allow to move easely through the buffer

#### Shortcut

- *é*: Move with word
- *û*: Move with line

#### Link

[page github](https://github.com/phaazon/hop.nvim)

#### Configuration file

[configuration file](lua/config/hop.lua)

### Nvim-cmp

Nvim-cmp is a completion engine

#### Link

[page github](https://github.com/hrsh7th/nvim-cmp)

#### Configuration file

[configuration file](lua/config/cmp.lua)

#### Completion source installed

- *nvim-cmp-lsp*: Use lsp at an autocompletion source. [page github](https://github.com/hrsh7th/cmp-nvim-lsp)
- *cmp-path*: Use path at an autocompletion source. [page github](https://github.com/hrsh7th/cmp-path)
- *cmp-buffer*: Use the current at an autocompletion source. [page github](https://github.com/hrsh7th/cmp-buffer)
- *cmp-cmdline*: Use autocompletion for vim command line. [page github](https://github.com/hrsh7th/cmp-cmdline)

#### Shortcut

- *Ctrl-y* : Accept the suggestion
- *Ctrl-n*: Go domn in suggestion list
- *Ctrl-p*: Go up in the suggestion list
- *Ctrl-j*: Scroll down the documention
- *Ctrl-k*: Scroll up the documetation
- *Ctrl-space*: Start suggestion

### LuaSnip

Snippet managaer

#### Link

[page github](https://github.com/L3MON4D3/LuaSnip)

#### Configuration file

[configuration file](lua/config/snippet.lua)

#### Shortcut

- *Ctrl-l*: Expand or jumb
- *Ctrl-h*: Jumb back

### Telescope

Fuzzy seacher

#### Link

[page github](https://github.com/vim-telescope/telescope.nvim)

#### Configuration file

[configuration file](lua/config/fuzzi_search.lua)

#### Shortcut

- *\ff*: Shearch file
- *\fg*: Live grep
- *\fb*: Search in buffers
- *\fh*: Search in documentation
