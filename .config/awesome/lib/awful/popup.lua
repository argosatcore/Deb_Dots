---------------------------------------------------------------------------
--- An auto-resized, free floating or modal wibox built around a widget.
--
-- This type of widget box (wibox) is auto closed when being clicked on and is
-- automatically resized to the size of its main widget.
--
-- Note that the widget itself should have a finite size. If something like a
-- `wibox.layout.flex` is used, then the size would be unlimited and an error
-- will be printed. The `wibox.layout.fixed`, `wibox.container.constraint`,
-- `forced_width` and `forced_height` are recommended.
--
--
--
--![Usage example](../images/AUTOGEN_awful_popup_simple.svg)
--
-- 
--     awful.popup {
--         widget = {
--             {
--                 {
--                     text   = 'foobar',
--                     widget = wibox.widget.textbox
--                 },
--                 {
--                     {
--                         text   = 'foobar',
--                         widget = wibox.widget.textbox
--                     },
--                     bg     = '#ff00ff',
--                     clip   = true,
--                     shape  = gears.shape.rounded_bar,
--                     widget = wibox.widget.background
--                 },
--                 {
--                     value         = 0.5,
--                     forced_height = 30,
--                     forced_width  = 100,
--                     widget        = wibox.widget.progressbar
--                 },
--                 layout = wibox.layout.fixed.vertical,
--             },
--             margins = 10,
--             widget  = wibox.container.margin
--         },
--         border_color = '#00ff00',
--         border_width = 5,
--         placement    = awful.placement.top_left,
--         shape        = gears.shape.rounded_rect,
--         visible      = true,
--     }
--
-- Here is an example of how to create an alt-tab like dialog by leveraging
-- the `awful.widget.tasklist`.
--
--
--
--![Usage example](../images/AUTOGEN_awful_popup_alttab.svg)
--
-- 
--     awful.popup {
--         widget = awful.widget.tasklist {
--             screen   = screen[1],
--             filter   = awful.widget.tasklist.filter.allscreen,
--             buttons  = tasklist_buttons,
--             style    = {
--                 shape = gears.shape.rounded_rect,
--             },
--             layout   = {
--                 spacing = 5,
--                 forced_num_rows = 2,
--                 layout = wibox.layout.grid.horizontal
--             },
--             widget_template = {
--                 {
--                     {
--                         id     = 'clienticon',
--                         widget = awful.widget.clienticon,
--                     },
--                     margins = 4,
--                     widget  = wibox.container.margin,
--                 },
--                 id              = 'background_role',
--                 forced_width    = 48,
--                 forced_height   = 48,
--                 widget          = wibox.container.background,
--                 create_callback = function(self, c, index, objects) --luacheck: no unused
--                     self:get_children_by_id('clienticon')[1].client = c
--                 end,
--             },
--         },
--         border_color = '#777777',
--         border_width = 2,
--         ontop        = true,
--         placement    = awful.placement.centered,
--         shape        = gears.shape.rounded_rect
--     }
--
-- @author Emmanuel Lepage Vallee
-- @copyright 2016 Emmanuel Lepage Vallee
-- @classmod awful.popup
---------------------------------------------------------------------------
local wibox     = require( "wibox"           )
local util      = require( "awful.util"      )
local placement = require( "awful.placement" )
local xresources= require("beautiful.xresources")
local timer     = require( "gears.timer"     )
local capi      = {mouse = mouse}


local module = {}

local main_widget = {}

