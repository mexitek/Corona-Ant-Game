-- 
--  subpub.lua
--  Ant
--  
--  Created by Arlo Carreon on 2011-06-29.
--  Copyright 2011 Corillo Apps. All rights reserved.
--
-- SUBPUB.lua : A hub for application events.  Class can publish an event, 
-- all methods subscribed to said event will be executed.
--
-- Try out the test below!!
--
--

-- ==================================================
-- = Quick SubPub Test: paste this in your main.lua =
-- ==================================================
--local subpub = require( "libraries/subpub" );
--subpub.subscribe("test",function(show_text) native.showAlert( "test", show_text ) end);
--subpub.publish("test","Woohoo! SubPub works!!");
-- ==================================================


-- ** make file into a package ** --
module( ..., package.seeall );

-- ** Local Vars ** --
local event_queues = {};

-- ===================================================================================
-- = subscribe() : Method takes an event_name and a function that wants to subscribe =
-- ===================================================================================
function subscribe( event_name, method_to_subscribe )
	-- ** Need to authenticate params here ** --
	
	-- ** Check for event queue ** --
	if not event_queues[event_name] then
		event_queues[event_name] = {};
	end
	
	-- ** Add method to it's queue ** --
	table.insert( event_queues[event_name], method_to_subscribe );
end

-- =====================================================================================
-- = Publish() : Method takes an event_name and will call all methods in event's queue =
-- =====================================================================================
function publish( event_name, info )
	-- ** cache event_queue ** --
	local q = event_queues[event_name];
	
	-- ** Check to make sure event exists ** --
	if not q then
		return nil;
	end
	
	-- ** Iterate through the event_queue and call all methods ** --
	for i=1,table.getn(q) do
		q[i](info);
	end
end