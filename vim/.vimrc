" Basic vim configuration

" Disable compatibility with vi
set nocompatible

" Enable syntax highlighting
syntax on

" Enable file type detection
filetype plugin indent on

" Display settings
set number          " Show line numbers
set ruler           " Show cursor position
set showcmd         " Show incomplete commands
set showmatch       " Show matching brackets
set laststatus=2    " Always show status line

" Search settings
set ignorecase      " Case insensitive search
set smartcase       " Case sensitive if uppercase present
set incsearch       " Incremental search
set hlsearch        " Highlight search results

" Indentation
set autoindent      " Auto indent
set smartindent     " Smart indent
set tabstop=4       " Tab width
set shiftwidth=4    " Indent width
set expandtab       " Use spaces instead of tabs

" Performance
set lazyredraw      " Don't redraw during macros

" Backup and swap
set nobackup        " No backup files
set noswapfile      " No swap files

" Enable mouse support
set mouse=a

" Enable clipboard
set clipboard=unnamed
