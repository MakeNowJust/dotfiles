" Set options {{{1
if &compatible | set nocompatible | endif

" Encoding
silent! set encoding:utf-8 fileencoding:utf-8 fileformats:unix,dos,mac
silent! set fileencodings:utf-8,iso-2022-jp-3,euc-jisx2013,cp932,euc-jp,sjis,jis,latin,iso-2022-jp

" Appearance
silent! set number relativenumber numberwidth:4
silent! set background:dark display:lastline,uhex
silent! set wrap wrapmargin:0 showbreak:>\ 
silent! set noshowmatch matchtime:1 noshowmode noshowcmd
silent! set shortmess:aIAc cmdheight:1 cmdwinheight:10
let g:mode_dict = {
\ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'c': 'COMMAND', 'r': 'PROMPT', '!': 'EXECUTE',
\ 'v': 'VISUAL', 'V': 'L-VISUAL', "\<C-v>": 'R-VISUAL', 's': 'SELECT', 'S': 'L-SELECT', "\<C-s>": 'R-SELECT',
\ 't': 'TERMINAL'
\ }
silent! set noruler rulerformat: laststatus:2
silent! set statusline:[%n][%{g:mode_dict[mode()]}][%t]%{&paste?'[PASTE]':''}%{&expandtab?'':'[TAB]'}%m%r%h%w%y%q[%{strftime('%Y/%m/%d\ %k:%M:%S')}]%=[%l/%L:%c][%p%%]
silent! set title titlelen:100 titleold: titlestring:%t%m\ -\ VIM
silent! set noicon iconstring: showtabline:1 norightleft
silent! set cursorline nocursorcolumn colorcolumn: concealcursor:nvc conceallevel:0
silent! set list listchars:tab:>\ ,nbsp:_,trail:-
silent! set synmaxcol:5000 ambiwidth:default breakindent breakindentopt:min:30,sbr
silent! set nosplitbelow nosplitright startofline whichwrap:b,s,<,>
silent! set scroll:0 sidescroll:0 scrolloff:5 sidescrolloff:0
silent! set equalalways nowinfixwidth nowinfixheight winminwidth:3 winminheight:3
silent! set nowarn noconfirm fillchars:stl:\ ,stlnc:\ ,vert:\|,fold:\ ,diff:\ 
silent! set eventignore: helplang:en viewoptions:cursor,folds,options virtualedit:
silent! set emoji
if has('gui_running') | set lines:999 columns:999 | else | set t_Co:256 | endif

" Editing
silent! set iminsert:0 imsearch:0 nopaste pastetoggle: nogdefault comments& commentstring:#\ %s
silent! set smartindent autoindent shiftround shiftwidth:2 expandtab tabstop:2 smarttab softtabstop:2
silent! set textwidth:0 backspace:eol,indent,start nrformats:alpha,hex,bin formatoptions:cmMj nojoinspaces
silent! set nohidden autoread noautowrite noautowriteall nolinebreak mouse: modeline modelines&
silent! set noautochdir write nowriteany writedelay:0 verbose:0 verbosefile: notildeop noinsertmode

" Folding
silent! set foldclose:all foldcolumn:0 nofoldenable foldlevel:0 foldlevelstart:0 foldmarker& foldmethod:indent

" Clipboard
" silent! set clipboard:unnamed,unnamedplus

" Search
silent! set wrapscan ignorecase smartcase incsearch hlsearch magic

" Insert completion
silent! set complete& completeopt:menu infercase pumheight:10 noshowfulltag

" Command line
silent! set wildchar:<Tab> wildmenu wildmode:list:longest wildoptions: wildignorecase cedit:<C-k>
silent! set wildignore:*~ suffixes:

" Performance
silent! set updatetime:300 timeout timeoutlen:500 ttimeout ttimeoutlen:50 ttyfast lazyredraw

" Bell
silent! set noerrorbells visualbell t_vb:

if has('vim_starting')
  " Use DECSCUSR to set cursor type.

  " On insert mode, display unblink vertical cursor.
  let &t_SI .= "\e[6 q"
  " On normal mode, display unblink block cursor.
  let &t_EI .= "\e[2 q"
  " On replace mode, display underline cursor.
  let &t_SR .= "\e[4 q"
endif

" Functions {{{1

function! g:HistoryDeleteAll()
  set viminfo+=:0
  wviminfo!
  set viminfo-=:0
endfunction

" Auto commands {{{1
augroup vimrc
autocmd!
augroup END

" Fix window position of help/quickfix
autocmd vimrc FileType help if &l:buftype ==# 'help'     | wincmd K | endif
autocmd vimrc FileType qf   if &l:buftype ==# 'quickfix' | wincmd J | endif

" Always open read-only when a swap file is found
autocmd vimrc SwapExists * let v:swapchoice = 'o'

