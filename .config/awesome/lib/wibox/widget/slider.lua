---------------------------------------------------------------------------
-- An interactive mouse based slider widget.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_defaults_slider.svg)
--
-- @usage
-- wibox.widget {
--     bar_shape           = gears.shape.rounded_rect,
--     bar_height          = 3,
--     bar_color           = beautiful.border_color,
--     handle_color        = beautiful.bg_normal,
--     handle_shape        = gears.shape.circle,
--     handle_border_color = beautiful.border_color,
--     handle_border_width = 1,
--     value               = 25,
--     widget              = wibox.widget.slider,
-- }
--
-- @author Grigory Mishchenko &lt;grishkokot@gmail.com&gt;
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2015 Grigory Mishchenko, 2016 Emmanuel Lepage Vallee
-- @classmod wibox.widget.slider
---------------------------------------------------------------------------

local setmetatable = setmetatable
local type = type
local color = require("gears.color")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local base = require("wibox.widget.base")
local shape = require("gears.shape")
local capi = {
    mouse        = mouse,
    mousegrabber = mousegrabber,
    root         = root,
}

local slider = {mt={}}

--- The slider handle shape.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_handle_shape.svg)
--
--
-- @property handle_shape
-- @tparam[opt=gears shape rectangle] gears.shape shape
-- @see gears.shape

--- The slider handle color.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_handle_color.svg)
--
--
-- @property handle_color
-- @param color

--- The slider handle margins.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_handle_margins.svg)
--
--
-- @property handle_margins
-- @tparam[opt={}] table margins
-- @tparam[opt=0] number margins.left
-- @tparam[opt=0] number margins.right
-- @tparam[opt=0] number margins.top
-- @tparam[opt=0] number margins.bottom

--- The slider handle width.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_handle_width.svg)
--
--
-- @property handle_width
-- @param number

--- The handle border_color.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_handle_border.svg)
--
--
-- @property handle_border_color
-- @param color

--- The handle border width.
-- @property handle_border_width
-- @param[opt=0]  number

--- The bar (background) shape.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_bar_shape.svg)
--
--
-- @property bar_shape
-- @tparam[opt=gears shape rectangle] gears.shape shape
-- @see gears.shape

--- The bar (background) height.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_bar_height.svg)
--
--
-- @property bar_height
-- @param number

--- The bar (background) color.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_bar_color.svg)
--
--
-- @property bar_color
-- @param color

--- The bar (background) margins.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_bar_margins.svg)
--
--
-- @property bar_margins
-- @tparam[opt={}] table margins
-- @tparam[opt=0] number margins.left
-- @tparam[opt=0] number margins.right
-- @tparam[opt=0] number margins.top
-- @tparam[opt=0] number margins.bottom

--- The bar (background) border width.
-- @property bar_border_width
-- @param[opt=0] numbergb

--- The bar (background) border_color.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_bar_border.svg)
--
--
-- @property bar_border_color
-- @param color

--- The slider value.
--
-- **Signal:** *property::value* notify the value is changed.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_slider_value.svg)
--
--
-- @property value
-- @param[opt=0] number

--- The slider minimum value.
-- @property minimum
-- @param[opt=0] number

--- The slider maximum value.
-- @property maximum
-- @param[opt=100] number

--- The bar (background) border width.
-- @beautiful beautiful.slider_bar_border_width
-- @param number

--- The bar (background) border color.
-- @beautiful beautiful.slider_bar_border_color
-- @param color

--- The handle border_color.
-- @beautiful beautiful.slider_handle_border_color
-- @param color

--- The handle border width.
-- @beautiful beautiful.slider_handle_border_width
-- @param number

--- The handle .
-- @beautiful beautiful.slider_handle_width
-- @param number

-- @beautiful beautiful.slider_handle_color
-- @param color

--- The handle shape.
-- @beautiful beautiful.slider_handle_shape
-- @tparam[opt=gears shape rectangle] gears.shape shape
-- @see gears.shape

