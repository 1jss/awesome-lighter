-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
-- gears: Utilities such as color parsing and objects
local gears = require("gears")
-- awful: Everything related to window managment
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
-- wibox: Awesome own generic widget framework
local wibox = require("wibox")

-- Theme handling library
-- beautiful: Awesome theme module
local beautiful = require("beautiful")

-- Notification library
-- naughty: Notifications
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

-- ERROR HANDLING
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
  text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
    text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- VARIABLE DEFINITIONS
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local config_dir = gears.filesystem.get_configuration_dir() .. "/config/"
local theme_path = gears.filesystem.get_configuration_dir() .. "/themes/theme.lua"
beautiful.init(theme_path)


-- Code block and/or called functions to profile --

naughty.config.defaults.margin = beautiful.notification_margin

-- Get screen geometry
-- I am using a single screen setup and I assume that screen geometry will not
-- change during the session.
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

awful.mouse.snap.default_distance = 0
awful.mouse.snap.client_enabled = false
--awful.mouse.snap.edge_enabled = true
awful.mouse.drag_to_tag.enabled = false

-- define default apps (global variable so other components can access it)
apps = {
  network_manager = "connman-gtk --no-icon",
  power_manager = "", -- recommended: xfce4-power-manager
  bluetooth_manager = "connman-gtk --no-icon",
  terminal = "lxterminal",
  launcher = "play.py",
  lock = "light-locker-command -l",
  screenshot = "scrot -e 'mv $f ~/ 2>/dev/null'"
}

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
network_interfaces = {
  wlan = 'wls3',
  lan = 'enp0s25'
}

-- List of apps to run on start-up - autostart
local run_on_start_up = {
  "lxpolkit"
--  "syncthing -no-browser -logfile=default"
--  "touchegg"
}

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
  local findme = app
  local firstspace = app:find(" ")
  if firstspace then
    findme = app:sub(0, firstspace - 1)
  end
  -- pipe commands to bash to allow command to be shell agnostic
  awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
local altkey = "Mod1"

-- {{{ Wibar

-- Import components
require("components.exit-screen")
require("components.volume-adjust")
require("components.backlight-adjust")

-- Import panels
local top_panel = require("components.top-panel")
local dock_panel = require("components.dock-panel")

local function set_wallpaper(s)
-- Wallpaper
if beautiful.wallpaper then
  local wallpaper = beautiful.wallpaper
  -- If wallpaper is a function, call it with the screen
  if type(wallpaper) == "function" then
    wallpaper = wallpaper(s)
  end
  gears.wallpaper.maximized(wallpaper, s, true)
end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
-- Wallpaper
set_wallpaper(s)

-- Add the top panel to every screen
top_panel.create(s)
dock_panel.create(s)

-- Each screen has its own tag table.
local tagnames = { "●", "●", "●", "●", "●", "●", "●", "●", "●" }
--local tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
awful.tag(tagnames, s, {awful.layout.suit.floating})
end)
-- }}}

require("components.titlebar")

-- Events on desktop

