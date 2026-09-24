#!/bin/bash

##### Volume — glyph only; click toggles mute, scroll changes the level #####

sketchybar --add item volume right \
  --set volume "${right_item[@]}" \
    icon="$ICON_VOLUME_100" \
    label.drawing=off \
    script="$PLUGIN_DIR/volume.sh" \
    click_script="$PLUGIN_DIR/volume.sh toggle" \
  --subscribe volume volume_change mouse.scrolled