-- Get the optimal direction for the wibox
-- This (try to) avoid going offscreen
local function set_position(self)
    -- First, if there is size to be applied, do it
    if self._private.next_width then
        self.width = self._private.next_width
        self._private.next_width = nil
    end

    if self._private.next_height then
        self.height = self._private.next_height
        self._private.next_height = nil
    end

    local pf = self._private.placement

    if pf == false then return end

    if pf then
        pf(self, {bounding_rect = self.screen.geometry})
        return
    end

    local geo = self._private.widget_geo

    if not geo then return end

    local _, pos_name, anchor_name = placement.next_to(self, {
        preferred_positions = self._private.preferred_directions,
        geometry            = geo,
        preferred_anchors   = self._private.preferred_anchors,
        offset              = self._private.offset or { x = 0, y = 0},
    })

    if pos_name ~= self._private.current_position then
        local old = self._private.current_position
        self._private.current_position = pos_name
        self:emit_signal("property::current_position", pos_name, old)
    end

    if anchor_name ~= self._private.current_anchor then
        local old = self._private.current_anchor
        self._private.current_anchor = anchor_name
        self:emit_signal("property::current_anchor", anchor_name, old)
    end
end

-- Set the wibox size taking into consideration the limits
local function apply_size(self, width, height, set_pos)
    local prev_geo = self:geometry()

    width  = math.max(self._private.minimum_width  or 1, math.ceil(width  or 1))
    height = math.max(self._private.minimum_height or 1, math.ceil(height or 1))

    if self._private.maximum_width then
        width = math.min(self._private.maximum_width, width)
    end

    if self._private.maximum_height then
        height = math.min(self._private.maximum_height, height)
    end

    self._private.next_width, self._private.next_height = width, height

    if set_pos or width ~= prev_geo.width or height ~= prev_geo.height then
        set_position(self)
    end
end

-- Layout this widget
function main_widget:layout(context, width, height)
    if self._private.widget then
        local w, h = wibox.widget.base.fit_widget(
            self,
            context,
            self._private.widget,
            self._wb._private.maximum_width  or 9999,
            self._wb._private.maximum_height or 9999
        )
        timer.delayed_call(function()
            apply_size(self._wb, w, h, true)
        end)
        return { wibox.widget.base.place_widget_at(self._private.widget, 0, 0, width, height) }
    end
end

-- Set the widget that is drawn on top of the background
function main_widget:set_widget(widget)
    if widget then
        wibox.widget.base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

function main_widget:get_widget()
    return self._private.widget
end

function main_widget:get_children_by_id(name)
    return self._wb:get_children_by_id(name)
end

local popup = {}

--- Set the preferred popup position relative to its parent.
--
-- This allows, for example, to have a submenu that goes on the right of the
-- parent menu. If there is no space on the right, it tries on the left and so
-- on.
--
-- Valid directions are:
--
-- * left
-- * right
-- * top
-- * bottom
--
-- The basic use case for this method is to give it a parent wibox:
--
-- 
--
--![Usage example](../images/AUTOGEN_awful_popup_position1.svg)
--
-- 
--    for _, v in ipairs {'left', 'right', 'bottom', 'top'} do
--        local p2 = awful.popup {
--            widget = wibox.widget {
--                text   = 'On the '..v,
--                widget = wibox.widget.textbox
--            },
--            border_color        = '#777777',
--            border_width        = 2,
--            preferred_positions = v,
--            ontop               = true,
--        }
--        p2:move_next_to(p)
--    end
--
-- As demonstrated by this second example, it is also possible to use a widget
-- as a parent object:
--
-- 
--
--![Usage example](../images/AUTOGEN_awful_popup_position2.svg)
--
-- 
--    for _, v in ipairs {'left', 'right'} do
--        local p2 = awful.popup {
--            widget = wibox.widget {
--                text = 'On the '..v,
--                forced_height = 100,
--                widget = wibox.widget.textbox
--            },
--            border_color  = '#0000ff',
--            preferred_positions = v,
--            border_width  = 2,
--        }
--        p2:move_next_to(textboxinstance, v)
--    end
--
-- @property preferred_positions
-- @tparam table|string preferred_positions A position name or an ordered
--  table of positions
-- @see awful.placement.next_to
-- @see awful.popup.preferred_anchors

function popup:set_preferred_positions(pref_pos)
    self._private.preferred_directions = pref_pos
    set_position(self)
end

