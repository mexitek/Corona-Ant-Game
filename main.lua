-- ** load all libraries being used ** --
local ui = require( "libraries/ui" );
local imgs = require( "libraries/images" );
local subpub = require( "libraries/subpub" );

-- ** Set app data (as globals) ** --
app_globals = {
	-- hide status bar of phone --
	hide_status_bar = display.setStatusBar( display.HiddenStatusBar ),
	
	-- set game background --
	background = display.newImage( imgs.fetchImagePath( "bg_meadow.png" ) ),
	
	-- calculate center of the x axis
	centerX = display.contentWidth / 2,
	
	-- keep count of total balls --
	total_balls = 0,
	
	-- limit of balls --
	max_balls = 20,
	
	-- ** universal gravity ** --
	gravity = { x = 1.5, y = 20 },
	
	-- ** determine if high res ** --
	is_high_res = imgs.isHighRes()
};

-- ** cache math library functions ** --
local rand = math.random;

-- ** add and start physics, set gravity (explained in part 1) ** --
local physics = require("physics");
physics.start();
-- physics.pause();
physics.setGravity( app_globals.gravity.x, app_globals.gravity.y );

-- ** create tennis ball ** --
local function createBall( ball_count )

	-- ** create new instance of tennis ball ** --
	local tennis_ball = display.newImage( "images/bg_tennis_ball_sm.png" );
	
	-- ** set tennis ball id ** --
	tennis_ball.tb_id = "tb_" .. ( ball_count + 1 );
	
	-- ** initiate bounces of this ball ** --
	tennis_ball.bounces = 0;  -- set to zero --
	
	-- ** position tennis ball ** --
	tennis_ball.x = ant_player.x;  -- set x axis --
	tennis_ball.y = -15;  -- set y axis --
	tennis_ball.rotation = 1;
	
	-- ** add physics to ball ** --
	physics.addBody( tennis_ball, { bounce = 0.8, density = 1.0 } );
	
	-- ** incremente count of balls ** --
	app_globals.total_balls = app_globals.total_balls + 1;
	
	-- ** return new object ** --
	return tennis_ball;
	
end

-- ** spawn tennis ball(s) ** --
local function spawnBall()
	
	-- ** check to see if max balls created ** --
	--if( app_globals.total_balls < app_globals.max_balls ) then
		-- ** fetch new ball ** --
		timer.performWithDelay( 100,
			function()
				-- ** create ball ** --
				createBall( app_globals.total_balls );
			end,
		1 );
		-- local new_ball = createBall( app_globals.total_balls );
		
	--end
end

-- ** ball bounce event handler ** --
local function ballBounce( e )
	
	-- ** save bouncing ball ** --
	local ball = e.object2;
	
	-- ** detect first bounce ** --
	if ( e.phase == "began" and ball.bounces == 0 ) then
		spawnBall();
		--native.showAlert( "Corona", "test" );
	end
	
	-- ** track every bounce ** --
	ball.bounces = ball.bounces + 1;
	
	-- ** return ** --
	return;
end

-- ** add ball bounce listener ** --
Runtime:addEventListener( "collision", ballBounce );

-- ** create floor (for physics) ** --
floor = display.newRect( 0, 430, 320, 50 );
floor.alpha = 0;
	
-- adds phyiscs properties to the newly added floor
physics.addBody( floor, "static", { bounce = 0.4, density = 1.0 } );

-- ** add ant to stage (global access) ** --
-- ** set in middle of screen (on the floor) ** --
ant_player = display.newImage( "images/bg_ant.png" );
ant_player.x = 160;
ant_player.y = 405;

-- ** Teleport Method ** --
ant_teleport = function(e)
	-- ** Make Ant disappear ** --
	transition.to(ant_player, {time = 10, alpha = 0,y=600, onComplete=function() 
		-- ** Move the y axis (drop from stage) ** --
		transition.to(ant_player, {time = 10, y=600, onComplete=function() 
			-- ** Move to the touch x axis to new location ** --
			transition.to( ant_player, { time = 100, x=e.x, onComplete=function() 
				-- ** Reintroduce the y axis to the stage ** --
				transition.to(ant_player, {time = 10, y=405, onComplete=function()
					-- ** Make Ant appear ** --
					transition.to(ant_player, {time = 10, alpha = 1} );
				end});-- End Reintroduce original y axis
			end} );-- End move to new x axis
		end}); -- End Move ant backstage
	end} );-- End Disappear
	
	-- ** Notify application the ant has moved ** --
	subpub.publish("ant_moved",antplayer);
end
-- ** Subscribe to "player_touched" ** --
subpub.subscribe("player_touched",ant_teleport);

-- ** add physics to ant ** --
physics.addBody( ant_player, "kinematic" );

-- ** start balls ** --
spawnBall();


-- ==========================================
-- = Listen: When player touches the screen =
-- ==========================================
Runtime:addEventListener("touch", function(e) subpub.publish("player_touched",e); end)
