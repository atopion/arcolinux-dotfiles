--[[
    My Awesome Configuration

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

--https://awesomewm.org/doc/api/documentation/05-awesomerc.md.html
-- Standard awesome library
local gears         = require("gears") --Utilities such as color parsing and objects
local awful         = require("awful") --Everything related to window managment
                      require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")

-- Theme handling library
local beautiful     = require("beautiful")

-- Notification library
local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100

local menubar       = require("menubar")

local lain          = require("lain")
local freedesktop   = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors,
                     timeout = 15 })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err),
                         timeout = 15 })
        in_error = false
    end)
end
-- }}}

-- Setup the theme
local theme = "valley"
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme)
beautiful.init(theme_path)


-- Setup variables

-- modkey is ALT
local modkey       = "Mod1"
local super        = "Mod4"
local ctrl         = "Control"

-- personal variables
local browser1          = "firefox"
local browser2          = "chromium -no-default-browser-check"
local browser_private   = "firefox -private-window" 
local editor            = os.getenv("EDITOR") or "vim"
local editorgui         = "code"
local filemanager       = "pcmanfm"
local mailclient        = "thunderbird"
local terminal          = "kitty"


-- awesome layout variables
awful.util.terminal = terminal
-- Fallback tagnames, will be overwritten by the theme
awful.util.tagnames = { "⠐", "⠡", "⠲", "⠵", "⠻", "⠿" }
--awful.util.tagnames = { "⌘", "♐", "⌥", "ℵ" }
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.max,
    awful.layout.suit.magnifier
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme))

-- temp variable for layout switching
local layout_tmp = nil

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "arandr", "arandr" },
}

awful.util.mymainmenu = freedesktop.menu.build({
    before = {
        { "Awesome", myawesomemenu },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Shutdown", "systemctl poweroff" },
        -- other triads can be put here
    }
})
-- hide menu when mouse leaves it
-- awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function() awful.util.mymainmenu:hide() end)  -- DOES NOT WORK -> menu closes when selecting submenu
menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}



-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 2
        else
            c.border_width = beautiful.border_width
        end
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s)
    s.systray = wibox.widget.systray()
    s.systray.visible = true
 end)
-- }}}



-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}




-- Setup Keybindings

-- Global (not client) keybindings

