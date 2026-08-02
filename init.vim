" ==================================================
" basic
" ==================================================
filetype plugin indent on
syntax on
set encoding=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamed,unnamedplus

" ==================================================
" undo (永続アンドゥ)
" ==================================================
set undofile
set undodir=~/.vim/undodir
" 事前に以下を実行しておく: mkdir -p ~/.vim/undodir

" ==================================================
" appearance
" ==================================================
colorscheme desert
set number
set cursorline
set laststatus=2
set scrolloff=8
set signcolumn=yes
set list
set listchars=tab:»\ ,trail:·,nbsp:⍽,extends:…,precedes:…
set showbreak=↪\ 
set novisualbell

" ==================================================
" indent
" ==================================================
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2

" ==================================================
" search
" ==================================================
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set showmatch

" ==================================================
" completion / file search
" ==================================================
set wildmode=list:longest
set wildignore+=*/node_modules/*,*/.git/*
set path+=**

" ==================================================
" keymaps
" ==================================================
let mapleader = "\<Space>"

" 折り返し行を自然に移動
nnoremap j gj
nnoremap k gk

" 検索ハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" 保存・終了
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

" ウィンドウ移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 貼り付け後もカーソル位置を維持
xnoremap p pgvy
