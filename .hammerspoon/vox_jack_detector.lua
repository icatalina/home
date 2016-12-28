_G.voxPrev = 0

function sleepWatch(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidLock) then
        _G.voxPrev = hs.vox.getPlayerState()

        if _G.voxPrev == 1 then
            hs.vox.pause()
        end
    end
    if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        local audio = hs.audiodevice.current()

        if _G.voxPrev == 1 and audio.device:jackConnected() then
            hs.alert.show("Resume Playing!")
            hs.vox.play()
        end
    end
end

function notify(method, config)
    return hs.notify.new(function (notification) 
        if (notification:activationType() == hs.notify.activationTypes.actionButtonClicked) then
            method(notification)
        end
    end, config):send()
end

function runVoxAndPlay()
    hs.vox.play()
end

function audioWatcher(uuid, event, scope, channel)
    local device = hs.audiodevice.findDeviceByUID(uuid)

    if (event == 'jack' and scope == 'outp' and device:jackConnected()) then
        if (pcall(hs.vox.isRunning)) then
            hs.alert.show("Resume Playing!")
            hs.timer.doAfter(2, function () hs.vox.play() end)
        else
            notify(runVoxAndPlay, {
                title='Vox',
                informativeText='Do you want to run VOX and start playing music?',
                actionButtonTitle='Play'
            })
        end
    end
end

local sleepWatcher = hs.caffeinate.watcher.new(sleepWatch)
local audioDeviceWatcher = hs.audiodevice.findDeviceByName('Built-in Output'):watcherCallback(audioWatcher)

audioDeviceWatcher:watcherStart()
sleepWatcher:start()
