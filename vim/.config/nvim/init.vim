"===============================[ Fuchsia ]=====================================
if $FUCHSIA_DIR != "" && getcwd() =~ $FUCHSIA_DIR
  source $FUCHSIA_DIR/scripts/vim/fuchsia.vim

  exec 'autocmd BufEnter ! setlocal textwidth=100' . fnameescape($FUCHSIA_DIR . '/*.md')
  autocmd FileType fidl setlocal colorcolumn=81
  autocmd FileType go setlocal colorcolumn=81

  let $FUCHSIA_BUILD_DIR = trim(system('fx get-build-dir'))
  let $GOROOT = $FUCHSIA_BUILD_DIR . '/host-tools/goroot'
  let $GOPATH = $FUCHSIA_BUILD_DIR . '/gen/gopaths/grand_unified_binary'
  let $GOFLAGS = '-tags=fuchsia'
endif

"===============================[ Plugins ]=====================================
filetype plugin indent on
syntax enable
call plug#begin('~/.vim/plugged')

" Appearance
Plug 'chriskempson/base16-vim' " color scheme
Plug 'itchyny/lightline.vim'   " status line

" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'        " fuzzy finder
Plug 'wincent/ferret'          " multi-line search & replace

" Code analysis
Plug 'neovim/nvim-lsp'                " language server
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
Plug 'Shougo/echodoc.vim'
Plug 'majutsushi/tagbar'              " ctags
Plug 'sheerun/vim-polyglot'           " language pack

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
Plug 'christoomey/vim-tmux-navigator' " tmux window switching
Plug 'easymotion/vim-easymotion'      " motions on speed
Plug 'editorconfig/editorconfig-vim'  " editorconfig
Plug 'junegunn/goyo.vim'              " distraction-free writing
Plug 'junegunn/vim-easy-align'        " alignment
Plug 'scrooloose/nerdcommenter'       " commenting
Plug 'scrooloose/nerdtree'            " file browser
Plug 'tpope/vim-fugitive'             " git wrapper
Plug 'tpope/vim-repeat'               " enable repeating supported plugins
Plug 'tpope/vim-surround'             " surround in braces

" Disabled
"Plug 'airblade/vim-gitgutter'        " git line diff
"Plug 'jiangmiao/auto-pairs'          " bracket pairs

if getcwd() =~ $FUCHSIA_DIR
  Plug $FUCHSIA_DIR . '/garnet/public/lib/fidl/tools/vim'
endif

call plug#end()

"==============================[ Custom Keybindings ]===========================

" Disable Ex mode
nnoremap Q <Nop>

" Change leader to <Space>
let mapleader="\<Space>"

nnoremap <Leader>s :G<cr>
nnoremap <Leader>c :Gcommit<cr>
nnoremap <Leader>p :Gpush<cr>
nnoremap <Leader>d :Gdiff<cr>

" Edit the RC
command! Edit edit $MYVIMRC
command! Source source $MYVIMRC

" Control buffers
nnoremap <right> :bn<cr>
nnoremap <left> :bp<cr>
nnoremap <del> :bp\|bd #<cr>

" Build
set makeprg=$(pwd)/build.sh
nnoremap <F5> :silent make\|redraw!\|cc<cr>

function Make(script)
    exe 'silent !$(pwd)/' . a:script
    redraw!
endfunction

" Plugins
nmap <F8> :TagbarToggle<cr>
map <C-n> :NERDTreeToggle<cr>
map <Leader>r :NERDTreeFind<cr>

"===============================[ neovim/nvim-lsp ]=============================
"
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gc <cmd>lua vim.lsp.buf.rename()<CR>

lua << EOF
local nvim_lsp = require 'nvim_lsp'
local configs = require 'nvim_lsp/configs'

configs.ciderlsp = {
 default_config = {
   cmd = {'/google/bin/releases/editor-devtools/ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
   filetypes = {'c', 'cpp', 'java', 'proto', 'textproto', 'go', 'swift'};
   root_dir = nvim_lsp.util.root_pattern('BUILD');
   settings = {};
 };
}

nvim_lsp.ciderlsp.setup{}
nvim_lsp.rust_analyzer.setup({})
nvim_lsp.gopls.setup{
  root_dir = nvim_lsp.util.root_pattern('go.mod', '.git', 'BUILD.gn');
}
EOF

let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('_', 'max_abbr_width', 0)

" Tab completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Close the preview window after completion is done.
autocmd CompleteDone * silent! pclose!

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'

"===============================[ junegunn/goyo.vim ]===========================
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

"===============================[ junegunn/vim-easy-align ]=====================

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"===============================[ junegunn/fzf ]================================

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
set nojoinspaces    " Only insert one space after a '.', '?', and '!'

" Enable smart % matching for HTML, LaTeX, etc.
runtime macros/matchit.vim

" Enable spell checking for markdown files
autocmd BufEnter *.md setlocal spell

"============================[ Line Numbers ]===================================
set number         " Show the absolute line number where the cursor is
set relativenumber " Show relative line numbers everywhere else

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

"============================[ Rust ]===========================================

" Run rustfmt on every save
"let g:rustfmt_autosave = 1

" Load and compile tags automatically
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" Better tagbar
let g:rust_use_custom_ctags_defs = 1  " if using rust.vim
let g:tagbar_type_rust = {
  \ 'ctagstype' : 'rust',
  \ 'ctagsbin' : '/bin/ctags-universal',
  \ 'kinds' : [
      \ 'n:modules',
      \ 's:structures:1',
      \ 'i:interfaces',
      \ 'c:implementations',
      \ 'f:functions:1',
      \ 'g:enumerations:1',
      \ 't:type aliases:1:0',
      \ 'v:constants:1:0',
      \ 'M:macros:1',
      \ 'm:fields:1:0',
      \ 'e:enum variants:1:0',
      \ 'P:methods:1',
  \ ],
  \ 'sro': '::',
  \ 'kind2scope' : {
      \ 'n': 'module',
      \ 's': 'struct',
      \ 'i': 'interface',
      \ 'c': 'implementation',
      \ 'f': 'function',
      \ 'g': 'enum',
      \ 't': 'typedef',
      \ 'v': 'variable',
      \ 'M': 'macro',
      \ 'm': 'field',
      \ 'e': 'enumerator',
      \ 'P': 'method',
  \ },
\ }

" ===========================[ Golang ]=========================================
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent',
	\ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions',
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype',
	\ },
	\ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n',
	\ },
\ }

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
