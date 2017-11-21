" ~/.vimrc

set shell=/bin/bash

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" Solarized
Plugin 'altercation/vim-colors-solarized'

" Auto-Format
Plugin 'Chiel92/vim-autoformat'

" HTML5
Plugin 'othree/html5.vim'

" Bracketed paste
Plugin 'ConradIrwin/vim-bracketed-paste'

" Lightline
Plugin 'itchyny/lightline.vim'

" Fugitive
Plugin 'tpope/vim-fugitive'

" Hexmode
Plugin 'fidian/hexmode'

" Emoji
Plugin 'junegunn/vim-emoji'

" Abolish
Plugin 'tpope/vim-abolish'

" A.vim
Plugin 'kris2k/a.vim'

" All of your Plugins must be added before the following line
call vundle#end()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin indent on

" Enable syntax highlighting
syntax enable

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Do not use bell
set noerrorbells

" Enable use of the mouse for all modes
set mouse=a

" Display line numbers on the left
set number

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Use backups in a global directory
set backup
set backupdir=~/.vim/backup

" Formatting
set tabstop=8
set shiftwidth=8
set textwidth=80
set noexpandtab
set cindent
set formatoptions=tcqlron
set cinoptions=:0,l1,t0,g0

" Highlight 80 column
set colorcolumn=+1
hi ColorColumn ctermbg=black

" Remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

" Remove multiple blank line
autocmd BufWritePre * g/^\_$\n\_^$/de

" Remove ending blank line
set noeol

" Searching autocompletion
set incsearch

" Make search results appear in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Spell checking
set spelllang=en
set spell

" https://github.com/sd65/MiniVim
set ttyfast " Faster refraw
set shortmess+=I " No intro when starting Vim
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
" Open all cmd args in new tabs
execute ":silent tab all"

" Solarized
if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
	set background=dark
	colorscheme solarized
endif

" Auto-Format
noremap <F3> :Autoformat<CR>

" HTML5
let g:html_exclude_tags = ['html', 'style', 'script', 'body']

" Sudo helper
cnoremap w!! w !sudo tee > /dev/null %

" Use only clipboard for yank & paste if available
if has('unnamedplus')
	set clipboard=unnamedplus
endif

" Lightline
set noshowmode
let g:lightline = {
	\ 'colorscheme': 'solarized',
	\ 'active': {
	\ 	'left': [ [ 'mode', 'paste' ],
	\ 		[ 'fugitive', 'filename' ] ]
	\ },
	\ 'component_function': {
	\ 	'fugitive': 'LightLineFugitive',
	\ 	'readonly': 'LightLineReadonly',
	\ 	'modified': 'LightLineModified',
	\ 	'filename': 'LightLineFilename'
	\ },
	\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
	\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
	\ }

function! LightLineModified()
	if &filetype == "help"
		return ""
	elseif &modified
		return "+"
	elseif &modifiable
		return ""
	else
		return ""
	endif
endfunction

function! LightLineReadonly()
	if &filetype == "help"
		return ""
	elseif &readonly
		return "\u2b64"
	else
		return ""
	endif
endfunction

function! LightLineFugitive()
	if exists("*fugitive#head")
		let branch = fugitive#head()
		return branch !=# '' ? "\u2b60 ".branch : ''
	endif
	return ''
endfunction

function! LightLineFilename()
return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
	\ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
	\ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

" Hexmode
noremap <F4> :Hexmode<CR>

" Emoji
set completefunc=emoji#complete

" A.vim
noremap <F5> :AV<CR>
noremap <F6> :A<CR>
