
-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

-- define module table
local dock_panel = {}

-- ===================================================================
-- Bar Creation
-- ===================================================================

dock_panel.create = function(s)

    local tasklist_buttons = gears.table.join(
        -- Left click on task list
    	awful.button({ }, 1, function (c)
       		if c == client.focus then
       		 	c.minimized = true
       	 	else
            	c:emit_signal(
              		"request::activate",
                	"tasklist",
                	{raise = true}
            	)
        	end
        end)
   )
   
	s.mytasklist = awful.widget.tasklist {
	    screen   = s,
	    filter   = awful.widget.tasklist.filter.currenttags,
	    buttons  = tasklist_buttons,
	    layout   = {
	        q = {
	            valign = 'center',
	            halign = 'center',
	            widget = wibox.container.place,
	        },
	        spacing = 0,
	        layout  = wibox.layout.fixed.horizontal
	    },
	    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
	    -- not a widget instance.
	    widget_template = {
	    	{
	    		id     = 'clienticon',
				widget = awful.widget.clienticon,
			},
	        margins = 5,
	        widget  = wibox.container.margin,
	        create_callback = function(self, c, index, objects) --luacheck: no unused args
				self:get_children_by_id('clienticon')[1].client = c
				local tt = awful.tooltip {
				    text = c.name,
				    objects = {self},
				    mode = 'outside',
				    align = 'top',
				    preferred_positions = {'top', 'left', 'right', 'bottom'},
				    margin_leftright = dpi(12),
				    margin_topbottom = dpi(8)
				}
	        end,
	    },
	}
	
    local dock = awful.wibar({
    	screen = s,
    	position = "bottom",
    	--ontop = true,
    	height = dpi(64),
    	width = s.geometry.width,
		stretch = true,
		type = "dock",
    	bg = beautiful.tasklist_bg_normal,
    	visible = false
    })
  	
    dock:setup {
    	expand = "none",
    	layout = wibox.layout.align.horizontal,
    	nil,
     	s.mytasklist,
    	nil
    }

	-- Invisible trigger that enables the dock
    local dock_trigger = awful.wibar({
    	screen = s,
	    position = "bottom",
	    height = dpi(1),
    	ontop = true,
	    width = s.geometry.width,
    	bg = "#00000000",
    	visible = true
	})

	-- Show dock and hide trigger
	dock_trigger:connect_signal("mouse::enter", function()
		dock.visible = true
		dock_trigger.visible = false			
	end)
	-- Hide dock and show trigger
	dock:connect_signal("mouse::leave", function()
		dock.visible = false
		dock_trigger.visible = true
	end)

   -- hide dock when client is fullscreen
   local function change_dock_visibility(client)
      if client.screen == s then
         dock.ontop = not client.fullscreen
      end
   end

   -- connect dock visibility function to relevant signals
   client.connect_signal("property::fullscreen", change_dock_visibility)
   client.connect_signal("focus", change_dock_visibility)

end

return dock_panel
