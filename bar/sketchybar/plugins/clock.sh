#!/bin/bash

source "$CONFIG_DIR/colors.sh"

is_open() { [ "$(sketchybar --query clock | jq -r '.popup.drawing')" = "on" ]; }
close() { sketchybar --set clock popup.drawing=off background.color="$PEBBLE" icon.color="$TEXT_MUTED" label.color="$TEXT"; }

[ "$1" = close ] && close && exit 0

case "$SENDER" in
mouse.clicked)
  if is_open; then
    close
  else
    sketchybar --set clock.day label="$(date '+%A')" \
      --set clock.date label="$(date '+%-d %B %Y · week %V')" \
      --set clock popup.drawing=on background.color="$ACCENT" icon.color="$ON_ACCENT" label.color="$ON_ACCENT"
  fi
  ;;
mouse.entered) is_open || sketchybar --set clock background.color="$PEBBLE_HOVER" ;;
mouse.exited) is_open || sketchybar --set clock background.color="$PEBBLE" ;;
mouse.exited.global) close ;;
*) sketchybar --set "$NAME" icon="$(date '+%a %-d %b')" label="$(date '+%H:%M')" ;;
esac
