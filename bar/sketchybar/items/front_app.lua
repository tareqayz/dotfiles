-- Front app — name of the focused app, 16 pt after the spaces (13 + 3).
local sbar = require("sketchybar")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  padding_left = 3,
  icon = { drawing = false },
  label = { font = settings.font.semibold },
})

-- INFO carries the app name.
front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = env.INFO })
end)

-- A forced update (startup, reload) has no INFO: ask AeroSpace, then System Events as a
-- fallback.
front_app:subscribe("forced", function()
  sbar.exec("aerospace list-windows --focused --format '%{app-name}' 2>/dev/null", function(name)
    if name:find("%S") then
      return front_app:set({ label = name:match("[^\n]+") })
    end
    sbar.exec([[osascript -e 'tell application "System Events" to get displayed name of first application process whose frontmost is true' 2>/dev/null]],
      function(fallback) front_app:set({ label = fallback:match("[^\n]*") }) end)
  end)
end)
