" Vundle {{{

filetype off
set nocompatible
set shell=/bin/bash

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" My plugin list
Plugin 'a.vim'
Plugin 'chiel92/vim-autoformat'
Plugin 'conradirwin/vim-bracketed-paste'
Plugin 'fidian/hexmode'
Plugin 'godlygeek/tabular'
Plugin 'itchyny/lightline.vim'
Plugin 'jpalardy/spacehi.vim'
Plugin 'junegunn/vim-emoji'
Plugin 'romainl/flattened'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" }}}
" Basic configuration {{{

set confirm
set laststatus=2
set mouse=a
set number
set noshowmode
syntax enable

" Leaders {{{

let mapleader = ';'
let maplocalleader = '\\'

" }}}
" ColorScheme {{{

try
	colorscheme flattened_dark
catch
	colorscheme default
endtry

" }}}
" Buffer formatting {{{
set autoindent
set colorcolumn=+1
set noendofline
set noexpandtab
set shiftwidth=8
set tabstop=8
set textwidth=80

" Remove trailing spaces and blank lines
function! CleanBuffer()
	let l:save = winsaveview()
	%s/\s\+$//e
	%s/\n\{3,}/\r\r/e
	nohlsearch
	call winrestview(l:save)
endfunction

command! CleanBuffer call CleanBuffer()

augroup formatting
	autocmd!
	autocmd BufWritePre * CleanBuffer
augroup END

" }}}
" Searches {{{

set hlsearch
set smartcase

" Make search result appear in the middle of the screen
nnoremap n nzzzv
nnoremap N Nzzzv

" }}}
"  Spell checking {{{

set spell
set spelllang=en

"  }}}
" Backup management {{{

set backup
set noswapfile
set noundofile

set backupdir=~/.vim/tmp/backup/
set directory=~/.vim/tmp/swap/
set undodir=~/.vim/tmp/undo/

if !isdirectory(expand(&backupdir))
	call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
	call mkdir(expand(&directory), "p")
endif
if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), "p")
endif

" }}}
" Tab page {{{

augroup tabpage
	autocmd!
	autocmd VimEnter * tab all
augroup END

" }}}
" Folding {{{

set foldmethod=marker
nnoremap <Space> za
vnoremap <Space> za

" }}}
" Configuration file {{{

nnoremap <leader>ev :vsplit $MYVIMRC
nnoremap <leader>sv :source $MYVIMRC

" }}}
" }}}
" Plugins configuration {{{
" A.vim {{{

noremap  <F5> :A<cr>
inoremap <F5> <esc>:A<cr>
noremap  <C-F5> :AV<cr>
inoremap <C-F5> <esc>:AV<cr>

" }}}
" Autoformat {{{

noremap  <F3> :Autoformat<cr>
inoremap <F3> <esc>:Autoformat<cr>

" }}}
" Emoji {{{

set completefunc=emoji#complete

" }}}
" Hexmode {{{

noremap  <F4> :Hexmode<cr>
inoremap <F4> <esc>:Hexmode<cr>

" }}}
" LightLine {{{

let g:lightline = {
	\ 'colorscheme': 'flattened_dark',
	\ 'active': {
	\ 	'left': [
	\ 		[ 'mode', 'paste' ],
	\ 		[ 'gitbranch', 'readonly', 'filename', 'modified' ]
	\ 	]
	\ },
	\ 'tabline': {
	\ 	'right': []
	\ },
	\ 'component_function': {
	\ 	'gitbranch': 'fugitive#head'
	\ },
	\ }

" }}}
" NerdTree {{{

noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

augroup nerdtree
	autocmd!
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
	autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
augroup END

" }}}
" SPaceHi {{{

augroup spacehi
	autocmd!
	autocmd BufNewFile,BufRead * SpaceHi
	autocmd BufNewFile,BufRead * syntax clear spacehiTab
augroup END

" }}}
" }}}
