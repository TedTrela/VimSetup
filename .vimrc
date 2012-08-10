"===================================================================================
" GENERAL SETTINGS
"===================================================================================
"
"-------------------------------------------------------------------------------
" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
"-------------------------------------------------------------------------------
set nocompatible
"
"-------------------------------------------------------------------------------
" Enable file type detection. Use the default filetype settings.
" Also load indent files, to automatically do language-dependent indenting.
"-------------------------------------------------------------------------------
filetype  plugin on
filetype  indent on
"
"-------------------------------------------------------------------------------
" Switch syntax highlighting on.
"-------------------------------------------------------------------------------
syntax    on            
"
" Platform specific items:
" - central backup directory (has to be created)
" - default dictionary
" Uncomment your choice.  
"if  has("win16") || has("win32") || has("win64") || has("win95")
"
"  runtime mswin.vim
"  set backupdir =$VIM\vimfiles\backupdir
"  set dictionary=$VIM\vimfiles\wordlists/german.list
"else
"  set backupdir=$HOME/.vim.backupdir
"  set dictionary=$HOME/.vim/wordlists/german.list,$HOME/.vim/wordlists/english.list
"endif
"
"-------------------------------------------------------------------------------
" Various settings
"-------------------------------------------------------------------------------
set autoindent                  " copy indent from current line
set autoread                    " read open files again when changed outside Vim
set autowrite                   " write a modified buffer on each :next , ...
set backspace=indent,eol,start  " backspacing over everything in insert mode
"set backup                      " keep a backup file
set browsedir=current           " which directory to use for the file browser
set complete+=k                 " scan the files given with the 'dictionary' option
set complete-=i
set expandtab
set history=50                  " keep 50 lines of command line history
set hlsearch                    " highlightthe last used search pattern
set ignorecase smartcase 
set incsearch                   " do incremental searching
set laststatus=2 " tell VIM to always put a status line in, even if there is only one window
set lazyredraw " Don't update the display while executing macros
set listchars=tab:>.,eol:\$     " strings to use in 'list' mode
"set mouse=a                     " enable the use of the mouse
set mousehide                   " Hide the mouse pointer while typing
set nowrap                      " do not wrap lines
set number
set popt=left:8pc,right:3pc     " print options
set ruler                       " show the cursor position all the time
set shiftwidth=4                " number of spaces to use for each step of indent
set showcmd                     " display incomplete commands
set showmode                    " Show the current mode
set smartindent                 " smart autoindenting when starting a new line
set tabstop=4                   " number of spaces that a <Tab> counts for
"set undodir=~/.vim/undodir      " dir for all undo files -- NEED vim 7.3
"set undofile                    " save undo history into file -- NEED vim 7.3
set visualbell                  " visual bell instead of beeping
set wildignore=*.bak,*.o,*.e,*~ " wildmenu: ignore these extensions
set wildmenu                    " command-line completion in an enhanced mode
"set wrap
set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]  " Set the status line the way i like it
set stl+=%#warningmsg#
set stl+=%{SyntasticStatuslineFlag()}
set stl+=%*


let g:pad_dir = '~/notes'

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

command CDC cd %:p:h


set t_Co=16
if !has('gui_running')
   let g:solarized_termcolors=&t_Co
   let g:solarized_termtrans=0
endif
set background=dark

" option name               default     optional
" ------------------------------------------------
"let g:solarized_termcolors=  16 
"let g:solarized_termtrans =   0 
let g:solarized_degrade   =   0
let g:solarized_bold      =   1
let g:solarized_underline =   1
let g:solarized_italic    =   1
let g:solarized_style     =   "dark"
let g:solarized_contrast  =   "normal"
" ------------------------------------------------

colorscheme solarized

function! ToggleBackground()
if (g:solarized_style=="dark")
    let g:solarized_style="light"
     colorscheme solarized
 else
     let g:solarized_style="dark"
     colorscheme solarized
 endif
endfunction
command! Togbg call ToggleBackground()
nnoremap <F5> :call ToggleBackground()<CR>
inoremap <F5> <ESC>:call ToggleBackground()<CR>a
vnoremap <F5> <ESC>:call ToggleBackground()<CR>

"
"-------------------------------------------------------------------------------
"  highlight paired brackets
"-------------------------------------------------------------------------------
highlight MatchParen ctermbg=34 guibg=lightyellow
highlight Search ctermfg=33

function! TestOrPmFile()
    echo expand( "%" )
    let ext = expand("%:e")
    if ext == "t" 
        let replaceext = ".pm"
    else 
        let replaceext = ".t"
    endif
    let testpath = expand("%:h") . "/"
    echo testpath
    let testpath = substitute( testpath, "lib", "test", "" )
    echo testpath
    let testpath = testpath . expand("%:t:r") . replaceext 
    echo testpath
    return testpath 
endfunction

nmap ,gtf :execute "new ". TestOrPmFile()<CR>

function! Prove ( verbose, taint )
    let testfile = TestOrPmFile()
    if ! exists("testfile") 
        echo 'No test file: '.testfile
    else 
        let s:params = "l"
        if a:verbose
            let s:params = s:params . "v"
        endif
        if a:taint
            let s:params = s:params . "Tt"
        endif
        let g:prove = system( "prove -" . s:params . " " . testfile )
        if v:shell_error
            echo "Tests failed:  ".v:shell_error
            cex g:prove
            copen
        else 
            echo "Tests all passed for: ".expand("%")
        endif
    endif
endfunction

