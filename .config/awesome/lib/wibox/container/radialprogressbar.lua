---------------------------------------------------------------------------
--
-- A circular progressbar wrapper.
--
-- If no child `widget` is set, then the radialprogressbar will take all the
-- available size. Use a `wibox.container.constraint` to prevent this.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_container_defaults_radialprogressbar.svg)
--
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2013 Emmanuel Lepage Vallee
-- @classmod wibox.container.radialprogressbar
---------------------------------------------------------------------------

local setmetatable = setmetatable
local base      = require("wibox.widget.base")
local shape     = require("gears.shape"      )
local gtable    = require( "gears.table"     )
local color     = require( "gears.color"     )
local beautiful = require("beautiful"        )

local default_outline_width  = 2

local radialprogressbar = { mt = {} }

--- The progressbar border background color.
-- @beautiful beautiful.radialprogressbar_border_color

--- The progressbar foreground color.
-- @beautiful beautiful.radialprogressbar_color

--- The progressbar border width.
-- @beautiful beautiful.radialprogressbar_border_width

--- The padding between the outline and the progressbar.
-- @beautiful beautiful.radialprogressbar_paddings
-- @tparam[opt=0] table|number paddings A number or a table
-- @tparam[opt=0] number paddings.top
-- @tparam[opt=0] number paddings.bottom
-- @tparam[opt=0] number paddings.left
-- @tparam[opt=0] number paddings.right

local function outline_workarea(self, width, height)
    local border_width = self._private.border_width or
        beautiful.radialprogressbar_border_width or default_outline_width

    local x, y = 0, 0

    -- Make sure the border fit in the clip area
    local offset = border_width/2
    x, y = x + offset, y+offset
    width, height = width-2*offset, height-2*offset

    return {x=x, y=y, width=width, height=height}, offset
end

-- The child widget area
local function content_workarea(self, width, height)
    local padding = self._private.paddings or {}
    local wa = outline_workarea(self, width, height)

    wa.x      = wa.x + (padding.left or 0)
    wa.y      = wa.y + (padding.top  or 0)
    wa.width  = wa.width  - (padding.left or 0) - (padding.right  or 0)
    wa.height = wa.height - (padding.top  or 0) - (padding.bottom or 0)

    return wa
end

-- Draw the radial outline and progress
function radialprogressbar:after_draw_children(_, cr, width, height)
    cr:restore()

    local border_width = self._private.border_width or
        beautiful.radialprogressbar_border_width or default_outline_width

    local wa = outline_workarea(self, width, height)
    cr:translate(wa.x, wa.y)

    -- Draw the outline
    shape.rounded_bar(cr, wa.width, wa.height)
    cr:set_source(color(self:get_border_color() or "#0000ff"))
    cr:set_line_width(border_width)
    cr:stroke()

    -- Draw the progress
    cr:set_source(color(self:get_color() or "#ff00ff"))
    shape.radial_progress(cr,  wa.width, wa.height, self._percent or 0)
    cr:set_line_width(border_width)
    cr:stroke()

end

-- Set the clip
function radialprogressbar:before_draw_children(_, cr, width, height)
    cr:save()
    local wa = content_workarea(self, width, height)
    cr:translate(wa.x, wa.y)
    shape.rounded_bar(cr, wa.width, wa.height)
    cr:clip()
    cr:translate(-wa.x, -wa.y)
end

-- Layout this layout
function radialprogressbar:layout(_, width, height)
    if self._private.widget then
        local wa = content_workarea(self, width, height)

        return { base.place_widget_at(
            self._private.widget, wa.x, wa.y, wa.width, wa.height
        ) }
    end
end

-- Fit this layout into the given area
function radialprogressbar:fit(context, width, height)
    if self._private.widget then
        local wa = content_workarea(self, width, height)
        local w, h = base.fit_widget(self, context, self._private.widget, wa.width, wa.height)
        return wa.x + w, wa.y + h
    end

    return width, height
end

--- The widget to wrap in a radial proggressbar.
-- @property widget
-- @tparam widget widget The widget

function radialprogressbar:set_widget(widget)
    if widget then
        base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

--- Get the children elements
-- @treturn table The children
function radialprogressbar:get_children()
    return {self._private.widget}
end

--- Replace the layout children
-- This layout only accept one children, all others will be ignored
-- @tparam table children A table composed of valid widgets
function radialprogressbar:set_children(children)
    self._private.widget = children and children[1]
    self:emit_signal("widget::layout_changed")
end

--- Reset this container.
function radialprogressbar:reset()
    self:set_widget(nil)
end

for _,v in ipairs {"left", "right", "top", "bottom"} do
    radialprogressbar["set_"..v.."_padding"] = function(self, val)
        self._private.paddings = self._private.paddings or {}
        self._private.paddings[v] = val
        self:emit_signal("widget::redraw_needed")
        self:emit_signal("widget::layout_changed")
    end
end

--- The padding between the outline and the progressbar.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_radialprogressbar_padding.svg)
--
-- @property paddings
-- @tparam[opt=0] table|number paddings A number or a table
-- @tparam[opt=0] number paddings.top
-- @tparam[opt=0] number paddings.bottom
-- @tparam[opt=0] number paddings.left
-- @tparam[opt=0] number paddings.right

--- The progressbar value.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_radialprogressbar_value.svg)
--
-- @property value
-- @tparam number value Between min_value and max_value

function radialprogressbar:set_value(val)
    if not val then self._percent = 0; return end

    if val > self._private.max_value then
        self:set_max_value(val)
    elseif val < self._private.min_value then
        self:set_min_value(val)
    end

    local delta = self._private.max_value - self._private.min_value

    self._percent = val/delta
    self:emit_signal("widget::redraw_needed")
end

--- The border background color.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_radialprogressbar_border_color.svg)
--
-- @property border_color

--- The border foreground color.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_radialprogressbar_color.svg)
--
-- @property color

--- The border width.
--
--
--![Usage example](../images/AUTOGEN_wibox_container_radialprogressbar_border_width.svg)
--
-- @property border_width
-- @tparam[opt=3] number border_width

--- The minimum value.
-- @property min_value

--- The maximum value.
-- @property max_value

for _, prop in ipairs {"max_value", "min_value", "border_color", "color",
    "border_width", "paddings"} do
    radialprogressbar["set_"..prop] = function(self, value)
        self._private[prop] = value
        self:emit_signal("property::"..prop)
        self:emit_signal("widget::redraw_needed")
    end
    radialprogressbar["get_"..prop] = function(self)
        return self._private[prop] or beautiful["radialprogressbar_"..prop]
    end
end

function radialprogressbar:set_paddings(val)
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

--- Returns a new radialprogressbar layout. A radialprogressbar layout
-- radialprogressbars a given widget. Use `.widget` to set the widget.
-- @param[opt] widget The widget to display.
-- @function wibox.container.radialprogressbar
local function new(widget)
    local ret = base.make_widget(nil, nil, {
        enable_properties = true,
    })

    gtable.crush(ret, radialprogressbar)
    ret._private.max_value = 1
    ret._private.min_value = 0

    ret:set_widget(widget)

    return ret
end

function radialprogressbar.mt:__call(_, ...)
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

return setmetatable(radialprogressbar, radialprogressbar.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
