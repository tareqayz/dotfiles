#!/bin/bash

# Glyphs. SF Symbols render with icon.font="$SF_SYMBOLS"; the two bluetooth glyphs come from
# Hack Nerd Font (icon.font="$NERD_FONT") because SF Symbols has no bluetooth symbol.
# Private-use codepoints look blank in most editors — each line says which symbol it is.
# Swap one via SF Symbols.app → "Copy Symbol", or regenerate with: perl -CS -e 'print chr(0x1008FA)'
export ICON_APPLE="􀣺"  # U+1008FA applelogo
export ICON_WIFI="􀙇"  # U+100647 wifi
export ICON_WIFI_OFF="􀙈"  # U+100648 wifi.slash
export ICON_VOLUME_100="􀊩"  # U+1002A9 speaker.wave.3.fill
export ICON_VOLUME_66="􀊧"  # U+1002A7 speaker.wave.2.fill
export ICON_VOLUME_33="􀊥"  # U+1002A5 speaker.wave.1.fill
export ICON_VOLUME_0="􀊣"  # U+1002A3 speaker.slash.fill
export ICON_BLUETOOTH="󰂯"  # U+F00AF nf-md-bluetooth (Hack Nerd Font)
export ICON_BLUETOOTH_OFF="󰂲"  # U+F00B2 nf-md-bluetooth_off (Hack Nerd Font)
export ICON_SUN="􀆮"  # U+1001AE sun.max.fill
export ICON_MOON="􀇁"  # U+1001C1 moon.stars.fill
export ICON_LAPTOP="􁈸"  # U+101238 laptopcomputer
export ICON_GEAR="􀣌"  # U+1008CC gearshape.fill
export ICON_LOCK="􀎡"  # U+1003A1 lock.fill
export ICON_SLEEP="􀆾"  # U+1001BE moon.zzz.fill
export ICON_RESTART="􀅈"  # U+100148 arrow.clockwise
export ICON_POWER="􀷄"  # U+100DC4 power.circle.fill
