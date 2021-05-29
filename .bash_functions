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
	fdfind -t f -H -I | fzf -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-  
	exit
	}


# ------Use fzf to move between directories
	fzd() {
	cd && cd "$(fdfind -t d -H | fzf --cycle --reverse --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=wrap:hidden)" && clear
	}


# ------Give Apt fuzzy-like package management abilities:
	debcrawler() {
	sudo apt update && sudo apt install $(apt-cache pkgnames | fzf --multi --cycle --reverse --preview "apt-cache show {1}" --preview-window=:57%:wrap:hidden --bind=space:toggle-preview)
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
