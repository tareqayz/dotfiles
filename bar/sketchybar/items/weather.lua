-- Weather — sun/moon glyph in the glow color + temperature; click opens Weather.
-- Temperature from wttr.in (location from your IP), refreshed every 30 min. Glyph: sun from
-- 06:00 to 18:59, moon otherwise. If the fetch fails the glyph stays, the label hides.
local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local weather = sbar.add("item", "weather", {
  position = "right",
  padding_left = settings.right_gap,
  icon = { string = icons.sun, color = colors.glow, padding_right = 5 },
  label = { drawing = false },
  update_freq = 1800,
  click_script = "open -a Weather",
})

weather:subscribe({ "forced", "routine", "system_woke" }, function()
  local hour = os.date("*t").hour
  local icon = (hour >= 6 and hour < 19) and icons.sun or icons.moon
  sbar.exec("curl -fsS --max-time 5 'https://wttr.in/?format=%t' 2>/dev/null", function(out)
    local temp = out:gsub("[%s+C]", "") -- "+43°C" → "43°"
    if temp:match("°$") then
      weather:set({ icon = icon, label = { string = temp, drawing = true } })
    else
      weather:set({ icon = icon, label = { drawing = false } })
    end
  end)
end)
