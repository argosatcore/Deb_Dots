---------------------------------------------------------------------------
-- A container used to place smaller widgets into larger space.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_container_defaults_place.svg)
--
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2016 Emmanuel Lepage Vallee
-- @release v4.3
-- @classmod wibox.container.place
---------------------------------------------------------------------------

local setmetatable = setmetatable
local base = require("wibox.widget.base")
local gtable = require("gears.table")

local place = { mt = {} }

-- Take the widget width/height and compute the position from the full
-- width/height
local align_fct = {
    left   = function(_  , _   ) return 0                         end,
    center = function(wdg, orig) return math.max(0, (orig-wdg)/2) end,
    right  = function(wdg, orig) return math.max(0, orig-wdg    ) end,
}
align_fct.top, align_fct.bottom = align_fct.left, align_fct.right

-- Layout this layout
function place:layout(context, width, height)

    if not self._private.widget then
        return
    end

    local w, h = base.fit_widget(self, context, self._private.widget, width, height)

    if self._private.content_fill_horizontal then
        w = width
    end

    if self._private.content_fill_vertical then
        h = height
    end

    local valign = self._private.valign or "center"
    local halign = self._private.halign or "center"

    local x, y = align_fct[halign](w, width), align_fct[valign](h, height)

    return { base.place_widget_at(self._private.widget, x, y, w, h) }
end

-- Fit this layout into the given area
function place:fit(context, width, height)
    if not self._private.widget then
        return 0, 0
    end

    local w, h = base.fit_widget(self, context, self._private.widget, width, height)

    return (self._private.fill_horizontal or self._private.content_fill_horizontal)
        and width or w,
    (self._private.fill_vertical or self._private.content_fill_vertical)
        and height or h
end

--- The widget to be placed.
-- @property widget
-- @tparam widget widget The widget

function place:set_widget(widget)
    if widget then
        base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

function place:get_widget()
    return self._private.widget
end

--- Get the number of children element
-- @treturn table The children
function place:get_children()
    return {self._private.widget}
end

--- Replace the layout children
-- This layout only accept one children, all others will be ignored
-- @tparam table children A table composed of valid widgets
function place:set_children(children)
    self:set_widget(children[1])
end

--- Reset this layout. The widget will be removed and the rotation reset.
function place:reset()
    self:set_widget(nil)
end

--- The vertical alignment.
--
-- Possible values are:
--
-- * *top*
-- * *center* (default)
-- * *bottom*
--
-- @property valign
-- @param[opt="center"] string

--- The horizontal alignment.
--
-- Possible values are:
--
-- * *left*
-- * *center* (default)
-- * *right*
--
-- @property halign
-- @param[opt="center"] string

function place:set_valign(value)
    if value ~= "center" and value ~= "top" and value ~= "bottom" then
        return
    end

    self._private.valign = value
    self:emit_signal("widget::layout_changed")
end

function place:set_halign(value)
    if value ~= "center" and value ~= "left" and value ~= "right" then
        return
    end

    self._private.halign = value
    self:emit_signal("widget::layout_changed")
end

--- Fill the vertical space.
-- @property fill_vertical
-- @param[opt=false] boolean

function place:set_fill_vertical(value)
    self._private.fill_vertical = value
    self:emit_signal("widget::layout_changed")
end

--- Fill the horizontal space.
-- @property fill_horizontal
-- @param[opt=false] boolean

function place:set_fill_horizontal(value)
    self._private.fill_horizontal = value
    self:emit_signal("widget::layout_changed")
end

--- Stretch the contained widget so it takes all the vertical space.
-- @property content_fill_vertical
-- @param[opt=false] boolean

function place:set_content_fill_vertical(value)
    self._private.content_fill_vertical = value
    self:emit_signal("widget::layout_changed")
end

--- Stretch the contained widget so it takes all the horizontal space.
-- @property content_fill_horizontal
-- @param[opt=false] boolean

function place:set_content_fill_horizontal(value)
    self._private.content_fill_horizontal = value
    self:emit_signal("widget::layout_changed")
end

--- Returns a new place container.
-- @param[opt] widget The widget to display.
-- @tparam[opt="center"] string halign The horizontal alignment
-- @tparam[opt="center"] string valign The vertical alignment
-- @treturn table A new place container.
-- @function wibox.container.place
local function new(widget, halign, valign)
    local ret = base.make_widget(nil, nil, {enable_properties = true})

    gtable.crush(ret, place, true)

    ret:set_widget(widget)
    ret:set_halign(halign)
    ret:set_valign(valign)

    return ret
end

function place.mt:__call(_, ...)
    return new(_, ...)
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

return setmetatable(place, place.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
