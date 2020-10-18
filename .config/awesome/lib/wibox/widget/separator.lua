---------------------------------------------------------------------------
-- A flexible separator widget.
--
-- By default, this widget display a simple line, but can be extended by themes
-- (or directly) to display much more complex visuals.
--
-- This widget is mainly intended to be used alongside the `spacing_widget`
-- property supported by various layouts such as:
--
-- * `wibox.layout.fixed`
-- * `wibox.layout.flex`
-- * `wibox.layout.ratio`
--
-- When used with these layouts, it is also possible to provide custom clipping
-- functions. This is useful when the layout has overlapping widgets (negative
-- spacing).
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_defaults_separator.svg)
--
-- @usage
-- wibox.widget {
--     widget = wibox.widget.separator
-- }
--
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2014, 2017 Emmanuel Lepage Vallee
-- @classmod wibox.widget.separator
---------------------------------------------------------------------------
local beautiful = require( "beautiful"         )
local base      = require( "wibox.widget.base" )
local color     = require( "gears.color"       )
local gtable    = require( "gears.table"       )

local separator = {}

--- The separator's orientation.
--
-- Valid values are:
--
-- * *vertical*: From top to bottom
-- * *horizontal*: From left to right
-- * *auto*: Decide depending on the widget geometry (default)
--
-- The default value is selected automatically. If the widget is taller than
-- large, it will use vertical and vice versa.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_separator_orientation.svg)
--
--
-- @property orientation
-- @param string

--- The separator's thickness.
--
-- This is used by the default line separator, but ignored when a shape is used.
--
-- @property thickness
-- @param number

--- The separator's shape.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_separator_shape.svg)
--
-- @usage
-- for _, s in ipairs { 'losange' ,'circle', 'isosceles_triangle', 'cross' } do
--     local w = wibox.widget {
--         shape  = gears.shape[s],
--         widget = wibox.widget.separator,
--     }
-- end
--
-- @property shape
-- @tparam function shape A valid shape function
-- @see gears.shape

--- The relative percentage covered by the bar.
-- @property span_ratio
-- @tparam[opt=1] number A number between 0 and 1.

--- The separator's color.
-- @property color
-- @param string
-- @see gears.color

--- The separator's border color.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_separator_border_color.svg)
--
-- @usage
-- wibox.widget {
--     shape        = gears.shape.circle,
--     color        = '#00000000',
--     border_width = 1,
--     border_color = beautiful.bg_normal,
--     widget       = wibox.widget.separator,
-- }
--
-- @property border_color
-- @param string
-- @see gears.color

--- The separator's border width.
-- @property border_width
-- @param number

--- The separator thickness.
-- @beautiful beautiful.separator_thickness
-- @param number
-- @see thickness

--- The separator border color.
-- @beautiful beautiful.separator_border_color
-- @param gears.color
-- @see border_color

--- The separator border width.
-- @beautiful beautiful.separator_border_width
-- @param number
-- @see border_width

--- The relative percentage covered by the bar.
-- @beautiful beautiful.separator_span_ratio
-- @tparam[opt=1] number A number between 0 and 1.

--- The separator's color.
-- @beautiful beautiful.separator_color
-- @param string
-- @see gears.color

--- The separator's shape.
--
-- @beautiful beautiful.separator_shape
-- @tparam function shape A valid shape function
-- @see gears.shape

local function draw_shape(self, _, cr, width, height, shape)
    local bw = self._private.border_width or beautiful.separator_border_width or 0
    local bc = self._private.border_color or beautiful.separator_border_color

    cr:translate(bw/2, bw/2)

    shape(cr, width-bw, height-bw)

    if bw == 0 then
        cr:fill()
    elseif bc then
        cr:fill_preserve()
        cr:set_source(color(bc))
        cr:set_line_width(bw)
        cr:stroke()
    end
end

local function draw_line(self, _, cr, width, height)
    local thickness = self._private.thickness or beautiful.separator_thickness or 1

    local orientation = self._private.orientation ~= "auto" and
        self._private.orientation or (width > height and "horizontal" or "vertical")

    local span_ratio = self.span_ratio or 1

    if orientation == "horizontal" then
        local w = width*span_ratio
        cr:rectangle((width-w)/2, height/2 - thickness/2, w, thickness)
    else
        local h = height*span_ratio
        cr:rectangle(width/2 - thickness/2, (height-h)/2, thickness, h)
    end

    cr:fill()
end

local function draw(self, _, cr, width, height)
    -- In case there is a specialized.
    local draw_custom = self._private.draw or beautiful.separator_draw
    if draw_custom then
        return draw_custom(self, _, cr, width, height)
    end

    local col = self._private.color or beautiful.separator_color

    if col then
        cr:set_source(color(col))
    end

    local s = self._private.shape or beautiful.separator_shape

    if s then
        draw_shape(self, _, cr, width, height, s)
    else
        draw_line(self, _, cr, width, height)
    end
end

local function fit(_, _, width, height)
    return width, height
end

for _, prop in ipairs {"orientation", "color", "thickness", "span_ratio",
                       "border_width", "border_color", "shape" } do
    separator["set_"..prop] = function(self, value)
        self._private[prop] = value
        self:emit_signal("property::"..prop)
        self:emit_signal("widget::redraw_needed")
    end
    separator["get_"..prop] = function(self)
        return self._private[prop] or beautiful["separator_"..prop]
    end
end

local function new(args)
    local ret = base.make_widget(nil, nil, {
        enable_properties = true,
    })
    gtable.crush(ret, separator, true)
    gtable.crush(ret, args or {})
    ret._private.orientation = ret._private.orientation or "auto"
    rawset(ret, "fit" , fit )
    rawset(ret, "draw", draw)
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

return setmetatable(separator, { __call = function(_, ...) return new(...) end })
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