--- Set the preferred popup anchors relative to the parent.
--
-- The possible values are:
--
-- * front
-- * middle
-- * back
--
-- For details information, see the `awful.placement.next_to` documentation.
--
-- In this example, it is possible to see the effect of having a fallback
-- preferred anchors when the popup would otherwise not fit:
--
-- 
--
--![Usage example](../images/AUTOGEN_awful_popup_anchors.svg)
--
-- 
--     local p2 = awful.popup {
--         widget = wibox.widget {
--             text   = 'A popup',
--             forced_height = 100,
--             widget = wibox.widget.textbox
--         },
--         border_color        = '#777777',
--         border_width        = 2,
--         preferred_positions = 'right',
--         preferred_anchors   = {'front', 'back'},
--     }
--     local p4 = awful.popup {
--         widget = wibox.widget {
--             text   = 'A popup2',
--             forced_height = 100,
--             widget = wibox.widget.textbox
--         },
--         border_color        = '#777777',
--         border_width        = 2,
--         preferred_positions = 'right',
--         preferred_anchors   = {'front', 'back'},
--     }
--
-- @property preferred_anchors
-- @tparam table|string preferred_anchors Either a single anchor name or a table
--  ordered by priority.
-- @see awful.placement.next_to
-- @see awful.popup.preferred_positions

function popup:set_preferred_anchors(pref_anchors)
    self._private.preferred_anchors = pref_anchors
    set_position(self)
end

--- The current position relative to the parent object.
--
-- If there is a parent object (widget, wibox, wibar, client or the mouse), then
-- this property returns the current position. This is determined using
-- `preferred_positions`. It is usually the preferred position, but when there
-- isn't enough space, it can also be one of the fallback.
--
-- @property current_position
-- @tparam string current_position Either "left", "right", "top" or "bottom"

function popup:get_current_position()
    return self._private.current_position
end

--- Get the current anchor relative to the parent object.
--
-- If there is a parent object (widget, wibox, wibar, client or the mouse), then
-- this property returns the current anchor. The anchor is the "side" of the
-- parent object on which the popup is based on. It will "grow" in the
-- opposite direction from the anchor.
--
-- @property current_anchor
-- @tparam string current_anchor Either "front", "middle", "back"

function popup:get_current_anchor()
    return self._private.current_anchor
end

--- Move the wibox to a position relative to `geo`.
-- This will try to avoid overlapping the source wibox and auto-detect the right
-- direction to avoid going off-screen.
--
-- @param[opt=mouse] obj An object such as a wibox, client or a table entry
--  returned by `wibox:find_widgets()`.
-- @see awful.placement.next_to
-- @see awful.popup.preferred_positions
-- @see awful.popup.preferred_anchors
-- @treturn table The new geometry
function popup:move_next_to(obj)
    if self._private.is_relative == false then return end

    self._private.widget_geo = obj

    obj = obj or capi.mouse

    if obj._apply_size_now then
        obj:_apply_size_now(false)
    end

    self.visible = true

    self:_apply_size_now(true)

    self._private.widget_geo = nil
end

--- Bind the popup to a widget button press.
--
-- @tparam widget widget The widget
-- @tparam[opt=1] number button The button index
function popup:bind_to_widget(widget, button)
    if not self._private.button_for_widget then
        self._private.button_for_widget = {}
    end

    self._private.button_for_widget[widget] = button or 1
    widget:connect_signal("button::press", self._private.show_fct)
end

--- Unbind the popup from a widget button.
-- @tparam widget widget The widget
function popup:unbind_to_widget(widget)
    widget:disconnect_signal("button::press", self._private.show_fct)
end

--- Hide the popup when right clicked.
--
-- @property hide_on_right_click
-- @tparam[opt=false] boolean hide_on_right_click

function popup:set_hide_on_right_click(value)
    self[value and "connect_signal" or "disconnect_signal"](
        self, "button::press", self._private.hide_fct
    )
end

--- The popup minimum width.
-- @property minimum_width
-- @tparam[opt=1] number The minimum width

--- The popup minimum height.
-- @property minimum_height
-- @tparam[opt=1] number The minimum height

