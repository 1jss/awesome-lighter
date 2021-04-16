-- BACKLIGHT

-- ===================================================================
-- Initialization
-- ===================================================================


local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(56)
local offsety = dpi(256)
local screen = awful.screen.focused()
local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/backlight/"


-- ===================================================================
-- Appearance & Functionality
-- ===================================================================


local backlight_icon = wibox.widget {
   widget = wibox.widget.imagebox
}

-- create the backlight_adjust component
local backlight_adjust = wibox({
   screen = awful.screen.focused(),
   x = screen.geometry.width - offsetx,
   y = (screen.geometry.height / 2) - (offsety / 2),
   width = dpi(48),
   height = offsety,
   bg = beautiful.hud_panel_bg,
   shape = gears.shape.rounded_rect,
   visible = false,
   ontop = true
})

local backlight_bar = wibox.widget{
   widget = wibox.widget.progressbar,
   shape = gears.shape.rounded_bar,
   color = beautiful.hud_slider_fg,
   background_color = beautiful.hud_slider_bg,
   max_value = 100,
   value = 0
}

backlight_adjust:setup {
   layout = wibox.layout.align.vertical,
   {
      wibox.container.margin(
         backlight_bar, dpi(14), dpi(20), dpi(20), dpi(20)
      ),
      forced_height = offsety * 0.75,
      direction = "east",
      layout = wibox.container.rotate
   },
   wibox.container.margin(
      backlight_icon
   )
}

-- create a 4 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_backlight_adjust = gears.timer {
   timeout = 4,
   autostart = true,
   callback = function()
      backlight_adjust.visible = false
   end
}

-- show backlight-adjust when "backlight_change" signal is emitted
awesome.connect_signal("backlight_change",
   function()
      -- set new volume value
      awful.spawn.easy_async_with_shell(
         "xbacklight",
         function(stdout)
            local backlight_level = tonumber(stdout)
            backlight_bar.value = backlight_level
            if (backlight_level < 50) then
               backlight_icon:set_image(icon_dir .. "brightness-low.png")
            else
               backlight_icon:set_image(icon_dir .. "brightness-high.png")
            end
         end,
         false
      )

      -- make backlight_adjust component visible
      if backlight_adjust.visible then
         hide_backlight_adjust:again()
      else
         backlight_adjust.visible = true
         hide_backlight_adjust:start()
      end
   end
)
