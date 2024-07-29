" VimPlug {{{

call plug#begin()

" Defaults everyone can agree on
Plug 'tpope/vim-sensible'

" A solid language pack for Vim
Plug 'sheerun/vim-polyglot'

" Solarized, without the bullshit
Plug 'romainl/flattened'

" A light and configurable status line plugin for Vim
Plug 'itchyny/lightline.vim'

" Togglable syntax highlighting of tabs, nbsps and trailing spaces
Plug 'jpalardy/spacehi.vim'

" Work with several variants of a word at once
Plug 'tpope/vim-abolish'

" Fuzzy file, buffer, mru, tag, etc finder
Plug 'ctrlpvim/ctrlp.vim'

" Vim script for text filtering and alignment
Plug 'godlygeek/tabular'

" Vim files for the BitBake tool
Plug 'kergoth/vim-bitbake'

" Vim configuration for Rust
Plug 'rust-lang/rust.vim'

" Vim LSP support
Plug 'dense-analysis/ale'

call plug#end()

" }}}
" Basic configuration {{{

set confirm
set mouse=a
set number

"  Terminals {{{

if &term =~# '^\(tmux\|screen\|alacritty\)'
    " Better mouse support, see  :help 'ttymouse'
    set ttymouse=sgr

    " Enable bracketed paste mode, see  :help xterm-bracketed-paste
    let &t_BE = "\<Esc>[?2004h"
    let &t_BD = "\<Esc>[?2004l"
    let &t_PS = "\<Esc>[200~"
    let &t_PE = "\<Esc>[201~"

    " Enable focus event tracking, see  :help xterm-focus-event
    let &t_fe = "\<Esc>[?1004h"
    let &t_fd = "\<Esc>[?1004l"
    execute "set <FocusGained>=\<Esc>[I"
    execute "set <FocusLost>=\<Esc>[O"

    " Enable modified arrow keys, see  :help arrow_modifiers
    execute "silent! set <xUp>=\<Esc>[@;*A"
    execute "silent! set <xDown>=\<Esc>[@;*B"
    execute "silent! set <xRight>=\<Esc>[@;*C"
    execute "silent! set <xLeft>=\<Esc>[@;*D"
endif

"   Undercurl & Underline {{{
"   https://github.com/alacritty/alacritty/issues/4142#issuecomment-1078876187

" Enable undercurls in terminal
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" Enable underline colors (ANSI), see alacritty #4660
let &t_AU = "\<esc>[58;5;%dm"

if !empty($DISPLAY) && $COLORTERM !~# '^rxvt'
    " Enable true colors, see :help xterm-true-color
    if &term =~# '^\(tmux\|screen\|alacritty\)'
        let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
    endif

    " Enable underline colors (RGB), see alacritty #4660
    let &t_8u = "\<esc>[58;2;%lu;%lu;%lum"

    " Use highlight-guibg and guifg attributes in terminal
    set termguicolors
endif

"   }}}
"  }}}
"  ColorScheme {{{

try
	colorscheme flattened_dark
catch
	colorscheme default
endtry

"  }}}
"  Buffer formatting {{{

set tabstop=8
set shiftwidth=8
set noexpandtab

set nofixeol

set textwidth=80
set colorcolumn=+1

"  }}}
"  Searches {{{

set hlsearch
set smartcase

" Make search result appear in the middle of the screen
nnoremap n nzzzv
nnoremap N Nzzzv

"  }}}
"  Spell checking {{{

set spell
set spelllang=en

"  }}}
"  Backup management {{{

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

"  }}}
"  Tab page {{{

set tabpagemax=50
execute ":silent tab all"

"  }}}
"  Folding {{{

set foldmethod=marker
nnoremap <Space> za
vnoremap <Space> za

"  }}}
"  Keyword doc {{{

autocmd FileType rust set keywordprg=rustup\ doc

"  }}}
" }}}
" Plugins configuration {{{
"  LightLine {{{

set laststatus=2
set noshowmode

let g:lightline = {
	\ 'colorscheme': 'flattened_dark',
	\ 'active': {
	\ 	'left': [
	\ 		[ 'mode', 'paste' ],
	\ 		[ 'readonly', 'filename', 'modified' ]
	\ 	]
	\ },
	\ 'tabline': {
	\ 	'right': []
	\ },
	\ }

"  }}}
"  SPaceHi {{{

augroup spacehi
	autocmd!
	autocmd BufNewFile,BufRead * SpaceHi
	autocmd BufNewFile,BufRead * syntax clear spacehiTab
augroup END

"  }}}
"  ALE {{{

" Enable completion
let g:ale_completion_enabled = 1

" Enable fixers
let g:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'rust': ['rustfmt'],
	\ 'sh': ['shfmt'],
	\ }

let g:ale_fix_on_save = 1

let g:ale_fix_on_save_ignore = {
	\ 'diff': ['trim_whitespace'],
	\ }

" Configure go to definition
nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>

" Rust options
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_check_examples = 1

" Shfmt options
let g:ale_sh_shfmt_options = '-s -p'

"  }}}
" }}}
