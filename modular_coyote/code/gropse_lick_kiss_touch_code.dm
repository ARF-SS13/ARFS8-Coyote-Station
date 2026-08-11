/proc/safepick(list/items)
	if(LAZYLEN(items))
		return pick(items)
	return null

GLOBAL_LIST_EMPTY(gropekissers)
GLOBAL_LIST_EMPTY(shotglass_gropers)

/datum/grope_kiss_MERP/proc/make_visible_message(mob/doer, mob/target, list/last_action = list())
	if(!doer || !target)
		return
	// if(!isliving(target) && !(doer.ckey in GLOB.shotglass_gropers))
	// 	return // you grope the shotglass's butt // screw it you can grope the shotglass's butt
	/// first get the direction of doer compared to target
	var/direc = calc_dir(doer, target)
	/// then, get the right location
	var/intent = get_grope_intent(doer, target)
	var/part = get_grope_target(doer, target)
	var/list/partname = get_grope_list(part, direc, intent, FALSE, TRUE)
	var/list/actions = get_grope_list(part, direc, intent)
	var/tense = "present"
	if(LAZYLEN(last_action))
		if(LAZYACCESS(last_action, 1) == direc)
			if(LAZYACCESS(last_action, 2) == part)
				if(LAZYACCESS(last_action, 3) == intent)
					if(LAZYACCESS(last_action, 4) == target.name)
						tense = "gerundo"
	var/snd = get_sound(doer, target, part, direc, intent)
	var/watDsee = make_message_for_doer(doer, target, actions, tense, LAZYACCESS(partname, 1))
	var/watTsee = make_message_for_target(doer, target, actions, tense, LAZYACCESS(partname, 1))
	var/watEsee = make_message_for_everyone(doer, target, actions, tense, LAZYACCESS(partname, 1))
	var/watIsee = make_message_for_myself_to_me(doer, target, actions, tense, LAZYACCESS(partname, 1))
	var/watYEsee = make_message_for_myself_to_others(doer, target, actions, tense, LAZYACCESS(partname, 1)) // catch the wave!
	if(target == doer)
		playsound(doer, snd, 50, TRUE)
		to_chat(doer, span_love(watIsee))
		doer.visible_message(
			watYEsee,
			ignored_mobs = list(doer),
			vision_distance = 2,
		)
	else
		playsound(target, snd, 50, TRUE)
		to_chat(doer, span_love(watDsee))
		to_chat(target, span_love(watTsee))
		doer.visible_message(
			watEsee,
			ignored_mobs = list(doer, target),
			vision_distance = 2,
		)
	var/list/thing_that_happened = list(direc, part, intent, target.name)
	return thing_that_happened

/datum/grope_kiss_MERP/proc/get_sound(mob/doer, mob/target, part, direc, intent)
	var/whichvar = "[part]_[direc]_action_[intent]_sound"
	var/list/snds = list()
	if(vars[whichvar])
		snds |= vars[whichvar]
	return pick(snds)

/datum/grope_kiss_MERP/proc/make_message_for_doer(mob/doer, mob/target, list/actions, tense, part)
	if( LAZYLEN(actions) != 4)
		return
	var/msg_out = ""
	/// you slap Tia's cheek!
	if(tense == "present")
		var/act = actions[1]
		msg_out = "You [act] [target.name]'s [part]!"
	/// you continue slapping Tia's cheek!
	if(tense == "gerundo")
		var/act = actions[3]
		msg_out = "You continue [act] [target.name]'s [part]!"
	msg_out = replacetext(msg_out, "<DOERS>", "your")
	msg_out = replacetext(msg_out, "<TARGETS>", "[target.p_their()]")
	return msg_out

/datum/grope_kiss_MERP/proc/make_message_for_target(mob/doer, mob/target, list/actions, tense, part)
	if( LAZYLEN(actions) != 4)
		return
	var/msg_out = ""
	/// Tia slaps your cheek!
	if(tense == "present")
		var/act = actions[2]
		msg_out = "[doer.name] [act] your [part]!"
	/// Tia continues slapping your cheek!
	if(tense == "gerundo")
		var/act = actions[3]
		msg_out = "[doer.name] continues [act] your [part]!"
	msg_out = replacetext(msg_out, "<DOERS>", "[doer.p_their()]")
	msg_out = replacetext(msg_out, "<TARGETS>", "your")
	return msg_out

