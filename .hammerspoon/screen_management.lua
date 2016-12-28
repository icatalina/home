local localMash = mash

if localMash == nil then
    localMash = {"cmd", "alt", "ctrl"}
end

hs.window.animationDuration = 0
hs.window.setShadows(false)
hs.grid.setMargins(hs.geometry.size(0, 0))
hs.grid.setGrid('4x4')

function push(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w * x)
  f.y = max.y + (max.h * y)
  f.w = max.w * w
  f.h = max.h * h
  win:setFrame(f)
end

-- Screen half top
hs.hotkey.bind(localMash, "up", function() push(0,0,1,0.5) end)
-- Screen half bottom
hs.hotkey.bind(localMash, "down", function() push(0,0.5,1,0.5) end)

-- Screen half left
hs.hotkey.bind(localMash, "left", function() push(0,0,0.5,1) end)
-- Screen half right
hs.hotkey.bind(localMash, "right", function() push(0.5,0,0.5,1) end)

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
