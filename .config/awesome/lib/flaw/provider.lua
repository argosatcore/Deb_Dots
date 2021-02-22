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
local pairs = pairs
local os = os
local setmetatable = setmetatable

local capi = {
   timer = timer,
}

local flaw = {
   helper = require('flaw.helper'),
}


--- Providers core mechanisms.
--
-- <p>In <b>flaw</b>, all data is gathered by provider objects which,
-- in an attempt to minimize resources usage, can be shared among
-- gadgets. The providers can poll disks or memory at a given rate for
-- their information, or can be updated by scripts or direct
-- <b>Lua</b> invocation, like <b>awful</b> callbacks. When updated,
-- providers notify the gadgets that have subscribed to them.</p>
--
-- <p>Providers are normally handled automatically when a gadget is
-- created. You only have to take care of them when you are writing
-- your own gadget, or if you want to create a new provider, or extend
-- an existing one. <b>flaw</b> already implements many providers for
-- common system information. The existing providers are usually
-- defined in the module of the widget type they serve.</p>
--
-- <p>A provider is identified by its type and an identifier, which
-- must remain unique for one type. The provider type usually
-- represents the module of this provider and can be composed of any
-- character. Thus, it is common to create a new provider prototype
-- this way:</p>
--
-- <div class='example'>
-- flaw.provider.Provider:new{ type = _NAME }
-- </div>
--
-- <p>All created providers are kept in a <a
-- href='#_providers_cache'>global store</a> from which they can be
-- retrieved anytime. Note that this store has normally no use for the
-- user, but allows gadgets to share providers.</p>
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2010,2011 David Soulayrol
module('flaw.provider')


--- Global providers store.
--
-- <p>This table stores all the registered provider
-- instances. Providers are sorted by their type first, and then by
-- their ID. The store is private to the <code>provider</code>
-- module. It can be accessed using its <a
-- href='#get'><code>get</code></a>, and <a
-- href='#add'><code>add</code></a> functions.</p>
--
-- @class table
-- @name _providers_cache
local _providers_cache = {}

--- Store a provider instance.
--
-- <p>This function stores the given provider in the global providers
-- store. It fails if the instance is invalid, that is if it is nil or
-- if its type is nil.</p>
--
-- <p>You normally do not have to call this function since it is
-- silently invoked each time a gadget instantiates its provider.</p>
--
-- @param  p the provider prototype to store.
function add(p)
   if p == nil or p.id == nil then
      flaw.helper.debug.error('flaw.provider.provider_add: invalid provider.')
   else
      if _providers_cache[p.type] == nil then
         _providers_cache[p.type] = {}
      end
      _providers_cache[p.type][p.id] = p
   end
end

--- Retrieve a provider instance.
--
-- <p>This function returns the provider matching the given
-- information. It immediately fails if the given type or identifier
-- is nil. It also fails if no instance in the store matches the given
-- parameters.</p>
--
-- @param  type the type of the provider to retrieve.
-- @param  id the uniquer identifier of the provider to retrieve.
-- @return The matching provider instance, or nil if information was
--         incomplete or if there is no such provider.
function get(type, id)
   if type == nil or id == nil then
      flaw.helper.debug.error('flaw.provider.provider_get: invalid information.')
   else
      return _providers_cache[type] ~= nil
         and _providers_cache[type][id] or nil
   end
end


--- The Provider prototype.
--
-- <p>This is the root prototype of all providers. It defines nothing
-- but the prototype's type and a method for gadgets subscription.</p>
--
-- @class table
-- @name Provider
Provider = { type = 'unknown' }

--- Provider constructor.
--
-- <p>Remember that providers are normally handled automatically when
-- a gadget is created. This constructor is only used internally, or
-- to create new gadget prototypes.</p>
--
-- @param  o a table with default values.
-- @return The brand new provider.
function Provider:new(o)
   o = o or {}
   o.data = o.data or {}
   o.subscribers = o.subscribers or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

--- Subscribe a gadget to this provider.
--
-- <p>This is the method a gadget automatically uses, when created by
-- the gadget factory, to register itself to its provider. The root
-- provider does strictly nothing with this subscription, but any
-- active provider uses the subscribers list to update its
-- gadgets.</p>
--
-- <p>This method immediately fails if the given gadget is nil. On
-- success, the gadget is stored in the provider internal subscribers
-- list.</p>
--
-- @param  g the gadget subscriber.
-- @return True if the subscriber was correctly stored, False otherwise.
function Provider:subscribe(g)
   if g == nil then
      flaw.helper.debug.error('flaw.provider.Provider:subscribe: invalid gadget')
   return false
