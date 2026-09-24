#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

# App names (one per line) → space-separated sketchybar-app-font ligatures.
app_icons() {
  local out="" app
  while IFS= read -r app; do
    [ -n "$app" ] && out="$out $(icon_map "$app")"
  done
  echo "${out# }"
}

# Append the properties for one workspace to ARGS (one sketchybar call sets everything).
# Drawn when it has apps or is focused; focused = ink + underline, otherwise dimmed.
ARGS=()
add_props() { # add_props <ws> <icons> <true|false>
  local ws="$1" icons="$2" on="$3"
  ARGS+=(--set "space.$ws")
  if [ -n "$icons" ]; then ARGS+=(label="$icons" label.drawing=on icon.padding_right=4)
  else ARGS+=(label="" label.drawing=off icon.padding_right=0); fi
  if [ "$on" = true ]; then ARGS+=(icon.color="$INK" label.color="$INK" background.drawing=on drawing=on)
  elif [ -n "$icons" ]; then ARGS+=(icon.color="$INK_DIM" label.color="$INK_DIM" background.drawing=off drawing=on)
  else ARGS+=(icon.color="$INK_DIM" label.color="$INK_DIM" background.drawing=off drawing=off); fi
}

# Rebuild every workspace from AeroSpace: one list-windows call for all of them.
render() {
  command -v aerospace >/dev/null 2>&1 || return 0
  local focused windows map ws rest icons
  focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
  windows="$(aerospace list-windows --all --format '%{workspace}%{tab}%{app-name}' 2>/dev/null)" || return 0
  # "<ws>\t<app>\t<app>…" per line (bash 3.2 has no associative arrays; names can be letters)
  map=$'\n'"$(printf '%s\n' "$windows" | sort -u | awk -F'\t' 'NF == 2 { a[$1] = a[$1] "\t" $2 } END { for (w in a) print w a[w] }')"$'\n'
  ARGS=()
  for ws in $(sketchybar --query bar | jq -r '.items[] | select(startswith("space.")) | sub("^space\\."; "")'); do
    icons=""
    case "$map" in *$'\n'"$ws"$'\t'*)
      rest="${map#*$'\n'"$ws"$'\t'}"
      icons="$(printf '%s\n' "${rest%%$'\n'*}" | tr '\t' '\n' | app_icons)" ;;
    esac
    if [ "$ws" = "$focused" ]; then add_props "$ws" "$icons" true; else add_props "$ws" "$icons" false; fi
  done
  [ ${#ARGS[@]} -gt 0 ] && sketchybar "${ARGS[@]}"
}

render
