#!/bin/bash

# Weather from wttr.in (location from your IP), refreshed every 30 min. Clicking the
# pebble flips macOS dark mode; items/theme.sh then reloads the bar in the other palette.

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "toggle" ]; then
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
  exit 0
fi

case "$SENDER" in
mouse.entered) sketchybar --set sky background.color="$PEBBLE_HOVER"; exit 0 ;;
mouse.exited) sketchybar --set sky background.color="$PEBBLE"; exit 0 ;;
esac

temp="$(curl -fsS --max-time 5 'https://wttr.in/?format=%t' 2>/dev/null | tr -d '+C ')"
case "$temp" in
*°) sketchybar --set sky label="$temp" label.drawing=on ;;
*) sketchybar --set sky label.drawing=off ;;
esac
