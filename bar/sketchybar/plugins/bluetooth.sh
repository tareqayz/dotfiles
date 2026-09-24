#!/bin/bash

# Controller state via blueutil (brew install blueutil); falls back to the Bluetooth prefs plist.
# On + something connected → ink. On but idle → muted. Off → muted "off" glyph.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

if command -v blueutil >/dev/null 2>&1; then
  power="$(blueutil -p 2>/dev/null)"
  connected="$(blueutil --connected 2>/dev/null)"
else
  power="$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null)"
  connected="unknown"
fi

if [ "$power" = "1" ]; then
  if [ -n "$connected" ]; then color="$INK"; else color="$INK_MUTED"; fi
  sketchybar --set "$NAME" icon="$ICON_BLUETOOTH" icon.color="$color"
else
  sketchybar --set "$NAME" icon="$ICON_BLUETOOTH_OFF" icon.color="$INK_MUTED"
fi
