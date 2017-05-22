mash = {"cmd", "alt", "ctrl"}

-- Reload Hammerspoon Config
hs.hotkey.bind(mash, "`", function()
  hs.notify.show("Reload Config", "Hammerspoon Config Reloaded", "Hammerspoon Config Reloaded")
  hs.reload()
end)

-- Reload Chrome active tab
hs.hotkey.bind({'ctrl', 'cmd'}, "R", function()
  hs.osascript.applescript('tell application "Google Chrome" to tell the active tab of its first window to reload')
end)

-- Sleep system
hs.hotkey.bind(mash, "escape", function()
  hs.caffeinate.systemSleep()
end)

-- Show/Hide menu icon
hs.menuIcon(false)
hs.hotkey.bind(mash, "-", function()
  hs.menuIcon(not hs.menuIcon())
end)

require('cursor_key_remap')
require('screen_management')
require('vox_jack_detector')
require('caffeine')
require('show_hide_dotfiles')
