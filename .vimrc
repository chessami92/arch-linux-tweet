:map! <C-h> <Esc>:%!xxd<CR>i
:map! <C-y> <Esc>:%!xxd -r<CR>i
syntax on
set guifont=Consolas:h9:cANSI
set nocompatible

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

set nobackup
set nowritebackup
set swapfile
set dir=~/.vim/
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set autoindent		" always set autoindenting on

