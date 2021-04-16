---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local themes_path = string.format("%s/.config/awesome/themes/", os.getenv("HOME"))

local theme = {}
local transparent = "#00000000"
local standardfont = "Open Sans 10"
-- ===================================================================
-- Theme Variables
-- ===================================================================

-- Font
theme.font = standardfont
theme.title_font = standardfont

-- Background
theme.bg_normal     = "#242424"
theme.bg_focus      = "#444444"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

-- Foreground
theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- Gaps
theme.useless_gap   = dpi(0)
theme.gap_single_client = false

-- Window Borders
theme.border_width  = dpi(0)
theme.border_normal = "#cccccc"
theme.border_focus  = theme.border_normal
theme.border_marked = theme.border_normal

-- Snap border
theme.snap_bg           = "#22aadd"
theme.snap_border_width = dpi(4)
theme.snapper_gap       = dpi(6)

-- Taglist
theme.taglist_fg_focus = "#ffffff"
theme.taglist_fg_urgent = "#ffb400"
theme.taglist_fg_occupied = "#aaaaaa"
theme.taglist_fg_empty = "#555555"
theme.taglist_fg_volatile = "#ffffff"

theme.taglist_bg_focus = transparent
theme.taglist_bg_urgent = transparent
theme.taglist_bg_occupied = transparent
theme.taglist_bg_empty = transparent
theme.taglist_bg_volatile = transparent

theme.taglist_spacing = dpi(4)
theme.taglist_disable_icon = true

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal    = "#222222"
theme.tasklist_bg_focus     = theme.bg_focus
theme.tasklist_bg_urgent    = theme.bg_urgent

theme.tasklist_fg_focus     = theme.fg_focus
theme.tasklist_fg_urgent    = theme.fg_urgent
theme.tasklist_fg_normal    = theme.fg_normal

-- Panel Sizing
theme.top_panel_height  = dpi(32)
theme.top_panel_bg      = "#222222"

-- Notification Sizing
theme.notification_max_width    = dpi(350)
theme.notification_margin       = dpi(16)
theme.notification_font         = standardfont
theme.notification_fg           = "#ffffff"
theme.notification_bg           = "#222222"
theme.notification_border_width = dpi(1)
theme.notification_border_color = "#555555"
theme.notification_shape        = gears.shape.rounded_rect


-- HUD colors
theme.hud_slider_fg = "#000000"
theme.hud_slider_bg = "#555555"
theme.hud_panel_bg  = "#ffffff"


-- System Tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(4)

theme.menu_height = dpi(32)
theme.menu_width  = dpi(200)

-- fallback not used in titlebar
theme.titlebar_bg_focus = "#e8e8e7"
theme.titlebar_bg_normal = "#e8e8e7"
theme.titlebar_fg_focus = "#2e3436"
theme.titlebar_fg_normal = "#aaaaaa"

local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/titlebar/"

-- Close Button
theme.titlebar_close_button_normal = icon_dir .. 'normal.svg'
theme.titlebar_close_button_focus  = icon_dir .. 'close_focus.svg'
theme.titlebar_close_button_normal_hover = icon_dir .. 'close_focus_hover.svg'
theme.titlebar_close_button_focus_hover  = icon_dir .. 'close_focus_hover.svg'

-- Minimize Button
theme.titlebar_minimize_button_normal = icon_dir .. 'normal.svg'
theme.titlebar_minimize_button_focus  = icon_dir .. 'minimize_focus.svg'
theme.titlebar_minimize_button_normal_hover = icon_dir .. 'minimize_focus_hover.svg'
theme.titlebar_minimize_button_focus_hover  = icon_dir .. 'minimize_focus_hover.svg'

-- Maximized Button (While Window is Maximized)
theme.titlebar_maximized_button_normal_active = icon_dir .. 'normal.svg'
theme.titlebar_maximized_button_focus_active  = icon_dir .. 'maximized_focus.svg'
theme.titlebar_maximized_button_normal_active_hover = icon_dir .. 'maximized_focus_hover.svg'
theme.titlebar_maximized_button_focus_active_hover  = icon_dir .. 'maximized_focus_hover.svg'

-- Maximized Button (While Window is not Maximized)
theme.titlebar_maximized_button_normal_inactive = icon_dir .. 'normal.svg'
theme.titlebar_maximized_button_focus_inactive  = icon_dir .. 'maximized_focus.svg'
theme.titlebar_maximized_button_normal_inactive_hover = icon_dir .. 'maximized_focus_hover.svg'
theme.titlebar_maximized_button_focus_inactive_hover  = icon_dir .. 'maximized_focus_hover.svg'


-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.wallpaper = themes_path .. "background.jpg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Mkos-Big-Sur"

return theme
