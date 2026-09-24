#!/bin/bash

##### Theme watcher (hidden) #####
# macOS posts AppleInterfaceThemeChangedNotification when appearance flips; reloading
# re-runs colors.sh, which picks the Day or Night palette.

sketchybar --add event theme_change AppleInterfaceThemeChangedNotification \
  --add item theme right \
  --set theme drawing=off updates=on script='[ "$SENDER" = "theme_change" ] && sketchybar --reload' \
  --subscribe theme theme_change
