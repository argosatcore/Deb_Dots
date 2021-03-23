--[[


░█▀█░█▀▄░█▀▀░░░░░█▀▄░█▀█░█▀▄░█░█
░█▀█░█▀▄░█░░░▄▄▄░█░█░█▀█░█▀▄░█▀▄
░▀░▀░▀░▀░▀▀▀░░░░░▀▀░░▀░▀░▀░▀░▀░▀

     Arc Dark Awesome WM theme
     github.com/argosatcore

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/arc-dark"
theme.wallpaper                                 = theme.dir .. "/Wallpapers/tile.jpeg"
theme.font                                      = "FontAwesome bold 8"
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = "#FFFFFF"
theme.fg_urgent                                 = "#FFFFFF"
theme.bg_normal                                 = "#2F343FBF"
theme.bg_focus                                  = "#2F343F"
theme.bg_urgent                                 = "#1A1A1A"
theme.hotkeys_bg                                = "#2F343F"
theme.hotkeys_fg                                = "#FFFFFF"
theme.hotkeys_modifiers_fg                      = "#FFFFFF"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#323944"
theme.border_focus                              = "#5294E2"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#5294E2"
theme.tasklist_bg_normal                        = "#5294E259"
theme.tasklist_bg_urgent                        = "#f46067"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.taglist_bg_focus                          = "#5294E2"
theme.taglist_bg_urgent                         = "#f46067"
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
theme.layout_centerwork                         = theme.dir .. "/icons/centerwork.png"
theme.layout_centerworkh                        = theme.dir .. "/icons/centerworkh.png"
theme.layout_centerfair                         = theme.dir .. "/icons/centerfair.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(0)
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


local markup = lain.util.markup
-- local separators = lain.util.separators


local keyboardlayout = awful.widget.keyboardlayout:new()


-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %l:%M %P'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)


-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Ubuntu Mono 12",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})


-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB"))
    end
})


-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "%"))
    end
})


-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C"))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
theme.bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "%"))
        else
            widget:set_markup(markup.font(theme.font, " AC"))
            baticon:set_image(theme.widget_ac)
        end
    end
})
theme.bat.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("xbacklight -inc 5")
                                     theme.bat.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("xbacklight -dec 5")
                                     theme.bat.update()
                               end)
))


-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(theme.widget_vol_low)
        else
            volicon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "%"))
    end
})
theme.volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("amixer set Master 1%+")
                                     theme.volume.update()
                               end),
                               awful.button({}, 1, function ()
                                     awful.util.spawn("pavucontrol -t 3")
                               end),
                               awful.button({}, 3, function ()
                                     awful.util.spawn("pkill pavucontrol")
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("amixer set Master 1%-")
                                     theme.volume.update()
                               end)
))


-- Net
local neticon =  wibox.widget{
    markup = '<b></b>',
    align  = 'center',
    valign = 'center',
    font   = 'FontAwesome 8',
    fg     = theme.fg_normal,
    widget = wibox.widget.textbox
}
neticon:buttons(awful.util.table.join(
                               awful.button({}, 1, function ()
                                     awful.spawn.with_shell("bash ~/.local/bin/scripts/rofi/rofi-wifi-menu/rofi-wifi-menu.sh")
                               end)
))


-- Debian's Logo
local deblogo =  wibox.widget{
    markup = '  <b></b>   ',
    align  = 'center',
    valign = 'center',
    font   = 'Ubuntu Nerd Font 12',
    fg     = theme.fg_normal,
    widget = wibox.widget.textbox
}
deblogo:buttons(awful.util.table.join(
                               awful.button({}, 1, function ()
                                     awful.util.spawn("rofi -show power-menu -location 1 -yoffset 25 -xoffset 5 -width 15 -columns 1 -lines 6 -modi power-menu:~/.local/bin/scripts/rofi/rofi-power-menu-master/./rofi-power-menu")
                               end),

                               awful.button({ }, 5, function(t) 
				     awful.tag.viewnext(t.screen) 
			       end),

                               awful.button({ }, 4, function(t) 
				     awful.tag.viewprev(t.screen) 
			       end),

                               awful.button({ }, 3, function( ) 
				     awful.util.spawn("rofi -show drun -location 1 -yoffset 25 -xoffset 5 -width 15 -columns 1 -lines 6")  
			       end)
))


-- Separators
local spr     = wibox.widget.textbox('     ')

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 5, function () awful.layout.inc( 1) end),
                           awful.button({}, 4, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
	    deblogo,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            wibox.widget.systray(),
            spr,
            keyboardlayout,
            spr,
            memicon,
            mem.widget,
            spr,
            cpuicon,
            cpu.widget,
            spr,
            tempicon,
            temp.widget,
            spr,
	    neticon,
	    spr,
            volicon,
            theme.volume.widget,
            spr,
            baticon,
	    theme.bat.widget,
            spr,
            clock,
            spr,
            s.mylayoutbox,
        },
    }
end

return theme
