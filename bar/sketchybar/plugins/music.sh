#!/bin/bash

# Now playing for the island's music wing.
# Music.app and Spotify broadcast a distributed notification on every change
# (music_change / spotify_change, see items/island.sh). SketchyBar's media_change is
# deprecated on macOS 26+, so this asks the player directly via AppleScript — only
# when it is already running, so nothing gets launched by accident.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

S="${TMPDIR:-/tmp}/sketchybar_island"
mkdir -p "$S"
US=$'\x1f' # field separator (titles can contain anything else)

player() {
  if pgrep -xq Spotify && [ "$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)" = "playing" ]; then
    echo Spotify
  elif pgrep -xq Music; then
    echo Music
  elif pgrep -xq Spotify; then
    echo Spotify
  fi
}

# → state US name US artist US album US duration(s) US position(s) US id
query() {
  case "$1" in
  Music)
    osascript <<'OSA' 2>/dev/null
tell application "Music"
  if player state is stopped then return "stopped"
  set t to current track
  set d to character id 31
  return (player state as string) & d & (name of t) & d & (artist of t) & d & (album of t) & d & ((duration of t) as integer) & d & ((player position) as integer) & d & (persistent ID of t)
end tell
OSA
    ;;
  Spotify)
    osascript <<'OSA' 2>/dev/null
tell application "Spotify"
  if player state is stopped then return "stopped"
  set t to current track
  set d to character id 31
  return (player state as string) & d & (name of t) & d & (artist of t) & d & (album of t) & d & (((duration of t) / 1000) as integer) & d & ((player position) as integer) & d & (id of t)
end tell
OSA
    ;;
  *) echo stopped ;;
  esac
}

# Cover art → one PNG per track (new path per track so SketchyBar reloads the image).
artwork() {
  local file="$S/cover-$2.png" url
  if [ ! -f "$file" ]; then
    rm -f "$S"/cover-*.png "$S/cover.raw"
    case "$1" in
    Music)
      osascript - "$S/cover.raw" <<'OSA' >/dev/null 2>&1
on run argv
  tell application "Music"
    try
      set d to raw data of artwork 1 of current track
    on error
      return "none"
    end try
  end tell
  set f to open for access (POSIX file (item 1 of argv)) with write permission
  set eof f to 0
  write d to f
  close access f
  return "ok"
end run
OSA
      ;;
    Spotify)
      url="$(osascript -e 'tell application "Spotify" to artwork url of current track' 2>/dev/null)"
      [ -n "$url" ] && curl -fsSL --max-time 5 "$url" -o "$S/cover.raw"
      ;;
    esac
    [ -s "$S/cover.raw" ] && sips -s format png -Z 128 "$S/cover.raw" --out "$file" >/dev/null 2>&1
  fi
  if [ -f "$file" ]; then
    sketchybar --set island.art background.image="$file" background.image.scale=0.14 background.image.drawing=on \
      --set musicp.now background.image="$file" background.image.scale=0.4375
  else
    idle_cover "$1"
  fi
}

# No artwork: the wing keeps its empty tile, the panel shows the player's app icon.
idle_cover() {
  local bundle=com.apple.Music
  [ "$1" = Spotify ] && bundle=com.spotify.client
  sketchybar --set island.art background.image.drawing=off \
    --set musicp.now background.image="app.$bundle" background.image.scale=1.75
}

# While playing, island.eq.1 runs eq.sh every second; the first beat starts right away.
eq_on() {
  sketchybar --set island.eq.1 update_freq=1 --set island.ctl.play icon="$ICON_PAUSE"
  "$CONFIG_DIR/plugins/eq.sh"
}

eq_off() {
  sketchybar --set island.eq.1 update_freq=0 --set island.ctl.play icon="$ICON_PLAY" \
    --animate sin 20 \
    --set island.eq.1 icon.background.height=3 icon.background.color="$ISLAND_MUTED" \
    --set island.eq.2 icon.background.height=3 icon.background.color="$ISLAND_MUTED" \
    --set island.eq.3 icon.background.height=3 icon.background.color="$ISLAND_MUTED" \
    --set island.eq.4 icon.background.height=3 icon.background.color="$ISLAND_MUTED"
}

fmt() { printf '%d:%02d' $(($1 / 60)) $(($1 % 60)); }

refresh() {
  local p st name artist album dur pos id app
  p="$(player)"
  app="${p:-Music}"
  IFS="$US" read -r st name artist album dur pos id <<<"$(query "$p")"
  [ -z "$st" ] && st=stopped
  echo "$st" >"$S/music_state"

  sketchybar --set musicp.open label="Open $app" click_script="open -a $app; $CONFIG_DIR/plugins/island.sh close"
  if [ "$st" = playing ] || [ "$st" = paused ]; then
    sketchybar --set island.title label="$name" --set musicp.now icon="$name" label="$artist"
    artwork "$p" "${id//[^A-Za-z0-9]/}"
  else
    sketchybar --set island.title label="Not playing" \
      --set musicp.now icon="Nothing playing" label="Open $app to start" \
      --set musicp.times icon="0:00" label="-0:00" --set musicp.progress slider.percentage=0
    idle_cover "$app"
  fi

  if [ "$st" = playing ]; then eq_on; else eq_off; fi
}

progress() {
  local p st name artist album dur pos id
  p="$(player)"
  [ -z "$p" ] && return
  IFS="$US" read -r st name artist album dur pos id <<<"$(query "$p")"
  [ "${dur:-0}" -gt 0 ] 2>/dev/null || return
  sketchybar --set musicp.progress slider.percentage=$((pos * 100 / dur)) \
    --set musicp.times icon="$(fmt "$pos")" label="-$(fmt $((dur - pos)))"
}

# Controls (click_script of the island's ⏮ ⏯ ⏭ items).
case "$1" in
playpause | next | previous)
  p="$(player)"
  case "$1" in
  playpause) cmd="playpause" ;;
  next) cmd="next track" ;;
  previous) cmd="previous track" ;;
  esac
  osascript -e "tell application \"${p:-Music}\" to $cmd" >/dev/null 2>&1
  sleep 0.2
  refresh
  exit 0
  ;;
esac

if [ "$NAME" = "musicp.progress" ]; then
  progress
  exit 0
fi

case "$SENDER" in
system_will_sleep) eq_off ;;
*) refresh ;;
esac
