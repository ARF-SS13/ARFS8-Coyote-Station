/proc/extract_client(something)
	if(istype(something, /client))
		return something
	if(istext(something))
		return LAZYACCESS(GLOB.directory, something)
	if(ismob(something))
		var/mob/mub = something
		return mub.client
	return null
