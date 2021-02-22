----------------------------------------------------------------------------
--- Display the available client layouts for a screen.
--
-- This is what the layoutlist looks like by default with a vertical layout:
--
--
--
--![Usage example](../images/AUTOGEN_awful_widget_layoutlist_default.svg)
--
-- 
--     awful.popup {
--         widget = awful.widget.layoutlist {
--             screen      = 1,
--             base_layout = wibox.layout.flex.vertical
--         },
--         maximum_height = #awful.layout.layouts * 24,
--         minimum_height = #awful.layout.layouts * 24,
--         placement      = awful.placement.centered,
--     }
--
-- In the second example, it is shown how to create a popup in the center of
-- the screen:
--
--
--
--![Usage example](../images/AUTOGEN_awful_widget_layoutlist_popup.svg)
--
-- 
--     local ll = awful.widget.layoutlist {
--         base_layout = wibox.widget {
--             spacing         = 5,
--             forced_num_cols = 5,
--             layout          = wibox.layout.grid.vertical,
--         },
--         widget_template = {
--             {
--                 {
--                     id            = 'icon_role',
--                     forced_height = 22,
--                     forced_width  = 22,
--                     widget        = wibox.widget.imagebox,
--                 },
--                 margins = 4,
--                 widget  = wibox.container.margin,
--             },
--             id              = 'background_role',
--             forced_width    = 24,
--             forced_height   = 24,
--             shape           = gears.shape.rounded_rect,
--             widget          = wibox.container.background,
--         },
--     }
--      
--     local layout_popup = awful.popup {
--         widget = wibox.widget {
--             ll,
--             margins = 4,
--             widget  = wibox.container.margin,
--         },
--         border_color = beautiful.border_color,
--         border_width = beautiful.border_width,
--         placement    = awful.placement.centered,
--         ontop        = true,
--         visible      = false,
--         shape        = gears.shape.rounded_rect
--     }
--      
--     -- Make sure you remove the default `Mod4+Space` and `Mod4+Shift+Space`
--     -- keybindings before adding this.
--     awful.keygrabber {
--         start_callback = function() layout_popup.visible = true  end,
--         stop_callback  = function() layout_popup.visible = false end,
--         export_keybindings = true,
--         release_event = 'release',
--         stop_key = {'Escape', 'Super_L', 'Super_R'},
--         keybindings = {
--             {{ modkey          } , ' ' , function()
--                 awful.layout.set(gears.table.iterate_value(ll.layouts, ll.current_layout, 1))
--             end},
--             {{ modkey, 'Shift' } , ' ' , function()
--                 awful.layout.set(gears.table.iterate_value(ll.layouts, ll.current_layout, -1), nil)
--             end},
--         }
--     }
--
-- This example extends 'awful.widget.layoutbox' to show a layout list popup:
--
--
--
--![Usage example](../images/AUTOGEN_awful_widget_layoutlist_bar.svg)
--
-- 
--     -- Normally you would use your existing bars, but for this example, we add one
--     local lb = awful.widget.layoutbox(screen[1])
--     local l = wibox.layout.align.horizontal(nil, lb, nil)
--     l.expand = 'outside'
--     awful.wibar { widget = l }
--      
--     local p = awful.popup {
--         widget = wibox.widget {
--             awful.widget.layoutlist {
--                 source      = awful.widget.layoutlist.source.default_layouts,
--                 screen      = 1,
--                 base_layout = wibox.widget {
--                     spacing         = 5,
--                     forced_num_cols = 3,
--                     layout          = wibox.layout.grid.vertical,
--                 },
--                 widget_template = {
--                     {
--                         {
--                             id            = 'icon_role',
--                             forced_height = 22,
--                             forced_width  = 22,
--                             widget        = wibox.widget.imagebox,
--                         },
--                         margins = 4,
--                         widget  = wibox.container.margin,
--                     },
--                     id              = 'background_role',
--                     forced_width    = 24,
--                     forced_height   = 24,
--                     shape           = gears.shape.rounded_rect,
--                     widget          = wibox.container.background,
--                 },
--             },
--             margins = 4,
--             widget  = wibox.container.margin,
--         },
--         preferred_anchors = 'middle',
--         border_color      = beautiful.border_color,
--         border_width      = beautiful.border_width,
--         shape             = gears.shape.infobubble,
--     }
--     p:bind_to_widget(lb)
--
-- This example shows how to add a layout subset to the default wibar:
--
--
--
--![Usage example](../images/AUTOGEN_awful_widget_layoutlist_wibar.svg)
--
-- 
--    wb:setup {
--        layout = wibox.layout.align.horizontal,
--        { -- Left widgets
--            mytaglist,
--            awful.widget.layoutlist {
--                screen = 1,
--                style = {
--                    disable_name = true,
--                    spacing      = 3,
--                },
--                source = function() return {
--                    awful.layout.suit.floating,
--                    awful.layout.suit.tile,
--                    awful.layout.suit.tile.left,
--                    awful.layout.suit.tile.bottom,
--                    awful.layout.suit.tile.top,
--                } end
--            },
--            layout = wibox.layout.fixed.horizontal,
--        },
--        mytasklist, -- Middle widget
--        { -- Right widgets
--            layout = wibox.layout.fixed.horizontal,
--            mykeyboardlayout,
--            mytextclock,
--            mylayoutbox,
--        },
--    }
--
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2010, 2018 Emmanuel Lepage Vallee
-- @classmod awful.widget.layoutlist
----------------------------------------------------------------------------

