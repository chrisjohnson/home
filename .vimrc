" vim: fdm=marker foldminlines=1
let g:afterstart_callbacks = []

" == Editor Preferences == {{{
" nocompatible (no-op in most cases)
set nocompatible
" Disable backup files
set nobackup
" Set up a huge history and undo cache
set history=1000
set undolevels=1000
" Show the changed line count for commands
set report=0
" Show the command as you type it
set showcmd
" Confirm closing unsaved files
set confirm
" Don't do spell-checking by default
set nospell
" Persistent undo
set undofile
" Set the dir to store all the swap files
set directory=$HOME/.vim/swap
" And all the undo files
set undodir=$HOME/.vim/undo
" But then disable them anyway
set noswapfile
" Case insensitive tab completion
set wildignorecase
" Command-line menu for completion
set wildmenu
" Match the longest first and tab through the remaining choices
set wildmode=longest:full,full
" Suffixes that get lower priority when doing tab completion for filenames
" These are files we are not likely to want to edit or read
set suffixes=.bak,~,.swp,.swo,.swn,.swm,.o,.d,.info,.aux,.dvi,.pdf,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyd,.dll,.bin,.exe
" Enable filetype-specific plugins and indentations
filetype on
filetype plugin on
filetype indent on
" Set cwd per window/tab
let g:rooter_use_lcd = 1
" Follow symlinks
let g:rooter_resolve_links = 1
" Set cwd to file's dir for non-project files
let g:rooter_change_directory_for_non_project_files = 'current'
" Quiet
let g:rooter_silent_chdir = 1

" In vim 8, this is effectively a no-op. In vim < 8, this will shim vim 8 package paths into rtp
runtime pack/plugins/start/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags
" }}}

" == Keyboard Preferences == {{{
" Delete existing text with backspace, including up to the previous line
set backspace=indent,eol,start
" Set leaderkey to be comma
let mapleader = ","
" Make ; work like :
nnoremap ; :
" Paste-mode where there is no autoindentation
set pastetoggle=<F12>

" Remap the arrow keys to ijkl
map <nowait> i <Up>
map <nowait> j <Left>
map <nowait> k <Down>
noremap <nowait> h i
vnoremap <nowait> h i
" And map them with control to navigate splits
nnoremap <C-i> <C-w>k
nnoremap <C-j> <C-w>h
nnoremap <C-k> <C-w>j
nnoremap <C-l> <C-w>l
" Also map i in netrw buffer
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw noremap <buffer> i <Up>
augroup END
" Disable ruby mappings from vim-ruby since they conflict with my i mapping
let g:no_ruby_maps = 1
" Disable gitgutter mappings for ic since they conflict with my i mapping
omap XX <Plug>GitGutterTextObjectInnerPending
xmap XX <Plug>GitGutterTextObjectInnerVisual

" Set Control - n to return to normal mode in insert mode and visual mode
"TODO: Temporarily disabled to maybe learn how to use omnifunc properly?
"imap <c-n> <esc>
vmap <c-n> <esc>
" And jj in insert mode
inoremap jj <ESC>
" }}}

" == Key mappings == {{{
" Gundo
map <leader>g :GundoToggle<cr>
" surround.vim
map <leader>s yshw
" ,w to write
map <leader>w :w<cr>
" ,e to edit
map <leader>e :edit 
" ;e to reload all current buffers
map ;e :set noconfirm<cr>:bufdo e!<cr>:set confirm<cr>
map <leader>q :q<cr>
" ,m to create dirs necessary for the current file
map <leader>m :!mkdir -p %:h<cr>
" ;q to close all tabs and quit entirely
map ;q :quitall<cr>
" ;wq to write and quit
map ;wq :w<cr>:q<cr><cr>
" Map w!! to sudo write
cmap w!! w !sudo tee % > /dev/null
" }}}

" == Code Formatting == {{{
" Set tab character to 4 spaces
set tabstop=4
" Always show tabs
set showtabline=2
" Set << and >> to move 4 spaces (1 tab)
set shiftwidth=4
" Enable auto indent
set autoindent
" Wrap lines
set wrap

" Folding
set foldmethod=syntax
set foldlevel=1
set foldminlines=3
set foldcolumn=1
" Stolen from anyfold
set foldtext=MinimalFoldText()
function! MinimalFoldText() abort
	let fs = v:foldstart
	while getline(fs) !~ '\w'
		let fs = nextnonblank(fs + 1)
	endwhile
	if fs > v:foldend
		let line = getline(v:foldstart)
	else
		let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
	endif

	let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
	let foldSize = 1 + v:foldend - v:foldstart
	let foldSizeStr = " " . foldSize . " lines "
	let foldLevelStr = repeat("  +  ", v:foldlevel)
	let lineCount = line("$")
	let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr))
	return line . expansionString . foldSizeStr . foldLevelStr
endfunction
" Space to toggle folds
nnoremap <Space> za
" <leader>Space to focus on current fold
nnoremap <leader><Space> zMzv:set foldminlines=1<cr>
" }}}