/datum/grope_kiss_MERP/proc/make_message_for_everyone(mob/doer, mob/target, list/actions, tense, part)
	if( LAZYLEN(actions) != 4)
		return
	var/msg_out = ""
	/// Dan slapped Tia's cheek!
	if(tense == "present")
		var/act = actions[4]
		msg_out = "[doer.name] [act] [target.name]'s [part]!"
	/// Dan continues to slap Tia's cheek!
	if(tense == "gerundo")
		var/act = actions[3]
		msg_out = "[doer.name] continues [act] [target.name]'s [part]!"
	msg_out = replacetext(msg_out, "<DOERS>", "[doer.p_their()]")
	msg_out = replacetext(msg_out, "<TARGETS>", "[target.p_their()]")
	return msg_out

/datum/grope_kiss_MERP/proc/make_message_for_myself_to_me(mob/doer, mob/target, list/actions, tense, part)
	if( LAZYLEN(actions) != 4)
		return
	var/msg_out = ""
	/// You slap your butt!
	if(tense == "present")
		var/act = actions[1]
		msg_out = "You [act] your [part]!"
	/// You continue slapping your butt!
	if(tense == "gerundo")
		var/act = actions[3]
		msg_out = "You continue [act] your [part]!"
	msg_out = replacetext(msg_out, "<DOERS>", "your")
	msg_out = replacetext(msg_out, "<TARGETS>", "your")
	return msg_out

/datum/grope_kiss_MERP/proc/make_message_for_myself_to_others(mob/doer, mob/target, list/actions, tense, part)
	if( LAZYLEN(actions) != 4)
		return
	var/msg_out = ""
	/// Dan slapped her butt!
	if(tense == "present")
		var/act = actions[4]
		msg_out = "[doer.name] [act] [doer.p_their()]'s [part]!"
	/// Dan continues slapping her butt!
	if(tense == "gerundo")
		var/act = actions[3]
		msg_out = "[doer.name] continues [act] [doer.p_their()]'s [part]!"
	msg_out = replacetext(msg_out, "<DOERS>", "[doer.p_their()]")
	msg_out = replacetext(msg_out, "<TARGETS>", "[doer.p_their()]")
	return msg_out

/datum/grope_kiss_MERP/proc/get_grope_target(mob/doer, mob/target, direc)
	var/here = doer.zone_selected
	return here

/datum/grope_kiss_MERP/proc/get_grope_intent(mob/living/doer, mob/target)
	switch(doer.combat_mode)
		if(INTENT_HELP)
			return "help"
		if(INTENT_DISARM)
			return "disarm"
		if(INTENT_GRAB)
			return "grab"
		if(INTENT_HARM)
			return "harm"

/datum/grope_kiss_MERP/proc/get_grope_list(partname, sidename, intentname, soundpls, just_part)
	var/varname = "[partname]" + "_" + "[sidename]"
	if(!just_part)
		varname += "_action_" + "[intentname]"
		if(soundpls)
			varname += "_sound"
	var/list/ret = list()
	if(vars[varname])
		ret |= vars[varname] // datums re just massive lists that are easier to read
	return ret

// returns if the doer is in front of, behind, or to a side of the target
// The three tiles in front of the target are considered the front, the one tile behind the target is considered the back
// The two tiles to the left and right of the target are considered the sides
/datum/grope_kiss_MERP/proc/calc_dir(mob/doer, mob/target)
	if(doer == target)
		if(doer.dir == NORTH)
			return "back"
		if(doer.dir == SOUTH)
			return "front"
		return "side"
	var/dirTarg = target.dir
	var/turf/D = get_turf(doer)
	var/turf/T = get_turf(target)
	if(D == T)
		// simple relative direction check
		var/dirDoer = doer.dir
		if(dirDoer == dirTarg)
			return "front"
		for(var/turnz in 1 to 3) // SPEEN
			var/turnt = turn(dirDoer, 90*turnz)
			if(turnz == 1 || turnz == 3)
				if(turnt == dirTarg)
					return "side"
			else
				if(turnt == dirTarg)
					return "front"
		return "back"
	/// now, check a special ring of turfs around the target
	var/list/turfz = list()
	turfz.len = 8
	/// front
	turfz[1] += get_step(T, dirTarg)
	turfz[2] += get_step(T, turn(dirTarg, 45))
	turfz[3] += get_step(T, turn(dirTarg, -45))
	/// sides
	turfz[4] += get_step(T, turn(dirTarg, 90))
	turfz[5] += get_step(T, turn(dirTarg, -90))
	turfz[6] += get_step(T, turn(dirTarg, 135))
	turfz[7] += get_step(T, turn(dirTarg, -135))
	/// back
	turfz[8] += get_step(T, turn(dirTarg, 180))
	for(var/i in 1 to 8)
		if(D == turfz[i])
			switch(i)
				if(1, 2, 3)
					return "front"
				if(4, 5, 6, 7)
					return "side"
				if(8)
					return "back"
	return "front"
