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
    " On Windows, also use '.vim' instead of '.vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if WINDOWS()
        set runtimepath=$HOME/.vimfiles,$VIMRUNTIME,$VIM/.vimfiles/after
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
    let $PLUG_PATH = '$HOME/.vimfiles/plugged'
    function! HasDirectory(dir)
        return isdirectory(expand("$PLUG_PATH/".a:dir))
    endfunction
" }

" Use before config if available {
if filereadable(expand("$HOME/.vimrc.before"))
    source $HOME/.vimrc.before
endif
" }

" Use plug config {
if filereadable(expand("$HOME/.vimrc.plug"))
    source $HOME/.vimrc.plug
endif
" }

" General {
    set background=dark         " Assume a dark background
    " if !has('gui')
    "set term=$TERM          " Make arrow and other keys work
    " endif
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
    
" Most prefer to automatically switch to the current file directory when
" a new buffer is opened; to prevent this behavior, add the following to
" your .vimrc.before.local file:
"   let g:spf13_no_autochdir = 1
if !exists('g:spf13_no_autochdir')
    " autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    autocmd BufEnter * silent! lcd %:p:h " Always switch to the current file directory
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
    if !exists('g:override_spf13_plug') && filereadable(expand("$HOME/.vimfiles/plugged/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        color solarized             " Load a colorscheme
    endif
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number
    " statusline
    if has('statusline')
        if HasDirectory("lightline.vim")
            function! LightlineReadonly()
                return &readonly && &filetype !=# 'help' ? 'RO' : ''
            endfunction
            let g:lightline = {
                        \ 'component': {
                        \   'filefullpath': '%F',
                        \   'lineinfo': '%l/%L : %c'
                        \ },
                        \ 'component_function': {
                        \   'gitbranch': 'fugitive#head',
                        \   'readonly': 'LightlineReadonly'
                        \ },
                        \ }
            if HasDirectory('tagbar')
                let g:lightline.component.tagbar = '%{tagbar#currenttag("%s", "", "f")}'
                let g:lightline.active = {
                            \ 'left': [
                            \     ['mode', 'paste'],
                            \     ['gitbranch', 'readonly'],
                            \     ['filefullpath', 'modified'],
                            \     ['tagbar'],
                            \ ]
                            \ }
            else
                let g:lightline.active = {
                            \ 'left': [
                            \     ['mode', 'paste'],
                            \     ['gitbranch', 'readonly'],
                            \     ['filefullpath', 'modified']
                            \ ]
                            \ }
            endif
            if g:syntax_tool == 'coc' && HasDirectory("coc.nvim")
                let g:lightline.component_function.cocstatus = 'coc#status'
                let g:lightline.active.right = [
                            \ ['percent'],
                            \ ['cocstatus', 'filetype', 'fileformat', 'fileencoding', 'lineinfo']
                            \ ]
            elseif HasDirectory("lightline-neomake") && HasDirectory('neomake')
                let g:lightline.component_expand =  {
                            \ 'linter_infos': 'lightline#neomake#infos',
                            \ 'linter_errors': 'lightline#neomake#errors',
                            \ 'linter_warnings': 'lightline#neomake#warnings',
                            \ 'linter_ok': 'lightline#neomake#ok'
                            \ }
                let g:lightline.component_type = {
                            \ 'linter_infos': 'right',
                            \ 'linter_errors': 'error',
                            \ 'linter_warnings': 'warning',
                            \ 'linter_ok': 'left'
                            \ }
                let g:lightline.active.right = [
                            \ ['percent'],
                            \ ['filetype', 'fileformat', 'fileencoding', 'lineinfo'],
                            \ ['linter_infos', 'linter_errors', 'linter_warnings', 'linter_ok']
                            \ ]
            elseif HasDirectory("lightline-ale") && HasDirectory('ale')
                let g:lightline.component_expand =  {
                            \ 'linter_checking': 'lightline#ale#checking',
                            \ 'linter_errors': 'lightline#ale#errors',
                            \ 'linter_warnings': 'lightline#ale#warnings',
                            \ 'linter_ok': 'lightline#ale#ok'
                            \ }
                let g:lightline.component_type = {
                            \ 'linter_checking': 'right',
                            \ 'linter_errors': 'error',
                            \ 'linter_warnings': 'warning',
                            \ 'linter_ok': 'left'
                            \ }
                let g:lightline.active.right = [
                            \ ['percent'],
                            \ ['filetype', 'fileformat', 'fileencoding', 'lineinfo'],
                            \ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok']
                            \ ]
            else
                let g:lightline.active.right = [
                            \ ['percent'],
                            \ ['filetype', 'fileformat', 'fileencoding', 'lineinfo']
                            \ ]
            endif
        else
            set statusline=%1*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
            set statusline+=%2*\ %F\ %*
            set statusline+=%3*\ \ %m%r%y\ %*
            set statusline+=%=%4*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\ \|\"}\ %-14.(%l\/%L\ %c%)%*
            set statusline+=%5*\ %P\ %<
            hi User1 cterm=bold ctermfg=232 ctermbg=179
            hi User2 cterm=bold ctermfg=255 ctermbg=100
            hi User3 cterm=None ctermfg=208 ctermbg=238
            hi User4 cterm=None ctermfg=246 ctermbg=237
            hi User5 cterm=None ctermfg=250 ctermbg=238
        endif
    endif
    " if has('statusline')
    " set laststatus=2
    
    " " Broken down into easily includeable segments
    " set statusline=%<%f\                     " Filename
    " set statusline+=%w%h%m%r                 " Options
    " if !exists('g:override_spf13_plug')
    " set statusline+=%{fugitive#statusline()} " Git Hotness
    " endif
    " set statusline+=\ [%{&ff}/%Y]            " Filetype
    " set statusline+=\ [%{getcwd()}]          " Current dir
    " set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    " endif
    
    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_keep_trailing_whitespace = 1
" }

" Key (re)Mappings {
    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    if !exists('g:spf13_leader')
        let mapleader = ';'
    else
        let mapleader=g:spf13_leader
    endif
    if !exists('g:spf13_localleader')
        let maplocalleader = '\'
    else
        let maplocalleader=g:spf13_localleader
    endif
    
    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif
    
    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk
    

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Easier horizontal scrolling
map zl zL
map zh zH

" Easier formatting
nnoremap <silent> <leader>q gwip

" Plugins {

" " TextObj Sentence {
    " if HasModule('writing')
        " augroup textobj_sentence
            " autocmd!
            " autocmd FileType markdown call textobj#sentence#init()
            " autocmd FileType textile call textobj#sentence#init()
            " autocmd FileType text call textobj#sentence#init()
        " augroup END
    " endif
" " }

" " TextObj Quote {
    " if HasModule('writing')
        " augroup textobj_quote
            " autocmd!
            " autocmd FileType markdown call textobj#quote#init()
            " autocmd FileType textile call textobj#quote#init()
            " autocmd FileType text call textobj#quote#init({'educate': 0})
        " augroup END
    " endif
" " }

" Misc {
if isdirectory(expand("$HOME/.vimfiles/plugged/nerdtree"))
    let g:NERDShutUp=1
endif
if isdirectory(expand("$HOME/.vimfiles/plugged/matchit.zip"))
    let b:match_ignorecase = 1
endif
" }

" vimiwiki {
let g:vimwiki_list = [{'path': $HOME.'/SupportFiles/vimwiki/',
            \ 'syntax': 'markdown',
            \ 'ext': '.md'}]
" }

" EasyAlign {
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }


" NerdCommenter {
let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }
" Add one space after the delimiter
let g:NERDSpaceDelims=1
" }

