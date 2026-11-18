#!/bin/sh
# Set the wallpaper and recolor SketchyBar, JankyBorders and Ghostty from it (Pywal16).
#   set-wallpaper.sh ~/Pictures/foo.jpg   set a new wallpaper and theme it
#   set-wallpaper.sh                      re-theme from the current wallpaper
set -eu

if [ $# -gt 0 ]; then
	img=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
	osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$img\""
else
	img=$(osascript -e 'tell application "System Events" to get picture of desktop 1')
fi

cache="$HOME/.cache/wal"
mkdir -p "$cache"
src=$img
case "$img" in
*.heic | *.HEIC)
	# ImageMagick can't always read HEIC; let macOS convert it.
	src="$cache/wallpaper-source.png"
	sips -s format png "$img" --out "$src" >/dev/null
	;;
esac

# -n: we set the wallpaper ourselves; -s/-t: Ghostty is themed via its config instead.
"$HOME/.local/bin/wal" -n -s -t -e -q -i "$src"

/opt/homebrew/bin/sketchybar --reload
"$HOME/.config/borders/bordersrc"
pkill -USR2 -f 'Ghostty.app/Contents/MacOS/ghostty' || true # Ghostty reloads its config on SIGUSR2
