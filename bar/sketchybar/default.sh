#!/bin/bash

##### Fonts #####
# Labels use native SF Pro Rounded (the Figma mockups use Nunito as a stand-in for it).
export FONT="SF Pro Rounded"
export SF_SYMBOLS="SF Pro:Regular:15.0"
export APP_FONT="sketchybar-app-font:Regular:14.0"

##### Changing Defaults #####
# Applied to every item added after this point.
default=(
  padding_left=3
  padding_right=3
  updates=when_shown
  icon.font="$SF_SYMBOLS"
  label.font="$FONT:Bold:13.0"
  icon.color="$TEXT"
  label.color="$TEXT"
  icon.padding_left=0
  icon.padding_right=0
  label.padding_left=0
  label.padding_right=0
  background.height=24
  background.corner_radius=12
  popup.background.color="$POPUP"
  popup.background.border_color="$POPUP_BORDER"
  popup.background.border_width=1
  popup.background.corner_radius=12
  popup.blur_radius=20
  popup.height=28
)

sketchybar --default "${default[@]}"

##### Shared pebble style #####
# A pebble is a bracket (or a single item) with a rounded background and a 1 pt rim.
pebble=(
  background.color="$PEBBLE"
  background.border_color="$PEBBLE_BORDER"
  background.border_width=1
  background.corner_radius=12
  background.height=24
  background.drawing=on
)

# Popup row: fixed icon column, fixed-width label, rounded hover background.
# Usage: popup_row <label_width>  → fills the array "row".
popup_row() {
  row=(
    icon.font="$SF_SYMBOLS"
    icon.width=24
    icon.align=center
    icon.padding_left=6
    icon.color="$TEXT_MUTED"
    label.font="$FONT:Bold:13.0"
    label.padding_left=6
    label.padding_right=6
    label.width="$1"
    background.color="$ROW_HOVER"
    background.corner_radius=7
    background.height=28
    background.drawing=off
    script="$PLUGIN_DIR/popup.sh"
  )
}
