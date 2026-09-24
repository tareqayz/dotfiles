#!/bin/bash

#### Apple — pebble with the system menu

apple=(
  icon="$ICON_APPLE"
  icon.font="SF Pro:Regular:15.0"
  icon.padding_left=9
  icon.padding_right=9
  label.drawing=off
  padding_left=0
  "${pebble[@]}"
  popup.align=left
  script="$PLUGIN_DIR/apple.sh"
)

sketchybar --add item apple left \
  --set apple "${apple[@]}" \
  --subscribe apple mouse.clicked mouse.entered mouse.exited mouse.exited.global

popup_row 150
rows=(
  "about|$ICON_LAPTOP|About This Mac"
  "settings|$ICON_GEAR|System Settings…"
  "lock|$ICON_LOCK|Lock Screen"
  "sleep|$ICON_SLEEP|Sleep"
  "restart|$ICON_RESTART|Restart…"
  "shutdown|$ICON_POWER|Shut Down…"
)
for r in "${rows[@]}"; do
  IFS='|' read -r key glyph text <<<"$r"
  sketchybar --add item "apple.$key" popup.apple \
    --set "apple.$key" "${row[@]}" icon="$glyph" label="$text" \
    click_script="$PLUGIN_DIR/apple.sh $key" \
    --subscribe "apple.$key" mouse.entered mouse.exited
done
