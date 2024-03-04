-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local dpi   = require("beautiful.xresources").apply_dpi
local calendar_widget = require("calendar")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

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

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.font = "Poppins Regular 16"
beautiful.menu_font = "Poppins Regular 14"
titlebar_font = "Poppins Regular 13"
beautiful.notification_font = "Poppins Regular 14"
beautiful.menu_width = dpi(240)
beautiful.menu_height = dpi(27)

text_color = '#F0F0F0'
-- accent_light = '#4C3A6B' --purple
-- accent_dark = '#36265A' --purple
accent_light = "#09AC93" --turquoise
accent_dark = "#03866A" --turquoise
-- accent_light = "#079F36" --green
-- accent_dark = "#02771F" --green
-- accent_light = '#AA8B09' --yellow
-- accent_dark = '#7E5F02' --yellow
neutral_light = "#404040"
neutral_dark = "#303030"

wibar_height = dpi(36)
wibar_color = gears.color({
    type  = "linear",
    from  = { wibar_height, 0 },
    to    = { wibar_height, wibar_height },
    stops = { { 0, neutral_light.."D8" }, { 0.3, neutral_dark.."D8" }, {0.7, neutral_dark.."D8"}, { 1, neutral_light.."D8" } }
})


titlebar_height = 25
titlebar_focus_color = gears.color({
    type  = "linear",
    from  = { titlebar_height, 0 },
    to    = { titlebar_height, titlebar_height },
    stops = { { 0, accent_light.."D8" }, { 0.3, accent_dark.."D8" }, {0.7, accent_dark.."D8"}, { 1, accent_light.."D8"} }
})
titlebar_color = gears.color({
    type  = "linear",
    from  = { titlebar_height, 0 },
    to    = { titlebar_height, titlebar_height },
    stops = { { 0, neutral_light.."D8" }, { 0.3, neutral_dark.."D8" }, {0.7, neutral_dark.."D8"}, { 1, neutral_dark.."D8" } }
})
menu_focus_color = gears.color({
    type  = "linear",
    from  = { beautiful.menu_height, 0 },
    to    = { beautiful.menu_height, beautiful.menu_height },
    stops = { { 0, accent_light.."D0" }, { 0.3, accent_dark.."D0" }, {0.7, accent_dark.."D0"}, { 1, accent_light.."D0"} }
})
beautiful.wibar_border_color = neutral_light
beautiful.wibar_bg = wibar_color
beautiful.wibar_fg = text_color
beautiful.bg_normal = neutral_dark
beautiful.fg_normal = text_color
beautiful.menu_bg_normal = neutral_dark.."D0"
beautiful.menu_fg_normal = text_color
beautiful.menu_bg_focus = menu_focus_color
beautiful.menu_fg_focus = text_color
beautiful.bg_systray = neutral_dark
beautiful.taglist_fg_focus = text_color
beautiful.taglist_fg_urgent = text_color
beautiful.taglist_fg_occupied = text_color
beautiful.taglist_fg_empty = text_color
beautiful.taglist_bg_focus = beautiful.wibar_border_color
beautiful.taglist_squares_unsel = beautiful.taglist_squares_sel
beautiful.titlebar_bg = titlebar_color
beautiful.titlebar_fg = text_color
beautiful.titlebar_bg_focus = titlebar_focus_color
beautiful.border_focus = accent_light
beautiful.border_normal = neutral_light
beautiful.border_width = dpi(3)

-- This is used later as the default terminal and editor to run.
terminal = "st -e tmux"
editor = os.getenv("EDITOR") or "vim"
-- editor_cmd = terminal .. " -e " .. editor
editor_cmd = "st -e tmux new-session vim"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1" --Mod1 is Alt, Mod4 is Windows

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.fullscreen,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu

myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_terminal,
        }
    })
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Calendar widget
local cw = calendar_widget({
    theme = 'naughty',
    placement = 'top_right',
    start_sunday = true
})
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %l:%M %P", 5)
local popup_cal = awful.widget.calendar_popup.month()
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then
            if mymainmenu.wibox.visible then
                mymainmenu:hide()
            else
                cw.toggle()
            end
        end
        if button == 3 then mymainmenu:toggle() end
        if button == 4 then awful.tag.viewnext() end
        if button == 5 then awful.tag.viewprev() end
    end
)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        -- local wallpaper = beautiful.wallpaper
        local wallpaper = os.getenv("HOME") .. "/.config/background"
        if not gears.filesystem.file_readable(wallpaper) then
            naughty.notify({ preset = naughty.config.presets.critical,
                             title = "Oops, there were errors during startup!",
                             text = "Could not load background: " .. wallpaper })
        end
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

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        -- filter = awful.widget.taglist.filter.selected,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                        widget  = wibox.container.place,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                widget = wibox.container.place,
            },
            id = 'background_role',
            widget = wibox.container.background,
            forced_width = dpi(30),
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        stretch  = false,
        width = s.geometry.width*0.7,
        height = wibar_height,
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.container.margin,
        align  = 'center',
        -- margins = dpi(3),
        top = dpi(3),
        bottom = dpi(3),
        left = dpi(5),
        right = dpi(5),
        color = beautiful.wibar_border_color,
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
                s.mylayoutbox,
                s.mypromptbox,
            },
            {
                align  = 'center',
                widget = mytextclock
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
            },
        }
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
     -- Multimedia keys
    awful.key({ }, "XF86AudioRaiseVolume",    function () awful.util.spawn("pactl set-sink-volume 0 +5%") end),
    awful.key({ }, "XF86AudioLowerVolume",    function () awful.util.spawn("pactl set-sink-volume 0 -5%") end),
    awful.key({ }, "XF86AudioMute",    function () awful.util.spawn("pactl set-sink-mute 0 toggle") end),
    awful.key({ }, "XF86AudioPlay",    function () awful.util.spawn("playerctl play") end),
    awful.key({ }, "XF86AudioPause",    function () awful.util.spawn("playerctl pause") end),
    awful.key({ }, "XF86AudioNext",    function () awful.util.spawn("playerctl next") end),
    awful.key({ }, "XF86AudioPrev",    function () awful.util.spawn("playerctl previous") end),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "t", function () awful.spawn("thunar") end,
              {description = "file explorer", group = "launcher"}),
    awful.key({ modkey,           }, "space", function () awful.spawn("rofi -show run") end,
              {description = "launch a program", group = "launcher"}),
        -- awful.key({ modkey,           }, "space", function () awful.spawn("dmenu_run -fn 'Droid Sans Mono-12' -sb '#4B81AF'") end,
    --           {description = "launch a program", group = "launcher"}),
    -- awful.key({ modkey }, "space", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ "Mod4",           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ "Mod4", "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ "Mod4",           }, ";", function () awful.spawn("i3lock") end,
              {description = "lock screen", group = "launcher"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 4 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ }, "F" .. i,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Move client to tag.
        awful.key({ "Shift" }, "F" .. i,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                               tag:view_only()
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
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
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { rule_any = { class = { "Main.py", "guake" } , name = { "Guake!" }  },
	  properties = { floating = true }, callback = awful.client.setslave},
}
-- }}}

-- {{{ Signals
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
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    local top_titlebar = awful.titlebar(c, {
        size = titlebar_height,
    })

    titlewidget = awful.titlebar.widget.titlewidget(c)
    titlewidget.font = titlebar_font

    top_titlebar : setup {
        layout = wibox.container.margin,
        bottom = beautiful.border_width,
        {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align  = "center",
                    -- widget = awful.titlebar.widget.titlewidget(c, {font = "Poppins Regular 8"})
                    widget = titlewidget
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                --awful.titlebar.widget.stickybutton   (c),
                --awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus",
    function(c)
        c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus",
    function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
do
  local cmds =
  {
    "guake",
    "xcompmgr",
    "thunar --daemon",
    "xfce4-power-manager",
    "kdeconnect-indicator",
    "gnome-keyring-daemon",
    "nm-applet"
  }

  for _,i in pairs(cmds) do
    awful.util.spawn(i)
  end
end
