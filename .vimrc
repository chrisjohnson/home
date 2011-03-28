syntax on
set nocompatible
set tabstop=4
set background=dark
set nobackup
set autoindent
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
" Hilight the search results
set hlsearch
" Don't do spell-checking by default
set nospell
" Enable mouse support
set mouse=a
" Case insensitive search by default, but switch to case sensitive when searching with uppercase
set ignorecase
set smartcase
" Paste-mode where there is no autoindentation
set pastetoggle=<F12>
" Give 5 lines of space between the cursor and the top/bottom when scrolling
set scrolloff=5
" Set the dir to store all the swap files
set directory=$HOME/.vim/swap,.
" But then disable them anyway
set noswapfile
" Show line numbers
set number
set numberwidth=1 " But keep it narrow
" Always show tabs
set showtabline=2
" Set << and >> to move 4 spaces (1 tab)
set shiftwidth=4
" Make spaces easier to see
set listchars=tab:.\ ,trail:.
set list
" Set up the font for gvim
set guifont=Liberation\ Mono\ 9
" Set the statusline
set statusline=%F%m%r%h%w\ [Format:\ %{&ff}]\ [Type:\ %Y]\ [Position:\ (%4l,\ %3v)\ %p%%]\ [Lines:\ %L]%=[Git\ branch:\ %{GitBranchInfoTokens()[0]}]
" Always show it
set laststatus=2
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
" Set up ack
let g:ackprg="ack -H --nocolor --nogroup --column"
" Folding
set foldmethod=syntax
set foldlevel=1
set foldminlines=5
" Fold perl
let perl_fold = 1
let perl_fold_blocks = 1
" Don't Fold PHP
let php_fold = 0

" Remap the arrow keys to ijkl
map i <Up>
map j <Left>
map k <Down>
noremap h i

" Hotkeys
" Set Control - n to return to normal mode in insert mode and visual mode
imap <c-n> <esc>
vmap <c-n> <esc>

let mapleader = ","
map <leader>tn :tabnew<cr>
map <leader>u :VCSUpdate<cr>
map <leader>w :w<cr>
map <leader>e :edit 
map <leader>q :q<cr>
map <leader>p "+gp
map <leader>P "+gP
" yank/put to special register (to avoid the automatically handled one)
map <leader>sy "ry
map <leader>sp "rp
map <leader>sP "rP
" Copy to X clipboard with ,y
map <leader>y "+y
" ,x to de-highlight from the search
map <leader>x :nohlsearch<cr>
" ,a to add the current file to version control
map <leader>a :VCSAdd<cr>
" Control+Enter to commit
map <C-Enter> <leader>cc<cr>
" ;c to commit without a commit log
map ;c <leader>cc<leader>cc
map ;l viwuW
map ;u viwUW
" ;y to yank the whole buffer to the X clipboard
map ;y :%y<space>+<cr>
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
" Sync the current working copy to sandbox
map ;s :!swc sync<cr>
" Restart the sandbox server
map ;r :!$HOME/bin/manta-restart<cr>
" Build the current file as a PDF and open it with evince
map ;pdf :!pdf "%" && evince "`dirname '%'`/`basename '%' .tex`.pdf"<cr>
" Map w!! to sudo write
cmap w!! w !sudo tee % > /dev/null

colorscheme wombat

autocmd FileType php let php_noShortTags=1

autocmd FileType php hi MatchParen ctermbg=blue guibg=lightblue

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

hi MatchParen cterm=none ctermbg=none ctermfg=white

au BufNewFile,BufReadPost .z*,zsh*,zlog*	so $VIM/vim72/syntax/zsh.vim
