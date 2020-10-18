---------------------------------------------------------------------------
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_defaults_fixed.svg)
--
-- @usage
-- wibox.widget {
--     generic_widget( 'first'  ),
--     generic_widget( 'second' ),
--     generic_widget( 'third'  ),
--     layout  = wibox.layout.fixed.horizontal
-- }
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @classmod wibox.layout.fixed
---------------------------------------------------------------------------

local unpack = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)
local base  = require("wibox.widget.base")
local table = table
local pairs = pairs
local gtable = require("gears.table")

local fixed = {}

-- Layout a fixed layout. Each widget gets just the space it asks for.
-- @param context The context in which we are drawn.
-- @param width The available width.
-- @param height The available height.
function fixed:layout(context, width, height)
    local result = {}
    local pos,spacing = 0, self._private.spacing
    local spacing_widget = self._private.spacing_widget
    local is_y = self._private.dir == "y"
    local is_x = not is_y
    local abspace = math.abs(spacing)
    local spoffset = spacing < 0 and 0 or spacing

    for k, v in pairs(self._private.widgets) do
        local x, y, w, h, _
        if is_y then
            x, y = 0, pos
            w, h = width, height - pos
            if k ~= #self._private.widgets or not self._private.fill_space then
                _, h = base.fit_widget(self, context, v, w, h);
            end
            pos = pos + h + spacing
        else
            x, y = pos, 0
            w, h = width - pos, height
            if k ~= #self._private.widgets or not self._private.fill_space then
                w, _ = base.fit_widget(self, context, v, w, h);
            end
            pos = pos + w + spacing
        end

        if (is_y and pos-spacing > height) or
            (is_x and pos-spacing > width) then
            break
        end

        -- Add the spacing widget
        if k > 1 and abspace > 0 and spacing_widget then
            table.insert(result, base.place_widget_at(
                spacing_widget, is_x and (x - spoffset) or x, is_y and (y - spoffset) or y,
                is_x and abspace or w, is_y and abspace or h
            ))
        end
        table.insert(result, base.place_widget_at(v, x, y, w, h))
    end
    return result
end

