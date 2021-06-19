#!/bin/sh

# Get available windows
windows=$(swaymsg -t get_tree | jq -r '
	recurse(.nodes[]?) |
		recurse(.floating_nodes[]?) |
		select(.type=="con"), select(.type=="floating_con") |
			" " + .app_id + ": " + .name' | sed '/ $/d;s/\ ://;s/^\ //')

# Find out how many lines wofi needs
length=$(echo "$windows" | wc -l)

# Select window with wofi
selected=$(printf %s "$windows" | wofi --dmenu --insensitive --lines "$length" -p "Switch to:")

# Make it work with Xwayland or Wayland apps
case "$selected" in
	*:\ * )
		theapp=$(printf '%s' "$selected" | cut -d: -f1 )
		thename=$(printf '%s' "$selected" | cut -d: -f2- | sed 's/\ //' )
		identity=$(swaymsg -t get_tree | jq -r '
			recurse(.nodes[]?) |
				recurse(.floating_nodes[]?) |
				select(.app_id=="'"$theapp"'" and .name=="'"$thename"'") |
					(.id | tostring)')
		;;
	* )
		identity=$(swaymsg -t get_tree | jq -r '
			recurse(.nodes[]?) |
				recurse(.floating_nodes[]?) |
				select(.name=="'"$selected"'") |
					(.id | tostring)')
		;;
esac

# Tell sway to focus said window
swaymsg [con_id="$identity"] focus
