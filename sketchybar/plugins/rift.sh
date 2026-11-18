#!/bin/bash
# Redraw the workspace items from Rift's state: app icons per workspace,
# dimmed when empty, highlighted when focused.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/plugins/icon_map.sh"

state=$(/opt/homebrew/bin/rift-cli query workspaces | /usr/bin/jq -r '
	.[] | [.index + 1, .is_focused, ([.windows[].app_name] | unique | join(","))] | @tsv')

args=()
while IFS=$'\t' read -r n focused apps; do
	[ "$n" -le 9 ] 2>/dev/null || continue
	icons=""
	if [ -n "$apps" ]; then
		IFS=','
		for app in $apps; do
			__icon_map "$app"
			icons+="$icon_result"
		done
		unset IFS
	fi

	if [ "$focused" = true ]; then
		color=$ACCENT bg=on
	elif [ -n "$icons" ]; then
		color=$FG bg=off
	else
		color=$DIM bg=off
	fi
	label_drawing=$([ -n "$icons" ] && echo on || echo off)

	args+=(--set "space.$n" icon.color="$color" label="$icons" label.color="$color"
		label.drawing="$label_drawing" background.drawing="$bg")
done <<<"$state"

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
