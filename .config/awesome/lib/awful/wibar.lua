---------------------------------------------------------------------------
--- Wibox module for awful.
-- This module allows you to easily create wibox and attach them to the edge of
-- a screen.
--
-- @author Emmanuel Lepage Vallee &lt;elv1313@gmail.com&gt;
-- @copyright 2016 Emmanuel Lepage Vallee
-- @classmod awful.wibar
---------------------------------------------------------------------------

-- Grab environment we need
local capi =
{
    screen = screen,
    client = client
}
local setmetatable = setmetatable
local tostring = tostring
local ipairs = ipairs
local error = error
local wibox = require("wibox")
local beautiful = require("beautiful")
local gdebug = require("gears.debug")
local placement = require("awful.placement")

local function get_screen(s)
    return s and capi.screen[s]
end

local awfulwibar = { mt = {} }

--- Array of table with wiboxes inside.
-- It's an array so it is ordered.
local wiboxes = setmetatable({}, {__mode = "v"})

--- If the wibar needs to be stretched to fill the screen.
-- @property stretch
-- @tparam boolean stretch

--- The wibar's width.
-- @property width
-- @tparam integer width

--- The wibar's height.
-- @property height
-- @tparam integer height

--- If the wibar needs to be stretched to fill the screen.
-- @beautiful beautiful.wibar_stretch
-- @tparam boolean stretch

--- The wibar border width.
-- @beautiful beautiful.wibar_border_width
-- @tparam integer border_width

--- The wibar border color.
-- @beautiful beautiful.wibar_border_color
-- @tparam string border_color

--- If the wibar is to be on top of other windows.
-- @beautiful beautiful.wibar_ontop
-- @tparam boolean ontop

--- The wibar's mouse cursor.
-- @beautiful beautiful.wibar_cursor
-- @tparam string cursor

--- The wibar opacity, between 0 and 1.
-- @beautiful beautiful.wibar_opacity
-- @tparam number opacity

--- The window type (desktop, normal, dock, …).
-- @beautiful beautiful.wibar_type
-- @tparam string type

--- The wibar's width.
-- @beautiful beautiful.wibar_width
-- @tparam integer width

--- The wibar's height.
-- @beautiful beautiful.wibar_height
-- @tparam integer height

--- The wibar's background color.
-- @beautiful beautiful.wibar_bg
-- @tparam color bg

--- The wibar's background image.
-- @beautiful beautiful.wibar_bgimage
-- @tparam surface bgimage

--- The wibar's foreground (text) color.
-- @beautiful beautiful.wibar_fg
-- @tparam color fg

--- The wibar's shape.
-- @beautiful beautiful.wibar_shape
-- @tparam gears.shape shape

-- Compute the margin on one side
local function get_margin(w, position, auto_stop)
    local h_or_w = (position == "top" or position == "bottom") and "height" or "width"
    local ret = 0

    for _, v in ipairs(wiboxes) do
        -- Ignore the wibars placed after this one
        if auto_stop and v == w then break end

        if v.position == position and v.screen == w.screen and v.visible then
            ret = ret + v[h_or_w]
        end
    end

    return ret
end

-- `honor_workarea` cannot be used as it does modify the workarea itself.
-- a manual padding has to be generated.
local function get_margins(w)
    local position = w.position
    assert(position)

    local margins = {left=0, right=0, top=0, bottom=0}

    margins[position] = get_margin(w, position, true)

    -- Avoid overlapping wibars
    if position == "left" or position == "right" then
        margins.top    = get_margin(w, "top"   )
        margins.bottom = get_margin(w, "bottom")
    end

    return margins
end

-- Create the placement function
local function gen_placement(position, stretch)
    local maximize = (position == "right" or position == "left") and
        "maximize_vertically" or "maximize_horizontally"

    return placement[position] + (stretch and placement[maximize] or nil)
end

-- Attach the placement function.
local function attach(wb, align)
    gen_placement(align, wb._stretch)(wb, {
        attach          = true,
        update_workarea = true,
        margins         = get_margins(wb)
    })
end

