---------------------------------------------------------------------------
-- A boolean display widget.
--
-- If necessary, themes can implement custom shape:
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_checkbox_custom.svg)
--
-- 
--     wibox.widget {
--         checked       = true,
--         color         = beautiful.bg_normal,
--         paddings      = 2,
--         check_shape   = function(cr, width, height)
--             local rs = math.min(width, height)
--             cr:move_to( 0  , 0  )
--             cr:line_to( rs , 0  )
--             cr:move_to( 0  , 0  )
--             cr:line_to( 0  , rs )
--             cr:move_to( 0  , rs )
--             cr:line_to( rs , rs )
--             cr:move_to( rs , 0  )
--             cr:line_to( rs , rs )
--             cr:move_to( 0  , 0  )
--             cr:line_to( rs , rs )
--             cr:move_to( 0  , rs )
--             cr:line_to( rs , 0  )
--         end,
--         check_border_color = '#ff0000',
--         check_color        = '#00000000',
--         check_border_width = 1,
--         widget             = wibox.widget.checkbox
--     }
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_defaults_checkbox.svg)
--
-- @usage
--         wibox.widget {
--             checked       = true,
--             color         = beautiful.bg_normal,
--             paddings      = 2,
--             shape         = gears.shape.circle,
--             widget        = wibox.widget.checkbox
--         }
-- @author Emmanuel Lepage Valle
-- @copyright 2010 Emmanuel Lepage Vallee
-- @classmod wibox.widget.checkbox
---------------------------------------------------------------------------

local color     = require( "gears.color"       )
local base      = require( "wibox.widget.base" )
local beautiful = require( "beautiful"         )
local shape     = require( "gears.shape"       )
local gtable    = require( "gears.table"       )

local checkbox = {}

--- The outer (unchecked area) border width.
-- @beautiful beautiful.checkbox_border_width

--- The outer (unchecked area) background color, pattern or gradient.
-- @beautiful beautiful.checkbox_bg

--- The outer (unchecked area) border color.
-- @beautiful beautiful.checkbox_border_color

--- The checked part border color.
-- @beautiful beautiful.checkbox_check_border_color

--- The checked part border width.
-- @beautiful beautiful.checkbox_check_border_width

--- The checked part filling color.
-- @beautiful beautiful.checkbox_check_color

--- The outer (unchecked area) shape.
-- @beautiful beautiful.checkbox_shape
-- @see gears.shape

--- The checked part shape.
-- If none is set, then the `shape` property will be used.
-- @beautiful beautiful.checkbox_check_shape
-- @see gears.shape

--- The padding between the outline and the progressbar.
-- @beautiful beautiful.checkbox_paddings
-- @tparam[opt=0] table|number paddings A number or a table
-- @tparam[opt=0] number paddings.top
-- @tparam[opt=0] number paddings.bottom
-- @tparam[opt=0] number paddings.left
-- @tparam[opt=0] number paddings.right

--- The checkbox color.
-- This will be used for the unchecked part border color and the checked part
-- filling color. Note that `check_color` and `border_color` have priority
-- over this property.
-- @beautiful beautiful.checkbox_color

--- The outer (unchecked area) border width.
-- @property border_width

--- The outer (unchecked area) background color, pattern or gradient.
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_checkbox_bg.svg)
--
-- @usage
-- wibox.widget {
--     checked            = true,
--     color              = beautiful.bg_normal,
--     bg                 = '#ff00ff',
--     border_width       = 3,
--     paddings           = 4,
--     border_color       = '#0000ff',
--     check_color        = '#ff0000',
--     check_border_color = '#ffff00',
--     check_border_width = 1,
--     widget             = wibox.widget.checkbox
-- }
-- @property bg

--- The outer (unchecked area) border color.
-- @property border_color

--- The checked part border color.
-- @property check_border_color

--- The checked part border width.
-- @property check_border_width

--- The checked part filling color.
-- @property check_color

--- The outer (unchecked area) shape.
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_checkbox_shape.svg)
--
-- @usage
-- for _, s in ipairs {'rectangle', 'circle', 'losange', 'octogon'} do
--     wibox.widget {
--         checked       = true,
--         color         = beautiful.bg_normal,
--         paddings      = 2,
--         shape         = gears.shape[s],
--         widget        = wibox.widget.checkbox
--     }
-- end
-- @property shape
-- @see gears.shape

