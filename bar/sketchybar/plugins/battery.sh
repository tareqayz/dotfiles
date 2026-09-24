#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

case "$SENDER" in
mouse.entered) sketchybar --set "$NAME" background.drawing=on; exit 0 ;;
mouse.exited) sketchybar --set "$NAME" background.drawing=off; exit 0 ;;
esac

BATT="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT" | grep -Eo "\d+%" | cut -d% -f1)"
[ -z "$PERCENTAGE" ] && exit 0

case "$PERCENTAGE" in
9[0-9] | 100) ICON="$ICON_BATTERY_100" ;;
[6-8][0-9]) ICON="$ICON_BATTERY_75" ;;
[3-5][0-9]) ICON="$ICON_BATTERY_50" ;;
[1-2][0-9]) ICON="$ICON_BATTERY_25" ;;
*) ICON="$ICON_BATTERY_0" ;;
esac

COLOR="$TEXT"
if echo "$BATT" | grep -q 'AC Power'; then
  ICON="$ICON_BATTERY_CHARGING"
elif [ "$PERCENTAGE" -lt 20 ]; then
  COLOR="$ACCENT"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
