-- Volume — glyph only; click toggles mute, scroll changes the level.
local sbar = require("sketchybar")
local icons = require("icons")
local settings = require("settings")

local volume = sbar.add("item", "volume", {
  position = "right",
  padding_left = settings.right_gap,
  icon = icons.volume_100,
  label = { drawing = false },
})

local get_settings = "osascript -e 'get volume settings'"

-- Draws the glyph from the `get volume settings` output, e.g.
-- "output volume:25, input volume:0, alert volume:100, output muted:false".
local function render(volume_settings)
  local level = tonumber(volume_settings:match("output volume:(%d+)")) or 0
  local icon = icons.volume_100
  if volume_settings:match("output muted:true") or level < 1 then
    icon = icons.volume_0
  elseif level < 30 then
    icon = icons.volume_33
  elseif level < 60 then
    icon = icons.volume_66
  end
  volume:set({ icon = icon })
end

volume:subscribe({ "forced", "volume_change" }, function()
  sbar.exec(get_settings, render)
end)

volume:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'set volume output muted not (output muted of (get volume settings))' -e 'get volume settings'",
    render)
end)

-- 2 % per scroll step, clamped to 0–100; volume_change then redraws the glyph.
volume:subscribe("mouse.scrolled", function(env)
  sbar.exec(get_settings, function(volume_settings)
    local level = tonumber(volume_settings:match("output volume:(%d+)"))
    if not level then return end
    level = math.max(0, math.min(100, level + (tonumber(env.SCROLL_DELTA) or 0) * 2))
    sbar.exec("osascript -e 'set volume output volume " .. level .. "'")
  end)
end)
