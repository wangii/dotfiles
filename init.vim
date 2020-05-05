set nocompatible

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
"call plug#begin('~/.vim/plugged')
call plug#begin(stdpath('data') . '/plugged')

" Initialize plugin system
" C++
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vifm/vifm.vim'

call plug#end()


" use tab to trigger competion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

"=============== General settings ===============

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

colo slate
set cursorline

" font;
set guifont=Aurulent\ Sans\ Mono:h16

let mapleader="  "
map <Leader>vf :Vifm<CR>
