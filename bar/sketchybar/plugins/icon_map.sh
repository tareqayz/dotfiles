#!/bin/bash

# App name → sketchybar-app-font ligature. Covers the apps installed on this Mac;
# anything else falls back to :default:. Full upstream map:
# https://github.com/kvndrsslr/sketchybar-app-font (icon_map.sh in each release).
icon_map() {
  case "$1" in
  "Ghostty") echo ":ghostty:" ;;
  "kitty") echo ":kitty:" ;;
  "iTerm" | "iTerm2") echo ":iterm:" ;;
  "Terminal") echo ":terminal:" ;;
  "Warp") echo ":warp:" ;;
  "Neovim" | "nvim") echo ":neovim:" ;;
  "Code" | "Visual Studio Code") echo ":code:" ;;
  "Cursor") echo ":cursor:" ;;
  "Zed") echo ":zed:" ;;
  "Xcode") echo ":xcode:" ;;
  "Android Studio") echo ":android_studio:" ;;
  "Arduino IDE" | "Arduino") echo ":arduino:" ;;
  "Docker" | "Docker Desktop") echo ":docker:" ;;
  "Postman") echo ":postman:" ;;
  "GitHub Desktop") echo ":git_hub:" ;;
  "Zen" | "Zen Browser") echo ":zen_browser:" ;;
  "Safari") echo ":safari:" ;;
  "Google Chrome") echo ":google_chrome:" ;;
  "Brave Browser") echo ":brave_browser:" ;;
  "Firefox") echo ":firefox:" ;;
  "Arc") echo ":arc:" ;;
  "Claude") echo ":claude:" ;;
  "ChatGPT") echo ":openai:" ;;
  "Gemini") echo ":gemini:" ;;
  "Perplexity") echo ":perplexity:" ;;
  "Ollama") echo ":ollama:" ;;
  "LM Studio") echo ":lm_studio:" ;;
  "Microsoft 365 Copilot" | "Copilot") echo ":copilot:" ;;
  "Figma") echo ":figma:" ;;
  "Sketch") echo ":sketch:" ;;
  "Blender") echo ":blender:" ;;
  "FreeCAD") echo ":freecad:" ;;
  "Obsidian") echo ":obsidian:" ;;
  "Notion") echo ":notion:" ;;
  "Notes") echo ":notes:" ;;
  "Books") echo ":apple_books:" ;;
  "Journal") echo ":journal:" ;;
  "Anki") echo ":anki:" ;;
  "Music") echo ":music:" ;;
  "Spotify") echo ":spotify:" ;;
  "Podcasts") echo ":podcasts:" ;;
  "Logic Pro") echo ":logicpro:" ;;
  "Final Cut Pro") echo ":final_cut_pro:" ;;
  "OBS" | "OBS Studio") echo ":obsstudio:" ;;
  "QuickTime Player") echo ":quicktime:" ;;
  "IINA") echo ":iina:" ;;
  "VLC") echo ":vlc:" ;;
  "Photos") echo ":photos:" ;;
  "Preview") echo ":preview:" ;;
  "Microsoft Word") echo ":microsoft_word:" ;;
  "Microsoft Excel") echo ":microsoft_excel:" ;;
  "Microsoft PowerPoint") echo ":microsoft_power_point:" ;;
  "Microsoft Outlook") echo ":microsoft_outlook:" ;;
  "Microsoft Teams" | "Microsoft Teams (work or school)") echo ":microsoft_teams:" ;;
  "OneDrive") echo ":onedrive:" ;;
  "Keynote") echo ":keynote:" ;;
  "Numbers") echo ":numbers:" ;;
  "Pages") echo ":pages:" ;;
  "Mail") echo ":mail:" ;;
  "Proton Mail") echo ":proton_mail:" ;;
  "Calendar") echo ":calendar:" ;;
  "Reminders") echo ":reminders:" ;;
  "Messages") echo ":messages:" ;;
  "Discord") echo ":discord:" ;;
  "WhatsApp") echo ":whats_app:" ;;
  "zoom.us") echo ":zoom:" ;;
  "Raycast") echo ":raycast:" ;;
  "Finder") echo ":finder:" ;;
  "Maps") echo ":maps:" ;;
  "App Store") echo ":app_store:" ;;
  "TextEdit") echo ":textedit:" ;;
  "Activity Monitor") echo ":activity_monitor:" ;;
  "System Settings" | "System Preferences") echo ":gear:" ;;
  "TestFlight") echo ":testflight:" ;;
  "Minecraft") echo ":minecraft:" ;;
  "Calculator") echo ":calculator:" ;;
  *) echo ":default:" ;;
  esac
}
