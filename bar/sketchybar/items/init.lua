-- Left — apple · spaces · front app
require("items.apple")
require("items.spaces")
require("items.front_app")

-- Right — items are added right to left, so the clock ends up at the edge
require("items.clock")
require("items.weather")
require("items.bluetooth")
require("items.volume")
require("items.wifi")

-- Hidden helper: reload when the macOS appearance flips between Day and Night
require("items.theme")