--- The popup minimum width.
-- @property maxmimum_width
-- @tparam[opt=1] number The maxmimum width

--- The popup maximum height.
-- @property maximum_height
-- @tparam[opt=1] number The maximum height

for _, orientation in ipairs {"_width", "_height"} do
    for _, limit in ipairs {"minimum", "maximum"} do
        popup["set_"..limit..orientation] = function(self, value)
            self._private[limit..orientation] = value
            self._private.container:emit_signal("widget::layout_changed")
        end
    end
end

--- The distance between the popup and its parent (if any).
--
-- Here is an example of 5 popups stacked one below the other with an y axis
-- offset (spacing).
--
-- 
--
--![Usage example](../images/AUTOGEN_awful_popup_position3.svg)
--
-- 
--    local previous = nil
--    for i=1, 5 do
--        local p2 = awful.popup {
--            widget = wibox.widget {
--                text   = 'Hello world!  '..i..'  aaaa.',
--                widget = wibox.widget.textbox
--            },
--            border_color        = beautiful.border_color,
--            preferred_positions = 'bottom',
--            border_width        = 2,
--            preferred_anchors   = 'back',
--            placement           = (not previous) and awful.placement.top or nil,
--            offset = {
--                 y = 10,
--            },
--        }
--        p2:move_next_to(previous)
--        previous = p2
--    end
-- @property offset
-- @tparam table|number offset An integer value or a `{x=, y=}` table.
-- @tparam[opt=offset] number offset.x The horizontal distance.
-- @tparam[opt=offset] number offset.y The vertical distance.

function popup:set_offset(offset)

    if type(offset) == "number" then
        offset = {
            x = offset or 0,
            y = offset or 0,
        }
    end

    local oldoff = self._private.offset or {x=0, y=0}

    if oldoff.x == offset.x and oldoff.y == offset.y then return end

    offset.x, offset.y = offset.x or oldoff.x or 0, offset.y or oldoff.y or 0

    self._private.offset = offset

    self:_apply_size_now(false)
end

--- Set the placement function.
-- @tparam[opt=next_to] function|string|boolean The placement function or name
-- (or false to disable placement)
-- @property placement
-- @param function

function popup:set_placement(f)
    if type(f) == "string" then
        f = placement[f]
    end

    self._private.placement = f
    self:_apply_size_now(false)
end

-- For the tests and the race condition when 2 popups are placed next to each
-- other.
function popup:_apply_size_now(skip_set)
    if not self.widget then return end

    local w, h = wibox.widget.base.fit_widget(
        self.widget,
        {dpi= self.screen.dpi or xresources.get_dpi()},
        self.widget,
        self._private.maximum_width  or 9999,
        self._private.maximum_height or 9999
    )

    -- It is important to do it for the obscure reason that calling `w:geometry()`
    -- is actually mutating the state due to quantum determinism thanks to XCB
    -- async nature... It is only true the very first time `w:geometry()` is
    -- called
    self.width  = math.max(1, math.ceil(w or 1))
    self.height = math.max(1, math.ceil(h or 1))

    apply_size(self, w, h, skip_set ~= false)
end

function popup:set_widget(wid)
    self._private.widget = wid
    self._private.container:set_widget(wid)
end

function popup:get_widget()
    return self._private.widget
end

