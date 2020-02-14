" -----------------------------------------------------------
" General setup
" -----------------------------------------------------------

" enable backspace to delete anyting (includes \n) in insert mode
set backspace=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nocompatible
" jingle bells, jingle bells, hingle bells, ....
set errorbells

" turn off tab insertion
set et
" -----------------------------------------------------------
" Text-Formatting, Identing, Tabbing
" -----------------------------------------------------------
set expandtab
set sts=3
set visualbell
" autoindenting (local to buffer)
set ai
" smartindenting (clever autoindenting)
set si
" number of spaces the tab stands for
set tabstop=2
" number of spaces used for (auto)indenting
set shiftwidth=2
" a <tab> in an indent insets 'shiftwidth' spaces (not tabstop)
set smarttab
" if non-zero, number of spaces to insert for a <tab>
set softtabstop=2
" enable specific indenting for c-code and others
set cindent
" and here some nice options for cindenting
set cinoptions={.5s,+.5s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s   " by FOLKE
" now real wrap during insert (enable/override this when using as mail-editor)
set tw=0
" use full featured format-options. see "help fo-table for help
if v:version >= 600
    set formatoptions=tcrqn2
else
    " vim 5 doesn't know r/n
    set formatoptions=tcq2
endif
" write before changing files
:set autowrite

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

" select case-insenitiv search
set ignorecase 
" No ignorecase if Uppercase chars in search
set scs
" change the way backslashes are used in search patterns
set magic
" begin search at top when EOF reached
set wrapscan
" jump to matches during entering the pattern
set sm
" highlight all matches...
set hls
" ...and also during entering the pattern
set incsearch
" display incomplete commands
set showcmd
" use 'g'-flag when substituting (subst. all matches in that line, not only first)
" to turn off, use g (why is there no -g ?)
set gdefault
" turn off the fucking :s///gc toggling
set noedcompatible
" Don't use Ex mode, use Q for formatting
map Q gq
" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" -----------------------------------------------------------
" Highlighting, Colors, Fonts
" -----------------------------------------------------------

" when we have a colored terminal or gui...
if &t_Co > 2 || has("gui_running")
    " ...then use highlighting
    syntax on
    " Also switch on highlighting the last used search pattern.
    set hlsearch
endif

if has("gui_running")
    "Standartgroesse bei'm GUI-Fenster
    "columns    width of the display
    set co=98
    "lines      number of lines in the display
    set lines=41
    if has("win32")
        set guifont=Fixedsys:h9:cANSI
        "set guifont=Courier:h10:cANSI
    else
        set gfn=-adobe-courier-medium-r-normal-*-*-140-*-*-m-*-iso8859-15
    endif
    "colorscheme morning
endif

if !has('gui_running')
  set t_Co=256
endif

" how many lines to sync backwards
syn sync minlines=10000 maxlines=10000
" how many lines to search backward after a jump to check syntax
let c_minlines = 200
" aldo highlight some things in comments
let c_comment_strings = 1
" SQL-Highlighting in PHP-Strings (1=yes 0=no)
let php_sql_query = 1
let php_minlines=300
let php_htmlInStrings=1
" use white background in GUI-Mode, black on console
if has("gui_running") 
"|| &term=="xterm"
    set bg=light
else
    set bg=dark
endif

" use css when converting syntax to html (2html.vim)
let html_use_css = 1
" and a nice command for makeing html-code
command Code2html :source $VIMRUNTIME/syntax/2html.vim|

" -----------------------------------------------------------
" Statusline, Menu
" -----------------------------------------------------------

" use tab for auto-expansion in menus
set wc=<TAB>
" show a list of all matches when tabbing a command
set wmnu
" how command line completion works
set wildmode=list:longest,list:full
" ignore some files for filename completion
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz
" some filetypes got lower priority
set su=.h,.bak,~,.o,.info,.swp,.obj
" remember last 2000 typed commands
set hi=2000
" show cursor position below each window
set ruler
" shows the current status (insert, visual, ...) in statusline
set showmode
" use shortest messages
set shm=a
" show always statusline of last window
set laststatus=2

" -----------------------------------------------------------
" Insert-Mode Completion
" -----------------------------------------------------------

" order and what to complete. see ":help complete" for info
set     complete=.,w,b,u,t,i
" enable dictionary (add k to complete to scan dict when completing)
" set dict=<FILENAME>
" adjust case of a keyword completion match
set infercase
" showfulltag   when completing tags in Insert mode show only the name
" not any arguments (when a c-funtion is inserted)
set nosft

" -----------------------------------------------------------
" Tag search (c-code) and tag highlighting
" -----------------------------------------------------------

" where to look for tags
set     tags=./tags,../tags,../../tags,../../../tags,/usr/include/tags
" double-click opens preview-window with matching tag
noremap <2-LeftMouse> :call MousePush()<cr>
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

" focus follows mouse
set mousef
" minimal number of lines used for the current window
set wh=1
" minimal number of lines used for any window
set wmh=0
" make all windows the same size when adding/removing windows
set noequalalways
"a new window is put below the current one
set splitbelow

" -----------------------------------------------------------
" file, backup, path
" -----------------------------------------------------------

" updatecount   number of characters typed to cause a swap file update
set uc=50
" make no backups
set nobackup

if has("unix")
    if v:version >= 600
        set     path=.,~/include/**,~/src/**2,~/.vim/**2,~/lib/**2,/usr/include/**,/usr/X11R6/include/,/usr/local/include
    else
        set     path=.,~/include,/usr/include,/usr/X11R6/include/,/usr/local/include
    endif
endif


" -----------------------------------------------------------
" WIN-GUI Specials
" -----------------------------------------------------------

" first of all: we don't use "behave windows"
" to try to get a better clipboard-handling
" (we do it ourself)

if has("win32")
    if has("gui_running")
        " alt jumps to menu
        set winaltkeys=menu
        " clipboard to autoselect
        set guioptions+=a

        " ---- Windows Like keys ----
        " CTRL-Z is Undo; not in cmdline though
        noremap <C-Z> u
        inoremap <C-Z> <C-O>u
        " CTRL-Y is Redo (although not repeat); not in cmdline though
        noremap <C-Y> <C-R>
        inoremap <C-Y> <C-O><C-R>
        " CTRL-A is Select all
        noremap <C-A> gggH<C-O>G
        inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
        cnoremap <C-A> <C-C>gggH<C-O>G
        " CTRL-F4 is Close window
        noremap <C-F4> <C-W>c
        inoremap <C-F4> <C-O><C-W>c
        cnoremap <C-F4> <C-C><C-W>c
        " CTRL-Tab is Next window
        noremap <C-Tab> <C-W>w
        inoremap <C-Tab> <C-O><C-W>w
        cnoremap <C-Tab> <C-C><C-W>w
        " ---- Windows Like Copy-Paste keys ----
        " CTRL-v is paste
        inoremap <C-v> <esc>"*p<return>i
        noremap <C-v> "*p<return>
        " CTRL-x is cut (in visual mode only)
        vnoremap <C-x> "*d
        " CTRL-c is copy (in visual mode only)
        vnoremap <C-c> "*y
        " ---- Restore some remapped things 
        " make real <C-V> (visual block) as <C-Q> available
        noremap <c-q> <c-v>
        inoremap <C-Y> <C-Y>

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

" toggle highlight search (folke)
noremap <F4>  :if 1 == &hls \| noh \| else \| set hls \| endif \| <CR>


"noremap <PageUp> <c-u>
"noremap <PageDown> <c-d>

" <Tab> is bound to `complete'
" inoremap <Tab> ^P

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

" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

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
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
" Initialize plugin system
call plug#end()

" Personalization
set showmatch
set guioptions-=T
set vb t_vb=
set incsearch
set virtualedit=all
set guifont=char
" important!!
set termguicolors

" for dark version
set background=dark

" for light version
"set background=light

" set contrast
" this configuration option should be placed before `colorscheme gruvbox-material`
" available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'

"" Airline
"let g:airline_theme = 'gruvbox_material'

" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox_material'

colorscheme gruvbox-material
" colorscheme icansee
"source ~/work/dotfiles/.vim/icansee.vim

