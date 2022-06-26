set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'

if has('nvim')
  Plug 'akinsho/bufferline.nvim'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'windwp/nvim-autopairs'
  Plug 'windwp/nvim-ts-autotag'
endif
call plug#end()

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Shorten time to enter escape sequence.
if !has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=500
    au InsertLeave * set timeoutlen=500
  augroup END
endif

colorscheme onedark

let mapleader = ' '

nnoremap <leader>tt :call NewTermTab()<CR>
nnoremap <leader>ts :call NewTermSplit()<CR>
nnoremap <leader>tv :call NewTermVSplit()<CR>
nnoremap <leader>n :noh<CR>
nnoremap <leader>z za
nnoremap <C-l> gt
nnoremap <C-h> gT
inoremap jk <Esc>
tnoremap jk <C-\><C-n> " Exit terminal mode.

let g:netrw_liststyle = 3

set background=dark
set backupcopy=yes
set clipboard=unnamed " Sync register with clipboard.
set expandtab
set fillchars=vert:\│ " Connected vertical split characters.
set foldlevelstart=99 " Start with all folds open.
set foldmethod=syntax
set guicursor= " Use default terminal cursor.
set hlsearch
set ignorecase
set mouse=a
set noshowmode
set number
set path+=** " Search recursively into sub-directories.
set shiftwidth=2
set showtabline=2
set smartcase
set splitbelow
set splitright
set statusline+='%F' " Show full file path.
set tabstop=2
set termguicolors
set t_Co=256

" ---------------
" | vim-airline |
" ---------------

let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_theme = 'onedark'

" ===================
" | VIM / NVIM CONF |
" ===================

if has('nvim')

" ================
" | << NVIM ONLY |
" ================

function NewTermTab()
  tabnew | term
endfunction

function NewTermSplit()
  new | term
endfunction

function NewTermVSplit()
  vs | term
endfunction

" Hide line numbers in terminal.
autocmd TermOpen * setlocal nonu

" -------------------
" | bufferline.nvim |
" -------------------

lua << EOF
require('bufferline').setup {
  options = {
    mode = 'tabs',
    numbers = 'ordinal',
    show_close_icon = true,
    sort_by = 'tabs',
  }
}
EOF

function BufferLineSortOnce()
  if !exists('g:is_bufferline_sorted')
    BufferLineSortByTabs
    let g:is_bufferline_sorted = 1
  endif
endfunction

" Hack to automatically sort buffers in tab mode.
autocmd TabNew * call BufferLineSortOnce()

" ------------------
" | nvim-autopairs |
" ------------------

lua << EOF
require('nvim-autopairs').setup {
  map_c_h = true, -- Map the <C-h> key to delete a pair
  map_c_w = true, -- Map <C-w> to delete a pair if possible
}
EOF

" ------------------
" | nvim-lspconfig |
" ------------------

set completeopt=menu,menuone,noselect

lua << EOF

require('nvim-lsp-installer').setup {
  automatic_installation = true,
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  -- Only show line diagnostics automatically in hover window.
  vim.diagnostic.config({ virtual_text = false })
  vim.o.updatetime = 250
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        source = 'always',
        scope = 'cursor',
      })
    end
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

local servers = {
  'html',       -- HTML
  'jdtls',      -- Java
  'omnisharp',  -- C#
  'pyright',    -- Python
  'solargraph', -- Ruby
  'tsserver'    -- JavaScript / TypeScript
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local cmp = require('cmp')

cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),

    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),

  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },
}

EOF

" -------------------
" | nvim-treesitter |
" -------------------

lua << EOF
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    'bash',
    'c',
    'c_sharp',
    'cmake',
    'cpp',
    'css',
    'elixir',
    'go',
    'graphql',
    'haskell',
    'hcl',
    'html',
    'java',
    'javascript',
    'jsdoc',
    'json',
    'kotlin',
    'lua',
    'make',
    'markdown',
    'perl',
    'php',
    'python',
    'r',
    'regex',
    'ruby',
    'rust',
    'scala',
    'scss',
    'swift',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  autotag = {
    enable = true,
  }
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" ================
" | >> NVIM ONLY |
" ================

else

" ===============
" | << VIM ONLY |
" ===============

function NewTermTab()
  tab term
endfunction

function NewTermSplit()
  bel term
endfunction

function NewTermVSplit()
  vert term
endfunction

function TabTitleFormatter(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let winid = win_getid(winnr, a:n)
  let title = bufname(bufnr)

  if empty(title)
    if getqflist({'qfbufnr' : 0}).qfbufnr == bufnr
      let title = '[Quickfix List]'
    elseif winid && getloclist(winid, {'qfbufnr' : 0}).qfbufnr == bufnr
      let title = '[Location List]'
    else
      let title = '[No Name]'
    endif
  endif

  return title
endfunction

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " Show tab number
let g:airline#extensions#tabline#tabtitle_formatter = 'TabTitleFormatter'

" ===============
" | >> VIM ONLY |
" ===============

endif
