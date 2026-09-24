#!/bin/bash

# Popup row hover: show the pill while the mouse is over the row.
case "$SENDER" in
mouse.entered) sketchybar --set "$NAME" background.drawing=on ;;
mouse.exited) sketchybar --set "$NAME" background.drawing=off ;;
esac
