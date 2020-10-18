---------------------------------------------------------------------------
-- A stacked layout.
--
-- This layout display widgets on top of each other. It can be used to overlay
-- a `wibox.widget.textbox` on top of a `awful.widget.progressbar` or manage
-- "pages" where only one is visible at any given moment.
--
-- The indices are going from 1 (the bottom of the stack) up to the top of
-- the stack. The order can be changed either using `:swap` or `:raise`.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_defaults_stack.svg)
--
-- @usage
-- wibox.widget {
--     generic_widget( 'first'  ),
--     generic_widget( 'second' ),
--     generic_widget( 'third'  ),
--     layout  = wibox.layout.stack
-- }
-- @author Emmanuel Lepage Vallee
-- @copyright 2016 Emmanuel Lepage Vallee
-- @classmod wibox.layout.stack
---------------------------------------------------------------------------

local base  = require("wibox.widget.base" )
local fixed = require("wibox.layout.fixed")
local table = table
local pairs = pairs
local gtable  = require("gears.table")

local stack = {mt={}}

----- Set a widget at a specific index, replace the current one.
-- **Signal:** widget::replaced The argument is the new widget and the old one
-- and the index.
-- @tparam number index A widget or a widget index
-- @param widget2 The widget to take the place of the first one
-- @treturn boolean If the operation is successful
-- @name set
-- @class function

--- Replace the first instance of `widget` in the layout with `widget2`.
-- **Signal:** widget::replaced The argument is the new widget and the old one
-- and the index.
-- @param widget The widget to replace
-- @param widget2 The widget to replace `widget` with
-- @tparam[opt=false] boolean recursive Dig in all compatible layouts to find the widget.
-- @treturn boolean If the operation is successful
-- @name replace_widget
-- @class function

--- Swap 2 widgets in a layout.
-- **Signal:** widget::swapped The arguments are both widgets and both (new) indexes.
-- @tparam number index1 The first widget index
-- @tparam number index2 The second widget index
-- @treturn boolean If the operation is successful
-- @name swap
-- @class function

--- Swap 2 widgets in a layout.
-- If widget1 is present multiple time, only the first instance is swapped
-- **Signal:** widget::swapped The arguments are both widgets and both (new) indexes.
-- if the layouts not the same, then only `widget::replaced` will be emitted.
-- @param widget1 The first widget
-- @param widget2 The second widget
-- @tparam[opt=false] boolean recursive Dig in all compatible layouts to find the widget.
-- @treturn boolean If the operation is successful
-- @name swap_widgets
-- @class function

--- Get all direct children of this layout.
-- @param layout The layout you are modifying.
-- @property children

--- Reset a ratio layout. This removes all widgets from the layout.
-- **Signal:** widget::reset
-- @param layout The layout you are modifying.
-- @name reset
-- @class function

--- Add some widgets to the given stack layout
-- @param layout The layout you are modifying.
-- @tparam widget ... Widgets that should be added (must at least be one)
-- @name add
-- @class function

--- Remove a widget from the layout
-- @tparam index The widget index to remove
-- @treturn boolean index If the operation is successful
-- @name remove
-- @class function

--- Insert a new widget in the layout at position `index`
-- @tparam number index The position
-- @param widget The widget
-- @treturn boolean If the operation is successful
-- @name insert
-- @class function

--- Remove one or more widgets from the layout
-- The last parameter can be a boolean, forcing a recursive seach of the
-- widget(s) to remove.
-- @param widget ... Widgets that should be removed (must at least be one)
-- @treturn boolean If the operation is successful
-- @name remove_widgets
-- @class function

--- Add spacing around the widget, similar to the margin container.
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_stack_spacing.svg)
--
-- @usage
-- wibox.widget {
--     generic_widget( 'first'  ),
--     generic_widget( 'second' ),
--     generic_widget( 'third'  ),
--     spacing = 6,
--     layout  = wibox.layout.stack
-- }
-- @property spacing
-- @tparam number spacing Spacing between widgets.

function stack:layout(_, width, height)
    local result = {}
    local spacing = self._private.spacing

    width  = width  - math.abs(self._private.h_offset * #self._private.widgets) - 2*spacing
    height = height - math.abs(self._private.v_offset * #self._private.widgets) - 2*spacing

    local h_off, v_off = spacing, spacing

    for _, v in pairs(self._private.widgets) do
        table.insert(result, base.place_widget_at(v, h_off, v_off, width, height))
        h_off, v_off = h_off + self._private.h_offset, v_off + self._private.v_offset
        if self._private.top_only then break end
    end

    return result
end

function stack:fit(context, orig_width, orig_height)
    local max_w, max_h = 0,0
    local spacing = self._private.spacing

    for _, v in pairs(self._private.widgets) do
        local w, h = base.fit_widget(self, context, v, orig_width, orig_height)
        max_w, max_h = math.max(max_w, w+2*spacing), math.max(max_h, h+2*spacing)
    end

    return math.min(max_w, orig_width), math.min(max_h, orig_height)
end

--- If only the first stack widget is drawn
-- @property top_only

function stack:get_top_only()
    return self._private.top_only
end

function stack:set_top_only(top_only)
    self._private.top_only = top_only
end

--- Raise a widget at `index` to the top of the stack
-- @tparam number index the widget index to raise
function stack:raise(index)
    if (not index) or self._private.widgets[index] then return end

    local w = self._private.widgets[index]
    table.remove(self._private.widgets, index)
    table.insert(self._private.widgets, w)

    self:emit_signal("widget::layout_changed")
end

--- Raise the first instance of `widget`
-- @param widget The widget to raise
-- @tparam[opt=false] boolean recursive Also look deeper in the hierarchy to
--   find the widget
function stack:raise_widget(widget, recursive)
    local idx, layout = self:index(widget, recursive)

    if not idx or not layout then return end

    -- Bubble up in the stack until the right index is found
    while layout and layout ~= self do
        idx, layout = self:index(layout, recursive)
    end

    if layout == self and idx ~= 1 then
        self:raise(idx)
    end
end

--- Add an horizontal offset to each layers.
--
-- Note that this reduces the overall size of each widgets by the sum of all
-- layers offsets.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_stack_offset.svg)
--
-- @usage
-- wibox.widget {
--     generic_widget( 'first'  ),
--     generic_widget( 'second' ),
--     generic_widget( 'third'  ),
--     horizontal_offset = 5,
--     vertical_offset   = 5,
--     layout            = wibox.layout.stack
-- }
--
-- @property horizontal_offset
-- @param number

--- Add an vertical offset to each layers.
--
-- Note that this reduces the overall size of each widgets by the sum of all
-- layers offsets.
--
-- @property vertial_offset
-- @param number
-- @see horizontal_offset

function stack:set_horizontal_offset(value)
    self._private.h_offset = value
    self:emit_signal("widget::layout_changed")
end

function stack:set_vertical_offset(value)
    self._private.v_offset = value
    self:emit_signal("widget::layout_changed")
end

--- Create a new stack layout.
-- @function wibox.layout.stack
-- @treturn widget A new stack layout

local function new(...)
    local ret = fixed.horizontal(...)

    gtable.crush(ret, stack, true)

    ret._private.h_offset = 0
    ret._private.v_offset = 0

    return ret
end

function stack.mt:__call(_, ...)
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

return setmetatable(stack, stack.mt)
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