" == Search == {{{
" Hilight the search results
set hlsearch
" Begin searching immediately
set incsearch
" Case insensitive search by default, but switch to case sensitive when searching with uppercase
set ignorecase
set smartcase
" Wrap searching around the EOF and BOF
set wrapscan
" Ignore various tmp and cruft files when searching
set wildignore+=*/.git/*,*/tmp/*,*.swp
" r to repeat search
map r /<CR>
" ,x to de-highlight from the search
map <leader>x :nohlsearch<cr>

" Bind ,k to grep for the last searched string
nnoremap <leader>k :Grep "<C-R>/"<CR>:cw<CR>
" bind K to grep word under cursor or selected word
nnoremap K :Grep "\b<cword>\b"<CR>:cw<CR>
vnoremap K "vy:Grep "<C-R>v"<CR>:cw<CR>
" Except in tmux config, then go to tmux manpage
autocmd FileType tmux nnoremap <buffer> K :call tmux#man()<CR>
autocmd FileType tmux vnoremap <buffer> K :call tmux#man()<CR>

" rg / ripgrep
if executable('rg')
	" Use rg if it exists instead of grep for :grep
	set grepprg=rg\ --no-heading\ --color=never

" ag / The Silver Searcher
elseif executable('ag')
	" Use ag if it exists instead of grep for :grep
	set grepprg=ag\ --nogroup\ --nocolor
endif

" gutentags
let g:gutentags_ctags_exclude=["vendor", "bundle", ".git"]
let g:gutentags_ctags_tagfile = ".tags"
" Tagbar
let g:tagbar_autofocus=1
let g:tagbar_compact=1
"let g:tagbar_autoclose=1
nnoremap <F8> :TagbarToggle<CR>

" FZF
"let g:fzf_nvim_statusline = 0 " disable statusline overwriting

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>a :Windows<CR>
nnoremap <c-p> :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
imap <C-x><C-f> <plug>(fzf-complete-file)
imap <C-x><C-l> <plug>(fzf-complete-line)
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" }}}

" == Colors / UI == {{{
set background=dark
" Enable mouse support
set mouse=a
" Give 5 lines of space between the cursor and the top/bottom when scrolling
set scrolloff=5
" Show line numbers
set number
set numberwidth=1 " But keep it narrow
" Make the line number relative
"set relativenumber
" Make spaces easier to see
set listchars=tab:.\ ,trail:.
set list
" Enable syntax highlighting
syntax on
" New windows to below or right
set splitbelow
set splitright
" Highlight the current line (but only in gvim, it looks terrible in normal vim)
if has('gui_running')
	set cursorline
	set lines=40
	set columns=120
endif
" Hide the toolbar in gvim
set guioptions-=T
" Vertical diffing
set diffopt+=vertical
" Colorscheme
colorscheme wombat
" Highlight coloring
hi MatchParen cterm=none ctermbg=none ctermfg=white
" Highlight lines that are too long
highlight OverLength ctermbg=1 ctermfg=white
highlight MatchParen ctermbg=blue ctermfg=white
" Max 40 tabs
set tabpagemax=40
" }}}

" == Quickfix == {{{
" r in quickfix to reload
autocmd FileType qf nnoremap <buffer> r :Copen<CR>
" R in quickfix to reload and scroll to the end
autocmd FileType qf nnoremap <buffer> R :Copen<CR>G
" q in quickfix to close
autocmd FileType qf nnoremap <buffer> q :ccl<CR>
" and for help
autocmd FileType help nnoremap <buffer> q :q<CR>
" vim-qf
let g:qf_mapping_ack_style = 1
nmap Q <Plug>qf_qf_toggle
nmap qf <Plug>qf_qf_switch

function AfterQuickfix()
	" [q ]q to navigate qf entries
	nmap ]q <Plug>qf_qf_next
	nmap ]Q <Plug>qf_qf_next
	nmap [q <Plug>qf_qf_previous
	nmap [Q <Plug>qf_qf_previous
	" t/T in quickfix to open in a new tab
	augroup QuickFixAuCommands
		autocmd FileType qf nnoremap <silent> <buffer> t <C-W><Enter><C-W>T :doauto FileType<CR>
		autocmd FileType qf nnoremap <silent> <buffer> T <C-W><Enter><C-W>T :doauto FileType<CR>
	augroup END
endfunction
" Register to run after plugins
call add(g:afterstart_callbacks, function('AfterQuickfix'))
" }}}

" == Copy / Paste == {{{
" pbcopy/pbpaste
"TODO: Write a wrapper that only calls reattach-to-user-namespace if necessary (or include a no-op reattach-to-user-namespace wrapper)
"TODO: Write a check/wrapper for clipper
nmap <F1> :set paste<CR>:r !reattach-to-user-namespace pbpaste<CR>:set nopaste<CR>
imap <F1> <Esc>:set paste<CR>:r !reattach-to-user-namespace pbpaste<CR>:set nopaste<CR>
nmap <F2> :.w !reattach-to-user-namespace pbcopy<CR><CR>
"vmap <F2> :w !pbcopy<CR><CR>
" Make it work with the actual selection instead of always the entire line
vmap <F2> :call system('reattach-to-user-namespace pbcopy', GetSelection())<CR>:echo ""<CR>

" yank/put to special register (to avoid the automatically handled one)
map <leader>sy "ry
map <leader>sp "rp
map <leader>sP "rP
" ,y Copy host clipboard with
map <leader>y "+y
" ;y to yank the whole buffer to the X clipboard
map ;y :%y<space>+<cr>
" ,p ,P Paste from host clipboard
map <leader>p "+gp
map <leader>P "+gP
" }}}

" == Window Management == {{{
" Create hotkeys to create splits
nnoremap <C-h> <C-w>s
nnoremap <C-u> <C-w>v
" Open new tab
map <leader>tn :tabnew<cr>
" Control+t for new tab
nnoremap <C-t> :tabnew<CR>
" }}}

" == Status line == {{{
" Hide mode status since lightline includes it
set noshowmode
" Always show it
set laststatus=2
" lightline
function! LightlineFugitive()
	if exists('*fugitive#head') && fugitive#extract_git_dir(expand('%')) !=# ''
		silent! let branch = fugitive#head()
		return branch !=# '' ? branch : ''
	endif
	return ''
endfunction
function! LightlineTag()
	silent! let currenttag = tagbar#currenttag('%s','')
	return currenttag !=# '' ? currenttag : ''
endfunction
function! LightlineGutentags()
	silent! let tagstatus = gutentags#statusline()
	return tagstatus !=# '' ? 'Generating Tags' : ''
endfunction
function! LightlineMode()
  return expand('%:t') ==# '__Tagbar__' ? 'Tagbar':
        \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'component_function': {
\   'gitbranch': 'LightlineFugitive',
\   'tag': 'LightlineTag',
\   'gutentags': 'LightlineGutentags',
\   'mode': 'LightlineMode',
\ },
\ 'active': {
\   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'modified', 'gitbranch', 'filename', 'tag', 'gutentags' ] ],
\   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'inactive': {
\   'left': [ [ 'filename' ] ],
\   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
\ },
\ 'tabline': {
\   'left': [ [ 'tabs' ] ],
\   'right': []
\ },
\ 'tab': {
\   'active': [ 'tabnum', 'filename', 'modified' ],
\   'inactive': [ 'tabnum', 'filename', 'modified' ]
\ },
\ }
" }}}

" == Git == {{{
let g:github_enterprise_urls = ['https://git.innova-partners.com']
" }}}

" == Filetype-specific == {{{
let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
\ 'p':  "<pre> \r </pre>",
\ 'w':  "%w(\r)",
\ }
let g:surround_custom_mapping.help = {
\ 'p':  "> \r <",
\ }
let g:surround_custom_mapping.ruby = {
\ '-':  "<% \r %>",
\ '=':  "<%= \r %>",
\ '9':  "(\r)",
\ '5':  "%(\r)",
\ '%':  "%(\r)",
\ 'w':  "%w(\r)",
\ '#':  "#{\r}",
\ '3':  "#{\r}",
\ 'e':  "begin \r end",
\ 'E':  "<<EOS \r EOS",
\ 'i':  "if \1if\1 \r end",
\ 'u':  "unless \1unless\1 \r end",
\ 'c':  "class \1class\1 \r end",
\ 'm':  "module \1module\1 \r end",
\ 'd':  "def \1def\1\2args\r..*\r(&)\2 \r end",
\ 'p':  "\1method\1 do \2args\r..*\r|&| \2\r end",
\ 'P':  "\1method\1 {\2args\r..*\r|&|\2 \r }",
\ }
let g:surround_custom_mapping.javascript = {
\ 'f':  "function(){ \r }"
\ }

augroup FileTypeThings
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType ruby set omnifunc=rubycomplete#Complete
	autocmd FileType c set omnifunc=ccomplete#Complete

	" Use spaces instead of tabs for ruby/python
	au BufRead,BufNewFile *.py,*pyw set shiftwidth=4 softtabstop=4 expandtab
	au Filetype ruby set shiftwidth=2 softtabstop=2 expandtab
	" Use vrspec as the compiler for ruby (custom shell script ssh dispatcher for vagrant ssh bundle exec rspec)
	au Filetype ruby compiler rspec
	au Filetype ruby set makeprg=vrspec
	" Enable long-line highlighting
	au Filetype ruby match OverLength /\%101v.*/

	au BufNewFile,BufReadPost .z*,zsh*,zlog*	so $HOME/.vim/syntax/zsh.vim
augroup END
" }}}

" == Local vimrc == {{{
silent! source ~/.vimrc_local
function AfterLocalVimrc()
	silent! source ~/.vimrc_after_local
endfunction
" Register to run after plugins
call add(g:afterstart_callbacks, function('AfterQuickfix'))
" }}}
