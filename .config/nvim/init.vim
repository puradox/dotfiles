"============================[ Plug Plugin Management ]=========================
call plug#begin('~/.vim/plugged')

if !has('nvim')
  Plug 'tpope/vim-sensible'            " Let's be sensible now...
endif

" Appearance
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Extentions
Plug 'scrooloose/nerdtree'             " tree explorer
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                " fuzzy finder
Plug 'wincent/ferret'                  " multi-line search & replace

" Linting
Plug 'w0rp/ale'

" Utilities
Plug 'tpope/vim-surround'              " surround in braces
Plug 'tpope/vim-repeat'                " enable repeating supported plugins
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'scrooloose/nerdcommenter'        " easy block commenting
Plug 'godlygeek/tabular'               " text alightment
Plug 'christoomey/vim-tmux-navigator'  " tmux window switching
Plug 'kassio/neoterm'                  " Wrapper of neovim's :terminal
Plug 'janko-m/vim-test'                " Run your tests at the speed of thought
Plug 'junegunn/goyo.vim'               " Distraction-free writing
Plug 'editorconfig/editorconfig-vim'   " EditorConfig

" Additional Languages
Plug 'plasticboy/vim-markdown'         " markdown
Plug 'pangloss/vim-javascript'         " better JavaScript
Plug 'mxw/vim-jsx'                     " JSX
Plug 'leafgarland/typescript-vim'      " TypeScript

" React development
Plug 'mxw/vim-jsx'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'json', 'graphql', 'markdown'] }

call plug#end()

"===============================[ goto ]========================================
function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
    silent !tmux resize-pane -Z
  endif
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
    silent !tmux resize-pane -Z
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"===============================[ fzf ]=========================================

" Use ag for finding files; respects .gitignore
let $FZF_DEFAULT_COMMAND = 'rg --files --glob "!{.git,node_modules,bower_components}"'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nmap <C-p> :Files<cr>
nmap <C-f> :Ag!<cr>

"============================[ vim-test ]=======================================

nmap <silent> <Leader>t :TestNearest<CR>
nmap <silent> <Leader>T :TestFile<CR>
nmap <silent> <Leader>a :TestSuite<CR>
nmap <silent> <Leader>g :TestVisit<CR>

if !has('nvim')
  let test#strategy = "neoterm"
endif

"===============================[ Ale ]=========================================
let g:ale_completion_enabled = 1
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}
let g:ale_linters_explicit = 1

let g:airline#extensions#ale#enabled = 1

"============================[ Font + Color Theme ]=============================
let g:jsx_ext_required = 0
syntax enable

set background=dark
colorscheme solarized
highlight clear SignColumn

let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

"============================[ General Config ]=================================
set autowriteall    " Save before closing
set autoread        " Reloads files changed outside of vim
set showcmd         " Show incomplete cmds down the bottom
set backspace=2
set clipboard+=unnamedplus
set backupcopy=yes  " Make a copy of the file and overwrite the original one
set number          " Add line numbers
set gdefault        " Add the global flag to search/replace by default
set colorcolumn=81  " Ruler at the 80th character

" Enable smart % matching for HTML, LaTeX, etc.
runtime macros/matchit.vim

" Enable spell checking for markdown files
au BufRead *.md setlocal spell

"============================[ Folding ]========================================
set foldmethod=syntax   " Fold based on indent
set nofoldenable        " Don't fold by default

"============================[ Indentation ]====================================
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap           " Don't wrap lines
set linebreak        " Wrap lines at convenient points
set showbreak=\ \ ↳\ " Better line wrap indicator
set cpo+=n           " Indicator inline with line numbers

"============================[ Custom Keybindings ]=============================

" Disable Ex mode
nnoremap Q <Nop>

" Change leader to <Space>
let mapleader="\<Space>"

nnoremap <Leader>s :Gstatus<cr>
nnoremap <Leader>c :Gcommit<cr>
nnoremap <Leader>p :Gpush<cr>
nnoremap <Leader>d :Gdiff<cr>

" Edit the RC
command Edit edit $MYVIMRC
command Source source $MYVIMRC

" Control buffers
nnoremap <tab> <C-w><C-w>
nnoremap <right> :bn<cr>
nnoremap <left> :bp<cr>
nnoremap <del> :bp\|bd #<cr>

" Build
set makeprg=$(pwd)/build.sh
nnoremap <F5> :silent make\|redraw!\|cc<CR>

function Make(script)
    exe 'silent !$(pwd)/' . a:script
    redraw!
endfunction

" Plugins
map <C-n> :NERDTreeToggle<cr>
nmap <F8> :TagbarToggle<cr>
nmap <F9> :CtrlPTag<cr>

"============================[ Terminal ]=======================================

" Escape exits terminal mode.
tnoremap <Esc> <C-\><C-n>

" Use `Alt+{h,j,k,l}` to navigate between windows from any mode.
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


"============================[ Searching ]======================================
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" Switch off the current search
nnoremap <silent> <Leader>/ :nohlsearch<CR>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*

" Use ripgrep over grep
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

" Bind K to grep word under cursor
nnoremap K :grep <cword> *<CR>

"============================[ Backup/Swap Locations ]==========================
if !isdirectory($HOME.'/.vim/backup')
    call mkdir($HOME.'/.vim/backup', 'p')
endif
set backupdir=$HOME/.vim/backup

if !isdirectory($HOME.'/.vim/swap')
    call mkdir($HOME.'/.vim/swap', 'p')
endif
set directory=$HOME/.vim/swap

"============================[ Persistent Undo ]================================
" Keep undo history across sessions, by storing in file.
if has('persistent_undo')
    if !isdirectory($HOME.'/.vim/undo')
        call mkdir($HOME.'/.vim/undo', 'p')
    endif
    set undodir=$HOME/.vim/undo
    set undofile
endif

"============================[ Paste behavior ]=================================
" These are to cancel the default behavior of c, C
"  to put the text they delete in the default register.
"  Note that this means e.g. "ad won't copy the text into
"  register a anymore.  You have to explicitly yank it.
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

"============================[ Line Wrapping ]==================================
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        silent! nunmap <buffer> k
        silent! nunmap <buffer> j
        silent! nunmap <buffer> 0
        silent! nunmap <buffer> $
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        setlocal display+=lastline
        noremap  <buffer> <silent> k gk
        noremap  <buffer> <silent> j gj
        noremap  <buffer> <silent> 0 g0
        noremap  <buffer> <silent> $ g$
    endif
endfunction

"============================[ Remove Trailing Whitespace ]=====================
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd BufWritePre     * :call TrimWhiteSpace()

"============================[ Laptop Mode ]====================================
"noremap <silent> <Leader>l :call LaptopMode()<CR>
"let g:laptop_mode = 0
"
"function LaptopMode()
"    if g:laptop_mode
"        set guifont=Consolas:h14
"        let g:laptop_mode = 0
"    else
"        set guifont=Consolas:h16
"        let g:laptop_mode = 1
"    endif
"endfunction

"============================[ Project Specific ]===============================
"noremap <silent> <Leader>n :call Norco()<CR>
"function Norco()
"    cd /media/sam/OS/Users/Sam/Desktop/code/
"    set number
"    set makeprg=/media/sam/OS/Users/Sam/Desktop/code/build-gcc.sh\ %:p:h\ %:p:h:t
"endfunction
