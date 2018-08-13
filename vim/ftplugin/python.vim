set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=120
set expandtab
set autoindent
set fileformat=unix

let python_highlight_all=1

let g:ale_fixers = {
      \ 'python': [ 'isort' ]
      \}
let g:ale_linters = {
      \'python': ['flake8', 'pycodestyle'],
      \}
let g:ale_python_flake8_options="--ignore=E501"
let g:ale_python_pycodestyle_options="--ignore=E501"



" Fix python comment indent
inoremap # X<c-h>#<space>
