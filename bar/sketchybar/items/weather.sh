#!/bin/bash

##### Weather — sun/moon glyph in the glow color + temperature; click opens Weather #####

sketchybar --add item weather right \
  --set weather "${right_item[@]}" \
    icon="$ICON_SUN" \
    icon.color="$GLOW" \
    icon.padding_right=5 \
    label.drawing=off \
    update_freq=1800 \
    script="$PLUGIN_DIR/weather.sh" \
    click_script="open -a Weather" \
  --subscribe weather system_woke
