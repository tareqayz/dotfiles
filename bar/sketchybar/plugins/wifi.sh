#!/bin/bash

# wifi_change no longer fires on recent macOS, so this polls (update_freq=30).

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

case "$SENDER" in
mouse.entered) sketchybar --set "$NAME" background.drawing=on; exit 0 ;;
mouse.exited) sketchybar --set "$NAME" background.drawing=off; exit 0 ;;
esac

if [ -n "$(ipconfig getifaddr en0 2>/dev/null)" ]; then
  sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color="$TEXT"
else
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color="$TEXT_MUTED"
fi