--- Add some widgets to the given fixed layout
-- @param ... Widgets that should be added (must at least be one)
function fixed:add(...)
    -- No table.pack in Lua 5.1 :-(
    local args = { n=select('#', ...), ... }
    assert(args.n > 0, "need at least one widget to add")
    for i=1, args.n do
        base.check_widget(args[i])
        table.insert(self._private.widgets, args[i])
    end
    self:emit_signal("widget::layout_changed")
end


--- Remove a widget from the layout
-- @tparam number index The widget index to remove
-- @treturn boolean index If the operation is successful
function fixed:remove(index)
    if not index or index < 1 or index > #self._private.widgets then return false end

    table.remove(self._private.widgets, index)

    self:emit_signal("widget::layout_changed")

    return true
end

--- Remove one or more widgets from the layout
-- The last parameter can be a boolean, forcing a recursive seach of the
-- widget(s) to remove.
-- @param widget ... Widgets that should be removed (must at least be one)
-- @treturn boolean If the operation is successful
function fixed:remove_widgets(...)
    local args = { ... }

    local recursive = type(args[#args]) == "boolean" and args[#args]

    local ret = true
    for k, rem_widget in ipairs(args) do
        if recursive and k == #args then break end

        local idx, l = self:index(rem_widget, recursive)

        if idx and l and l.remove then
            l:remove(idx, false)
        else
            ret = false
        end

    end

    return #args > (recursive and 1 or 0) and ret
end

function fixed:get_children()
    return self._private.widgets
end

function fixed:set_children(children)
    self:reset()
    if #children > 0 then
        self:add(unpack(children))
    end
end

--- Replace the first instance of `widget` in the layout with `widget2`
-- @param widget The widget to replace
-- @param widget2 The widget to replace `widget` with
-- @tparam[opt=false] boolean recursive Digg in all compatible layouts to find the widget.
-- @treturn boolean If the operation is successful
function fixed:replace_widget(widget, widget2, recursive)
    local idx, l = self:index(widget, recursive)

    if idx and l then
        l:set(idx, widget2)
        return true
    end

    return false
end

function fixed:swap(index1, index2)
    if not index1 or not index2 or index1 > #self._private.widgets
        or index2 > #self._private.widgets then
        return false
    end

    local widget1, widget2 = self._private.widgets[index1], self._private.widgets[index2]

    self:set(index1, widget2)
    self:set(index2, widget1)

    self:emit_signal("widget::swapped", widget1, widget2, index2, index1)

    return true
end

function fixed:swap_widgets(widget1, widget2, recursive)
    base.check_widget(widget1)
    base.check_widget(widget2)

    local idx1, l1 = self:index(widget1, recursive)
    local idx2, l2 = self:index(widget2, recursive)

    if idx1 and l1 and idx2 and l2 and (l1.set or l1.set_widget) and (l2.set or l2.set_widget) then
        if l1.set then
            l1:set(idx1, widget2)
            if l1 == self then
                self:emit_signal("widget::swapped", widget1, widget2, idx2, idx1)
            end
        elseif l1.set_widget then
            l1:set_widget(widget2)
        end
        if l2.set then
            l2:set(idx2, widget1)
            if l2 == self then
                self:emit_signal("widget::swapped", widget1, widget2, idx2, idx1)
            end
        elseif l2.set_widget then
            l2:set_widget(widget1)
        end

        return true
    end

    return false
end

function fixed:set(index, widget2)
    if (not widget2) or (not self._private.widgets[index]) then return false end

    base.check_widget(widget2)

    local w = self._private.widgets[index]

    self._private.widgets[index] = widget2

    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::replaced", widget2, w, index)

    return true
end

--- The widget used to fill the spacing between the layout elements.
--
-- By default, no widget is used.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_fixed_spacing_widget.svg)
--
-- @usage
-- -- Use the separator widget directly
-- local w1 = wibox.widget {
--     spacing        = 10,
--     spacing_widget = wibox.widget.separator,
--     layout         = wibox.layout.fixed.horizontal
-- }
-- -- Use a standard declarative widget construct
-- local w2 = wibox.widget {
--     spacing = 10,
--     spacing_widget = {
--         color  = '#00ff00',
--         shape  = gears.shape.circle,
--         widget = wibox.widget.separator,
--     },
--     layout = wibox.layout.fixed.horizontal
-- }
-- -- Use composed widgets
-- local w3 = wibox.widget {
--     spacing = 10,
--     spacing_widget = {
--         {
--             text   = 'F',
--             widget = wibox.widget.textbox,
--         },
--         bg     = '#ff0000',
--         widget = wibox.container.background,
--     },
--     layout = wibox.layout.fixed.horizontal
-- }
-- -- Use negative spacing to create a powerline effect
-- local w4 = wibox.widget {
--     spacing = -12,
--     spacing_widget = {
--         color  = '#ff0000',
--         shape  = gears.shape.powerline,
--         widget = wibox.widget.separator,
--     },
--     layout = wibox.layout.fixed.horizontal
-- }
--
-- @property spacing_widget
-- @param widget

function fixed:set_spacing_widget(wdg)
    self._private.spacing_widget = base.make_widget_from_value(wdg)
    self:emit_signal("widget::layout_changed")
end

--- Insert a new widget in the layout at position `index`
-- **Signal:** widget::inserted The arguments are the widget and the index
-- @tparam number index The position
-- @param widget The widget
-- @treturn boolean If the operation is successful
function fixed:insert(index, widget)
    if not index or index < 1 or index > #self._private.widgets + 1 then return false end

    base.check_widget(widget)
    table.insert(self._private.widgets, index, widget)
    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::inserted", widget, #self._private.widgets)

    return true
end

-- Fit the fixed layout into the given space
-- @param context The context in which we are fit.
-- @param orig_width The available width.
-- @param orig_height The available height.
function fixed:fit(context, orig_width, orig_height)
    local width, height = orig_width, orig_height
    local used_in_dir, used_max = 0, 0

    for _, v in pairs(self._private.widgets) do
        local w, h = base.fit_widget(self, context, v, width, height)
        local in_dir, max
        if self._private.dir == "y" then
            max, in_dir = w, h
            height = height - in_dir
        else
            in_dir, max = w, h
            width = width - in_dir
        end
        if max > used_max then
            used_max = max
        end
        used_in_dir = used_in_dir + in_dir

        if width <= 0 or height <= 0 then
            if self._private.dir == "y" then
                used_in_dir = orig_height
            else
                used_in_dir = orig_width
            end
            break
        end
    end

    local spacing = self._private.spacing * (#self._private.widgets-1)

    if self._private.dir == "y" then
        return used_max, used_in_dir + spacing
    end
    return used_in_dir + spacing, used_max
end

function fixed:reset()
    self._private.widgets = {}
    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::reseted")
end

--- Set the layout's fill_space property. If this property is true, the last
-- widget will get all the space that is left. If this is false, the last widget
-- won't be handled specially and there can be space left unused.
-- @property fill_space

function fixed:fill_space(val)
    if self._private.fill_space ~= val then
        self._private.fill_space = not not val
        self:emit_signal("widget::layout_changed")
    end
end

local function get_layout(dir, widget1, ...)
    local ret = base.make_widget(nil, nil, {enable_properties = true})

    gtable.crush(ret, fixed, true)

    ret._private.dir = dir
    ret._private.widgets = {}
    ret:set_spacing(0)
    ret:fill_space(false)

    if widget1 then
        ret:add(widget1, ...)
    end

    return ret
end

--- Returns a new horizontal fixed layout. Each widget will get as much space as it
-- asks for and each widget will be drawn next to its neighboring widget.
-- Widgets can be added via :add() or as arguments to this function.
-- Note that widgets ignore `forced_height`. They will use the preferred/minimum width
-- on the horizontal axis, and a stretched height on the vertical axis.
-- @tparam widget ... Widgets that should be added to the layout.
-- @function wibox.layout.fixed.horizontal
function fixed.horizontal(...)
    return get_layout("x", ...)
end

--- Returns a new vertical fixed layout. Each widget will get as much space as it
-- asks for and each widget will be drawn next to its neighboring widget.
-- Widgets can be added via :add() or as arguments to this function.
-- Note that widgets ignore `forced_width`. They will use the preferred/minimum height
-- on the vertical axis, and a stretched width on the horizontal axis.
-- @tparam widget ... Widgets that should be added to the layout.
-- @function wibox.layout.fixed.vertical
function fixed.vertical(...)
    return get_layout("y", ...)
end

--- Add spacing between each layout widgets.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_fixed_spacing.svg)
--
-- @usage
-- for i=1, 5 do
--     local w = wibox.widget {
--         first,
--         second,
--         third,
--         spacing = i*3,
--         layout  = wibox.layout.fixed.horizontal
--     }
-- end
--
-- @property spacing
-- @tparam number spacing Spacing between widgets.

function fixed:set_spacing(spacing)
    if self._private.spacing ~= spacing then
        self._private.spacing = spacing
        self:emit_signal("widget::layout_changed")
    end
end

function fixed:get_spacing()
    return self._private.spacing or 0
end

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

return fixed

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
