---------------------------------------------------------------------------
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_defaults_flex.svg)
--
-- @usage
-- wibox.widget {
--     generic_widget( 'first'  ),
--     generic_widget( 'second' ),
--     generic_widget( 'third'  ),
--     layout  = wibox.layout.flex.horizontal
-- }
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @classmod wibox.layout.flex
---------------------------------------------------------------------------

local base = require("wibox.widget.base")
local fixed = require("wibox.layout.fixed")
local table = table
local pairs = pairs
local gmath = require("gears.math")
local gtable = require("gears.table")

local flex = {}

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

--- Replace the layout children
-- @tparam table children A table composed of valid widgets
-- @name set_children
-- @class function

--- Add some widgets to the given fixed layout
-- @param layout The layout you are modifying.
-- @tparam widget ... Widgets that should be added (must at least be one)
-- @name add
-- @class function

--- Remove a widget from the layout
-- @tparam index The widget index to remove
-- @treturn boolean index If the operation is successful
-- @name remove
-- @class function

--- Remove one or more widgets from the layout
-- The last parameter can be a boolean, forcing a recursive seach of the
-- widget(s) to remove.
-- @param widget ... Widgets that should be removed (must at least be one)
-- @treturn boolean If the operation is successful
-- @name remove_widgets
-- @class function

--- Insert a new widget in the layout at position `index`
-- @tparam number index The position
-- @param widget The widget
-- @treturn boolean If the operation is successful
-- @name insert
-- @class function

--- The widget used to fill the spacing between the layout elements.
--
-- By default, no widget is used.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_flex_spacing_widget.svg)
--
-- @usage
-- -- Use the separator widget directly
-- local w1 = wibox.widget {
--     spacing        = 10,
--     spacing_widget = wibox.widget.separator,
--     layout         = wibox.layout.flex.horizontal
-- }
-- -- Use a standard declarative widget construct
-- local w2 = wibox.widget {
--     spacing = 10,
--     spacing_widget = {
--         color  = '#00ff00',
--         shape  = gears.shape.circle,
--         widget = wibox.widget.separator,
--     },
--     layout = wibox.layout.flex.horizontal
-- }
-- -- Use composed widgets
-- local w3 = wibox.widget {
--     spacing = 10,
--     spacing_widget = {
--         {
--             text = 'F',
--             widget = wibox.widget.textbox,
--         },
--         bg     = '#ff0000',
--         widget = wibox.container.background,
--     },
--     layout = wibox.layout.flex.horizontal
-- }
-- -- Use negative spacing to create a powerline effect
-- local w4 = wibox.widget {
--     spacing = -12,
--     spacing_widget = {
--         color  = '#ff0000',
--         shape  = gears.shape.powerline,
--         widget = wibox.widget.separator,
--     },
--     layout = wibox.layout.flex.horizontal
-- }
--
-- @property spacing_widget
-- @param widget

--- Add spacing between each layout widgets.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_flex_spacing.svg)
--
-- @usage
-- for i=1, 5 do
--     local w = wibox.widget {
--         first,
--         second,
--         third,
--         spacing = i*5,
--         layout  = wibox.layout.flex.horizontal
--     }
-- end
--
-- @property spacing
-- @tparam number spacing Spacing between widgets.

function flex:layout(_, width, height)
    local result = {}
    local spacing = self._private.spacing
    local num = #self._private.widgets
    local total_spacing = (spacing*(num-1))
    local spacing_widget = self._private.spacing_widget
    local abspace = math.abs(spacing)
    local spoffset = spacing < 0 and 0 or spacing
    local is_y = self._private.dir == "y"
    local is_x = not is_y

    local space_per_item
    if is_y then
        space_per_item = height / num - total_spacing/num
    else
        space_per_item = width / num - total_spacing/num
    end

    if self._private.max_widget_size then
        space_per_item = math.min(space_per_item, self._private.max_widget_size)
    end

    local pos, pos_rounded = 0, 0
    for k, v in pairs(self._private.widgets) do
        local x, y, w, h

        local next_pos = pos + space_per_item
        local next_pos_rounded = gmath.round(next_pos)

        if is_y then
            x, y = 0, pos_rounded
            w, h = width, next_pos_rounded - pos_rounded
        else
            x, y = pos_rounded, 0
            w, h = next_pos_rounded - pos_rounded, height
        end

        pos = next_pos + spacing
        pos_rounded = next_pos_rounded + spacing

        table.insert(result, base.place_widget_at(v, x, y, w, h))

        if k > 1 and spacing ~= 0 and spacing_widget then
            table.insert(result, base.place_widget_at(
                spacing_widget, is_x and (x - spoffset) or x, is_y and (y - spoffset) or y,
                is_x and abspace or w, is_y and abspace or h
            ))
        end
    end

    return result
end

-- Fit the flex layout into the given space.
-- @param context The context in which we are fit.
-- @param orig_width The available width.
-- @param orig_height The available height.
function flex:fit(context, orig_width, orig_height)
    local used_in_dir = 0
    local used_in_other = 0

    -- Figure out the maximum size we can give out to sub-widgets
    local sub_height = self._private.dir == "x" and orig_height or orig_height / #self._private.widgets
    local sub_width  = self._private.dir == "y" and orig_width  or orig_width / #self._private.widgets

    for _, v in pairs(self._private.widgets) do
        local w, h = base.fit_widget(self, context, v, sub_width, sub_height)

        local max = self._private.dir == "y" and w or h
        if max > used_in_other then
            used_in_other = max
        end

        used_in_dir = used_in_dir + (self._private.dir == "y" and h or w)
    end

    if self._private.max_widget_size then
        used_in_dir = math.min(used_in_dir,
            #self._private.widgets * self._private.max_widget_size)
    end

    local spacing = self._private.spacing * (#self._private.widgets-1)

    if self._private.dir == "y" then
        return used_in_other, used_in_dir + spacing
    end
    return used_in_dir + spacing, used_in_other
end

--- Set the maximum size the widgets in this layout will take.
--That is, maximum width for horizontal and maximum height for vertical.
-- @property max_widget_size
-- @param number

function flex:set_max_widget_size(val)
    if self._private.max_widget_size ~= val then
        self._private.max_widget_size = val
        self:emit_signal("widget::layout_changed")
    end
end

local function get_layout(dir, widget1, ...)
    local ret = fixed[dir](widget1, ...)

    gtable.crush(ret, flex, true)

    ret._private.fill_space = nil

    return ret
end

--- Returns a new horizontal flex layout. A flex layout shares the available space
-- equally among all widgets. Widgets can be added via :add(widget).
-- @tparam widget ... Widgets that should be added to the layout.
-- @function wibox.layout.flex.horizontal
function flex.horizontal(...)
    return get_layout("horizontal", ...)
end

--- Returns a new vertical flex layout. A flex layout shares the available space
-- equally among all widgets. Widgets can be added via :add(widget).
-- @tparam widget ... Widgets that should be added to the layout.
-- @function wibox.layout.flex.vertical
function flex.vertical(...)
    return get_layout("vertical", ...)
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

return flex

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
