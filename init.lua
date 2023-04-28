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
  {'z', 'Obsidian'},
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

-- Function to make the current window full screen
function makeWindowFullScreen()
    local win = hs.window.focusedWindow()

    if not win then
        print("No focused window")
        return
    end

    win:maximize(0) -- Animate instantly by setting the duration to 0
end

-- Accepts a zip or cbz, and runs a script that renames the first 10 filenames to two-digit numbers
function processSelectedCompressedFile()
    local finder = hs.appfinder.appFromName("Finder")
    local finderActive = hs.application.frontmostApplication() == finder

    if not finderActive then
        hs.alert.show("Please select a file in Finder.")
        return
    end

    -- Get selected items from Finder using AppleScript
    local script = [[
        tell application "Finder"
            set selectedItems to selection
            set itemList to {}
            repeat with i in selectedItems
                set end of itemList to (POSIX path of (i as alias))
            end repeat
            return itemList
        end tell
    ]]
    local _, selectedItems, _ = hs.osascript.applescript(script)

    if #selectedItems == 0 then
        hs.alert.show("Please select a compressed folder.")
        return
    end

    local selectedFile = selectedItems[1]
    local fileExtension = string.match(selectedFile, "%.([^%.]+)$")

    if fileExtension ~= "zip" and fileExtension ~= "cbz" then
        hs.alert.show("Please select a compressed folder.")
        return
    end

    hs.execute(string.format("/Users/dannberg/Code/scripts/cbz_process.sh '%s'", selectedFile))
end

-- Bind hyperkey-x to rename files inside the selected compressed file in finder
hs.hotkey.bind(hyper, "X", processSelectedCompressedFile)

-- Bind hyperkey-[up arrow] to make the current window full screen
hs.hotkey.bind(hyper, "up", makeWindowFullScreen)


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
