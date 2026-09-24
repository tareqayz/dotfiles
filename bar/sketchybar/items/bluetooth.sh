#!/bin/bash

##### Bluetooth — glyph only (Hack Nerd Font); click opens Bluetooth settings #####

sketchybar --add item bluetooth right \
  --set bluetooth "${right_item[@]}" \
    icon="$ICON_BLUETOOTH" \
    icon.font="$NERD_FONT" \
    label.drawing=off \
    update_freq=30 \
    script="$PLUGIN_DIR/bluetooth.sh" \
    click_script="open 'x-apple.systempreferences:com.apple.BluetoothSettings'" \
  --subscribe bluetooth system_woke
