-- ** make file into a package ** --
module( ..., package.seeall );

-- ** split string ** --
function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    -- Attach chars left of current divider
    table.insert(arr,string.sub(str,pos,st-1)) 
    pos = sp + 1 -- Jump past current divider
  end
  -- Attach chars right of last divider
  table.insert(arr,string.sub(str,pos)) 
  return arr
end

-- ** determine screen res ** --
function isHighRes()
	
	-- ** if screen height is greater than 500, its hi res ** --
	if( display.contentHeight > 500 ) then
		return true;
	end
	
	-- ** default return ** --
	return false;

end

-- ** parse image name ** --
function parseImageName( image )

	-- ** string that will hold final image url ** --
	return explode( ".", image );

end

-- ** load image ** --
function fetchImagePath( image )

	-- ** local vars used ** --
	local temp_image_string = "";
	local split_image_name = parseImageName( image );
	
	-- ** determine if screen is hi res ** --
	if( isHighRes() ) then
		-- ** compose hi res image path ** --
		temp_image_string = "images/hires/" .. split_image_name[1] .. "@2x." .. split_image_name[2];
	else
		-- ** compose image path ** --
		temp_image_string = "images/" .. split_image_name[1] .. "." .. split_image_name[2];
	end
	
	-- ** return full path ** --
	return temp_image_string;

end