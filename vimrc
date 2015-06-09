"==
" dot vimrc
" author: Chanaka Sandaruwan
"==

"== 01 Basic {{{
set nocompatible

execute pathogen#infect()

syntax enable
filetype plugin indent on
set hidden
"}}}

"== 02 Auto commands {{{
" jump to last cursor positon of a file
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Ruby xmpfilter
autocmd FileType ruby nmap <buffer> <F7> <Plug>(xmpfilter-mark)
autocmd FileType ruby xmap <buffer> <F7> <Plug>(xmpfilter-mark)
autocmd FileType ruby imap <buffer> <F7> <Plug>(xmpfilter-mark)

autocmd FileType ruby nmap <buffer> <F5> <Plug>(xmpfilter-run)
autocmd FileType ruby xmap <buffer> <F5> <Plug>(xmpfilter-run)
autocmd FileType ruby imap <buffer> <F5> <Plug>(xmpfilter-run)

" By default, vim thinks .md is Modula-2.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Wrap the quickfix window
autocmd FileType qf setlocal wrap linebreak
" }}}

"== 03 New {{{
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" Make it more obvious which paren I'm on
"hi MatchParen cterm=none ctermbg=black ctermfg=yellow

:set formatoptions-=cro " disable automatic comment insertion in next line
set switchbuf=useopen

" This makes RVM work inside Vim. I have no idea why.
set shell=bash

" to improve vim speed, set below ruby path if you are using rbenv
let g:ruby_path = system('echo $HOME/.rbenv/shims')
"}}}

"== 04 General {{{
set history=500		  " keep 500 lines of command line history
set undolevels=500  " use many muchos levels of undo

set laststatus=2 " always show statusbar
set title

set visualbell t_vb=
set noerrorbells
set lazyredraw

set showcmd		" display incomplete commands
set showmode

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1
set timeoutlen=400 " Don't wait so long for the next keypress (particularly in ambigious Leader situations)

" scrolling
set scrolloff=3

" search
"set incsearch
"set hlsearch
set ignorecase smartcase  " make searches case-sensitive only if they contain upper-case characters

let mapleader="\<space>"
"}}}

"== 05 Tabs, Spaces and Whitespace {{{
set smartindent
set tabstop=2
set softtabstop=2
set expandtab

" whitespace
" Display extra whitespace
"set list listchars=tab:»·,trail:·
"set listchars=tab:▸\ ,eol:¬
"}}}

"== 06 Files, Directories and Backups {{{
set autoread " If a file is changed outside of vim, automatically reload it without asking
set wildmenu " Better? completion on command line
set wildmode=longest:full,full " What to do when I press 'wildchar'. Worth tweaking to see what feels right.

set wildignore+=*.swp,*.bak,*.pyc,*.class " Ignore these directories

" backups
set backup
set writebackup

set backupdir=~/.tmp-vim,~/.tmp,~/tmp,/var/tmp,/tmp " Don't clutter my dirs up with swp and tmp files
set directory=~/.tmp-vim,~/.tmp,~/tmp,/var/tmp,/tmp
" }}}

"== 07 Editing {{{
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces

set number
set hidden
match ErrorMsg '\s\+$'

set showmatch " set show matching parenthesis
set nowrap
" }}}

"== 08 Appearance {{{
set t_Co=256 " 256 colors
set background=dark
colorscheme grb256

set cursorline " highlight current line
set ruler		" show the cursor position all the time
set cmdheight=1
set showtabline=2 " Always show tab bar

" GRB: Put useful info in status line
:set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red
hi CursorLine cterm=NONE ctermbg=black
"}}}

"== 09 Indentation {{{
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent  " always set autoindenting on
set copyindent  " copy the previous indentation on autoindenting
set shiftwidth=2  " number of spaces to use for autoindenting
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.
"}}}

"== 10 Buffers, Splits and Windows {{{
set splitbelow
set splitright

" move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" buffers
nnoremap <c-tab> :bnext<cr>
nnoremap <c-s-tab> :bprev<cr>
nnoremap <c-t> :tabnew<cr>

" windows
set winwidth=79
set wmh=0
" }}}

"== 11 Custom Functions {{{
" duplicate current file
function! DuplicateFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name !=# old_name
        exec ':saveas ' . new_name
        redraw!
    endif
endfunction

" rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name !=# old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

" delete current file
function! DeleteFile()
    let file_name = expand('%')
    if file_name != ''
        exec ':!rm -i ' . file_name
    endif
endfunction

" create directory
function! CreateDirectory()
    let current_dir = expand('%:h').'/'
    let dir_name = input('New directory: ', expand('%:h').'/')
    if dir_name != '' && dir_name
        exec ':!mkdir -p ' . dir_name
    endif
endfunction

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" }}}

"== 12 Custom Commands {{{
"noremap :! :!clear;

" open files in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" delete buffer
command! BD :bprev | bd#

