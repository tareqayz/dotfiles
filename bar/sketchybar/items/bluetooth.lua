-- Bluetooth — glyph only (Hack Nerd Font), polled every 30 s; click opens Bluetooth settings.
-- On + something connected → ink. On but idle → muted. Off → muted "off" glyph.
local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local bluetooth = sbar.add("item", "bluetooth", {
  position = "right",
  padding_left = settings.right_gap,
  icon = { string = icons.bluetooth, font = settings.font.nerd },
  label = { drawing = false },
  update_freq = 30,
  click_script = "open 'x-apple.systempreferences:com.apple.BluetoothSettings'",
})

-- Prints the power state ("1" = on), then one line per connected device. Uses blueutil
-- (brew install blueutil); without it the power state comes from the Bluetooth prefs plist
-- and the connected devices are unknown, which counts as connected.
local query = os.execute("command -v blueutil >/dev/null 2>&1")
    and "blueutil -p; blueutil --connected"
    or "defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState; echo unknown"

bluetooth:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("{ " .. query .. "; } 2>/dev/null", function(out)
    local power, devices = out:match("^([^\n]*)\n?(.*)$")
    if power == "1" then
      local color = devices:find("%S") and colors.ink or colors.ink_muted
      bluetooth:set({ icon = { string = icons.bluetooth, color = color } })
    else
      bluetooth:set({ icon = { string = icons.bluetooth_off, color = colors.ink_muted } })
    end
  end)
end)