-- Re-attach all wibars on a given wibar screen
local function reattach(wb)
    local s = wb.screen
    for _, w in ipairs(wiboxes) do
        if w ~= wb and w.screen == s then
            if w.detach_callback then
                w.detach_callback()
                w.detach_callback = nil
            end
            attach(w, w.position)
        end
    end
end

--- The wibox position.
-- @property position
-- @param string Either "left", right", "top" or "bottom"

local function get_position(wb)
    return wb._position or "top"
end

local function set_position(wb, position, skip_reattach)
    -- Detach first to avoid any uneeded callbacks
    if wb.detach_callback then
        wb.detach_callback()

        -- Avoid disconnecting twice, this produces a lot of warnings
        wb.detach_callback = nil
    end

    -- Move the wibar to the end of the list to avoid messing up the others in
    -- case there is stacked wibars on one side.
    if wb._position then
        for k, w in ipairs(wiboxes) do
            if w == wb then
                table.remove(wiboxes, k)
            end
        end
        table.insert(wiboxes, wb)
    end

    -- In case the position changed, it may be necessary to reset the size
    if (wb._position == "left" or wb._position == "right")
      and (position == "top" or position == "bottom") then
        wb.height = math.ceil(beautiful.get_font_height(wb.font) * 1.5)
    elseif (wb._position == "top" or wb._position == "bottom")
      and (position == "left" or position == "right") then
        wb.width = math.ceil(beautiful.get_font_height(wb.font) * 1.5)
    end

    -- Set the new position
    wb._position = position

    -- Attach to the new position
    attach(wb, position)

    -- A way to skip reattach is required when first adding a wibar as it's not
    -- in the `wiboxes` table yet and can't be added until it's attached.
    if not skip_reattach then
        -- Changing the position will also cause the other margins to be invalidated.
        -- For example, adding a wibar to the top will change the margins of any left
        -- or right wibars. To solve, this, they need to be re-attached.
        reattach(wb)
    end
end

--- Stretch the wibar.
--
-- @property stretch
-- @param[opt=true] boolean

local function get_stretch(w)
    return w._stretch
end

local function set_stretch(w, value)
    w._stretch = value

    attach(w, w.position)
end

--- Remove a wibar.
-- @function remove
local function remove(self)
    self.visible = false

    if self.detach_callback then
        self.detach_callback()
        self.detach_callback = nil
    end

    for k, w in ipairs(wiboxes) do
        if w == self then
            table.remove(wiboxes, k)
        end
    end

    self._screen = nil
end

--- Get a wibox position if it has been set, or return top.
-- @param wb The wibox
-- @deprecated awful.wibar.get_position
-- @return The wibox position.
function awfulwibar.get_position(wb)
    gdebug.deprecate("Use wb:get_position() instead of awful.wibar.get_position", {deprecated_in=4})
    return get_position(wb)
end

--- Put a wibox on a screen at this position.
-- @param wb The wibox to attach.
-- @param position The position: top, bottom left or right.
-- @param screen This argument is deprecated, use wb.screen directly.
-- @deprecated awful.wibar.set_position
function awfulwibar.set_position(wb, position, screen) --luacheck: no unused args
    gdebug.deprecate("Use wb:set_position(position) instead of awful.wibar.set_position", {deprecated_in=4})

    set_position(wb, position)
end

--- Attach a wibox to a screen.
--
-- This function has been moved to the `awful.placement` module. Calling this
-- no longer does anything.
--
-- @param wb The wibox to attach.
-- @param position The position of the wibox: top, bottom, left or right.
-- @param screen The screen to attach to
-- @see awful.placement
-- @deprecated awful.wibar.attach
function awfulwibar.attach(wb, position, screen) --luacheck: no unused args
    gdebug.deprecate("awful.wibar.attach is deprecated, use the 'attach' property"..
        " of awful.placement. This method doesn't do anything anymore",
        {deprecated_in=4}
    )
end

