-- flaw, a Lua OO management framework for Awesome WM widgets.
-- Copyright (C) 2009,2011 David Soulayrol <david.soulayrol AT gmail DOT net>

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
local setmetatable = setmetatable


--- Core events objects.
--
-- <p>Events are a way for the user to modify the gadget behaviour or
-- properties when certain conditions are met. An event is composed of
-- a trigger, which computes the condition, and an action.</p>
--
-- <h2>Trigger and Action</h2>
--
-- <p>The trigger is an object which takes a condition and provides
-- some status depending of its type. The trigger is tested each time
-- the gadget's provider refreshes its data, and the action called if
-- the event fires. There are three kind of triggers; the simple <a
-- href='#Trigger'><code>Trigger</code></a>, the <a
-- href='#LatchTrigger'><code>LatchTrigger</code></a> and the <a
-- href='#EdgeTrigger'><code>EdgeTrigger</code></a> described
-- below. All depend on the condition function but fire the event
-- differently, depending on their previous status.</p>
--
-- <p>The condition function takes one parameter which is the data
-- table updated by the provider. This table layout depends on the
-- provider and is detailed in the provider documentation. The
-- condition function shall return true if its conditions are met, or
-- false otherwise. The event will then fire depending on its
-- type.</p>
--
-- <p>The action function takes the gadget as parameter. It can do
-- absolutely anything, and its return value has no meaning for
-- <b>flaw</b>.</p>
--
-- <h2>Usage</h2>
--
-- <p>Condition and action are written by the user. Events must be
-- registered to a gadget, which in turn registers the trigger to its
-- provider.</p>
--
-- <div class='example'>
-- t = flaw.event.LatchTrigger:new{<br/>
-- &nbsp;&nbsp;&nbsp;condition = function(d) return d.load &lt; 25 end },<br/>
-- a = function(g) g.pattern = '&lt;bg color="#ff6565"/&gt;$load%' end<br/>
-- gadget:add_event(e, a)<br/>
-- </div>
--
-- <p>Assuming <code>g</code> is a battery icon gadget created as
-- above and <code>battery_low_icon</code> a beautiful property
-- holding the path to an explicit low battery icon, here is a short
-- snippet to change the icon in a gadget when the battery load gets
-- really low.</p>
--
-- <div class='example'>
-- g.add_event(<br/>
-- &nbsp;&nbsp;&nbsp;flaw.event.LatchTriger:new{
-- condition = function(d) return d.load &lt; 9 end },<br/>
-- &nbsp;&nbsp;&nbsp;function(g) g.widget.image =
-- image(beautiful.battery_low_icon) end)
-- </div>
--
-- <p>It is important to carefully choose the correct trigger for the
-- event to be raised. The <a
-- href='#LatchTrigger'><code>LatchTrigger</code></a> object used here
-- will make the event happen only at the moment the load gets under 9
-- percents. If the percentage of load remains under 9, the event will
-- not be triggered again. If a raw <a
-- href='#Trigger'><code>Trigger</code></a> object had been used, the
-- event would be triggered again at each provider's refresh.</p>
--
-- <p> If a repeated refresh can be considered as a minor optimisation
-- issue here, it can become a really annoying problem, like in the
-- following sample where <b>naughty</b> is used to be notified if the
-- same situation.</p>
--
-- <div class='example'>
-- g.add_event(<br/>
-- &nbsp;&nbsp;&nbsp;flaw.event.LatchTriger:new{
-- condition = function(d) return d.load &lt; 9 end },<br/>
-- &nbsp;&nbsp;&nbsp;function(g) naughty.notify{<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;title = "Battery Warning",<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;text = "Battery low! " .. g.provider.data.load .. "% left!",<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;timeout = 5,<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;position = "top_right",<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fg = beautiful.fg_focus,<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bg = beautiful.bg_focus} end)
-- </div>
--
-- <p>Here is another example which introduces the <a
-- href='#EdgeTrigger'><code>EdgeTrigger</code></a>. This trigger is
-- activated when the condition's state change, that is if it becomes
-- true or if it becomes false. Since <b>Lua</b> objects can be
-- extended at will, the following snippet also moves the refresh
-- action content into a <code>my_update</code> object's member. This
-- way, behaviour which is common to multiple events can be written
-- only once.</p>
--
-- <div class='example'>
-- bg = flaw.gadget.icon.battery('BAT0',<br/>
-- &nbsp;&nbsp;&nbsp;{<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;my_icons = {<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;image(
-- beautiful.icon_battery_low ),<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;image(
-- beautiful.icon_battery_mid ),<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;image(
-- beautiful.icon_battery_full )<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;},<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;my_load_icon = image(
-- beautiful.icon_battery_plugged ),<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;my_update = function(self)<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if
-- self.provider.data.st_symbol == flaw.battery.STATUS_CHARGING then<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;self.widget.image
-- = self.my_load_icon<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;else<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;self.widget.image
-- = self.my_icons[math.floor(self.provider.data.load / 30) + 1]<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end<br/>
-- &nbsp;&nbsp;&nbsp;}, {<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;image
-- = image(beautiful.icon_battery_full)<br/>
-- &nbsp;&nbsp;&nbsp;} )<br/>
-- <br/>bg:add_event(<br/>
-- &nbsp;&nbsp;&nbsp;flaw.event.EdgeTrigger:new{
-- condition = function(d) return d.load &lt; 60 end },<br/>
-- &nbsp;&nbsp;&nbsp;function (g) g:my_update() end )<br/>
-- bg:add_event(<br/>
-- &nbsp;&nbsp;&nbsp;flaw.event.EdgeTrigger:new{
-- condition = function(d) return d.load &lt; 30 end },<br/>
-- &nbsp;&nbsp;&nbsp;function (g) g:my_update() end )<br/>
-- bg:add_event(<br/>
-- &nbsp;&nbsp;&nbsp;flaw.event.EdgeTrigger:new{<br/>
-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condition
-- = function(d) return d.st_symbol == flaw.battery.STATUS_CHARGING end },<br/>
-- &nbsp;&nbsp;&nbsp;function (g) g:my_update() end )<br/>
-- </div>
--
-- <p>This module provides the different Trigger prototypes.</p>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2011 David Soulayrol
module('flaw.event')