--- The checked part shape.
-- If none is set, then the `shape` property will be used.
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_checkbox_check_shape.svg)
--
-- @usage
-- for _, s in ipairs {'rectangle', 'circle', 'losange', 'octogon'} do
--     wibox.widget {
--         checked       = true,
--         color         = beautiful.bg_normal,
--         paddings      = 2,
--         check_shape   = gears.shape[s],
--         widget        = wibox.widget.checkbox
--     }
-- end
-- @property check_shape
-- @see gears.shape

--- The padding between the outline and the progressbar.
-- @property paddings
-- @tparam[opt=0] table|number paddings A number or a table
-- @tparam[opt=0] number paddings.top
-- @tparam[opt=0] number paddings.bottom
-- @tparam[opt=0] number paddings.left
-- @tparam[opt=0] number paddings.right

--- The checkbox color.
-- This will be used for the unchecked part border color and the checked part
-- filling color. Note that `check_color` and `border_color` have priority
-- over this property.
-- @property color

local function outline_workarea(self, width, height)
    local offset = (self._private.border_width or
        beautiful.checkbox_border_width or 1)/2

    return {
        x      = offset,
        y      = offset,
        width  = width-2*offset,
        height = height-2*offset
    }
end

-- The child widget area
local function content_workarea(self, width, height)
    local padding = self._private.paddings or {}
    local offset = self:get_check_border_width() or 0
    local wa = outline_workarea(self, width, height)

    wa.x      = offset + wa.x + (padding.left or 1)
    wa.y      = offset + wa.y + (padding.top  or 1)
    wa.width  = wa.width  - (padding.left or 1) - (padding.right  or 1) - 2*offset
    wa.height = wa.height - (padding.top  or 1) - (padding.bottom or 1) - 2*offset

    return wa
end

local function draw(self, _, cr, width, height)
    local size = math.min(width, height)

    local background_shape = self:get_shape() or shape.rectangle
    local border_width = self:get_border_width() or 1

    local main_color = self:get_color()
    local bg = self:get_bg()
    local border_color = self:get_border_color()

    -- If no color is set, it will fallback to the default one
    if border_color or main_color then
        cr:set_source(color(border_color or main_color))
    end

    local wa = outline_workarea(self, size, size)
    cr:translate(wa.x, wa.y)
    background_shape(cr, wa.width, wa.height)
    cr:set_line_width(border_width)

    if bg then
        cr:save()
        cr:set_source(color(bg))
        cr:fill_preserve()
        cr:restore()
    end

    cr:stroke()

    cr:translate(-wa.x, -wa.y)

    -- Draw the checked part
    if self._private.checked then
        local col = self:get_check_color() or main_color
        border_color = self:get_check_border_color()
        border_width = self:get_check_border_width() or 0
        local check_shape = self:get_check_shape() or background_shape

        wa = content_workarea(self, size, size)
        cr:translate(wa.x, wa.y)

        check_shape(cr, wa.width, wa.height)

        if col then
            cr:set_source(color(col))
        end

        if border_width > 0 then
            cr:fill_preserve()
            cr:set_line_width(border_width)
            cr:set_source(color(border_color))
            cr:stroke()
        else
            cr:fill()
        end
    end
end

local function fit(_, _, w, h)
    local size = math.min(w, h)
    return size, size
end

--- If the checkbox is checked.
-- @property checked
-- @param boolean

for _, prop in ipairs {"border_width", "bg", "border_color", "check_border_color",
    "check_border_width", "check_color", "shape", "check_shape", "paddings",
    "checked", "color" } do
    checkbox["set_"..prop] = function(self, value)
        self._private[prop] = value
        self:emit_signal("property::"..prop)
        self:emit_signal("widget::redraw_needed")
    end
    checkbox["get_"..prop] = function(self)
        return self._private[prop] or beautiful["checkbox_"..prop]
    end
end

--- The checkbox color.
-- @property color

function checkbox:set_paddings(val)
    self._private.paddings = type(val) == "number" and {
        left   = val,
        right  = val,
        top    = val,
        bottom = val,
    } or val or {}
    self:emit_signal("property::paddings")
    self:emit_signal("widget::redraw_needed")
end

local function new(checked, args)
    checked, args = checked or false, args or {}

    local ret = base.make_widget(nil, nil, {
        enable_properties = true,
    })

    gtable.crush(ret, checkbox)

    ret._private.checked = checked
    ret._private.color = args.color and color(args.color) or nil

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

return setmetatable({}, { __call = function(_, ...) return new(...) end})

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
