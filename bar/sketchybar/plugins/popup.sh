#!/bin/bash

# Hover highlight for popup rows (subscribed to mouse.entered / mouse.exited).
case "$SENDER" in
mouse.entered) sketchybar --set "$NAME" background.drawing=on ;;
mouse.exited) sketchybar --set "$NAME" background.drawing=off ;;
esac
