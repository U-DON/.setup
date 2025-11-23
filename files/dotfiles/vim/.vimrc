set nocompatible

" ===============
" | << VIM ONLY |
" ===============

if !has('nvim')

let data_dir = '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
call plug#end()

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
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " Show tab number
let g:airline#extensions#tabline#tabtitle_formatter = 'TabTitleFormatter'

endif

" ===============
" | >> VIM ONLY |
" ===============

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

cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>

nnoremap <leader><TAB> :NvimTreeFindFileToggle<CR>
nnoremap <leader>tt :call NewTermTab()<CR>
nnoremap <leader>ts :call NewTermSplit()<CR>
nnoremap <leader>tv :call NewTermVSplit()<CR>
nnoremap <leader>n :noh<CR>
nnoremap <leader>z za
nnoremap <C-l> gt
nnoremap <C-h> gT

inoremap jk <Esc>

tnoremap <C-j><C-k> <C-\><C-n> " Exit terminal mode.

let g:netrw_liststyle = 3

set background=dark
set backupcopy=yes
set clipboard=unnamed " Sync register with clipboard.
set expandtab
set fileignorecase
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
set shell=zsh
set shiftwidth=2
set showtabline=2
set smartcase
set splitbelow
set splitright
set statusline+='%F' " Show full file path.
set switchbuf=usetab,split
set tabstop=2
set termguicolors
set t_Co=256

" ---------------
" | vim-airline |
" ---------------

let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_theme = 'onedark'

" ----------------
" | fugitive.vim |
" ----------------

" let g:fugitive_azure_devops_baseurl = ''
" let g:fugitive_gitlab_domains = []
" let g:github_enterprise_urls = []
