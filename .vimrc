syntax on
set nocompatible
" Set tab character to 4 spaces
set tabstop=4
" Always show tabs
set showtabline=2
" Set << and >> to move 4 spaces (1 tab)
set shiftwidth=4
set background=dark
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
" Begin searching immediately
set incsearch
" Delete existing text with backspace
set backspace=indent,eol,start
" Hilight the search results
set hlsearch
" Don't do spell-checking by default
set nospell
" Enable mouse support
set mouse=a
" Case insensitive search by default, but switch to case sensitive when searching with uppercase
set ignorecase
set smartcase
" Case insensitive tab completion
if exists("&wildignorecase")
	set wildignorecase
endif
" Paste-mode where there is no autoindentation
set pastetoggle=<F12>
" Give 5 lines of space between the cursor and the top/bottom when scrolling
set scrolloff=5
" Persistent undo
set undofile
" Set the dir to store all the swap files
set directory=$HOME/.vim/swap,.
" And all the undo files
set undodir=$HOME/.vim/undo,.
" But then disable them anyway
set noswapfile
" Show line numbers
set number
set numberwidth=1 " But keep it narrow
" Make the line number relative
"set relativenumber
" Make spaces easier to see
set listchars=tab:.\ ,trail:.
set list
" Set up the font for gvim
set guifont=Liberation\ Mono\ 9
" Set leaderkey to be comma
let mapleader = ","
" Command-line menu for completion
set wildmenu
" Match the longest first and tab through the remaining choices
set wildmode=longest:full,full
" Suffixes that get lower priority when doing tab completion for filenames
" These are files we are not likely to want to edit or read
set suffixes=.bak,~,.swp,.swo,.swn,.swm,.o,.d,.info,.aux,.dvi,.pdf,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyd,.dll,.bin,.exe
" Wrap searching around the EOF and BOF
set wrapscan
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

" == Searching ==
" Set cwd per window/tab
let g:rooter_use_lcd = 1
" Follow symlinks
let g:rooter_resolve_links = 1
" Set cwd to file's dir for non-project files
let g:rooter_change_directory_for_non_project_files = 'current'
" Quiet
let g:rooter_silent_chdir = 1

" Set up ack
let g:ackprg="ack -H --nocolor --nogroup --column"
" Bind ,k to grep for the last searched string
nnoremap <leader>k :Grep "<C-R>/"<CR>:cw<CR>
" bind K to grep word under cursor or selected word
nnoremap K :Grep "\b<cword>\b"<CR>:cw<CR>
vnoremap K "vy:Grep "<C-R>v"<CR>:cw<CR>
" Except in tmux config, then go to tmux manpage
autocmd FileType tmux nnoremap <buffer> K :call tmux#man()<CR>
autocmd FileType tmux vnoremap <buffer> K :call tmux#man()<CR>

" ag / The Silver Searcher
if executable('ag')
	" Use ag if it exists instead of grep for :grep
	set grepprg=ag\ --nogroup\ --nocolor
	" And :Ack
	let g:ackprg = 'ag --vimgrep'
	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

" Ctrl-P
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPSmartTabs'
let g:ctrlp_custom_ignore = '\v[\/](\.git|bundle|vendor)$'
" Ctrl-P -- SmartTabs
let g:ctrlp_extensions = ['smarttabs']
let g:ctrlp_smarttabs_modify_tabline = 1
" gutentags
let g:gutentags_ctags_exclude=["vendor", "bundle", ".git"]
let g:gutentags_ctags_tagfile = ".tags"
" Prepare tagbar
let g:tagbar_autofocus=1
let g:tagbar_compact=1
"let g:tagbar_autoclose=1

" == Key mappings ==
" Paste/copy using pbcopy/pbpaste (which are mapped over ssh)
"TODO: Write a wrapper that only calls reattach-to-user-namespace if necessary
nmap <F1> :set paste<CR>:r !reattach-to-user-namespace pbpaste<CR>:set nopaste<CR>
imap <F1> <Esc>:set paste<CR>:r !reattach-to-user-namespace pbpaste<CR>:set nopaste<CR>
nmap <F2> :.w !reattach-to-user-namespace pbcopy<CR><CR>
"vmap <F2> :w !pbcopy<CR><CR>
" Make it work with the actual selection instead of always the entire line
vmap <F2> :call system('reattach-to-user-namespace pbcopy', GetSelection())<CR>:echo ""<CR>

" Switch buffers quickly
nmap <leader>l :ls<CR> :b<space>
vmap <leader>l :ls<CR> :b<space>

