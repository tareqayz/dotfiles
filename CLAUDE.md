# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles, grouped by category (`shells/`, `editors/`, `terminals/`, `wms/`, `bar/`, `tools/`, `etc/`). There is no build, lint or test step. Configs go live through **manual symlinks** from `$HOME`/`~/.config` into this repo. `install.sh` and `docs/bootstrap.md` are empty placeholders, so nothing automates linking yet.

Symlinks that are currently live on this macOS machine (edits here take effect immediately):
- `~/.zshrc` → `shells/zsh/zshrc`
- `~/.config/nvim` → `editors/lazy-vim`
- `~/.config/sketchybar` → `bar/sketchybar`

Everything else (`wms/hypr`, `wms/i3`, `etc/ly`, `terminals/kitty`, `shells/bash`, `shells/fish`, `tools/git`, `editors/vim`) is stored but **not linked** on this machine. Several of those are Linux-only (Hyprland, i3, ly).

`docs/config-map.md` and `docs/experimental.md` are planning notes, not a description of the current layout. The layout they describe (`wm/`, `bars/`) differs from the real one (`wms/`, `bar/`). The strategy they lay out is to keep starter-kit configs (`editors/lazy-vim`, `shells/zsh-omz`) apart from future custom ones, and to switch between them by repointing the symlink with `ln -sf`.

## Gotchas

- `shells/zsh-omz` is a git submodule of oh-my-zsh, but `zshrc` sources `$HOME/.oh-my-zsh`, not the submodule.
- `editors/lazy-vim` is the stock LazyVim starter. Plugin specs go in `lua/plugins/`, and `lua/config/` holds options, keymaps and autocmds.

## SketchyBar (`bar/sketchybar/`)

This is where most of the active work happens. The current design is "Dune v2": a transparent bar, a black notch island, and one Suites launcher. It comes from the Figma file "Sketchybar", section "04 · Dune v2". `sketchybarrc` is the entry point. SketchyBar runs it with `$CONFIG_DIR` set to the config directory. It defines `PLUGIN_DIR`/`ITEMS_DIR`, then `source`s:
1. `colors.sh`: the Day or Night palette, picked from the macOS appearance. `items/theme.sh` reloads the bar when the appearance changes.
2. `icons.sh`: SF Symbol glyphs as `ICON_*` variables. They are private-use codepoints, so they look blank in most editors; each has its codepoint in a comment.
3. `bar.sh`: global `--bar` properties.
4. `default.sh`: `--default` item properties, fonts (SF Pro Rounded labels, SF Pro symbols, `sketchybar-app-font` app ligatures), the `pebble` style array and the `popup_row` helper.
5. `items/*.sh`: one file per bar item. Items are sourced, not executed, so they share its variables. To add one, create `items/<name>.sh` and add a `source` line. Right-side items are added right to left. `items/items.sh` is an unused stub.
6. A final `sketchybar --update`.

`plugins/*.sh` are the scripts items run through `script=`/`click_script=`. They run as separate processes, get `$NAME`, `$SENDER`, `$CONFIG_DIR` and so on from SketchyBar, and `source` `colors.sh`/`icons.sh` themselves (`$PLUGIN_DIR` is not set there).

- **Island** (`items/island.sh`): a music wing (position `q`), the notch (`center`, width 185) and a Garmin wing (`e`) under one black bracket. `plugins/island.sh` is the hover/click state machine. Its state lives in `$TMPDIR/sketchybar_island`, and the item file resets it on every reload. `plugins/music.sh` reads Music/Spotify over AppleScript when their distributed notifications fire. Reading never launches a player, but the ⏯ control starts Music when nothing is running. `plugins/eq.sh` animates the equalizer, but it isn't audio-reactive. `plugins/garmin.sh` is a placeholder that reads `~/.cache/sketchybar/garmin.json`.
- **Suites** (`items/suites.sh`): one launcher with paged popups. Each suite is a list of `label|glyph|app|sf|action` rows. Focus modes run a Shortcut with the mode's name.
- **Spaces** (`items/spaces.sh`): AeroSpace workspaces when AeroSpace is running (it needs an `exec-on-workspace-change` hook that triggers `aerospace_workspace_change`), otherwise native Spaces. Clicking a native space sends ⌃N. yabai is no longer used.

Layout gotchas (SketchyBar 2.23, all found by measuring):
- `q` items stack outward from the notch in the order they are added, so the first added sits next to the notch. `e` works the same way on the right.
- An item or text with a fixed `width=` ignores its padding when the next item is placed. Padding only shifts where it is drawn. Use text widths, or put gaps inside the item.
- Item `padding_*` is not part of an item's mouse area. Gaps there count as "outside" for `mouse.entered`/`exited`.
- Every popup row is its own window, so nothing can overhang a row. A row's height grows with its item `background.height`, but not with a text background.
- Images: scale 1.0 draws 1 px as 1 pt. `app.<bundle-id>` icons draw at about 32 pt, so scale 1.75 gives about 56 pt.

To apply changes, run `sketchybar --reload`. Errors go to `/opt/homebrew/var/log/sketchybar/sketchybar.err.log`. The bar sits behind fullscreen apps (`topmost=off`). To screenshot it, raise it with `sketchybar --bar topmost=on show_in_fullscreen=on`, then run `sketchybar --reload` afterwards. `bar/sketchybar/README.md` is a local copy of the upstream SketchyBar config docs (properties, events, components). Use it as the reference instead of fetching the docs online. `TODO.md` lists ideas for future items.

## Skill routing

When the user's request matches an available skill, invoke it via the Skill tool. When in doubt, invoke the skill.

Key routing rules:
- Product ideas/brainstorming → invoke /office-hours
- Strategy/scope → invoke /plan-ceo-review
- Architecture → invoke /plan-eng-review
- Design system/plan review → invoke /design-consultation or /plan-design-review
- Full review pipeline → invoke /autoplan
- Bugs/errors → invoke /investigate
- QA/testing site behavior → invoke /qa or /qa-only
- Code review/diff check → invoke /review
- Visual polish → invoke /design-review
- Ship/deploy/PR → invoke /ship or /land-and-deploy
- Save progress → invoke /context-save
- Resume context → invoke /context-restore
- Author a backlog-ready spec/issue → invoke /spec
