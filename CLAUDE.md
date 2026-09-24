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

This is where most of the active work happens. `sketchybarrc` is the entry point. SketchyBar runs it with `$CONFIG_DIR` set to the config directory. It defines `PLUGIN_DIR`/`ITEMS_DIR`, then `source`s:
1. `bar.sh`: global `--bar` properties
2. `default.sh`: `--default` item properties (Hack Nerd Font, white icons and labels)
3. `items/*.sh`: one file per bar item, each doing `sketchybar --add item … --set …`. To add an item, create `items/<name>.sh` and add a `source` line to `sketchybarrc`. Items are sourced, not executed, so they share its variables. `items/items.sh` is an unused stub.
4. A final `sketchybar --update`

`plugins/*.sh` are the scripts items run through `script=`/`click_script=` (event handlers, toggles). They run as separate processes and get `$NAME`, `$SELECTED` and so on from SketchyBar. Several plugins (clock, volume, battery, front_app) are only referenced from commented-out blocks in `sketchybarrc`.

Icons come from three fonts: SF Symbols glyphs (`SF Pro`/`SF Pro Rounded`, private-use codepoints that may render as blanks), Hack Nerd Font, and `sketchybar-app-font` (`:app_name:` ligatures). Space items call `yabai -m space --focus`.

To apply changes, run `sketchybar --reload`. To see errors, stop the brew service and run `sketchybar` in the foreground. `bar/sketchybar/README.md` is a local copy of the upstream SketchyBar config docs (properties, events, components). Use it as the reference instead of fetching the docs online. `TODO.md` lists ideas for future items.

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
