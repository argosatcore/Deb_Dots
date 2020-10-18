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
local capi = {
   client = client,
}

local awful = {
   util = require("awful.util"),
}

local flaw = {
   gadget = require('flaw.gadget'),
   provider = require('flaw.provider'),
   helper = require('flaw.helper'),
}

--- Clients title display.
--
-- <p>This module contains a simple text gadget which displays the
-- title of the active client, and its provider. This is a convenient
-- way to see the window title displayed, even if the window bar is
-- not displayed.</p>
--
-- <h2>Gadget</h2>
--
-- <p>The title gadget can be instantiated by indexing the gadget
-- module with <code>text.title</code>. The ID parameter has no
-- meaning for the calendar gadget, and it takes no particular
-- parameters. See the <a href="flaw.gadget.html">gadget</a> module
-- documentation to learn about standard gadgets parameters.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.title('')
-- </div>
--
-- <h2>Provider</h2>
--
-- <p>The provider makes no hardware or software access whatsoever. It
-- simply plugs its <code>update</code> method on the
-- <code>focus</code>, <code>unfocus</code> and
-- <code>property::name</code> signals. This also means the
-- <code>delay</code> parameter has no meaning for it.</p>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2010,2011 David Soulayrol
module('flaw.title')

--- The client events provider prototype.
--
-- <p>The client title provider type is set to
-- <code>title._NAME</code>.</p>
--
-- @class table
-- @name ClientProvider
ClientProvider = flaw.provider.Provider:new{ type = _NAME }

--- Display the new client title.
function ClientProvider:update(c)
   if c and c.name and capi.client.focus == c then
      self.data.title = awful.util.escape(c.name)
      self:refresh_gadgets()
   end
end

--- Erase the client title.
function ClientProvider:reset(c)
   if c then
      self.data.title = ''
      self:refresh_gadgets()
   end
end

--- A factory for client providers.
--
-- @return a brand new client provider.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = ClientProvider:new{ id = '', data = { title = '' } }
      flaw.provider.add(p)

      -- Init signals once for the provider.
      capi.client.add_signal(
         'manage',
         function (c, startup)
            c:add_signal('property::name',
                         function(c)
                            p:update(c)
                         end)
         end)
      capi.client.add_signal('focus', function(c) p:update(c) end)
      capi.client.add_signal('unfocus', function(c) p:reset(c) end)
   end
   return p
end


-- A Text gadget prototype for clients title display.
flaw.gadget.register.text(_M, { pattern = '$title' })
