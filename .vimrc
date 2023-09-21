" Comments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Print info about line and column in status bar
set ruler

" highlight search results on screen
set hlsearch

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Turn on completion for command mode
set wildmenu

" Auto-load files when changes are made to them that were NOT made
" in vim. Can undo changes with u.
set autoread

" set background to dark always
set background=dark

" In insert or command mode, move normally by using Ctrl
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" tab is 4 characters
set tabstop=4 softtabstop=4
" using the shift key moves over by 4 spaces
set shiftwidth=4
" convert tabs to spaces
set expandtab
" attempt to auto-indent
set smartindent
" don't line wrap
set nowrap
" don't create swap files
set noswapfile

" show previous command on status line at bottom of buffer
set showcmd
" when a bracket is inserted, briefly jump to the matching bracket
set showmatch

" use F3 to toggle paste mode on or off. When pastemode is on,
" don't auto-indent blocks of pasted text
set pastetoggle=<F3>

" Toggle relative numbers off when entering insert mode or when
" the buffer loses focus
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Show tab characters and trailing whitespace characters
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" map leader key to spacebar
let mapleader = " "

"Remove all trailing whitespace in file by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" test if running inside WSL and apply WSL specific settings
let uname = substitute(system('uname'),'\n','','')
if uname == 'Linux'
    let lines = readfile("/proc/version")
    if lines[0] =~ "Microsoft"
        " when yanking text copy to windows clipboard
        autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' |  clip.exe')
    endif
endif

if uname =~ 'CYGWIN.*'
    set pythonthreedll=/usr/bin/libpython3.8.dll
endif

" check if .valid_hosts file exists. If it does, read in list of valid
" hosts to initialize plugins and plugin-specific settings.
let validhosts = []
let hosts_file = $HOME . '/.vim/.valid_hosts'
if !empty(glob(hosts_file))
    let validhosts = readfile(hosts_file)
endif

" add settings specific to home servers here
if index(validhosts, hostname()) >= 0

    " Specify a directory for plugins for plugged plugin
    " Avoid using standard Vim directory names like 'plugin'
    call plug#begin('~/.vim/plugged')

    Plug 'git@github.com:kien/ctrlp.vim.git'
    Plug 'git@github.com:Valloric/YouCompleteMe.git'
    Plug 'mbbill/undotree'
    Plug 'git@github.com:yegappan/taglist'
    Plug 'mechatroner/rainbow_csv'
    Plug 'tmhedberg/matchit'
    Plug 'tomasr/molokai'

    " Initialize plugin system
    call plug#end()

    " set undo directory for undo tree
    set undodir=~/.vim/undodir
    set undofile

    " CtrlP options
    "
    " Set additional root project marker for maven projects
    let g:ctrlp_root_markers = ['pom.xml']
    " disable ctrlp caching
    let g:ctrlp_use_caching = 0
    " disable max files setting
    let g:ctrlp_max_files=0

    " set patterns to ignore when ctrlp scans for files
    set wildignore=.DS_Store,*.class,*.jaw,*/target/*,*.o,*.lo,*.la,*.so,*.so.[0-9]*,*.pyc,*.pyo,__pycache__/,nbactions.xml,nb-configuration.xml,.idea/,*.iml,.svn/

    let g:netrw_browse_split=2
    let g:netrw_banner = 0
    let g:netrw_winsize = 25

    nnoremap <leader>u :UndotreeShow<CR>
    nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

    " set colorscheme to molokai
    colorscheme molokai

    " Configure powerline
    python3 from importlib import util
    python3 exists = util.find_spec("powerline") is not None
    python3 if exists: from powerline.vim import setup as powerline_setup
    python3 if exists: powerline_setup()
    python3 if exists: del powerline_setup
    python3 del exists
    python3 del util

    set laststatus=2

else
" add settings specific to ngs cloud servers here

    " Disable .viminfo file because of permissions issues with home directories
    " in the cloud
    set viminfo=

    " set color scheme to elflord
    colorscheme elflord

endif
