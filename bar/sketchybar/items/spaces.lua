-- Spaces — AeroSpace workspaces.
-- One item per workspace: its name (mono) + the apps open in it (app glyphs).
-- Only workspaces that have windows, plus the focused one, are drawn. The focused one is
-- full ink with a 2 pt glow underline 3 pt above the bottom; the others are dimmed.
-- Figma: "Mirage v1/Space". AeroSpace workspaces are not native Spaces, so these are plain
-- items fed by the triggers in wms/aerospace/aerospace.toml, not `space` components.
local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")
local app_icon = require("helpers.app_icons")

-- Workspaces come from the AeroSpace server; if it isn't up yet, fall back to 1–9
-- (aerospace.toml reloads the bar after startup).
local function list_workspaces()
  local aerospace = io.popen("aerospace list-workspaces --all 2>/dev/null")
  local names = {}
  for name in aerospace:lines() do
    names[#names + 1] = name
  end
  aerospace:close()
  if #names == 0 then
    for i = 1, 9 do names[i] = tostring(i) end
  end
  return names
end

local workspaces = list_workspaces()
local spaces = {}
for _, ws in ipairs(workspaces) do
  spaces[ws] = sbar.add("item", "space." .. ws, {
    drawing = false,
    padding_left = 0,
    padding_right = 13,
    icon = { string = ws, font = settings.font.mono, color = colors.ink_dim, padding_right = 0 },
    label = { font = settings.font.apps, color = colors.ink_dim, y_offset = -1, drawing = false },
    background = { color = colors.glow, height = 2, corner_radius = 1, y_offset = -12 },
    click_script = "aerospace workspace " .. ws,
  })
  -- The underline starts hidden. It is a separate set because setting background.color turns
  -- the background on (see helpers/popup.lua).
  spaces[ws]:set({ background = { drawing = false } })
end

-- Workspace → its apps as space-separated ligatures, sorted by app name and without
-- duplicates, e.g. { ["2"] = ":ghostty: :iterm:" }.
local function app_glyphs(windows)
  local apps = {}
  for _, window in ipairs(windows) do
    apps[window.workspace] = apps[window.workspace] or {}
    apps[window.workspace][window["app-name"]] = true
  end

  local glyphs = {}
  for ws, set in pairs(apps) do
    local names = {}
    for name in pairs(set) do names[#names + 1] = name end
    table.sort(names, function(a, b) return a:lower() < b:lower() end)
    local ligatures = {}
    for i, name in ipairs(names) do ligatures[i] = app_icon(name) end
    glyphs[ws] = table.concat(ligatures, " ")
  end
  return glyphs
end

-- Redraws every workspace from one list-windows call (SbarLua sends all the sets of a
-- callback as one message). Drawn when it has apps or is focused; focused = ink + underline,
-- otherwise dimmed.
local function render(focused)
  local list = "aerospace list-windows --all --json --format '%{workspace}%{app-name}' 2>/dev/null"
  sbar.exec(list, function(windows)
    if type(windows) ~= "table" then return end
    local glyphs = app_glyphs(windows)
    for _, ws in ipairs(workspaces) do
      local apps = glyphs[ws] or ""
      local on = ws == focused
      local ink = on and colors.ink or colors.ink_dim
      spaces[ws]:set({
        drawing = on or apps ~= "",
        icon = { color = ink, padding_right = apps ~= "" and 4 or 0 },
        label = { string = apps, color = ink, drawing = apps ~= "" },
        background = { drawing = on },
      })
    end
  end)
end

-- Hidden controller. aerospace_workspace_change (focus moved, carries FOCUSED_WORKSPACE) and
-- aerospace_windows_change (window focus changed: opened, closed, moved) are triggered by
-- AeroSpace; every other event asks it for the focused workspace.
sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_windows_change")

local ctl = sbar.add("item", "spaces.ctl", { drawing = false, updates = true })
ctl:subscribe({
  "forced",
  "aerospace_workspace_change",
  "aerospace_windows_change",
  "front_app_switched",
  "system_woke",
}, function(env)
  if env.FOCUSED_WORKSPACE and env.FOCUSED_WORKSPACE ~= "" then
    return render(env.FOCUSED_WORKSPACE)
  end
  sbar.exec("aerospace list-workspaces --focused 2>/dev/null", function(focused)
    render(focused:match("[^\n]+"))
  end)
end)
