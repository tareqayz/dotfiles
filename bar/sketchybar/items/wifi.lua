-- Wi‑Fi — glyph only, polled every 30 s (wifi_change no longer fires on recent macOS);
-- click opens Wi‑Fi settings.
local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local wifi = sbar.add("item", "wifi", {
  position = "right",
  padding_left = settings.right_gap,
  icon = icons.wifi,
  label = { drawing = false },
  update_freq = 30,
  click_script = "open 'x-apple.systempreferences:com.apple.wifi-settings-extension'",
})

wifi:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("ipconfig getifaddr en0 2>/dev/null", function(ip)
    if ip:find("%S") then
      wifi:set({ icon = { string = icons.wifi, color = colors.ink } })
    else
      wifi:set({ icon = { string = icons.wifi_off, color = colors.ink_muted } })
    end
  end)
end)
