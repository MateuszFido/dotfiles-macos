#!/bin/sh
# Total CPU load as a share of all cores.
cores=$(sysctl -n hw.logicalcpu)
load=$(ps -A -o %cpu= | awk -v n="$cores" '{ s += $1 } END { printf "%d", s / n }')
sketchybar --set "$NAME" label="$load%"
