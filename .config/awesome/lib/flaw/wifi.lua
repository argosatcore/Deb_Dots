-- flaw, a Lua OO management framework for Awesome WM widgets.
-- Copyright (C) 2011 David Soulayrol <david.soulayrol AT gmail DOT net>

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
local tonumber = tonumber

local lfs = require('lfs')

local flaw = {
   gadget = require('flaw.gadget'),
   helper = require('flaw.helper'),
   provider = require('flaw.provider')
}


--- Wifi information.
--
-- <p>This module contains a provider for wifi information and two
-- gadgets: a text gadget and an icon gadget.</p>
--
-- <h2>Gadgets</h2>
--
-- <p>The ID of the gadgets designates the network device to be
-- monitored. Wifi gadgets provide no custom parameters. See the <a
-- href="flaw.gadget.html">gadget</a> module documentation to learn
-- about standard gadgets parameters.</p>
--
-- <h3>Icon Gadget</h3>
--
-- <p>The wifi icon gadget can be instantiated by indexing the
-- gadget module with <code>icon.wifi</code>. Here is an exemple
-- which assumes the icon path is stored in a <b>beautiful</b>
-- property.</p>
--
-- <div class='example'>
-- g = flaw.gadget.icon.wifi(<br/>
-- &nbsp;&nbsp;&nbsp;'wlan0', {}, { image = image(beautiful.wifi_icon) })<br/>
-- </div>
--
-- <h3>Text Gadget</h3>
--
-- <p>The wifi text gadget can be instantiated by indexing the
-- gadget module with <code>text.wifi</code>. By default, the
-- gadget pattern is <code>$essid: $rate Mb/s</code>. See the
-- provider's documentation below to learn about the available
-- variables.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.wifi('wlan1')
-- </div>
--
-- <h2>Provider</h2>
--
-- <p>The wifi provider loads its information from
-- <code>iwconfig</code> output (generally from the wireless-tools
-- package). The use of <code>iwconfig</code> was prefered to
-- <code>iwgetid</code> (which output if far simpler to parse) because
-- it returns all data at once and so limits the number of processes
-- to launch.</p>
--
-- <p>The wifi provider stores the data for each configured wireless
-- device at once. Data is composed of the following fields.</p>
--
-- <ul>
--
-- <li><code>essid</code>
--
-- <p>The name of the network the device is connected to (or
-- <code>N/A</code>).</p></li>
--
-- <li><code>mode</code>
--
-- <p>The mode of the wireless connection (generally
-- <code>Managed</code> or <code>Ad-Hoc</code>).</p></li>
--
-- <li><code>channel</code>
--
-- <p>The channel used by the wireless connection, as a
-- number</p></li>
--
-- <li><code>freq</code>
--
-- <p>The frequency used by the wireless adapter as a number in
-- MHz.</p></li>
--
-- <li><code>ap</code>
--
-- <p>The wireless access-point MAC address.</p></li>
--
-- <li><code>rate</code>
--
-- <p>The connection bit rate, as a number in Mb/s.</p></li>
--
-- <li><code>quality</code>
--
-- <p>The link quality as returned by <code>iwconfig</code>, in its
-- fraction format.</p></li>
--
-- <li><code>level</code>
--
-- <p>Ths signal level as a number.</p></li>
--
-- </ul>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2011, David Soulayrol
module('flaw.wifi')


--- The wifi provider prototype.
--
-- <p>The wifi provider type is set to <code>wifi._NAME</code>.</p>
--
-- @class table
-- @name WifiProvider
WifiProvider = flaw.provider.CyclicProvider:new{ type = _NAME }


--- Parse one entry from <code>iwconfig</code> output.
--
-- @param bloc the text representing information for one device. The
--        first characters of this bloc are the name of the device
--        which is analysed.
function WifiProvider:parse_adapter_info(bloc)
   local adapter = string.match(bloc, '([%w%d]+)')
   self.data[adapter] = {}

   self.data[adapter].essid =
      string.match(bloc, 'ESSID[=:]"(.-)"') or 'N/A'
   self.data[adapter].ap =
      string.match(bloc, 'Access Point[=:] ([%w%d%:]+)') or 'No Access-Point'
   self.data[adapter].mode =
      string.match(bloc, "Mode[=:]([%w%-]*)") or ''
   self.data[adapter].freq =
      tonumber(string.match(bloc, "Frequency[=:]([%d%.]+)")) or 0
   self.data[adapter].channel =
      tonumber(string.match(bloc, "Channel[=:]([%d]+)")) or 0
   self.data[adapter].rate =
      tonumber(string.match(bloc, "Bit Rate[=:]([%s]*[%d%.]*)")) or 0
   self.data[adapter].quality =
      string.match(bloc, "Link Quality[=:]([%d]+/[%d]+)") or 'N/A'
   self.data[adapter].level =
      tonumber(string.match(bloc, "Signal level[=:]([%-]?[%d]+)")) or 0
end

--- Callback for provider refresh.
function WifiProvider:do_refresh()
   local file = io.popen('/sbin/iwconfig 2> /dev/null', 'r')
   local content = ''
   local line = false

   if file then
      while line ~= nil do
         line = file:read()
         if line == '' then
            self:parse_adapter_info(content)
         elseif line ~= nil then
            content = content .. line
         end
      end
      file:close()
   end
end

--- A factory for wifi providers.
--
-- <p>Only one provider is built for all wireless adapters. Its data
-- is a map indexed by the name of the wireless device.</p>
--
-- @return a brand new wireless provider, or the existing one if found
--         in the providers cache.
function provider_factory()
   local p = flaw.provider.get(_NAME, '')
   -- Create the provider if necessary.
   if p == nil then
      p = WifiProvider:new{ id = '', data = {} }
      flaw.provider.add(p)
   end
   return p
end

--- Module initialization routine.
--
-- <p>This method tests the available information on the system. If
-- wireless devices can can be found, it registers gadgets and returns
-- the module; otherwise it simply returns nil.</p>
--
-- @return return this module if it can be used on the system,
--         false otherwise.
function init()
   local file = '/proc/net/wireless'
   if lfs.attributes(file, 'mode') == 'file' then
      local t = {}
      if flaw.helper.file.load_state_file('', file, t) > 0 then

         -- An icon gadget prototype for wifi status display.
         flaw.gadget.register.icon(_M)

         -- A Text gadget prototype for wifi status display.
         flaw.gadget.register.text(_M, { pattern = '$essid: $rate Mb/s' })

         return _M
      end
   end
end
