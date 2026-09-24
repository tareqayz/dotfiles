#!/bin/bash

##### Sky pebble: sun by day / moon by night + temperature; click toggles dark mode #####

if [ "$THEME" = night ]; then sky_icon="$ICON_MOON"; else sky_icon="$ICON_SUN"; fi

sky=(
  icon="$sky_icon"
  icon.font="SF Pro:Regular:14.0"
  icon.color="$ACCENT"
  icon.padding_left=9
  icon.padding_right=5
  label.font="$FONT:Heavy:13.0"
  label.padding_right=10
  "${pebble[@]}"
  update_freq=1800
  script="$PLUGIN_DIR/sky.sh"
  click_script="$PLUGIN_DIR/sky.sh toggle"
)

sketchybar --add item sky right \
  --set sky "${sky[@]}" \
  --subscribe sky system_woke mouse.entered mouse.exited
