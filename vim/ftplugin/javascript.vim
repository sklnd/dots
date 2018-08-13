set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=120
set expandtab
set autoindent
set fileformat=unix

let b:ale_fixers = {
      \'javascript': ['prettier', 'eslint']
      \}
let g:javascript_plugin_flow = 1
let g:vim_jsx_pretty_enable_jsx_highlight = 1