" r in quickfix to reload
autocmd FileType qf nnoremap <buffer> r :Copen<CR>
" R in quickfix to reload and scroll to the end
autocmd FileType qf nnoremap <buffer> R :Copen<CR>G
" q in quickfix to close
autocmd FileType qf nnoremap <buffer> q :ccl<CR>

" Remap the arrow keys to ijkl
map i <Up>
map j <Left>
map k <Down>
noremap h i
" And map them with control to navigate splits
nnoremap <C-i> <C-w>k
nnoremap <C-j> <C-w>h
nnoremap <C-k> <C-w>j
nnoremap <C-l> <C-w>l
" Also map i in netrw buffer
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> i <Up>
endfunction

" Create hotkeys to create splits
nnoremap <C-h> <C-w>s
nnoremap <C-u> <C-w>v

nnoremap <F8> :TagbarToggle<CR>

" Set Control - n to return to normal mode in insert mode and visual mode
imap <c-n> <esc>
vmap <c-n> <esc>
" And jj in insert mode
inoremap jj <ESC>

"map <leader>nt :NERDTree<cr>
map <leader>g :GundoToggle<cr>
map <leader>tn :tabnew<cr>
map <leader>w :w<cr>
map <leader>e :edit 
" ;e to reload all current buffers
map ;e :set noconfirm<cr>:bufdo e!<cr>:set confirm<cr>
map <leader>q :q<cr>
map <leader>p "+gp
map <leader>P "+gP
" yank/put to special register (to avoid the automatically handled one)
map <leader>sy "ry
map <leader>sp "rp
map <leader>sP "rP
" Copy to X clipboard with ,y
map <leader>y "+y
" ;y to yank the whole buffer to the X clipboard
map ;y :%y<space>+<cr>
" ,x to de-highlight from the search
map <leader>x :nohlsearch<cr>
map <leader>m :!mkdir -p %:h<cr>
" ;q to close all tabs and quit entirely
map ;q :quitall<cr>
" ;wq to write and quit
map ;wq :w<cr>:q<cr><cr>
" r to repeat search
map r /<CR>
" Command-line navigation
cnoremap <C-x> <Right>
cnoremap <C-z> <Left>
" Alt+Left/Right to switch tabs
nnoremap <A-Left> gT
nnoremap <A-Right> gt
" Control+Tab (+Shift, for reverse direction) to switch through tabs
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
" Control+t for new tab
nnoremap <C-t> :tabnew<CR>
" Run the current file in a perl window
map ;p :!perl "%"
" Build the current file as a PDF and open it with evince
map ;pdf :!pdf "%" && evince "`dirname '%'`/`basename '%' .tex`.pdf"<cr>
" Map w!! to sudo write
cmap w!! w !sudo tee % > /dev/null
" Make ; work like :
nnoremap ; :

" == Status line ==
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
" Temporarily disable tabline until https://github.com/itchyny/lightline.vim/issues/239 is fixed/addressed
let g:lightline = {
\ 'enable': { 'tabline': 0 },
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'filename', 'modified', 'gitbranch' ] ]
\ },
\ 'component_function': {
\   'gitbranch': 'LightlineFugitive'
\ },
\ }

" Rest of editor
colorscheme wombat

hi MatchParen cterm=none ctermbg=none ctermfg=white
set tabpagemax=40

" terminal-specific magic
let s:screen  = &term =~ 'screen'
let s:xterm   = &term =~ 'xterm'

" make use of Xterm "bracketed paste mode"
" http://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
" http://stackoverflow.com/questions/5585129
if s:screen || s:xterm
  function! s:BeginXTermPaste(ret)
    set paste
    return a:ret
  endfunction

  " enable bracketed paste mode on entering Vim
  let &t_ti .= "\e[?2004h"

  " disable bracketed paste mode on leaving Vim
  let &t_te = "\e[?2004l" . &t_te

  set pastetoggle=<Esc>[201~
  inoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("")
  nnoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("i")
  vnoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("c")
  cnoremap <Esc>[200~ <nop>
  cnoremap <Esc>[201~ <nop>
endif

call pathogen#infect()
Helptags

silent! source ~/.vimrc_local

" == Source Code ==
set autoindent
" load filetype-specific indent files
filetype indent on
" Wrap lines
set wrap

" Folding
set foldmethod=syntax
set foldlevel=1
set foldminlines=5
" Fold perl
let perl_fold = 1
let perl_fold_blocks = 1
" Don't Fold PHP
let php_fold = 0

" == Filetype-specific ==
augroup FileTypeThings
	autocmd FileType php let php_noShortTags=1

	autocmd FileType php hi MatchParen ctermbg=blue guibg=lightblue

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

	au BufNewFile,BufReadPost .z*,zsh*,zlog*	so $HOME/.vim/syntax/zsh.vim
augroup END
