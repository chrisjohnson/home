" <C-R>=system('python', GetSelection())

" Cases:
" 1 visual char substring of one line
" 2 visual char substrings of several lines
" 3 visual line one line
" 4 visual line several lines
" 5 visual block one line (identical to first)
" 6 visual block several lines
function! GetSelection()
    let ltop    = line("'<")
    let lbottom = line("'>")
    let cleft   = col("'<") - 1
    let cright  = col("'>") - 1
    let v       = visualmode()

    if v == 'v'
        if ltop == lbottom " case 1
            return getline(ltop)[cleft : cright]
        elseif ltop != lbottom " case 2
            let selection =  [ getline(ltop)[cleft : -1] ]
            let selection +=   getline(ltop + 1, lbottom - 1)
            let selection += [ getline(lbottom)[ 0 : cright] ]
            return join(selection, "\n")
        endif
    elseif v == 'V'
        if ltop == lbottom " case 3
            return getline(ltop)
        elseif ltop != lbottom " case 4
            return join(getline(ltop, lbottom), "\n")
        endif
    elseif v == "\<C-V>"
        if ltop == lbottom " case 5
            return getline(ltop)[cleft : cright]
        elseif ltop != lbottom " case 6
            let selection = getline(ltop, lbottom)
            call map(selection, 'v:val[cleft : cright]')
            return join(selection, "\n")
        endif
    endif
endfunction
