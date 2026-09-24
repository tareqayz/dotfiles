#!/bin/bash

# Notch island state machine. Each side is collapsed | hover | open.
#   mouse.entered  wing  → that side expands (the notch expands both)
#   mouse.exited         → collapse hovered sides after a short delay, unless the mouse
#                          re-enters any island part first (moving across items is fine)
#   mouse.clicked  wing  → toggle that side's panel; the notch toggles both
#   mouse.exited.global  → leaving the bar and its popups closes everything

source "$CONFIG_DIR/colors.sh"

S="${TMPDIR:-/tmp}/sketchybar_island"
mkdir -p "$S"

TITLE_W=135
STATS_W=150
ANIMATE=(--animate tanh 15)

state() { cat "$S/$1" 2>/dev/null || echo collapsed; }
set_state() { echo "$2" >"$S/$1"; }
touch_token() { t="$$$RANDOM" && echo "$t" >"$S/token" && echo "$t"; }

controls() { echo --set island.ctl.prev drawing="$1" --set island.ctl.play drawing="$1" --set island.ctl.next drawing="$1"; }

left_hover() {
  sketchybar "${ANIMATE[@]}" \
    --set island.title drawing=on width=$TITLE_W label.color="$ISLAND_TEXT" \
    --set island.art drawing=on popup.drawing=off \
    --set island.eq.1 padding_left=0 \
    $(controls off)
  set_state left hover
}

left_open() {
  sketchybar --set island.title drawing=off width=0 label.color="$TRANSPARENT" \
    --set island.art drawing=on popup.drawing=on \
    --set island.eq.1 padding_left=0 \
    $(controls on)
  set_state left open
}

left_collapse() {
  sketchybar "${ANIMATE[@]}" \
    --set island.title width=0 label.color="$TRANSPARENT" \
    --set island.art drawing=off popup.drawing=off \
    --set island.eq.1 padding_left=9 \
    $(controls off)
  set_state left collapsed
  (sleep 0.3 && [ "$(state left)" = collapsed ] && sketchybar --set island.title drawing=off) >/dev/null 2>&1 &
}

right_hover() {
  sketchybar "${ANIMATE[@]}" \
    --set island.heart icon.padding_right=5 \
    --set island.bb drawing=on label.color="$OASIS" \
    --set island.stats drawing=on width=$STATS_W label.color="$ISLAND_TEXT" popup.drawing=off
  set_state right hover
}

right_open() {
  sketchybar "${ANIMATE[@]}" \
    --set island.heart icon.padding_right=5 \
    --set island.bb drawing=on label.color="$OASIS" \
    --set island.stats drawing=on width=$STATS_W label.color="$ISLAND_TEXT" popup.drawing=on
  set_state right open
}

right_collapse() {
  sketchybar "${ANIMATE[@]}" \
    --set island.heart icon.padding_right=11 \
    --set island.bb label.color="$TRANSPARENT" \
    --set island.stats width=0 label.color="$TRANSPARENT" popup.drawing=off
  set_state right collapsed
  (sleep 0.3 && [ "$(state right)" = collapsed ] &&
    sketchybar --set island.bb drawing=off --set island.stats drawing=off) >/dev/null 2>&1 &
}

schedule_collapse() {
  local t
  t="$(touch_token)"
  (
    sleep 0.35
    [ "$(cat "$S/token" 2>/dev/null)" = "$t" ] || exit 0
    [ "$(state left)" = hover ] && left_collapse
    [ "$(state right)" = hover ] && right_collapse
  ) >/dev/null 2>&1 &
}

side() {
  case "$NAME" in
  island.heart | island.bb | island.stats) echo right ;;
  island.notch) echo both ;;
  *) echo left ;;
  esac
}

# Panel rows call "island.sh close" after acting.
if [ "$1" = "close" ]; then
  left_collapse
  right_collapse
  exit 0
fi

# island.eq.1 runs every second while music plays (update_freq set by music.sh).
[ "$SENDER" = "routine" ] && exec "$CONFIG_DIR/plugins/eq.sh"

case "$SENDER" in
mouse.entered)
  touch_token >/dev/null
  case "$(side)" in
  left) [ "$(state left)" = collapsed ] && left_hover ;;
  right) [ "$(state right)" = collapsed ] && right_hover ;;
  both)
    [ "$(state left)" = collapsed ] && left_hover
    [ "$(state right)" = collapsed ] && right_hover
    ;;
  esac
  ;;
mouse.exited) schedule_collapse ;;
mouse.clicked)
  case "$(side)" in
  left) if [ "$(state left)" = open ]; then left_hover; else left_open; fi ;;
  right) if [ "$(state right)" = open ]; then right_hover; else right_open; fi ;;
  both)
    if [ "$(state left)" = open ] && [ "$(state right)" = open ]; then
      left_hover
      right_hover
    else
      left_open
      right_open
    fi
    ;;
  esac
  ;;
mouse.exited.global)
  left_collapse
  right_collapse
  ;;
esac
