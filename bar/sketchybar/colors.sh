#!/bin/bash

# Dune palette. Values mirror the "Desert" variables in Figma (modes Day / Night).
# The bar follows the macOS appearance; items/theme.sh reloads on a change.

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  export THEME=night
  export PEBBLE=0xff232c42
  export PEBBLE_HOVER=0xff2f3a55
  export PEBBLE_BORDER=0x24eadcc2
  export TEXT=0xffefe3cb
  export TEXT_MUTED=0xff8e97ae
  export ACCENT=0xffe89a58
  export ON_ACCENT=0xff1b2030
  export POPUP=0xf7182033
  export POPUP_BORDER=0xff303b57
  export DIVIDER=0xff29334b
  export ROW_HOVER=0xff222b41
  export SUN=0xfff29a60
  export OASIS=0xff5cd3be
else
  export THEME=day
  export PEBBLE=0xffe8d5b0
  export PEBBLE_HOVER=0xffddc59b
  export PEBBLE_BORDER=0x8cffffff
  export TEXT=0xff3a2616
  export TEXT_MUTED=0xff7a604a
  export ACCENT=0xffb9582f
  export ON_ACCENT=0xfffff6e8
  export POPUP=0xf7fbf3e4
  export POPUP_BORDER=0xffe0cba4
  export DIVIDER=0xffeadbbf
  export ROW_HOVER=0xfff0e3c9
  export SUN=0xffee8b4e
  export OASIS=0xff52c7b2
fi

# The notch island is hardware black in both modes.
export ISLAND=0xff000000
export ISLAND_TEXT=0xfff3e7d0
export ISLAND_MUTED=0xff9c9080
export ISLAND_TRACK=0xff2b2723
export ISLAND_HOVER=0xff1e1b18

export TRANSPARENT=0x00000000
