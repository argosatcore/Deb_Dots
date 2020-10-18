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
local ipairs = ipairs

local naughty = require('naughty')
local table = require('table')

local service_modules = { loaded = {}, dropped = {}, invalid = {} }

local function load_flaw_component(name)
   local m = require('flaw.' .. name)
   if m then
      if m.init ~= nil then
         m = m.init()
      end
      if m ~= nil then
         table.insert(service_modules.loaded, name)
      else
         table.insert(service_modules.dropped, name)
      end
   else
      table.insert(service_modules.invalid, name)
   end
   return m
end

local function get_nb_modules(section)
   return # service_modules[section]
end

local function get_modules_names(section)
   local str = ''
   for _, v in ipairs(service_modules[section]) do
      str = str .. v .. ' '
   end
   return str
end

-- Essential modules.
require('flaw.gadget')
require('flaw.provider')
require('flaw.event')
require('flaw.helper')

-- Service modules.
load_flaw_component('alsa')
load_flaw_component('battery')
load_flaw_component('calendar')
load_flaw_component('cpu')
load_flaw_component('gmail')
load_flaw_component('keyboard')
load_flaw_component('memory')
load_flaw_component('network')
load_flaw_component('title')
load_flaw_component('wifi')


--- Introduction to the core concepts and mechanisms.
--
-- <p>The <b>flaw</b> package is composed of core modules which
-- provide the raw mechanisms and utilities, and service modules which
-- build upon this core to propose interesting gadgets with their
-- associated information sources.</p>
--
-- <p>Hereafter are described the core concepts developed by
-- <b>flaw</b>. Users also should have a look at the service modules
-- they are interested in. Developers may read the core modules
-- documentation before doing more complicated things.</p>
--
-- <h2>Setup</h2>
--
-- <p>The following statement must be inserted in the <b>awesome</b>
-- configuration before any <b>flaw</b> gadget or mechanism can be
-- used. Such a statement is usually written at the top of the
-- configuration file, where <b>naughty</b>, <b>beautiful</b> or
-- others modules are declared.</p>
--
-- <div class='example'>
-- require('flaw')<br/>
-- </div>
--
-- <p>When this statement is parsed at start up, each of the non-core
-- modules referenced in <b>flaw</b>'s <code>init.lua</code> are
-- loaded and then register the gadgets they provide, and a factory
-- for their associated provider. All this information is maintained
-- in a table in the <a href="flaw.gadget.html">gadget</a> core
-- module, and is ready to be used to instantiate gadgets.</p>
--
-- <h2>Gadgets</h2>
--
-- <p>Gadgets are a wrapper around <b>awful</b> widgets that provide
-- an automated way to react asynchronously on some hardware or
-- software events. The <a href="flaw.gadget.html">gadget</a> core
-- module provides the main gadgets factory and management.</p>
--
-- <p>Gadgets are divided in types which are named after the kinds of
-- widgets <b>awesome</b> provides: <code>Text</code>,
-- <code>Icon</code>, <code>Graph</code> and <code>ProgressBar</code>
-- (which is reduced to <code>Bar</code> in <b>flaw</b>). Thanks to
-- some nifty tricks, creating a gadget is straight forward. As an
-- example, the following statement instantiates a very simple gadget
-- which displays the title of the focused window.</p>
--
-- <div class='example'>
-- gtitle = flaw.gadget.text.title('')
-- </div>
--
-- <p>The <a href="flaw.gadget.html">gadget</a> module is indexed
-- first with the type of the desired gadget, and then with its
-- name. <code>title</code> is actually one of the service modules
-- which were loaded at start up, and which have registered a
-- <code>Text</code> gadget. Note that the parameter is required,
-- while not useful to this gadget (hence the empty string).</p>
--
-- <p>Here is a moderately complicated example which builds an
-- <b>awful</b> 60x18 graph widget which is updated every 5 seconds
-- with the current CPU activity.</p>
--
-- <div class='example'>
-- gcpu = flaw.gadget.graph.cpu('cpu',<br/>
-- &nbsp;&nbsp;&nbsp;{ delay = 5 }, { width = 60, height = 18 })<br/>
-- </div>
--
-- <p>The <a href="flaw.gadget.html">gadget</a> module is indexed
-- first with the <code>graph</code> type, and then with the
-- <code>cpu</code> gadget name. Indeed, the <code>cpu</code> module
-- registers a <code>Text</code>, a <code>Graph</code> and an
-- <code>Icon</code> gadget when loaded. Here the required first
-- parameter designates the cpu to be monitored. The second and third
-- parameters are respectively the gadget and the wrapped widget
-- options.</p>
--
-- <p>Here is now how these two gadgets can be embedded in a
-- <i>wibox</i> with a layout box and a tags list.</p>
--
-- <div class='example'>
-- for s = 1, screen.count() do<br/>
-- &nbsp;&nbsp;&nbsp;mylayoutbox[s] = awful.widget.layoutbox(s)<br/>
-- &nbsp;&nbsp;&nbsp;mytaglist[s] = awful.widget.taglist(<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;s, awful.widget.taglist.label.all, mytaglist.buttons))<br/>
-- &nbsp;&nbsp;&nbsp;mywibox[s] = awful.wibox({ position = "top", screen = s })<br/>
-- &nbsp;&nbsp;&nbsp;<br/>
-- &nbsp;&nbsp;&nbsp;-- Add widgets to the wibox - order matters<br/>
-- &nbsp;&nbsp;&nbsp;mywibox[s].widgets = {<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mytaglist[s],<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;gcpu.widget,<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;gtitle.widget,<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;layout = awful.widget.layout.horizontal.leftright<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;},<br/>
-- &nbsp;&nbsp;&nbsp;mylayoutbox[s],<br/>
-- &nbsp;&nbsp;&nbsp;layout = awful.widget.layout.horizontal.rightleft<br/>
-- &nbsp;&nbsp;&nbsp;}<br/>
-- end<br/>
-- </div>
--
-- <h2>Providers</h2>
--
-- <p>Providers are the objects that gather data to feed a gadget. The
-- <a href="flaw.provider.html">provider</a> core module provides the
-- roots of the data mining objects.</p>
--
-- <p>Creating a gadget automatically registers itself to a provider
-- so that the displayed information is refreshed at the requested
-- pace. Providers can be shared among gadgets, and only refresh their
-- data according to the smallest gadget refresh rate.</p>
--
-- <p>No user action is required for this mechanism. However, the
-- refresh rate of a gadget can be tuned using the <code>delay</code>
-- gadget option. As seen in the gadgets description above, it
-- defaults to 10 seconds.</p>
--
-- <h2>Events</h2>
--
-- <p>The automated and efficient refresh loop of <b>flaw</b> is the
-- core of its design. It provides cyclic data updates to gadgets
-- which display it in accordance with their type. Events were
-- introduced to provide the capability to react to some data values,
-- and to do something else than just displaying them. This mechanism
-- is available to all of gadgets and is implemented in the <a
-- href="flaw.event.html">event</a> core module.</p>
--
-- <p>Events are made of a trigger and an action. The trigger's
-- condition takes the provider's data and is tested each time a
-- refresh is called. If it returns true, the event's action is then
-- fired, with the gadget as parameter. It can do absolutely anything,
-- and its return value has no meaning for <b>flaw</b>.</p>
--
-- <p>Here is an example assuming <code>g</code> is a battery icon
-- gadget and <code>battery_low_icon</code> a beautiful property
-- holding the path to an explicit low battery icon. This snippet
-- changes of the gadget when the battery load gets really low.</p>
--
-- <div class='example'>
-- g.add_event(<br/>
-- &nbsp;&nbsp;&nbsp;flaw.event.LatchTriger:new{
-- condition = function(d) return d.load &lt; 9 end },<br/>
-- &nbsp;&nbsp;&nbsp;function(g) g.widget.image =
-- image(beautiful.battery_low_icon) end)
-- </div>
--
-- <h2>Writing a new service module</h2>
--
-- <p><b>FIXME</b></p>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2010,2011, David Soulayrol
module("flaw")

--- Notify the dropped service modules to the user.
--
-- <p>This function pops up a notification displaying a list of
-- modules which were not loaded. These checked modules are those
-- which depend on hardware or sources that can be absent from some
-- system, like the battery.</p>
--
-- <p>This function can typically be called at the end of the
-- configuration file, or on demand to check the flaw library status.</p>
function check_modules()
   if get_nb_modules('dropped') ~= 0 then
      naughty.notify{
         title = "Flaw",
         text = "The following modules are absent from your system:\n"
            .. get_modules_names('dropped'),
         timeout = 12,
         position = "top_right"}
   end
end

--- Check the availability of a service module.
--
-- @param m the name of the service module to check.
-- @return true if the module was loaded, false otherwise. Note that
--         loaded means here that the module was correctly parsed and
--         has registered the provider or the gadgets it contains.
function check_module(m)
   for _, v in ipairs(service_modules['loaded']) do
      if m == v then return true end
   end
   return false
end
