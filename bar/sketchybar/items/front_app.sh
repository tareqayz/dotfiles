#!/bin/bash

##### Front app — name of the focused app, 16 pt after the spaces (13 + 3) #####

sketchybar --add item front_app left \
  --set front_app padding_left=3 \
    icon.drawing=off \
    label.font="$FONT:Semibold:13.0" \
    script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
