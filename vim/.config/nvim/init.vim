"============================[ Plug Plugin Management ]=========================
call plug#begin('~/.vim/plugged')

" Appearance
Plug 'chriskempson/base16-vim' " color scheme
Plug 'itchyny/lightline.vim'   " status line

" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'        " fuzzy finder
Plug 'wincent/ferret'          " multi-line search & replace

" IDE features
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} " code completion
Plug 'majutsushi/tagbar'       " ctags
Plug 'dbgx/lldb.nvim'          " debugger integration

" React development
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'json', 'graphql', 'markdown'],
\ }
Plug 'styled-components/vim-styled-components', {
  \ 'branch': 'main',
  \ 'for': ['javascript', 'typescript'],
\ }

" Misc
Plug 'christoomey/vim-tmux-navigator'  " tmux window switching
Plug 'easymotion/vim-easymotion'       " motions on speed
Plug 'editorconfig/editorconfig-vim'   " editorconfig
Plug 'godlygeek/tabular'               " text alightment
Plug 'junegunn/goyo.vim'               " distraction-free writing
Plug 'scrooloose/nerdcommenter'        " commenting
Plug 'scrooloose/nerdtree'             " file browser
Plug 'sheerun/vim-polyglot'            " language pack
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'tpope/vim-repeat'                " enable repeating supported plugins
Plug 'tpope/vim-surround'              " surround in braces

" Disabled
"Plug 'airblade/vim-gitgutter'          " git line diff
"Plug 'jiangmiao/auto-pairs'            " bracket pairs

call plug#end()

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
nmap <F8> :TagbarToggle<cr>
map <C-n> :NERDTreeToggle<CR>

"===============================[ Code completion ]=============================

" Use tab to navigate completion list
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use enter to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Close preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

set hidden          " if hidden is not set, TextEdit might fail.
set nobackup        " Some servers have issues with backup files, see #649
set nowritebackup
set cmdheight=2     " Better display for messages
set updatetime=300  " Smaller updatetime for CursorHold & CursorHoldI
set shortmess+=c    " don't give |ins-completion-menu| messages.
set signcolumn=yes  " always show signcolumns

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use gh to show documentation in preview window
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

command! -nargs=0 Format :call CocAction('format')       " Use `:Format` to format current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>) " Use `:Fold` to fold current buffer

"===============================[ Google ]======================================
if $FUCHSIA_DIR != ""
  source $FUCHSIA_DIR/scripts/vim/fuchsia.vim
endif


"===============================[ goyo ]========================================
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

" Augmenting Rg command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Rg  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Rg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)


" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nmap <C-p> :Files<cr>
nmap <C-f> :Rg!<cr>

"============================[ Font + Color Theme ]=============================
let g:jsx_ext_required = 0
syntax enable

" Base16
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

set background=dark
colorscheme base16-default-dark
highlight clear SignColumn

set noshowmode
let g:lightline = {
  \ 'colorscheme': 'one',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch' ],
  \             [ 'readonly', 'filename', 'modified', 'cocstatus' ], ],
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'cocstatus': 'coc#status',
  \   'filename': 'LightLineFilename',
  \ },
\ }

function! LightLineFilename()
  return expand('%')
endfunction


"============================[ General Config ]=================================
set autowriteall    " Save before closing
set autoread        " Reloads files changed outside of vim
set showcmd         " Show incomplete cmds down the bottom
set backspace=2
set clipboard+=unnamedplus
set backupcopy=yes  " Make a copy of the file and overwrite the original one
set number          " Add line numbers
set gdefault        " Add the global flag to search/replace by default
set colorcolumn=101 " Ruler at the 100th character

" Enable smart % matching for HTML, LaTeX, etc.
runtime macros/matchit.vim

" Enable spell checking for markdown files
au BufRead *.md setlocal spell

" Run rustfmt on every save
let g:rustfmt_autosave = 1

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
