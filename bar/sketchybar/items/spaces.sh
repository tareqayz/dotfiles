#!/bin/bash

##### Spaces — AeroSpace workspaces #####
# One item per workspace: its name (mono) + the apps open in it (app glyphs).
# Only workspaces that have windows, plus the focused one, are drawn. The focused one is
# full ink with a 2 pt glow underline 3 pt above the bottom; the others are dimmed.
# Figma: "Mirage v1/Space". AeroSpace workspaces are not native Spaces, so these are plain
# items fed by the triggers in wms/aerospace/aerospace.toml, not `space` components.

space=(
  drawing=off
  padding_left=0
  padding_right=13
  icon.font="$MONO_FONT"
  icon.color="$INK_DIM"
  icon.padding_right=0
  label.font="$APP_FONT"
  label.color="$INK_DIM"
  label.y_offset=-1
  label.drawing=off
  background.color="$GLOW"
  background.height=2
  background.corner_radius=1
  background.y_offset=-12
  background.drawing=off
)

# Workspaces come from the AeroSpace server; if it isn't up yet, fall back to 1–9
# (aerospace.toml reloads the bar after startup).
workspaces="$(aerospace list-workspaces --all 2>/dev/null)"
[ -n "$workspaces" ] || workspaces="$(seq 1 9)"

for ws in $workspaces; do
  sketchybar --add item "space.$ws" left \
    --set "space.$ws" "${space[@]}" icon="$ws" \
      click_script="aerospace workspace $ws"
done

# Hidden controller: re-renders every workspace in one batch. aerospace_workspace_change
# (focus moved, carries $FOCUSED_WORKSPACE) and aerospace_windows_change (window focus
# changed: opened, closed, moved) are triggered by AeroSpace.
sketchybar --add event aerospace_workspace_change \
  --add event aerospace_windows_change \
  --add item spaces.ctl left \
  --set spaces.ctl drawing=off updates=on script="$PLUGIN_DIR/spaces.sh" \
  --subscribe spaces.ctl aerospace_workspace_change aerospace_windows_change \
    front_app_switched system_woke
