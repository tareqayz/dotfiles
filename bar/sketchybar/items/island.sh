#!/bin/bash

##### Notch island #####
# The notch becomes a black island: a music wing (position q, left of the notch) and a
# Garmin wing (position e, right of it) under one black bracket. See plugins/island.sh:
#   hover a wing    → it stretches outward (title + artwork / Body Battery + stats)
#   hover the notch → both stretch
#   click a wing    → it drops its panel; the music wing swaps its title for ⏮ ⏯ ⏭
#   click the notch → both panels (they meet under the middle of the notch)
# Items are added from the notch outward. Hidden parts are drawing=off so they take no space.

ISLAND_FONT="$FONT:Bold:12.0"

# A reload draws the island collapsed, so forget any hover/open state from before it.
rm -f "${TMPDIR:-/tmp}/sketchybar_island/left" "${TMPDIR:-/tmp}/sketchybar_island/right"
island_item=(padding_left=0 padding_right=0 icon.drawing=off label.drawing=off script="$PLUGIN_DIR/island.sh")

# --- music wing (q): equalizer · controls · title · artwork -------------------------
# Position q places the first-added item next to the notch and works outward.
# Each bar item is [bar][gap]: the icon's background is the bar and a blank label is the
# gap. Keeping gaps inside items (not in item padding, which isn't part of an item's
# mouse area) leaves no dead spots between the bars, so hovering doesn't flicker.
for i in 4 3 2 1; do
  gap=2
  [ "$i" = 4 ] && gap=9
  sketchybar --add item "island.eq.$i" q \
    --set "island.eq.$i" "${island_item[@]}" updates=on \
    icon.drawing=on icon=" " icon.width=3 \
    icon.background.drawing=on icon.background.color="$ISLAND_MUTED" icon.background.height=3 \
    icon.background.corner_radius=1 \
    label.drawing=on label=" " label.width=$gap
done
# Outer margin while collapsed; plugins/island.sh drops it when the wing expands.
sketchybar --set island.eq.1 padding_left=9

control=("${island_item[@]}" drawing=off icon.drawing=on icon.font="SF Pro:Regular:13.0" icon.color="$ISLAND_TEXT"
  icon.padding_left=6 icon.padding_right=6)
sketchybar --add item island.ctl.next q --set island.ctl.next "${control[@]}" icon="$ICON_NEXT" \
  click_script="$PLUGIN_DIR/music.sh next" \
  --add item island.ctl.play q --set island.ctl.play "${control[@]}" icon="$ICON_PAUSE" \
  click_script="$PLUGIN_DIR/music.sh playpause" \
  --add item island.ctl.prev q --set island.ctl.prev "${control[@]}" icon="$ICON_PREVIOUS" \
  click_script="$PLUGIN_DIR/music.sh previous" \
  --set island.ctl.next icon.padding_right=9

sketchybar --add item island.title q \
  --set island.title "${island_item[@]}" drawing=off width=0 label.drawing=on scroll_texts=on \
  label="Not playing" label.font="$ISLAND_FONT" label.color="$TRANSPARENT" label.max_chars=17 \
  label.padding_left=8

sketchybar --add item island.art q \
  --set island.art "${island_item[@]}" drawing=off width=18 padding_left=11 \
  background.drawing=on background.height=18 background.corner_radius=4 background.color="$ISLAND_TRACK" \
  background.image.corner_radius=4 \
  popup.align=left popup.y_offset=-9 popup.height=24 popup.blur_radius=0 \
  popup.background.color="$ISLAND" popup.background.border_width=0 popup.background.corner_radius=12

# --- notch hit area (center) -----------------------------------------------------
sketchybar --add item island.notch center \
  --set island.notch "${island_item[@]}" width=185 background.drawing=off

# --- Garmin wing (e): heart · Body Battery · stats ----------------------------------
sketchybar --add item island.heart e \
  --set island.heart "${island_item[@]}" icon.drawing=on icon="$ICON_HEART_BOLT" icon.font="SF Pro:Regular:13.0" \
  icon.color="$OASIS" icon.padding_left=10 icon.padding_right=11 \
  --add item island.bb e \
  --set island.bb "${island_item[@]}" drawing=off label.drawing=on label="—" \
  label.font="$FONT:Heavy:12.5" label.color="$TRANSPARENT" label.padding_right=5 \
  --add item island.stats e \
  --set island.stats "${island_item[@]}" drawing=off width=0 label.drawing=on \
  label="· $ICON_STEPS —   $ICON_HEART —" label.font="$ISLAND_FONT" label.color="$TRANSPARENT" \
  popup.align=right popup.y_offset=-9 popup.height=24 popup.blur_radius=0 \
  popup.background.color="$ISLAND" popup.background.border_width=0 popup.background.corner_radius=12

for item in island.eq.1 island.eq.2 island.eq.3 island.eq.4 island.title island.art island.notch \
  island.heart island.bb island.stats; do
  sketchybar --subscribe "$item" mouse.entered mouse.exited mouse.clicked
done
sketchybar --subscribe island.ctl.next mouse.entered mouse.exited \
  --subscribe island.ctl.play mouse.entered mouse.exited \
  --subscribe island.ctl.prev mouse.entered mouse.exited \
  --subscribe island.notch mouse.exited.global

