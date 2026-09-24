#!/bin/bash

source "$CONFIG_DIR/icons.sh"

NAME="${NAME:-volume}"

render() {
  local vol="$1" muted icon
  muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"
  case "$vol" in
  [6-9][0-9] | 100) icon="$ICON_VOLUME_100" ;;
  [3-5][0-9]) icon="$ICON_VOLUME_66" ;;
  [1-9] | [1-2][0-9]) icon="$ICON_VOLUME_33" ;;
  *) icon="$ICON_VOLUME_0" ;;
  esac
  [ "$muted" = "true" ] && icon="$ICON_VOLUME_0"
  sketchybar --set "$NAME" icon="$icon"
}

current() { osascript -e 'output volume of (get volume settings)' 2>/dev/null; }

if [ "$1" = "toggle" ]; then
  osascript -e 'set volume output muted not (output muted of (get volume settings))'
  render "$(current)"
  exit 0
fi

case "$SENDER" in
mouse.scrolled)
  vol=$(($(current) + SCROLL_DELTA * 2))
  [ "$vol" -lt 0 ] && vol=0
  [ "$vol" -gt 100 ] && vol=100
  osascript -e "set volume output volume $vol"
  ;;
volume_change) render "$INFO" ;;
*) render "$(current)" ;;
esac