" quickly edit/reload the vimrc file
command! Evimrc :e $MYVIMRC
command! Egvimrc :e $MYGVIMRC
command! Svimrc :so $MYVIMRC
command! Sgvimrc :so $MYGVIMRC

" Fail-safe
command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! W :w
"}}}

"== 13 Plugins {{{
" Enable built-in matchit plugin
runtime macros/matchit.vim

" CtrlP
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:30,results:30'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/vim-ctrlp'

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    let g:ackprg='ag --nogroup --nocolor --column'

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-b>'
let g:multi_cursor_skip_key='<C-k>'
let g:multi_cursor_quit_key='<Esc>'

" emmet
"let g:user_emmet_leader_key='<c-e>'
"let g:user_emmet_expandabbr_key = '<Tab>'
"inoremap <buffer> <tab> <plug>(emmet-expand-abbr)
"imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
    \ 'iw'  :0,
    \ 'iW'  :0,
    \ 'i"'  :0,
    \ 'a"'  :0,
    \ 'i''' :0,
    \ 'a''' :0,
    \ 'i]'  :1,
    \ 'it'  :0,
    \ 'at'  :0,
\ }

" UltiSnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Syntactic
let syntastic_mode_map = { 'passive_filetypes': ['cucumber'] }

" NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeMouseMode=3

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
" }}}

"== 14 Function key mappings {{{
" reload file
:map <F5> :checktime<CR>
:map! <F5> <C-O>:checktime<CR>

nnoremap <f4> :vsp<cr>
nnoremap <f3> :sp<cr>

" Recent files
map <F6> :Mru<CR>
imap <F6> <Esc>:Mru<CR>

set pastetoggle=<F2> " paste mode
nnoremap <F2> :set invpaste paste?<CR>

"nnoremap <f11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
" }}}

"== 15 Misc mappings {{{
" move vertically by visual line
nmap k gk
nmap j gj

" visual indent
vmap <Tab> >gv
vmap <S-Tab> <gv

" Insert a hash rocket with <c-l>
inoremap <c-l> <space>=><space>
inoremap <c-y> ->

" Insert semicolon at end of line
inoremap ;; <esc>m`:s/\s\+$//e<cr>A;<esc>``

nnoremap vv viw

" delete line
nnoremap dl dd

" Emacs-like beginning and end of line.
imap <c-e> <c-o>$
imap <c-a> <c-o>^

" make Y for copy behave as D for cut
nnoremap Y y$

" save file
nnoremap <c-s> :w<CR>
inoremap <c-s> <c-[>:w<CR>

" Escape mapping
inoremap jk <esc>
cno jk <c-c>
" }}}

"== 16 Leader mappings {{{
map <Leader>ac :sp app/controllers/application_controller.rb<cr>
vmap <Leader>bl :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

nnoremap <leader>; :
nnoremap <leader>[ ^
nnoremap <leader>] $

nnoremap <leader><cr> :nohlsearch<cr>

" Airline tabs
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" save session
"nnoremap <leader>s :mksession<CR>

" open
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :b<space>

" save file
nnoremap <Leader>w :w<CR>
" auto indent
nnoremap <leader>= ggVG=
" select all
nnoremap <Leader>a ggVG
" escape mapping
noremap <leader>h <c-c>
noremap <leader>c <c-c>
" uppercase word before cursor
nmap <Leader>u gUiw'

" copy & paste to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
vmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader>p "+p
nmap <Leader>P "+P

" last pasted selection
nnoremap <Leader>s `[v`]

" alternate file
nnoremap <leader><leader> <c-^>

" remove trailing whitespace
nnoremap <Leader>rt m`:%s/\s\+$//e<CR>``

" toggle invisible chars
"nmap <leader>l :set list!<CR>"

" call functions
map <Leader>d :call DuplicateFile()<cr>
map <Leader>re :call RenameFile()<cr>
map <Leader>rm :call DeleteFile()<cr>
map <Leader>mkd :call CreateDirectory()<cr>

" new buffer
map <Leader>n :enew<cr>

" edit file
" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
"map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
"map <Leader>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
"map <Leader>v :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <leader>e :edit %%
map <leader>v :view %%

" run tests
map <leader>t :w\|!rspec %<cr>
" }}}

"== 17 Auto-complete and multi-purpose tab key {{{
"inoremap <Tab> <C-n>
"inoremap <S-Tab> <C-p>

" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>
" }}}

"== 18 Copy & Paste {{{
" select the last pasted text
noremap gV `[v`]

" paste and fix indent
"nnoremap p p`[v`]=`]
"nnoremap P P`[v`]=

" jump to end of pasted text
"vnoremap <silent> y y`]
"vnoremap <silent> p p`]
"nnoremap <silent> p p`]
" }}}

"== 19 Best practices {{{
" Don't use Arrow keys
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>
" }}}