--- Create a new popup build around a passed in widget.
-- @tparam[opt=nil] table args
-- @tparam integer args.border_width Border width.
-- @tparam string args.border_color Border color.
-- @tparam[opt=false] boolean args.ontop On top of other windows.
-- @tparam string args.cursor The mouse cursor.
-- @tparam boolean args.visible Visibility.
-- @tparam[opt=1] number args.opacity The opacity, between 0 and 1.
-- @tparam string args.type The window type (desktop, normal, dock, …).
-- @tparam integer args.x The x coordinates.
-- @tparam integer args.y The y coordinates.
-- @tparam integer args.width The width.
-- @tparam integer args.height The height.
-- @tparam screen args.screen The wibox screen.
-- @tparam wibox.widget args.widget The widget that the wibox displays.
-- @param args.shape_bounding The wibox’s bounding shape as a (native) cairo surface.
-- @param args.shape_clip The wibox’s clip shape as a (native) cairo surface.
-- @param args.shape_input The wibox’s input shape as a (native) cairo surface.
-- @tparam color args.bg The background.
-- @tparam surface args.bgimage The background image of the drawable.
-- @tparam color args.fg The foreground (text) color.
-- @tparam gears.shape args.shape The shape.
-- @tparam[opt=false] boolean args.input_passthrough If the inputs are
--  forward to the element below.
-- @tparam function args.placement The `awful.placement` function
-- @tparam string|table args.preferred_positions
-- @tparam string|table args.preferred_anchors
-- @tparam table|number args.offset The X and Y offset compared to the parent object
-- @tparam boolean args.hide_on_right_click Whether or not to hide the popup on
--  right clicks.
-- @function awful.popup
local function create_popup(_, args)
    assert(args)

    -- Temporarily remove the widget
    local original_widget = args.widget
    args.widget = nil

    assert(original_widget, "The `awful.popup` requires a `widget` constructor argument")

    local child_widget = wibox.widget.base.make_widget_from_value(original_widget)

    local ii = wibox.widget.base.make_widget(child_widget, "awful.popup", {
        enable_properties = true
    })

    util.table.crush(ii, main_widget, true)

    -- Create a wibox to host the widget
    local w = wibox(args or {})

    rawset(w, "_private", {
        container            = ii,
        preferred_directions = { "right", "left", "top", "bottom" },
        preferred_anchors    = { "back", "front", "middle" },
        widget = child_widget
    })

    util.table.crush(w, popup)

    ii:set_widget(child_widget)

    -- Create the signal handlers
    function w._private.show_fct(wdg, _, _, button, _, geo)
        if button == w._private.button_for_widget[wdg] then
            w:move_next_to(geo)
        end
    end
    function w._private.hide_fct()
        w.visible = false
    end

    -- Restore
    args.widget = original_widget

    -- Cross-link the wibox and widget
    ii._wb = w
    wibox.set_widget(w, ii)

    --WARNING The order is important
    -- First, apply the limits to avoid a flicker with large width or height
    -- when set_position is called before the limits
    for _,v in ipairs{"minimum_width", "minimum_height", "maximum_height",
      "maximum_width", "offset", "placement","preferred_positions",
      "preferred_anchors", "hide_on_right_click"} do
        if args[v] ~= nil then
            w["set_"..v](w, args[v])
        end
    end

    -- Default to visible
    if args.visible ~= false then
        w.visible = true
    end

    return w
end

----- Border width.
--
-- **Signal:**
--
--  * *property::border_width*
--
-- @property border_width
-- @param integer

--- Border color.
--
-- Please note that this property only support string based 24 bit or 32 bit
-- colors:
--
--    Red Blue
--     _|  _|
--    #FF00FF
--       T‾
--     Green
--
--
--    Red Blue
--     _|  _|
--    #FF00FF00
--       T‾  ‾T
--    Green   Alpha
--
-- **Signal:**
--
--  * *property::border_color*
--
-- @property border_color
-- @param string

--- On top of other windows.
--
-- **Signal:**
--
--  * *property::ontop*
--
-- @property ontop
-- @param boolean

--- The mouse cursor.
--
-- **Signal:**
--
--  * *property::cursor*
--
-- @property cursor
-- @param string
-- @see mouse

--- Visibility.
--
-- **Signal:**
--
--  * *property::visible*
--
-- @property visible
-- @param boolean

--- The opacity of the wibox, between 0 and 1.
--
-- **Signal:**
--
--  * *property::opacity*
--
-- @property opacity
-- @tparam number opacity (between 0 and 1)

--- The window type (desktop, normal, dock, ...).
--
-- **Signal:**
--
--  * *property::type*
--
-- @property type
-- @param string
-- @see client.type

