#!/bin/bash
binds=$(hyprctl binds -j)
binds_parsed=$(echo "$binds" | jq -r '.[] | "\(.description) (\(.key))"' | sort)
picked_bind=$(echo "$binds_parsed" | fuzzel --dmenu --prompt='binds: ')
if [[ -z "$picked_bind" ]]; then
	exit
fi
notify-send "binds" "$picked_bind"
