---------------------------------------------------------------------------
--
--
--
--![Usage example](../images/AUTOGEN_wibox_container_defaults_margin.svg)
--
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @classmod wibox.container.margin
---------------------------------------------------------------------------

local pairs = pairs
local setmetatable = setmetatable
local base = require("wibox.widget.base")
local gcolor = require("gears.color")
local cairo = require("lgi").cairo
local gtable = require("gears.table")

local margin = { mt = {} }

-- Draw a margin layout
function margin:draw(_, cr, width, height)
    local x = self._private.left
    local y = self._private.top
    local w = self._private.right
    local h = self._private.bottom
    local color = self._private.color

    if not self._private.widget or width <= x + w or height <= y + h then
        return
    end

    if color then
        cr:set_source(color)
        cr:rectangle(0, 0, width, height)
        cr:rectangle(x, y, width - x - w, height - y - h)
        cr:set_fill_rule(cairo.FillRule.EVEN_ODD)
        cr:fill()
    end
end

-- Layout a margin layout
function margin:layout(_, width, height)
    if self._private.widget then
        local x = self._private.left
        local y = self._private.top
        local w = self._private.right
        local h = self._private.bottom

        return { base.place_widget_at(self._private.widget, x, y, width - x - w, height - y - h) }
    end
end

-- Fit a margin layout into the given space
function margin:fit(context, width, height)
    local extra_w = self._private.left + self._private.right
    local extra_h = self._private.top + self._private.bottom
    local w, h = 0, 0
    if self._private.widget then
        w, h = base.fit_widget(self, context, self._private.widget, width - extra_w, height - extra_h)
    end

    if self._private.draw_empty == false and (w == 0 or h == 0) then
        return 0, 0
    end

    return w + extra_w, h + extra_h
end

--- The widget to be wrapped the the margins.
-- @property widget
-- @tparam widget widget The widget

function margin:set_widget(widget)
    if widget then
        base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

function margin:get_widget()
    return self._private.widget
end

-- Get the number of children element
-- @treturn table The children
function margin:get_children()
    return {self._private.widget}
end

-- Replace the layout children
-- This layout only accept one children, all others will be ignored
-- @tparam table children A table composed of valid widgets
function margin:set_children(children)
    self:set_widget(children[1])
end

--- Set all the margins to val.
-- @property margins
-- @tparam number val The margin value

function margin:set_margins(val)
    if self._private.left   == val and
       self._private.right  == val and
       self._private.top    == val and
       self._private.bottom == val then
        return
    end

    self._private.left = val
    self._private.right = val
    self._private.top = val
    self._private.bottom = val
    self:emit_signal("widget::layout_changed")
end

--- Set the margins color to create a border.
-- @property color
-- @param color A color used to fill the margin.

function margin:set_color(color)
    self._private.color = color and gcolor(color)
    self:emit_signal("widget::redraw_needed")
end

function margin:get_color()
    return self._private.color
end

--- Draw the margin even if the content size is 0x0 (default: true)
-- @function draw_empty
-- @tparam boolean draw_empty Draw nothing is content is 0x0 or draw the margin anyway

function margin:set_draw_empty(draw_empty)
    self._private.draw_empty = draw_empty
    self:emit_signal("widget::layout_changed")
end

function margin:get_draw_empty()
    return self._private.draw_empty
end

--- Reset this layout. The widget will be unreferenced, the margins set to 0
-- and the color erased
function margin:reset()
    self:set_widget(nil)
    self:set_margins(0)
    self:set_color(nil)
end

--- Set the left margin that this layout adds to its widget.
-- @param margin The new margin to use.
-- @property left

--- Set the right margin that this layout adds to its widget.
-- @param margin The new margin to use.
-- @property right

--- Set the top margin that this layout adds to its widget.
-- @param margin The new margin to use.
-- @property top

--- Set the bottom margin that this layout adds to its widget.
-- @param margin The new margin to use.
-- @property bottom

-- Create setters for each direction
for _, v in pairs({ "left", "right", "top", "bottom" }) do
    margin["set_" .. v] = function(layout, val)
        if layout._private[v] == val then return end
        layout._private[v] = val
        layout:emit_signal("widget::layout_changed")
    end

    margin["get_" .. v] = function(layout)
        return layout._private[v]
    end
end

--- Returns a new margin container.
-- @param[opt] widget A widget to use.
-- @param[opt] left A margin to use on the left side of the widget.
-- @param[opt] right A margin to use on the right side of the widget.
-- @param[opt] top A margin to use on the top side of the widget.
-- @param[opt] bottom A margin to use on the bottom side of the widget.
-- @param[opt] color A color for the margins.
-- @param[opt] draw_empty whether or not to draw the margin when the content is empty
-- @treturn table A new margin container
-- @function wibox.container.margin
local function new(widget, left, right, top, bottom, color, draw_empty)
    local ret = base.make_widget(nil, nil, {enable_properties = true})

    gtable.crush(ret, margin, true)

    ret:set_left(left or 0)
    ret:set_right(right or 0)
    ret:set_top(top or 0)
    ret:set_bottom(bottom or 0)
    ret:set_draw_empty(draw_empty)

    ret:set_color(color)

    if widget then
        ret:set_widget(widget)
    end

    return ret
end

function margin.mt:__call(...)
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

return setmetatable(margin, margin.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
