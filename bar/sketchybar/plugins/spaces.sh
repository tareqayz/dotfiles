#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

STATE="${TMPDIR:-/tmp}/sketchybar_focused_space"

# Native Spaces click: needs "Switch to Desktop N" (⌃N) enabled in
# System Settings → Keyboard → Keyboard Shortcuts → Mission Control.
if [ "$1" = "focus" ]; then
  codes=(0 18 19 20 21 23 22 26 28 25 29)
  osascript -e "tell application \"System Events\" to key code ${codes[$2]} using control down"
  exit 0
fi

# App names on stdin → space-separated sketchybar-app-font ligatures.
app_icons() {
  local out="" app
  while IFS= read -r app; do
    [ -n "$app" ] && out="$out $(icon_map "$app")"
  done
  echo "${out# }"
}

render_aerospace() {
  local focused nonempty ws icons args=()
  focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
  echo "$focused" >"$STATE"
  nonempty="$(aerospace list-workspaces --monitor all --empty no)"
  for ws in $(aerospace list-workspaces --all); do
    if [ "$ws" = "$focused" ] || printf '%s\n' "$nonempty" | grep -qx "$ws"; then
      icons="$(aerospace list-windows --workspace "$ws" --format '%{app-name}' 2>/dev/null | sort -u | app_icons)"
      args+=(--set "space.$ws" drawing=on label="$icons")
      if [ "$ws" = "$focused" ]; then
        args+=(background.drawing=on background.color="$ACCENT" icon.color="$ON_ACCENT" label.color="$ON_ACCENT")
        if [ -n "$icons" ]; then args+=(label.drawing=on); else args+=(label.drawing=off); fi
      else
        args+=(background.drawing=off icon.color="$TEXT_MUTED" label.color="$TEXT" label.drawing=off)
      fi
    else
      args+=(--set "space.$ws" drawing=off)
    fi
  done
  sketchybar --animate tanh 10 "${args[@]}"
}

is_focused() { [ "${NAME#space.}" = "$(cat "$STATE" 2>/dev/null)" ]; }
has_icons() { [ -n "$(sketchybar --query "$NAME" | jq -r '.label.value')" ] && echo on || echo off; }

case "$SENDER" in
mouse.entered)
  is_focused || sketchybar --animate tanh 8 --set "$NAME" background.drawing=on background.color="$PEBBLE_HOVER" \
    label.drawing="$(has_icons)"
  ;;
mouse.exited) is_focused || sketchybar --set "$NAME" background.drawing=off label.drawing=off ;;
aerospace_workspace_change | front_app_switched | system_woke) render_aerospace ;;
space_windows_change)
  sid="$(echo "$INFO" | jq -r '.space')"
  [ "$sid" -ge 1 ] 2>/dev/null && [ "$sid" -le 20 ] || exit 0
  icons="$(echo "$INFO" | jq -r '.apps | keys[]' | app_icons)"
  if [ "$sid" = "$(cat "$STATE" 2>/dev/null)" ] && [ -n "$icons" ]; then
    sketchybar --set "space.$sid" label="$icons" label.drawing=on
  else
    sketchybar --set "space.$sid" label="$icons" label.drawing=off
  fi
  ;;
*)
  if [ "$NAME" = "spaces.ctl" ]; then
    aerospace list-workspaces --focused >/dev/null 2>&1 && render_aerospace
  elif [ "$SELECTED" = "true" ]; then # native space became active
    echo "${NAME#space.}" >"$STATE"
    sketchybar --animate tanh 10 --set "$NAME" background.drawing=on background.color="$ACCENT" \
      icon.color="$ON_ACCENT" label.color="$ON_ACCENT" label.drawing="$(has_icons)"
  elif [ "$SELECTED" = "false" ]; then
    sketchybar --animate tanh 10 --set "$NAME" background.drawing=off icon.color="$TEXT_MUTED" label.color="$TEXT" \
      label.drawing=off
  fi
  ;;
esac
