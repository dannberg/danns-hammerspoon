# Dann's Awesome Hammerspoon

This Hammerspoon script includes custom keybindings to quickly open applications, resize windows, and open URLs.

It needs to be cleaned up a bit, and more needs to be added. But it's 1) functional and 2) a start!

## Keybindings

The script uses the Hyper key (Cmd + Ctrl + Alt + Shift) in combination with other keys to trigger various actions.

### Application Keybindings

Press Hyper + the corresponding key to open or switch to the specified application:

- Hyper + F: Finder
- Hyper + B: Brave Browser
- Hyper + S: Sublime Text
- Hyper + Z: Obsidian
- Hyper + T: iTerm

### URL Keybindings

Press Hyper + the corresponding key to open the specified URL:

- Hyper + N: https://QuickConnect.to/dannberg
- Hyper + D: https://dannb.org

### Script Keybindings

Press Hyper + the corresponding key to run a script:

- Hpyer + X: Takes the selected file in Finder and renames any single-digit numbers to be two-digit numbers

### Window Resizing Keybindings

Press Hyper + the corresponding arrow key to resize the current window:

- Hyper + [Left Arrow]: Resize the current window to fill the left 1/2 or 2/3 of the screen. If it's already 2/3 of the screen, it will fill the left 1/2 of the screen.
- Hyper + [Right Arrow]: Resize the current window to fill the right 1/3 of the screen. Press Hyper + [Right Arrow] again within 5 seconds to return the window to its original size and position.

## Installation

1. Install [Hammerspoon](https://www.hammerspoon.org/).
2. Copy the provided script into your `~/.hammerspoon/init.lua` file.
3. Click the Hammerspoon menu bar icon and select "Reload Config" to apply the changes.

Now you can use the keybindings defined in the script for quick access to applications, resizing windows, and opening URLs.
