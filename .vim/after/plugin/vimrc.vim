" [q ]q to navigate qf entries
nmap ]q <Plug>qf_qf_next
nmap ]Q <Plug>qf_qf_next
nmap [q <Plug>qf_qf_previous
nmap [Q <Plug>qf_qf_previous

" t/T in quickfix to open in a new tab
autocmd FileType qf nnoremap <silent> <buffer> t <C-W><Enter><C-W>T :doauto FileType<CR>
autocmd FileType qf nnoremap <silent> <buffer> T <C-W><Enter><C-W>T :doauto FileType<CR>
