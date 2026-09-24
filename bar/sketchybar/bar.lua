-- Bar appearance. Mirage v1: no background at all. Height matches the MacBook Pro 14" notch
-- (32 pt), items start 14 pt from each edge, and notch_width keeps center items clear of the
-- hardware notch.
local sbar = require("sketchybar")
local colors = require("colors")

sbar.bar({
  position = "top",
  height = 32,
  color = colors.transparent,
  border_width = 0,
  corner_radius = 0,
  margin = 0,
  y_offset = 0,
  blur_radius = 0,
  padding_left = 14,
  padding_right = 14,
  notch_width = 185,
  notch_display_height = 0,
  notch_offset = 0,
  display = "all",
  hidden = false,
  topmost = false,
  sticky = true,
  font_smoothing = false,
  shadow = false,
})
