" -----------------------------------------------------------
" General setup
" -----------------------------------------------------------
set backspace=2 " enable backspace to delete anyting (includes \n) in insert mode
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nocompatible " Disable compatibility with old VI
set errorbells " jingle bells, jingle bells, hingle bells, ....
set et " turn off tab insertion

" -----------------------------------------------------------
" Text-Formatting, Identing, Tabbing
" -----------------------------------------------------------
syntax on                   " syntax highlighting
"set number                  " add line numbers
set sts=3
set visualbell
set ai " autoindenting (local to buffer)
set si " smartindenting (clever autoindenting)
set tabstop=4 " number of spaces the tab stands for
set softtabstop=4 " if non-zero, number of spaces to insert for a <tab>
set expandtab               " converts tabs to white space
set shiftwidth=4 " number of spaces used for (auto)indenting
set smarttab " a <tab> in an indent insets 'shiftwidth' spaces (not tabstop)
set cindent " enable specific indenting for c-code and others
set cinoptions={.5s,+.5s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s   " by FOLKE " and here some nice options for cindenting
set cc=80 " set an 80 column border for good coding style
set tw=0 " now real wrap during insert (enable/override this when using as mail-editor)
" use full featured format-options. see "help fo-table for help
if v:version >= 600
    set formatoptions=tcrqn2
else
    " vim 5 doesn't know r/n
    set formatoptions=tcq2
endif
:set autowrite " write before changing files

" define what are comments
set com& " reset to default
set com^=sr:*\ -,mb:*\ \ ,el:*/ com^=sr://\ -,mb://\ \ ,el:///
" auto tw=78 when textmode
if has("autocmd")
    autocmd FileType text setlocal textwidth=78
    autocmd FileType text set nocindent
endif

" -----------------------------------------------------------
" Searching, Substituting
" -----------------------------------------------------------
set ignorecase " select case-insenitiv search
set scs " No ignorecase if Uppercase chars in search
set magic " change the way backslashes are used in search patterns
set wrapscan " begin search at top when EOF reached
set sm " jump to matches during entering the pattern
"set hls " highlight all matches...
set incsearch " ...and also during entering the pattern
set showcmd " display incomplete commands
set gdefault " use 'g'-flag when substituting (subst. all matches in that line, not only first) to turn off, use g (why is there no -g ?)
set noedcompatible " turn off the fucking :s///gc toggling
" Don't use Ex mode, use Q for formatting
map Q gq
" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

syn sync minlines=10000 maxlines=10000 " how many lines to sync backwards
let c_minlines = 200 " how many lines to search backward after a jump to check syntax
let c_comment_strings = 1 " aldo highlight some things in comments

let html_use_css = 1 " use css when converting syntax to html (2html.vim)
command Code2html :source $VIMRUNTIME/syntax/2html.vim| " and a nice command for makeing html-code

" -----------------------------------------------------------
" Statusline, Menu
" -----------------------------------------------------------
set wc=<TAB> " use tab for auto-expansion in menus
set wmnu " show a list of all matches when tabbing a command
set wildmode=list:longest,list:full " how command line completion works
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz " ignore some files for filename completion
set su=.h,.bak,~,.o,.info,.swp,.obj " some filetypes got lower priority
set hi=2000 " remember last 2000 typed commands
set ruler " show cursor position below each window
set showmode " shows the current status (insert, visual, ...) in statusline
set shm=a " use shortest messages
set laststatus=2 " show always statusline of last window

" -----------------------------------------------------------
" Insert-Mode Completion
" -----------------------------------------------------------
set complete=.,w,b,u,t,i " order and what to complete. see ":help complete" for info
" set dict=<FILENAME> " enable dictionary (add k to complete to scan dict when completing)
set infercase " adjust case of a keyword completion match
set nosft " showfulltag   when completing tags in Insert mode show only the name not any arguments (when a c-funtion is inserted)

" -----------------------------------------------------------
" Tag search (c-code) and tag highlighting
" -----------------------------------------------------------
set tags=./tags,../tags,../../tags,../../../tags,/usr/include/tags " where to look for tags
noremap <2-LeftMouse> :call MousePush()<cr> " double-click opens preview-window with matching tag
" and also <Strg-_> (useful on console or using no mouse)
map ^_ :call MousePush()<cr>
imap ^_  <space><esc>:let pos_pos = line('.').'normal! '.virtcol('.').'<bar>'<cr>[(^[[D:call MousePush()<cr>:exe pos_pos<cr>a<backspace>
" cycle thru preview tags
map <C-PageUp> :ptp<cr>
map <C-PageDown> :ptn<cr>
imap <C-PageUp> <esc>:silent! ptp<cr>a
imap <C-PageDown> <esc>:silent! ptn<cr>a
" height of preview-window
set previewheight=5
fun! MousePush()
    if filereadable(expand("<cfile>"))
        exe 'edit ' . expand("<cfile>")
    elseif -1 < match(getline(line(".")), "<".expand("<cfile>").">")
        exe 'find ' . expand("<cfile>")
    else
        exe 'ptag ' . expand ("<cword>")
    endif
endfun
" generate tags.vim file out of tags file for highlighting all local functions
noremap <F11>  :sp tags<CR>:%s/^\([^ \t:]*:\)\=\([^ \t]*\).*/syntax keyword Tag \2/<CR>:wq! tags.vim<CR>/^<CR><F12><F4>
" source tags.vim file
noremap <F12>  :source tags.vim<CR>
" autoload tags.vim if exists
au BufRead *
            \   if filereadable(expand("%:p:h")."/tags.vim")  && expand("%p:h") != $VIMRUNTIME
            \ |     exe 'source '.expand("%:p:h")."/tags.vim"
            \ | endif

" -----------------------------------------------------------
" window handling
" -----------------------------------------------------------
set wh=1 " minimal number of lines used for the current window
set wmh=0 " minimal number of lines used for any window
set noequalalways " make all windows the same size when adding/removing windows
set splitbelow "a new window is put below the current one

" -----------------------------------------------------------
" mouse
" -----------------------------------------------------------
set mouse=v " middle-click paste with mouse
set mousef " focus follows mouse

" -----------------------------------------------------------
" file, backup, path
" -----------------------------------------------------------
set uc=50 " updatecount   number of characters typed to cause a swap file update
set nobackup " make no backups

if has("unix")
    if v:version >= 600
        set     path=.,~/include/**,~/src/**2,~/.vim/**2,~/lib/**2,/usr/include/**,/usr/X11R6/include/,/usr/local/include
    else
        set     path=.,~/include,/usr/include,/usr/X11R6/include/,/usr/local/include
    endif
endif

" -----------------------------------------------------------
" UNIX Specials
" -----------------------------------------------------------
if has("unix")
  if !has("nvim")
    set clipboard=autoselect
  else
  endif

  set shell=/bin/zsh
endif

" -----------------------------------------------------------
" Special Features
" -----------------------------------------------------------
if v:version >= 600
    filetype on
    filetype indent on
else
    filetype on
endif

if has("autocmd")
    " try to auto-examine filetype
    if v:version >= 600
        filetype plugin indent on
    endif
    " try to restore last known cursor position
    autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif
    " autoread gzip-files
    augroup gzip
    " Remove all gzip autocommands
    au!

    " Enable editing of gzipped files
    " set binary mode before reading the file
    autocmd BufReadPre,FileReadPre      *.gz,*.bz2 set bin
    autocmd BufReadPost,FileReadPost    *.gz call GZIP_read("gunzip")
    autocmd BufReadPost,FileReadPost    *.bz2 call GZIP_read("bunzip2")
    autocmd BufWritePost,FileWritePost  *.gz call GZIP_write("gzip")
    autocmd BufWritePost,FileWritePost  *.bz2 call GZIP_write("bzip2")
    autocmd FileAppendPre               *.gz call GZIP_appre("gunzip")
    autocmd FileAppendPre               *.bz2 call GZIP_appre("bunzip2")
    autocmd FileAppendPost              *.gz call GZIP_write("gzip")
    autocmd FileAppendPost              *.bz2 call GZIP_write("bzip2")

    " After reading compressed file: Uncompress text in buffer with "cmd"
    fun! GZIP_read(cmd)
        let ch_save = &ch
        set ch=2
        execute "'[,']!" . a:cmd
        set nobin
        let &ch = ch_save
        execute ":doautocmd BufReadPost " . expand("%:r")
    endfun

    " After writing compressed file: Compress written file with "cmd"
    fun! GZIP_write(cmd)
        !mv <afile> <afile>:r
        execute "!" . a:cmd . " <afile>:r"
    endfun

    " Before appending to compressed file: Uncompress file with "cmd"
    fun! GZIP_appre(cmd)
        execute "!" . a:cmd . " <afile>"
        !mv <afile>:r <afile>
    endfun
    augroup END " gzip
endif

" -----------------------------------------------------------
" Mappings
" -----------------------------------------------------------

" Appends / insert current date
nmap _d "=strftime("%d.%m.%Y")<CR>p
nmap _D "=strftime("%d.%m.%Y")<CR>P

" Changes directory to the one of the current file
nmap _h :cd%:h<CR>

" Suppresses all spaces at end/beginning of lines
nmap _s :%s/\s\+$//<CR>
nmap _S :%s/^\s\+//<CR>

" Converts file format to/from unix
command Unixformat :set ff=unix
command Dosformat :set ff=dos

" toggle h",highlight search (folke)
noremap <F4>  :if 1 == &hls \| noh \| else \| set hls \| endif \| <CR>

" cycle thru errors (folke)
nnoremap <M-PageDown> :cn<cr>
nnoremap <M-PageUp> :cp<cr>
" Make opens error-list automatically
command Make :make|:cw
inoremap <F9> <esc>:write<cr>:Make<cr>
nnoremap <F9> write<cr>:Make<cr>

" cycle thru buffers ...
nnoremap <c-n> :bn<cr>
nnoremap <c-p> :bp<cr>

" search in doc selected text
vnoremap * <esc>:let save_reg=@"<cr>gvy:let @/=@"<cr>:let @"=save_reg<cr>/<cr>

" Folkes magic  # adder/remover
vnoremap # :s/^\([ \t]*\)\(.*\)$/\1#\2<cr>:nohl<cr>:silent! set hl<CR>
vnoremap 3 :s/^\([ \t]*\)#\(.*\)$/\1\2<cr>:nohl<cr>:silent! set hl<CR>

" Folkes auto-reindenter
function! SavePos()
    let g:restore_position_excmd = line('.').'normal! '.virtcol('.').'|'
endfun
function! RestorePos()
    exe g:restore_position_excmd
    unlet g:restore_position_excmd
endfun

inoremap <F10> <esc>:call SavePos()<CR>ggVG=:call RestorePos()<CR>a
nnoremap <F10> :call SavePos()<CR>ggVG=:call RestorePos()<CR>

" Folkes magic :wq in insertmode
function Wqtipper()
    let x = confirm("Hey!\nDu bist im Insert-Mode!\n Willst du trotzdem :wq machen?"," &Ja \n &Nein ",1,1)
    if x == 1
        silent! wq
    else
        "???
    endif
endfun
iab wq <bs><esc>:call Wqtipper()<CR>

" i often press del with the left hand on shift
inoremap <S-Del> <Del>
noremap <S-Del> <Del>


set fdm=marker

" tab navigation like firefox
:nmap <C-S-tab> :tabprevious<cr>
:nmap <C-tab> :tabnext<cr>
:map <C-S-tab> :tabprevious<cr>
:map <C-tab> :tabnext<cr>
:imap <C-S-tab> <ESC>:tabprevious<cr>i
:imap <C-tab> <ESC>:tabnext<cr>i
:nmap <C-t> :tabnew<cr>
:imap <C-t> <ESC>:tabnew<cr> 
nmap <C-Insert> :tabnew<CR>
nmap <C-Delete> :tabclose<CR>
:nmap <C-PageUp> :tabnext<cr>
:nmap <C-PageDown> :tabprev<cr>

" FZF
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf


" Plugins
call plug#begin('~/.vim/bundle')
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/artify.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'macthecadillac/lightline-gitdiff'
Plug 'maximbaz/lightline-ale'
Plug 'albertomontesg/lightline-asyncrun'
Plug 'rmolin88/pomodoro.vim'
Plug 'gruvbox-material/vim', {'as': 'gruvbox-material'}
Plug 'arcticicestudio/nord-vim'
Plug 'rakr/vim-one'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  "Plug 'zchee/deoplete-jedi', { 'for': 'python' }
  "Plug 'zchee/deoplete-clang'
  Plug 'Shougo/neco-vim', { 'for': 'vim' }
  Plug 'Shougo/neoinclude.vim'
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
endif
" Initialize plugin system
call plug#end()

" use deoplete
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libcln.so.6'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'
let g:deoplete#sources#clang#std = 'c++17'
"let g:deoplete#sources#clang#flags = ''
let g:deoplete#sources#clang#sort_algo = 'priority'
"let g:deoplete#sources#clang#clang_complete_database =
"'/home/fcavalcanti/work/source/code/build'
"let g:deoplete#sources#clang#include_default_arguments = ''
"let g:deoplete#sources#clang#filter_availability_kinds = ''

" Personalization
set showmatch " show matching brackets
set guioptions-=T
set vb t_vb=
set incsearch
set virtualedit=all
set guifont=char

" set contrast
" this configuration option should be placed before `colorscheme gruvbox-material`
" available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'

"" Airline
"let g:airline_theme = 'gruvbox_material'
"let g:airline_theme = 'one'

"" Lightline
"let g:lightline = {}
"let g:lightline.colorscheme = 'gruvbox_material'
"#############################################################################

if has('nvim')
    set path+=**
endif

" remap mapleader key (usually, \)
let mapleader = ";"

" For C++
source /home/fcavalcanti/work/dotfiles/.coc.vim

" -----------------------------------------------------------
" Highlighting, Colors, Fonts
" -----------------------------------------------------------
if exists('+termguicolors')
  echo "We have termguicolors"
  "colorscheme one
  colorscheme elflord
  "colorscheme gruvbox-material

  set t_Co=256
  set t_ut=
  set guifont=Inconsolata\ Nerd\ Font\ Complete:h10 "~/Downloads/nerd-fonts/patched-fonts/Inconsolata/complete/Inconsolata\ Nerd\ Font\ Complete.otf
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  "#############################################################################
  " Attempting to set 24-bit (true-color)
  "-----------------------------------------------------------------------------
  "Credit joshdick
  "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
  "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
  "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
  if (empty($TMUX))
    if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
      set termguicolors
    endif
  endif
  
  set background=dark " for the dark version
  " set background=light " for the light version
  " Making background transparent
  hi! Normal ctermbg=NONE guibg=NONE
  hi! NonText ctermbg=NONE guibg=NONE
  "-----------------------------------------------------------------------------
  set termguicolors " important!!
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " This line enables the true color support.
endif