globalkeys = my_table.join (

    -- Switch clients
    
    -- By direction client focus with arrows
    awful.key({ modkey }, "Down",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}
    ),

    awful.key({ modkey }, "Up",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}
    ),

    awful.key({ modkey }, "Left",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}
    ),

    awful.key({ modkey }, "Right",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}
    ),

    -- By direction client focus with hjkl
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}
    ),

    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}
    ),

    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}
    ),

    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}
    ),

    -- Move clients
    
    awful.key({ modkey, "Shift" }, "Down",
        function()
            awful.client.swap.global_bydirection("down")
        end,
        {description = "focus down", group = "client"}
    ),

    awful.key({ modkey, "Shift" }, "Up",
        function()
            awful.client.swap.global_bydirection("up")
        end,
        {description = "focus up", group = "client"}
    ),

    awful.key({ modkey, "Shift" }, "Left",
        function()
            awful.client.swap.global_bydirection("left")
        end,
        {description = "focus left", group = "client"}
    ),

    awful.key({ modkey, "Shift" }, "Right",
        function()
            awful.client.swap.global_bydirection("right")
        end,
        {description = "focus right", group = "client"}
    ),


    awful.key({ modkey, "Shift"   }, "j",
        function ()
            awful.client.swap.global_bydirection("down")
        end,
        {description = "swap with next client by index", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "k",
        function ()
            awful.client.swap.global_bydirection("up")
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    
    awful.key({ modkey, "Shift"   }, "h",
        function ()
            awful.client.swap.global_bydirection("left")
        end,
        {description = "swap with next client by index", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "l",
        function ()
            awful.client.swap.global_bydirection("right")
        end,
        {description = "swap with previous client by index", group = "client"}
    ),


    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,     {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,     {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto), 

    -- Tag browsing
    awful.key({ modkey, super }, "Left",   awful.tag.viewprev,            {description = "view previous", group = "tag"}),
    awful.key({ modkey, super }, "Right",  awful.tag.viewnext,            {description = "view next", group = "tag"}),


    -- Setup program shortcuts

    awful.key({ modkey          }, "w", function () awful.util.spawn( browser1 ) end, {description = browser1, group = "hotkeys"}),
    awful.key({ modkey, "Shift" }, "w", function () awful.util.spawn( browser_private) end, {description = browser_private, group = "hotkeys"}), 
    awful.key({ modkey          }, "d",
        function ()
            --awful.spawn(string.format("dmenu_run -i -nb '#4C3E41' -nf '#FCE1D4' -sb '#FCE1D4' -sf '#4C3E41' -fn FiraCodeMedium:bold:pixelsize=14",
            --beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
            --awful.spawn("dmenu_run -i -nb '#4C3E41' -nf '#FCE1D4' -sb '#FCE1D4' -sf '#4C3E41' -fn FiraCodeMedium:bold:pixelsize=14")
            awful.spawn("dmenu_run -p $ -i -nb '"..beautiful.bg_focus.."' -nf '"..beautiful.fg_focus.."' -sb '"..beautiful.fg_focus.."' -sf '"..beautiful.bg_focus.."' -fn FiraCodeMedium:bold:pixelsize=14")
        end,
        {description = "show dmenu", group = "hotkeys"}
    ),

    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,                      {description = terminal, group = "hotkeys"}),
    awful.key({ modkey }, "e",      function () awful.util.spawn( editorgui ) end,              {description = "run gui editor", group = "hotkeys"}),
    awful.key({ modkey }, "p",      function () awful.util.spawn( "kitty -T 'htop task manager' htop" ) end, {description = "htop", group = "hotkeys"}),
    awful.key({ modkey }, "t",      function () awful.util.spawn( mailclient ) end,             {description = "thunderbird", group = "hotkeys"}),
    awful.key({ modkey }, "v",      function () awful.util.spawn( "pavucontrol" ) end,          {description = "pulseaudio control", group = "hotkeys"}),
    awful.key({ modkey }, "c",      function () awful.util.spawn( "arcolinux-logout" ) end,     {description = "exit", group = "hotkeys"}),
    awful.key({ modkey }, "Escape", function () awful.util.spawn( "xkill" ) end,                {description = "Kill proces", group = "hotkeys"}),

    awful.key({ modkey, "Shift" }, "Return", function() awful.util.spawn( filemanager ) end, {description = "Open filemanager", group = "hotkeys"}),

    awful.key({ }, "Print", function () awful.util.spawn("scrot 'Screenshot-%Y-%m-%d-%s_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)/Screenshots/'") end,  {description = "Save screenshot", group = "hotkeys"}),

    -- Activate menubar
    awful.key({ modkey }, "ü", function() menubar.show() end,              {description = "show the menubar", group = "function keys"}),

    -- Hotkeys Awesome
    awful.key({ modkey}, "s",       hotkeys_popup.show_help,       {description = "show hotkeys", group="awesome"}),
    
    -- Show/Hide Wibox
    awful.key({ modkey }, "b", 
        function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "Show / Hide wibox", group = "awesome"}
    ),

    awful.key({ modkey, "Shift"  }, "r", awesome.restart,                                      {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"  }, "c", awesome.quit,                                         {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),


    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end,             {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end,             {description = "select previous", group = "layout"}),

    awful.key({ modkey }, "n", 
        function() 
            local screen = awful.screen.focused()
            if screen then
                if layout_tmp then
                    awful.layout.set(layout_tmp)
                    layout_tmp = nil
                else
                    layout_tmp = awful.layout.get(awful.screen.focused())
                    awful.layout.set(awful.layout.suit.magnifier)
                end
            end
        end,
        {description = "switch to magnifier", group = "layout" }
    ),

    -- Simple key bindings

    -- ALSA volume control
    awful.key({ }, "XF86AudioRaiseVolume", function () os.execute("amixer -q set Master 2%+") end),
    awful.key({ }, "XF86AudioLowerVolume", function () os.execute("amixer -q set Master 2%-") end),
    awful.key({ }, "XF86AudioMute",        function () os.execute("amixer -q set Master toggle") end),

    -- Media keys supported by vlc, spotify, audacious, xmm2, and web browsers
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play-pause", false) end),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next", false) end),
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous", false) end),
    awful.key({}, "XF86AudioStop", function() awful.util.spawn("playerctl stop", false) end)

)


clientkeys = my_table.join(

    awful.key({ modkey, "Shift"   }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
        end,
        {description = "toggle fullscreen", group = "client" }
    ),

    awful.key({ modkey,           }, "f",
        function (c)
            c.floating = not c.floating
            c.width = c.screen.geometry.width * 3/5
            c.x = c.screen.geometry.x+(c.screen.geometry.width/5)
            c.height = c.screen.geometry.height * 3/5
            c.y = c.screen.geometry.height * 1/5
        end,
        {description = "toggle floating", group = "client" }
    ),

    awful.key({ modkey, "Shift"   }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "toggle maximize", group = "client" }
    ),

    -- Maximize / minimize clients
    awful.key({ modkey,           }, "m",
        function()
            local c = client.focus
            if c then
                if not c.minimized then
                    c.minimized = true
                else
                    c.minimized = false
                end
            else
                c = awful.client.restore()
                if c then
                    client.focus = c
                    c:raise()
                end
            end
        end,
        {description = "show / minimize client", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,             {description = "close", group = "hotkeys"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,             {description = "move to screen", group = "client"})
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,             {description = "move to master", group = "client"}),

)


-- Bind all key numbers to tags.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

-- Set mouse keys
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
),

-- Set keys
root.keys(globalkeys)



-- Set window rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } }, properties = { titlebars_enabled = false } },

    -- VS Code should not start maximized
    { rule = { class = "code" },
        properties = { maximized = false, floating = false } },

    { rule = { class = "Gimp*", role = "gimp-image-window" },
        properties = { maximized = true } },

    { rule = { class = "Gnome-disks" },
        properties = { maximized = true } },

    { rule = { class = "inkscape" },
        properties = { maximized = true } },

    --{ rule = { class = mediaplayer },
    --      properties = { maximized = true } },

    { rule = { class = "Vlc" },
        properties = { maximized = true } },


    -- Floating clients.
    { 
        rule_any = {
            instance = {
                "copyq",  -- Includes session name in class.
                "Msgcompose", -- Thunderbirds new email
            },
            class = {
                "Arcolinux-welcome-app.py",
                "Galculator",
                "Gnome-font-viewer",
                "Gpick",
                "Imagewriter",
                "Font-manager",
                "Kruler",
                "MessageWin",  -- kalarm.
                "arcolinux-logout",
                "Peek",
                "Skype",
                "System-config-printer.py",
                "Sxiv",
                "Unetbootin.elf",
                "Wpa_gui",
                "xtightvncviewer",
                "Xfce4-terminal",
            },

            name = {
                "Event Tester",  -- xev.
                "ownCloud",    -- OwnCloud client 
                "Taschenrechner"
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                "Preferences",
                "setup",
            }
        },
        properties = { floating = true },
        callback = function (c)
            awful.placement.centered(c, nil)
        end
    },

    -- Floating clients but centered in screen
    { 
        rule_any = {
       	    class = { "Polkit-gnome-authentication-agent-1"	},
		},
      	properties = { floating = true },
	    callback = function (c)
    	    awful.placement.centered(c,nil)
        end 
    }
}

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = dpi(21)}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
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
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Setup autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
awful.spawn.with_shell("picom -b --config  $HOME/.config/awesome/picom.conf")
