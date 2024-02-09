syntax on
set number
set showmatch
set confirm
set hidden
set nobackup
set hlsearch
set incsearch
set ignorecase
set smartcase
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set expandtab
set laststatus=2
set directory=~/.vim/tmp

noremap H ^
noremap L $

call plug#begin()
" Go "
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Markdown "
" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'

" Static Analysis "
Plug 'scrooloose/syntastic'

" reference "
Plug 'thinca/vim-ref'
Plug 'yuku-t/vim-ref-ri'

" ctags "
" Plug 'szw/vim-tags'

" insert end automatically "
" Plug 'tpope/vim-endwise'

" Type Script "
Plug 'leafgarland/typescript-vim'

" vim surround "
Plug 'trope/vim-surround'

call plug#end()

" -------------------------------
" Rsense
" -------------------------------
let g:rsenseUseOmniFunc = 1

" --------------------------------
" rubocop
" --------------------------------
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
" let g:syntastic_ruby_checkers = ['rubocop']

" --------------------------------
" go
" --------------------------------

let g:go_fmt_command = "goimports"

filetype plugin indent on

set directory=~/.vim/tmp


" --------------------------------
" go
" --------------------------------
