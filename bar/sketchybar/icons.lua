-- Glyphs. SF Symbols render with the settings.font.symbols font; the two bluetooth glyphs come
-- from Hack Nerd Font (settings.font.nerd) because SF Symbols has no bluetooth symbol.
-- They are private-use codepoints, written as \u{...} escapes because the glyphs themselves look
-- blank in most editors. A glyph copied from SF Symbols.app ("Copy Symbol") also works pasted
-- between the quotes.
return {
  apple = "\u{1008FA}",        -- applelogo
  wifi = "\u{100647}",         -- wifi
  wifi_off = "\u{100648}",     -- wifi.slash
  volume_100 = "\u{1002A9}",   -- speaker.wave.3.fill
  volume_66 = "\u{1002A7}",    -- speaker.wave.2.fill
  volume_33 = "\u{1002A5}",    -- speaker.wave.1.fill
  volume_0 = "\u{1002A3}",     -- speaker.slash.fill
  bluetooth = "\u{F00AF}",     -- nf-md-bluetooth (Hack Nerd Font)
  bluetooth_off = "\u{F00B2}", -- nf-md-bluetooth_off (Hack Nerd Font)
  sun = "\u{1001AE}",          -- sun.max.fill
  moon = "\u{1001C1}",         -- moon.stars.fill
  laptop = "\u{101238}",       -- laptopcomputer
  gear = "\u{1008CC}",         -- gearshape.fill
  lock = "\u{1003A1}",         -- lock.fill
  sleep = "\u{1001BE}",        -- moon.zzz.fill
  restart = "\u{100148}",      -- arrow.clockwise
  power = "\u{100DC4}",        -- power.circle.fill
}
