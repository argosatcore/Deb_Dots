---------------------------------------------------------------------------
-- A layout with widgets added at specific positions.
--
-- Use cases include desktop icons, complex custom composed widgets, a floating
-- client layout and fine grained control over the output.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_defaults_manual.svg)
--
-- @usage
-- local w1, w2 = generic_widget(), generic_widget()
-- w1.point  = {x=75,y=5}
-- w1.text   = 'first'
-- w1.forced_width = 50
-- w2.text = 'second'
-- w2.point  = function(geo, args)
--     -- Bottom right
--     return {
--         x = args.parent.width-geo.width,
--         y = args.parent.height-geo.height
--     }
-- end
-- wibox.layout {
--     w1,
--     w2,
--     generic_widget('third'),
--     layout  = wibox.layout.manual
-- }
-- @author Emmanuel Lepage Vallee
-- @copyright 2016 Emmanuel Lepage Vallee
-- @classmod wibox.layout.manual
---------------------------------------------------------------------------
local gtable = require("gears.table")
local base = require("wibox.widget.base")
local unpack = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)

local manual_layout = {}

--- Add some widgets to the given stack layout
-- @param layout The layout you are modifying.
-- @tparam widget ... Widgets that should be added
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
function manual_layout:insert(index, widget)
    table.insert(self._private.widgets, index, widget)

    -- Add the point
    if widget.point then
        table.insert(self._private.pos, index, widget.point)
    end

    self:emit_signal("widget::layout_changed")
end

--- Remove one or more widgets from the layout
-- The last parameter can be a boolean, forcing a recursive seach of the
-- widget(s) to remove.
-- @param widget ... Widgets that should be removed (must at least be one)
-- @treturn boolean If the operation is successful
-- @name remove_widgets
-- @class function


function manual_layout:fit(_, width, height)
    return width, height
end

local function geometry(self, new)
    self._new_geo = new
    return self._new_geo or self
end

function manual_layout:layout(context, width, height)
    local res = {}

    for k, v in ipairs(self._private.widgets) do
        local pt = self._private.pos[k] or {x=0,y=0}
        local w, h = base.fit_widget(self, context, v, width, height)

        -- Make sure the signature is compatible with `awful.placement`. `Wibox`,
        -- doesn't depend on `awful`, but it is still nice not to have to code
        -- geometry functions again and again.
        if type(pt) == "function" or (getmetatable(pt) or {}).__call then
            local geo = {
                x      = 0,
                y      = 0,
                width  = w,
                height = h,
                geometry = geometry,
            }
            pt = pt(geo, {
                parent = {
                    x=0, y=0, width = width, height = height, geometry = geometry
                }
            })
            -- Trick to ensure compatibility with `awful.placement`
            gtable.crush(pt, geo._new_geo or {})
        end

        assert(pt.x)
        assert(pt.y)

        table.insert(res, base.place_widget_at(
            v, pt.x, pt.y, pt.width or w, pt.height or h
        ))
    end

    return res
end

function manual_layout:add(...)
    local wdgs = {...}
    local old_count = #self._private.widgets
    gtable.merge(self._private.widgets, {...})

    -- Add the points
    for k, v in ipairs(wdgs) do
        if v.point then
            self._private.pos[old_count+k] = v.point
        end
    end

    self:emit_signal("widget::layout_changed")
end

