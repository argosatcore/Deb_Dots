" ░█░█░▀█▀░█▄█
" ░▀▄▀░░█░░█░█
" ░░▀░░▀▀▀░▀░▀


" ------Global configs:

	filetype plugin on
	let g:ShiftTabDefaultCompletionType = "<C-X><C-O>"
	runtime! debian.vim
	set autoread wildmode=longest,list,full
	set background=dark
	set complete+=k
	set cursorline cursorcolumn
	set dictionary+=/usr/share/dict/words
	set hlsearch
	set ignorecase
	set incsearch
	set joinspaces
	set laststatus=2
	set list
	set listchars=tab:▸\ ,eol:¬
	set mouse=a
	set nocompatible
	set noshowmode
	set nostartofline
	set number relativenumber
	set omnifunc=syntaxcomplete#Complete
	set showcmd
	set showmatch
	set spell spelllang=es,en_us
	set spellsuggest=10
	set splitbelow
	set splitright
	set wildmenu
	set wrapmargin=0
	set wrap
	"Necessary order, ignore the alphabetical order for the next three lines:
	set linebreak
	set textwidth=0
	set display=lastline
	"End of alphabetical exception.
	syntax on


" -----Global autocommands:

	"Jump to the last position when reopening a file:
		au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" ------Keybindings:

	"Set space as the leader key:
		let mapleader = "\<space>"

	"Return to normal mode:
		imap fd <Esc>
		vmap fd <Esc>

	"Toggle Goyo on/off:
		map <leader>g :Goyo \| set linebreak<CR>

	"Vim-like movement between splits:
		nnoremap <C-h> <C-W>h
		nnoremap <C-j> <C-W>j
		nnoremap <C-k> <C-W>k
		nnoremap <C-l> <C-W>l

	"Resize splits with arrow keys:
		nnoremap <Left>  :vertical resize +2<CR>
		nnoremap <Right> :vertical resize -2<CR>
		nnoremap <Down> :resize -2<CR>
		nnoremap <Up> :resize +2<CR>

	"Move between buffers:
		nmap <Leader>[ :bprev<CR>
		nmap <Leader>] :bnext<CR>

	"Primary selection and clipboard copy and paste:
		vnoremap <C-c> "+y
		map <C-p> "+P
		vnoremap <C-c> "*y :let @+=@*<CR>

	"Move lines when in visual mode up or down:
		xnoremap K :move '<-2<CR>gv-gv
		xnoremap J :move '>+1<CR>gv-gv

	"Insert citation characters for markdown notes, move three characters
	"to the left and then switch to insert mode:
		nnoremap <Leader>n a^[[@,].]<Esc><Left><Left><Left>i

	"Use vim's built-in file browser:
		inoremap <C-b> <Esc>:Lex<CR>:vertical resize 30<CR>
		nnoremap <C-b> <Esc>:Lex<CR>:vertical resize 30<CR>

	"Clear higlighting:
		nnoremap \\ :noh<cr> "

	" Trim trailing spaces
		nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>


" ------Plug-ins:

	"Plug-ins list:
		call plug#begin(expand('~/.vim/pluged'))
		Plug 'airblade/vim-gitgutter'
		Plug 'jalvesaq/zotcite'
		Plug 'junegunn/goyo.vim'
		Plug 'junegunn/fzf'
		Plug 'junegunn/fzf.vim'
		Plug 'michal-h21/vim-zettel'
		Plug 'vimwiki/vimwiki'
		call plug#end()

	"fzf.vim
		nmap <Leader>f :Files<CR>

	"vim-zetterl
		let g:nv_search_paths = ['$HOME/Desktop/vimwiki/']

	"Colorscheme:
	"
        if has('termguicolors')
		set termguicolors
		let &t_8f = "\<Esc>[38:2::%lu:%lu:%lum"
		let &t_8b = "\<Esc>[48:2::%lu:%lu:%lum"
        endif
	let g:solarized_termtrans = '1'
	let g:solarized_italics = '0'
        colorscheme solarized8

		"Status line colors:
			au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
			au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
			hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

		"Status modes:
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

		"Status modules:
			set statusline=
			set statusline+=%#WildMenu#
			set statusline+=\ \ %{toupper(g:currentmode[mode()])}\
			set statusline+=%1*\ %<%F%m%r%h%w\ [%{&spelllang}\]\
			set statusline+=%#CursorLineNr#
			set statusline+=\ %y\ %{&fileencoding?&fileencoding:&encoding}\
			set statusline+=%1*\ ln:\ %02l/%L\ (%p%%)\ [col:%c]
			set statusline+=%=
			set statusline+=%#WildMenu#
			set statusline+=\%0*\ %n\

	"Goyo:
		let g:goyo_width=90
		let g:goyo_height=90

		function! s:goyo_enter()
		set cursorline nocursorcolumn
		endfunction

		function! s:goyo_leave()
		set cursorline cursorcolumn
		hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
		endfunction

		autocmd! User GoyoEnter nested call <SID>goyo_enter()
		autocmd! User GoyoLeave nested call <SID>goyo_leave()

	"Vimwiki:
		let g:vimwiki_list = [{'path': '~/Desktop/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'auto_diary_index': 1, 'auto_generate_links': 1, 'auto_generate_tags': 1, 'auto_tags': 1}]
		let g:vimwiki_global_ext = 0

	"Zotcite:
		let zotcite_filetypes = ['markdown', 'pandoc', 'rmd', 'vimwiki']
