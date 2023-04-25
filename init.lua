-- Hammerspoon init.lua

-- Define the hyperkey
local hyper = {"cmd", "ctrl", "alt", "shift"}
k = hyper

-- Function to open the specified URL
function openURL(url)
    hs.execute("open " .. url)
end

-- Function to bind a key to a URL
function bindKeyToURL(key, url)
    hs.hotkey.bind(hyper, key, function() openURL(url) end)
end

-- Function to open the specified application
function openApplication(appName)
    hs.application.launchOrFocus(appName)
end

-- Function to bind a key to an application
function bindKeyToApp(key, appName)
    hs.hotkey.bind(hyper, key, function() openApplication(appName) end)
end

singleapps = {
  {'f', 'Finder'},
  {'b', 'Brave Browser'},
  {'s', 'Sublime Text'},
  {'o', 'Obsidian'},
  {'t', 'iTerm'}
}

-- Bind the keys to their corresponding applications
for _, app in ipairs(singleapps) do
    bindKeyToApp(app[1], app[2])
end

-- Function to resize the current window left
function resizeCurrentWindow()
    local win = hs.window.focusedWindow()

    if not win then
        print("No focused window")
        return
    end

    local frame = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    if math.abs(frame.w - (max.w * 2/3)) < 5 then
        frame.w = max.w * 1/2
    else
        frame.w = max.w * 2/3
    end

    frame.x = max.x
    frame.y = max.y
    frame.h = max.h

    win:setFrame(frame)
end

-- Function to resize the current window right
local rightThirdTimer = nil
local originalWindowFrame = nil

function resizeRightThirdAndRestore()
    local win = hs.window.focusedWindow()

    if not win then
        print("No focused window")
        return
    end

    if rightThirdTimer and rightThirdTimer:running() then
        -- Restore the original window size and position
        win:setFrame(originalWindowFrame)
        rightThirdTimer:stop()
        rightThirdTimer = nil
        originalWindowFrame = nil
    else
        -- Save the original window size and position
        originalWindowFrame = win:frame()

        -- Resize the window to the right 9/20 of the screen
        local screen = win:screen()
        local max = screen:frame()
        local frame = win:frame()

        frame.x = max.x + max.w * 11/20
        frame.y = max.y
        frame.w = max.w * 9/20
        frame.h = max.h

        win:setFrame(frame)

        -- Create and start the 5-second timer
        rightThirdTimer = hs.timer.doAfter(5, function()
            originalWindowFrame = nil
            rightThirdTimer = nil
        end)
    end
end

-- Bind hyperkey-[right arrow] to resize the current window to the right 1/3 and restore it
hs.hotkey.bind(hyper, "right", resizeRightThirdAndRestore)

-- Bind hyperkey-[left arrow] to resize the current window
hs.hotkey.bind(hyper, "left", resizeCurrentWindow)

-- Define the keys and URLs you want to bind
local keyBindings = {
    {key = "n", url = "https://QuickConnect.to/dannberg"},
    {key = "d", url = "https://dannb.org"}
}

-- Bind the keys to their corresponding URLs
for _, binding in ipairs(keyBindings) do
    bindKeyToURL(binding.key, binding.url)
end
