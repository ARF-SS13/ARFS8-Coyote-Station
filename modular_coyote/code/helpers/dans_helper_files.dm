/proc/extract_client(something)
	if(istype(something, /client))
		return something
	if(istext(something))
		return LAZYACCESS(GLOB.directory, something)
	if(ismob(something))
		var/mob/mub = something
		return mub.client
	if(isatom(something))
		var/atom/thing = something
		var/list/its_complicated = list()
		var/smth = SEND_SIGNAL(thing, COMSIG_EXTRACT_CLIENT, its_complicated)
		if(!smth)
			return null
		if(LAZYLEN(its_complicated))
			return its_complicated[its_complicated.len]
	return null

/proc/extract_ckey(something)
	if(istext(something))
		return ckey(something)
	if(ismob(something))
		var/mob/mub = something
		return mub.ckey
	if(istype(something, /client))
		var/client/cl = something
		return cl.ckey
	if(isatom(something))
		var/atom/thing = something
		var/list/its_complicated = list()
		var/smth = SEND_SIGNAL(thing, COMSIG_EXTRACT_CKEY, its_complicated)
		if(!smth)
			return null
		if(LAZYLEN(its_complicated))
			return its_complicated[its_complicated.len]
	return null

/proc/extract_prefs_holder(something)
	if(istype(something, /datum/prefs_holder))
		return something
	if(ismob(something))
		var/mob/mub = something
		return mub.client?.prefs
	if(istype(something, /client))
		var/client/cl = something
		return cl.prefs
	if(istext(something))
		var/client/cl = LAZYACCESS(GLOB.directory, something)
		return cl?.prefs
	return null

/proc/extract_mob(something)
	var/mob/mub = get_mob_by_ckey(something)
	if(mub)
		return mub
	if(ismob(something))
		return something
	if(istype(something, /client))
		var/client/cl = something
		return cl.mob
	if(istext(something))
		var/client/cl = LAZYACCESS(GLOB.directory, something)
		return cl?.mob
	if(istype(something, /datum/mind))
		var/datum/mind/mind = something
		return mind.current
	return null

/proc/extract_current_character_slot(mob/user, null_is_ok)
	var/datum/prefs_holder/preferences = extract_prefs_holder(user)
	if(preferences)
		return preferences.default_slot // default is current
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		return H.prefs_character_slot || 1
	return null_is_ok ? null : 1

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

/proc/get_species_name(mob/living/carbon/human/critter, custompls = TRUE)
	if(!ishuman(critter))
		return "critter"
	if(custompls)
		var/maybename = critter?.dna?.features["custom_species"]
		if(maybename != "")
			return maybename
			// otherwise, get the species datum and return its name
	var/datum/species/species_datum = get_species(critter)
	if(!species_datum)
		return "critter"
	return species_datum.name

/proc/get_species(mob/living/carbon/human/critter)
	if(!ishuman(critter))
		return null
	return critter?.dna?.species

/proc/verbify(mob/focus, text)
	for(var/datum/csnip_verbset/verbset in SSdans_cool_prefs.verbsets)
		text = verbset.replace_token(text, focus)
	return text

/// hey i wanna pay someone, time to check 40 different things to figure out where it goes
/proc/extract_bank_account(something)
	if(istype(something, /datum/bank_account))
		return something
	if(istype(something, /obj/item/card/id))
		var/obj/item/card/id/card = something
		return card.registered_account
	// now its gonna get a bit hazier, hold onto ur butts, cus its time to go digging
	var/mob/possiblemob = extract_mob(something)
	if(possiblemob)
		var/mob_uid = possiblemob.m_uid
		for(var/ind in SSeconomy.bank_accounts_by_id)
			var/datum/bank_account/account = SSeconomy.bank_accounts_by_id[ind]
			if(account && account.original_owner_uid == mob_uid)
				return account




/proc/drift_towards_by(val,target,amt)
	if(IS_WITHIN_TOLERANCE(val, target, amt))
		return target
	if(val < target)
		val = min(val+amt,target)
	if(val > target)
		val = max(val-amt,target)
	return val

