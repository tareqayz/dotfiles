#!/bin/bash

# Date in the icon slot ("Thu 24"), time in the label ("3:03 PM").
sketchybar --set "$NAME" icon="$(date '+%a %-d')" label="$(date '+%-I:%M %p')"
