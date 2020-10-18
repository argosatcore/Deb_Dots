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


--- Cpu information.
--
-- <p>This module contains a provider for cpu information and three
-- gadgets: a text gadget, an icon gadget and a graph gadget.</p>
--
-- <h2>Gadgets</h2>
--
-- <p>The ID of the gadgets designates the CPU slot to be monitored,
-- in the <code>/proc/stat</code> file, as indicated in the provider's
-- documentation below. CPU gadgets provide no custom parameters. See
-- the <a href="flaw.gadget.html">gadget</a> module documentation to
-- learn about standard gadgets parameters.</p>
--
-- <h3>Icon Gadget</h3>
--
-- <p>The CPU icon gadget can be instantiated by indexing the gadget
-- module with <code>icon.cpu</code>. Here is an exemple which assumes
-- the CPU icon path is stored in a <b>beautiful</b> property.</p>
--
-- <div class='example'>
-- g = flaw.gadget.icon.cpu(<br/>
-- &nbsp;&nbsp;&nbsp;'cpu', {}, { image = image(beautiful.cpu_icon) })<br/>
-- </div>
--
-- <h3>Text Gadget</h3>
--
-- <p>The CPU text gadget can be instantiated by indexing the gadget
-- module with <code>text.cpu</code>. By default, the gadget pattern
-- is <code>$load_user/$load_sum</code>. See the provider's
-- documentation below to learn about the available variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.cpu('cpu')
-- </div>
--
-- <h3>Graph Gadget</h3>
--
-- <p>The CPU graph gadget can be instantiated by indexing the gadget
-- module with <code>graph.cpu</code>. By default, the chart displayed
-- by the gadget shows the evolution of <code>load_sum</code>. See the
-- provider's documentation below to learn about the available
-- variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.graph.cpu(<br/>
-- &nbsp;&nbsp;&nbsp;'cpu', {}, { width = 60, height = 18 })
-- </div>
--
-- <h2>Provider</h2>
--
-- <p>The cpu provider loads its information from
-- <code>/proc/stat/</code> and considers the line beginning with
-- <code>cpu</code>. On multi-core machines, multiple
-- <code>cpuNN</code> lines follow the one which begins with only
-- <code>cpu</code>. The complete file format is explained at <a
-- href="http://www.linuxhowtos.org/System/procstat.htm">http://www.linuxhowtos.org/System/procstat.htm</a></p>
--
-- <p>The cpu provider computed data is composed of the following
-- fields.</p>
--
-- <ul>
--
-- <li><code>load_user</code>
--
-- <p>The percentage of time the CPU has spent performing normal
-- processing in user mode.</p></li>
--
-- <li><code>load_nice</code>
--
-- <p>The percentage of time the CPU has spent performing niced
-- processing in user mode.</p></li>
--
-- <li><code>load_sum</code>
--
-- <p>The percentage of time the CPU has spent performing any task in
-- any mode.</p></li>
--
-- </ul>
--
-- The provider data also stores the raw values read from the lines
-- parsed in <code>/proc/stat</code>. This information can be found in
-- <code>raw_sum</code>, <code>raw_user</code>, <code>raw_nice</code>,
-- <code>raw_idle</code>, and is used to compute percentage values.
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2010,2011 David Soulayrol
module('flaw.cpu')

--- The cpu provider prototype.
--
-- <p>The CPU provider type is set to
-- <code>cpu._NAME</code>.</p>
--
-- @class table
-- @name CPUProvider
CPUProvider = flaw.provider.CyclicProvider:new{ type = _NAME, data = {} }

--- Callback for provider refresh.
function CPUProvider:do_refresh()
   local file = io.open('/proc/stat')
   local line = ''

   local id, user, nice, system, idle, diff

   while line ~= nil do
      line = file:read()

      if line ~=nil then
         id, user, nice, system, idle = string.match(
            line, '(%w+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)')

         if id ~=nil and string.find(id, 'cpu') ~= nil then

            if self.data[id] == nil then
               self.data[id] = {
                  raw_user = 0, raw_nice = 0, raw_idle = 0, raw_sum = 0,
                  load_user = 0, load_nice = 0, load_sum = 0 }
            end

            local cpu_sum = user + nice + system + idle
            diff = cpu_sum - self.data[id].raw_sum

            -- The diff should always be positive. If it is not the case,
            -- the load is too heavy for the system to refresh data. In
            -- this case, keep a 100 USER_HZ default value.
            self.data[id].load_user = 100
            self.data[id].load_nice = 100
            self.data[id].load_sum = 100
            if diff > 0 then
               self.data[id].load_user =
                  100 * (user - self.data[id].raw_user) / diff
               self.data[id].load_nice =
                  100 * (nice - self.data[id].raw_nice) / diff
               self.data[id].load_sum =
                  100 - 100 * (idle - self.data[id].raw_idle) / diff
            end

            self.data[id].raw_sum = cpu_sum
            self.data[id].raw_user = user
            self.data[id].raw_nice = nice
            self.data[id].raw_idle = idle
         end
      end
   end
   io.close(file);
end

--- A factory for CPU provider.
--
-- <p>Only one provider is built to store all the CPU information. Its
-- data is a map indexed by CPU slot.</p>
--
-- @return a brand new CPU provider, or the existing one if found in
--         the providers cache.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = CPUProvider:new{ id = '' }
      flaw.provider.add(p)
   end
   return p
end

-- A Text gadget for cpu status display.
flaw.gadget.register.text(_M, { delay = 1, pattern = '$load_user/$load_sum' })

-- A graph gadget for cpu load display.
flaw.gadget.register.graph(_M, { delay = 1, values = { 'load_sum' } })

-- An icon gadget for cpu status display.
flaw.gadget.register.icon(_M, { delay = 1 })