function! Compile ()
    if ! exists("g:compilefile")
        let g:compilefile = expand("%")
    endif
    execute "!perl -wc -Ilib " . g:compilefile
endfunction

nmap ,t :call  Prove (0,0)<cr>
nmap ,tt :call  Prove (0,1)<cr>
nmap ,T :call  Prove (1,0)<cr>
nmap ,TT :call  Prove (1,1)<cr>
nmap ,v :call  Compile ()<cr>

"let perl_fold=1
"augroup filetypedetect
"    autocmd! BufNewFile,BufRead *.epl,*.phtml setf embperl
"augroup END

"autocmd BufNewFile,BufRead *.epl,*.phtml colorscheme embperl_yellow

"nnoremap <Leader>pm :call LoadPerlModule()<CR>
"function! LoadPerlModule()
"      execute 'e `perldoc -l ' . expand("<cWORD>") . '`'
"endfunction

"delete insert blanklines below/above ctrl/alt-j and ctrl/alt-k
"nnoremap <C-j> m`:+g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <C-k> m`:-g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <M-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <M-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>


noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

nnoremap mr :MRU<CR>
nnoremap cdc :CDC<CR>
nnoremap <leader>sw :set wrap<CR>
nnoremap <leader>nsw :set nowrap<CR>


map <C-J>  <C-W>j<C-W>_
map <C-K>  <C-W>k<C-W>_

set wmh=0

"-------------------------------------------------------------------------------
"  some additional hot keys
"-------------------------------------------------------------------------------
"     F2  -  write file without confirmation
"     F3  -  call file explorer Ex
"     F4  -  show tag under curser in the preview window (tagfile must exist!)
"     F6  -  list all errors           
"     F7  -  display previous error
"     F8  -  display next error   
"     F12 -  list buffers and edit n-th buffer
"-------------------------------------------------------------------------------
noremap   <silent> <F2>         :write<CR>
noremap   <silent> <F3>         :Explore<CR>
"noremap   <silent> <F4>         :execute ":ptag ".expand("<cword>")<CR>
"noremap   <silent> <F5>         :copen<CR>
noremap   <silent> <F6>         :cclose<CR>
noremap   <silent> <F7>         :cprevious<CR>
noremap   <silent> <F8>         :cnext<CR>
noremap            <F12>        :ls<CR>:edit #
"
inoremap  <silent> <F2>    <C-C>:write<CR>
inoremap  <silent> <F3>    <C-C>:Explore<CR>
"inoremap  <silent> <F4>    <C-C>:execute ":ptag ".expand("<cword>")<CR>
"inoremap  <silent> <F5>    <C-C>:copen<CR>
inoremap  <silent> <F6>    <C-C>:cclose<CR>
inoremap  <silent> <F7>    <C-C>:cprevious<CR>
inoremap  <silent> <F8>    <C-C>:cnext<CR>
inoremap           <F12>   <C-C>:ls<CR>:edit #
"
"-------------------------------------------------------------------------------
" comma always followed by a space
"-------------------------------------------------------------------------------
"inoremap  ,  ,<Space>
"
"-------------------------------------------------------------------------------
" autocomplete parenthesis, (brackets) and braces
"-------------------------------------------------------------------------------
"inoremap  (  ()<Left>
"inoremap  [  []<Left>
"inoremap  {  {}<Left>
"
"vnoremap  (  s()<Esc>P<Right>%
"vnoremap  [  s[]<Esc>P<Right>%
"vnoremap  {  s{}<Esc>P<Right>%
"
" surround content with additional spaces
"
vnoremap  )  s(  )<Esc><Left>P<Right><Right>%
vnoremap  ]  s[  ]<Esc><Left>P<Right><Right>%
vnoremap  }  s{  }<Esc><Left>P<Right><Right>%
"
"-------------------------------------------------------------------------------
" autocomplete quotes (visual and select mode)
"-------------------------------------------------------------------------------
xnoremap  '  s''<Esc>P<Right>
xnoremap  "  s""<Esc>P<Right>
xnoremap  `  s``<Esc>P<Right>
"
"-------------------------------------------------------------------------------
" The current directory is the directory of the file in the current window.
"-------------------------------------------------------------------------------
"if has("autocmd")
"  autocmd BufEnter * :lchdir %:p:h
"endif
"
"-------------------------------------------------------------------------------
" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
" Choose :bprevious or :bnext
"-------------------------------------------------------------------------------
"noremap  <silent> <s-tab>       :if &modifiable && !&readonly && 
"     \                      &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
"inoremap  <silent> <s-tab>  <C-C>:if &modifiable && !&readonly && 
"     \                      &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
"
"-------------------------------------------------------------------------------
" Leave the editor with Ctrl-q (KDE): Write all changed buffers and exit Vim
"-------------------------------------------------------------------------------
"nnoremap  <C-A>    :wqall<CR>
"
"
"===================================================================================
" VARIOUS PLUGIN CONFIGURATIONS
"===================================================================================
"
"-------------------------------------------------------------------------------
" perl-support.vim
"-------------------------------------------------------------------------------
"            
let g:Perl_MapLeader = ","
"
"-------------------------------------------------------------------------------
" plugin taglist.vim : toggle the taglist window
" plugin taglist.vim : define the tag file entry for Perl
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
noremap  <silent> <F11>       :TlistToggle<CR>
inoremap <silent> <F11>  <C-C>:TlistToggle<CR>
"
let tlist_perl_settings  = 'perl;c:constants;f:formats;l:labels;p:packages;s:subroutines;d:subroutines;o:POD'
"
