syntax on
set tabstop=4
set autoindent
set showcmd
set incsearch
set hlsearch
set nospell
set nofoldenable
set mouse=a
set background=dark
set pastetoggle=<F12>
" Set the dir to store all the swap files
set directory=$HOME/.vim/swap,.
" Show line numbers
set number
" Always show tabs
set showtabline=2
" Set << and >> to move 4 spaces (1 tab)
set shiftwidth=4

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
map <leader>y "+y
map <leader>x :nohlsearch<cr>
map <leader>a :VCSAdd<cr>
map <c-enter> <leader>cc<cr>
map ;c <leader>cc<leader>cc
map ;l viwuW
map ;u viwUW
map ;y :%y<space>+<cr>
map ;q :quitall<cr>
map ;wq :w<cr>:q<cr><cr>
" Run the current file in a perl window
map ;p :!perl "%"
" Build the current file as a PDF and open it with evince
map ;pdf :!pdf "%" && evince "`dirname '%'`/`basename '%' .tex`.pdf"<cr>

set statusline=%F%m%r%h%w\ [Format:\ %{&ff}]\ [Type:\ %Y]\ [Position:\ (%4l,\ %3v)\ %p%%]\ [Lines:\ %L]\ [Git\ branch:\ %{GitBranchInfoTokens()[0]}]
set laststatus=2

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
