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
local math = math
local tonumber = tonumber
local os = os
local string = string

local beautiful = require('beautiful')
local naughty = require('naughty')

local flaw = {
   helper = require('flaw.helper'),
   gadget = require('flaw.gadget'),
   provider = require('flaw.provider')
}


--- Network activity.
--
-- <p>This module contains a provider for network status and activity
-- and three gadgets: a text gadget, an icon gadget and a graph
-- gadget.</p>
--
-- <h2>Gadgets</h2>
--
-- <p>The ID of the gadgets designates the network device to be
-- monitored, in the <code>/proc/net/dev</code> file, as indicated in
-- the provider's documentation below. Network gadgets provide no
-- custom parameters. See the <a href="flaw.gadget.html">gadget</a>
-- module documentation to learn about standard gadgets
-- parameters.</p>
--
-- <h3>Icon Gadget</h3>
--
-- <p>The network icon gadget can be instantiated by indexing the
-- gadget module with <code>icon.network</code>. Here is an exemple
-- which assumes the icon path is stored in a <b>beautiful</b>
-- property.</p>
--
-- <div class='example'>
-- g = flaw.gadget.icon.network(<br/>
-- &nbsp;&nbsp;&nbsp;'eth0', {}, { image = image(beautiful.net_icon) })<br/>
-- </div>
--
-- <h3>Text Gadget</h3>
--
-- <p>The network text gadget can be instantiated by indexing the
-- gadget module with <code>text.network</code>. By default, the
-- gadget pattern is <code>in:$net_in out:$net_out</code>. See the
-- provider's documentation below to learn about the available
-- variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.network('wlan0')
-- </div>
--
-- <h3>Graph Gadget</h3>
--
-- <p>The network graph gadget can be instantiated by indexing the
-- gadget module with <code>graph.network</code>. By default, the
-- chart displayed by the gadget shows the evolution of
-- <code>percents_in</code>. See the provider's documentation below to
-- learn about the available variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.graph.network(<br/>
-- &nbsp;&nbsp;&nbsp;'eth1', {}, { width = 60, height = 18 })
-- </div>
--
-- <h2>Provider</h2>
--
-- <p>The network provider loads its information from
-- <code>/proc/net/dev</code>. It stores the data for each line, which
-- represent the network devices of the machine. The file format is
-- explained in the <code>proc</code> manual page (for example at <a
-- href="http://linux.die.net/man/5/proc">http://linux.die.net/man/5/proc</a></p>
--
-- <p>The network provider computed data is composed of the following
-- fields.</p>
--
-- <ul>
--
-- <li><code>net_in</code>
--
-- <p>The number of packets received by the monitored interface
-- between two updates of the provider.</p></li>
--
-- <li><code>net_out</code>
--
-- <p>The number of packets emitted by the monitored interface
-- between two updates of the provider.</p></li>
--
-- <li><code>all_net_in</code>
--
-- <p>The total number of packets received by the monitored interface
-- since the machine start up.</p></li>
--
-- <li><code>all_net_out</code>
--
-- <p>The total number of packets emitted by the monitored interface
-- since the machine start up.</p></li>
--
-- <li><code>percents_in</code>
--
-- <p>The incoming data load in percents on the monitored
-- interface. This value is for now computed with a hard-coded maximum
-- value of 256000 (in <code>DL_BANDWIDTH</code>).</p></li>
--
-- <li><code>percents_out</code>
--
-- <p>The ougoing data load in percents on the monitored
-- interface. This value is for now computed with a hard-coded maximum
-- value of 64000 (in <code>UP_BANDWIDTH</code>).</p></li>
--
-- </ul>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2010,2011 David Soulayrol
module('flaw.network')


-- Bandwidth in bytes.
-- TODO: should become a parameter for the provider.
DL_BANDWIDTH = 256000
UP_BANDWIDTH = 64000

--- The network provider prototype.
--
-- <p>The network provider type is set to
-- <code>network._NAME</code>.</p>
--
-- @class table
-- @name NetworkProvider
NetworkProvider = flaw.provider.CyclicProvider:new{ type = _NAME }

--- Callback for provider refresh.
function NetworkProvider:do_refresh()
   local file = io.open('/proc/net/dev')
   local sep
   local adapter
   local line = ''
   local input, output

   while line ~= nil do
      line = file:read()

      if line ~= nil then
         -- Skip the adapter prefix.
         sep = string.find (line, ':')
         if sep ~= nil then
            adapter = flaw.helper.strings.lstrip(string.sub(line, 0, sep - 1))
            if adapter ~= nil then
               if self.data[adapter] == nil then
                  self.data[adapter] = {
                     all_net_in = 0, all_net_out = 0, net_in = 0, net_out = 0 }
               end
               -- First decimal number are total bytes
               local split_line = flaw.helper.strings.split(
                  string.sub(line, sep + 1))
               local interval = os.time() - self.timestamp

               input = tonumber(split_line[1])
               output = tonumber(split_line[9])

               self.data[adapter].net_in =
                  (input - self.data[adapter].all_net_in) / interval
               self.data[adapter].net_out =
                  (output - self.data[adapter].all_net_out) / interval

               self.data[adapter].percents_in =
                  (self.data[adapter].net_in / DL_BANDWIDTH) * 100
               self.data[adapter].percents_out =
                  (self.data[adapter].net_out / UP_BANDWIDTH) * 100

               self.data[adapter].all_net_in = input
               self.data[adapter].all_net_out = output
            end
         end
      end
   end
   io.close(file);
end

--- A factory for network providers.
--
-- <p>Only one provider is built for all network adapters. Its data is
-- a map indexed by the name of the interface.</p>
--
-- @return a brand new network provider, or the existing one if found
--         in the providers cache.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = NetworkProvider:new{ id = '', data = {} }
      flaw.provider.add(p)
   end
   return p
end

-- An icon gadget for network status display.
flaw.gadget.register.icon(_M, { delay = 1 })

-- A Text gadget for network status display.
flaw.gadget.register.text(_M, { delay = 1, pattern = 'in:$net_in out:$net_out' })

-- A graph gadget for network load display.
flaw.gadget.register.graph(_M, { delay = 1, values = { 'percents_in' } })
