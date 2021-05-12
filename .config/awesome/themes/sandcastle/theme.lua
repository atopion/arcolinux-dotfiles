--[[

     Sandcastle Awesome WM theme

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Awesome widgets
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/sandcastle"
theme.wallpaper                                 = theme.dir .. "/wallpaper.jpg"
theme.font                                      = "Fira Code Medium 11.0"
theme.taglist_font                              = "Fira Code Bold 11.0"

theme.fg_normal                                 = "#DDB6A3"
theme.fg_focus                                  = "#FCE1D4"
theme.bg_normal                                 = "#0E0B1A"
theme.bg_focus                                  = "#4C3E41"

theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#2A1F1E"

theme.border_width                              = dpi(2)
theme.border_normal                             = "#876D63"
theme.border_focus                              = "#FCE1D4"

theme.taglist_fg_focus                          = "#FCE1D4"
theme.taglist_bg_focus                          = "#4C3E41"
theme.tasklist_fg_focus                         = "#FCE1D4"
theme.tasklist_bg_focus                         = "#4C3E41"

theme.calendar_bg                               = "#191919"
theme.calendar_fg                               = "#FFFFFF"

theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(130)


theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note.png"
theme.widget_music_pause                        = theme.dir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.dir .. "/icons/stop.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.widget_task                               = theme.dir .. "/icons/task.png"
theme.widget_scissors                           = theme.dir .. "/icons/scissors.png"
theme.widget_weather                            = theme.dir .. "/icons/dish.png"
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 12
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

awful.util.tagnames = { " ⠐ ", " ⠡ ", " ⠲ ", " ⠵ ", " ⠻ ", " ⠿ " }

local markup     = lain.util.markup
local separators = lain.util.separators
local gray       = "#dddddd"

-- Textclock
local mytextclock = wibox.widget.textclock(" %H:%M ")
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Fira Code Medium 11",
        fg   = theme.calendar_fg,
        bg   = theme.calendar_bg
    }
})

-- Weather
--theme.weather = lain.widget.weather({
--    city_id = 2871039, -- Minden, Germany
--    settings = function()
--        units = math.floor(weather_now["main"]["temp"])
--        widget:set_markup(" " .. units .. "° ")
--    end
--})

--theme.weather = weather_widget({
--    api_key = "8cdbe9449d0690a4b9915f021e4f093c",
--    coordinates = {52.292726, 8.9598552} -- Minden, Germany
--})

--theme.cpu = cpu_widget({
--    width = 40,
--    step_width = 2,
--    step_spacing = 1,
--    process_info_max_length = 35,
--    enable_kill_button = true
--})


-- Separator
local separator       = wibox.widget.textbox(" ")

local barheight = dpi(22)
theme.titlebar_bg = gears.color.parse_color(theme.bg_normal)
theme.titlebar_bg_focus = gears.color.parse_color(theme.bg_focus)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    local layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.tile,
        awful.layout.suit.tile,
        awful.layout.suit.tile,
        awful.layout.suit.tile,
        awful.layout.suit.tile
    }

    -- Tags
    awful.tag(awful.util.tagnames, s, layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, 
            { 
                bg_normal = theme.bg_normal,
                bg_focus = theme.tasklist_bg_focus,
                fg_normal = theme.fg_normal,
                fg_focus = theme.tasklist_fg_focus
            }
    )

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = barheight, bg = theme.bg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            separator,
            s.mytaglist,
            separator,
            s.mylayoutbox,
            separator,
            s.mypromptbox,
            separator,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            separator,
            weather_widget({
                api_key = '8cdbe9449d0690a4b9915f021e4f093c',
                coordinates = {52.292726, 8.9598552},
                show_hourly_forecast = true,
                show_daily_forecast = true
            }),
            seperator,
            cpu_widget({
                width = 40,
                step_width = 2,
                step_spacing = 1,
                enable_kill_button = true,
                process_info_max_length = 128
            }),
            seperator,
            volume_widget{
                widget_type = 'arc'
            },
            separator,
            wibox.widget.systray(), 
            seperator,
            mytextclock,
            logout_menu_widget(),
        },
    }
end

return theme
