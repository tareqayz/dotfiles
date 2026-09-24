-- Apple — the logo; click opens a small system menu.
local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local popup = require("helpers.popup")

local apple = sbar.add("item", "apple", {
  icon = icons.apple,
  padding_right = 16,
  label = { drawing = false },
  popup = { align = "left" },
})

-- The logo glows while the menu is open.
local open = false
local function show(state)
  open = state
  apple:set({
    popup = { drawing = state },
    icon = { color = state and colors.glow or colors.ink },
  })
end

apple:subscribe("mouse.clicked", function() show(not open) end)
apple:subscribe("mouse.exited.global", function() show(false) end)

-- A row click closes the menu, then runs the row's command.
local function run(command)
  return function()
    show(false)
    sbar.exec(command)
  end
end

local width = 180 -- label column
popup.row(apple, "about", width, icons.laptop, "About This Mac",
  run("open 'x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension'"))
popup.row(apple, "settings", width, icons.gear, "System Settings…", run("open -a 'System Settings'"))
popup.row(apple, "lock", width, icons.lock, "Lock Screen", run("pmset displaysleepnow"))
popup.row(apple, "sleep", width, icons.sleep, "Sleep", run("pmset sleepnow"))
popup.row(apple, "restart", width, icons.restart, "Restart…",
  run([[osascript -e 'tell application "loginwindow" to «event aevtrrst»']]))
popup.row(apple, "shutdown", width, icons.power, "Shut Down…",
  run([[osascript -e 'tell application "loginwindow" to «event aevtrsdn»']]))