local capi     = {screen = screen, tag = tag}
local wibox    = require("wibox")
local awcommon = require("awful.widget.common")
local abutton  = require("awful.button")
local ascreen  = require("awful.screen")
local gtable   = require("gears.table")
local beautiful= require("beautiful")
local alayout  = require("awful.layout")
local surface  = require("gears.surface")

local module = {}

local default_buttons = gtable.join(
    abutton({ }, 1, function(a) a.callback() end)
)

local function wb_label(item, _, textbox)
    local selected = alayout.get(item.screen) == item.layout

    -- Apply the built-in customization
    local bg, fg, shape, shape_bw, shape_bc

    -- The layout have only 2 states: normal and selected
    if selected then
        bg = item.style.bg_selected or
            beautiful.layoutlist_bg_selected or
            beautiful.bg_focus
        fg = item.style.fg_selected or
            beautiful.layoutlist_fg_selected or
            beautiful.fg_focus or beautiful.fg_normal
        shape = item.style.shape_selected or
            beautiful.layoutlist_shape_selected
        shape_bw = item.style.shape_border_width_selected or
            beautiful.layoutlist_shape_border_width_selected
        shape_bc = item.style.shape_border_color_selected or
            beautiful.layoutlist_shape_border_color_selected
    else
        bg = item.style.bg_normal or
            beautiful.layoutlist_bg_normal or
            nil
        fg = item.style.fg_normal or
            beautiful.layoutlist_fg_normal or
            beautiful.fg_normal
        shape = item.style.shape or
            beautiful.layoutlist_shape
        shape_bw = item.style.shape_border_width or
            beautiful.layoutlist_shape_border_width
        shape_bc = item.style.shape_border_color or
            beautiful.layoutlist_shape_border_color
    end

    if textbox and item.style.align or beautiful.layoutlist_align then
        textbox:set_align(item.style.align or beautiful.layoutlist_align)
    end

    local text = ""

    if item.name then
        text = "<span color='"..fg.."'>"..item.name..'</span>'
    end

    return text, bg, nil, item.icon, {
        shape               = shape,
        shape_border_width  = shape_bw,
        shape_border_color  = shape_bc,
    }
end

module.source = {}

--- The layout list for the first selected tag of a screen.
-- @tparam screen s The screen.
-- @sourcefunction awful.widget.layoutlist.source.for_screen
function module.source.for_screen(s)
    s = capi.screen[s or ascreen.focused() or 1]
    assert(s)

    local t = s.selected_tag or #s.tags > 0 and s.tags[1]

    return t and t.layouts or {}
end

