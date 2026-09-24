#!/bin/bash

##### Wi‑Fi — glyph only, polled every 30 s; click opens Wi‑Fi settings #####

sketchybar --add item wifi right \
  --set wifi "${right_item[@]}" \
    icon="$ICON_WIFI" \
    label.drawing=off \
    update_freq=30 \
    script="$PLUGIN_DIR/wifi.sh" \
    click_script="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'" \
  --subscribe wifi system_woke
