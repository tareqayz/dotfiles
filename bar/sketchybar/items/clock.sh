#!/bin/bash

##### Clock — date (muted, Medium) + time (Semibold); click opens Calendar #####

sketchybar --add item clock right \
  --set clock "${right_item[@]}" \
    icon.font="$FONT:Medium:13.0" \
    icon.color="$INK_MUTED" \
    icon.padding_right=6 \
    label.font="$FONT:Semibold:13.0" \
    update_freq=10 \
    script="$PLUGIN_DIR/clock.sh" \
    click_script="open -a Calendar" \
  --subscribe clock system_woke
