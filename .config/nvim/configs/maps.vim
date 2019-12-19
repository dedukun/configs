""""""""
" Maps

" Remap 'Y' to stay the same as other commands
map Y y$

" Set map leader
let mapleader=","

" Remove all spaces at the end of lines
nnoremap <leader>cc  :%s/\s\+$//ge<CR>

" Toggle Syntastic [WIP]
nnoremap <leader>s  :call SyntasticToggle()<CR>

" vimgrep maps
nnoremap <leader>f  :noautocmd grep -s <cword> **/* --include={*.c,*.h,*.py,*.java}<CR>
nnoremap <leader>F  :call MultipleFileSearch("")<left><left>

" Build tags file
nnoremap <leader>t :!ctags -R .<CR>
nnoremap <leader>T :call GenerateTags()<CR>

" Toggle Goyo
nnoremap <leader>g :call GoyoToggle()<CR>
nnoremap <leader>G :Goyo<CR>

" clear highlights
nnoremap <leader>n :noh<CR>

" toogle number
nnoremap <leader>N :call ToggleNumber()<CR>

" File Explorer
nnoremap <leader>m :NERDTreeToggle<CR>

" Remap split windows navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Search for under under cursor in multiple files
nnoremap gr :noautocmd rep <cword> *<CR>
nnoremap Gr :noautocmd rep <cword> %:p:h/*<CR>
nnoremap gR :noautocmd rep '\b<cword>\b' *<CR>
nnoremap GR :noautocmd rep '\b<cword>\b' %:p:h/*<CR>

" Remap ^W_w to zoomwin
nnoremap <C-w>w :ZoomWinTabToggle<CR>

" neosnippet
imap <C-j>     <Plug>(neosnippet_expand_or_jump)
smap <C-j>     <Plug>(neosnippet_expand_or_jump)
xmap <C-j>     <Plug>(neosnippet_expand_target)