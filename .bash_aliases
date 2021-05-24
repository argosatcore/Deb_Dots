#░█▀▄░█▀█░█▀▀░█░█░░░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▄░█▀█░▀▀█░█▀█░░░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█
#░▀▀░░▀░▀░▀▀▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀


# ------Handy aliases:
	
	#General use:
	alias ll='ls -alF'
	alias la='ls -A'
	alias li='ls -lih'
	alias l='ls -CF'
	alias c='clear'
	alias rm='rm -I'
	alias poweroff='systemctl poweroff'
	alias reboot='systemctl reboot'
	alias suspend='systemctl suspend'
	alias v='nvim'
	alias t='tmux'
	alias n='nnn'
	alias rec='wf-recorder'
	alias vrc='nvim ~/.vimrc'
	alias brc='nvim ~/.bashrc'
	alias prc='nvim ~/.profile'
	alias irc='nvim ~/.inputrc'
	alias barc='nvim ~/.bash_aliases'
	alias wrcss='nvim .config/waybar/style.css'
	alias wrc='nvim .config/waybar/config'
	alias src='nvim ~/.config/sway/config'
	alias v='nvim'
	alias f='xdg-open "$(fzf --multi --cycle --reverse --preview "cat {1}" --preview-window=:57%:wrap:hidden --bind=ctrl-a:toggle-preview)"; exit'
	alias t='tmux'
	alias ws='watch sensors'
	alias n='nnn'
	alias c='clear'
	alias colorp='grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-'
	alias configheader='toilet -f pagga'
	alias fp='ps aux | fzf'
	alias note='nvim Desktop/Notes/Notes.txt'

	#Apt:
	alias aptdate='sudo apt update'
	alias aptgradable='apt list --upgradable'
	alias aptgrade='sudo apt upgrade'
	alias lookapt='apt search'
	alias throwapt='sudo apt remove'
	alias capture='sudo apt install'
	alias debcount='apt-cache search "" | wc -l'
	alias debcrawler='apt-cache pkgnames | fzf --multi --cycle --reverse --preview "apt-cache show {1}" --preview-window=:57%:wrap:hidden --bind=space:toggle-preview | xargs -ro sudo apt install' 
	alias debxile='apt list --installed | sort | cut --delimiter " " --fields 1 | fzf --multi --cycle --reverse | xargs -r sudo apt remove'

	#Systemd:
	alias sd-all='systemctl list-units --type=service'
	alias sd-active='systemctl list-units --type=service --state=active'
	alias sd-running='systemctl list-units --type=service --state=running '
	alias sd-timer='systemctl list-timers'

	#Git
	alias gpull='git pull'
	alias gpush='git push -u'
	alias gadd='git add -u'

