set number
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
source $VIMRUNTIME/macros/matchit.vim
filetype plugin indent on
autocmd BufEnter *.m compiler mlint
