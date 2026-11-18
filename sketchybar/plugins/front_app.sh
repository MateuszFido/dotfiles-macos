#!/bin/bash
# Focused app: icon + name. Clicking lists the app's menus (File, Edit, ...) in a popup;
# picking one opens that native menu.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
MENUBAR="$CONFIG_DIR/helpers/menubar"

case "$SENDER" in
front_app_switched)
	. "$CONFIG_DIR/plugins/icon_map.sh"
	__icon_map "$INFO"
	sketchybar --set "$NAME" icon="$icon_result" label="$INFO" popup.drawing=off
	;;
mouse.clicked)
	args=(--remove '/menu\..*/')
	n=1
	while IFS= read -r title; do
		args+=(--add item "menu.$n" "popup.$NAME"
			--set "menu.$n" label="$title" icon.drawing=off label.padding_left=12 label.padding_right=12
			click_script="$MENUBAR press $n; sketchybar --set $NAME popup.drawing=off")
		n=$((n + 1))
	done < <("$MENUBAR" list)
	sketchybar "${args[@]}" --set "$NAME" popup.drawing=toggle
	;;
mouse.exited.global)
	sketchybar --set "$NAME" popup.drawing=off
	;;
esac