--- The simple trigger prototype.
--
-- <p>The simple trigger starts the event it belongs to each time the
-- condition is successfully checked.</p>
--
-- @class table
-- @name Trigger
-- @field condition the boolean computing routine, normally provided
--        by the user, which decides if the event should be started.
Trigger = { condition = function() return true end }

--- The simple trigger constructor.
--
-- @param o a table, which should at least contain the condition
--          function at the index <code>condition</code>.
--  @return the fresh new trigger.
function Trigger:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

--- Event trigger using the raw condition.
--
-- @param  data the provider data.
function Trigger:test(data)
   return self.condition(data)
end

--- The latch trigger prototype.
--
-- <p>The latch trigger starts the event it belongs to only when the
-- condition becomes true. That is, while the condition remains true,
-- the event is started exactly once. It will be started again only if
-- the condition becomes false again and then true.</p>
--
-- @class table
-- @name LatchTrigger
-- @field condition the boolean computing routine, normally provided
--        by the user, which decides if the event should be started.
-- @field status the trigger memory.
LatchTrigger = Trigger:new{ status = false }

--- Event trigger using a bistable mechanism around the raw condition.
--
-- @param  data the provider data.
function LatchTrigger:test(data)
   local old_status = self.status
   self.status = self.condition(data)
   return not old_status and self.status
end

--- The edge trigger prototype.
--
-- <p>The edge trigger starts the event it belongs to only when the
-- condition result changes. That is, the event is started each time
-- the condition becomes true or becomes false.</p>
--
-- @class table
-- @name EdgeTrigger
-- @field condition the boolean computing routine, normally provided
--        by the user, which decides if the event should be started.
-- @field status the trigger memory.
EdgeTrigger = Trigger:new{ status = false }

--- Event trigger using edge detection of the raw condition results.
--
-- @param  data the provider data.
function EdgeTrigger:test(data)
   local old_status = self.status
   self.status = self.condition(data)
   return old_status and not self.status or not old_status and self.status
end
