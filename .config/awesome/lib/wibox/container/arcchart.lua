---------------------------------------------------------------------------
--
-- A circular chart (arc chart).
--
-- It can contain a central widget (or not) and display multiple values.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_container_defaults_arcchart.svg)
--
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2013 Emmanuel Lepage Vallee
-- @classmod wibox.container.arcchart
---------------------------------------------------------------------------

local setmetatable = setmetatable
local base      = require("wibox.widget.base")
local shape     = require("gears.shape"      )
local gtable    = require( "gears.table"     )
local color     = require( "gears.color"     )
local beautiful = require("beautiful"        )


local arcchart = { mt = {} }

--- The progressbar border background color.
-- @beautiful beautiful.arcchart_border_color

--- The progressbar foreground color.
-- @beautiful beautiful.arcchart_color

--- The progressbar border width.
-- @beautiful beautiful.arcchart_border_width

--- The padding between the outline and the progressbar.
-- @beautiful beautiful.arcchart_paddings
-- @tparam[opt=0] table|number paddings A number or a table
-- @tparam[opt=0] number paddings.top
-- @tparam[opt=0] number paddings.bottom
-- @tparam[opt=0] number paddings.left
-- @tparam[opt=0] number paddings.right

--- The arc thickness.
-- @beautiful beautiful.arcchart_thickness
-- @param number

local function outline_workarea(width, height)
    local x, y = 0, 0
    local size = math.min(width, height)

    return {x=x+(width-size)/2, y=y+(height-size)/2, width=size, height=size}
end

-- The child widget area
local function content_workarea(self, width, height)
    local padding = self._private.paddings or {}
    local border_width = self:get_border_width() or 0
    local wa = outline_workarea(width, height)
    local thickness = math.max(border_width, self:get_thickness() or 5)

    wa.x      = wa.x + (padding.left or 0) + thickness + 2*border_width
    wa.y      = wa.y + (padding.top  or 0) + thickness + 2*border_width
    wa.width  = wa.width  - (padding.left or 0) - (padding.right  or 0)
        - 2*thickness - 4*border_width
    wa.height = wa.height - (padding.top  or 0) - (padding.bottom or 0)
        - 2*thickness - 4*border_width

    return wa
end

-- Draw the radial outline and progress
function arcchart:after_draw_children(_, cr, width, height)
    cr:restore()

    local values  = self:get_values() or {}
    local border_width = self:get_border_width() or 0
    local thickness = math.max(border_width, self:get_thickness() or 5)

    local offset = thickness + 2*border_width

    -- Draw a circular background
    local bg = self:get_bg()
    if bg then
        cr:save()
        cr:translate(offset/2, offset/2)
        shape.circle(
            cr,
            width-offset,
            height-offset
        )
        cr:set_line_width(thickness+2*border_width)
        cr:set_source(color(bg))
        cr:stroke()
        cr:restore()
    end

    if #values == 0 then
        return
    end

    local wa = outline_workarea(width, height)
    cr:translate(wa.x+border_width/2, wa.y+border_width/2)


    -- Get the min and max value
    --local min_val = self:get_min_value() or 0 --TODO support min_values
    local max_val = self:get_max_value()
    local sum = 0

    for _, v in ipairs(values) do
        sum = sum + v
    end

    if not max_val then
        max_val = sum
    end

    max_val = math.max(max_val, sum)

    local use_rounded_edges = sum ~= max_val and self:get_rounded_edge()

    -- Fallback to the current foreground color
    local colors = self:get_colors() or {}

    -- Draw the outline
    local offset_angle = self:get_start_angle() or math.pi
    local start_angle, end_angle = offset_angle, offset_angle

    for k, v in ipairs(values) do
        end_angle = start_angle + (v*2*math.pi) / max_val

        if colors[k] then
            cr:set_source(color(colors[k]))
        end

        shape.arc(cr, wa.width-border_width, wa.height-border_width,
            thickness+border_width, math.pi-end_angle, math.pi-start_angle,
            (use_rounded_edges and k == #values), (use_rounded_edges and k == 1)
        )

        cr:fill()
        start_angle = end_angle
    end

    if border_width > 0 then
        local border_color = self:get_border_color()

        cr:set_source(color(border_color))
        cr:set_line_width(border_width)

        shape.arc(cr, wa.width-border_width, wa.height-border_width,
            thickness+border_width, math.pi-end_angle, math.pi-offset_angle,
            use_rounded_edges, use_rounded_edges
        )
        cr:stroke()
    end

end

-- Set the clip
function arcchart:before_draw_children(_, cr, width, height)
    cr:save()
    local wa = content_workarea(self, width, height)
    cr:translate(wa.x, wa.y)
    shape.circle(
        cr,
        wa.width,
        wa.height
    )
    cr:clip()
    cr:translate(-wa.x, -wa.y)
end

-- Layout this layout
function arcchart:layout(_, width, height)
    if self._private.widget then
        local wa = content_workarea(self, width, height)

        return { base.place_widget_at(
            self._private.widget, wa.x, wa.y, wa.width, wa.height
        ) }
    end
end

-- Fit this layout into the given area
function arcchart:fit(_, width, height)
    local size = math.min(width, height)
    return size, size
end

--- The widget to wrap in a radial proggressbar.
-- @property widget
-- @tparam widget widget The widget

function arcchart:set_widget(widget)
    if widget then
        base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

--- Get the children elements.
-- @treturn table The children
function arcchart:get_children()
    return {self._private.widget}
end

--- Replace the layout children
-- This layout only accept one children, all others will be ignored
-- @tparam table children A table composed of valid widgets
function arcchart:set_children(children)
    self._private.widget = children and children[1]
    self:emit_signal("widget::layout_changed")
end

--- Reset this layout. The widget will be removed and the rotation reset.
function arcchart:reset()
    self:set_widget(nil)
end

for _,v in ipairs {"left", "right", "top", "bottom"} do
    arcchart["set_"..v.."_padding"] = function(self, val)
        self._private.paddings = self._private.paddings or {}
        self._private.paddings[v] = val
        self:emit_signal("widget::redraw_needed")
        self:emit_signal("widget::layout_changed")
    end
end

--- The padding between the outline and the progressbar.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_paddings.svg)
--
-- @property paddings
-- @tparam[opt=0] table|number paddings A number or a table
-- @tparam[opt=0] number paddings.top
-- @tparam[opt=0] number paddings.bottom
-- @tparam[opt=0] number paddings.left
-- @tparam[opt=0] number paddings.right

