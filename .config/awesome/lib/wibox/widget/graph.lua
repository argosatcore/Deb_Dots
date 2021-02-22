---------------------------------------------------------------------------
--- A graph widget.
--
-- The graph goes from left to right. To change this to right to left, use
-- a `wibox.container.mirror` widget. This can also be used to have data
-- shown from top to bottom.
--
-- To add text on top of the graph, use a `wibox.layout.stack` and a
-- `wibox.container.align` widgets.
--
-- To display the graph vertically, use a `wibox.container.rotate` widget.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_defaults_graph.svg)
--
-- @usage
-- wibox.widget {
--     max_value = 29,
--     widget = wibox.widget.graph
-- }
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @classmod wibox.widget.graph
---------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local math = math
local table = table
local type = type
local color = require("gears.color")
local base = require("wibox.widget.base")
local beautiful = require("beautiful")

local graph = { mt = {} }

--- Set the graph border color.
-- If the value is nil, no border will be drawn.
--
-- @property border_color
-- @tparam gears.color border_color The border color to set.
-- @see gears.color

--- Set the graph foreground color.
--
-- @property color
-- @tparam color color The graph color.
-- @see gears.color

--- Set the graph background color.
--
-- @property background_color
-- @tparam gears.color background_color The graph background color.
-- @see gears.color

--- Set the maximum value the graph should handle.
-- If "scale" is also set, the graph never scales up below this value, but it
-- automatically scales down to make all data fit.
--
-- @property max_value
-- @param number

--- The minimum value.
-- Note that the min_value is not supported when used along with the stack
-- property.
-- @property min_value
-- @param number

--- Set the graph to automatically scale its values. Default is false.
--
-- @property scale
-- @param boolean

--- Set the width or the individual steps.
--
-- Note that it isn't supported when used along with stacked graphs.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_graph_step.svg)
--
-- @usage
-- wibox.widget {
--     max_value = 29,
--     step_width = 3,
--     step_spacing = 1,
--     step_shape = function(cr, width, height)
--         gears.shape.rounded_rect(cr, width, height, 2)
--     end,
--     widget = wibox.widget.graph
-- }
--
-- @property step_width
-- @param[opt=1] number

--- Set the spacing between the steps.
--
-- Note that it isn't supported when used along with stacked graphs.
--
-- @property step_spacing
-- @param[opt=0] number

--- The step shape.
-- @property step_shape
-- @param[opt=rectangle] shape
-- @see gears.shape

--- Set the graph to draw stacks. Default is false.
--
-- @property stack
-- @param boolean

--- Set the graph stacking colors. Order matters.
--
-- @property stack_colors
-- @param stack_colors A table with stacking colors.

--- The graph background color.
-- @beautiful beautiful.graph_bg

--- The graph foreground color.
-- @beautiful beautiful.graph_fg

--- The graph border color.
-- @beautiful beautiful.graph_border_color

local properties = { "width", "height", "border_color", "stack",
                     "stack_colors", "color", "background_color",
                     "max_value", "scale", "min_value", "step_shape",
                     "step_spacing", "step_width" }

