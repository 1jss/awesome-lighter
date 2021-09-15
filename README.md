# Lighter

This makes Awesome WM into a Lightweight Stacking WM

![](/screenshots/launcher.png)

## Features:
- Lightweight!
- Configurable window titlebar colors per application
- Resize windows by dragging window border
- Icon dock with launcher on the left
- Runs perfectly without compositor

## Dependencies:
**Won't run without:**
- xorg (duh!)
- awesome 4.3

**Extra:**
- alsa-utils (for volume HUD)

**Is configured for:**
- lxterminal
- play.py
- connman-gtk

But they are optional an can be exchanged in `lua.rc`.

## Installation:
1. Put the `awesome` folder in the hidden `.config` folder in your `home` directory. (Like this: `/home/USERNAME/.config/awesome`)
2. Edit default apps and connections in `rc.lua`
3. Done

### Test your setup:

Run this in your terminal to test your setup in a separate window:

```
Xephyr :5 & sleep 1 ; DISPLAY=:5 awesome
```

## Screenshots:
![](/screenshots/files.png)
![](/screenshots/online_terminal.png)
![](/screenshots/tiling.png)

### Screenshot Details:
- **WM**: Awesome 4.3
- **Compositor**: None
- **GTK Theme**: Adwaita
- **Icon Theme**: [Mkos Big Sur](https://github.com/zayronxio/Mkos-Big-Sur)
- **Font**: Open Sans

## Credit:
- Mainly adapted from [default rc.lua](https://awesomewm.org/doc/api/sample%20files/rc.lua.html)
- Some elements are adapted from [Mirage by WillPower3309](https://github.com/WillPower3309/awesome-dotfiles)
- Inspiration from the very beautiful (but heavy) [Nice by mut-ex](https://github.com/mut-ex/awesome-wm-nice)

## Tags:
- awesomewm
- dotfiles
- lua
