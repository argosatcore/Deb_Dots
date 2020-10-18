---------------------------------------------------------------------------
-- Display percentage in a circle.
--
-- Note that this widget makes no attempts to prevent overlapping labels or
-- labels drawn outside of the widget boundaries.
--
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_defaults_piechart.svg)
--
-- @usage
-- wibox.widget {
--     data_list = {
--         { 'L1', 100 },
--         { 'L2', 200 },
--         { 'L3', 300 },
--     },
--     border_width = 1,
--     colors = {
--         beautiful.bg_normal,
--         beautiful.bg_highlight,
--         beautiful.border_color,
--     },
--     widget = wibox.widget.piechart
-- }
-- @author Emmanuel Lepage Valle
-- @copyright 2012 Emmanuel Lepage Vallee
-- @classmod wibox.widget.piechart
---------------------------------------------------------------------------

local color     = require( "gears.color"       )
local base      = require( "wibox.widget.base" )
local beautiful = require( "beautiful"         )
local gtable    = require( "gears.table"       )
local pie       = require( "gears.shape"       ).pie
local unpack    = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)

local module = {}

local piechart = {}

local function draw_label(cr,angle,radius,center_x,center_y,text)
    local edge_x = center_x+(radius/2)*math.cos(angle)
    local edge_y = center_y+(radius/2)*math.sin(angle)

    cr:move_to(edge_x, edge_y)

    cr:rel_line_to(radius*math.cos(angle), radius*math.sin(angle))

    local x,y = cr:get_current_point()

    cr:rel_line_to(x > center_x and radius/2 or -radius/2, 0)

    local ext = cr:text_extents(text)

    cr:rel_move_to(
        (x>center_x and radius/2.5 or (-radius/2.5 - ext.width)),
        ext.height/2
    )

    cr:show_text(text) --TODO eventually port away from the toy API
    cr:stroke()

    cr:arc(edge_x, edge_y,2,0,2*math.pi)
    cr:arc(x+(x>center_x and radius/2 or -radius/2),y,2,0,2*math.pi)

    cr:fill()
end

local function compute_sum(data)
    local ret = 0
    for _, entry in ipairs(data) do
        ret = ret + entry[2]
    end

    return ret
end

local function draw(self, _, cr, width, height)
    if not self._private.data_list then return end

    local radius = (height > width and width or height) / 4
    local sum, start, count = compute_sum(self._private.data_list),0,0
    local has_label = self._private.display_labels ~= false

    -- Labels need to be drawn later so the original source is kept
    -- use get_source() wont work are the reference cannot be set from Lua(?)
    local labels = {}

    local border_width = self:get_border_width() or 1
    local border_color = self:get_border_color()
    border_color       = border_color and color(border_color)

    -- Draw the pies
    cr:save()
    cr:set_line_width(border_width)

    -- Alternate from a given sets or colors
    local colors = self:get_colors()
    local col_count = colors and #colors or 0

    for _, entry in ipairs(self._private.data_list) do
        local k, v = entry[1], entry[2]
        local end_angle = start + 2*math.pi*(v/sum)

        local col = colors and color(colors[math.fmod(count,col_count)+1]) or nil

        pie(cr, width, height, start, end_angle, radius)

        if col then
            cr:save()
            cr:set_source(color(col))
        end

        if border_width > 0 then
            if col then
                cr:fill_preserve()
                cr:restore()
            end

            -- By default, it uses the fg color
            if border_color then
                cr:set_source(border_color)
            end
            cr:stroke()
        elseif col then
            cr:fill()
            cr:restore()
        end

        -- Store the label position for later
        if has_label then
            table.insert(labels, {
                --[[angle   ]] start+(end_angle-start)/2,
                --[[radius  ]] radius,
                --[[center_x]] width/2,
                --[[center_y]] height/2,
                --[[text    ]] k,
            })
        end
        start,count = end_angle,count+1
    end
    cr:restore()

    -- Draw the labels
    if has_label then
        for _, v in ipairs(labels) do
            draw_label(cr, unpack(v))
        end
    end
end

local function fit(_, _, width, height)
    return width, height
end

--- The pie chart data list.
-- @property data_list
-- @tparam table data_list Sorted table where each entry has a label as its
-- first value and a number as its second value.

--- The pie chart data.
-- @property data
-- @tparam table data Labels as keys and number as value.

--- The border color.
-- If none is set, it will use current foreground (text) color.
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_piechart_border_color.svg)
--
-- @property border_color
-- @param color
-- @see gears.color

--- The pie elements border width.
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_piechart_border_width.svg)
--
-- @property border_width
-- @tparam[opt=1] number border_width

--- The pie chart colors.
-- If no color is set, only the border will be drawn. If less colors than
-- required are set, colors will be re-used in order.
-- @property colors
-- @tparam table colors A table of colors, one for each elements
-- @see gears.color

--- The border color.
-- If none is set, it will use current foreground (text) color.
-- @beautiful beautiful.piechart_border_color
-- @param color
-- @see gears.color

--- If the pie chart has labels.
--
--
--![Usage example](../images/AUTOGEN_wibox_widget_piechart_label.svg)
--
-- @property display_labels
-- @param[opt=true] boolean

--- The pie elements border width.
-- @beautiful beautiful.piechart_border_width
-- @tparam[opt=1] number border_width

--- The pie chart colors.
-- If no color is set, only the border will be drawn. If less colors than
-- required are set, colors will be re-used in order.
-- @beautiful beautiful.piechart_colors
-- @tparam table colors A table of colors, one for each elements
-- @see gears.color

for _, prop in ipairs {"data_list", "border_color", "border_width", "colors",
    "display_labels"
  } do
    piechart["set_"..prop] = function(self, value)
        self._private[prop] = value
        self:emit_signal("property::"..prop)
        if prop == "data_list" then
            self:emit_signal("property::data")
        end
        self:emit_signal("widget::redraw_needed")
    end
    piechart["get_"..prop] = function(self)
        return self._private[prop] or beautiful["piechart_"..prop]
    end
end

function piechart:set_data(value)
    local list = {}
    for k, v in pairs(value) do
        table.insert(list, { k, v })
    end
    self:set_data_list(list)
end

function piechart:get_data()
    local list = {}
    for _, entry in ipairs(self:get_data_list()) do
        list[entry[1]] = entry[2]
    end
    return list
end

local function new(data_list)

    local ret = base.make_widget(nil, nil, {
        enable_properties = true,
    })

    gtable.crush(ret, piechart)

    rawset(ret, "fit" , fit )
    rawset(ret, "draw", draw)

    ret:set_data_list(data_list)

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

return setmetatable(module, { __call = function(_, ...) return new(...) end })
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
