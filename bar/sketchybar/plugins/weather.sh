#!/bin/bash

# Temperature from wttr.in (location from your IP), refreshed every 30 min.
# Glyph: sun from 06:00 to 18:59, moon otherwise. If the fetch fails the glyph stays, the label hides.

source "$CONFIG_DIR/icons.sh"

hour=$(date '+%-H')
if [ "$hour" -ge 6 ] && [ "$hour" -lt 19 ]; then icon="$ICON_SUN"; else icon="$ICON_MOON"; fi

temp="$(curl -fsS --max-time 5 'https://wttr.in/?format=%t' 2>/dev/null | tr -d '+C ')"
case "$temp" in
*°) sketchybar --set "$NAME" icon="$icon" label="$temp" label.drawing=on ;;
*) sketchybar --set "$NAME" icon="$icon" label.drawing=off ;;
esac
