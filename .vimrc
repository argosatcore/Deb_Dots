"__     ___                __  _   _                 _             
"\ \   / (_)_ __ ___      / / | \ | | ___  _____   _(_)_ __ ___    
" \ \ / /| | '_ ` _ \    / /  |  \| |/ _ \/ _ \ \ / / | '_ ` _ \   
"  \ V / | | | | | | |  / /   | |\  |  __/ (_) \ V /| | | | | | |_ 
"   \_/  |_|_| |_| |_| /_/    |_| \_|\___|\___/ \_/ |_|_| |_| |_(_)
"                                                                  


" Estimado Lector: Este archivo de configuración para el editor de texto conocido como Vim es liberado al dominio público para ser modificado según su conveniencia. Aunque me adjudiqué la autoría de este documento, debo confesar que esto es, en parte, una mentira. Si bien el acomodo, la inclusión -y la exclusión- de ciertos parámetros de configuración es artificio mío, el conocimiento necesario para lograr armar este documento fue tomado de otros escritores que, ahora como yo, decidieron, de manera desinteresada, el poner a la disposición de otros parte del bagaje acumulado en el tiempo en relación con este singular programa. Espero que les sea tan provechoso como lo ha sido conmigo, sino es que más. 

" -------Atajos del teclado:

" Mapaer 'ff' para ser utilizada como 'Esc'. Esto permite el salir de los modos 'Insert' y 'Visual'  para entrar en el modo 'Normal'.
	imap fd <Esc>
	vmap fd <Esc> 

" Mapear F4 para entrar y salir de Goyo 
	nmap <Space> :Goyo <CR>

"Mapear F5 para utilizar vifm de modo que cuando este se abra, lo haga siempre desde el directorio actual.
	map <F5> :EditVifm .<CR>
	
" Remapear las teclas para moverse entre splits de acuerdo con las teclas para moverse en vim (h-j-k-l):
	nnoremap <C-h> <C-W>h
	nnoremap <C-j> <C-W>j
	nnoremap <C-k> <C-W>k
	nnoremap <C-l> <C-W>l  

" Remapeo de los comandos para copiar y pegar. Gracias a la instalación de gvim (mediante el comando 'apt install vim-gtk' en distribuciones derivadas de Debian), ahora Vim tiene acceso al clipboard del sistema, habilitando el copiado y pegado de texto entre Vim y las distintas aplicaciones del sistema operativo. Cabe mencionar que, desde que se instaló este último programa, se hizo presente un bug con el esquema de color 'gruvbox': el tema claro se instauró como el default y no permite se sobreescrito con otro tema. Sin embargo, este bug parece ser válido sólo para Vim, ya que al utilizar a otra de sus encarnaciones, NeoVim, la paleta oscura de gruvbox funciona sin problema.
	vnoremap <C-c> "+y
	map <C-p> "+P

"Para copiar tanto en el clipboard y en la selección primaria.
	vnoremap <C-c> "*y :let @+=@*<CR>

" Permitir el mover líneas seleccionadas hacia arriba y hacia abajo en el modo visual. Esencialmente, permite el desmontaje y remontaje de líneas de texto a lo largo del documento según el criterio del editor de turno (con 'editor' me refiero, claro está, a la persona que maneja el programa de edición y no al programa en sí mismo, ja). 
	xnoremap K :move '<-2<CR>gv-gv
	xnoremap J :move '>+1<CR>gv-gv


" -------Configuraciones básicas en la exposición de información:

" Habilitar el mostrar los números de línea y el número de línea relativo por default.
	set number relativenumber

" Configurar los diccionarios de vim para inglés y español.
	set spell spelllang=es,en_us  	

" Habilitar autocompletado en la barra de estado.
	set wildmenu
	set autoread wildmode=longest,list,full

"Soporte para mouse en Vim.
	set mouse=a

" Resaltar la línea en donde se encuentra posicionado el cursor.
	set background=dark cursorline
"	highlight! link CursorLine Visual

" Detectar la sintaxis de un determinado tipo de documento, indicado en la extensión del archivo mismo.
	syntax on 


" -------Plug-ins: 

" Lista de plug-ins.
	call plug#begin(expand('~/.vim/pluged'))
	Plug 'arcticicestudio/nord-vim' "Instala y habilita el uso de la paleta 'nord' como tema de Vim.
	Plug 'morhetz/gruvbox' "Instala y habilita el uso de la paleta 'gruvbox' como tema de Vim. 
	Plug 'junegunn/goyo.vim' "Da un formato más legible y libre de distracciones para escribir en Vim.
	Plug 'vim-airline/vim-airline' "Habilita la barra de estado llamada airline.
	Plug 'vim-airline/vim-airline-themes' "Permite que la barra de estado 'airline' herede la paleta del tema que Vim esté utilizando.
	Plug 'airblade/vim-gitgutter' "Permite el rastreo de cambios en los archivos que estén vinculados a Github.
	Plug 'mcchrish/nnn.vim' " Permite abrir el gestor de archivos 'nnn' dentro de vim.
	call plug#end()

	
" -------Apariencia visual de Vim:

" Esquema de color, para escoger un tema remueva las comillas de citación del tema a escoger.
	"colorscheme nord

	" Gruvbox
		let g:gruvbox_contrast_dark = 'hard'
		let g:gruvbox_bold = '1'
		let g:gruvbox_italic = '1'
		let g:gruvbox_underline = '1'
		let g:gruvbox_undercurl = '1'
		let g:gruvbox_termcolor = '256'
		colorscheme gruvbox 

" Cambiar esquema de color
"	map <F1> :colorscheme gruvbox<CR>

" Transparencia
	hi! Normal ctermbg=NONE guibg=NONE 
	hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
"	highlight Visual term=reverse cterm=reverse ctermbg=Black ctermfg=NONE guibg=NONE guifg=NONE gui=reverse 

" Tema usado en airline:
	let g:airline_theme='base16_gruvbox_dark_hard'
"	let g:airline_theme='base16_nord'
"	let g:airline_theme='monochrome'

" Configuración de Goyo 
	function! s:goyo_enter()
	set noshowmode
	set noshowcmd
	set nocursorline
"	highlight! link CursorLine Visual
	hi! Normal ctermbg=NONE guibg=NONE 
	hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
"	highlight Visual term=reverse cterm=reverse ctermbg=Black ctermfg=NONE guibg=NONE guifg=NONE gui=reverse 
	endfunction
	
	function! s:goyo_leave()
	set showmode
	set showcmd
	set cursorline
"	highlight! link CursorLine Visual
	hi! Normal ctermbg=NONE guibg=NONE 
	hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE
"	highlight Visual term=reverse cterm=reverse ctermbg=Black ctermfg=NONE guibg=NONE guifg=NONE gui=reverse 
	endfunction


	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave() 