--- The x coordinates.
--
-- **Signal:**
--
--  * *property::x*
--
-- @property x
-- @param integer

--- The y coordinates.
--
-- **Signal:**
--
--  * *property::y*
--
-- @property y
-- @param integer

--- The width of the wibox.
--
-- **Signal:**
--
--  * *property::width*
--
-- @property width
-- @param width

--- The height of the wibox.
--
-- **Signal:**
--
--  * *property::height*
--
-- @property height
-- @param height

--- The wibox screen.
--
-- @property screen
-- @param screen

---  The wibox's `drawable`.
--
-- **Signal:**
--
--  * *property::drawable*
--
-- @property drawable
-- @tparam drawable drawable

--- The widget that the `wibox` displays.
-- @property widget
-- @param widget

--- The X window id.
--
-- **Signal:**
--
--  * *property::window*
--
-- @property window
-- @param string
-- @see client.window

--- The wibox's bounding shape as a (native) cairo surface.
--
-- **Signal:**
--
--  * *property::shape_bounding*
--
-- @property shape_bounding
-- @param surface._native

--- The wibox's clip shape as a (native) cairo surface.
--
-- **Signal:**
--
--  * *property::shape_clip*
--
-- @property shape_clip
-- @param surface._native

--- The wibox's input shape as a (native) cairo surface.
--
-- **Signal:**
--
--  * *property::shape_input*
--
-- @property shape_input
-- @param surface._native


--- The wibar's shape.
--
-- **Signal:**
--
--  * *property::shape*
--
-- @property shape
-- @tparam gears.shape shape

--- Forward the inputs to the client below the wibox.
--
-- This replace the `shape_input` mask with an empty area. All mouse and
-- keyboard events are sent to the object (such as a client) positioned below
-- this wibox. When used alongside compositing, it allows, for example, to have
-- a subtle transparent wibox on top a fullscreen client to display important
-- data such as a low battery warning.
--
-- **Signal:**
--
--  * *property::input_passthrough*
--
-- @property input_passthrough
-- @param[opt=false] boolean
-- @see shape_input

--- Get or set mouse buttons bindings to a wibox.
--
-- @param buttons_table A table of buttons objects, or nothing.
-- @function buttons

--- Get or set wibox geometry. That's the same as accessing or setting the x,
-- y, width or height properties of a wibox.
--
-- @param A table with coordinates to modify.
-- @return A table with wibox coordinates and geometry.
-- @function geometry

--- Get or set wibox struts.
--
-- @param strut A table with new strut, or nothing
-- @return The wibox strut in a table.
-- @function struts
-- @see client.struts

--- The default background color.
-- @beautiful beautiful.bg_normal
-- @see bg

--- The default foreground (text) color.
-- @beautiful beautiful.fg_normal
-- @see fg

--- Set a declarative widget hierarchy description.
-- See [The declarative layout system](../documentation/03-declarative-layout.md.html)
-- @param args An array containing the widgets disposition
-- @name setup
-- @class function

--- The background of the wibox.
-- @param c The background to use. This must either be a cairo pattern object,
--   nil or a string that gears.color() understands.
-- @property bg
-- @see gears.color

--- The background image of the drawable.
-- If `image` is a function, it will be called with `(context, cr, width, height)`
-- as arguments. Any other arguments passed to this method will be appended.
-- @param image A background image or a function
-- @property bgimage
-- @see gears.surface

--- The foreground (text) of the wibox.
-- @param c The foreground to use. This must either be a cairo pattern object,
--   nil or a string that gears.color() understands.
-- @property fg
-- @see gears.color

--- Find a widget by a point.
-- The wibox must have drawn itself at least once for this to work.
-- @tparam number x X coordinate of the point
-- @tparam number y Y coordinate of the point
-- @treturn table A sorted table of widgets positions. The first element is the biggest
-- container while the last is the topmost widget. The table contains *x*, *y*,
-- *width*, *height* and *widget*.
-- @name find_widgets
-- @class function

return setmetatable(module, {__call = create_popup})
