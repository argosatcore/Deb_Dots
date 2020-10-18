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
local pairs = pairs
local setmetatable = setmetatable
local string = string
local tonumber = tonumber

local awful = {
   widget = require('awful.widget'),
   tooltip = require('awful.tooltip'),
   util = require('awful.util'),
}

local capi = {
   widget = widget,
}

local flaw = {
   helper = require('flaw.helper'),
}


--- Core gadgets factory and handling.
--
-- <p>To add functionality to awesome widgets, <b>flaw</b> defines
-- gadget objects, which are a wrapper around a widget. Gadgets have
-- properties, events, a refresh mechanism and a data provider. Even
-- though gadgets could wrap any <b>awesome</b> widget type,
-- <b>flaw</b> is focused on the most commonly used to report
-- information: text boxes, image boxes, graphs or progress
-- bars. These gadgets are <a
-- href='#TextGadget'><code>TextGadget</code></a>, <a
-- href='#GraphGadget'><code>GraphGadget</code></a>, <a
-- href='#BarGadget'><code>BarGadget</code></a> and <a
-- href='#IconGadget'><code>IconGadget</code></a> which embed a text
-- box, a graph, a progress bar and an image box
-- respectively.</p>
--
-- <p><b>flaw</b> provides many gadgets for common system information
-- (like battery, CPU or memory activity) in different modules. This
-- one contains the core gadget prototypes and functions.</p>
--
-- <h2>Instantiation, Initialization Parameters</h2>
--
-- <p>The following is the complete pattern to instantiate a
-- gadget:</p>
--
-- <div class='example'>
-- g = flaw.gadget.&lt;type&gt;.&lt;name&gt;(&lt;id&gt;, &lt;gopts&gt;, &lt;wopts&gt;)
-- </div>
--
-- <p>A gadget is first identified by its <code>type</code> and its
-- <code>name</code>. The <code>type</code> is what identifies the
-- gadget kind and can be <code>Text</code>, <code>Icon</code>,
-- <code>Graph</code> and <code>Bar</code>. The <code>name</code> is
-- usually the name of the module which defines it (eg. the battery
-- module defines battery gadgets).</p>
--
-- <p>Whatever the gadget, up to three parameters can be passed at
-- creation time, only the first being mandatory.</p>
--
-- <ul>
--
-- <li><code>id</code>
--
-- <p>This first and most important parameter is the gadget
-- identifier, or ID. It is altogether the gadget unique name and a
-- string that can be used by this gadget provider to identify a
-- resource (eg. the CPU to monitor or the id of the battery). Whether
-- the provider needs an ID or not is described in service modules
-- pages, but this parameter must always be non-null.</p></li>
--
-- <li><code>gopts</code>
--
-- <p>The next parameter is a table providing properties for the
-- gadget to create. Again, modules documentation will provide
-- information on the available properties. This table can also be
-- used to store user data which will be available in the event
-- triggering functions for example.</p></li>
--
-- <li><code>wopts</code>
--
-- <p>The last parameter is another table providing properties for the
-- wrapped <b>awful</b> widget. The acceptable options are detailed in
-- the <b>awesome</b> documentation.</p></li>
--
-- </ul>
--
-- <p>All created gadgets are kept in a <a
-- href='#_gadgets_cache'>global store</a> from which they can be
-- retrieved anytime. This store knows not only about gadgets
-- instances, but also about their prototype, their provider, and
-- defaults properties.</p>
--
-- <h2>Usage in <b>awesome</b> configuration</h2>
--
-- <p>Gadgets are meant to be displayed in <i>wiboxes</i>, like any
-- other <b>awful</b> widget. Actually, it is the wrapped widget that
-- will be added to the <i>wibox</i>. To achieve this, every gadget
-- exposes its underlying widget with the <code>widget</code>
-- member.</p>
--
-- <h2>Types Details</h2>
--
-- <h3>Icon Gadgets</h3>
--
-- <p>Icon gadgets wrap the <b>awful</b> <i>imagebox</i> widget. They
-- can display an image and that is all, which makes them the simpler
-- gadget provided by <b>flaw</b>. What's interesting about them
-- though is that like any other gadget they rely on one provider and
-- can make use of events.</p>
--
-- <p>Assuming the beautiful property <code>battery_icon</code> is the
-- path to a default battery icon path, the following statement
-- creates a new battery status icon gadget. Note the
-- <code>image</code> widget property which is explained in
-- <b>awful</b> documentation.</p>
--
-- <div class='example'>
-- g = flaw.gadget.icon.battery(<br/>
-- &nbsp;&nbsp;&nbsp;'BAT0', {}, { image = image(beautiful.battery_icon) })<br/>
-- </div>
--
-- <h3>Text Gadgets</h3>
--
-- <p>Text gadgets allow you to display any textual information. What
-- makes them really interesting is that the display can be used to
-- format information returned by the provider associated to the
-- gadget.</p>
--
-- <p>All text gadgets provide a default content related to the
-- information they gather from the provider (percents of available
-- memory, or of battery load for example). The <code>pattern</code>
-- gadget option allows every text gadget to be customized.</p>
--
-- <div class='example'>
-- g = flaw.gadget.text.alsa('0',<br/>
-- &nbsp;&nbsp;&nbsp;{ pattern = '&lt;span color="#ffffff"&gt;
-- $volume&lt;/span&gt;%($mute)' })
-- </div>
--
-- <p>The variables to be formatted must be prefixed by a dollar
-- sign. The available variables are detailed in the providers
-- documentations.</p>
--
-- <h3>Graph Gadgets</h3>
--
-- <p>Graph gadgets are an interesting way to represent data variation
-- in the time. As of text gadgets, all graph gadgets provide default
-- content to be drawn. This content can be customized uing the
-- <code>values</code> gadget option.</p>
--
-- <div class='example'>
-- g = flaw.gadget.graph.memory('', { values = {'free'} }, {<br/>
-- &nbsp;&nbsp;&nbsp;width = '35',<br/>
-- &nbsp;&nbsp;&nbsp;height = '0.8',<br/>
-- &nbsp;&nbsp;&nbsp;grow = 'right',<br/>
-- &nbsp;&nbsp;&nbsp;bg = beautiful.bg_normal,<br/>
-- &nbsp;&nbsp;&nbsp;fg = beautiful.fg_normal,<br/>
-- &nbsp;&nbsp;&nbsp;max_value = '100',<br/>
-- })
-- </div>
--
-- <h3>Bar Gadgets</h3>
--
-- <p><b>FIXME</b></p>
--
--
-- @author David Soulayrol &lt;david.soulayrol AT gmail DOT com&gt;
-- @copyright 2009,2010,2011 David Soulayrol
module('flaw.gadget')


--- Types store.
--
-- <p>This table indexes the available gadget types and their default
-- implementation.</p>
--
-- <p>This table is private to the <code>gadget</code> module. It is
-- mainly used as a reference for registering gadget prototypes.</p>
--
-- @class table
-- @name _gadgets_types
local _gadgets_types = {}

--- Global gadgets store.
--
-- <p>This table stores all the registered prototypes as well as all
-- the gagdet instances. The store behaves like a dictionnary where
-- the keys are prototype types and entries a table which
-- contains:</p>
--
-- <ul>
-- <li>The prototype itself.</li>
-- <li>A factory for the provider used by the prototype.</li>
-- <li>A table of instances.</li>
-- <li>A table of default values to be set on each new instance.</li>
-- </ul>
--
-- <p>This table is private to the <code>gadget</code> module. It can
-- be accessed using the <a href='#get'><code>get</code></a> and <a
-- href='#register'><code>register</code></a> functions of this
-- module.</p>
--
-- @class table
-- @name _gadgets_cache
local _gadgets_cache = {}

--- Store a gadget prototype.
--
-- <p>This function creates a new entry in the global store. This
-- entry retains the given prototype, provider factory and defaults
-- tables and associates a gadget instance table to them.</p>
--
-- <p>The function fails if the given prototype is nil or has a nil
-- type.</p>
--
-- <p>Note that unless you create your own gadget prototype, you do
-- not have to call this function. Also note that the current
-- implementation silently overwrites the previous entry if it
-- existed.</p>
--
-- @param  t the type of prototype to register.
-- @param  n the name of prototype to register.
-- @param  p the prototype to register.
-- @param  pf the provider factory to use when creating a new gadget
--         using this new prototype.
-- @param  gopt the default prototype options.
-- @param  wopt the default options for the wrapped widget.
function register_prototype(t, n, p, pf, gopt, wopt)
   if t == nil or n == nil or p == nil or pf == nil then
      flaw.helper.debug.error('flaw.gadget.register_prototype: invalid arguments.')
      return
   end

   if _gadgets_cache[t] == nil then
      flaw.helper.debug.error('flaw.gadget.register_prototype: invalid type: ' .. t)
      return
   end

   -- Keep only the latest part of a dotted notation in name.
   n = n:gsub('^%w*%.', '')

   _gadgets_cache[t][n] = {
      prototype = p,
      provider_factory = pf,
      instances = {},
      defaults = { gadget = gopt or {}, widget = wopt or {} }
   }
end

--- Store a gadget instance.
--
-- <p> This function stores the given instance in the global gadgets
-- store. It fails if the instance is invalid, that is if it is nil or
-- if its type or its ID is nil. It also fails if the store has no
-- entry for this gadget type.</p>
--
-- <p>You normally do not have to call this function since it is
-- silently invoked each time you call the gadget factory <a
-- href='#new'><code>new</code></a> function.</p>
--
-- @param  t the type of gadget to store.
-- @param  g the gadget to store.
-- @return The gadget stored, or nil if the given gadget could not be stored.
function add(t, n, g)
   if t == nil or n == nil or g == nil or g.id == nil then
      flaw.helper.debug.error('flaw.gadget.add: invalid gadget.')
   else
      if _gadgets_cache[t] == nil or _gadgets_cache[t][n] == nil then
         flaw.helper.debug.error('flaw.gadget.add: unknown gadget class: ' .. g.type)
      end
      _gadgets_cache[t][n].instances[g.id] = g
      return g
   end
   return nil
end

--- Retrieve a gadget instance.
--
-- <p>This function returns the gadget matching the given
-- information. It immediately fails if the given type or identifier
-- is nil. It also fails if no gadget in the store matches the given
-- parameters.</p>
--
-- @param  t the type of the gadget to retrieve.
-- @param  id the uniquer identifier of the gadget to retrieve.
-- @return The matching gadget instance, or nil if information was
--         incomplete or if there is no such gadget.
function get(t, n, id)
   if t ~= nil and n ~= nil and id ~= nil then
      return _gadgets_cache[t] and _gadgets_cache[t][n] ~= nil
         and _gadgets_cache[t].instances[id]
   end
   flaw.helper.debug.error('flaw.gadget.get: invalid information.')
   return nil
end

--- Create a new gadget.
--
-- <p>This function is the only gadget factory and the main
-- <b>flaw</b> interface for a user to populate its <i>wibox</i> with
-- gadgets. However, it is not necessary to call it directly since the
-- module provides intelligent indexation to hide it.</p>
--
-- <p>It immediately fails if given type or identifier is nil, or if
-- no such type was registered in the store. If it was, the gadget is
-- created from the data available in the matching store entry.</p>
--
-- <p>If a matching entry is found in the store, the function first
-- completes the given options tables with the defaults found in the
-- entry. Then it creates the gadget using the found prototype and
-- provider factory, and applies the options tables to the gadget and
-- the wrapped widget respectively. At last, it starts the gadget
-- monitoring with the <code>delay</code> gadget option and stores it
-- in the store entry instances table.</p>
--
-- @param  t the type of the gadget to create.
-- @param  id the uniquer identifier of the gadget to create.
-- @param  gopt the options to pass to the created gadget.
-- @param  wopt the options to pass to the created wrapped widget.
-- @return A brand new gadget instance, or nil it was not successfully
--         created. Note that the returned widget is present in the
--         gadget store and can be retrieved with the <a
--         href='#get'><code>get</code></a> function from now on.
function new(t, n, id, gopt, wopt)
   if t == nil or n == nil or id == nil then
      flaw.helper.debug.error('flaw.gadget.new: invalid information.')
      return nil
   end

   local e = _gadgets_cache[t][n]
   if e == nil then
      flaw.helper.debug.error('flaw.gadget.new: unknown gadget class: ' .. t .. '.' .. n)
      return nil
   end

   -- Load default parameters.
   gopt = gopt or {}
   wopt = wopt or {}
   for k in pairs(e.defaults.gadget) do
      gopt[k] = gopt[k] or e.defaults.gadget[k]
   end
   for k in pairs(e.defaults.widget) do
      wopt[k] = wopt[k] or e.defaults.widget[k]
   end

   -- Create the widget.
   local g = e.prototype:new{ id = id, provider = e.provider_factory(id) }

   -- Configure the gadget.
   for k in pairs(gopt) do g[k] = gopt[k] end
   if g.create ~= nil then
      g:create(wopt)
      for k in pairs(wopt) do g.widget[k] = wopt[k] end
   end

   -- Start monitoring.
   g:register(gopt.delay)

   return add(t, n, g)
end


--- The Gadget prototype.
--
-- <p>This is the root prototype of all gadgets. It provides common
-- methods for events and refresh handling.</p>
--
-- @class table
-- @name Gadget
Gadget = {}

--- Gadget constructor.
--
-- <p>Note that this constructor is only used internally, or to create
-- new gadget prototypes. To create gadget instances, you should use
-- the gadget factory <a href='#new'><code>new</code></a>
-- function.</p>
--
-- @param  o a table with default values.
-- @return The brand new gadget.
function Gadget:new(o)
   o = o or {}
   o.events = {}
   setmetatable(o, self)
   self.__index = self
   return o
end

--- Hook the gadget to clock events.
--
-- <p>This method is called automatically by the <a
-- href='#new'><code>new</code></a> function, with the
-- <code>delay</code> argument of its <code>gopt</code> options
-- table. The <code>delay</code> will be considered or not by the
-- provider depending on its kind.</p>
--
-- @param delay the delay between gadget updates in seconds. It can be
--        nil if the underlying provider is not a <a
--        href="flaw.provider.html#CyclicProvider"><code>CyclicProvider</code></a>.
function Gadget:register(delay)
   -- Subscribe this gadget to the provider.
   if self.provider ~= nil then
      self.provider:subscribe(self, delay)
   end
end

--- Register an event to the gadget.
--
-- @param  t the event trigger.
-- @param  a the action taken upon the event occurrence.
function Gadget:add_event(t, a)
   if t == nil or a == nil then
      flaw.helper.debug.error('flaw.gadget.Gadget:add_event: invalid event')
   else
      self.events[t] = a
   end
end

--- Sets the tooltip for this gadget.
--
-- @param pattern the pattern to use for the tooltip content. This
-- pattern will be parsed like a <a
-- href='#TextGadget'><code>TextGadget</code></a> pattern.
function Gadget:set_tooltip(pattern)
   if pattern == nil then
      flaw.helper.debug.error('flaw.gadget.Gadget:set_tooltip: invalid pattern.')
      return nil
   end

   self.tooltip = {
      widget = awful.tooltip({ objects = { self.widget }, }),
      pattern = pattern }

   if self.provider ~= nil and self.provider.data ~= nil then
      self.tooltip.widget:set_text(
         flaw.helper.strings.format(
            pattern, self.provider.data[self.id] or self.provider.data))
   else
      flaw.helper.debug.warn('flaw.gadget.Gadget:set_tooltip: useless tooltip.')
   end
end

--- Callback for gadget update.
--
-- <p>This function is called by awful if the gadget has been
-- registered to awful time events. It first asks the gadget provider
-- to refresh itself, and then applies any triggered event. At last,
-- it calls its own redraw function, if defined.</p>
function Gadget:update()
   if self.provider ~= nil then
      for c, a in pairs(self.events) do
         if c:test(self.provider.data) then
            a(self, t)
         end
      end
      if self.redraw then self:redraw() end
   end
end


--- The text boxes wrapper gadget.
--
-- <p>This specialised gadget relies on a pattern property which is
-- used to format the text output. The provider data are used when
-- parsing the pattern. See <a
-- href='flaw.helper.html#strings.format'><code>helper.strings.format</code></a>
-- to understand how the pattern is used to build the output.</p>
--
-- @class table
-- @name TextGadget
TextGadget = Gadget:new{}

-- Create the wrapped gadget.
function TextGadget:create(wopt)
   self.widget = capi.widget(
      awful.util.table.join(wopt, { type = 'textbox', name = self.id }))
end

--- Specialised callback for text gadget update.
--
-- <p>This implementation support two data models. First, it can apply
-- the gadget pattern directly on the provider data table. But if the
-- gadget identifier is a key of the provider data, then the gadget
-- pattern is applied using the content of this entry only in the
-- provider data set.</p>
function TextGadget:redraw()
   local data_set = {}
   if self.provider ~= nil and self.provider.data ~= nil then
      data_set = self.provider.data[self.id] or self.provider.data
   end
   if self.pattern ~= nil then
      self.widget.text = flaw.helper.strings.format(self.pattern, data_set)
   end
   if self.tooltip ~= nil then
      self.tooltip.widget:set_text(
         flaw.helper.strings.format(self.tooltip.pattern, data_set))
   end
end

_gadgets_types.text = TextGadget
_gadgets_cache.text = {}

--- The graphs wrapper gadget.
--
-- <p>This specialised gadget proposes a list of data values to track
-- from the provider data and to plot.</p>
--
-- @class table
-- @name GraphGadget
GraphGadget = Gadget:new{}

--- Specialised callback for graph gadget update.
--
-- <p>This implementation support two data models. First, it can
-- search the gadget values directly on the provider data table. But
-- if the gadget identifier is a key of the provider data, then the
-- gadget values is searched using the content of this entry only in
-- the provider data set.</p>
function GraphGadget:redraw()
   if self.provider ~= nil and self.provider.data ~= nil then
      local data_set = self.provider.data[self.id] or self.provider.data
      for i, v in ipairs(self.values) do
         self.hull:add_value(tonumber(data_set[v]) / 100)
      end
   end
end

-- Create the wrapped gadget.
--
-- In this case, the raw widget is still stored in
-- <code>widget</code>, but the <code>awful.widget.graph</code> is
-- stored in the <code>hull</code> one.
function GraphGadget:create(wopt)
   self.hull = awful.widget.graph(
      awful.util.table.join(wopt, {name = self.id}))
   self.widget = self.hull.widget
end

_gadgets_types.graph = GraphGadget
_gadgets_cache.graph = {}

--- The progress bar wrapper gadget.
--
-- The progress bar represents a numeric value using a horizontal or
-- vertical gauge. The gadget <code>value</code> field is the name of
-- the provider property to be represented.
--
-- @class table
-- @name BarGadget
BarGadget = Gadget:new{}

--- Specialised callback for progress gadget update.
--
-- <p>This implementation supports two data models. First, it can
-- search the gadget <code>value</code> field directly in the provider
-- data table. But if the gadget identifier is a key of the provider
-- data table, then the gadget <code>value</code> field is searched in
-- the provider's <code>data[id]</code> table.</p>
function BarGadget:redraw()
   if self.provider ~= nil and self.provider.data ~= nil then
      local data_set = self.provider.data[self.id] or self.provider.data
      self.hull:set_value(tonumber(data_set[self.value]) / 100)
   end
end

-- Create the wrapped gadget.
--
-- In this case, the raw widget is still stored in
-- <code>widget</code>, but the <code>awful.widget.progressbar</code>
-- is stored in the <code>hull</code> one. To configure the
-- <code>hull</code>, see
-- <http://awesome.naquadah.org/doc/api/modules/awful.widget.progressbar.html>.
function BarGadget:create(wopt)
   self.hull = awful.widget.progressbar(
      awful.util.table.join(wopt, {name = self.id}))
   self.widget = self.hull.widget
end

_gadgets_types.bar = BarGadget
_gadgets_cache.bar = {}

--- The image boxes wrapper gadget.
--
-- <p>This specialised gadget is a placeholder for specific icon
-- treatments. For now, it brings nothing. Interesting stuff can be
-- handled using the events mechanism.</p>
--
-- @class table
-- @name IconGadget
IconGadget = Gadget:new{ type = 'unknown.imagebox' }

_gadgets_types.icon = IconGadget
_gadgets_cache.icon = {}


-- TODO
function IconGadget:create()
   self.widget = capi.widget({ type = 'imagebox', name = self.id })
end

-- Below are nifty shortcuts to register or create new gadgets.
register = {}
setmetatable(register, {
                __index = function(_, t)
                             return function(m, gopt, wopt, p)
                                       if m == nil or m._NAME == nil or m.provider_factory == nil then
                                          flaw.helper.debug.error(
                                             'flaw.gadget.register.' .. t .. ': invalid module.')
                                          return
                                       end

                                       register_prototype(t, m._NAME, p or _gadgets_types[t],
                                                          m.provider_factory, gopt, wopt)
                                    end
                          end })


setmetatable(_M, {
                __index = function(_, t)
                             _t = {}
                             _mt = { __index = function(_, n)
                                                  return function(id, gopt, wopt)
                                                            return new(t, n, id, gopt, wopt)
                                                         end
                                               end }
                             setmetatable(_t, _mt)
                             return _t
                          end })
