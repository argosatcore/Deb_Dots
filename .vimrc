
" ░█░█░▀█▀░█▄█
" ░▀▄▀░░█░░█░█
" ░░▀░░▀▀▀░▀░▀


" ------Global configs::
	set number relativenumber
	set spell spelllang=es,en_us  	
	set wildmenu
	set autoread wildmode=longest,list,full
	set mouse=a
	set cursorline
	syntax on


" ------Keybindings:

" 	Enter normal mode:
  	      imap fd <Esc>
  	      vmap fd <Esc> 

" 	Toggle Goyo: 
  	      nmap <Space> :Goyo <CR>
  	      
" 	Vim-like movement between splits:	
  	      nnoremap <C-h> <C-W>h
  	      nnoremap <C-j> <C-W>j
  	      nnoremap <C-k> <C-W>k
  	      nnoremap <C-l> <C-W>l  

" 	Primary selection and clipboard copy and paste:
  	      vnoremap <C-c> "+y
  	      map <C-p> "+P
  	      vnoremap <C-c> "*y :let @+=@*<CR>

" 	Move lines when in visual mode up or down:
  	      xnoremap K :move '<-2<CR>gv-gv
  	      xnoremap J :move '>+1<CR>gv-gv


" ------Plug-ins: 

	call plug#begin(expand('~/.vim/pluged'))
	Plug 'arcticicestudio/nord-vim' 
	Plug 'morhetz/gruvbox' 
	Plug 'crusoexia/vim-monokai'
	Plug 'junegunn/goyo.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'airblade/vim-gitgutter'
	Plug 'mcchrish/nnn.vim' 
	call plug#end()

	
" ------Colorschemes:
	
	"Nord 
		let g:nord_bold = '1'
		let g:nord_italic = '1'
		let g:nord_underline = '1'
		let g:nord_undercurl = '1'
		let g:nord_termcolor = '256'
		colorscheme nord 
	
	"Monokai 
"		let g:monokai_bold = '1'
"		let g:monokai_italic = '1'
"		let g:monokai_underline = '1'
"		let g:monokai_undercurl = '1'
"		let g:monokai_termcolor = '256'
"		colorscheme monokai

	" Gruvbox
"		let g:gruvbox_contrast_dark = 'hard'
"		let g:gruvbox_bold = '1'
"		let g:gruvbox_italic = '1'
"		let g:gruvbox_underline = '1'
"		let g:gruvbox_undercurl = '1'
"		let g:gruvbox_termcolor = '256'
"		colorscheme gruvbox 

	" Airline theme:
"		let g:airline_theme='base16_gruvbox_dark_hard'
"		let g:airline_theme='base16_nord'
"		let g:airline_theme='monochrome'
"		let g:airline_theme='base16_chalk'
		let g:airline_theme='bubblegum'

"	Inherit terminal's current backgground:

		hi! Normal ctermbg=NONE guibg=NONE 
		hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 


" ------Goyo config: 

	function! s:goyo_enter()
	set noshowmode
	set noshowcmd
	set nocursorline
	endfunction
	
	function! s:goyo_leave()
	set showmode
	set showcmd
	set cursorline
	hi! Normal ctermbg=NONE guibg=NONE 
	hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
	endfunction

	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave() 
