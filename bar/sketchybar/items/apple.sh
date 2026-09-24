#!/bin/bash

##### Apple — the logo; click opens a small system menu #####

sketchybar --add item apple left \
  --set apple icon="$ICON_APPLE" \
    padding_right=16 \
    label.drawing=off \
    popup.align=left \
    script="$PLUGIN_DIR/apple.sh" \
  --subscribe apple mouse.clicked mouse.exited.global

popup_row 180
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
