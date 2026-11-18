#!/bin/bash
. "${CONFIG_DIR:-$HOME/.config/sketchybar}/icons.sh"

settings=$(osascript -e 'get volume settings')
vol=${INFO:-$(echo "$settings" | sed -E 's/.*output volume:([0-9]+).*/\1/')}
case "$settings" in *"output muted:true"*) vol=0 ;; esac

if [ "$vol" -eq 0 ]; then icon=$ICON_VOL_MUTE
elif [ "$vol" -lt 34 ]; then icon=$ICON_VOL_LOW
elif [ "$vol" -lt 67 ]; then icon=$ICON_VOL_MED
else icon=$ICON_VOL_HIGH
fi

sketchybar --set "$NAME" icon="$icon" label="$vol%"