--- The bar (background) shape.
-- @beautiful beautiful.slider_bar_shape
-- @tparam[opt=gears shape rectangle] gears.shape shape
-- @see gears.shape

--- The bar (background) height.
-- @beautiful beautiful.slider_bar_height
-- @param number

--- The bar (background) margins.
-- @beautiful beautiful.slider_bar_margins
-- @tparam[opt={}] table margins
-- @tparam[opt=0] number margins.left
-- @tparam[opt=0] number margins.right
-- @tparam[opt=0] number margins.top
-- @tparam[opt=0] number margins.bottom

--- The slider handle margins.
-- @beautiful beautiful.slider_handle_margins
-- @tparam[opt={}] table margins
-- @tparam[opt=0] number margins.left
-- @tparam[opt=0] number margins.right
-- @tparam[opt=0] number margins.top
-- @tparam[opt=0] number margins.bottom

--- The bar (background) color.
-- @beautiful beautiful.slider_bar_color
-- @param color

local properties = {
    -- Handle
    handle_shape         = shape.rectangle,
    handle_color         = false,
    handle_margins       = {},
    handle_width         = false,
    handle_border_width  = 0,
    handle_border_color  = false,

    -- Bar
    bar_shape            = shape.rectangle,
    bar_height           = false,
    bar_color            = false,
    bar_margins          = {},
    bar_border_width     = 0,
    bar_border_color     = false,

    -- Content
    value                = 0,
    minimum              = 0,
    maximum              = 100,
}

-- Create the accessors
for prop in pairs(properties) do
    slider["set_"..prop] = function(self, value)
        local changed = self._private[prop] ~= value
        self._private[prop] = value

        if changed then
            self:emit_signal("property::"..prop)
            self:emit_signal("widget::redraw_needed")
        end
    end

    slider["get_"..prop] = function(self)
        -- Ignoring the false's is on purpose
        return self._private[prop] == nil
            and properties[prop]
            or self._private[prop]
    end
end

-- Add some validation to set_value
function slider:set_value(value)
    value = math.min(value, self:get_maximum())
    value = math.max(value, self:get_minimum())
    local changed = self._private.value ~= value

    self._private.value = value

    if changed then
        self:emit_signal( "property::value"       )
        self:emit_signal( "widget::redraw_needed" )
    end
end

local function get_extremums(self)
    local min = self._private.minimum or properties.minimum
    local max = self._private.maximum or properties.maximum
    local interval = max - min

    return min, max, interval
end