--- The layouts available for the first selected tag of `awful.screen.focused()`.
-- @sourcefunction awful.widget.layoutlist.source.current_screen
function module.source.current_screen()
    return module.source.for_screen()
end

--- The default layout list.
-- @see awful.layout.layouts
-- @sourcefunction awful.widget.layoutlist.source.default_layouts
function module.source.default_layouts()
    return alayout.layouts
end

local function reload_cache(self)
    self._private.cache = {}

    local show_text = (not self._private.style.disable_name) and
        (not beautiful.layoutlist_disable_name)

    local show_icon = (not self._private.style.disable_icon) and
        (not beautiful.layoutlist_disable_icon)

    local s = self.screen or ascreen.focused()

    -- Get the list.
    local ls = self:get_layouts()

    for _, l in ipairs(ls or {}) do
        local icn_path, icon = beautiful["layout_" .. (l.name or "")]
        if icn_path then
            icon = surface.load(icn_path)
        end

        table.insert(self._private.cache, {
            icon         = show_icon and icon   or nil,
            name         = show_text and l.name or nil,
            layout       = l,
            screen       = s,
            callback     = function() alayout.set(l) end,
            style        = self._private.style,
        })
    end
end

local function update(self)
    assert(self._private.layout)
    awcommon.list_update(
        self._private.layout,
        self._private.buttons or default_buttons,
        wb_label,
        self._private.data,
        self._private.cache,
        {
            widget_template = self._private.widget_template
        }
    )
end

local layoutlist = {}

--- The layoutlist default widget layout.
-- If no layout is specified, a `wibox.layout.fixed.vertical` will be created
-- automatically.
-- @property base_layout
-- @param widget
-- @see wibox.layout.fixed.vertical
-- @see base_layout

--- The delegate widget template.
-- @property widget_template
-- @param table

--- The layoutlist screen.
-- @property screen
-- @param screen

--- A function that returns the list of layout to display.
--
-- @property source
-- @param[opt=awful.widget.layoutlist.source.for_screen] function

--- The layoutlist filter function.
-- @property filter
-- @param[opt=awful.widget.layoutlist.source.for_screen] function

--- The layoutlist buttons.
--
-- The default is:
--
--    gears.table.join(
--        awful.button({ }, 1, awful.layout.set)
--    )
--
-- @property buttons
-- @param table

--- The default foreground (text) color.
-- @beautiful beautiful.layoutlist_fg_normal
-- @tparam[opt=nil] string|pattern fg_normal
-- @see gears.color

--- The default background color.
-- @beautiful beautiful.layoutlist_bg_normal
-- @tparam[opt=nil] string|pattern bg_normal
-- @see gears.color

--- The selected layout foreground (text) color.
-- @beautiful beautiful.layoutlist_fg_selected
-- @tparam[opt=nil] string|pattern fg_selected
-- @see gears.color

--- The selected layout background color.
-- @beautiful beautiful.layoutlist_bg_selected
-- @tparam[opt=nil] string|pattern bg_selected
-- @see gears.color

--- Disable the layout icons (only show the name label).
-- @beautiful beautiful.layoutlist_disable_icon
-- @tparam[opt=false] boolean layoutlist_disable_icon

--- Disable the layout name label (only show the icon).
-- @beautiful beautiful.layoutlist_disable_name
-- @tparam[opt=false] boolean layoutlist_disable_name

--- The layoutlist font.
-- @beautiful beautiful.layoutlist_font
-- @tparam[opt=nil] string font

--- The selected layout alignment.
-- @beautiful beautiful.layoutlist_align
-- @tparam[opt=left] string align *left*, *right* or *center*

--- The selected layout title font.
-- @beautiful beautiful.layoutlist_font_selected
-- @tparam[opt=nil] string font_selected

--- The space between the layouts.
-- @beautiful beautiful.layoutlist_spacing
-- @tparam[opt=0] number spacing The spacing between tasks.

--- The default layoutlist elements shape.
-- @beautiful beautiful.layoutlist_shape
-- @tparam[opt=nil] gears.shape shape

