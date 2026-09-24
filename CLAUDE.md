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

The config is written in Lua and talks to SketchyBar through SbarLua (github.com/FelixKratz/SbarLua), a module that sends commands and receives events over mach ports. The module lives outside the repo, at `~/.local/share/sketchybar_lua/sketchybar.so`. It statically links its own copy of Lua (5.5.0) and runs it on the `lua` interpreter's state, so Homebrew's `lua` has to be the same version. If the bar comes up empty after `brew upgrade lua`, suspect this first. Install or rebuild it with `git clone https://github.com/FelixKratz/SbarLua /tmp/SbarLua && make -C /tmp/SbarLua install`. The bash version of this config is in git history (commit `8b19c7e`).

`sketchybarrc` is the entry point (`#!/usr/bin/env lua`). SketchyBar runs it with `$CONFIG_DIR` set to the config directory, and the process stays alive to handle events; on reload SketchyBar tells it to exit and starts a new one. It puts the config dir on `package.path`, then `require`s these between `sbar.begin_config()` and `sbar.end_config()`, which send the whole config as one message:
1. `bar.lua`: global `sbar.bar` properties (32 pt, transparent, 14 pt side padding, `notch_width=185`).
2. `default.lua`: `sbar.default` item properties (SF Pro fonts, the ink color, the 1 pt shadow on icon and label, popup style).
3. `items/init.lua`, which requires `items/<name>.lua` in bar order. To add an item, create `items/<name>.lua` and add a `require` line there. Right-side items are added right to left, so `clock` comes first.

Last, `sbar.event_loop()` sends a forced update (`SENDER=forced`), which draws every item's initial state, and then runs the callbacks.

Shared modules: `colors.lua` (the Day or Night `sky/*` palette, picked from the macOS appearance; `items/theme.lua` reloads the bar when the appearance changes), `icons.lua` (glyphs written as `\u{...}` escapes, because SF Symbols are private-use codepoints that look blank in most editors; the two bluetooth glyphs come from Hack Nerd Font because SF Symbols has no bluetooth symbol), `settings.lua` (fonts, and `right_gap`: the 14 pt gap between a right-side item and its left neighbour), `helpers/popup.lua` (`popup.row`: a popup row with the Apple-menu style and hover pill) and `helpers/app_icons.lua` (app name → sketchybar-app-font ligature).

Each item file creates its item with `sbar.add` and handles events in Lua callbacks (`item:subscribe(events, fn)`, where `fn` gets SketchyBar's variables as a table: `env.INFO`, `env.SENDER` and so on). Shell commands run through `sbar.exec`. Clicks that only run a shell command stay plain `click_script` strings.

Items, left to right: `apple` (click → popup with About / System Settings / Lock / Sleep / Restart / Shut Down; a row click closes the menu and runs the action), `space.<ws>` (one plain item per AeroSpace workspace, built from `aerospace list-workspaces --all` when the bar loads, with 1–9 as the fallback if the server isn't up yet; `after-startup-command` in `aerospace.toml` reloads the bar. Each shows the workspace name plus the apps open in it as sketchybar-app-font glyphs. Only workspaces with windows plus the focused one are drawn; the focused one is full ink with a 2 pt glow underline. The hidden `spaces.ctl` item re-renders all of them from a single `aerospace list-windows --all --json` call on `forced`, `aerospace_workspace_change` (from `exec-on-workspace-change`, carries `FOCUSED_WORKSPACE`), `aerospace_windows_change` (from `on-focus-changed`; AeroSpace has no window-created or window-destroyed callback, but opening, closing or moving a window changes focus), `front_app_switched` and `system_woke`. A click runs `aerospace workspace <ws>`), `front_app` (name of the focused app from `front_app_switched`; the forced update asks AeroSpace), then on the right `wifi` (polls every 30 s, click → Wi‑Fi settings), `volume` (`volume_change` event, click mutes, scroll adjusts), `bluetooth` (`blueutil`, polls every 30 s, click → Bluetooth settings), `weather` (wttr.in temperature every 30 min, sun 06–18 h and moon otherwise, click → Weather) and `clock` (date muted + time semibold, click → Calendar).

Layout gotchas (SketchyBar 2.23, all found by measuring):
- `q` items stack outward from the notch in the order they are added, so the first added sits next to the notch. `e` works the same way on the right.
- An item or text with a fixed `width=` ignores its padding when the next item is placed. Padding only shifts where it is drawn. Use text widths, or put gaps inside the item.
- Item `padding_*` is not part of an item's mouse area. Gaps there count as "outside" for `mouse.entered`/`exited`.
- Every popup row is its own window, so nothing can overhang a row. A row's height grows with its item `background.height`, but not with a text background.
- Images: scale 1.0 draws 1 px as 1 pt. `app.<bundle-id>` icons draw at about 32 pt, so scale 1.75 gives about 56 pt.
- Text and background `shadow.angle`: 90 draws the shadow below the text, 270 above it (measured with `shadow.distance=4`).

Lua gotchas (SbarLua, from its source and from testing):
- The keys of a property table reach SketchyBar in no fixed order, because Lua randomises string hashing in each process. SketchyBar's `background.color` and `shadow.color` setters also switch drawing on. So `background = { color = …, drawing = false }` comes out on or off at random. Hide it with a separate `:set` after the add (see `helpers/popup.lua`).
- `forced` and `routine` (the `update_freq` tick) only reach callbacks that subscribe to them. Callbacks match the item and the event exactly, so a forced update never runs a `theme_change` handler.
- `subscribe` clears the item's `script` and also adds each event without a notification. SketchyBar ignores a second add of the same event, so an event tied to a macOS notification has to be added before anything subscribes to it (see `items/theme.lua`).
- `sbar.exec(cmd, fn)` is async (it forks and runs `sh -c`). `fn(output, exit_code)` gets the output as a string, or as a table when it parses as a JSON array or object. `io.popen` and `os.execute` block the event loop, so they are only used while the config loads (`colors.lua`, the workspace list in `items/spaces.lua`).
- All the `set` calls made in one callback reach SketchyBar as one message.
- `sbar.update` is not `--update`: SbarLua binds that name to `event_loop`. Use `sbar.exec("sketchybar --update")` to force an update.
- `os.date` rejects `%-d` and `%-I`, and Lua 5.5 loop variables are read-only.

To apply changes, run `sketchybar --reload`; `luac -p <file>` checks syntax without reloading. Errors while the config loads (syntax errors, a failed `require`) go to `/opt/homebrew/var/log/sketchybar/sketchybar.err.log`. Errors inside callbacks, and SketchyBar's replies to bad properties, go to `sketchybar.out.log` as `[!] Lua: …` and `[i] sketchybar: …` lines. `sketchybar --trigger <event> KEY=value` runs every callback subscribed to that event, which is a handy way to test them. Never trigger `mouse.clicked` this way: it would also run the Apple menu's Sleep, Restart and Shut Down rows. The bar sits behind fullscreen apps (`topmost=off`). To screenshot it, raise it with `sketchybar --bar topmost=on show_in_fullscreen=on`, then run `sketchybar --reload` afterwards. `bar/sketchybar/README.md` is a local copy of the upstream SketchyBar config docs (properties, events, components). Use it as the reference instead of fetching the docs online. `TODO.md` lists ideas for future items.

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
