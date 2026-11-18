#!/bin/sh
# Focus the next display, left to right, wrapping (OmniWM's focusMonitorNext).
# Sorted the same way Rift orders displays (x, then y, then UUID).
rift=/opt/homebrew/bin/rift-cli
next=$("$rift" query displays | /usr/bin/jq -r '
  sort_by(.frame.origin.x, .frame.origin.y, .uuid)
  | (map(.is_active_context) | index(true) // -1) as $i
  | .[($i + 1) % length].uuid')
exec "$rift" execute display focus --uuid "$next"
