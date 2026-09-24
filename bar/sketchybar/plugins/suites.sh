#!/bin/bash

source "$CONFIG_DIR/colors.sh"

S="${TMPDIR:-/tmp}/sketchybar_island"
mkdir -p "$S"
KEYS="design dev agents library studio work focus"

is_open() { [ "$(sketchybar --query suites | jq -r '.popup.drawing')" = "on" ]; }

page() {
  local p="$1" k args=(--set '/suites\.menu\..*/' drawing=off)
  for k in $KEYS; do
    if [ "$k" = "$p" ]; then args+=(--set "/suites\\.$k\\..*/" drawing=on); else args+=(--set "/suites\\.$k\\..*/" drawing=off); fi
  done
  [ "$p" = menu ] && args+=(--set '/suites\.menu\..*/' drawing=on)
  sketchybar "${args[@]}"
  [ "$p" = focus ] && mark_focus
}

open_popup() {
  page menu
  sketchybar --set suites popup.drawing=on background.color="$ACCENT" icon.color="$ON_ACCENT" label.color="$ON_ACCENT"
}

close() {
  sketchybar --set suites popup.drawing=off background.color="$PEBBLE" icon.color="$TEXT" label.color="$TEXT"
}

# Highlight the focus mode last chosen from the bar.
mark_focus() {
  local current i=0 name args=()
  current="$(cat "$S/focus" 2>/dev/null)"
  for name in Zen Study Learning Work Sleep "Do Not Disturb"; do
    if [ "$name" = "$current" ]; then args+=(--set "suites.focus.$i" icon.color="$ACCENT"); else args+=(--set "suites.focus.$i" icon.color="$TEXT_MUTED"); fi
    i=$((i + 1))
  done
  sketchybar "${args[@]}"
}

# Focus modes: runs a Shortcut with the same name (e.g. a "Zen" shortcut that turns on the
# Zen Focus). Without one, opens Focus settings.
focus() {
  if shortcuts list 2>/dev/null | grep -qx "$1"; then
    shortcuts run "$1" && echo "$1" >"$S/focus"
  else
    open "x-apple.systempreferences:com.apple.Focus-Settings.extension"
  fi
}

case "$1" in
page)
  page "$2"
  exit 0
  ;;
run)
  close
  case "$2" in
  app:*) open -a "${2#app:}" ;;
  url:*) open "${2#url:}" ;;
  cmd:nvim) open -na Ghostty --args -e nvim ;;
  cmd:office) "$CONFIG_DIR/plugins/ms_office_toggle.sh" ;;
  cmd:focus\ *) focus "${2#cmd:focus }" ;;
  esac
  exit 0
  ;;
esac

case "$SENDER" in
mouse.clicked) if is_open; then close; else open_popup; fi ;;
mouse.entered) is_open || sketchybar --set suites background.color="$PEBBLE_HOVER" ;;
mouse.exited) is_open || sketchybar --set suites background.color="$PEBBLE" ;;
mouse.exited.global) close ;;
esac
