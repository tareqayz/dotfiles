-- Mirage v1 palette = the "sky/*" variables in Figma (Desert collection, modes Day / Night).
-- Day or Night follows the macOS appearance; items/theme.lua reloads the bar when it flips.
-- ARGB hex, alpha first: 0xb8 = 72 %, 0xcc = 80 %, 0x99 = 60 %, 0x8c = 55 %, 0x80 = 50 %,
-- 0x4d = 30 %, 0x38 = 22 %, 0x24 = 14 %, 0x1a = 10 %.

local function dark_mode()
  local defaults = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  local style = defaults:read("a")
  defaults:close()
  return style:match("Dark") ~= nil
end

local colors = dark_mode() and {
  theme = "night",
  ink = 0xffe8ecf8,         -- sky/fg
  ink_muted = 0xb8e8ecf8,   -- sky/fg-muted
  ink_dim = 0x99e8ecf8,     -- sky/fg-dim — idle spaces
  shadow = 0x8c000000,      -- sky/shadow
  glow = 0xffb0c4f4,        -- sky/glow — weather glyph
  track = 0x4de8ecf8,       -- sky/track
  panel = 0xcc10162a,       -- sky/panel — popup background
  panel_fg = 0xffe4e8f4,    -- sky/panel-fg
  panel_muted = 0xff9ca6c6, -- sky/panel-muted
  accent = 0xffa4b8e8,      -- sky/accent
  accent_soft = 0x38a4b8e8, -- sky/accent-soft — popup row hover
  line = 0x1affffff,        -- sky/line — popup border
} or {
  theme = "day",
  ink = 0xffffffff,
  ink_muted = 0xb8ffffff,
  ink_dim = 0x99ffffff,
  shadow = 0x8014285a,
  glow = 0xffface82,
  track = 0x4dffffff,
  panel = 0xccfff7e8,
  panel_fg = 0xff382612,
  panel_muted = 0xff705638,
  accent = 0xff925820,
  accent_soft = 0x38925820,
  line = 0x245a3c1e,
}

colors.notch = 0xff000000
colors.transparent = 0x00000000

return colors
