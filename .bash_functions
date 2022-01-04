#░█▀▄░█▀█░█▀▀░█░█░░░█▀▀░█░█░█▀█░█▀▀░▀█▀░▀█▀░█▀█░█▀█░█▀▀
#░█▀▄░█▀█░▀▀█░█▀█░░░█▀▀░█░█░█░█░█░░░░█░░░█░░█░█░█░█░▀▀█
#░▀▀░░▀░▀░▀▀▀░▀░▀░░░▀░░░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀


# ------Make a new directory and cd into it immediately:
	mkcd() {
		mkdir "$1"
		cd "$1"
	}


# ------Create quick notes on random topics:
 	jot() {
 		touch ~/Desktop/Notes/"$1"
		nvim ~/Desktop/Notes/"$1"
 	}


# ------Kill processes in a fuzzy way:
	fkill() {
	  local pid
	  pid="$(
	    ps -ef \
	      | sed 1d \
	      | fzf -e -m --cycle --reverse \
	      | awk '{print $2}'
	  )" || return
	  kill -"${1:-9}" "$pid" &> /dev/null
	}


# ------Browse and open notes quickly:
	fjot() {
		cd ~/Desktop/Notes/
		note="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="head -$LINES {}" --bind="space:toggle-preview" --preview-window=wrap:hidden)"
			if [ -n "$note" ]; then	
			nvim "$note"
			fi
		cd
	}


# ------Use fzf as a file opener:
	fo() {
		file="$(fdfind -t f -H | fzf --reverse --preview="head -$LINES {}" --bind="space:toggle-preview" --preview-window=wrap:hidden)"
		if [ -n "$file" ]; then
			mimetype="$(xdg-mime query filetype $file)"
			default="$(xdg-mime query default $mimetype)"
		    		if [[ "$default" == "nvim.desktop" ]]; then
		        		nvim "$file"
		    		else
		        		&>/dev/null xdg-open "$file" & disown; exit
		    		fi
		fi
	}


# ------Use fzf to move between directories:
	fd() {
		cd "$(fdfind -t d -H | fzf --cycle --reverse --color=border:#FFFFFF --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=wrap:hidden)" && clear
	}


# ------Give Apt fuzzy-like package management abilities:
	debcrawler() {
		sudo apt-get update && sudo apt-get install $(apt-cache pkgnames | fzf --multi --color=border:#FFFFFF --cycle --reverse --preview "apt-cache show {1}" --preview-window=:57%:wrap:hidden --bind=space:toggle-preview)
	}


# -----Fuzzy find packages with Apt:
	lookapt() {
	apt search $(apt-cache pkgnames | fzf --multi --color=border:#FFFFFF  --cycle --reverse --preview "apt-cache show {1}" --preview-window=:80%:wrap:hidden --bind=space:toggle-preview)
	}


# ------Clean system:
	debclean() {
		sudo apt-get clean
		sudo apt-get autoclean
		sudo apt-get autoremove --purge 
	}


# ------Wayland's color picker:
	waypick() {
		grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-
	}


# ------Update Deb_Dots:
	debgit() {
		git add -u
		git commit -m "$1"
		git push -u
	}

# ------Update Blender:
	buildblend() {
		cd
		cd ~/blender-git/blender
		make update
		make
	}


# ------Count files or directories in directory:
	count() {
	    # Usage: count /path/to/dir/*
	    #        count /path/to/dir/*/
	    [ -e "$1" ] \
	        && printf '%s\n' "$#" \
	        || printf '%s\n' 0
	}
