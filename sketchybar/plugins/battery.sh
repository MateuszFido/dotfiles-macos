#!/bin/bash
. "${CONFIG_DIR:-$HOME/.config/sketchybar}/icons.sh"

info=$(pmset -g batt)
pct=$(echo "$info" | grep -Eo '[0-9]+%' | head -1 | tr -d %)
[ -z "$pct" ] && exit 0

if echo "$info" | grep -q 'AC Power'; then icon=$ICON_BAT_CHARGING
elif [ "$pct" -gt 80 ]; then icon=$ICON_BAT_100
elif [ "$pct" -gt 55 ]; then icon=$ICON_BAT_75
elif [ "$pct" -gt 30 ]; then icon=$ICON_BAT_50
elif [ "$pct" -gt 10 ]; then icon=$ICON_BAT_25
else icon=$ICON_BAT_0
fi

sketchybar --set "$NAME" icon="$icon" label="$pct%"