" NerdTree {
if isdirectory(expand("$HOME/.vimfiles/plugged/nerdtree"))
    map <C-e> <plug>NERDTreeTabsToggle<CR>
    map <leader>e :NERDTreeFind<CR>
    nmap <leader>nt :NERDTreeFind<CR>
    let g:NERDShutUp                            = 1
    let s:has_nerdtree                          = 1
    let g:nerdtree_tabs_open_on_gui_startup     = 0
    let g:nerdtree_tabs_open_on_console_startup = 0
    let g:nerdtree_tabs_smart_startup_focus     = 2
    let g:nerdtree_tabs_focus_on_files          = 1
    let g:NERDTreeWinSize                       = 30
    let g:NERDTreeShowBookmarks                 = 1
    let g:nerdtree_tabs_smart_startup_focus     = 0
    let g:NERDTreeChDirMode                     = 1
    let g:NERDTreeQuitOnOpen                    = 1
    let g:NERDTreeMouseMode                     = 2
    let g:NERDTreeShowHidden                    = 1
    let g:NERDTreeKeepTreeInNewTab              = 1
    let g:nerdtree_tabs_focus_on_files          = 1
    let g:nerdtree_tabs_open_on_gui_startup     = 0
    let g:NERDTreeDirArrowExpandable            = '▸'
    let g:NERDTreeDirArrowCollapsible           = '▾'
    let g:NERDTreeIgnore                        = ['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
endif

if isdirectory(expand("$HOME/.vimfiles/plugged/nerdtree-git-plugin"))
    let g:NERDTreeIndicatorMapCustom = {
                \ "Modified"  : "*",
                \ "Staged"    : "+",
                \ "Untracked" : "★",
                \ "Renamed"   : "→ ",
                \ "Unmerged"  : "=",
                \ "Deleted"   : "X",
                \ "Dirty"     : "●",
                \ "Clean"     : "√",
                \ "Unknown"   : "?"
                \ }
endif
" }

" Startify {
if isdirectory(expand("$HOME/.vimfiles/plugged/vim-startify"))
    let g:startify_session_dir = expand("$HOME/supportfilese/session")
    let g:startify_files_number = 10
    let g:startify_session_number = 10
    let g:startify_list_order = [
                \  ['   最近项目:'],
                \  'sessions',
                \  ['   最近文件:'],
                \  'files',
                \  ['   快捷命令:'],
                \  'commands',
                \  ['   常用书签:'],
                \  'bookmarks',
                \ ]
    let g:startify_commands = [
                \  {'h': ['帮助', 'help howto']},
                \  {'v': ['版本', 'version']},
                \  {'w': ['wiki', 'VimwikiIndex']}
                \ ]
endif
" }

" AsyncRun {
if isdirectory(expand('$HOME/.vimfiles/plugged/asyncrun.vim'))
    autocmd BufEnter * set errorformat&
    let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
    function! s:ASYNC_RUN()
        exec "w"
        call asyncrun#quickfix_toggle(8,1)
        if &filetype == 'c'
            exec ":AsyncRun g++ % -o %<"
            exec ":AsyncRun -raw=1 ./%<"
        elseif &filetype == 'cpp'
            exec ":AsyncRun g++ % -o %<"
            exec ":AsyncRun -raw=1 ./%<"
        elseif &filetype == 'java'
            exec ":AsyncRun -raw=1 javac %"
            exec ":AsyncRun -raw=1 java %<"
        elseif &filetype == 'sh'
            exec ":AsyncRun -raw=1 bash %"
        elseif &filetype == 'perl'
            exec ":AsyncRun -raw=1 perl %"
        elseif &filetype == 'go'
            exec ":AsyncRun -raw=1 go run %"
        elseif &filetype == 'python'
            if g:python_version == 3
                exec ":AsyncRun -raw=1 python3 %"
            elseif g:python_version == 2
                exec ":AsyncRun -raw=1 python %"
            else
                echo "Cannot run without python support"
            endif
        endif
    endfunction
    command! AsyncRunNow call s:ASYNC_RUN()
    nnoremap <leader>r :AsyncRun
    nnoremap <M-A> :AsyncRunNow<CR>
    nnoremap <M-S> :AsyncStop<CR>
    au bufenter * if (winnr("$") == 1 && exists("AsyncRun!")) | q | endif
endif
" }

" ctrlp {
if isdirectory(expand("$HOME/.vimfiles/plugged/ctrlp.vim/"))
    let g:ctrlp_working_path_mode = 'ra'
    nnoremap <silent> <D-t> :CtrlP<CR>
    nnoremap <silent> <D-r> :CtrlPMRU<CR>
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

    if executable('ag')
        let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
    elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
    elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
        " On Windows use "dir" as fallback command.
    elseif WINDOWS()
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
    else
        let s:ctrlp_fallback = 'find %s -type f'
    endif
    if exists("g:ctrlp_user_command")
        unlet g:ctrlp_user_command
    endif
    let g:ctrlp_user_command = {
                \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
                \ }

    if isdirectory(expand("$HOME/.vimfiles/plugged/ctrlp-funky/"))
        " CtrlP extensions
        let g:ctrlp_extensions = ['funky']

        "funky
        nnoremap <Leader>fu :CtrlPFunky<Cr>
    endif
endif
"}

" Ctags {
    " set tags=./tags;/,$HOME/.vimtags
    " set tags=./.tags;,.tags
    let Tlist_Auto_Open=1
    set tags=tags;
    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
" }

" TagBar {
if isdirectory(expand("$HOME/.vimfiles/plugged/tagbar/"))
    " nnoremap <silent> <leader>tt :TagbarToggle<CR>
    let g:tagbar_type_markdown = {
                \ 'ctagstype' : 'markdown',
                \ 'kinds' : ['h:headings'],
                \ 'sort' : 0
                \ }
    map <silent> <F9> :TagbarToggle<cr>
endif
"}


" Fugitive {
if isdirectory(expand("$HOME/.vimfiles/plugged/vim-fugitive/"))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif
"}

" UndoTree {
if isdirectory(expand("$HOME/.vimfiles/plugged/undotree/"))
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
endif
" }



" vim-airline {
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
" segments add the following to your .vimrc.before.local file:
"   let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.

" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
if isdirectory(expand("$HOME/.vimfiles/plugged/vim-airline-themes/"))
    if !exists('g:airline_theme')
        let g:airline_theme = 'solarized'
    endif
    if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='›'  " Slightly fancier than '>'
        let g:airline_right_sep='‹' " Slightly fancier than '<'
    endif

    let g:airline#extensions#tabline#enabled = 1
    " let g:airline#extensions#tabline#left_sep = ''
    " let g:airline#extensions#tabline#left_alt_sep = ''
    " let g:airline#extensions#tabline#formatter = 'unique_tail'
endif
" }

" Terminal setup  {
    if has('terminal')
        tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
        tnoremap <C-[> <C-\><C-n>
        tnoremap <ESC> <C-\><C-n>
        tnoremap <M-h> <C-\><C-n><c-w>h
        tnoremap <M-l> <C-\><C-n><c-w>l
        tnoremap <M-j> <C-\><C-n><c-w>j
        tnoremap <M-k> <C-\><C-n><c-w>k
        tnoremap <M-H> <C-\><C-n><c-w>H
        tnoremap <M-L> <C-\><C-n><c-w>L
        tnoremap <M-J> <C-\><C-n><c-w>J
        tnoremap <M-K> <C-\><C-n><c-w>K
        if has('nvim')
            if windows()
                nmap <C-b>\ :vsplit term://cmd<cr>i
                nmap <C-b>= :split  term://cmd<cr>i
                nmap <C-b>t :tabe   term://cmd<cr>i
            else
                nmap <C-b>\ :vsplit term://bash<cr>i
                nmap <C-b>= :split  term://bash<cr>i
                nmap <C-b>t :tabe   term://bash<cr>i
            endif
            nmap <leader>b\ :vsplit term://
            nmap <leader>b= :split  term://
            nmap <leader>bt :tabe   term://
        else
            if WINDOWS()
                nmap <C-b>\ :vertical terminal<cr>cmd<cr>
                nmap <C-b>= :terminal<cr>cmd<cr>
                nmap <C-b>t :tab terminal<Cr>cmd<Cr>
            else
                nmap <C-b>\ :vertical terminal<cr>bash<cr>
                nmap <C-b>= :terminal<cr>bash<cr>
                nmap <C-b>t :tab terminal<Cr>bash<Cr>
            endif
            nmap <leader>b\ :vertical terminal
            nmap <leader>b= :terminal
            nmap <leader>bt :tab terminal
        endif
    endif
" }

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T  "remove toolbar
        set guioptions-=m  "remove menu bar
        set guioptions-=r  "remove right-hand scroll bar
        set guioptions-=L  "remove left-hand scroll bar
        set lines=60 columns=130
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
    let parent = $HOME
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
    "   eg: let g:spf13_consolidated_directory = $HOME . '/.vimfiles/'
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
" }

" Initialize NERDTree as needed {
function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction
" }
" Complete options {
if filereadable(expand("$HOME/.vimrc.compl"))
    source $HOME/.vimrc.compl
endif
" }
" User defined vimrc {
if filereadable(expand("$HOME/.usr_vimrc"))
    source $HOME/.usr_vimrc
endif
" }
