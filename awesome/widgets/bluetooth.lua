
-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local clickable_container = require("widgets.clickable-container")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/bluetooth/"

local checker


-- ===================================================================
-- Initialization
-- ===================================================================


local widget = wibox.widget {
   {
      id = "icon",
      widget = wibox.widget.imagebox,
      resize = true
   },
   layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(6), dpi(6), dpi(6), dpi(6)))
widget_button:buttons(
   gears.table.join(
      awful.button({}, 1, nil,
         function()
            awful.spawn(apps.bluetooth_manager)
         end
      )
   )
)

awful.tooltip(
   {
      objects = {widget_button},
      mode = "outside",
      align = "right",
      timer_function = function()
         if checker ~= nil then
            return "Bluetooth is on"
         else
            return "Bluetooth is off"
         end
      end,
      preferred_positions = {"right", "left", "top", "bottom"}
   }
)

local last_bluetooth_check = os.time()
watch("bluetoothctl --monitor list", 5,
   function(_, stdout)
      -- Check if there  bluetooth
      checker = stdout:match("Controller") -- If 'Controller' string is detected on stdout
      local widget_icon_name = "loading"
      if (checker ~= nil) then
         widget_icon_name = "bluetooth"
      else
         widget_icon_name = "bluetooth-off"
      end
      widget.icon:set_image(icon_dir .. widget_icon_name .. ".svg")
      collectgarbage("collect")
   end,
   widget
)

return widget_button
