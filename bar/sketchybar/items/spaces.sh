#!/bin/bash

##### Workspaces pebble #####
# AeroSpace workspaces when AeroSpace is running (it triggers aerospace_workspace_change,
# see ~/.aerospace.toml), otherwise native macOS Spaces. Each pill shows the workspace
# number; the focused pill (and any pill you hover) also shows its apps as icons.

space=(
  icon.font="$FONT:Heavy:11.5"
  icon.padding_left=4
  icon.padding_right=4
  icon.color="$TEXT_MUTED"
  label.font="$APP_FONT"
  label.padding_right=7
  label.y_offset=-1
  label.color="$TEXT"
  label.drawing=off
  background.color="$ACCENT"
  background.height=20
  background.corner_radius=10
  background.drawing=off
  padding_left=1
  padding_right=1
  script="$PLUGIN_DIR/spaces.sh"
)

if aerospace list-workspaces --focused >/dev/null 2>&1; then
  sketchybar --add event aerospace_workspace_change
  for ws in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$ws" left \
      --set "space.$ws" "${space[@]}" icon="$ws" drawing=off \
      click_script="aerospace workspace $ws" \
      --subscribe "space.$ws" mouse.entered mouse.exited
  done
  events="aerospace_workspace_change front_app_switched system_woke"
else
  for sid in $(seq 1 20); do
    sketchybar --add space "space.$sid" left \
      --set "space.$sid" space="$sid" "${space[@]}" icon="$sid" \
      click_script="$PLUGIN_DIR/spaces.sh focus $sid" \
      --subscribe "space.$sid" mouse.entered mouse.exited
  done
  events="space_windows_change"
fi

# Invisible controller: one script run per event updates every pill in one batch.
sketchybar --add item spaces.ctl left \
  --set spaces.ctl drawing=off updates=on script="$PLUGIN_DIR/spaces.sh" \
  --subscribe spaces.ctl $events

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces "${pebble[@]}"
