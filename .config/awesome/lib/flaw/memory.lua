-- flaw, a Lua OO management framework for Awesome WM widgets.
-- Copyright (C) 2009,2010,2011 David Soulayrol <david.soulayrol AT gmail DOT net>

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
local string = string

local beautiful = require('beautiful')
local naughty = require('naughty')

local flaw = {
   helper = require('flaw.helper'),
   gadget = require('flaw.gadget'),
   provider = require('flaw.provider')
}


--- Memory information.
--
-- <p>This module contains a provider for memory status and two
-- gadgets: a text gadget and a graph gadget.</p>
--
-- <h2>Gadgets</h2>
--
-- <p>The ID parameter has no meaning for the memory gadgets. Memory
-- gadgets provide no custom parameters. See the <a
-- href="flaw.gadget.html">gadget</a> module documentation to learn
-- about standard gadgets parameters.</p>
--
-- <h3>Text Gadget</h3>
--
-- <p>The memory text gadget can be instantiated by indexing the
-- gadget module with <code>text.memory</code>. By default, the gadget
-- pattern is <code>$ratio%</code>. See the provider's documentation
-- below to learn about the available variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.memory('')
-- </div>
--
-- <h3>Graph Gadget</h3>
--
-- <p>The memory graph gadget can be instantiated by indexing the
-- gadget module with <code>graph.memory</code>. By default, the chart
-- displayed by the gadget shows the evolution of
-- <code>ratio</code>. See the provider's documentation below to learn
-- about the available variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.graph.memory(<br/>
-- &nbsp;&nbsp;&nbsp;'', {}, { width = 60, height = 18 })
-- </div>
--
-- <h2>Provider</h2>
--
-- <p>The memory provider loads its information from
-- <code>/proc/meminfo/</code>. This file format is explained, among
-- other places, at <a
-- href="http://www.redhat.com/advice/tips/meminfo.html">http://www.redhat.com/advice/tips/meminfo.html</a></p>
--
-- <p>The memory provider computed data is composed of the following
-- field.</p>
--
-- <ul>
--
-- <li><code>ratio</code>
--
-- <p>The percentage of memory currently used.</p></li>
--
-- </ul>
--
-- <p>The provider data also stores the raw values read from the
-- <code>/proc/meminfo</code> file. This information can be found in
-- <code>proc</code> and is composed of the following fields.</p>
--
-- <ul>
--
-- <li><code>proc.meminfo_memtotal</code>
--
-- <p>The memory available on the system.</p></li>
--
-- <li><code>proc.meminfo_cached</code>
--
-- <p>The memory affected to cached data.</p></li>
--
-- <li><code>proc.meminfo_buffers</code>
--
-- <p>The memory affected to application buffers data.</p></li>
--
-- <li><code>proc.meminfo_memfree</code>
--
-- <p>The free memory.</p></li>
--
-- </ul>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2010,2011 David Soulayrol
module('flaw.memory')


--- The memory provider prototype.
--
-- <p>The memory provider type is set to
-- <code>memory._NAME</code>.</p>
--
-- @class table
-- @name MemoryProvider
MemoryProvider = flaw.provider.CyclicProvider:new{ type = _NAME, data = {} }

--- Callback for provider refresh.
function MemoryProvider:do_refresh()
   local p = self.data.proc
   local r = flaw.helper.file.load_state_file('/proc', 'meminfo', p)

   self.data.ratio = 0
   if r > 0 then
      -- Adapt values.
      local total = p.meminfo_memtotal:match('(%d+).*') or 0
      local free = p.meminfo_memfree:match('(%d+).*') or 0
      local buffers = p.meminfo_buffers:match('(%d+).*') or 0
      local cached = p.meminfo_cached:match('(%d+).*') or 0

      if total ~= 0 then
         self.data.ratio = flaw.helper.round(
            100 * (total - free - buffers - cached) / total, 2)
      end
   end
end

--- A factory for memory providers.
--
-- <p>Only one provider is built.</p>
--
-- @return a brand new memory provider, or the existing one if found
--         in the providers cache.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = MemoryProvider:new{
         id = '', data = { ratio = 0, proc = {} } }
      flaw.provider.add(p)
   end
   return p
end


-- A Text gadget for memory status display.
flaw.gadget.register.text(_M, { pattern = '$ratio%' })

-- A graph gadget for memory status history.
flaw.gadget.register.graph(_M, { delay = 1, values = { 'ratio' } })
