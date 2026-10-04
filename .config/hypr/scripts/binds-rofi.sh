#!/bin/bash
binds=$(hyprctl binds -j)
binds_parsed=$(echo "$binds" | jq -r '.[] | " \(.description) \t \(.key) "' | sort)
picked_bind=$(echo "$binds_parsed" | rofi -dmenu -display-columns 1 -p binds)
if [[ -z "$picked_bind" ]]; then
	exit
fi
notify-send "binds" "$picked_bind"
