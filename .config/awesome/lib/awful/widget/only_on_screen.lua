---------------------------------------------------------------------------
--
-- A container that makes a widget display only on a specified screen.
--
-- @author Uli Schlachter
-- @copyright 2017 Uli Schlachter
-- @classmod awful.widget.only_on_screen
---------------------------------------------------------------------------

local type = type
local pairs = pairs
local setmetatable = setmetatable
local base = require("wibox.widget.base")
local gtable = require("gears.table")
local capi = {
    screen = screen,
    awesome = awesome
}

local only_on_screen = { mt = {} }

local instances = setmetatable({}, { __mode = "k" })

local function should_display_on(self, s)
    if not self._private.widget then
        return false
    end
    local own_s = self._private.screen
    if type(own_s) == "number" and (own_s < 1 or own_s > capi.screen.count()) then
        -- Invalid screen number
        return false
    end
    return capi.screen[self._private.screen] == s
end

-- Layout this layout
function only_on_screen:layout(context, ...)
    if not should_display_on(self, context.screen) then return end
    return { base.place_widget_at(self._private.widget, 0, 0, ...) }
end

-- Fit this layout into the given area
function only_on_screen:fit(context, ...)
    if not should_display_on(self, context.screen) then
        return 0, 0
    end
    return base.fit_widget(self, context, self._private.widget, ...)
end

--- The widget to be displayed
-- @property widget
-- @tparam widget widget The widget

function only_on_screen:set_widget(widget)
    if widget then
        base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

function only_on_screen:get_widget()
    return self._private.widget
end

--- Get the number of children element
-- @treturn table The children
function only_on_screen:get_children()
    return {self._private.widget}
end

--- Replace the layout children
-- This layout only accept one children, all others will be ignored
-- @tparam table children A table composed of valid widgets
function only_on_screen:set_children(children)
    self:set_widget(children[1])
end

--- The screen to display on. Can be a screen object, a screen index, a screen
-- name ("VGA1") or the string "primary" for the primary screen.
-- @property screen
-- @tparam screen|string|integer screen The screen.

function only_on_screen:set_screen(s)
    self._private.screen = s
    self:emit_signal("widget::layout_changed")
end

function only_on_screen:get_screen()
    return self._private.screen
end

--- Returns a new only_on_screen container.
-- This widget makes some other widget visible on just some screens. Use
-- `:set_widget()` to set the widget and `:set_screen()` to set the screen.
-- @param[opt] widget The widget to display.
-- @param[opt] s The screen to display on.
-- @treturn table A new only_on_screen container
-- @function wibox.container.only_on_screen
local function new(widget, s)
    local ret = base.make_widget(nil, nil, {enable_properties = true})

    gtable.crush(ret, only_on_screen, true)

    ret:set_widget(widget)
    ret:set_screen(s or "primary")

    instances[ret] = true

    return ret
end

function only_on_screen.mt:__call(...)
    return new(...)
end

-- Handle lots of cases where a screen changes and thus this widget jumps around

capi.screen.connect_signal("primary_changed", function()
    for widget in pairs(instances) do
        if widget._private.widget and widget._private.screen == "primary" then
            widget:emit_signal("widget::layout_changed")
        end
    end
end)

capi.screen.connect_signal("list", function()
    for widget in pairs(instances) do
        if widget._private.widget and type(widget._private.screen) == "number" then
            widget:emit_signal("widget::layout_changed")
        end
    end
end)

capi.screen.connect_signal("property::outputs", function()
    for widget in pairs(instances) do
        if widget._private.widget and type(widget._private.screen) == "string" then
            widget:emit_signal("widget::layout_changed")
        end
    end
end)

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

return setmetatable(only_on_screen, only_on_screen.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