--- The default layoutlist elements border width.
-- @beautiful beautiful.layoutlist_shape_border_width
-- @tparam[opt=0] number shape_border_width

--- The default layoutlist elements border color.
-- @beautiful beautiful.layoutlist_shape_border_color
-- @tparam[opt=nil] string|color shape_border_color
-- @see gears.color

--- The selected layout shape.
-- @beautiful beautiful.layoutlist_shape_selected
-- @tparam[opt=nil] gears.shape shape_selected

--- The selected layout border width.
-- @beautiful beautiful.layoutlist_shape_border_width_selected
-- @tparam[opt=0] number shape_border_width_selected

--- The selected layout border color.
-- @beautiful beautiful.layoutlist_shape_border_color_selected
-- @tparam[opt=nil] string|color shape_border_color_selected
-- @see gears.color

--- The currenly displayed layouts.
-- @property layouts
-- @param table

--- The currently selected layout.
-- @property current_layout
-- @param layout

function layoutlist:get_layouts()
    local f = self.source or self._private.source or module.source.for_screen

    return f(self.screen)
end

function layoutlist:get_current_layout()
    -- Eventually the entire lookup could be removed. All it does is allowing
    -- `nil` to be returned when there is no selection.
    local ls = self:get_layouts()
    local l = alayout.get(self.screen or ascreen.focused())
    local selected_k = gtable.hasitem(ls, l, true)

    return selected_k and ls[selected_k] or nil
end

function layoutlist:set_buttons(buttons)
    self._private.buttons = buttons
    update(self)
end

function layoutlist:get_buttons()
    return self._private.buttons
end

function layoutlist:set_base_layout(layout)
    self._private.layout = wibox.widget.base.make_widget_from_value(
        layout or wibox.layout.fixed.horizontal
    )

    if self._private.layout.set_spacing then
        self._private.layout:set_spacing(
            self._private.style.spacing or beautiful.tasklist_spacing or 0
        )
    end

    assert(self._private.layout.is_widget)

    update(self)

    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::redraw_needed")
end

function layoutlist:set_widget_template(widget_template)
    self._private.widget_template = widget_template

    -- Remove the existing instances
    self._private.data = {}

    -- Prevent a race condition when the constructor loop to initialize the
    -- arguments.
    if self._private.layout then
        update(self)
    end

    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::redraw_needed")
end

function layoutlist:layout(_, width, height)
    if self._private.layout then
        return { wibox.widget.base.place_widget_at(self._private.layout, 0, 0, width, height) }
    end
end

function layoutlist:fit(context, width, height)
    if not self._private.layout then
        return 0, 0
    end

    return wibox.widget.base.fit_widget(self, context, self._private.layout, width, height)
end

--- Create a layout list.
--
-- @tparam table args
-- @tparam widget args.layout The widget layout (not to be confused with client
--  layout).
-- @tparam table args.buttons A table with buttons binding to set.
-- @tparam[opt=awful.widget.layoutlist.source.for_screen] function args.source A
--  function to generate the list of layouts.
-- @tparam[opt] table args.widget_template A custom widget to be used for each action.
-- @tparam[opt=ascreen.focused()] screen args.screen A screen
-- @tparam[opt=nil] table args.buttons The list of `awful.buttons`.
-- @tparam[opt={}] table args.style Extra look and feel parameters
-- @tparam boolean args.style.disable_icon
-- @tparam boolean args.style.disable_name
-- @tparam string|pattern args.style.fg_normal
-- @tparam string|pattern args.style.bg_normal
-- @tparam string|pattern args.style.fg_selected
-- @tparam string|pattern args.style.bg_selected
-- @tparam string args.style.font
-- @tparam string args.style.font_selected
-- @tparam string args.style.align *left*, *right* or *center*
-- @tparam number args.style.spacing
-- @tparam gears.shape args.style.shape
-- @tparam number args.style.shape_border_width
-- @tparam string|pattern args.style.shape_border_color
-- @tparam gears.shape args.style.shape_selected
-- @tparam string|pattern args.style.shape_border_width_selected
-- @tparam string|pattern args.style.shape_border_color_selected
-- @treturn widget The action widget.
-- @function awful.widget.layoutlist

