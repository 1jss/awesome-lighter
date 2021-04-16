
-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local calendar = {}


-- ===================================================================
-- Create Widget
-- ===================================================================


calendar.create = function(screen)
   -- Clock / Calendar 12h format
   -- Get Time/Date format using `man strftime`
   -- Update every 60 seconds
   local clock_widget = wibox.widget.textclock("<span color='#ffffff' font='" .. beautiful.title_font .."'>%R</span>", 60)

   -- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
   awful.tooltip({
      objects = {clock_widget},
      mode = "outside",
      align = "right",
      timer_function = function()
         return os.date("Today it's %A %n %e %B %Y")
      end,
      preferred_positions = {"right", "left", "top", "bottom"},
      margin_leftright = dpi(12),
      margin_topbottom = dpi(8)
   })

   return clock_widget
end

return calendar
