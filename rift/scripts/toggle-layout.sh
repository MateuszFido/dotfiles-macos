#!/bin/sh
# Toggle the focused workspace between bsp and scrolling
# (OmniWM's dwindle <-> niri toggleWorkspaceLayout).
rift=/opt/homebrew/bin/rift-cli
mode=$("$rift" query workspaces | /usr/bin/jq -r '.[] | select(.is_focused) | .layout_mode')
if [ "$mode" = scrolling ]; then next=bsp; else next=scrolling; fi
exec "$rift" execute workspace set-layout "$next"
