-- flaw, a Lua OO management framework for Awesome WM widgets.
-- Copyright (C) 2010,2011 David Soulayrol <david.soulayrol AT gmail DOT net>

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


-- Grab environment.
local math = math
local os = os
local string = string
local table = table
local tostring = tostring

local capi = {
   client = client,
   mouse = mouse,
   wibox = wibox,
   widget = widget,
}

local awful = {
   button = require("awful.button"),
   placement = require("awful.placement"),
   util = require("awful.util"),
   widget = require("awful.widget"),
}

local flaw = {
   gadget = require('flaw.gadget'),
   provider = require('flaw.provider'),
   helper = require('flaw.helper'),
}

--- A Calendar.
--
-- <p>This module contains a text gadget and a provider to display a
-- calendar. It was written thanks to the original calendar module
-- proposed at <a
-- href="http://awesome.naquadah.org/wiki/Calendar_widget">http://awesome.naquadah.org/wiki/Calendar_widget</a>.</p>
--
-- <h2>Gadget</h2>
--
-- <p>The calendar gadget can be instantiated by indexing the gadget
-- module with <code>text.calendar</code>. The ID parameter has no
-- meaning for the calendar gadget, and it takes no particular
-- parameters. See the <a href="flaw.gadget.html">gadget</a>
-- module documentation to learn about standard gadgets
-- parameters.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.calendar('')
-- </div>
--
-- <p>When the mouse gets over the gadget, a floating
-- <code>wibox</code> is displayed to present a month view. The
-- buttons 4 and 5 of the mouse - which should normally be bound to
-- the wheel up and down movements - allow you to change the displayed
-- month. With the help of the <code>shift</code> key, the year is
-- changed.</p>
--
-- <h2>Provider</h2>
--
-- <p>The provider makes no hardware or software access whatsoever. It
-- simply builds a textual month view for the calendar gadget. This
-- also means the <code>delay</code> parameter has no meaning for
-- it.</p>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2010,2011, David Soulayrol
module('flaw.calendar')

--- The calendar provider prototype.
--
-- <p>The calendar provider type is set to
-- <code>calendar._NAME</code>.</p>
--
-- @class table
-- @name CalendarProvider
CalendarProvider = flaw.provider.Provider:new{ type = _NAME }

function CalendarProvider:subscribe(g)
   if flaw.provider.Provider.subscribe(self, g) then
      -- Initial update.
      g:update()
      return true
   end
   return false
end

function CalendarProvider:set_month(m)
   self.data.month = self.data.month + (m or 1)
   self:build_simple_view()
end

function CalendarProvider:build_simple_view()
   local t = os.time{ year = self.data.year, month = self.data.month + 1, day = 0 }
   local d = os.date('*t', t)
   local mthDays, stDay= d.day, (d.wday - d.day) % 7
   local lines = {}

   for x = 0, 6 do
      lines[x+1] = os.date(
         "%a ", os.time{ year = 2006, month = 1, day = x + 1 })
   end
   lines[8] = "    "

   local writeLine = 1
   while writeLine < (stDay + 1) do
      lines[writeLine] = lines[writeLine] .. "   "
      writeLine = writeLine + 1
   end

   for x = 1, mthDays do
      if writeLine == 8 then
         writeLine = 1
      end
      if writeLine == 1 or x == 1 then
         lines[8] = lines[8] .. os.date(
            " %V",os.time{ year = self.data.year, month = self.data.month, day = x })
      end
      if (#(tostring(x)) == 1) then
         x = " " .. x
      end
      lines[writeLine] = lines[writeLine] .. " " .. x
      writeLine = writeLine + 1
   end
   local header = os.date(
      "%B %Y\n", os.time{ year = self.data.year, month = self.data.month, day = 1 })
   header = string.rep(
      " ", math.floor((#(lines[1]) - #header) / 2 )) .. header

   self.data.v_simple = string.format(
      '<span font_desc="%s">%s</span>', 'monospace',
      header .. table.concat(lines, '\n'))
   self:refresh_gadgets()
end

--- A factory for calendar providers.
--
-- <p>Only one provider is built.</p>
--
-- @return a brand new calendar provider, or the existing one if the
--         found in the providers cache.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = CalendarProvider:new{
         id = '', data = { month = os.date('%m'), year = os.date('%Y'),
                           v_simple = '', v_remind = '', v_events = '' } }
      p:build_simple_view()
      flaw.provider.add(p)
   end
   return p
end


--- A Gadget prototype for calendar display.
--
-- @class table
-- @name CalendarGadget
CalendarGadget = flaw.gadget.Gadget:new{}

-- Create the wrapped gadget.
function CalendarGadget:create(wopt)
   self.widget = awful.widget.textclock(
      awful.util.table.join(wopt, { name = self.id }), self.clock_format)

   self.wibox = capi.wibox{}
   self.wibox.visible = false
   self.wibox.ontop = true
   self.wibox.widgets = { capi.widget{ type = "textbox", name = 'calendar' } }

   self.widget:add_signal("mouse::enter", function() self:popup() end)
   self.widget:add_signal("mouse::leave", function() self:collapse() end)
   self.wibox:add_signal("mouse::enter", function() self:collapse() end)

   self.widget:buttons(
      awful.util.table.join(
         awful.button({}, 4, function() self.provider:set_month(-1) end),
         awful.button({}, 5, function() self.provider:set_month(1) end),
         awful.button({ 'Shift' }, 4, function() self.provider:set_month(-12) end),
         awful.button({ 'Shift' }, 5, function() self.provider:set_month(12) end)))
end

function CalendarGadget:redraw()
   if self.provider ~= nil and self.provider.data ~= nil then
      self.wibox.widgets[1].text = self.provider.data.v_simple

      local size = self.wibox.widgets[1]:extents()
      self.wibox.width = size.width + 10
      self.wibox.height = size.height + 10
   end
end

function CalendarGadget:popup()
   if self.wibox.visible then return end

   self.wibox.screen = capi.mouse.screen
   awful.placement.under_mouse(self.wibox)
   awful.placement.no_offscreen(self.wibox)

   self.wibox.visible = true
end

function CalendarGadget:collapse()
   self.wibox.visible = false
end

flaw.gadget.register.text(_M, {}, {}, CalendarGadget)
