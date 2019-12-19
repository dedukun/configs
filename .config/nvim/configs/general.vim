""""""""""""""""""""
" General Settings

filetype plugin indent on
syntax enable                    "enable syntax highlighting

set nocompatible                 "less vi compatibility
set termguicolors                "number of colors
set tabstop=4                    "tabs are 4 spaces
set shiftwidth=4                 "spaces used in auto indenting
set expandtab                    "replace tabs with spaces
set mouse=a                      "enable mouse
set tw=0                         "maximum width of text that is being inserted
set cursorline                   "set a line where the cursor is
set showcmd                      "show commands in the lower right corner
set number                       "set number of the lines in the side
set hlsearch                     "highlight all search matches
set ignorecase                   "searches are case insensitive
set smartcase                    "search will be case sensitive if it contains an uppercase letter
set backspace=2                  "make backspace work in insert mode
set splitbelow splitright        "make splits open at the bottom and right
set bg=dark
if has('unnamedplus')            "use special register '*' or '+' for all
    set clipboard=unnamedplus    "yank, delete, ...
else
    set clipboard=unnamed
endif
set encoding=utf-8               "add support for utf-8 encoding
set noundofile                   "don't create .un~ file for persistent undo
set wildmode=longest,list,full   "do a partial complete first
set wildmenu                     "command-line completion in enhanced mode
set spelllang=en                 "languages for spell checker
set complete=.,w,b,u,t,i,kspell  "complete options

if has('nvim')
    let g:python3_host_prog = '/usr/local/bin/python3.6'
endif

" Change the directory where temporary files are stored
set backupdir=~/.vim/.backup//
set directory=~/.vim/.backup//

" Tags files default locations
set tags=./tags,./TAGS,tags,TAGS,../tags,../TAGS

" Change cursor shape depending of the mode
if has('nvim')
    " only needed in nvim 0.1.7 or before
    if !has('nvim-0.1.7')
        let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    endif
else
    let &t_SI = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[2 q"
    let &t_SR = "\<Esc>[4 q"
endif

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Enale maximum text width for tex files
autocmd FileType tex set tw=200

" Enable spell check by default in specific files
autocmd FileType tex set spell
autocmd FileType markdown set spell

" Delete bash 'edit-and-execute-command' (C-xC-e, or, if vi-mode enabled, <Esc>v) temporary file when opening it
"
" Case: When using bash 'edit-and-execute-command', if you open the mode with nothing on the command-line,
" and after writing something you quit without saving, the temporary script will not run, as the file doesn't
" exists in the system. However, when starting this mode with something already in the command-line, the
" temporary script file will be created an saved in the system automatically, so even if you leave the mode
" without saving it, the command that was originally in the command-line will still run.
" Result: The autocmd's bellow deletes the temporary file when vim starts reading it to the buffer, so the script needs
" to be saved before it is executed.
augroup del_bash_tmp_script
    autocmd FileChangedShell /tmp/bash-fc.* execute
    autocmd BufRead /tmp/bash-fc.* !rm %
augroup end

"set color scheme
try
    colorscheme gruvbox8
catch /^Vim\%((\a\+)\)\=:E185/
    " do nothing
endtry