-- {{{ Key bindings
globalkeys = gears.table.join(
-- hotkeys popup on mod + k
awful.key({ modkey, }, "k", hotkeys_popup.show_help,
{description = "show help", group = "session"}),

-- switch to previous tag
awful.key({ altkey, "Control" }, "Left", awful.tag.viewprev,
{description = "view previous desk", group = "desk"}),
-- switch to next tag
awful.key({ altkey, "Control" }, "Right", awful.tag.viewnext,
{description = "view next desk", group = "desk"}),

-- move window to previous tag
awful.key({ altkey, "Shift" }, "Left",
  function ()
    -- get current tag
    local t = client.focus and client.focus.first_tag or nil
    if t == nil then
      return
    end
    -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
    local tag = client.focus.screen.tags[(t.index - 2) % 9 + 1]
    if tag then
      client.focus:move_to_tag(tag)
      awful.tag.viewprev()
    end
  end,
{description = "move window to previous desk and switch to it", group = "desk"}),
-- move window to next tag
awful.key({ altkey, "Shift" }, "Right",
  function ()
    -- get current tag
    local t = client.focus and client.focus.first_tag or nil
    if t == nil then
      return
    end
    -- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
    local tag = client.focus.screen.tags[(t.index % 9) + 1]
    if tag then
      client.focus:move_to_tag(tag)
      awful.tag.viewnext()
    end
  end,
{description = "move window to next desk and switch to it", group = "desk"}),

-- switch to next window
awful.key({ altkey, }, "Tab",
  function ()
    awful.client.focus.byidx( 1)
  end,
  {description = "go to next window on desk", group = "window"}
),
-- switch to last window
awful.key({ altkey, "Shift" }, "Tab",
  function ()
    awful.client.focus.byidx(-1)
  end,
  {description = "go to previous window on desk", group = "window"}
),


-- switch to next tag
awful.key({ modkey, }, "Tab", awful.tag.viewnext,
{description = "go to next desk", group = "desk"}),
-- switch to last tag
awful.key({ modkey, "Shift" }, "Tab", awful.tag.viewprev,
{description = "go to previous desk", group = "desk"}),


-- FUNCTION KEYS

-- Brightness
awful.key({}, "XF86MonBrightnessUp",
  function()
    awful.spawn("xbacklight -inc 10", false)
    awesome.emit_signal("backlight_change")
  end
--  {description = "brightness up", group = "hotkeys"}
),
awful.key({}, "XF86MonBrightnessDown",
  function()
    awful.spawn("xbacklight -dec 10", false)
    awesome.emit_signal("backlight_change")
  end
  --{description = "brightness down", group = "hotkeys"}
),

-- ALSA volume control
awful.key({}, "XF86AudioRaiseVolume",
  function()
    awful.spawn("amixer -D pulse sset Master 5%+", false)
    awesome.emit_signal("volume_change")
  end
  --{description = "volume up", group = "hotkeys"}
),
awful.key({}, "XF86AudioLowerVolume",
  function()
    awful.spawn("amixer -D pulse sset Master 5%-", false)
    awesome.emit_signal("volume_change")
  end
  --{description = "volume down", group = "hotkeys"}
),
awful.key({}, "XF86AudioMute",
  function()
    awful.spawn("amixer -D pulse set Master 1+ toggle", false)
    awesome.emit_signal("volume_change")
  end
  --{description = "toggle mute", group = "hotkeys"}
),
awful.key({}, "XF86AudioNext",
  function()
    awful.spawn("mpc next", false)
  end
  --{description = "next music", group = "hotkeys"}
),
awful.key({}, "XF86AudioPrev",
  function()
    awful.spawn("mpc prev", false)
  end
  --{description = "previous music", group = "hotkeys"}
),
awful.key({}, "XF86AudioPlay",
  function()
    awful.spawn("mpc toggle", false)
  end
  --{description = "play/pause music", group = "hotkeys"}
),
-- Screenshot on prtscn using scrot
awful.key({modkey, "Shift"}, "3",
  function()
    awful.util.spawn(apps.screenshot, false)
  end,
  {description = "take screenshot", group = "launcher"}
),

-- Quit Awesome
awful.key({modkey, }, "Escape",
  function()
    -- emit signal to show the exit screen
    awesome.emit_signal("show_exit_screen")
  end,
  {description = "show exit screen", group = "session"}
),

awful.key({}, "XF86PowerOff",
  function()
    -- emit signal to show the exit screen
    awesome.emit_signal("show_exit_screen")
  end
  --{description = "show exit screen", group = "hotkeys"}
),


-- SPAWN APPLICATION KEY BINDINGS

-- Spawn terminal
awful.key({modkey}, "t",
  function()
    awful.spawn(apps.terminal)
  end,
  {description = "open a terminal", group = "launcher"}
),
-- Spawn launcher
awful.key({modkey}, "space",
  function()
    awful.spawn(apps.launcher)
  end,
  {description = "application launcher", group = "launcher"}
),

-- Standard programs
-- Restart awesome
awful.key({ modkey, "Control" }, "r", awesome.restart,
{description = "reload awesome", group = "session"}),
-- Quit awesome
awful.key({ modkey, "Shift" }, "q", awesome.quit,
{description = "quit awesome", group = "session"})
)

clientkeys = gears.table.join(
awful.key({ modkey, }, "f",
  function (c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end,
{description = "toggle fullscreen", group = "window"}),
awful.key({ modkey, "Shift" }, "c",
  function (c) c:kill()
  end,
{description = "close window", group = "window"}),
awful.key({ modkey, }, "Down",
  function (c)
      c.maximized = false
      c.width = screen_width * 0.40
      c.height = screen_height * 0.80
      local f = awful.placement.centered
      f(c, {honor_workarea = false, size_hints_honor = true})
      c:raise()
  end,
{description = "center mindow", group = "window"}),
awful.key({ modkey, }, "Up",
  function (c)
      --c.maximized = not c.maximized

      -- Alternative: Not using "proper" maximized state because it resizes wheen dock is shown
      c.maximized = false
      local f = awful.placement.left
             + awful.placement['maximize_vertically']
             + awful.placement['maximize_horizontally']
            f(c, {honor_workarea = true, size_hints_honor = false})
      c:raise()
  end,
{description = "maximize window", group = "window"}),
awful.key({ modkey, }, "Left",
  function (c)
      c.maximized = false
      local f = awful.placement.scale
       + awful.placement.left
       + awful.placement['maximize_vertically']
      f(c, {honor_workarea = true, to_percent = 0.5, size_hints_honor = false})
      c:raise()
  end,
{description = "snap window to the left", group = "window"}),
awful.key({ modkey, }, "Right",
  function (c)
      c.maximized = false
      local f = awful.placement.scale
       + awful.placement.right
       + awful.placement['maximize_vertically']
      f(c, {honor_workarea = true, to_percent = 0.5, size_hints_honor = false})
      c:raise()
  end,
{description = "snap window to the right", group = "window"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.

for i = 1, 9 do
globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ altkey, "Control" }, "#" .. i + 9,
    function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end,
  {description = "view desk "..i, group = "desk"}),
  -- Move client to tag.
  awful.key({ altkey, "Shift" }, "#" .. i + 9,
    function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
          tag:view_only()
        end
      end
    end,
  {description = "move window to desk "..i, group = "desk"})
)
end

-- check if mouse clicks on window border
local function check_border(mx, my, cx, cy, cw, ch)
  local onborder = nil
  if my > (cy + ch - 6) then
    if mx < (cx + 30) then onborder = "bottom_left"
    elseif mx > (cx + cw - 30) then onborder = "bottom_right"
    else onborder = "bottom"
    end
  elseif mx < (cx + 4) then onborder = "left"
  elseif mx > (cx + cw - 4) then onborder = "right"
  end
  return onborder
end

-- Mouse events on windows
clientbuttons = gears.table.join(
awful.button({ }, 1, function (c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  local cx, cy, cw, ch = c:geometry().x, c:geometry().y, c:geometry().width, c:geometry().height
  local mx, my = _G.mouse.coords().x, _G.mouse.coords().y
  local onborder = check_border(mx, my, cx, cy, cw, ch)
  if onborder then
    awful.mouse.client.resize(c, onborder)
  end
end),
awful.button({ modkey }, 1, function (c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  awful.mouse.client.move(c)
end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

local floating_client_placement = function(c)
    local f = awful.placement.centered + awful.placement.no_offscreen
    return f(c, {honor_padding = true, honor_workarea = true, size_hints_honor = true})
end


-- RULES --

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
-- All clients will match this rule.
{ rule = { },
  properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    size_hints_honor = true,
    honor_workarea = true,
    honor_padding = true,
    keys = clientkeys,
    buttons = clientbuttons,
    screen = awful.screen.preferred,
    placement = floating_client_placement,
    floating = true
  }
},
-- Add titlebars to normal clients and dialogs
{ rule_any = { type = { "normal", "dialog" }
  }, properties = { titlebars_enabled = true }
},
-- "Needy": Clients that steal focus when they are urgent
{ rule_any = { type = { "normal", "dialog" }
  }, callback = function (c)
    c:connect_signal("property::urgent", function ()
      if c.urgent then
      c:jump_to()
    end
  end)
end
},
-- Set default width and height
--[[{ rule_any = { type = { "normal"} },
  properties = { width = screen_width * 0.40, height = screen_height * 0.80 }
},]]--
-- File chooser dialog
{ rule_any = { role = { "GtkFileChooserDialog" } },
  properties = { width = screen_width * 0.50, height = screen_height * 0.50 }
},
}
-- }}}


-- SIGNALS --

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
-- Set the windows at the slave,
-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then awful.client.setmaster(c) end
	c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,3)
    end
	if awesome.startup
	and not c.size_hints.user_position
	and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.centered(c, {honor_padding = true, honor_workarea = true, size_hints_honor = false})
	end
end)




collectgarbage("collect")
-- }}}
