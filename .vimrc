
" ░█░█░▀█▀░█▄█
" ░▀▄▀░░█░░█░█
" ░░▀░░▀▀▀░▀░▀


" ------Global configs:
	set number relativenumber
	set spell spelllang=es,en_us  	
	set wildmenu
	set autoread wildmode=longest,list,full
	set mouse=a
	set cursorline cursorcolumn
	syntax on
	set showmatch
	set laststatus=2
	runtime! debian.vim

" ------Keybindings:

	"Enter normal mode:
  	      imap fd <Esc>
  	      vmap fd <Esc> 

	"Toggle Goyo: 
  	      nmap <Space> :Goyo <CR>
  	      
	"Vim-like movement between splits:	
  	      nnoremap <C-h> <C-W>h
  	      nnoremap <C-j> <C-W>j
  	      nnoremap <C-k> <C-W>k
  	      nnoremap <C-l> <C-W>l  

	"Primary selection and clipboard copy and paste:
  	      vnoremap <C-c> "+y
  	      map <C-p> "+P
  	      vnoremap <C-c> "*y :let @+=@*<CR>

	"Move lines when in visual mode up or down:
  	      xnoremap K :move '<-2<CR>gv-gv
  	      xnoremap J :move '>+1<CR>gv-gv


" ------Plug-ins: 

	call plug#begin(expand('~/.vim/pluged'))
	Plug 'arcticicestudio/nord-vim' 
	Plug 'junegunn/goyo.vim'
	Plug 'airblade/vim-gitgutter'
	call plug#end()

	
" ------Colorschemes:
	
	colorscheme nord 


" ------Status Line:
"
	au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
	au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
	hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
	let g:currentmode={
	    \ 'n'  : 'Normal',
	    \ 'no' : 'Normal·Operator Pending',
	    \ 'v'  : 'Visual',
	    \ 'V'  : 'V·Line',
	    \ "\<C-v>" : 'Visual·Block',
	    \ 's'  : 'Select',
	    \ 'S'  : 'S·Line',
	    \ '^S' : 'S·Block',
	    \ 'i'  : 'Insert',
	    \ 'R'  : 'Replace',
	    \ 'Rv' : 'V·Replace',
	    \ 'c'  : 'Command',
	    \ 'cv' : 'Vim Ex',
	    \ 'ce' : 'Ex',
	    \ 'r'  : 'Prompt',
	    \ 'rm' : 'More',
	    \ 'r?' : 'Confirm',
	    \ '!'  : 'Shell',
	    \ 't'  : 'Terminal'
	    \}

	set statusline=
	set statusline+=\ \ %{toupper(g:currentmode[mode()])}\ \ 
	set statusline+=%#CursorLineNr#
	set statusline+=%1*\ %<%F%m%r%h%w
	set statusline+=\ [%{&spelllang}\]
	set statusline+=\ 
	set statusline+=%#PmenuSel#
	set statusline+=\ %y
	set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
	set statusline+=\[%{&fileformat}\]
	set statusline+=\ %r
	set statusline+=%#CursorLineNr#
	set statusline+=%1*\ ln:\ %02l/%L\ (%p%%)\   
	set statusline+=\ [col:%c]
	set statusline+=%=
	set statusline+=%0*\ %n\ 

" ------Goyo config: 

	function! s:goyo_enter()
	set nocursorline nocursorcolumn
	endfunction
	
	function! s:goyo_leave()
	hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
	set cursorline cursorcolumn
	endfunction

	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave() 
