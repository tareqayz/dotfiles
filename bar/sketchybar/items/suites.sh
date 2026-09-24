#!/bin/bash

##### Suites — one launcher with a paged popup #####
# Page "menu" lists the suites; clicking one swaps the popup to that suite's apps
# (plugins/suites.sh toggles drawing per group), with a "‹ Suites" row to go back.
# Row format: label | icon | font (app = sketchybar-app-font, sf = SF Symbols) | action
#   action: app:<Application name> · url:<link> · cmd:<plugins/suites.sh command>

SUITES=(
  "design|$ICON_DESIGN|Design"
  "dev|$ICON_DEV|Dev Tools"
  "agents|$ICON_AGENTS|Agents"
  "library|$ICON_LIBRARY|Library"
  "studio|$ICON_STUDIO|Studio"
  "work|$ICON_WORK|Work"
  "focus|$ICON_FOCUS|Focus"
)

design=(
  "Figma|:figma:|app|app:Figma"
  "Canva|$ICON_APP_CANVA|sf|app:Canva"
  "Excalidraw|$ICON_APP_EXCALIDRAW|sf|url:https://excalidraw.com"
  "Blender|:blender:|app|app:Blender"
  "Sketch|:sketch:|app|app:Sketch"
  "SketchUp|$ICON_APP_SKETCHUP|sf|app:SketchUp 2026"
  "FreeCAD|:freecad:|app|app:FreeCAD"
)
dev=(
  "Ghostty|:ghostty:|app|app:Ghostty"
  "Neovim|:neovim:|app|cmd:nvim"
  "Cursor|:cursor:|app|app:Cursor"
  "VS Code|:code:|app|app:Visual Studio Code"
  "Xcode|:xcode:|app|app:Xcode"
  "Docker|:docker:|app|app:Docker"
  "Postman|:postman:|app|app:Postman"
  "GitHub|:git_hub:|app|url:https://github.com"
)
agents=(
  "Claude|:claude:|app|app:Claude"
  "ChatGPT|:openai:|app|app:ChatGPT"
  "Gemini|:gemini:|app|app:Gemini"
  "Perplexity|:perplexity:|app|app:Perplexity"
  "Grok|$ICON_APP_GROK|sf|app:Grok Bot"
  "Ollama|:ollama:|app|app:Ollama"
  "Agent Orchestrator|$ICON_APP_ORCHESTRATOR|sf|app:Agent Orchestrator"
)
library=(
  "Books|:apple_books:|app|app:Books"
  "Journal|:journal:|app|app:Journal"
  "Notes|:notes:|app|app:Notes"
  "Obsidian|:obsidian:|app|app:Obsidian"
  "Anki|:anki:|app|app:Anki"
  "OneNote|$ICON_APP_ONENOTE|sf|app:Microsoft OneNote"
)
studio=(
  "Music|:music:|app|app:Music"
  "Podcasts|:podcasts:|app|app:Podcasts"
  "GarageBand|$ICON_APP_GARAGEBAND|sf|app:GarageBand"
  "Final Cut Pro|:final_cut_pro:|app|app:Final Cut Pro"
  "iMovie|$ICON_APP_IMOVIE|sf|app:iMovie"
  "OBS|:obsstudio:|app|app:OBS"
)
work=(
  "Word|:microsoft_word:|app|app:Microsoft Word"
  "Excel|:microsoft_excel:|app|app:Microsoft Excel"
  "PowerPoint|:microsoft_power_point:|app|app:Microsoft PowerPoint"
  "Outlook|:microsoft_outlook:|app|app:Microsoft Outlook"
  "Teams|:microsoft_teams:|app|app:Microsoft Teams"
  "OneDrive|:onedrive:|app|app:OneDrive"
  "All Office apps…|$ICON_SUITES|sf|cmd:office"
)
focus=(
  "Zen|$ICON_FOCUS_ZEN|sf|cmd:focus Zen"
  "Study|$ICON_FOCUS_STUDY|sf|cmd:focus Study"
  "Learning|$ICON_FOCUS_LEARNING|sf|cmd:focus Learning"
  "Work|$ICON_WORK|sf|cmd:focus Work"
  "Sleep|$ICON_FOCUS_SLEEP|sf|cmd:focus Sleep"
  "Do Not Disturb|$ICON_FOCUS|sf|cmd:focus Do Not Disturb"
)

suites=(
  icon="$ICON_SUITES"
  icon.font="SF Pro:Regular:14.0"
  icon.padding_left=9
  icon.padding_right=5
  label="Suites"
  label.padding_right=10
  "${pebble[@]}"
  popup.align=right
  script="$PLUGIN_DIR/suites.sh"
)

sketchybar --add item suites right \
  --set suites "${suites[@]}" \
  --subscribe suites mouse.clicked mouse.entered mouse.exited mouse.exited.global

header=(icon.drawing=off label.font="$FONT:Heavy:10.0" label.color="$TEXT_MUTED" label.padding_left=10 width=230)

# Page: menu
sketchybar --add item suites.menu.header popup.suites --set suites.menu.header "${header[@]}" label="SUITES"
popup_row 176
for s in "${SUITES[@]}"; do
  IFS='|' read -r key glyph title <<<"$s"
  sketchybar --add item "suites.menu.$key" popup.suites \
    --set "suites.menu.$key" "${row[@]}" icon="$glyph" label="$title" \
    click_script="$PLUGIN_DIR/suites.sh page $key" \
    --subscribe "suites.menu.$key" mouse.entered mouse.exited
done

# Pages: one per suite (hidden until opened)
for s in "${SUITES[@]}"; do
  IFS='|' read -r key glyph title <<<"$s"
  sketchybar --add item "suites.$key.back" popup.suites \
    --set "suites.$key.back" "${row[@]}" drawing=off icon="$ICON_CHEVRON_LEFT" label="Suites" \
    click_script="$PLUGIN_DIR/suites.sh page menu" \
    --subscribe "suites.$key.back" mouse.entered mouse.exited \
    --add item "suites.$key.header" popup.suites \
    --set "suites.$key.header" "${header[@]}" drawing=off label="$(echo "$title" | tr '[:lower:]' '[:upper:]')"
  eval "apps=(\"\${${key}[@]}\")"
  i=0
  for a in "${apps[@]}"; do
    IFS='|' read -r name aglyph font action <<<"$a"
    [ "$font" = app ] && ifont="$APP_FONT" || ifont="$SF_SYMBOLS"
    sketchybar --add item "suites.$key.$i" popup.suites \
      --set "suites.$key.$i" "${row[@]}" drawing=off icon="$aglyph" icon.font="$ifont" label="$name" \
      click_script="$PLUGIN_DIR/suites.sh run '$action'" \
      --subscribe "suites.$key.$i" mouse.entered mouse.exited
    i=$((i + 1))
  done
done