--- The border background color.
--
-- @property border_color

--- The arcchart values foreground colors.
--
-- @property colors
-- @tparam table values An ordered set of colors for each value in arcchart.

--- The border width.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_border_width.svg)
--
-- @property border_width
-- @tparam[opt=3] number border_width

--- The minimum value.
-- @property min_value

--- The maximum value.
-- @property max_value

--- The radial background.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_bg.svg)
--
-- @property bg
-- @param color
-- @see gears.color

--- The value.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_value.svg)
--
-- @property value
-- @tparam number value Between min_value and max_value
-- @see values

--- The values.
-- The arcchart is designed to display multiple values at once. Each will be
-- shown in table order.
--
-- @property values
-- @tparam table values An ordered set of values.
-- @see value

--- If the chart has rounded edges.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_rounded_edge.svg)
--
-- @property rounded_edge
-- @param[opt=false] boolean

--- The arc thickness.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_thickness.svg)
--
-- @property thickness
-- @param number

--- The (radiant) angle where the first value start.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_arcchart_start_angle.svg)
--
-- @property start_angle
-- @param[opt=math.pi] number A number between 0 and 2*math.pi

for _, prop in ipairs {"border_width", "border_color", "paddings", "colors",
    "rounded_edge", "bg", "thickness", "values", "min_value", "max_value",
    "start_angle" } do
    arcchart["set_"..prop] = function(self, value)
        self._private[prop] = value
        self:emit_signal("property::"..prop)
        self:emit_signal("widget::redraw_needed")
    end
    arcchart["get_"..prop] = function(self)
        return self._private[prop] or beautiful["arcchart_"..prop]
    end
end

function arcchart:set_paddings(val)
    self._private.paddings = type(val) == "number" and {
        left   = val,
        right  = val,
        top    = val,
        bottom = val,
    } or val or {}
    self:emit_signal("property::paddings")
    self:emit_signal("widget::redraw_needed")
    self:emit_signal("widget::layout_changed")
end

function arcchart:set_value(value)
    self:set_values {value}
end

--- Returns a new arcchart layout.
-- @param[opt] widget The widget to display.
-- @function wibox.container.arcchart
local function new(widget)
    local ret = base.make_widget(nil, nil, {
        enable_properties = true,
    })

    gtable.crush(ret, arcchart)

    ret:set_widget(widget)

    return ret
end

function arcchart.mt:__call(...)
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

return setmetatable(arcchart, arcchart.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
