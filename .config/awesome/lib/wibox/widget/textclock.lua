---------------------------------------------------------------------------
--- Text clock widget.
--
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @classmod wibox.widget.textclock
---------------------------------------------------------------------------

local setmetatable = setmetatable
local os = os
local textbox = require("wibox.widget.textbox")
local timer = require("gears.timer")
local gtable = require("gears.table")
local glib = require("lgi").GLib
local DateTime = glib.DateTime
local TimeZone = glib.TimeZone

local textclock = { mt = {} }

local DateTime_new_now = DateTime.new_now

-- When $SOURCE_DATE_EPOCH and $SOURCE_DIRECTORY are both set, then this code is
-- most likely being run by the test runner. Ensure reproducible dates.
local source_date_epoch = tonumber(os.getenv("SOURCE_DATE_EPOCH"))
if source_date_epoch and os.getenv("SOURCE_DIRECTORY") then
    DateTime_new_now = function()
        return DateTime.new_from_unix_utc(source_date_epoch)
    end
end

--- Set the clock's format
-- @property format
-- @tparam string format The new time format.  This can contain pango markup

function textclock:set_format(format)
    self._private.format = format
    self:force_update()
end

function textclock:get_format()
    return self._private.format
end

--- Set the clock's timezone
-- @property timezone
-- @tparam string timezone

function textclock:set_timezone(tzid)
    self._private.tzid = tzid
    self._private.timezone = tzid and TimeZone.new(tzid)
    self:force_update()
end

function textclock:get_timezone()
    return self._private.tzid
end

--- Set the clock's refresh rate
-- @property refresh
-- @tparam number How often the clock is updated, in seconds

function textclock:set_refresh(refresh)
    self._private.refresh = refresh or self._private.refresh
    self:force_update()
end

function textclock:get_refresh()
    return self._private.refresh
end

--- Force a textclock to update now.
function textclock:force_update()
    self._timer:emit_signal("timeout")
end

--- This lowers the timeout so that it occurs "correctly". For example, a timeout
-- of 60 is rounded so that it occurs the next time the clock reads ":00 seconds".
local function calc_timeout(real_timeout)
    return real_timeout - os.time() % real_timeout
end

--- Create a textclock widget. It draws the time it is in a textbox.
--
-- @tparam[opt=" %a %b %d, %H:%M "] string format The time format.
-- @tparam[opt=60] number refresh How often to update the time (in seconds).
-- @tparam[opt=local timezone] string timezone The timezone to use,
--   e.g. "Z" for UTC, "±hh:mm" or "Europe/Amsterdam". See
--   https://developer.gnome.org/glib/stable/glib-GTimeZone.html#g-time-zone-new.
-- @treturn table A textbox widget.
-- @function wibox.widget.textclock
local function new(format, refresh, tzid)
    local w = textbox()
    gtable.crush(w, textclock, true)

    w._private.format = format or " %a %b %d, %H:%M "
    w._private.refresh = refresh or 60
    w._private.tzid = tzid
    w._private.timezone = tzid and TimeZone.new(tzid)

    function w._private.textclock_update_cb()
        local str = DateTime_new_now(w._private.timezone or TimeZone.new_local()):format(w._private.format)
        if str == nil then
            require("gears.debug").print_warning("textclock: "
                    .. "g_date_time_format() failed for format "
                    .. "'" .. w._private.format .. "'")
        end
        w:set_markup(str)
        w._timer.timeout = calc_timeout(w._private.refresh)
        w._timer:again()
        return true -- Continue the timer
    end

    w._timer = timer.weak_start_new(refresh, w._private.textclock_update_cb)
    w:force_update()
    return w
end

function textclock.mt:__call(...)
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

return setmetatable(textclock, textclock.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