--- Add a widget at a specific point.
--
-- The point can either be a function or a table. The table follow the generic
-- geometry format used elsewhere in Awesome.
--
-- * *x*: The horizontal position.
-- * *y*: The vertical position.
-- * *width*: The width.
-- * *height*: The height.
--
-- If a function is used, it follows the same prototype as `awful.placement`
-- functions.
--
-- * *geo*:
--     * *x*: The horizontal position (always 0).
--     * *y*: The vertical position (always 0).
--     * *width*: The width.
--     * *height*: The height.
--     * *geometry*: A function to get or set the geometry (for compatibility).
--       The function is compatible with the `awful.placement` prototype.
-- * *args*:
--     * *parent* The layout own geometry
--         * *x*: The horizontal position (always 0).
--         * *y*: The vertical position (always 0).
--         * *width*: The width.
--         * *height*: The height.
--         * *geometry*: A function to get or set the geometry (for compatibility)
--           The function is compatible with the `awful.placement` prototype.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_manual_add_at.svg)
--
-- @usage
-- local l = wibox.layout {
--     layout  = wibox.layout.manual
-- }
-- --
-- -- Option 1: Set the point directly in the widget
-- local w1        = generic_widget()
-- w1.point        = {x=75, y=5}
-- w1.text         = 'first'
-- w1.forced_width = 50
-- l:add(w1)
-- --
-- -- Option 2: Set the point directly in the widget as a function
-- local w2  = generic_widget()
-- w2.text   = 'second'
-- w2.point  = function(geo, args)
--     return {
--         x = args.parent.width  - geo.width,
--         y = 0
--     }
-- end
-- l:add(w2)
-- --
-- -- Option 3: Set the point directly in the widget as an `awful.placement`
-- -- function.
-- local w3 = generic_widget()
-- w3.text  = 'third'
-- w3.point = awful.placement.bottom_right
-- l:add(w3)
-- --
-- -- Option 4: Use `:add_at` instead of using the `.point` property. This works
-- -- with all 3 ways to define the point.
-- -- function.
-- local w4 = generic_widget()
-- w4.text  = 'fourth'
-- l:add_at(w4, awful.placement.centered + awful.placement.maximize_horizontally)
-- @tparam widget widget The widget.
-- @tparam table|function point Either an `{x=x,y=y}` table or a function
--  returning the new geometry.
function manual_layout:add_at(widget, point)
    assert(not widget.point, "2 points are specified, only one is supported")

    -- Check is the point function is valid
    if type(point) == "function" or (getmetatable(point) or {}).__call then
        local fake_geo = {x=0,y=0,width=1,height=1,geometry=geometry}
        local pt = point(fake_geo, {
            parent = {
                x=0, y=0, width = 10, height = 10, geometry = geometry
            }
        })
        assert(pt and pt.x and pt.y, "The point function doesn't seem to be valid")
    end

    self._private.pos[#self._private.widgets+1] = point
    self:add(widget)
end

--- Move a widget (by index).
-- @tparam number index The widget index.
-- @tparam table|function point A new point value.
-- @see add_at
function manual_layout:move(index, point)
    assert(self._private.pos[index])
    self._private.pos[index] = point
    self:emit_signal( "widget::layout_changed" )
end

--- Move a widget.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_layout_manual_move_widget.svg)
--
-- @usage
-- local l = wibox.layout {
--     layout  = wibox.layout.manual
-- }
-- --
-- local w1        = generic_widget()
-- w1.point        = {x=75, y=5}
-- w1.text         = 'first'
-- w1.forced_width = 50
-- l:add(w1)
-- l:move_widget(w1, awful.placement.bottom_right)
-- @tparam widget widget The widget.
-- @tparam table|function point A new point value.
-- @see add_at
function manual_layout:move_widget(widget, point)
    local idx, l = self:index(widget, false)

    if idx then
        l:move(idx, point)
    end
end

function manual_layout:get_children()
    return self._private.widgets
end

function manual_layout:set_children(children)
    self:reset()
    self:add(unpack(children))
end

function manual_layout:reset()
    self._private.widgets = {}
    self._private.pos     = {}
    self:emit_signal( "widget::layout_changed" )
end

--- Create a manual layout.
-- @tparam table ... Widgets to add to the layout.
local function new_manual(...)
    local ret = base.make_widget(nil, nil, {enable_properties = true})

    gtable.crush(ret, manual_layout, true)
    ret._private.widgets = {}
    ret._private.pos = {}

    ret:add(...)

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

return setmetatable(manual_layout, {__call=function(_,...) return new_manual(...) end})