end
   self.subscribers[g] = { timestamp = os.time() }
   g:update()
   return true
end

--- Refresh gadgets subscribed to this provider.
--
-- <p>This method is a facility for providers to invoke all the
-- gadgets refresh when they are done with data gathering.</p>
function Provider:refresh_gadgets()
   for g, props in pairs(self.subscribers) do
      props['timestamp'] = self.timestamp
      g:update()
   end
end


--- The Cyclic Provider prototype.
--
-- <p>This specialized provider is the root of all the providers
-- needing to provide cyclic information, based on files, network and
-- so on, rather than on events. Cyclic providers poll resources
-- status from system only when necessary (ie. when the gadget with
-- the shortest refresh rate demands it).</p>
--
-- <p>The CyclicProvider relies on a C API timer. The timer timeout
-- value defaults to 60 seconds but is updated each time a gadget
-- starts to use the provider, if its own rate is shorter. Note that
-- the higher rate demand only will be served in time, all others will
-- be refreshed using a comparison between their timestamp and the
-- refresh date. For example, if a provider is asked to refresh every
-- 10 seconds and then every 3 seconds, its timer will be set to 3
-- seconds. The second gadget will be refreshed exactly in time,
-- whereas the first will be refreshed at 12 seconds, 21 seconds, 30
-- seconds, and so on.</p>
--
-- <p>All CyclicProvider also define a <code>timestamp</code> value
-- which can be used in specific treatments to know the last refresh
-- date.</p>
--
-- @class table
-- @name CyclicProvider
CyclicProvider = Provider:new{ type = 'unknown.cyclic', timestamp = 0, timer = nil }

--- Subscribe a gadget to this provider.
--
-- <p>The CyclicProvider specialised method adds the poll timer
-- handling to the parent method. It also requires the gadget's rate
-- as second argument (which defaults to 60s).</p>
--
-- <p>This method immediately fails if the given gadget is nil. On
-- success, the gadget is stored in the provider internal subscribers
-- list.</p>
--
-- @param  g the gadget subscriber.
-- @param  rate the new poll interval asked by the gadget.
-- @return True if the subscriber was correctly stored and the timer
--         correctly started or reconfigured (if necessary), False otherwise.
function CyclicProvider:subscribe(g, rate)
   rate = rate or 60
   if Provider.subscribe(self, g) then
      self.subscribers[g].rate = rate
      if self.timer == nil then
         self.timer = capi.timer{ timeout = rate }
         self.timer:add_signal('timeout', function() self:refresh() end, true)
         self.timer:start()
      else
         if rate < self.timer.timeout then
            self.timer.timeout = rate
         end
      end

      -- Initial refresh.
      self:refresh(g)

      return true
   end
   return false
end

--- Refresh the provider status.
--
-- <p>This callback is invoked by the provider timer, which timeouts
-- at the highest asked rate. The actual refresh process is dedicated
-- to the <code>do_refresh</code> method, which is called with no
-- argument. This definition depends on the provider role, and should
-- be defined in all derived prototypes.</p>
--
-- <p>After refresh is done, the gadgets are redrawn.</p>
--
-- @param  g if provided, this gadget only is refreshed.
-- @return True is the provider did refresh its data set since the
--         given gadget last asked for the refresh.
function CyclicProvider:refresh(g)
   if self.do_refresh then
      self:do_refresh()
      if g ~= nil then
         self.subscribers[g].timestamp = self.timestamp
         g:update()
      else
         self:refresh_gadgets()
      end
   else
      flaw.helper.debug.warn(
         'CyclicProvider ' .. self.type .. '.' .. self.id .. ' misses do_refresh()')
   end
end

--- Refresh gadgets subscribed to this provider.
--
-- <p>Redefined here to handle the rate required by the different
-- gadgets. All child providers should rely on the
-- <code>refresh</code> method which calls directly this one.</p>
function CyclicProvider:refresh_gadgets(force)
   local force = force or false
   self.timestamp = os.time()
   for g, props in pairs(self.subscribers) do
      if force or props['timestamp'] + props['rate'] <= self.timestamp then
         props['timestamp'] = self.timestamp
         g:update()
      end
   end
end
