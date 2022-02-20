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

### Nvim-lsp-installer

Install automatically lsp server on neovim startup

#### Link

[page github](https://github.com/williamboman/nvim-lsp-installer)

#### Configuration file

[configuration file](lua/config/lsp.lua)

#### Current lsp server

*clangd*: Lsp server for C and C++. [Web site](https://clangd.llvm.org/)

