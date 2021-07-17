
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


" ------Status Line
	set statusline=
	set statusline+=%#CursorLineNr#
	set statusline+=%=
	set statusline+=\ %f
	set statusline+=\ [%{&spelllang}\]
	set statusline+=\ 
	set statusline+=%#PmenuSel#
	set statusline+=\ %y
	set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
	set statusline+=\[%{&fileformat}\]
	set statusline+=\ %r
	set statusline+=%#Difftext#
	set statusline+=\ %p%%
	set statusline+=\ ln:%l/%L
	set statusline+=\ [col:%c]


" ------Goyo config: 

	function! s:goyo_enter()
	set noshowmode
	set noshowcmd
	set nocursorline nocursorcolumn
	endfunction
	
	function! s:goyo_leave()
	set showmode
	set showcmd
	set cursorline cursorcolumn
	endfunction

	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave() 
