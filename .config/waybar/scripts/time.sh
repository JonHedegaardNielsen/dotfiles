#!/bin/bash

hour=$(date +%H)
min=$(date +%M)
icon=""
if [ $hour -ge 21 ]; then
    icon=" "
elif [ $hour -ge 18 ]; then
    icon=" "
elif [ $hour -ge 12 ]; then
    icon=" "
elif [ $hour -ge 9 ]; then
    icon=" "
elif [ $hour -ge 6 ]; then
    icon=" "
else 
    icon=" "
fi
echo "{\"text\" : \"$icon$hour:$min\"}"

