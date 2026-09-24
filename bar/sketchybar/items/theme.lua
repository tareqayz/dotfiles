-- Theme watcher (hidden). macOS posts AppleInterfaceThemeChangedNotification when the
-- appearance flips; reloading re-runs colors.lua, which picks the Day or Night palette.
local sbar = require("sketchybar")

-- Add the event before subscribing: subscribe adds it too, without the notification, and
-- SketchyBar ignores a second add of the same name.
sbar.add("event", "theme_change", "AppleInterfaceThemeChangedNotification")

local theme = sbar.add("item", "theme", { position = "right", drawing = false, updates = true })
theme:subscribe("theme_change", function()
  sbar.exec("sketchybar --reload")
end)