function slider:draw(_, cr, width, height)
    local bar_height = self._private.bar_height

    -- If there is no background, then skip this
    local bar_color = self._private.bar_color
        or beautiful.slider_bar_color

    if bar_color then
        cr:set_source(color(bar_color))
    end

    local margins = self._private.bar_margins
        or beautiful.slider_bar_margins

    local x_offset, right_margin, y_offset = 0, 0

    if margins then
        if type(margins) == "number" then
            bar_height = bar_height or (height - 2*margins)
            x_offset, y_offset = margins, margins
            right_margin = margins
        else
            bar_height = bar_height or (
                height - (margins.top or 0) - (margins.bottom or 0)
            )
            x_offset, y_offset = margins.left or 0, margins.top or 0
            right_margin = margins.right or 0
        end
    else
        bar_height = bar_height or beautiful.slider_bar_height or height
        y_offset   = (height - bar_height)/2
    end


    cr:translate(x_offset, y_offset)

    local bar_shape = self._private.bar_shape
        or beautiful.slider_bar_shape
        or properties.bar_shape

    local bar_border_width = self._private.bar_border_width
        or beautiful.slider_bar_border_width
        or properties.bar_border_width

    bar_shape(cr, width - x_offset - right_margin, bar_height or height)

    if bar_color then
        if bar_border_width == 0 then
            cr:fill()
        else
            cr:fill_preserve()
        end
    end

    -- Draw the bar border
    if bar_border_width > 0 then
        local bar_border_color = self._private.bar_border_color
            or beautiful.slider_bar_border_color
            or properties.bar_border_color

        cr:set_line_width(bar_border_width)

        if bar_border_color then
            cr:save()
            cr:set_source(color(bar_border_color))
            cr:stroke()
            cr:restore()
        else
            cr:stroke()
        end
    end

    cr:translate(-x_offset, -y_offset)

    -- Paint the handle
    local handle_color = self._private.handle_color
        or beautiful.slider_handle_color

    -- It is ok if there is no color, it will be inherited
    if handle_color then
        cr:set_source(color(handle_color))
    end

    local handle_height, handle_width = height, self._private.handle_width
        or beautiful.slider_handle_width
        or height/2

    local handle_shape = self._private.handle_shape
        or beautiful.slider_handle_shape
        or properties.handle_shape

    -- Lets get the margins for the handle
    margins = self._private.handle_margins
        or beautiful.slider_handle_margins

    x_offset, y_offset = 0, 0

    if margins then
        if type(margins) == "number" then
            x_offset, y_offset = margins, margins
            handle_width  = handle_width  - 2*margins
            handle_height = handle_height - 2*margins
        else
            x_offset, y_offset = margins.left or 0, margins.top or 0
            handle_width  = handle_width  -
                (margins.left or 0) - (margins.right  or 0)
            handle_height = handle_height -
                (margins.top  or 0) - (margins.bottom or 0)
        end
    end

    local value = self._private.value or self._private.min or 0

    -- Get the widget size back to it's non-transfored value
    local min, _, interval = get_extremums(self)
    local rel_value = ((value-min)/interval) * (width-handle_width)

    cr:translate(x_offset + rel_value, y_offset)

    local handle_border_width = self._private.handle_border_width
        or beautiful.slider_handle_border_width
        or properties.handle_border_width or 0

    handle_shape(cr, handle_width, handle_height)

    if handle_border_width > 0 then
        cr:fill_preserve()
    else
        cr:fill()
    end

    -- Draw the handle border
    if handle_border_width > 0 then
        local handle_border_color = self._private.handle_border_color
            or beautiful.slider_handle_border_color
            or properties.handle_border_color

        if handle_border_color then
            cr:set_source(color(handle_border_color))
        end

        cr:set_line_width(handle_border_width)
        cr:stroke()
    end
end

function slider:fit(_, width, height)
    -- Use all the space, this should be used with a constraint widget
    return width, height
end

-- Move the handle to the correct location
local function move_handle(self, width, x, _)
    local _, _, interval = get_extremums(self)
    self:set_value(math.floor((x*interval)/width))
end

local function mouse_press(self, x, y, button_id, _, geo)
    if button_id ~= 1 then return end

    local matrix_from_device = geo.hierarchy:get_matrix_from_device()

    -- Sigh. geo.width/geo.height is in device space. We need it in our own
    -- coordinate system
    local width = geo.widget_width

    move_handle(self, width, x, y)

    -- Calculate a matrix transforming from screen coordinates into widget coordinates
    local wgeo = geo.drawable.drawable:geometry()
    local matrix = matrix_from_device:translate(-wgeo.x, -wgeo.y)

    capi.mousegrabber.run(function(mouse)
        if not mouse.buttons[1] then
            return false
        end

        -- Calculate the point relative to the widget
        move_handle(self, width, matrix:transform_point(mouse.x, mouse.y))

        return true
    end,"fleur")
end

--- Create a slider widget.
-- @tparam[opt={}] table args
-- @function wibox.widget.slider
local function new(args)
    local ret = base.make_widget(nil, nil, {
        enable_properties = true,
    })

    gtable.crush(ret._private, args or {})

    gtable.crush(ret, slider, true)

    ret:connect_signal("button::press", mouse_press)

    return ret
end

function slider.mt:__call(_, ...)
    return new(...)
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

return setmetatable(slider, slider.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
