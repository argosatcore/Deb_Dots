#░█▀▄░█▀█░█▀▀░█░█░░░█▀▀░█░█░█▀█░█▀▀░▀█▀░▀█▀░█▀█░█▀█░█▀▀
#░█▀▄░█▀█░▀▀█░█▀█░░░█▀▀░█░█░█░█░█░░░░█░░░█░░█░█░█░█░▀▀█
#░▀▀░░▀░▀░▀▀▀░▀░▀░░░▀░░░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀


# ------Make a new directory and cd into it immediately:
	mkcd() {
	    mkdir "$1"
	    cd "$1"
	}


# ------Use fzf as a file opener:
	fo() {
	xdg-open "$(fzf --multi --cycle --reverse --preview "cat {1}" --preview-window=:57%:wrap:hidden --bind=ctrl-a:toggle-preview)"; exit	
	}


# ------Use fzf to move between directories
	fzd() {
	cd "$(fdfind -t d -H | fzf --cycle --reverse --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=wrap:hidden)" && clear
	}


# ------Give Debian fuzzy-like package management abilities:
	debcrawler() {
	sudo apt update 
	$(apt-cache pkgnames | fzf --multi --cycle --reverse --preview "apt-cache show {1}" --preview-window=:57%:wrap:hidden --bind=space:toggle-preview | xargs -ro sudo apt install)
	}


# ------Clean system:
	debclean() {
	sudo apt clean
	sudo apt autoclean
	sudo apt autoremove
	}


# ------Wayland's color picker:
	waypick() {
	grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-
	}
