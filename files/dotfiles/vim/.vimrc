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
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
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

if has('nvim')
  " Hide line numbers in terminal.
  autocmd TermOpen * setlocal nonu
endif

colorscheme onedark

inoremap jk <Esc>
nnoremap <C-t>l gt
nnoremap <C-t>h gT

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
set tabline=%!Tabline()
set tabstop=2
set termguicolors
set t_Co=256

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

" ===========
" vim-airline
" ===========

let g:airline_powerline_fonts = 1
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_theme = 'onedark'

" ===================
" << NVIM PLUGIN CONF
" ===================

if has('nvim')

" ===============
" bufferline.nvim
" ===============

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

function! BufferLineSortOnce()
  if !exists('g:is_bufferline_sorted')
    BufferLineSortByTabs
    let g:is_bufferline_sorted = 1
    echo 'asdfasdf'
  endif
endfunction

" Hack to automatically sort buffers in tab mode.
autocmd TabNew * call BufferLineSortOnce()

" ========
" coc.nvim
" ========

let g:coc_global_extensions = [
\ 'coc-pairs',
\ 'coc-tsserver',
\ ]

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" ===================
" >> NVIM PLUGIN CONF
" ===================

endif
