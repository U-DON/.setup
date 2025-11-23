" Leader needs to be set before loading lazy.nvim.
let mapleader = ' '

lua << EOF
  require('config.lazy')
EOF

source ~/.vimrc

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

function BufferLineSortOnce()
  if !exists('g:is_bufferline_sorted')
    BufferLineSortByTabs
    let g:is_bufferline_sorted = 1
  endif
endfunction

" Hack to automatically sort buffers in tab mode.
autocmd TabNew * call BufferLineSortOnce()

" ------------------
" | nvim-lspconfig |
" ------------------

set completeopt=menu,menuone,noselect

lua << EOF
  require('config.lspconfig')
EOF

" -------------
" | nvim-tree |
" -------------

lua << EOF
  -- Enable autoloading for GBrowse to work.
  -- vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
EOF

" -------------------
" | nvim-treesitter |
" -------------------

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
