#!/bin/bash
# Connected = Wi-Fi interface has an IP. (macOS hides the SSID without Location access.)
. "${CONFIG_DIR:-$HOME/.config/sketchybar}/icons.sh"

if [ -n "$(ipconfig getifaddr en0)" ]; then icon=$ICON_WIFI; else icon=$ICON_WIFI_OFF; fi
sketchybar --set "$NAME" icon="$icon"
