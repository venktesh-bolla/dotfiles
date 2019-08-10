" Vim TeamF1 Tags File
" Language:     C
" Maintainer:   Narayana Prasad
" Last Change:  2005 Oct 23
" Description:  Derived from original Vim _vimrc file
" Important:    Look for "Uncomment if needed." for potentially useful options

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
if !has("unix")
    source $VIMRUNTIME/mswin.vim
else
    "nmap <C-V> "+gP
    omap <C-V> "+gP
endif

if !has("unix")
    set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
  call EnterDiffMode()
endfunction

if !has("unix") || (v:progname != "gvim" && v:progname != "gvim.exe")
    " Prasad: cool colorscheme. Use it if you like it.
    " Uncomment if needed.
 "let xterm16_colormap    = 'soft'    " 'standard' is default
    let xterm16_colormap    = 'soft'    " 'standard' is default
    let xterm16_brightness  = '245'     " 'high' is default
    colorscheme default
    " Prasad: Custom colouring. You may not need these
    " ultra bright for laptop
    " Uncomment if needed.
    hi Normal guifg=#ffffff
    " better color for folds - depends on colorscheme
    hi Folded guifg=#00ff00
endif

" Prasad: uncomment following line to override mswin behaviour. Do this only 
" if you hate Microsoft.
" Uncomment if needed.
"behave xterm
"set columns=80
"if v:progname == "gvim" || v:progname == "gvim.exe"
"if has("unix")
"    set lines=42
"else
"    set lines=50
"endif
"else
"    set lines=24
"endif

set nobackup

" Prasad: This is a good font to view C code(for ex: 1,l,I and 0,O are all
" different and appear clearly with this font). You have to download it.
if has("unix")
    set guifont=Andale\ Mono\ 11
else " windows
    set guifont=Andale_Mono:h9:cANSI
endif
"set shiftwidth=4
"set tabstop=4
"set expandtab
set textwidth=80
set formatoptions+=t
" set expandtab
" set cinoptions={1s,f1s,^-s,(0,=0,l1
function VxVi()
    set expandtab
    set cinoptions={1s,f1s,^-s,(0,=0,l1
endfunction

" Prasad: Everytime the buffer is changed, the directory also changes. 
" Uncomment if needed.
" au  BufEnter *   execute ":lcd " . expand("%:p:h")

" Change window settings so that they are suited for diffing 2 files
function! EnterDiffMode() " {{{
    set columns=143
    set diff
    set scrollbind
    set scrollopt+=hor
    set nowrap
    set foldmethod=diff
    set foldcolumn=2
endfunction " }}}

" back to normal single file view settings
function! ExitDiffMode() " {{{
    set columns=80
    set nodiff
    set wrap
    set foldmethod=marker
    set foldcolumn=0
endfunction " }}}

" Prasad: Mappings to toggle DiffMode
" Uncomment if needed.
map <F1> :call EnterDiffMode()<CR><C-w>=
map <C-F1> :call ExitDiffMode()<CR>

if !has("unix")
    " Ctrl-A can now used to increment numbers rather than select text
    " Uncomment if needed.
    unmap <C-A>
endif

" Prasad: This sets the default folding method to marker based
set foldmethod=marker

" no need to load this script
let g:loaded_lhVimSpell_vim = 1

" mappings for jumping to start/end of function/block
map [[ 99[{
map ]] 99]}
map {{ [{
map }} ]}

"For vim commands(:) tab work like bash prompt.
set wildmenu

" *.h files should be recognized as C files
let c_syntax_for_h = 1

" highlight 80 colum lines
au BufNewFile,BufRead *.c,*.h exec 'match UnderLine /\%>' .  80 . 'v.\+/'

" dont scan included files for word completion
set cpt-=i

" get currpath as prefix for :e command
cmap %/ <C-R>=expand("%:p:h")."/"<CR>

" for xml indentation
map %i :%s/></>\r</g<CR>:0<CR>=:$<CR>

" highlight current line in bold
set cursorline
hi CursorLine term=bold cterm=bold gui=bold guibg=black
hi UnderLine term=underline cterm=underline gui=underline
au BufNewFile,BufRead *.dox setfiletype doxygen
highlight Search ctermbg=yellow 
highlight Search ctermfg=red

set mouse=

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	
" Function to autoload cscope.out
set cst
set csprg=/usr/bin/cscope
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()
set ls=2
" Below Vim will look for tags file everywhere starting from the current directory up to the root.
set tags=tags;/

" vim - to hilight full file syntax in a huge file
autocmd BufEnter * :syntax sync fromstart
":syntax sync fromstart
"autocmd BufEnter * :syntax sync minlines=200

"" Turning On Whitespace Characters
"" eol - Character to show at the end of each line.
"" tab - Two characters to be used to show a tab.
"" trail - Character to show for trailing spaces.
"" extends - Character to show in the last column when the line continues beyond
"" the right of the screen.
"" precedes - Character to show in the first column when the line continues
"" beyond the left of the screen.
"" conceal - Character to show in place of concealed text, when conceallevel is
"" set to 1.
"" nbsp - Character to show for a space.
"set listchars=eol:$,nbsp:_,tab:>-,trail:~,extends:>,precedes:<
"set list
"" For not showing listed options
"set nolist