local is_connected, instances = false, setmetatable({}, {__mode = "v"})

local function update_common()
    for _, ll in ipairs(instances) do
        reload_cache(ll)
        update(ll)
    end
end

local function new(_, args)
    local ret = wibox.widget.base.make_widget(nil, nil, {
        enable_properties = true,
    })

    gtable.crush(ret, layoutlist, true)

    ret._private.style   = args.style or {}
    ret._private.buttons = args.buttons
    ret._private.source  = args.source
    ret._private.data = {}

    reload_cache(ret)

    -- Apply all args properties
    gtable.crush(ret, args)

    if not ret._private.layout then
        ret:set_base_layout()
    end

    assert(ret._private.layout)

    -- Do not create a connection per instance, if used in a "volatile"
    -- popup, this will balloon.
    if not is_connected then
        for _, sig in ipairs {"layout", "layouts", "selected", "activated"} do
            capi.tag.connect_signal("property::"..sig, update_common)
        end
    end

    -- Add to the (weak) list of active instances.
    table.insert(instances, ret)

    update(ret)

    return ret
end

--
--- Get a widget index.
-- @param widget The widget to look for
-- @param[opt] recursive Also check sub-widgets
-- @param[opt] ... Additional widgets to add at the end of the path
-- @return The index
-- @return The parent layout
-- @return The path between self and widget
-- @function index

--- Get all direct and indirect children widgets.
-- This will scan all containers recursively to find widgets
-- Warning: This method it prone to stack overflow id the widget, or any of its
-- children, contain (directly or indirectly) itself.
-- @treturn table The children
-- @function get_all_children

--- Set a declarative widget hierarchy description.
-- See [The declarative layout system](../documentation/03-declarative-layout.md.html)
-- @param args An array containing the widgets disposition
-- @function setup

--- Force a widget height.
-- @property forced_height
-- @tparam number|nil height The height (`nil` for automatic)

--- Force a widget width.
-- @property forced_width
-- @tparam number|nil width The width (`nil` for automatic)

--- The widget opacity (transparency).
-- @property opacity
-- @tparam[opt=1] number opacity The opacity (between 0 and 1)

--- The widget visibility.
-- @property visible
-- @param boolean

--- Set/get a widget's buttons.
-- @param _buttons The table of buttons that should bind to the widget.
-- @function buttons

--- Emit a signal and ensure all parent widgets in the hierarchies also
-- forward the signal. This is useful to track signals when there is a dynamic
-- set of containers and layouts wrapping the widget.
-- @tparam string signal_name
-- @param ... Other arguments
-- @function emit_signal_recursive

--- When the layout (size) change.
-- This signal is emitted when the previous results of `:layout()` and `:fit()`
-- are no longer valid.  Unless this signal is emitted, `:layout()` and `:fit()`
-- must return the same result when called with the same arguments.
-- @signal widget::layout_changed
-- @see widget::redraw_needed

--- When the widget content changed.
-- This signal is emitted when the content of the widget changes. The widget will
-- be redrawn, it is not re-layouted. Put differently, it is assumed that
-- `:layout()` and `:fit()` would still return the same results as before.
-- @signal widget::redraw_needed
-- @see widget::layout_changed

--- When a mouse button is pressed over the widget.
-- @signal button::press
-- @tparam number lx The horizontal position relative to the (0,0) position in
-- the widget.
-- @tparam number ly The vertical position relative to the (0,0) position in the
-- widget.
-- @tparam number button The button number.
-- @tparam table mods The modifiers (mod4, mod1 (alt), Control, Shift)
-- @tparam table find_widgets_result The entry from the result of
-- @{wibox.drawable:find_widgets} for the position that the mouse hit.
-- @tparam wibox.drawable find_widgets_result.drawable The drawable containing
-- the widget.
-- @tparam widget find_widgets_result.widget The widget being displayed.
-- @tparam wibox.hierarchy find_widgets_result.hierarchy The hierarchy
-- managing the widget's geometry.
-- @tparam number find_widgets_result.x An approximation of the X position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.y An approximation of the Y position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.width An approximation of the width that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.height An approximation of the height that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.widget_width The exact width of the widget
-- in its local coordinate system.
-- @tparam number find_widgets_result.widget_height The exact height of the widget
-- in its local coordinate system.
-- @see mouse

