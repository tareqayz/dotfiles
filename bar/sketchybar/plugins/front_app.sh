#!/bin/bash

# $INFO carries the app name on front_app_switched. On a forced update (reload) ask AeroSpace,
# then System Events as a fallback.
if [ "$SENDER" = "front_app_switched" ]; then
  name="$INFO"
else
  name="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
  [ -n "$name" ] || name="$(osascript -e 'tell application "System Events" to get displayed name of first application process whose frontmost is true' 2>/dev/null)"
fi
sketchybar --set "$NAME" label="$name"
