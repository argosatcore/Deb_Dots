-- flaw, a Lua OO management framework for Awesome WM widgets.
-- Copyright (C) 2012 David Soulayrol <david.soulayrol AT gmail DOT net>

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
local io = io
local ipairs = ipairs
local os = os
local string = string
local table = table

local dbus = require('dbus')
local image = require('image')

local awful = {
   button = require("awful.button"),
   menu = require("awful.menu"),
   util = require("awful.util"),
}

local flaw = {
   gadget = require('flaw.gadget'),
   helper = require('flaw.helper'), -- DEBUG
   provider = require('flaw.provider')
}

local LANGS = {
   ch = { short = 'CH', long = '中国的' },
   de = { short = 'DE', long = 'Deutsch' },
   en = { short = 'EN', long = 'English' },
   fr = { short = 'FR', long = 'Français', },
   jp = { short = 'JP', long = '日本人', },
   ru = { short = 'РУС', long = 'Русский' },
   us = { short = 'US', long = 'English' },
}

local FLAGS = nil

local function get_current_layout()
   local f = io.popen('dbus-send --print-reply=literal --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.getCurrentLayout')
   local layout = 0

   if f ~= nil then
      line = f:read()
      if line ~= nil then
         layout = line:match('uint32%s+([%d]+)')
      end
   end
   f:close()

   return layout
end


--- Keyboard layout gadget and provider.
--
-- <p>This module contains a provider for keyboard layout information
-- and two gadgets: a text gadget and an icon gadget. This module was
-- written with the help of prior art found on <a
-- href="http://awesome.naquadah.org/wiki/Keyboard_layouts_with_kbdd">this
-- awesome's wiki page</a>.</p>
--
-- <p>The module relies on <code>kbdd</code> dbus notifications to
-- update itself. <code>kbdd</code> in turn relies on
-- <code>Xorg</code> configuration. The <code>Xorg</code> input
-- configuration can be tweaked using the <code>setxkbmap</code> tool.
-- For example:</p>
--
-- <div class='example'>
-- $ setxkbmap -query # displays the current configuration<br/>
-- $ setxkbmap -layout "en,fr,ru" -layout ",latin9,"
-- </div>
--
-- <h2>Gadgets</h2>
--
-- <p>The ID parameter has no meaning for the keyboard gadgets. Those
-- gadgets provide no custom parameters. See the <a
-- href="flaw.gadget.html">gadget</a> module documentation to learn
-- about standard gadgets parameters.</p>
--
-- <p>All keyboard gadgets specialize their standard counterpart to
-- provide a menu for direct selection of a keyboard layout. The
-- buttons 4 and 5 of the mouse - which should normally be bound to
-- the wheel up and down movements - allow you to select the previous
-- and next keyboard layout in the configured list, whereas the left
-- click opens a menu with the whole list.</p>
--
-- <p>Both the Icon and the Text gadgets can automatically display the
-- flag icon matching the curent layout's language. To achieve this,
-- the function <code>set_flags_dict</code> must be called once before
-- creating any gadget. The argument to this function must be a table
-- containing the flags icons paths indexed by the two-letters
-- language codes, in lower case. This dictionnary can be set
-- manually, or could be built automatically by browsing an icons
-- collection. In the following example, a valid table of icon files
-- is built from filenames matching <code>EN.png</code>,
-- <code>FR.png</code>, <code>DE.png</code> and so on:</p>
--
-- <div class='example'>
-- local lfs = require('lfs')<br/>
-- local path = '/home/david/.config/awesome/icons/flags/'<br/>
-- local flags = {}<br/>
-- for file in lfs.dir(path) do<br/>
-- &nbsp;&nbsp;&nbsp;lang = file:match('(%a%a)\.png')<br/>
-- &nbsp;&nbsp;&nbsp;if lang ~= nil then<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;flags[lang:lower()] = path .. file<br/>
-- &nbsp;&nbsp;&nbsp;end<br/>
-- end<br/>
-- flaw.keyboard.set_flags_dict(flags)
-- </div>
--
-- <h3>Icon Gadget</h3>
--
-- <p>The keyboard icon gadget can be instantiated by indexing the gadget
-- module with <code>icon.keyboard</code>.
--
-- <div class='example'>
-- g = flaw.gadget.icon.keyboard('')
-- </div>
--
-- <h3>Text Gadget</h3>
--
-- <p>The keyboard text gadget can be instantiated by indexing the
-- gadget module with <code>text.keyboard</code>. By default, the
-- gadget pattern is <code>'$name'</code>. See the provider's
-- documentation below to learn about the available variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.keyboard('')
-- </div>
--
-- <h2>Provider</h2>
--
-- <p>The keyboard provider is updated by the dbus notifications
-- emitted by <code>kbdd</code> everytime the keyboard layout is
-- modified. Since <code>kbdd</code> remembers the keyboard layout for
-- each window, these notifications can be received when the user
-- explicitly sets a new layout, or when a window with a different
-- layout gets the focus.</p>
--
-- <p>The keyboard provider maintains a table named
-- <code>layouts</code> which stores the currently configured layouts.
-- This list is updated each time a dbus event is received so as to
-- remain synchronized with the <code>Xorg</code> current
-- configuration. When it is updated, the provider's <code>data</code>
-- attribute is also set to the line matching the current layout.</p>
--
-- <p>Each entry of this table is composed of the following
-- fields.</p>
--
-- <ul>
--
-- <li><code>short_name</code>
--
-- <p>A string which represents the current layout's language, in the
-- international two characters form (e.g. 'EN' or 'DE').</p></li>
--
-- <li><code>name</code>
--
-- <p>The full name of the current layout's language (e.g. 'English'
-- or 'Deutsch').</p></li>
--
-- <li><code>img</code>
--
-- <p>The path to the matching flag icon, if the function
-- <code>set_flags_dict</code> was called to initialize the available
-- icons paths.</p></li>
--
-- </ul>
--
-- <p>The provider also holds in its <code>menu</code> attribute the
-- menu which is to be opened when interacting with the gadgets to
-- select a new layout.</p>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2012 David Soulayrol
module('flaw.keyboard')


