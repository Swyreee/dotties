#!/bin/bash
eww="eww -c $HOME/.config/eww/hosf/"

$eww close mpris

if [[ ! $? -eq 0 ]]
then
    pkill -9 -f media_info
    $HOME/.config/eww/hosf/scripts/media_info.sh &
    $eww open mpris
fi
