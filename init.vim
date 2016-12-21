set bs=indent,eol,start
set encoding=utf-8
set nocompatible
set t_Co=256
set termguicolors
set background=dark

filetype off
" set the runtime path to include Vundle and initialize

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

set runtimepath+=/Users/jarek/.vim/bundle/dein.vim
call dein#begin('/Users/jarek/.vim/bundle/')
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('fatih/vim-go')
call dein#add('vim-ruby/vim-ruby')
call dein#add('majutsushi/tagbar')
call dein#add('scrooloose/nerdtree')
call dein#add('saltstack/salt-vim')
call dein#add('klen/python-mode')
call dein#add('bling/vim-airline')
call dein#add('tpope/vim-fugitive', {'on_cmd' : 'Gstatus'})
call dein#add('tpope/vim-fugitive')
call dein#add('jistr/vim-nerdtree-tabs')
call dein#add('mbbill/undotree')
call dein#add('Lokaltog/vim-easymotion')
call dein#add('scrooloose/nerdcommenter')
call dein#add('Shougo/deoplete.nvim')
call dein#add('zchee/deoplete-go', {'build': 'make'})
"Plugin 'scrooloose/syntastic'

" You can specify revision/branch/tag.
"call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

colorscheme solarized
"let g:solarized_termcolors=16
"colorscheme elflord
syntax on
set nrformats-=octal
set autoindent
set number
set relativenumber
set showmatch
set ignorecase
set hlsearch
set cursorline                    " highlight current line
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=a                       " enable mouse support
set ttimeoutlen=100               " decrease timeout for faster insert with 'O'
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set scrolloff=2                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set list listchars=tab:»·,trail:· " show extra space characters
set nofoldenable                  " disable code folding
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
runtime macros/matchit.vim        " use % to jump between start/end of methods

" plugin customizations
" vim go
" disable open browser after posting snippet
let g:go_play_open_browser = 0
" enable goimports
let g:go_fmt_command = "goimports"
" enable additional highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

" vim-ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_load_gemfile = 1
let g:rubycomplete_use_bundler = 1

" vim-airline
set laststatus=2
let g:bufferline_echo = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'

" tagbar
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds' : [
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
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }


" neocomplete
let g:deoplete#enable_at_startup = 1
" Use smartcase.
let g:deoplete#enable_smart_case = 1
" Syntastic
"lee g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
""let g:syntastic_check_on_wq = 0
"let g:syntastic_puppet_puppetlint_args='
            "\ --no-80chars-check
            "\ --no-documentation-check
            "\ --no-inherits_across_namespaces-check
            "\ --no-only_variable_string-check
            "\ --no-selector_inside_resource-check
            "\'

" Set minimum syntax keyword length.
"let g:neocomplete#sources#syntax#min_keyword_length = 2
"
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets' behavior.
"imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 "\ "\<Plug>(neosnippet_expand_or_jump)"
 "\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

let g:neosnippet#snippets_directory = '~/.vim/bundle/repos/github.com/Shougo/neosnippet-snippets/neosnippets'
" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif


" shortcuts remap
nmap <F2> :tabnew<CR>
nmap <F3> :tabclose<CR>
nmap <F4> :tabnext<CR>
nmap <F5> :tabprevious<CR>
nmap <F6> :UndotreeToggle<CR>
nmap <F7> :NERDTreeTabsToggle<CR>
nmap <F8> :TagbarToggle<CR>

" put git status, column/row number, total lines, and percentage in status
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]

let mapleader=","

" show a list of interfaces which is implemented by the type under your cursor
au FileType go nmap <Leader>s <Plug>(go-implements)
" show type info for the word under your cursor
au FileType go nmap <Leader>gi <Plug>(go-info)
" open the relevant Godoc for the word under the cursor
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
" run Go commands
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap <Leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>i <Plug>(go-install)
" open the definition/declaration in a new vertical, horizontal or tab for the
" word under your cursor
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
" rename the identifier under the cursor to a new name
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go set nolist
"au FileType go setlocal omnifunc=g:neocomplete#enable_at_startup
if !exists('g:deoplete#sources#omni#input_patterns')
    let g:deoplete#sources#omni#input_patterns = {}
    let g:deoplete#auto_completion_start_length = 1
    "let g:deoplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
    let g:deoplete#sources#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '\h\w*::']
endif

"au FileType ruby setlocal omnifunc=rubycomplete#Complete
au BufReadPost fugitive://* set bufhidden=delete
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

set tabstop=4
set shiftwidth=4
set expandtab

set undofile
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
set tags=~/gotags
