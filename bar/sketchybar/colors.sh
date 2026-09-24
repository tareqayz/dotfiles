#!/bin/bash

# Mirage v1 palette = the "sky/*" variables in Figma (Desert collection, modes Day / Night).
# Day or Night follows the macOS appearance; items/theme.sh reloads the bar when it flips.
# ARGB hex, alpha first: 0xb8 = 72 %, 0xcc = 80 %, 0x8c = 55 %, 0x80 = 50 %, 0x4d = 30 %,
# 0x38 = 22 %, 0x24 = 14 %, 0x1a = 10 %.

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  export THEME=night
  export INK=0xffe8ecf8          # sky/fg
  export INK_MUTED=0xb8e8ecf8    # sky/fg-muted
  export INK_DIM=0x99e8ecf8      # sky/fg-dim — idle spaces
  export SHADOW=0x8c000000       # sky/shadow
  export GLOW=0xffb0c4f4         # sky/glow — weather glyph
  export TRACK=0x4de8ecf8        # sky/track
  export PANEL=0xcc10162a        # sky/panel — popup background
  export PANEL_FG=0xffe4e8f4     # sky/panel-fg
  export PANEL_MUTED=0xff9ca6c6  # sky/panel-muted
  export ACCENT=0xffa4b8e8       # sky/accent
  export ACCENT_SOFT=0x38a4b8e8  # sky/accent-soft — popup row hover
  export LINE=0x1affffff         # sky/line — popup border
else
  export THEME=day
  export INK=0xffffffff
  export INK_MUTED=0xb8ffffff
  export INK_DIM=0x99ffffff
  export SHADOW=0x8014285a
  export GLOW=0xffface82
  export TRACK=0x4dffffff
  export PANEL=0xccfff7e8
  export PANEL_FG=0xff382612
  export PANEL_MUTED=0xff705638
  export ACCENT=0xff925820
  export ACCENT_SOFT=0x38925820
  export LINE=0x245a3c1e
fi

export NOTCH=0xff000000
export TRANSPARENT=0x00000000
