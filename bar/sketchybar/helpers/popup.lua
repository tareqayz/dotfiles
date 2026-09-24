-- Popup row ("Mirage v1/Apple menu" in Figma): a 20 pt glyph column + label, with a 28 pt
-- pill behind the row while the mouse is over it.
local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local popup = {}

-- Adds the row "<parent>.<key>" to parent's popup; on_click runs when it is clicked.
function popup.row(parent, key, label_width, glyph, text, on_click)
  local row = sbar.add("item", parent.name .. "." .. key, {
    position = "popup." .. parent.name,
    padding_left = 6,
    padding_right = 6,
    icon = {
      string = glyph,
      font = settings.font.symbols,
      width = 20,
      align = "center",
      padding_left = 8,
      color = colors.panel_muted,
      shadow = { drawing = false },
    },
    label = {
      string = text,
      font = settings.font.medium,
      color = colors.panel_fg,
      padding_left = 8,
      padding_right = 8,
      width = label_width,
      shadow = { drawing = false },
    },
    background = {
      color = colors.accent_soft,
      corner_radius = 8,
      height = 28,
    },
  })
  -- Hide the pill in a set of its own: setting background.color turns the background on,
  -- and SbarLua sends a table's keys in no fixed order.
  row:set({ background = { drawing = false } })

  row:subscribe("mouse.entered", function() row:set({ background = { drawing = true } }) end)
  row:subscribe("mouse.exited", function() row:set({ background = { drawing = false } }) end)
  row:subscribe("mouse.clicked", on_click)
  return row
end

return popup