" Automatically set expandtab
autocmd vimrc FileType * execute 'setlocal ' . (search('^\t.*\n\t.*\n\t', 'n', line("w$")) ? 'no' : '') . 'expandtab'

" Setting lazyredraw causes a problem on startup
autocmd vimrc VimEnter * redraw

" Restore position if possible
autocmd vimrc BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" For commlog
autocmd vimrc BufRead,BufNewFile COMMIT_EDITMSG if system('git symbolic-ref --short HEAD') ==# "commlog\n" | setf markdown | endif

" babel
autocmd vimrc BufRead,BufNewFile .babelrc set ft=json

autocmd vimrc FileType go set noexpandtab

" Key mappings {{{1
" Swap line/normal visual mode
nnoremap v V
nnoremap V v

" Space based operations
nnoremap <silent> <Space>q :<C-u>quit<CR>
nnoremap <silent> <Space>Q :<C-u>quitall<CR>
nnoremap <silent> <Space>s :<C-u>split<CR>
nnoremap <silent> <Space>v :<C-u>vsplit<CR>
nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l
nnoremap <Space>H <C-w>H
nnoremap <Space>J <C-w>J
nnoremap <Space>K <C-w>K
nnoremap <Space>L <C-w>L
nnoremap <Space>w <C-w>w
nnoremap <Space>W <C-W>W
nnoremap <Space>o <C-w>o
nnoremap <silent> <Space>t :<C-u>tabnew<CR>
nnoremap <Space>n gt
nnoremap <Space>p gT

nnoremap <C-w>t gt

" Enter to save
nnoremap <expr> <CR> (bufname('%') ==# '[Command Line]' ? '<CR>' : ':<C-u>silent write<CR>:<C-u>echo "write"<CR>')

" Open command line window instead of command line
nnoremap  : q:
nnoremap q:  :

" Disable EX-mode
nnoremap  Q <Nop>
nnoremap gQ <Nop>

" Increment/Decrement
nnoremap + <C-a>
nnoremap - <C-x>

" For QuickFix
map <C-n> :<C-u>cn<CR>
map <C-p> :<C-u>cp<CR>

nnoremap <Space>ah :<C-u>history :<CR>
nnoremap <Space>ad :<C-u>call g:HistoryDeleteAll()<CR>

" Netrw settings {{{1

" Open with vertical split and reuse recently opened buffer by default
let g:netrw_browse_split = 3
" Not display menu
let g:netrw_menu = 0
" Not display banner
let g:netrw_banner = 0
" Tree view
let g:netrw_liststyle = 3
" Default size
let g:netrw_winsize = 80
" dotfiles is not shown defaultly
let g:netrw_listhide = '\(^\|\s\s\)\zs\.\S\+'
" Type p to open vertical preview window
let g:netrw_preview = 1
" Type v to open file rightside
let g:netrw_altv = 1
" Type o to open file topside
let g:netrw_alto = 0

" Plugins {{{1

" Plug commands {{{2
call plug#begin()

Plug 'MakeNowJust/islenauts.vim'
Plug 'haya14busa/is.vim'
Plug 'vim-scripts/gtags.vim'
Plug 'rhysd/vim-crystal', { 'for': ['crystal', 'markdown'] }
" Plug 'othree/yajs.vim', { 'for': ['javascript', 'markdown'] }
" Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'markdown'] }
Plug 'digitaltoad/vim-pug', { 'for': 'pug' }
Plug 'editorconfig/editorconfig-vim'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'keith/swift.vim', { 'for': 'swift' }
Plug 'nikvdp/ejs-syntax', { 'for': 'ejs' }
Plug 'vimperator/vimperator.vim'
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'vim-scripts/jam.vim'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'maxmellon/vim-jsx-pretty', { 'for': 'javascript' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'PProvost/vim-ps1', { 'for': 'ps1' }
Plug 'hashivim/vim-terraform'
Plug 'mk12/vim-lean'
Plug 'cespare/vim-toml'

call plug#end()

" islenauts.vim {{{2
colorscheme islenauts
"highlight Normal ctermbg=none
"highlight NonText ctermbg=none

" is.vim {{{2
map n  <Plug>(is-n)
map N  <Plug>(is-N)
map *  <Plug>(is-*)
map #  <Plug>(is-#)
map g* <Plug>(is-g*)
map g# <Plug>(is-g#)

" vim-markdown {{{2

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_fenced_languages = [
      \ 'viml=vim',
      \ 'js=javascript',
      \ ]

" vim-javascript {{{2

let g:javascript_plugin_flow = 1

" Load local .vimrc {{{1

if expand('<sfile>') !=# getcwd() . '/.vimrc' && filereadable(getcwd() . '/.vimrc')
  exec 'so ' . getcwd() . '/.vimrc'
endif

" Enable ftplugin, indent, syntax {{{1

filetype plugin indent on
silent! syntax enable
if !has('vim_starting')
  doautocmd FileType
endif

" vim:set foldenable foldmethod=marker:
