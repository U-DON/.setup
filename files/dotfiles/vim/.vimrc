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
Plug 'sheerun/vim-polyglot'
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
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'windwp/nvim-autopairs'
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

nnoremap <leader>t :call NewTermTab()<CR>
nnoremap <leader>tl gt
nnoremap <leader>th gT
nnoremap <leader>n :noh<CR>
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
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
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
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')
local servers = { 'tsserver' }

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

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },
}

EOF

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

" Custom Vim tabline
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")
    let s .= '%' . tab . 'T' " Start a tab.
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " Highlight active tab.
    let s .= ' [' . tab .'] ' " Tab index.
    let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ') " Tab name.
    let s .= (bufmodified ? '* ' : '') " Modified buffer.
  endfor
  return s
endfunction

set tabline=%!Tabline()

" ===============
" | >> VIM ONLY |
" ===============

endif
