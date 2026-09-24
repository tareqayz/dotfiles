# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles, grouped by category (`shells/`, `editors/`, `terminals/`, `wms/`, `bar/`, `tools/`, `etc/`). There is no build, lint or test step. Configs go live through **manual symlinks** from `$HOME`/`~/.config` into this repo. `install.sh` and `docs/bootstrap.md` are empty placeholders, so nothing automates linking yet.

Symlinks that are currently live on this macOS machine (edits here take effect immediately):
- `~/.zshrc` → `shells/zsh/zshrc`
- `~/.config/nvim` → `editors/lazy-vim`
- `~/.config/sketchybar` → `bar/sketchybar`
- `~/.config/aerospace` → `wms/aerospace` (tiling WM with its own hotkeys; AeroSpace.app from the `nikitabobko/tap` cask, starts at login. It is used instead of yabai because SIP stays on)

Everything else (`wms/yabai` and `wms/skhd` (the SIP-on yabai setup that was tried and dropped), `wms/hypr`, `wms/i3`, `etc/ly`, `terminals/kitty`, `shells/bash`, `shells/fish`, `tools/git`, `editors/vim`) is stored but **not linked** on this machine. Several of those are Linux-only (Hyprland, i3, ly).

`docs/config-map.md` and `docs/experimental.md` are planning notes, not a description of the current layout. The layout they describe (`wm/`, `bars/`) differs from the real one (`wms/`, `bar/`). The strategy they lay out is to keep starter-kit configs (`editors/lazy-vim`, `shells/zsh-omz`) apart from future custom ones, and to switch between them by repointing the symlink with `ln -sf`.

## Gotchas

- `shells/zsh-omz` is a git submodule of oh-my-zsh, but `zshrc` sources `$HOME/.oh-my-zsh`, not the submodule.
- `editors/lazy-vim` is the stock LazyVim starter. Plugin specs go in `lua/plugins/`, and `lua/config/` holds options, keymaps and autocmds.

## SketchyBar (`bar/sketchybar/`)

This is where most of the active work happens. The current design is "Mirage v1": a transparent bar with nothing drawn behind the items. Glyphs and text sit straight on the wallpaper in a light "sky" ink with a 1 pt shadow, and the notch stays hardware black. It is the baseline of the Claude Design mockup in `ref/Dune Sketchybar.dc.html` (section "Turn 2 · Mirage extended"): only the simple items exist so far, none of the AI-usage rings, suites or spaces. The design lives in the Figma file "Sketchybar": Page 1 → section "05 · Mirage v1" (three 1512×982 screens: Day, Night, Apple menu open, plus a spec card with every value), the components on page "🧱 Components" → "Mirage v1 — components", and the colors as the `sky/*` variables of the Desert collection (modes Day / Night). The previous design ("Dune v2": island + suites + spaces) is in git history (commit `02e17ac`) and in the Figma section "04 · Dune v2".

`sketchybarrc` is the entry point. SketchyBar runs it with `$CONFIG_DIR` set to the config directory. It defines `PLUGIN_DIR`/`ITEMS_DIR`, then `source`s:
1. `colors.sh`: the Day or Night `sky/*` palette, picked from the macOS appearance. `items/theme.sh` reloads the bar when the appearance changes.
2. `icons.sh`: glyphs as `ICON_*` variables. SF Symbols are private-use codepoints, so they look blank in most editors; each line has its codepoint in a comment. The two bluetooth glyphs come from Hack Nerd Font because SF Symbols has no bluetooth symbol.
3. `bar.sh`: global `--bar` properties (32 pt, transparent, 14 pt side padding, `notch_width=185`).
4. `default.sh`: `--default` item properties (SF Pro fonts, the ink color, the 1 pt shadow on icon and label, popup style), the `right_item` array (14 pt gap to the left neighbour) and the `popup_row` helper.
5. `items/*.sh`: one file per bar item. Items are sourced, not executed, so they share its variables. To add one, create `items/<name>.sh` and add a `source` line. Right-side items are added right to left, so `clock.sh` is sourced first.
6. A final `sketchybar --update`.

`plugins/*.sh` are the scripts items run through `script=`/`click_script=`. They run as separate processes, get `$NAME`, `$SENDER`, `$CONFIG_DIR` and so on from SketchyBar, and `source` `colors.sh`/`icons.sh` themselves (`$PLUGIN_DIR` is not set there).

Items, left to right: `apple` (click → popup with About / System Settings / Lock / Sleep / Restart / Shut Down; `plugins/apple.sh` runs the actions, `plugins/popup.sh` does the row hover), `space.<ws>` (one plain item per AeroSpace workspace, built from `aerospace list-workspaces --all` when the bar loads, with 1–9 as the fallback if the server isn't up yet; `after-startup-command` in `aerospace.toml` reloads the bar. Each shows the workspace name plus the apps open in it as sketchybar-app-font glyphs via `plugins/icon_map.sh`. Only workspaces with windows plus the focused one are drawn; the focused one is full ink with a 2 pt glow underline. The hidden `spaces.ctl` item re-renders all of them from a single `aerospace list-windows --all` call on `aerospace_workspace_change` (from `exec-on-workspace-change`, carries `$FOCUSED_WORKSPACE`), `aerospace_windows_change` (from `on-focus-changed`; AeroSpace has no window-created or window-destroyed callback, but opening, closing or moving a window changes focus), `front_app_switched` and `system_woke`. A click runs `aerospace workspace <ws>`. Plugins run under macOS `/bin/bash` 3.2, which has no associative arrays), `front_app` (name of the focused app from `front_app_switched`), then on the right `wifi` (polls every 30 s, click → Wi‑Fi settings), `volume` (`volume_change` event, click mutes, scroll adjusts), `bluetooth` (`blueutil`, polls every 30 s, click → Bluetooth settings), `weather` (wttr.in temperature every 30 min, sun 06–18 h and moon otherwise, click → Weather) and `clock` (date muted + time semibold, click → Calendar).

Layout gotchas (SketchyBar 2.23, all found by measuring):
- `q` items stack outward from the notch in the order they are added, so the first added sits next to the notch. `e` works the same way on the right.
- An item or text with a fixed `width=` ignores its padding when the next item is placed. Padding only shifts where it is drawn. Use text widths, or put gaps inside the item.
- Item `padding_*` is not part of an item's mouse area. Gaps there count as "outside" for `mouse.entered`/`exited`.
- Every popup row is its own window, so nothing can overhang a row. A row's height grows with its item `background.height`, but not with a text background.
- Images: scale 1.0 draws 1 px as 1 pt. `app.<bundle-id>` icons draw at about 32 pt, so scale 1.75 gives about 56 pt.
- Text and background `shadow.angle`: 90 draws the shadow below the text, 270 above it (measured with `shadow.distance=4`).

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
