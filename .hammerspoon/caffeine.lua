-- caffeine
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    local result = "inactive@2x.png"

    if state == "system" then
      result = "activesystem@2x.png"
    elseif state == "display" then
      result = "active@2x.png"
    end

    caffeine:setIcon(result)
end

function caffeineClicked(t)
    local c = hs.caffeinate
    if c.get("systemIdle") or c.get("displayIdle") then
        c.set("systemIdle", nil, true)
        c.set("displayIdle", nil, true)
        setCaffeineDisplay(nil)
        return
    end
    if t["shift"] then
        if not c.get("systemIdle") then
            c.set("systemIdle", true, true)
            setCaffeineDisplay("system")
        end
    else
        if not c.get("displayIdle") then
            c.set("displayIdle", true, true)
            setCaffeineDisplay("display")
        end
    end
end

if caffeine then
    setCaffeineDisplay(nil)
    caffeine:setClickCallback(caffeineClicked)
end