function graph.draw(_graph, _, cr, width, height)
    local max_value = _graph._private.max_value
    local min_value = _graph._private.min_value or (
        _graph._private.scale and math.huge or 0)
    local values = _graph._private.values

    local step_shape = _graph._private.step_shape
    local step_spacing = _graph._private.step_spacing or 0
    local step_width = _graph._private.step_width or 1

    cr:set_line_width(1)

    -- Draw the background first
    cr:set_source(color(_graph._private.background_color or beautiful.graph_bg or "#000000aa"))
    cr:paint()

    -- Account for the border width
    cr:save()
    if _graph._private.border_color then
        cr:translate(1, 1)
        width, height = width - 2, height - 2
    end

    -- Draw a stacked graph
    if _graph._private.stack then

        if _graph._private.scale then
            for _, v in ipairs(values) do
                for _, sv in ipairs(v) do
                    if sv > max_value then
                        max_value = sv
                    end
                    if min_value > sv then
                        min_value = sv
                    end
                end
            end
        end

        for i = 0, width do
            local rel_i = 0
            local rel_x = i + 0.5

            if _graph._private.stack_colors then
                for idx, col in ipairs(_graph._private.stack_colors) do
                    local stack_values = values[idx]
                    if stack_values and i < #stack_values then
                        local value = stack_values[#stack_values - i] + rel_i
                        cr:move_to(rel_x, height * (1 - (rel_i / max_value)))
                        cr:line_to(rel_x, height * (1 - (value / max_value)))
                        cr:set_source(color(col or beautiful.graph_fg or "#ff0000"))
                        cr:stroke()
                        rel_i = value
                    end
                end
            end
        end
    else
        if _graph._private.scale then
            for _, v in ipairs(values) do
                if v > max_value then
                    max_value = v
                end
                if min_value > v then
                    min_value = v
                end
            end
        end

        -- Draw the background on no value
        if #values ~= 0 then
            -- Draw reverse
            for i = 0, #values - 1 do
                local value = values[#values - i]
                if value >= 0 then
                    local x = i*step_width + ((i-1)*step_spacing) + 0.5
                    value = (value - min_value) / max_value
                    cr:move_to(x, height * (1 - value))

                    if step_shape then
                        cr:translate(step_width + (i>1 and step_spacing or 0), height * (1 - value))
                        step_shape(cr, step_width, height)
                        cr:translate(0, -(height * (1 - value)))
                    elseif step_width > 1 then
                        cr:rectangle(x, height * (1 - value), step_width, height)
                    else
                        cr:line_to(x, height)
                    end
                end
            end
            cr:set_source(color(_graph._private.color or beautiful.graph_fg or "#ff0000"))

            if step_shape or step_width > 1 then
                cr:fill()
            else
                cr:stroke()
            end
        end

    end

    -- Undo the cr:translate() for the border and step shapes
    cr:restore()

    -- Draw the border last so that it overlaps already drawn values
    if _graph._private.border_color then
        -- We decremented these by two above
        width, height = width + 2, height + 2

        -- Draw the border
        cr:rectangle(0.5, 0.5, width - 1, height - 1)
        cr:set_source(color(_graph._private.border_color or beautiful.graph_border_color or "#ffffff"))
        cr:stroke()
    end
end

function graph.fit(_graph)
    return _graph._private.width, _graph._private.height
end

--- Add a value to the graph
--
-- @param value The value to be added to the graph
-- @param group The stack color group index.
function graph:add_value(value, group)
    value = value or 0
    local values = self._private.values
    local max_value = self._private.max_value
    value = math.max(0, value)
    if not self._private.scale then
        value = math.min(max_value, value)
    end

    if self._private.stack and group then
        if not  self._private.values[group]
        or type(self._private.values[group]) ~= "table"
        then
            self._private.values[group] = {}
        end
        values = self._private.values[group]
    end
    table.insert(values, value)

    local border_width = 0
    if self._private.border_color then border_width = 2 end

    -- Ensure we never have more data than we can draw
    while #values > self._private.width - border_width do
        table.remove(values, 1)
    end

    self:emit_signal("widget::redraw_needed")
    return self
end

--- Clear the graph.
function graph:clear()
    self._private.values = {}
    self:emit_signal("widget::redraw_needed")
    return self
end

--- Set the graph height.
-- @param height The height to set.
function graph:set_height(height)
    if height >= 5 then
        self._private.height = height
        self:emit_signal("widget::layout_changed")
    end
    return self
end

--- Set the graph width.
-- @param width The width to set.
function graph:set_width(width)
    if width >= 5 then
        self._private.width = width
        self:emit_signal("widget::layout_changed")
    end
    return self
end

-- Build properties function
for _, prop in ipairs(properties) do
    if not graph["set_" .. prop] then
        graph["set_" .. prop] = function(_graph, value)
            if _graph._private[prop] ~= value then
                _graph._private[prop] = value
                _graph:emit_signal("widget::redraw_needed")
            end
            return _graph
        end
    end
    if not graph["get_" .. prop] then
        graph["get_" .. prop] = function(_graph)
            return _graph._private[prop]
        end
    end
end

--- Create a graph widget.
-- @param args Standard widget() arguments. You should add width and height
-- key to set graph geometry.
-- @return A new graph widget.
-- @function wibox.widget.graph
function graph.new(args)
    args = args or {}

    local width = args.width or 100
    local height = args.height or 20

    if width < 5 or height < 5 then return end

    local _graph = base.make_widget(nil, nil, {enable_properties = true})

    _graph._private.width     = width
    _graph._private.height    = height
    _graph._private.values    = {}
    _graph._private.max_value = 1

    -- Set methods
    _graph.add_value = graph["add_value"]
    _graph.clear = graph["clear"]
    _graph.draw = graph.draw
    _graph.fit = graph.fit

    for _, prop in ipairs(properties) do
        _graph["set_" .. prop] = graph["set_" .. prop]
        _graph["get_" .. prop] = graph["get_" .. prop]
    end

    return _graph
end

function graph.mt:__call(...)
    return graph.new(...)
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

return setmetatable(graph, graph.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
