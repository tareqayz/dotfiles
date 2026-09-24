-- Clock — date (muted, Medium) + time (Semibold); click opens Calendar.
local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local clock = sbar.add("item", "clock", {
  position = "right",
  padding_left = settings.right_gap,
  icon = { font = settings.font.medium, color = colors.ink_muted, padding_right = 6 },
  label = { font = settings.font.semibold },
  update_freq = 10,
  click_script = "open -a Calendar",
})

-- Date in the icon slot ("Thu 24"), time in the label ("3:03 PM"). os.date has no %-d or %-I,
-- so the leading zeros are stripped by hand.
clock:subscribe({ "forced", "routine", "system_woke" }, function()
  clock:set({
    icon = (os.date("%a %d"):gsub(" 0", " ")),
    label = (os.date("%I:%M %p"):gsub("^0", "")),
  })
end)
