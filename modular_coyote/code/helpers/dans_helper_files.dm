/proc/extract_client(something)
	if(istype(something, /client))
		return something
	if(istext(something))
		return LAZYACCESS(GLOB.directory, something)
	if(ismob(something))
		var/mob/mub = something
		return mub.client
	return null

/// takes in a screen_loc string, and shifts it by the given x and y offsets
/// "EAST-4:22,SOUTH+1:7", x_offset = 3, y_offset = 2 would output "EAST-1:25,SOUTH+3:9"
/// also makes sure theres always a : in each part, cus thats easier lol
/proc/shift_screen_loc(screen_loc, x_offset = 0, y_offset = 0)
	var/list/parts = splittext(screen_loc, ",")
	. = list() // the output
	var/is_x = TRUE
	for(var/xychunk in parts)
		//: or no :
		var/list/xy_parts = splittext(xychunk, ":")
		if(LAZYLEN(xy_parts) == 1) // no :, just give it one then
			xy_parts[2] = "0"
		xy_parts[2] = text2num(xy_parts[2])
		if(is_x)
			xy_parts[2] += x_offset
		else
			xy_parts[2] += y_offset
		is_x = !is_x
		. += "[xy_parts[1]]:[xy_parts[2]]"
	. = jointext(., ",")






