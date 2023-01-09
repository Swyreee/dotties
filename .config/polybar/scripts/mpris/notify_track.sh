#!/bin/bash

PLAYER=$(cat $HOME/.config/polybar/.curplayer.log)
TITLE=$(playerctl -p $PLAYER metadata title 2> /dev/null)
ARTIST=$(playerctl -p $PLAYER metadata artist 2> /dev/null)
ART_URL=$(playerctl -p $PLAYER metadata mpris:artUrl 2> /dev/null)

if [[ -z $TITLE ]]
then
    TITLE="Unknown title"
fi

if [[ -z $ARTIST ]]
then
    ARTIST="Unknown artist"
fi

POS=$(playerctl -p $PLAYER position)
LEN=$(playerctl -p $PLAYER metadata mpris:length)
PER=$(echo "scale=1;$POS / ($LEN / 100000000)" | bc -l)
PER=$(echo "$PER" | python -c "print(int(float(input())))")
echo $PER

if ! [[ -z $ART_URL ]]
then
    wget $ART_URL && \
    notify-send "$TITLE" "$ARTIST" -i $HOME/hqdefault.jpg \
        -u low \
        -h int:value:$PER \
        -h string:synchronous:playerctrl
    sleep 5
    rm hqdefault.jpg
else
    notify-send "$TITLE" "$ARTIST" -i $HOME/dotties/assets/desktop.png \
        -u low \
        -h int:value:$PER \
        -h string:synchronous:playerctrl
fi
