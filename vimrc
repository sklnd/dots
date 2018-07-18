set nocompatible

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'fholgado/minibufexpl.vim'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/JSON.vim'
Plug 'vim-scripts/OmniCppComplete'
Plug 'w0rp/ale'
call plug#end()

" Set up fonts to something pleasant
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 10
  elseif has("gui_win32")
    set guifont=Consolas:h11
  endif
endif

" Set up the ack plugin on Ubuntu.
if filereadable("/usr/bin/ack-grep")
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
endif

if has('multi_byte')      " Make sure we have unicode support
   scriptencoding utf-8    " This file is in UTF-8

   " ---- Terminal Setup ----
   if ($ANSWERBACK !=# "PuTTY")
      if (&termencoding == "" && (&term =~ "xterm" || &term =~ "putty")) || (&term =~ "rxvt-unicode") || (&term =~ "screen")
         set termencoding=utf-8
      endif
   endif
   set encoding=utf-8      " Default encoding should always be UTF-8
endif

set background=dark

" Backspace fixes
fixdel
set backspace=indent,eol,start

colors tango

" Tagbar
nnoremap <silent> <F11> :TagbarToggle<CR>
autocmd VimEnter * nested :call tagbar#autoopen(1)

set guioptions-=T  " remove toolbar
set guioptions+=LlRrb  " Add settings to
set guioptions-=LlRrb  " remove scrollbars

" wildignore/ctrl-p ignores
set wildignore+=*.d,*.o,*.sw*
let g:ctrlp_custom_ignore='\v\.(d|o|so|swp)$'

" ctrl-p optimizations
let g:ctrlp_use_caching = 0
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = {
  \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
      \ 'fallback': 'ag %s -l --nocolor-u -g ""'
      \ }
else
let g:ctrlp_user_command = {
  \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
      \ 'fallback': 'find %s -type f'
      \ }
endif

set nomh

set laststatus=2
set noswapfile

" Line numbers
set nu

" Make tabs not suck. 
set ts=2
set et
set sw=2
set sts=2
set sta
set si

set history=50
set ruler
set textwidth=120

"Map folding to +
set foldmethod=manual
map + v%zf

" Some java abbreviations
ab println System.out.println("");<esc>hhi

" Auto-generate a end brace when needed.
imap {<CR> {<Esc>o}<esc>O

" Abbreviations
" expanda writeline to Console.Writeline(""); for C# 
ab writeline Console.WriteLine("");<Esc>hhi

nmap <C-S-tab> :tabprevious<cr>
nmap <C-tab> :tabnext<cr>
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
imap <C-S-tab> <ESC>:tabprevious<cr>i
imap <C-tab> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr> 

" Nobody really needs those backup files
set nobackup
set nowritebackup

" Autoindent rules
set autoindent 

" Make searching easier to deal with
set ignorecase
set smartcase

" Display a pretty statusline if we can
if has('title')
   set title
endif
set laststatus=2
set shortmess=atI
if has('statusline')
   set statusline=%<%F\ %r[%{&ff}]%y%m\ %=\ Line\ %l\/%L\ Col:\ %v\ (%P)
endif

" Enable modelines only on secure vim
if (v:version == 603 && has("patch045")) || (v:version > 603)
   set modeline
   set modelines=3
else
   set nomodeline
endif
 
" Show trailing whitespace visually
" Shamelessly stolen from Ciaran McCreesh <ciaranm@gentoo.org>
if has("gui_running")
  set listchars=tab:>>,trail:·,extends:<
  set list

   nmap <silent> <F6> :silent set list!<CR>
   imap <silent> <F6> <C-O>:silent set list!<CR>
endif

if has('mouse')
   " Dont copy the listchars when copying
   set mouse=nvi
endif

function SetJSONOptions()
  set filetype=json
endfunction

if has('autocmd')
   " always refresh syntax from the start
   autocmd BufEnter * syntax sync fromstart

   " subversion commit messages need not be backed up
   autocmd BufRead svn-commit.tmp :setlocal nobackup

   " mutt does not like UTF-8
   autocmd BufRead,BufNewFile *
      \ if &ft == 'mail' | set fileencoding=iso8859-1 | endif

   " fix up procmail rule detection
   autocmd BufRead procmailrc :setfiletype procmail

   " Fix python comment indent
   autocmd BufRead *.py inoremap # X<c-h>#<space>

  autocmd BufNewFile,BufRead,BufEnter *.json call SetJSONOptions()
endif


" ---- Spelling ----
if (v:version >= 700)
   set spelllang=en_us        " US English Spelling please
   " speeling

   " Toggle spellchecking with F7
   nmap <silent> <F7> :silent set spell!<CR>
   imap <silent> <F7> <C-O>:silent set spell!<CR>

   " Toggle spellchecking with <leader>s too, thanks chromebook
   nmap <silent> <leader>s :silent set spell!<CR>
   imap <silent> <leader>s <C-O>:silent set spell!<CR>
endif


" tab indents selection
vmap <silent> <Tab> >gv

" shift-tab unindents
vmap <silent> <S-Tab> <gv

" Page using space
noremap <Space> <C-F>

" shifted arrows are stupid
inoremap <S-Up> <C-O>gk
noremap  <S-Up> gk
inoremap <S-Down> <C-O>gj
noremap  <S-Down> gj

" Y should yank to EOL
map Y y$

" vK is stupid
vmap K k

" :W and :Q are annoying
if has('user_commands')
   command! -nargs=0 -bang Q q<bang>
   command! -nargs=0 -bang W w<bang>
   command! -nargs=0 -bang WQ wq<bang>
   command! -nargs=0 -bang Wq wq<bang>
endif

""""""""""""""""""
" ctags bindings
""""""""""""""""""
" Open definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Open definition in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>"

""""""""""""""""""
" omnicomplete
""""""""""""""""""
" Set options for c++
autocmd BufNewFile,BufRead,BufEnter *.cxx,*.cpp,*.hpp,*.h call SetCPPOptions()

function SetCPPOptions()
  set omnifunc=omni#cpp#complete#Main
endfunction


let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" Set the popup menu colors to NOT HOT PINK
highlight Pmenu guibg=brown ctermbg=238 gui=bold

" Set highlight search
set hlsearch

" Set a couple mappings to quickly select with enter or cancel omnicomplete
" with esc
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

" Remap the up and down keys to be control + the normal vim arrow keys
inoremap <expr> <C-j>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-k>     pumvisible() ? "\<C-p>" : "\<Up>"

set nowrap

"""""""""""""""""""""
" fugitive bindings
"""""""""""""""""""""
" fugitive keybindings
map <leader>g  :Gcommit<cr>
map <leader>gs :Gstatus<cr>
map <leader>ge :Gedit HEAD<cr>
map <leader>gd :Gdiff<cr>

if !has("gui_running")
  " Remap arrow keys to unbreak them in some terminals
  imap OA <ESC>ki
  imap OB <ESC>ji
  imap OC <ESC>li
  imap OD <ESC>hi

endif

" wildmenu is wild
set wildmenu
set wildmode=list:longest,full

" Python stuff
au BufNewFile,BufRead,BufEnter *.py set sw=4

" Buffer switching
" switching to buffer 1 - 9 is mapped to ,[nOfBuffer]
for buffer_no in range(1, 9)
    execute "nmap <Leader>" . buffer_no . " :b" . buffer_no . "\<CR>"
endfor

" switching to buffer 10 - 100 is mapped to ,0[nOfBuffer]
for buffer_no in range(10, 100)
    execute "nmap <Leader>0" . buffer_no . " :b" . buffer_no . "\<CR>"
endfor
set colorcolumn=120
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%121v.\+/
nmap <silent> <leader>h :match none<CR> :set cc=""<CR>
imap <silent> <leader>h <C-O>:match none<CR> :set cc=""<CR>

let python_highlight_all=1

let g:ale_linters = {
\   'python': ['flake8', 'pycodestyle'],
\}

let g:ale_python_flake8_options="--ignore=E501"
let g:ale_python_pycodestyle_options="--ignore=E501"

" Map f1 to esc because the kinesis gaming keyboard is annoying
map <F1> <Esc>
imap <F1> <Esc>"
