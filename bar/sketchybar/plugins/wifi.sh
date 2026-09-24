#!/bin/bash

# wifi_change no longer fires on recent macOS, so the item polls (update_freq=30).

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

if [ -n "$(ipconfig getifaddr en0 2>/dev/null)" ]; then
  sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color="$INK"
else
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color="$INK_MUTED"
fi
