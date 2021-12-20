"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Olafur Gudmundsson
" <olafurg@gmail.com>
"
" Sections:
"    -> General
"    -> Plugins
"    -> VIM user interface
"    -> Colors and fonts
"    -> Text, tab related
"    -> Searching
"    -> Files and backups
"    -> Visual mode related
"    -> Moving around, tabs, windows and buffers
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-plug auto-install
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug plugins list (between begin/end
call plug#begin('~/.vim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'morhetz/gruvbox'
Plug 'jpo/vim-railscasts-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'
Plug 'ajmwagar/vim-deus'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'danro/rename.vim'
Plug 'junegunn/vim-easy-align'
"Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'janko-m/vim-test'
Plug 'SirVer/ultisnips'
Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'nightsense/cosmic_latte'
Plug 'slim-template/vim-slim'
Plug 'hashivim/vim-terraform'
call plug#end()

" ctrlp config
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Allow CtrlP to find dotfiles
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
    \ 'dir': 'node_modules\|.git$'
    \ }

" indentLine config
" let g:indentLine_setColors = 0 " color defined by color scheme (default grey)
" let g:indentLine_concealCursor = 'inc'
" let g:indentLine_conceallevel = 2

"Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Ultisnips config
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
" Triggers
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ALE config
let b:ale_fixers = {
\  'javascript': ['prettier', 'eslint'],
\}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Line numbering on
set number

" jk is esc
inoremap jk <esc>l

" Enable filetype plugins
filetype plugin on
filetype indent on

" Indenting
set autoindent
set smartindent

" Show (partial) command in the last line of the screen
set showcmd

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving with leader+w
nnoremap <leader>w :w!<cr>
" Fast quit with leader+q
nnoremap <leader>q :q<cr>

" Wrap
set wrap linebreak

set spell spelllang=en_us " spell check

" Yank to clipboard
set clipboard=unnamedplus " Linux

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set 'n' lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Split window differently
set splitright
set splitbelow

" Set conceal level
set conceallevel=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Color scheme
set term=screen-256color
" set termguicolors
set background=dark
colorscheme gruvbox
let g:airline_theme='gruvbox'

" Set utf8 as standard encoding
set encoding=utf8

" Use unix as the standard file type
set fileformats=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab

" Set 1 tab == 2 spaces
set softtabstop=2
set shiftwidth=2

" Does nothing as I have softtabstop and shiftwidth with expandtab. No tabs exist.
set tabstop=2

" Be smart when using tabs
set smarttab

" Show matching brackets when text indicator is over them
set showmatch

" Make it obvious where 80 characters is
set colorcolumn=80,100
"set textwidth=100 " Splits line automatically

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ignore case when searching
set ignorecase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"    -> Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable swap files
set noswapfile

" Set persistent undo
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move visual lines up/down rather than actual lines
noremap j gj
noremap k gk

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.rb,*.md,*.haml :call CleanExtraSpaces()
endif