--- The keyboard provider prototype.
--
-- <p>The keyboard provider type is set to
-- <code>kbd._NAME</code>.</p>
--
-- @class table
-- @name KbdProvider
KbdProvider = flaw.provider.Provider:new{ type = _NAME, menu = nil, layouts = {}, data = {} }

function KbdProvider:update(layout)
   self:update_keyboard_layouts()
   self.data = self.layouts[layout + 1]
   self:refresh_gadgets()
end

-- Read the keyboard layouts configured list.
function KbdProvider:update_keyboard_layouts()
   local f = io.popen('setxkbmap -query')
   local menu_items = {}
   local idx = 0
   local img = nil
   self.layouts = {}

   if f ~= nil then
      local line = nil
      repeat
         line = f:read()
         if line then
            list = line:match('layout:%s+([,%a]+)')
            if list ~= nil then
               for token in string.gmatch(list, '[^,]+') do
                  if FLAGS ~= nil then
                     img = FLAGS[token]
                  end
                  table.insert(self.layouts, { short_name = LANGS[token].short, name = LANGS[token].long, img = img })
                  table.insert(menu_items, { LANGS[token].long, _M.set_layout(idx), img })
                  idx = idx + 1
               end
            end
         end
      until line == nil
      f:close()
   end

   self.menu = awful.menu({ items = menu_items })
end


--- A factory for keyboard providers.
--
-- <p>Only one provider is built.</p>
--
-- @return a brand new keyboard provider, or the existing one if found
--         in the providers cache.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = KbdProvider:new{id = ''}
      p:update_keyboard_layouts()
      p.data = p.layouts[get_current_layout() + 1]
      flaw.provider.add(p)
   end
   return p
end


--- A Text gadget for current keyboard layout display.
--
-- <p>This specialized text gadget is able to display a flag in the
-- text background.</p>
KbdTextGadget = flaw.gadget.TextGadget:new{}

-- Create the wrapped gadget.
function KbdTextGadget:create(wopt)
   flaw.gadget.TextGadget.create(self, wopt)
   self.widget:buttons(
      awful.util.table.join(
        awful.button({ }, 1, function() self.provider.menu:toggle () end),
        awful.button({ }, 4, _M.set_previous_layout),
        awful.button({ }, 5, _M.set_next_layout)))
end

function KbdTextGadget:redraw()
   flaw.gadget.TextGadget.redraw(self)
   self.widget.bg_image = image(self.provider.data.img)
end


-- An icon gadget for current keyboard layout display.
KbdIconGadget = flaw.gadget.IconGadget:new{}

-- Create the wrapped gadget.
function KbdIconGadget:create(wopt)
   flaw.gadget.IconGadget.create(self, wopt)
   self.widget:buttons(
      awful.util.table.join(
        awful.button({ }, 1, function() self.provider.menu:toggle () end),
        awful.button({ }, 4, _M.set_previous_layout),
        awful.button({ }, 5, _M.set_next_layout)))
end

function KbdIconGadget:redraw()
   if self.flags ~= nil then
      self.widget.image = image(self.flags[provider.data.short])
   end
end


--- Module initialization routine.
--
-- <p> This method tests the available information on the system. If
-- kbdd is up and ready, it registers gadgets and returns the
-- module; otherwise it simply returns nil.</p>
--
-- @return return this module if it can be used on the system,
--         nil otherwise.
function init()
   if dbus and dbus.request_name('session', 'ru.gentoo.kbdd') then
      -- TODO: request_name returns ok even if the daemon is not running.

      dbus.add_match('session', "interface='ru.gentoo.kbdd',member='layoutChanged'")
      dbus.add_signal('ru.gentoo.kbdd', function(...)
                                           local data = {...}
                                           provider_factory():update(data[2])
                                        end)

      flaw.gadget.register.text(_M, { pattern = '$short_name' }, { align = 'center' }, KbdTextGadget)
      flaw.gadget.register.icon(_M, {}, {}, KbdIconGadget)

      return _M
   end
end

--- Set the flag icons dictionnary.
--
-- <p>This function must be called once to display flag icons in the
-- gadgets.</p>
function set_flags_dict(dict)
   FLAGS = dict
end

--- Explicitly set the previous configured keyboard layout.
function set_previous_layout()
   os.execute('dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.prev_layout')
end

--- Excplicitly set the next configured keyboard layout.
function set_next_layout()
   os.execute('dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.next_layout')
end

--- Set the keyboard layout specified by the given index.
--
-- <p>The index in the order number in the <code>Xorg</code>
-- configuration. It starts from 0.</p>
function set_layout(layout)
   return function()
             os.execute('dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.set_layout uint32:' .. layout)
          end
end
