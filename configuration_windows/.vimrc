" Modeline and Notes {
  " Based on spf13 and leoatchina-vim
" }

" Environment {

" Identify platform {
    silent function! OSX()
    return has('macunix')
            endfunction
            silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
        return  (has('win32') || has('win64'))
    endfunction
" }

" Basics {
    set nocompatible        " Must be first line
    "if !WINDOWS()
        "set shell=/bin/sh
    "endif
" }

" Windows Compatible {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if WINDOWS()
        set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
        " Python setup {
        " especially useful for portable version of vim
        let driver_path = strpart(expand('%:p'),0,1)
        "let $PATH =driver_path.':\Programs\Python37;'.$PATH
        "let $PYTHONHOME =driver_path.':\Programs\Python37'
        "let $PYTHON3_HOST_PROG =driver_path.':\Programs\Python37\python.exe'
        let $PATH ='D:\Programs\Python37;'.$PATH
        let $PYTHONHOME ='D:\Programs\Python37'
        let $PYTHON3_HOST_PROG ='D:\Programs\Python37\python.exe'
        if !empty($PYTHON_HOST_PROG)
            let g:python_host_prog  = $PYTHON_HOST_PROG
        endif
        if !empty($PYTHON3_HOST_PROG)
            let g:python3_host_prog = $PYTHON3_HOST_PROG
        endif
        let g:python_version = 3
        "}
    endif
" }



" Arrow Key Fix {
    " https://github.com/spf13/spf13-vim/issues/780
    " if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
        " inoremap <silent> <C-[>OC <RIGHT>
    " endif
" }

" HasDirectory define {
    let $PLUG_PATH = '$VIM/vimfiles/plugged'
    function! HasDirectory(dir)
        return isdirectory(expand("$PLUG_PATH/".a:dir))
    endfunction
" }

" Use before config if available {
    " if filereadable(expand("$VIM/.vimrc.before"))
        " source $VIM/.vimrc.before
    " endif
" }

" Use plug config {
    if filereadable(expand("$VIM/.vimrc.plug"))
        source $VIM/.vimrc.plug
    endif
" }

" General {
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
        nnoremap <leader>yy "+yy
        vnoremap <Leader>y "+y
        nmap     <Leader>p "+p
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=3000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator
    set nojoinspaces                " Prevents inserting two Spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        " autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        autocmd BufEnter * silent! lcd %:p:h " Always switch to the current file directory
    endif
    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction
        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif
    " Setting up the directories {
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif

    " To disable views add the following to your .vimrc.before.local file:
    "   let g:spf13_no_views = 1
    if !exists('g:spf13_no_views')
        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
                    \ '\[example pattern\]'
                    \ ]
    endif
    " }
" }

" Vim UI {
    set background=dark                            " Assume a dark background
    set backspace=indent,eol,start                 " Backspace for dummies
    set linespace=0                                " No extra spaces between rows
    set ruler                                      " show current col and row number in the corner
    set relativenumber
    set number                                     " Line numbers on
    set showmatch                                  " Show matching brackets/parenthesis
    set incsearch                                  " Find as you type search
    set hlsearch                                   " Highlight search terms
    set winminheight=0                             " Windows can be 0 line high
    set ignorecase                                 " Case insensitive search
    set smartcase                                  " Case sensitive when uc present
    set wildmenu                                   " Show list instead of just completing
    set wildmode=list:longest,full                 " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]                  " Backspace and cursor keys wrap too
    set scrolljump=5                               " Lines to scroll when cursor leaves screen
    set scrolloff=3                                " Minimum lines to keep above and below cursor
    set foldenable                                 " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
 " }

" Formatting {
    set wrap                                       " Do wrap long lines
    set formatoptions=want
    set autoindent                                 " Indent at the same level of the previous line
    set shiftwidth=2                               " Use indents of 4 spaces
    set expandtab                                  " Tabs are spaces, not tabs
    set tabstop=2                                  " An indentation every four columns
    set softtabstop=2                              " Let backspace delete indent
    set nojoinspaces                               " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                                 " Puts new vsplit windows to the right of the current
    set splitbelow                                 " Puts new split windows to the bottom of the current
    set showmode                                   " Display the current mode
    set cursorline                                 " Highlight current line
    set textwidth=80
    set wrapmargin=2
    set tabpagemax=15               " Only show 15 tabs
    " set matchpairs+=<:>             " Match, to be used with %
    " set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    " highlight clear SignColumn      " SignColumn should match background
    " highlight clear LineNr          " Current line number row will have same background color in relative mode
    " highlight clear CursorLineNr    " Remove highlight color from current line number
" }


" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T  "remove toolbar
        set guioptions-=m  "remove menu bar
        set guioptions-=r  "remove right-hand scroll bar
        set guioptions-=L  "remove left-hand scroll bar
        set lines=60 columns=90
        winpos 0 0
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
                set guifontwide=NSimSun\ 12
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
                set guifontwide=NSimSun\ 12
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h11,Menlo:h11,Consolas:h11,Courier_New:h11
                set guifontwide=NSimSun:h11
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif
" }

" Functions {
    " Initialize directories {
    function! InitializeDirectories()
        let parent = $VIM
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $VIM . '/.vimfiles/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }
" }

" User defined vimrc {
    if filereadable(expand("$VIM/.usr_vimrc"))
        source $VIM/.usr_vimrc
    endif
" Complete options {
    if filereadable(expand("$VIM/.vimrc.compl"))
        source $VIM/.vimrc.compl
    endif
" }
