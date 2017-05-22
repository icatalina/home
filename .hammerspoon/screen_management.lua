local localMash = mash

if localMash == nil then
    localMash = {"cmd", "alt", "ctrl"}
end

hs.window.animationDuration = 0
hs.window.setShadows(false)
hs.grid.setMargins(hs.geometry.size(0, 0))
hs.grid.setGrid('4x4')

function move(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = max.x + (max.w * x)
  f.y = max.y + (max.h * y)
  f.w = max.w * w
  f.h = max.h * h
  win:setFrame(f)
end

local size = 0.5

hs.hotkey.bind(localMash, "1", function() size = 0.1 end)
hs.hotkey.bind(localMash, "2", function() size = 0.2 end)
hs.hotkey.bind(localMash, "3", function() size = 0.3 end)
hs.hotkey.bind(localMash, "4", function() size = 0.4 end)
hs.hotkey.bind(localMash, "5", function() size = 0.5 end)
hs.hotkey.bind(localMash, "6", function() size = 0.6 end)
hs.hotkey.bind(localMash, "7", function() size = 0.7 end)
hs.hotkey.bind(localMash, "8", function() size = 0.8 end)
hs.hotkey.bind(localMash, "9", function() size = 0.9 end)
hs.hotkey.bind(localMash, "0", function() size = 1.0 end)

hs.hotkey.bind(localMash, "up",    function() move(       0,        0,    1, size) size = 0.5 end)
hs.hotkey.bind(localMash, "down",  function() move(       0, 1 - size,    1, size) size = 0.5 end)
hs.hotkey.bind(localMash, "left",  function() move(       0,        0, size,    1) size = 0.5 end)
hs.hotkey.bind(localMash, "right", function() move(1 - size,        0, size,    1) size = 0.5 end)

-- Screen fullscreen
hs.hotkey.bind(localMash, "m", function()
    hs.window.focusedWindow():maximize()
end)

-- Screen next screen
hs.hotkey.bind(localMash, "n", function()
  local win = hs.window.focusedWindow()
  win:moveToScreen(win:screen():next(), false, true)
end)

-- Screens, adjust to grid
hs.hotkey.bind(localMash, "=", function()
  for _, win in ipairs(hs.window.allWindows()) do
    hs.grid.snap(win)
  end
end)