--- When a mouse button is released over the widget.
-- @signal button::release
-- @tparam number lx The horizontal position relative to the (0,0) position in
-- the widget.
-- @tparam number ly The vertical position relative to the (0,0) position in the
-- widget.
-- @tparam number button The button number.
-- @tparam table mods The modifiers (mod4, mod1 (alt), Control, Shift)
-- @tparam table find_widgets_result The entry from the result of
-- @{wibox.drawable:find_widgets} for the position that the mouse hit.
-- @tparam wibox.drawable find_widgets_result.drawable The drawable containing
-- the widget.
-- @tparam widget find_widgets_result.widget The widget being displayed.
-- @tparam wibox.hierarchy find_widgets_result.hierarchy The hierarchy
-- managing the widget's geometry.
-- @tparam number find_widgets_result.x An approximation of the X position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.y An approximation of the Y position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.width An approximation of the width that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.height An approximation of the height that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.widget_width The exact width of the widget
-- in its local coordinate system.
-- @tparam number find_widgets_result.widget_height The exact height of the widget
-- in its local coordinate system.
-- @see mouse

--- When the mouse enter a widget.
-- @signal mouse::enter
-- @tparam table find_widgets_result The entry from the result of
-- @{wibox.drawable:find_widgets} for the position that the mouse hit.
-- @tparam wibox.drawable find_widgets_result.drawable The drawable containing
-- the widget.
-- @tparam widget find_widgets_result.widget The widget being displayed.
-- @tparam wibox.hierarchy find_widgets_result.hierarchy The hierarchy
-- managing the widget's geometry.
-- @tparam number find_widgets_result.x An approximation of the X position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.y An approximation of the Y position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.width An approximation of the width that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.height An approximation of the height that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.widget_width The exact width of the widget
-- in its local coordinate system.
-- @tparam number find_widgets_result.widget_height The exact height of the widget
-- in its local coordinate system.
-- @see mouse

--- When the mouse leave a widget.
-- @signal mouse::leave
-- @tparam table find_widgets_result The entry from the result of
-- @{wibox.drawable:find_widgets} for the position that the mouse hit.
-- @tparam wibox.drawable find_widgets_result.drawable The drawable containing
-- the widget.
-- @tparam widget find_widgets_result.widget The widget being displayed.
-- @tparam wibox.hierarchy find_widgets_result.hierarchy The hierarchy
-- managing the widget's geometry.
-- @tparam number find_widgets_result.x An approximation of the X position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.y An approximation of the Y position that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.width An approximation of the width that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.height An approximation of the height that
-- the widget is visible at on the surface.
-- @tparam number find_widgets_result.widget_width The exact width of the widget
-- in its local coordinate system.
-- @tparam number find_widgets_result.widget_height The exact height of the widget
-- in its local coordinate system.
-- @see mouse

--
--- Disconnect from a signal.
-- @tparam string name The name of the signal.
-- @tparam function func The callback that should be disconnected.
-- @function disconnect_signal

--- Emit a signal.
--
-- @tparam string name The name of the signal.
-- @param ... Extra arguments for the callback functions. Each connected
--   function receives the object as first argument and then any extra
--   arguments that are given to emit_signal().
-- @function emit_signal

--- Connect to a signal.
-- @tparam string name The name of the signal.
-- @tparam function func The callback to call when the signal is emitted.
-- @function connect_signal

--- Connect to a signal weakly.
--
-- This allows the callback function to be garbage collected and
-- automatically disconnects the signal when that happens.
--
-- **Warning:**
-- Only use this function if you really, really, really know what you
-- are doing.
-- @tparam string name The name of the signal.
-- @tparam function func The callback to call when the signal is emitted.
-- @function weak_connect_signal

return setmetatable(module, {__call = new})
