#!/bin/bash

source "$CONFIG_DIR/colors.sh"

close() { sketchybar --set apple popup.drawing=off background.color="$PEBBLE" icon.color="$TEXT"; }
is_open() { [ "$(sketchybar --query apple | jq -r '.popup.drawing')" = "on" ]; }

# Row actions (click_script passes the action name).
case "$1" in
about) close; open "x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension"; exit 0 ;;
settings) close; open -a "System Settings"; exit 0 ;;
lock) close; pmset displaysleepnow; exit 0 ;;
sleep) close; pmset sleepnow; exit 0 ;;
restart) close; osascript -e 'tell application "loginwindow" to «event aevtrrst»'; exit 0 ;;
shutdown) close; osascript -e 'tell application "loginwindow" to «event aevtrsdn»'; exit 0 ;;
esac

case "$SENDER" in
mouse.clicked)
  if is_open; then close
  else sketchybar --set apple popup.drawing=on background.color="$ACCENT" icon.color="$ON_ACCENT"
  fi ;;
mouse.entered) is_open || sketchybar --set apple background.color="$PEBBLE_HOVER" ;;
mouse.exited) is_open || sketchybar --set apple background.color="$PEBBLE" ;;
mouse.exited.global) close ;;
esac
