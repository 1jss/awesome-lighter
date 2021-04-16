
-- ===================================================================
-- Initialization
-- ===================================================================

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- DPI handling
local dpi = require("beautiful").xresources.apply_dpi
local color_rules = require("themes.color-rules")

local bg_default = color_rules["default"]
local bg_color = ""
local fg_focus_color = ""
local fg_normal_color = ""

-- ===================================================================
-- Titlebar Creation
-- ===================================================================


-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
	
	-- Set forground depending on background lightness
	local function set_fg_color(bg_color)
		local r, g, b = gears.color.parse_color(bg_color)
		if (math.max(r, g, b) > 0.5) then
			fg_focus_color = "#2e3436"
			fg_normal_color = "#aaaaaa"
		else
			fg_focus_color = "#ffffff"
			fg_normal_color = "#aaaaaa"
		end
	end

	-- Set titlebar color from color_rules
	local base_color = color_rules[c.instance]
	if base_color then
		bg_color = base_color
		set_fg_color(base_color)
	else
		bg_color = bg_default
		set_fg_color(bg_default)
	end

	-- Set titlebar colors
	local titlebar = awful.titlebar(c, {
	    size = dpi(32),
		bg_focus = bg_color,
		bg_normal = bg_color,
		fg_focus = fg_focus_color,
		fg_normal = fg_normal_color
	})

	-- Mouse button click on titlebar
	local buttons = gears.table.join(
		awful.button({ }, 1, function()
			gears.debug.dump(c.instance)
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
	    end)
	)

	titlebar: setup {
    	{ -- Left
         	-- AwesomeWM native buttons (images loaded from theme)
         	wibox.container.margin(
         		awful.titlebar.widget.closebutton(c),
         		dpi(12), dpi(6), dpi(6), dpi(6)),
         	wibox.container.margin(
         		awful.titlebar.widget.minimizebutton(c),
         		dpi(4), dpi(6), dpi(6), dpi(6)),
         	wibox.container.margin(
         		awful.titlebar.widget.maximizedbutton(c),
         		dpi(4), dpi(6), dpi(6), dpi(6)),
         	layout = wibox.layout.fixed.horizontal
      	},
      	{ -- Middle
        	{ -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
        	-- Compensate for window buttons to center title
	     	widget = wibox.container.margin(nil, dpi(98), 0, 0, 0),
        	buttons = buttons
        },
      	layout = wibox.layout.align.horizontal
   	}
end)
