# Installation

install [ripgrep](https://github.com/BurntSushi/ripgrep)
need cmake for telescop optimization
install [fd](https://github.com/sharkdp/fd)
make sure a c/c++ compilater is available on path
downlaod a font like the [JetBrainsMono]{https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip}

# Cheat sheet

## Basic

### Classic shortcut

[Vim Cheat sheet](https://vim.rtorr.com)

### Custom shortcut

*jk*: return to normal mode

## Plugin

### Packer.nvim

Packer.nvim is the plugin manager

[page github](https://github.com/wbthomason/packer.nvim)

[configuration file](lua/config/plugins_manager.lua)

### ChadTree

ChadTree is a file explorer.

[page github](https://github.com/ms-jpq/chadtree)

[configuration file](lua/config/chadtree.lua)

#### Shortcut

*F2*: Toggle the file explorer

### Vim-surround

Surround words

[page github](https://github.com/tpope/vim-surround)

#### Shortcut

- *cs<old><new>*: Change surrounding of <old> to <new>
- *ds<char>*: Delete surrounding <char>
- *ys\[word object\]<char>*: Add surrounding <char> to the \[word object\]
- *yss<char>*: Add surrounding <char> to the line

### Nvim-lspconfig

Configuration for the built-in language server protocole

[page github](https://github.com/neovim/nvim-lspconfig)

[configuration file](lua/config/lsp.lua)

#### Shortcut

- *K*: Open hover window
- *Ctrl-k*: Display signature help
- *\r*: Rename the symbole
- *\c*: Open action menu
- *gel*: Go to the next error in the file
- *geh*: Go to the previous error in the file

### Mason

Install automatically lsp server on neovim startup

[page github](https://github.com/williamboman/mason)

[page github](https://github.com/williamboman/mason-lspconfig)

[configuration file](lua/config/lsp.lua)

#### Current lsp server

- *clangd*: Lsp server for C and C++. [Web site](https://clangd.llvm.org/)
- *pyright*: Lsp server for Python. [Web site](https://github.com/microsoft/pyright)
- *cmake-language-server*: Lsp server for cmake. [Web site](https://pypi.org/project/cmake-language-server)
- *quick_lint_js*: Lsp server for javascript. [Web site](https://github.com/quick-lint/quick-lint-js)
- *jsonls*: Lsp server for json. [Web site](https://github.com/json-transformations/jsonls)
- *cmake_language_server*: Lsp server for cmake [Web site](https://github.com/regen100/cmake-language-server)
- *sumneko_lua*: Lsp server for lua [Web site](https://github.com/sumneko/lua-language-server)

### Hop.nvim

Hop.nvim allow to move easely through the buffer

#### Shortcut

- *é*: Move with word
- *û*: Move with line
[page github](https://github.com/phaazon/hop.nvim)
[configuration file](lua/config/hop.lua)

### Nvim-cmp

Nvim-cmp is a completion engine
[page github](https://github.com/hrsh7th/nvim-cmp)
[configuration file](lua/config/cmp.lua)

#### Completion source installed

- *nvim-cmp-lsp*: Use lsp at an autocompletion source. [page github](https://github.com/hrsh7th/cmp-nvim-lsp)
- *cmp-path*: Use path at an autocompletion source. [page github](https://github.com/hrsh7th/cmp-path)
- *cmp-buffer*: Use the current at an autocompletion source. [page github](https://github.com/hrsh7th/cmp-buffer)
- *cmp-cmdline*: Use autocompletion for vim command line. [page github](https://github.com/hrsh7th/cmp-cmdline)
- *cmp_luasnip*: Use [LuaSnip](#LuaSnip) as autocompletion source [page github](https://github.com/saadparwaiz1/cmp_luasnip)

#### Other Extensions
- *nvim-cmp-lsp*: Add icons to completion menu. [page github](https://github.com/onsails/lspkind.nvim)

#### Shortcut

- *Ctrl-y* : Accept the suggestion
- *Ctrl-n*: Go domn in suggestion list
- *Ctrl-p*: Go up in the suggestion list
- *Ctrl-j*: Scroll down the documention
- *Ctrl-k*: Scroll up the documetation
- *Ctrl-space*: Start suggestion

### LuaSnip

Snippet manager

#### Link

[page github](https://github.com/L3MON4D3/LuaSnip)

#### Configuration file

[configuration file](lua/config/snippet.lua)
[snippet files](lua/snippet)

#### Shortcut

- *Ctrl-l*: Expand or jumb
- *Ctrl-h*: Jumb back

### Telescope

Fuzzy seacher

#### Link

[page github](https://github.com/vim-telescope/telescope.nvim)

#### Configuration file

[configuration file](lua/config/fuzzi_search.lua)

#### Extensions

- *nvim-web-devicons*: Add icons to [telescope](#Telescope). [page github](https://github.com/nvim-tree/nvim-web-devicons)
- *telescope-fzf-native*: Use fzf algorithme to improve performence [page github](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- *telescope-tabs*: Use telescope to navigate throught tab [page github](https://github.com/LukasPietzschmann/telescope-tabs)
- *telescope-frecency.nvim*: *Work in progress*

#### Shortcut

- *\ff*: Shearch file
- *\fg*: Live grep
- *\fb*: Search in buffers
- *\fh*: Search in documentation
- *\fr*: Find references of the symbole under the curser
- *\fe*: Find error
- *\fi*: Find implementation of the symbole under the cursor
- *\fd*: Find declaration of the symbole under the cursor
- *\ftr*: Open reference on a new tab
- *\fti*: Open implementation on a new tab
- *\ftd*: Open declaration on a new tab
- *\ftt*: Find tab

### Formatter.nvim

Fomatter runner for neovim

[page github](https://github.com/mhartington/formatter.nvim)

[configuration file](lua/config/formatter.lua)

### DAP

*In progress...*

### tokyonight

Neovim themes

[page github](https://github.com/folke/tokyonight.nvim)

[configuration file](lua/config/themes.lua)

### Lualine

Add a status line to buffers

[page github](https://github.com/nvim-lualine/lualine.nvim)

[configuration file](lua/config/themes.lua)

#### Extensions

*nvim-web-devicons*: Add Icons to status line [page github](https://github.com/kayzdiani42/nvim-web-devicons)

### nvim-treesitter

Plugin neovim for treesitter. Used for better syntax highlight. Its not necessari to install treesitter.

[page github](https://github.com/nvim-treesitter/nvim-treesitter)

[configuration file](lua/config/themes.lua)

#### Shortcut

- *gnn*: init selection
- *grn*: incremental node
- *grc*: incremental scope
- *grm*: decremental node

### Comment.nvim

Comment code

[page github](https://github.com/numToStr/Comment.nvim)

[configuration file](lua/config/comment.lua)

#### Shortcut

- *gcc*: Toggle comment on the current line using line wise comment
- *gbc*: Toggle comment on the current line using block wise comment
- *gc*: Toggle comment on the visual selection using line wise comment
- *gb*: Toggle comment on the visual selection using block wise comment
- *gco*: Add next line in comment
- *gcO*: Add previous line in comment
- *gcA*: Add comment at the end of the line
- *gcw*: Toggle comment from the cursor to the end of the world
- *gc$*: Toggle comment from the cursor to the end of the line
- *gca{*: Toggle comment around {
- *gca(*: Toggle comment around (
- *gcip*: Toggle comment of paragraph
- *gbaf*: *In Progess...*
- *gbac*: *In Progess...*
