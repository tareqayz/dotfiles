#!/bin/bash

# Garmin wing — placeholder until a fetcher is wired up.
# Garmin Connect has no public consumer API; a future job (e.g. the unofficial
# python-garminconnect library, run every ~10 min) only needs to write this file:
#
#   ~/.cache/sketchybar/garmin.json
#   { "body_battery": 72, "steps": 8412, "steps_goal": 10000,
#     "resting_hr": 52, "sleep_score": 84, "sleep": "7 h 32 m" }
#
# Without the file the wing shows dashes.

source "$CONFIG_DIR/icons.sh"

DATA="$HOME/.cache/sketchybar/garmin.json"
[ -f "$DATA" ] || exit 0

field() { jq -r ".$1 // \"—\"" "$DATA" 2>/dev/null; }

bb="$(field body_battery)"
steps="$(jq -r 'if .steps then (.steps | tostring | [while(length>0; .[:-3]) | .[-3:]] | reverse | join(",")) else "—" end' "$DATA" 2>/dev/null)"
hr="$(field resting_hr)"
sleep_score="$(field sleep_score)"
sleep_len="$(field sleep)"

sketchybar --set island.bb label="$bb" \
  --set island.stats label="· $ICON_STEPS $steps   $ICON_HEART $hr" \
  --set garminp.header label="Garmin Connect" \
  --set garminp.bb label="Body Battery   $bb" \
  --set garminp.steps label="Steps   $steps" \
  --set garminp.hr label="Resting HR   $hr bpm" \
  --set garminp.sleep label="Sleep   $sleep_score · $sleep_len"