# One black shape over everything: taller than the bar and shifted up, so its top
# corners sit off-screen and it fuses with the notch.
sketchybar --add bracket island '/island\..*/' \
  --set island background.drawing=on background.color="$ISLAND" background.corner_radius=12 \
  background.height=44 background.y_offset=6

# --- music panel (popup of the artwork item) ----------------------------------------
# 234pt wide: from the island's left edge in the open state (x 522) to the middle of the
# notch (x 756), where the Garmin panel starts. Both panels are 144pt tall. Every popup
# row is its own window, so the cover can't hang across rows: the first row is one 72pt
# item with the cover as its background image and two text lines (icon = title,
# label = artist) stacked via y offsets on a zero-width icon.
panel_row=(padding_left=0 padding_right=0 icon.color="$ISLAND_MUTED" label.color="$ISLAND_MUTED")
sketchybar --add item musicp.now popup.island.art \
  --set musicp.now "${panel_row[@]}" width=234 scroll_texts=on \
  background.drawing=on background.color="$TRANSPARENT" background.height=72 \
  background.image=app.com.apple.Music background.image.scale=1.75 background.image.drawing=on background.image.padding_left=16 \
  background.image.corner_radius=10 \
  icon="Nothing playing" icon.font="$FONT:Heavy:14.0" icon.color="$ISLAND_TEXT" icon.padding_left=82 \
  icon.width=0 icon.y_offset=9 icon.max_chars=17 \
  label="Open Music to start" label.font="$FONT:Bold:12.0" label.padding_left=82 label.y_offset=-9 \
  label.max_chars=20 \
  --add slider musicp.progress popup.island.art 202 \
  --set musicp.progress "${panel_row[@]}" padding_left=16 icon.drawing=off label.drawing=off \
  slider.percentage=0 slider.highlight_color="$SUN" slider.knob.drawing=off \
  slider.background.height=4 slider.background.corner_radius=2 slider.background.color="$ISLAND_TRACK" \
  update_freq=1 script="$PLUGIN_DIR/music.sh" \
  --add item musicp.times popup.island.art \
  --set musicp.times "${panel_row[@]}" padding_left=16 icon="0:00" icon.font="$FONT:Bold:10.5" \
  icon.width=101 icon.align=left label="-0:00" label.font="$FONT:Bold:10.5" label.width=101 label.align=right \
  --add item musicp.open popup.island.art \
  --set musicp.open "${panel_row[@]}" padding_left=16 icon="$ICON_MUSIC" icon.font="SF Pro:Regular:12.0" \
  icon.width=18 label="Open Music" label.font="$FONT:Bold:11.5" \
  click_script="open -a Music; $PLUGIN_DIR/island.sh close"

# --- Garmin panel (popup of the stats item) — placeholder until Garmin is wired ----
# 290pt wide: from the middle of the notch to the island's right edge (hover/open state).
# A fixed text width ignores padding when measuring, so the 16pt inset lives inside icon.width.
garmin_row=(padding_left=0 padding_right=0 icon.padding_left=16 icon.width=38 icon.font="SF Pro:Regular:12.0"
  icon.color="$ISLAND_MUTED" label.font="$FONT:Bold:12.0" label.color="$ISLAND_TEXT" label.width=252)
sketchybar --add item garminp.header popup.island.stats \
  --set garminp.header "${garmin_row[@]}" icon="$ICON_WATCH" icon.color="$OASIS" \
  label="Garmin Connect · not connected" label.font="$FONT:Heavy:12.5" \
  --add item garminp.bb popup.island.stats --set garminp.bb "${garmin_row[@]}" icon="$ICON_HEART_BOLT" label="Body Battery   —" \
  --add item garminp.steps popup.island.stats --set garminp.steps "${garmin_row[@]}" icon="$ICON_STEPS" label="Steps   —" \
  --add item garminp.hr popup.island.stats --set garminp.hr "${garmin_row[@]}" icon="$ICON_HEART" label="Resting HR   —" \
  --add item garminp.sleep popup.island.stats --set garminp.sleep "${garmin_row[@]}" icon="$ICON_FOCUS_SLEEP" label="Sleep   —" \
  --add item garminp.open popup.island.stats --set garminp.open "${garmin_row[@]}" icon="$ICON_EXTERNAL" \
  label="Open Garmin Connect" label.color="$ISLAND_MUTED" \
  click_script="open https://connect.garmin.com/modern/; $PLUGIN_DIR/island.sh close"

# --- controllers (hidden) -----------------------------------------------------------
# Now playing: Music.app and Spotify broadcast a distributed notification on every change.
sketchybar --add event music_change com.apple.Music.playerInfo \
  --add event spotify_change com.spotify.client.PlaybackStateChanged \
  --add item music.ctl q \
  --set music.ctl drawing=off updates=on update_freq=15 script="$PLUGIN_DIR/music.sh" \
  --subscribe music.ctl music_change spotify_change system_woke system_will_sleep \
  --add item garmin.ctl e \
  --set garmin.ctl drawing=off updates=on update_freq=600 script="$PLUGIN_DIR/garmin.sh" \
  --subscribe garmin.ctl system_woke
