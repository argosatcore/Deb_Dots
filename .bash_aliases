#░█▀▄░█▀█░█▀▀░█░█░░░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀
#░█▀▄░█▀█░▀▀█░█▀█░░░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█
#░▀▀░░▀░▀░▀▀▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀


	#General use:
	alias barc='nvim ~/.bash_aliases'
	alias brc='nvim ~/.bashrc'
	alias bb='v ~/Debstrap/Imposition_tips.md'
	alias c='clear'
	alias configheader='toilet -f pagga'
	alias cp="rsync --archive --human-readable --progress --verbose --whole-file"
	alias dst='nvim ~/Debstrap/debstrap.sh'
	alias duh="du -h -d 0 [^.]*"
	alias fp='ps aux | fzf'
	alias frc='nvim ~/.bash_functions.sh'
	alias gnomebu='dconf dump / > ~/Debstrap/full-desktop-backup'
	alias gnomebusid='dconf dump / > ~/Debstrap/full-desktop-backup-sid'
	alias gnomelb='dconf load / < ~/Debstrap/full-desktop-backup'
	alias gnomelsidb='dconf load / < ~/Debstrap/full-desktop-backup-sid'
	alias irc='nvim ~/.inputrc'
	alias l='ls -CF'
	alias la='ls -A'
	alias lg='bash ~/.local/bin//lsix'
	alias li='ls -lih'
	alias ll='ls -alF'
	alias m='tmux -f ~/.2tmux.conf'
	alias poweroff='systemctl poweroff'
	alias prc='nvim ~/.profile'
	alias reboot='systemctl reboot'
	alias rec='wf-recorder'
	alias rm='rm -I'
	alias suspend='systemctl suspend'
	alias src='nvim ~/.config/sway/config'
	alias t='tmux'
	alias tree='tree -C'
	alias u="cd ../"
	alias u2="cd ../../"
	alias u3="cd ../../../"
	alias u4="cd ../../../../"
	alias u5="cd ../../../../../"
	alias u6="cd ../../../../../../"
	alias u7="cd ../../../../../../../"
	alias u8="cd ../../../../../../../../"
	alias v='nvim'
	alias vrc='nvim ~/.vimrc'
	alias wrc='nvim .config/waybar/config'
	alias wrcss='nvim .config/waybar/style.css'
	alias ws='watch sensors'
	alias ytopus='youtube-dl --add-metadata -i -x -f bestaudio/best'
	alias yt='yt-dlp --embed-metadata -i -x -f bestaudio/best'

	#Apt:
	alias aptdate='sudo apt update'
	alias aptgradable='apt list --upgradeable'
	alias aptgrade='sudo apt upgrade'
	alias capture='sudo apt install'
	alias debcount='apt-cache search "" | wc -l'
	alias debup='bash .local/bin/update-debian.sh'
	alias throwapt='sudo apt remove'
	alias sidup='bash .local/bin/update-sid.sh'

	#Systemd:
	alias sd-active='systemctl list-units --type=service --state=active'
	alias sd-all='systemctl list-units --type=service'
	alias sd-files='systemctl list-unit-files --type=service'
	alias sd-running='systemctl list-units --type=service --state=running '
	alias sd-timer='systemctl list-timers'

	#Git
	alias gadd='git add -u'
	alias gcom='git commit -m'
	alias gpull='git pull'
	alias gpush='git push -u'
