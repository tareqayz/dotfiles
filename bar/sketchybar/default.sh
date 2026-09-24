#!/bin/bash

##### Fonts #####
export FONT="SF Pro"                             # labels: Regular · Medium · Semibold
export SF_SYMBOLS="SF Pro:Regular:15.0"          # SF Symbol glyphs
export NERD_FONT="Hack Nerd Font:Regular:15.0"   # bluetooth glyphs only
export MONO_FONT="Hack Nerd Font:Bold:12.0"       # space numbers
export APP_FONT="sketchybar-app-font:Regular:14.0" # app glyphs in spaces

##### Defaults for every item added after this point #####
# Ink on the sky with a 1 pt shadow straight below (angle 90 = down, no blur — SketchyBar
# shadows are hard offsets). Popups are the frosted "sky/panel" cards from Figma.
default=(
  updates=when_shown
  padding_left=0
  padding_right=0
  icon.font="$SF_SYMBOLS"
  icon.color="$INK"
  icon.padding_left=0
  icon.padding_right=0
  icon.shadow.drawing=on
  icon.shadow.color="$SHADOW"
  icon.shadow.distance=1
  icon.shadow.angle=90
  label.font="$FONT:Regular:13.0"
  label.color="$INK"
  label.padding_left=0
  label.padding_right=0
  label.shadow.drawing=on
  label.shadow.color="$SHADOW"
  label.shadow.distance=1
  label.shadow.angle=90
  background.drawing=off
  popup.background.color="$PANEL"
  popup.background.border_color="$LINE"
  popup.background.border_width=1
  popup.background.corner_radius=16
  popup.blur_radius=30
  popup.height=32
  popup.y_offset=8
)

sketchybar --default "${default[@]}"

##### Right-side item: 14 pt gap to its left neighbour, nothing on the right #####
right_item=(
  padding_left=14
  padding_right=0
)

##### Popup row: 20 pt glyph column + label, 28 pt hover pill ("Mirage v1/Apple menu" in Figma) #####
# Usage: popup_row <label_width>  → fills the array "row".
popup_row() {
  row=(
    padding_left=6
    padding_right=6
    icon.font="$SF_SYMBOLS"
    icon.width=20
    icon.align=center
    icon.padding_left=8
    icon.color="$PANEL_MUTED"
    icon.shadow.drawing=off
    label.font="$FONT:Medium:13.0"
    label.color="$PANEL_FG"
    label.padding_left=8
    label.padding_right=8
    label.width="$1"
    label.shadow.drawing=off
    background.color="$ACCENT_SOFT"
    background.corner_radius=8
    background.height=28
    background.drawing=off
    script="$PLUGIN_DIR/popup.sh"
  )
}
