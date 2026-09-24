-- Defaults for every item added after this point. Ink on the sky with a 1 pt shadow straight
-- below (angle 90 = down, no blur — SketchyBar shadows are hard offsets). Popups are the
-- frosted "sky/panel" cards from Figma.
local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local shadow = { drawing = true, color = colors.shadow, distance = 1, angle = 90 }

sbar.default({
  updates = "when_shown",
  padding_left = 0,
  padding_right = 0,
  icon = {
    font = settings.font.symbols,
    color = colors.ink,
    padding_left = 0,
    padding_right = 0,
    shadow = shadow,
  },
  label = {
    font = settings.font.regular,
    color = colors.ink,
    padding_left = 0,
    padding_right = 0,
    shadow = shadow,
  },
  background = { drawing = false },
  popup = {
    background = {
      color = colors.panel,
      border_color = colors.line,
      border_width = 1,
      corner_radius = 16,
    },
    blur_radius = 30,
    height = 32,
    y_offset = 8,
  },
})
