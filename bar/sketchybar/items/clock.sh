#!/bin/bash

##### Clock pebble: date (muted) + time (bold), click for the calendar popup #####

clock=(
  icon.font="$FONT:Bold:13.0"
  icon.color="$TEXT_MUTED"
  icon.padding_left=10
  icon.padding_right=6
  label.font="$FONT:Heavy:13.0"
  label.padding_right=11
  "${pebble[@]}"
  update_freq=10
  popup.align=right
  script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock right \
  --set clock "${clock[@]}" \
  --subscribe clock system_woke mouse.clicked mouse.entered mouse.exited mouse.exited.global

popup_row 176
sketchybar --add item clock.day popup.clock \
  --set clock.day icon.drawing=off label.font="$FONT:Heavy:17.0" label.padding_left=10 width=230 \
  --add item clock.date popup.clock \
  --set clock.date icon.drawing=off label.font="$FONT:Bold:12.5" label.color="$TEXT_MUTED" label.padding_left=10 width=230 \
  --add item clock.calendar popup.clock \
  --set clock.calendar "${row[@]}" icon="$ICON_CALENDAR" label="Open Calendar" \
  click_script="open -a Calendar; $PLUGIN_DIR/clock.sh close" \
  --subscribe clock.calendar mouse.entered mouse.exited
