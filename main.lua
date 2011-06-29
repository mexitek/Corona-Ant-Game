-- ** Set app data (as globals) ** --
app_globals = {
	-- hide status bar of phone --
	hide_status_bar = display.setStatusBar( display.HiddenStatusBar ),
	
	-- set game background --
	background = display.newImage ("images/bg_meadow.png"),
	
	-- calculate center of the x axis
	centerX = display.contentWidth / 2,
	
	-- keep count of total balls --
	total_balls = 0,
	
	-- limit of balls --
	max_balls = 6
};

-- ** add and start physics, set gravity (explained in part 1) ** --
local physics = require("physics");
physics.start();
physics.setGravity( 1, 20 );

--[[ ** spin ball ** --
local max = math.max;
local min = math.min;
local function rotate( e )
	local r =  app_globals.centerX - e.x;  -- (shift values to between eg -240 to 240)
	r = min( r, 150 );
	r = max( r, -150 );
	tennis_ball.rotation = r;
end]]--

-- ** create tennis ball ** --
local function createBall( ball_count )

	-- ** create new instance of tennis ball ** --
	local tennis_ball = display.newImage( "images/bg_tennis_ball_sm.png" );
	
	-- ** set tennis ball id ** --
	tennis_ball.tb_id = "tb_" .. ( ball_count + 1 );
	
	-- ** initiate bounces of this ball ** --
	tennis_ball.bounces = 0;  -- set to zero --
	
	-- ** position tennis ball ** --
	tennis_ball.x = math.random(1,200);  -- set x axis --
	tennis_ball.y = -15;  -- set y axis --
	
	-- ** add physics to ball ** --
	physics.addBody( tennis_ball, { bounce=0.8, density=1.0 } );
	
	-- ** incremente count of balls ** --
	app_globals.total_balls = app_globals.total_balls + 1;
	
	-- ** return new object ** --
	return tennis_ball;
	
end

-- ** spawn tennis ball(s) ** --
local function spawnBall()
	
	-- ** check to see if max balls created ** --
	if( app_globals.total_balls < app_globals.max_balls ) then
		-- ** fetch new ball ** --
		timer.performWithDelay( 100,
			function()
				createBall( app_globals.total_balls );
			end,
		1 );
		-- local new_ball = createBall( app_globals.total_balls );
	end
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
	physics.addBody( floor, "static", { bounce=0.4, density=1.0 } );
	
-- ** start balls ** --
spawnBall();