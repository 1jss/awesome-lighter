
-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

-- define module table
local top_panel = {}

-- ===================================================================
-- Bar Creation
-- ===================================================================


top_panel.create = function(s)

    local taglist_buttons = gears.table.join(
        -- Left click on tag list
        awful.button({ }, 1, function(t) t:view_only() end),
        -- Right click on tag list
        awful.button({ }, 3, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
                t:view_only()
            end
        end)
   )

   s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
   }

   local panel = awful.wibar({
      screen = s,
      position = "top",
      ontop = false,
      height = beautiful.top_panel_height,
      width = s.geometry.width,
      bg = beautiful.top_panel_bg
   })

   panel:setup {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      wibox.container.margin(s.mytaglist, dpi(8), dpi(0), dpi(0), dpi(0)),
      require("widgets.calendar").create(s),
      {
         layout = wibox.layout.fixed.horizontal,
         wibox.container.margin(wibox.widget.systray(), dpi(4), dpi(4), dpi(4), dpi(4)),
         --require("widgets.bluetooth"),
         require("widgets.network")(),
         wibox.container.margin(require("widgets.battery"), dpi(0), dpi(8), dpi(0), dpi(0))
      }
   }

   -- ===================================================================
   -- Functionality
   -- ===================================================================


   -- hide panel when client is fullscreen
   local function change_panel_visibility(client)
      if client.screen == s then
         panel.ontop = not client.fullscreen
      end
   end

   -- connect panel visibility function to relevant signals
   client.connect_signal("property::fullscreen", change_panel_visibility)
   client.connect_signal("focus", change_panel_visibility)

end

return top_panel