--- Align a wibox.
--
-- Supported alignment are:
--
-- * top_left
-- * top_right
-- * bottom_left
-- * bottom_right
-- * left
-- * right
-- * top
-- * bottom
-- * centered
-- * center_vertical
-- * center_horizontal
--
-- @param wb The wibox.
-- @param align The alignment
-- @param screen This argument is deprecated. It is not used. Use wb.screen
--  directly.
-- @deprecated awful.wibar.align
-- @see awful.placement.align
function awfulwibar.align(wb, align, screen) --luacheck: no unused args
    if align == "center" then
        gdebug.deprecate("awful.wibar.align(wb, 'center' is deprecated, use 'centered'", {deprecated_in=4})
        align = "centered"
    end

    if screen then
        gdebug.deprecate("awful.wibar.align 'screen' argument is deprecated", {deprecated_in=4})
    end

    if placement[align] then
        return placement[align](wb)
    end
end

--- Stretch a wibox so it takes all screen width or height.
--
-- **This function has been removed.**
--
-- @deprecated awful.wibox.stretch
-- @see awful.placement
-- @see awful.wibar.stretch

--- Create a new wibox and attach it to a screen edge.
-- You can add also position key with value top, bottom, left or right.
-- You can also use width or height in % and set align to center, right or left.
-- You can also set the screen key with a screen number to attach the wibox.
-- If not specified, the primary screen is assumed.
-- @see wibox
-- @tparam[opt=nil] table args
-- @tparam string args.position The position.
-- @tparam string args.stretch If the wibar need to be stretched to fill the screen.
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
-- @return The new wibar
-- @function awful.wibar
function awfulwibar.new(args)
    args = args or {}
    local position = args.position or "top"
    local has_to_stretch = true
    local screen = get_screen(args.screen or 1)

    args.type = args.type or "dock"

    if position ~= "top" and position ~="bottom"
            and position ~= "left" and position ~= "right" then
        error("Invalid position in awful.wibar(), you may only use"
            .. " 'top', 'bottom', 'left' and 'right'")
    end

    -- Set default size
    if position == "left" or position == "right" then
        args.width = args.width or beautiful["wibar_width"]
            or math.ceil(beautiful.get_font_height(args.font) * 1.5)
        if args.height then
            has_to_stretch = false
            if args.screen then
                local hp = tostring(args.height):match("(%d+)%%")
                if hp then
                    args.height = math.ceil(screen.geometry.height * hp / 100)
                end
            end
        end
    else
        args.height = args.height or beautiful["wibar_height"]
            or math.ceil(beautiful.get_font_height(args.font) * 1.5)
        if args.width then
            has_to_stretch = false
            if args.screen then
                local wp = tostring(args.width):match("(%d+)%%")
                if wp then
                    args.width = math.ceil(screen.geometry.width * wp / 100)
                end
            end
        end
    end

    args.screen = nil

    -- The C code scans the table directly, so metatable magic cannot be used.
    for _, prop in ipairs {
        "border_width", "border_color", "font", "opacity", "ontop", "cursor",
        "bgimage", "bg", "fg", "type", "stretch", "shape"
    } do
        if (args[prop] == nil) and beautiful["wibar_"..prop] ~= nil then
            args[prop] = beautiful["wibar_"..prop]
        end
    end

    local w = wibox(args)

    w.screen   = screen
    w._screen  = screen --HACK When a screen is removed, then getbycoords wont work
    w._stretch = args.stretch == nil and has_to_stretch or args.stretch

    w.get_position = get_position
    w.set_position = set_position

    w.get_stretch = get_stretch
    w.set_stretch = set_stretch
    w.remove      = remove

    if args.visible == nil then w.visible = true end

    -- `w` needs to be inserted in `wiboxes` before reattach or its own offset
    -- will not be taken into account by the "older" wibars when `reattach` is
    -- called. `skip_reattach` is required.
    w:set_position(position, true)

    table.insert(wiboxes, w)

    -- Force all the wibars to be moved
    reattach(w)

    w:connect_signal("property::visible", function() reattach(w) end)

    return w
end

capi.screen.connect_signal("removed", function(s)
    local wibars = {}
    for _, wibar in ipairs(wiboxes) do
        if wibar._screen == s then
            table.insert(wibars, wibar)
        end
    end
    for _, wibar in ipairs(wibars) do
        wibar:remove()
    end
end)

function awfulwibar.mt:__call(...)
    return awfulwibar.new(...)
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

return setmetatable(awfulwibar, awfulwibar.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
