# Bar colors from the Pywal16 palette (~/.config/wal/set-wallpaper.sh regenerates it).
# Falls back to Catppuccin Mocha until a palette exists.
background='#1e1e2e'
foreground='#cdd6f4'
color4='#cba6f7'
color8='#585b70'
[ -f "$HOME/.cache/wal/colors.sh" ] && . "$HOME/.cache/wal/colors.sh"

# argb '#rrggbb' alpha -> 0xAARRGGBB
argb() { printf '0x%s%s' "$2" "${1#\#}"; }

TRANSPARENT=0x00000000
PILL=$(argb "$background" d9)
FG=$(argb "$foreground" ff)
DIM=$(argb "$color8" ff)
ACCENT=$(argb "$color4" ff)
ACCENT_BG=$(argb "$color4" 33)
