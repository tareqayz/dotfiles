#!/bin/bash

##### Status pebble: Wi-Fi · volume · battery #####
# Right-side items are laid out right to left, so battery is added first.

status_item=(
  icon.font="SF Pro:Regular:15.0"
  icon.padding_left=6
  icon.padding_right=6
  label.drawing=off
  padding_left=0
  padding_right=0
  background.height=20
  background.corner_radius=10
  background.color="$PEBBLE_HOVER"
  background.drawing=off
)

sketchybar --add item battery right \
  --set battery "${status_item[@]}" label.drawing=on label.font="$FONT:Bold:12.0" \
  icon.padding_right=3 label.padding_right=8 update_freq=120 script="$PLUGIN_DIR/battery.sh" \
  click_script="open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'" \
  --subscribe battery power_source_change system_woke mouse.entered mouse.exited \
  \
  --add item volume right \
  --set volume "${status_item[@]}" script="$PLUGIN_DIR/volume.sh" \
  click_script="$PLUGIN_DIR/volume.sh toggle" \
  --subscribe volume volume_change mouse.scrolled mouse.entered mouse.exited \
  \
  --add item wifi right \
  --set wifi "${status_item[@]}" update_freq=30 script="$PLUGIN_DIR/wifi.sh" \
  click_script="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'" \
  --subscribe wifi system_woke mouse.entered mouse.exited

sketchybar --add bracket status wifi volume battery \
  --set status "${pebble[@]}"
