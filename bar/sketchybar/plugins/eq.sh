#!/bin/bash

# Equalizer motion while music plays. music.sh sets update_freq=1 on island.eq.1, and
# every run queues ~1 s of random keyframes for all four bars in one sketchybar call
# (chained --animate keyframes), so the bars move continuously without a background
# loop. The middle bars get a wider range, like a real spectrum.
#
# Not audio-reactive: that needs a system-audio tap helper (Core Audio process tap).

source "$CONFIG_DIR/colors.sh"

args=(--animate sin 7)
for i in 1 2 3 4; do
  case $i in
  1) lo=4 hi=11 ;;
  2) lo=6 hi=15 ;;
  3) lo=5 hi=14 ;;
  4) lo=3 hi=10 ;;
  esac
  frames=()
  for _ in 1 2 3 4 5 6 7 8 9; do
    frames+=("icon.background.height=$((lo + RANDOM % (hi - lo + 1)))")
  done
  args+=(--set "island.eq.$i" icon.background.color="$SUN" "${frames[@]}")
done

sketchybar "${args[@]}"
