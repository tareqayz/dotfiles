#!/bin/bash

##### Bar Appearance #####
# Dune v2: no bar background. Every group is its own "pebble" (bracket), and the
# notch becomes a black island. Height matches the MacBook Pro 14" notch (32 pt).
# notch_width is the measured notch (185 pt), so position q / e items hug it exactly.

bar=(
  position=top
  height=32
  color="$TRANSPARENT"
  border_width=0
  corner_radius=0
  margin=0
  y_offset=0
  blur_radius=0
  padding_left=8
  padding_right=8
  notch_width=185
  notch_display_height=0
  notch_offset=0
  display=all
  hidden=off
  topmost=off
  sticky=on
  font_smoothing=off
  shadow=off
)

sketchybar --bar "${bar[@]}"
