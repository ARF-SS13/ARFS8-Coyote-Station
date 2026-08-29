// ╔═════════╤═══════════════════════════════════╗
// ║ File    │ rumormill_subsustem.dm            ║
// ║ Date    │ 2004-06-19 22:00:00               ║
// ║ Author  │ Dan 'Watoitygafc' Kelly           ║
// ║ License │ PG-13                             ║
// ║ Quote   │ "So word around the office is..." ║
// ╟─────────┼───────────────────────────────────╨───────────────────────────────────────────────────╖
// ║         │                                                                                       ║
// ║  ####   │ Simple system that randomly passes rumors around the station, all of them are player  ║
// ║  ####   │ made! Some are NSFW but that checks prefs or something.                               ║
// ║         │                                                                                       ║
// ║         │ Planned features:                                                                     ║
// ║         │ - Rumors found in fortune cookies, weighted towards nethack rumors, but not always.   ║
// ║         │ - Wall graffiti, PDA messageboards, and other things that can be read to get rumors.  ║
// ║         │ - Rumors can be flagged as "identifiable", meaning it displays the name of the person ║
// ║         │   its about, for easier roleplay.                                                     ║
// ║         │ + Rumors put in a database, and are accessible to rounds that the player never even   ║
// ║         │   joined, up until a certain time passes and they become "stale" and are disabled     ║
// ║         │ - White Sign Soapstone                                                                ║
// ║         │ - Rumors people can make up *about* other players                                     ║
// ║         │ - An admin tool to moderate these wretched things!                                    ║
// ║         │                                                                                       ║
// ╟─────────┼───────────────────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ===================================================================================  ║
// ╚═════════╧═══════════════════════════════════════════════════════════════════════════════════════╝
#define HORNYMODE_NONE      0
#define HORNYMODE_EITHEROR  1
#define HORNYMODE_ONLYHORNY 2
#define RUMOR_LOG            "data/rumormill/debug_log.txt"
#define RUMOR_STATS(kind)    "data/rumormill/misc_stats/[kind].json"
#define RUMOR_METRIX(ident)  "data/rumormill/metrix/[ident].json"
#define RUMOR_GRAVE          "data/rumormill/rumor_graveyard.json"
#define RUMOR_PATH           "data/rumormill/rumormine/"
#define RUMOR_FILE(filename) "[RUMOR_PATH][filename]"
SUBSYSTEM_DEF(rumormill)
	name = "RumorMill"
	wait = 10 SECONDS
	runlevels = parent_type::runlevels | RUNLEVEL_LOBBY
	/// all loaded rumor_holders, keyed by ckey
	var/list/rumors = list()
	/// the nethack rumor holder, which is a special case
	var/datum/rumor_holder/nethack/nethack_rumors
	/// the rumor admin tool, which may be awful
	var/datum/rumor_admin_thingy/rat
	/// tell the server when the rumor mill failed to save
	var/debug = FALSE
	var/debug_stats = FALSE
	/// the maximum number of rumors per character slot
	var/max_rumors_per_slot = 50
	/// my clopboard, currently full of twilight sparkle and other things
	var/list/clipboards = list() // thats right, we've got a damn clipboards
	/// dead rumors to be saved foreverially
	var/list/graveyard = list()
	var/graveyard_durty = FALSE

	/// rumor spreadder vars
	/// When a set of rumors is primed to be spread, this is the interval it'll be spread to each lucky player
	var/rm_spread_interval_min = 10 MINUTES
	var/rm_spread_interval_max = 15 MINUTES
	var/rm_next_spread_time = 0
	var/rm_force_new_targets_next = 0
	/// per player, when gathering keys to spread to, is the chance they'll be chosen
	var/rm_spread_chance = 50
	/// how often the rumor mill will gather a new set of rumors to spread, and pick new targets to spread them to
	var/rm_gather_interval = 30 MINUTES
	var/rm_gather_initial_delay = 5 MINUTES
	var/rm_gather_next = 0
	/// percent chance to ignore online check for the rumor source
	var/rm_pick_offline_chance = 25
	/// timedate cutoff for offline players for their rumors to be considered stale and (generally) not spread
	var/rm_stale_cutoff = 7 DAYS
	var/rm_stale_cutoff_hard = 14 DAYS
	/// percent chance to ignore the stale cutoff for offline players
	var/rm_pick_stale_chance = 25
	/// working vars for rumor dissemination
	/// list of several rumors to be spread, hopefully enough that everyone'll hear a rumor that they havent heard yet
	var/list/rm_rumors_to_spread = list()
	var/list/rm_rumors_to_spread_horny = list()
	var/list/rm_rumors_to_spread_offline = list()
	var/list/rm_rumors_to_spread_offline_horny = list()
	var/list/rm_rumors_to_spread_specificable = list()
	/// rumors that were spread already
	var/list/rm_rumors_used = list()
	var/rm_used_clear_interval = 3 HOURS
	var/rm_used_clear_next = 0
	var/rm_chance_to_just_be_some_silly_net_hack_rumor = 5
	/// ckey = timestamp they'll be sent a rumor
	/// lucky player ckeys chosen to receive a rumor
	var/list/rm_targets_queued = list()
	/// keys used, so everyone eventually gets a rumor at some point, and we dont just keep picking the same people over and over
	var/list/rm_targets_used = list()
	/// keys sourced from, so everyoine eventually gets to have their secrets exposed
	var/list/rm_sources_used = list()
	var/rm_target_batch_size = 5
	var/rm_source_batch_size = 3
	var/rm_source_stale_time = 20 MINUTES
	var/rm_heard_rumor_stale_time = 2 MINUTES // 1 DAYS // if a player hasnt heard this rumor in this long, they can hear it again
	// more metric junk
	// packets, written to a new statlog file every round
	var/round_identifier
	var/rumors_sent                    = 0
	var/saucy_rumors_sent              = 0
	var/rumors_killed_by_admins        = 0
	var/list/total_unique_rumors       = list() // rumor_uid = TRUE
	var/list/unique_rumors_sent        = list() // rumor_uid = times sent
	var/list/unique_saucy_rumors_sent  = list() // rumor_uid = times sent
	var/list/unique_recipients         = list() // ckey-slot
	var/list/unique_sources            = list() // ckey-slot
	var/list/nethack_rumors_sent       = list()
	var/list/total_rumorholding_sluts  = list()
	var/list/total_nondeleted_rumors   = list()
	var/list/total_deleted_rumors      = list()
	var/list/total_nsfw_rumors         = list()
	var/list/total_public_rumors       = list()
	var/list/total_specifiable_rumors  = list()
	var/list/total_secret_rumors       = list()
	var/list/total_private_rumors      = list()
	var/list/bigmetrix = list() // misc metricc
	var/next_metrix_save_time = 0
	var/metrix_save_interval = 15 MINUTES

/datum/controller/subsystem/rumormill/Initialize(start_timeofday)
	rustg_time_reset("rumors")
	LoadRumorsFromDisk()
	LoadNethackHolder()
	rat = new /datum/rumor_admin_thingy() // squeak
	var/keys_loaded = 0
	var/rumors_loaded = 0
	var/saucy_rumors = 0
	var/nethack_rumors_loaded = LAZYLEN(nethack_rumors.rumor_slots[1])
	for(var/ckey in rumors)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		keys_loaded += 1
		var/list/rumors = list()
		rumors.len = rholder.max_rumors_per_slot
		for(var/i in 1 to rholder.max_rumors_per_slot)
			rumors[i] = list() + rholder.get_all_rumors(i, FALSE)
			rumors_loaded += LAZYLEN(rholder.get_all_rumors(i, FALSE))
		for(var/datum/rumor/really_cool_rumor in rumors)
			if(really_cool_rumor.is_nsfw)
				saucy_rumors += 1

	to_chat(world, span_captaincast("Loaded [keys_loaded] rumor subjects!"))
	to_chat(world, span_captaincast("Loaded [rumors_loaded] rumors!"))
	to_chat(world, span_love("([saucy_rumors] of them are kinda saucy!~)"))
	to_chat(world, span_captaincast("Loaded [nethack_rumors_loaded] (mostly) nethack rumors!"))
	var/time = rustg_time_milliseconds("rumors")
	var/seconds = round(time / 1000, 0.01)
	to_chat(world, span_captaincast("And it was all loaded in [seconds] seconds!"))

/datum/controller/subsystem/rumormill/fire(resumed)
	var/yay = SaveRumorsToDisk()
	if(!yay)
		output_debug("RumorMill: Failed to save rumors to disk!", TRUE)
	yay = SaveMetrix()
	if(!yay)
		output_debug("RumorMill: Failed to save rumor metrix to disk!", TRUE)
	// todo!: SPREAD THE PAIN
	crank_rumor_mill()

// defs: source = who owns the rumor, target = who gets the rumor
// take two rumors, one horny, one not, and spread to a few random targets
// if target allows hearing horny rumors, pick between the two, otherwise pick the non-horny one
// biased towards rumors from online sources, tho it can do some offline ones too!
/// crank that soulja boi
/datum/controller/subsystem/rumormill/proc/crank_rumor_mill()
	//load em up
	clean_used_rumors()
	spread_those_rumors()

/datum/controller/subsystem/rumormill/proc/clean_used_rumors()
	if(rm_used_clear_next == 0)
		rm_used_clear_next = world.time + rm_used_clear_interval
		return
	if(rm_used_clear_next > world.time)
		return
	rm_used_clear_next = world.time + rm_used_clear_interval
	rm_rumors_used = list()

/// datums
/datum/rumor_recipient
	var/ckey = ""
	var/horny
	var/slot = 1
	var/list/rumors_heard = list()
	// filled out at the end
	var/time_to_receive = 0
	var/rumor_id
	var/rumor_slot
	var/rumor_source_key

/datum/rumor_source
	var/ckey = ""
	var/charname = ""
	var/slot = 1
	var/list/datum/rumor/cool_rumors = list()
	var/list/datum/rumor/cool_horny_rumors = list()

/datum/rumor_source/Destroy()
	cool_rumors = list()
	cool_horny_rumors = list()
	. = ..()

// lasagna ogre spermatazoa, vore chitter entree
/datum/controller/subsystem/rumormill/proc/spread_those_rumors(force_it)
	if(!force_it)
		if(rm_next_spread_time == 0)
			if(debug)
				rm_next_spread_time = world.time + 10 SECONDS
			else
				rm_next_spread_time = world.time + rm_spread_interval_min
			return
		if(rm_next_spread_time > world.time)
			return
		if(debug)
			rm_next_spread_time = world.time + 10 SECONDS
		else
			rm_next_spread_time = world.time + rand(rm_spread_interval_min, rm_spread_interval_max)

	var/list/metrix = list()
	var/list/online_recipients = get_online_recipients(metrix)
	if(!LAZYLEN(online_recipients))
		return
	var/list/chosen_recipients = choose_lucky_recipients(online_recipients, metrix)
	if(!LAZYLEN(chosen_recipients))
		return
	if(prob(rm_chance_to_just_be_some_silly_net_hack_rumor))
		return spread_nethack_rumor(chosen_recipients)
	var/offlines_too = prob(rm_pick_offline_chance)
	var/list/rumor_sources = choose_lucky_sources(offlines_too, metrix)
	if(!LAZYLEN(rumor_sources))
		return spread_nethack_rumor(chosen_recipients) // juist nethack them i guess
	var/list/source_datums = datumize_sources(rumor_sources, metrix)
	var/list/target_datums = datumize_targets(chosen_recipients, metrix)
	// time to disseminate the rumors, baby
	send_rumors(source_datums, target_datums, metrix)
	ditch_datums(source_datums, target_datums)
	for(var/thing_key in metrix)
		if(!bigmetrix[thing_key])
			bigmetrix[thing_key] = metrix[thing_key]
		else if (islist(bigmetrix[thing_key]) && islist(metrix[thing_key]))
			bigmetrix[thing_key] |= metrix[thing_key]
		else if (isnum(bigmetrix[thing_key]) && isnum(metrix[thing_key]))
			bigmetrix[thing_key] += metrix[thing_key]
		else
			bigmetrix[thing_key] = metrix[thing_key]
	return TRUE

/datum/controller/subsystem/rumormill/proc/get_online_recipients(list/metrix)
	// ckey = horny
	var/online_recipients = list()
	metrix["num_targets_start"] = LAZYLEN(GLOB.directory)
	for(var/ckey in GLOB.directory)
		var/client/C = GLOB.directory[ckey]
		if(!C)
			continue
		var/mob/living/current_mob = C.mob
		if(!isliving(current_mob))
			continue
		if(!safe_read_pref(current_mob, /datum/preference/toggle/rumors/hear_rumors))
			continue
		var/horny = safe_read_pref(current_mob, /datum/preference/toggle/rumors/hear_horny_rumors)
		online_recipients[ckey] = horny
	metrix["num_targets_online"] = LAZYLEN(online_recipients)
	//prefilter for people already who heard a thing
	var/list/filtered_recipients = online_recipients - rm_targets_used
	if(LAZYLEN(filtered_recipients) < rm_target_batch_size)
		rm_targets_used = list() // reset it, so we can pick from everyone again
		metrix["reset_targets_used"] = TRUE
		metrix["num_targets_prefiltered"] = LAZYLEN(filtered_recipients)
		return online_recipients
	metrix["num_targets_prefiltered"] = LAZYLEN(filtered_recipients)
	return filtered_recipients

/datum/controller/subsystem/rumormill/proc/choose_lucky_recipients(list/online_recipients, list/metrix)
	if(LAZYLEN(online_recipients) <= rm_target_batch_size)
		metrix["num_targets_chosen"] = LAZYLEN(online_recipients)
		return online_recipients
	var/list/chosen_recipients = list()
	for(var/i in 1 to min(rm_target_batch_size, LAZYLEN(online_recipients)))
		var/ckey = online_recipients[rand(1, LAZYLEN(online_recipients))]
		chosen_recipients[ckey] = online_recipients[ckey]
		online_recipients -= ckey
		if(!LAZYLEN(online_recipients))
			break
		// we'll set the rm_targets_used when they actually get something
	metrix["targets_chosen"] = ""
	for(var/ckey in chosen_recipients)
		metrix["targets_chosen"] += "[ckey], "
	metrix["num_targets_chosen"] = LAZYLEN(chosen_recipients)
	return chosen_recipients

/datum/controller/subsystem/rumormill/proc/choose_lucky_sources(offlines_too, list/metrix)
	var/list/online_sources = list()
	var/list/offline_sources = list()
	// ckey = list(1,2,3... slots)
	metrix["num_sources_start"] = LAZYLEN(rumors)
	for(var/ckey in rumors)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		if(!rholder)
			continue
		var/online = GLOB.directory[ckey]
		var/active_slot = extract_current_character_slot(ckey, TRUE)
		if(!active_slot)
			continue // no active slot, no rumors to spread
		online_sources[ckey] = list()
		offline_sources[ckey] = list()
		for(var/i in rholder.slots_with_stuff)
			var/actually_online = active_slot == i && online
			if(actually_online)
				online_sources[ckey] |= i
			else
				offline_sources[ckey] |= i
	metrix["num_sources_online"] = LAZYLEN(online_sources)
	metrix["num_sources_offline"] = LAZYLEN(offline_sources)
	metrix["offlines_too"] = offlines_too
	// sources sourted
	var/list/chosen_sources = online_sources
	if(offlines_too)
		chosen_sources |= offline_sources
	// filter for people already who had their rumors spread
	var/list/filtered_sources = chosen_sources - rm_sources_used
	if(LAZYLEN(filtered_sources) < rm_source_batch_size)
		metrix["reset_sources_used"] = TRUE
		rm_sources_used = list() // reset it, so we can pick from everyone again
		filtered_sources = chosen_sources
	if(LAZYLEN(filtered_sources) < rm_source_batch_size)
		metrix["num_sources_prefiltered"] = LAZYLEN(filtered_sources)
		return filtered_sources // lowpop or something
	if(!LAZYLEN(filtered_sources))
		return list() // no sources to choose from
	metrix["num_sources_prefiltered"] = LAZYLEN(filtered_sources)
	var/list/outsources = list()
	for(var/i in 1 to min(rm_source_batch_size, LAZYLEN(filtered_sources)))
		var/ckey = filtered_sources[rand(1, LAZYLEN(filtered_sources))]
		outsources[ckey] = filtered_sources[ckey]
		filtered_sources -= ckey
		if(!LAZYLEN(filtered_sources))
			break
	metrix["num_sources_chosen"] = LAZYLEN(outsources)
	return outsources

/datum/controller/subsystem/rumormill/proc/datumize_sources(list/sources, list/metrix)
	var/list/source_datums = list()
	for(var/ckey in sources)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		for(var/slot in sources[ckey])
			var/datum/rumor_source/source = new()
			source.ckey = ckey
			source.slot = slot
			var/list/datum/rumor/cool_rumors = rholder.get_all_rumors(slot, FALSE)
			shuffle_inplace(cool_rumors)
			for(var/datum/rumor/really_cool_rumor in cool_rumors)
				if(really_cool_rumor.is_nsfw)
					source.cool_horny_rumors |= really_cool_rumor
				else
					source.cool_rumors |= really_cool_rumor
			source.charname = rholder.get_character_name(slot)
			source_datums += source
	shuffle_inplace(source_datums)
	return source_datums

/datum/controller/subsystem/rumormill/proc/datumize_targets(list/recipients, list/metrix)
	var/list/target_datums = list()
	for(var/ckey in recipients)
		var/datum/rumor_recipient/target = new()
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		var/current_slot = extract_current_character_slot(ckey)
		if(!current_slot)
			qdel(target) // wouldnt work anyway
			continue
		target.ckey = ckey
		target.horny = safe_read_pref(ckey, /datum/preference/toggle/rumors/hear_horny_rumors)
		rholder.trim_rumors_heard() // trim out stale rumors, so we dont send them again
		target.rumors_heard = list()
		if(rholder.rumors_heard.len >= current_slot)
			target.rumors_heard |= rholder.rumors_heard[current_slot]
		target.slot = current_slot
		target_datums += target
	return target_datums

/datum/controller/subsystem/rumormill/proc/send_rumors(list/source_datums, list/target_datums, list/metrix)
	if(!LAZYLEN(source_datums) || !LAZYLEN(target_datums))
		return
	// for each target, choose a source, and find a rumor to send to them
	// if source doesnt have any rumors target likes, pick a new source, and try again
	// run out? just use a nethack rumor, and log it
	var/list/rejected_targets = list()
	var/nethacked = 0
	var/rumors_sent = 0
	for(var/datum/rumor_recipient/target in target_datums)
		// biased to the top of the list, and thus, to the same person
		var/sent_something = FALSE
		for(var/datum/rumor_source/source in source_datums)
			if(source.ckey == target.ckey && source.slot == target.slot && !debug)
				continue // dont send a rumor to yourself, thats just sad. from your other characters is ok tho
			var/list/rumors_to_send = source.cool_rumors
			if(target.horny)
				rumors_to_send |= source.cool_horny_rumors
			// filter out rumors the target has already heard
			for(var/datum/rumor/really_cool_rumor in rumors_to_send)
				if(target.rumors_heard[really_cool_rumor.rumor_uid])
					rumors_to_send -= really_cool_rumor
			if(!LAZYLEN(rumors_to_send))
				continue // try a new source, maybe they have something target can hear
			var/datum/rumor/really_cool_rumor = pick(rumors_to_send)
			sent_something = send_rumor_to_target(target, source, really_cool_rumor)
			if(sent_something)
				rumors_sent += 1
			break
		if(!sent_something) // just give em a nethack or something
			spread_nethack_rumor(list(target))
			nethacked += 1
	metrix["rumors_sent"] = rumors_sent
	metrix["nethacked"] = nethacked
	metrix["num_targets_rejected"] = LAZYLEN(rejected_targets)

/datum/controller/subsystem/rumormill/proc/ditch_datums(list/source_datums, list/target_datums)
	for(var/datum/rumor_source/source in source_datums)
		qdel(source)
	for(var/datum/rumor_recipient/target in target_datums)
		qdel(target)

/datum/controller/subsystem/rumormill/proc/spread_nethack_rumor(list/target_ppl)
	if(!nethack_rumors)
		return
	var/list/rumorhack = nethack_rumors.rumor_slots[1]
	if(!LAZYLEN(rumorhack))
		CRASH("RumorMill: No nethack rumors to spread!")
	var/rumorhack_key = pick(rumorhack)
	var/datum/rumor/really_cool_rumor = rumorhack[rumorhack_key]
	var/datum/rumor_source/source = new
	source.ckey = "the_dungeons_of_doom"
	for(var/datum/rumor_recipient/target in target_ppl)
		var/datum/rumor_recipient/targa = new
		targa.ckey = target.ckey
		targa.slot = target.slot
		send_rumor_to_target(targa, source, really_cool_rumor)

/datum/controller/subsystem/rumormill/proc/send_rumor_to_target(datum/rumor_recipient/target, datum/rumor_source/source, datum/rumor/really_cool_rumor)
	var/mob/living/current_mob = extract_mob(target.ckey)
	if(!isliving(current_mob))
		return
	var/hacker = source.ckey == "the_dungeons_of_doom"
	var/static/list/you_hears = list(
		"You recall an overheard rumor... ",
		"You remember something you may have heard... ",
		"You think to yourself... ",
		"A stray thought comes to mind... ",
		"Rumor has it... ",
		"What if... ",
	)
	var/static/list/you_hear_about_someones = list(
		"You remember hearing something about $SOURCENAME... ",
		"You recall a rumor about $SOURCENAME... ",
	)
	var/preamble = ""
	if(really_cool_rumor.is_specificable && !hacker)
		var/mob/living/source_mob = extract_mob(really_cool_rumor.my_holder.c_key)
		var/name = "someone"
		if(isliving(source_mob))
			name = source_mob.real_name
		preamble = replacetext(pick(you_hear_about_someones), "$SOURCENAME", name)
	else
		preamble = pick(you_hears)
	var/text = really_cool_rumor.rumor_text
	var/hrny = really_cool_rumor.is_nsfw
	var/outer_style = {"
		font-style: italic;
		padding: 0.1em;
		border: 1px solid #888;
		background-color: [hrny ? "#ff00f220" : "#002aff20"];
		color: [hrny ? "#c850ff" : "#5050FF"];
	"}
	var/static/inner_style = {"
		font-style: normal;
		padding-left: 0.5em;
	"}
	var/wholething = "<div style='[outer_style]'>[preamble]<div style='[inner_style]'>[text]</div></div>"
	to_chat(current_mob, wholething)

	// mark it as heard for this target, and mark the rumor as used so it wont be sent again for a while
	var/datum/rumor_holder/rholder = GetRumorHolder(target.ckey)
	rholder.heard_rumor(really_cool_rumor, target)
	rm_rumors_used |= really_cool_rumor.rumor_uid
	rm_targets_used += target.ckey
	rm_sources_used += source.ckey
	rumors_sent += 1
	if(really_cool_rumor.is_nsfw)
		saucy_rumors_sent += 1
		unique_saucy_rumors_sent[really_cool_rumor.rumor_uid] += 1
	unique_rumors_sent["[source.ckey]-[really_cool_rumor.rumor_uid]-[source.slot]"] += 1
	if(hacker)
		nethack_rumors_sent[really_cool_rumor.rumor_uid] += 1
	unique_recipients["[target.ckey]-[target.slot]"] += 1
	unique_sources["[source.ckey]-[source.slot]"] += 1
	return TRUE



/datum/controller/subsystem/rumormill/proc/get_online_character_slot(ckey)
	var/client/C = GLOB.directory[ckey]
	if(!C)
		return
	var/mob/living/current_mob = C.mob
	if(!isliving(current_mob))
		return
	return extract_current_character_slot(current_mob, TRUE)

/datum/controller/subsystem/rumormill/proc/output_stats(list/log, logname)
	var/file = RUMOR_STATS(logname)
	var/dat = json_encode(log, JSON_PRETTY_PRINT)
	if(!fexists(file))
		rustg_file_write(dat, file)
	else
		rustg_file_append(dat, file)

/datum/controller/subsystem/rumormill/proc/LoadNethackHolder()
	nethack_rumors = new /datum/rumor_holder/nethack("the_dungeons_of_doom")

/datum/controller/subsystem/rumormill/proc/GetRumorHolder(ckey)
	var/datum/rumor_holder/rholder = rumors["[ckey]"]
	if(rholder)
		return rholder
	rholder = new /datum/rumor_holder(ckey)
	rumors["[ckey]"] = rholder
	return rholder

/datum/controller/subsystem/rumormill/proc/CopyRumor(mob/user, ckey, rumor_uid, slot)
	if(!user || !istext(ckey))
		return
	var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
	var/char_slot = slot || extract_current_character_slot(user)
	var/list/to_copy = list()
	if(!isnull(rumor_uid))
		to_copy |= list(rumor_uid)
	else // get all of em in this slot
		to_copy |= rholder.get_keys(char_slot)
	var/list/true_copy = list()
	for(var/rumor_ in to_copy)
		var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_, char_slot)
		if(really_cool_rumor)
			true_copy += list(really_cool_rumor)
	clipboards[ckey] = true_copy // could clear it if nothings there, which is intended
	if(user)
		if(LAZYLEN(true_copy) == 0)
			if(prob(5))
				to_chat(user, span_notice("Couldn't copy anything to your clopboard!"))
			else
				to_chat(user, span_notice("Couldn't copy anything to your clipboards!"))
		else
			if(prob(5))
				to_chat(user, span_notice("Copied [LAZYLEN(true_copy)] rumors to your clopboard!"))
			else
				to_chat(user, span_notice("Copied [LAZYLEN(true_copy)] rumors to your clipboards!"))

/datum/controller/subsystem/rumormill/proc/PasteRumor(mob/user, ckey, slot)
	if(!user || !istext(ckey))
		return
	var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
	var/char_slot = slot || extract_current_character_slot(user)
	var/list/to_paste = clipboards[ckey] || list()
	if(!LAZYLEN(to_paste))
		if(user)
			if(prob(5))
				to_chat(user, span_notice("Your clopboard is empty!"))
			else
				to_chat(user, span_notice("Your clipboards is empty!"))
		return
	// itll append the rumors, or replace them if a rumor with the same uid already exists
	var/numpasted = 0
	var/ran_over = FALSE
	for(var/datum/rumor/really_cool_rumor in to_paste)
		if(!rholder.has_room_for_more_rumors(char_slot))
			ran_over = TRUE
			break
		rholder.add_rumor_from_rumor(really_cool_rumor, char_slot)
		numpasted += 1
	if(user)
		if(ran_over)
			if(numpasted == 0)
				to_chat(user, span_notice("Couldnt paste any rumors to your character slot! You already have the maximum number of rumors for this character slot!"))
			else
				to_chat(user, span_notice("Pasted [numpasted] of the [LAZYLEN(to_paste)] rumors in your cl[prob(5)?"o":"i"]pboard to your character slot! Couldnt do the rest cus theres no more room!"))
		else
			if(user)
				to_chat(user, span_notice("Pasted [numpasted] rumors to your character slot!"))
	if(numpasted >= 1)
		rholder.set_durty(TRUE)
		// if(ran_over)
		// 	var/list/clupboard = clipboards[ckey]
		// 	clubboard.Cut(1, numpasted+1) // remove the ones we pasted, so we dont paste them again
		// 	clipboards[ckey] = clubboard
		// else
		clipboards[ckey] = list() // clear the clipboards after pasting, so you dont paste it again
		if(user)
			if(prob(5))
				to_chat(user, span_notice("Clopboard is now cleared!"))
			else
				to_chat(user, span_notice("Clipboard is now cleared!"))

/datum/controller/subsystem/rumormill/proc/get_examine_rumor_display_text_for_tgui(mob/user)
	if(!user)
		return list()
	var/ckey = user.ckey
	if(!istext(ckey))
		return list()
	var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
	var/char_slot = extract_current_character_slot(user)
	var/list/rumors = rholder.get_all_rumors(char_slot, FALSE)
	var/list/data = list()
	data["rumor_examine"] = list()
	data["rumor_examine"]["horny_ones"] = list()
	data["rumor_examine"]["tame_ones"] = list()
	for(var/datum/rumor/really_cool_rumor in rumors)
		if(really_cool_rumor.is_secret)
			continue
		var/list/paquet = really_cool_rumor.serialize_rumor()
		if(really_cool_rumor.is_nsfw)
			data["rumor_examine"]["horny_ones"] += list(paquet)
		else
			data["rumor_examine"]["tame_ones"] += list(paquet)
	return data

/datum/controller/subsystem/rumormill/proc/send_to_graveyard(datum/rumor/ded)
	if(!ded)
		return
	var/client_key = ded.my_holder.c_key
	var/mob/who = LAZYACCESS(GLOB.directory, client_key)
	var/mobname = who ? who.real_name : client_key
	graveyard |= "[client_key] -- [mobname] -- [ded.rumor_text]"
	graveyard_durty = TRUE

/datum/controller/subsystem/rumormill/proc/get_random_nethack_rumor(just_the_string = TRUE)
	var/datum/rumor/nethack_rumor = nethack_rumors.get_random_rumor()
	if(just_the_string)
		return nethack_rumor.rumor_text
	return nethack_rumors

/datum/controller/subsystem/rumormill/proc/get_random_non_saucy_rumor(just_the_string = TRUE, obey_used_rumors = TRUE)
	return get_random_rumor(just_the_string, HORNYMODE_NONE, obey_used_rumors)

/datum/controller/subsystem/rumormill/proc/get_random_rumor(just_the_string = TRUE, hornymode = HORNYMODE_NONE, obey_used_rumors = TRUE)
	var/random_ckey = pick(rumors)
	var/datum/rumor_holder/rholder = GetRumorHolder(random_ckey)
	if(just_the_string)
		return rholder.get_random_rumor_string(hornymode, obey_used_rumors)
	return rholder.get_random_rumor(hornymode, obey_used_rumors)

/// clicked the new rumor button, so add a new rumor to the system
/// will be random or something
/datum/controller/subsystem/rumormill/proc/add_new_rumor(mob/user, slot, loud)
	if(!user)
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	if(!slot)
		slot = extract_current_character_slot(user)
	if(!rholder.has_room_for_more_rumors(slot))
		if(loud)
			to_chat(user, span_notice("You already have the maximum number of rumors for this character slot!"))
		return FALSE
	if(!rholder.add_new_rumor(user, slot))
		if(loud)
			to_chat(user, span_notice("You already have the maximum number of rumors for this character slot!"))
		return FALSE
	if(loud)
		to_chat(user, span_captaincast("Added a new rumor!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/delete_rumor(mob/user, rumor_uid, slot, loud, kill)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	rholder.remove_rumor(rumor_uid, slot, kill)
	if(loud)
		var/datum/rumor/so_called_dead_rumor = rholder.get_rumor(rumor_uid, slot, kill)
		var/rumor_text = so_called_dead_rumor.rumor_text
		to_chat(user, span_captaincast("Deleted that rumor! The text was: [rumor_text]"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/edit_rumor_text(mob/user, rumor_uid, slot)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!really_cool_rumor)
		return
	really_cool_rumor.edit_text(user)
	return TRUE

/datum/controller/subsystem/rumormill/proc/toggle_rumor_nsfw(mob/user, rumor_uid, slot, loud)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!really_cool_rumor)
		return
	var/now_state = really_cool_rumor.toggle_nsfw(user)
	if(loud)
		to_chat(user, span_notice("Okay! That rumor is now flagged as [now_state ? "NSFW" : "SFW"]!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/move_rumor_up(mob/user, rumor_uid, slot)
	move_rumor(user, rumor_uid, slot, FALSE)
/datum/controller/subsystem/rumormill/proc/move_rumor_down(mob/user, rumor_uid, slot)
	move_rumor(user, rumor_uid, slot, TRUE)
/datum/controller/subsystem/rumormill/proc/move_rumor(mob/user, rumor_uid, slot, down = FALSE)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/moved = rholder.move_rumor(rumor_uid, slot, down)
	if(moved)
		to_chat(user, span_notice("Okay! Moved that rumor [down ? "down" : "up"]!"))
	else
		to_chat(user, span_notice("Cannot move that rumor [down ? "down" : "up"] any further!"))
	return TRUE

/*
toggle_rumor_public
toggle_rumor_specifiable
 */
/datum/controller/subsystem/rumormill/proc/toggle_rumor_public(mob/user, rumor_uid, slot, loud)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!really_cool_rumor)
		return
	var/new_public = really_cool_rumor.toggle_public(user)
	if(loud)
		to_chat(user, span_notice("Okay! That rumor is now [new_public ? "public" : "private"]!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/toggle_rumor_specifiable(mob/user, rumor_uid, slot, loud)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!really_cool_rumor)
		return
	var/new_specifiable = really_cool_rumor.toggle_specifiable(user)
	if(loud)
		var/will_now
		if(new_specifiable)
			will_now = "will now include additional identifiable information about your character"
		else
			will_now = "will no longer include additional identifiable information about your character"
		to_chat(user, span_notice("Okay! That rumor [will_now]!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/toggle_rumor_secret(mob/user, rumor_uid, slot, loud)
	if(!user || !istext(rumor_uid))
		return FALSE
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!really_cool_rumor)
		return FALSE
	var/new_secret = really_cool_rumor.toggle_secret(user)
	if(loud)
		to_chat(user, span_notice("Okay! That rumor is now [new_secret ? "secret" : "not secret"]!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/get_rumors_for_tgui(mob/user, slot)
	var/list/data = list()
	var/datum/rumor_holder/my_holder = SSrumormill.GetRumorHolder(user.client.ckey)
	var/charslot = slot || extract_current_character_slot(user)
	data["player_rumor_slot"] = my_holder.serialize_slot(charslot)
	return data

// used for the admin tool. also gets deleted rumors, just to spot no no people
/datum/controller/subsystem/rumormill/proc/get_all_rumors_for_admin_tgui()
	var/list/data = list() // to tgui: <RumorMuncher2000Data>
	data["rumor_database"] = list()
	var/list/yiffkeys = list()
	for(var/c__key in rumors)
		yiffkeys += c__key
	yiffkeys = sort_list(yiffkeys) // sorted!
	for(var/ckey in yiffkeys)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		var/list/rumor_holder_data = rholder.serialize_rumor_holder(FALSE)
		data["rumor_database"]["[ckey]"] = rumor_holder_data
	data["rumor_keys"] = yiffkeys.Copy()
	return data // this could get hairy if there are a lot of rumors, but its only for admins so whatever

/datum/controller/subsystem/rumormill/proc/open_admin_tool(mob/user)
	if(!user || !is_admin(user))
		return
	rat.open_admin_tool(user)

/*
 * [ckey]_rumors.json
 * In list format, it looks like this:
 * list(
 *   "ckey" = "ckey_of_player",
 *   "last_online" = "byond_world_time_thing",
 *   "slot_holder" = list(
 *     list(
 *       "slot"            = 1,
 *       "heard_rumors"   = list(
 *         "unique_id_1" = 1,
 *         "unique_id_2" = 1,
 *         ...
 *       ),
 *       "character_name"  = list(
 *         "Dank Elly" = 1,
 *       ),
 *       "rumors"          = list(
 *         list(
 *           "uid"           = "unique_id",
 *           "text"          = "the rumor text",
 *           "horny"         = 1 or 0,
 *           "public"        = 1 or 0,
 *           "specificable"  = 1 or 0,
 *           "secret"        = 1 or 0,
 *           "times_spread"  = "number_of_times_spread",
 *           "deleted_time"  = "time_it_was_deleted" // i aint getting rid of history
 *           "created_time"  = "time_it_was_created"
 *           "modified_time" = "time_it_was_modified"
 *         ),
 *         ...
 *     )
 *     ...
 * )
 */
/datum/controller/subsystem/rumormill/proc/LoadRumorsFromDisk(oh_no)
	if(LAZYLEN(rumors) > 0)
		if(!oh_no)
			message_admins("RumorMill: Loading rumors from disk, but there are already rumors in memory! This is probably a bad idea!")
			CRASH("RumorMill: Loading rumors from disk, but there are already rumors in memory! This is probably a bad idea!")
		// only accessible by direct admin proc calling, so its on them
		QDEL_LIST_ASSOC_VAL(rumors)
	// superlagg_rumors.json, fuzzy_rumors.json, etc
	var/list/rumor_paths = flist(RUMOR_PATH)
	for(var/filename in rumor_paths)
		var/datta = rustg_file_read(RUMOR_FILE(filename))
		if(!datta)
			continue
		var/list/rumor_core = json_decode(datta)
		if(!rumor_core || !islist(rumor_core) || !LAZYLEN(rumor_core))
			continue

		var/ckey = rumor_core["ckey"]
		if(!istext(ckey))
			continue
		// one rumor holder per ckey, with lists for each character slot
		var/datum/rumor_holder/rholder = new /datum/rumor_holder(ckey)
		var/last_online = rumor_core["last_online"]
		var/list/slot_holder = rumor_core["slot_holder"]
		if(rholder.check_heartbeat())
			rholder.last_online = world.realtime // theyre online, so set it to now
		else
			rholder.last_online = last_online

		// the list of slot datas, for each character slot
		for(var/list/slot in slot_holder)
			if(!LAZYLEN(slot["rumors"]) && !LAZYLEN(slot["character_name"]) && !LAZYLEN(slot["rumors_heard"]))
				continue
			var/slotnum = slot["slot"] // 1, 2, etc
			if(!isnum(slotnum))
				slotnum = text2num(slotnum) || 1
			var/character_name = slot["character_name"]
			rholder.character_names[slotnum] = list() | character_name
			var/rumheard = slot["rumors_heard"]
			rholder.rumors_heard[slotnum] = list() | rumheard
			var/list/rumors_in_slot = slot["rumors"]
			if(!islist(rumors_in_slot) || !LAZYLEN(rumors_in_slot))
				continue

			// the list of rumors in this slot
			for(var/list/rumordat in rumors_in_slot)
				var/rumor_uid = rumordat["uid"]
				var/rumor_text = rumordat["text"]
				var/rumor_horny = rumordat["horny"]
				var/rumor_public = rumordat["public"]
				var/rumor_secret = rumordat["secret"]
				var/rumor_deleted_time = rumordat["deleted_time"]
				var/rumor_specificable = rumordat["specificable"]
				var/rumor_times_spread = rumordat["times_spread"]
				var/rumor_created_time = rumordat["created_time"]
				var/rumor_modified_time = rumordat["modified_time"]
				rholder.add_rumor(
					slotnum,
					rumor_text,
					rumor_uid,
					rumor_horny,
					rumor_public,
					rumor_specificable,
					rumor_deleted_time,
					rumor_times_spread,
					rumor_created_time,
					rumor_modified_time,
					rumor_secret,
				)
		rumors["[ckey]"] = rholder
		rholder.post_load()
	// then the graveyard, which is a list of deleted rumors, for history and admin purposes
	var/datta = rustg_file_read(RUMOR_GRAVE)
	if(!datta)
		return
	var/list/graveyard_core = json_decode(datta)
	if(!graveyard_core || !islist(graveyard_core) || !LAZYLEN(graveyard_core))
		return
	graveyard = graveyard_core // just a list of strings, so we can just assign it

/datum/controller/subsystem/rumormill/proc/SaveRumorsToDisk(every_single_one_too)
	var/coolyay = TRUE
	for(var/ckey in rumors)
		update_rumor_person(ckey)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		if(!rholder.durty && !every_single_one_too)
			continue
		var/rumor_core = rholder.serialize_rumor_holder(TRUE)
		var/filename = RUMOR_FILE("[ckey]_rumors.json")
		var/datta = json_encode(rumor_core, JSON_PRETTY_PRINT) // maek it all prettylike
		rustg_file_write(datta, filename)
		var/client/C = LAZYACCESS(GLOB.directory, ckey)
		var/yay = TRUE
		output_debug("RumorMill: Saved rumors for [ckey] to disk at [filename]!")
		var/datta2 = rustg_file_read(filename)
		if(!datta2)
			yay = FALSE
			output_debug("RumorMill: Failed to read back the file we just saved for [ckey] at [filename]!", TRUE)
		else
			if(datta2 != datta)
				yay = FALSE
				output_debug("RumorMill: The file we just saved for [ckey] at [filename] does not match the data we wrote to it!", TRUE)
			var/list/rson = json_decode(datta2)
			if(!rson || !islist(rson) || !LAZYLEN(rson))
				yay = FALSE
				output_debug("RumorMill: Failed to decode the file we just saved for [ckey] at [filename]!", TRUE)
			var/list/rson2 = json_decode(datta)
			if(!rson2 || !islist(rson2) || !LAZYLEN(rson2))
				yay = FALSE
				output_debug("RumorMill: Failed to decode the data we wrote to the file for [ckey] at [filename]!", TRUE)
			if(yay)
				output_debug("RumorMill: The file we just saved for [ckey] at [filename] matches the data we wrote to it, hooray!")
		if(!yay)
			coolyay = FALSE
			output_debug("RumorMill: Failed to save rumors for [ckey] to disk at [filename]!", TRUE)
			to_chat(extract_client(ckey), span_notice("RumorMill: Failed to save your rumors to disk! Please report this to an admin!"))
		else
			rholder.set_durty(FALSE) // we just saved it, so its not durty anymore
			if(C)
				if(isnewplayer(C.mob))
					to_chat(C, span_notice("RumorMill: Saved your rumors to disk!"))

	var/ghoulyay = TRUE
	if(graveyard_durty)
		var/datta = json_encode(graveyard, JSON_PRETTY_PRINT)
		var/yay = rustg_file_write(datta, RUMOR_GRAVE)
		if(!yay)
			ghoulyay = FALSE
			output_debug("RumorMill: Failed to save the rumor graveyard to disk at [RUMOR_GRAVE]!")
		else
			output_debug("RumorMill: Saved the rumor graveyard to disk at [RUMOR_GRAVE]!")
		if(!ghoulyay)
			coolyay = FALSE
	return coolyay

/datum/controller/subsystem/rumormill/proc/SaveMetrix()
	if(!round_identifier)
		var/now = time2text(world.realtime, "YYYY-MM-DD_HH-MM", -8) // PST timezone
		round_identifier = "[now]-[GLOB.round_id]-fuzzys_cute_butt"
	if(next_metrix_save_time > world.realtime)
		return TRUE
	next_metrix_save_time = world.realtime + metrix_save_interval
	update_metrix()
	var/list/metrix2save = bigmetrix.Copy()
	metrix2save["round_identifier"]          = round_identifier
	metrix2save["rumors_sent"]               = rumors_sent
	metrix2save["rumors_killed_by_admins"]   = rumors_killed_by_admins
	metrix2save["unique_rumors_sent"]        = LAZYLEN(unique_rumors_sent)
	metrix2save["most_sent_rumor"]           = get_most_often_sent_rumor(unique_rumors_sent)
	metrix2save["unique_recipients"]         = LAZYLEN(unique_recipients)
	metrix2save["unique_sources"]            = LAZYLEN(unique_sources)
	metrix2save["nethack_rumors_sent"]       = LAZYLEN(nethack_rumors_sent)
	metrix2save["most_sent_nethack_rumor"]   = get_most_often_sent_rumor(nethack_rumors_sent)
	metrix2save["saucy_rumors_sent"]         = LAZYLEN(saucy_rumors_sent)
	metrix2save["unique_saucy_rumors_sent"]  = LAZYLEN(unique_saucy_rumors_sent)
	metrix2save["total_unique_rumors"]       = LAZYLEN(total_unique_rumors)
	metrix2save["total_rumorholding_sluts"]  = LAZYLEN(total_rumorholding_sluts)
	metrix2save["total_nondeleted_rumors"]   = LAZYLEN(total_nondeleted_rumors)
	metrix2save["total_deleted_rumors"]      = LAZYLEN(total_deleted_rumors)
	metrix2save["total_nsfw_rumors"]         = LAZYLEN(total_nsfw_rumors)
	metrix2save["total_public_rumors"]       = LAZYLEN(total_public_rumors)
	metrix2save["total_specifiable_rumors"]  = LAZYLEN(total_specifiable_rumors)
	metrix2save["total_secret_rumors"]       = LAZYLEN(total_secret_rumors)
	metrix2save["total_private_rumors"]      = LAZYLEN(total_private_rumors)
	var/datta = json_encode(metrix2save, JSON_PRETTY_PRINT)
	var/filename = RUMOR_METRIX(round_identifier)
	rustg_file_write(datta, filename)
	if(debug)
		var/readback = rustg_file_read(filename)
		if(readback != datta)
			output_debug("RumorMill: Failed to save the rumor metrix to disk at [filename]!", TRUE)
		else
			output_debug("RumorMill: Saved the rumor metrix to disk at [filename]!")
	return TRUE

/datum/controller/subsystem/rumormill/proc/get_most_often_sent_rumor(list/rumors_sent)
	var/biggestest = 0
	var/bigrumor = ""
	for(var/rumor_uid in rumors_sent)
		var/numsent = rumors_sent[rumor_uid]
		if(numsent > biggestest)
			biggestest = numsent
			bigrumor = rumor_uid
	var/list/broke_up = splittext(bigrumor, "-")
	if(LAZYLEN(broke_up) < 3)
		return "idk, something went wrong, but it was sent [biggestest] times"
	else
		var/datum/rumor_holder/rholder = GetRumorHolder(broke_up[1])
		var/datum/rumor/really_cool_rumor = rholder.get_rumor(broke_up[2], broke_up[3])
		if(really_cool_rumor)
			return "[broke_up[1]]'s rumor: [really_cool_rumor.rumor_text] (sent [biggestest] times)"
		else
			return "idk, didnt work, but it was sent [biggestest] times"

/datum/controller/subsystem/rumormill/proc/update_metrix()
	// okay lets update EVERYTHING
	// go through every darn rumor in existence and count it up
	for(var/ckey in rumors)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		for(var/i in 1 to LAZYLEN(rholder.rumor_slots))
			var/list/rumors_in = rholder.rumor_slots[i]
			if(LAZYLEN(rumors_in))
				total_rumorholding_sluts["[ckey]-[i]"] = LAZYLEN(rumors_in)
			for(var/ruid in rumors_in)
				// process each rumor UID as needed
				var/datum/rumor/R = rumors_in[ruid]
				total_unique_rumors["[ruid]"] = TRUE
				if(R.deleted_time == 0)
					total_nondeleted_rumors["[ruid]"] = TRUE
				else
					total_deleted_rumors["[ruid]"] = TRUE
				if(R.is_nsfw)
					total_nsfw_rumors["[ruid]"] = TRUE
				if(R.is_public)
					total_public_rumors["[ruid]"] = TRUE
				else
					total_private_rumors["[ruid]"] = TRUE
				if(R.is_specificable)
					total_specifiable_rumors["[ruid]"] = TRUE
				if(R.is_secret)
					total_secret_rumors["[ruid]"] = TRUE

/datum/controller/subsystem/rumormill/proc/output_debug(text, do_it_anyways)
	if(!debug && !do_it_anyways)
		return
	var/now = time2text(world.realtime, null, -8) // PST timezone
	if(!fexists(RUMOR_LOG))
		rustg_file_write("-- LOG BEGIN [now] (kiss fuzzy on the cheeks) --\n", RUMOR_LOG)
	rustg_file_append("[now]: [text]\n", RUMOR_LOG)
	message_admins("RumorMill Debug: [text]")

// /datum/controller/subsystem/rumormill/proc/GenerateRumorUid()
	// var/uid = "[rand(100000, 999999)]"
	// for(var/i in 1 to 10)
	// 	if(prob(10))
	// 		uid += "-spanky"
	// 	uid += "-[rand(100000, 999999)]"
	// return "uid_[uid]"

// "Giggleton-Abernathy-Angerman-the-Delightful-Cute-Happily-Running-Beautiful-Carp-Shark-12345"
/datum/controller/subsystem/rumormill/proc/GenerateRumorUid()
	// a 1 in 40 scrotillion chance of collision, winner gets a kiss
	var/uid = "UID"
	var/adj1 = pick(GLOB.adjectives)
	var/adj2 = pick(GLOB.adjectives)
	var/adv = pick(GLOB.adverbs)
	var/ingverb = pick(GLOB.ing_verbs)
	var/carpshark1 = pick(GLOB.carp_names + GLOB.megacarp_first_names)
	var/carpshark2 = pick(GLOB.megacarp_last_names)
	var/num = rand(10000, 99999)
	uid += "-[adj1]-[adj2]-[adv]-[ingverb]-[carpshark1]-[carpshark2]-[num]"
	uid = replacetext(uid, " ", "-")
	uid = replacetext(uid, "'", "")
	uid = replacetext(uid, "\"", "")
	return uid // its this long to inflate its file size big and round

/datum/controller/subsystem/rumormill/proc/GetRandomRumor(mob/user)
	if(!user)
		user = SSdans_cool_prefs.cutie_cats[FEMALE]
		if(!user)
			. = "Rumor has it, this rumor failed to generate a random rumor because the user was null and the fallback user was null too. Also youre cute."
			CRASH("Rumormill: GetRandomRumor() failed to generate a random rumor because the user was null and the fallback user was null too!")
	var/static/list/singlepart = list(
		"$PREFS_NAME likes to kiss $THEIR cat, but not on the lips.",
		"$PREFS_NAME has a secret stash of $THEIR favorite candy hidden in $THEIR room.",
		"One time, $PREFS_NAME chugged a whole bottle of hot sauce and only cried for two days straight.",
		"Despite popular belief, $PREFS_NAME actually isn't behind it all.",
		"$PREFS_NAME spends most of $THEIR income on candles.",
		"You're cute!",
		"$PREFS_NAME is in space!",
		"$PREFS_NAME is a $SPECIES!",
	)
	var/rumor = pick(singlepart)
	rumor = verbify(user, rumor)
	return rumor

/datum/controller/subsystem/rumormill/proc/update_rumor_person(someone, slot)
	var/mob/user = extract_mob(someone)
	if(!user)
		return
	if(!slot)
		slot = extract_current_character_slot(user)
	var/name2add = user.real_name
	if(!name2add)
		var/datum/prefs_holder/ph = user.client?.prefs
		if(ph)
			name2add = ph.read_preference(/datum/preference/name/real_name)
		if(!name2add)
			name2add = user.name
	var/datum/rumor_holder/rholder = GetRumorHolder(user.ckey)
	if(rholder.character_names[slot][name2add])
		return
	rholder.character_names[slot][name2add] = TRUE
	rholder.set_durty(TRUE)

// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║ ╔══════════════════════════════╗  ╔══════════════════════════════╗  ╔══════════════════════════════╗ ║
// ║ ║                              ║  ║                              ║  ║                              ║ ║
// ║ ║ RUMOR HOLDER                 ║  ║ RUMOR HOLDER                 ║  ║ RUMOR HOLDER                 ║ ║
// ║ ║                              ║  ║                              ║  ║                              ║ ║
// ║ ╚══════════════════════════════╝  ║                              ║  ╚══════════════════════════════╝ ║
// ║ ╔══════════════════════════════╗  ║                              ║  ╔══════════════════════════════╗ ║
// ║ ║                              ║  ║                              ║  ║                              ║ ║
// ║ ║ RUMOR HOLDER                 ║  ║ RUMOR HOLDER                 ║  ║ RUMOR HOLDER                 ║ ║
// ║ ║                              ║  ║                              ║  ║                              ║ ║
// ║ ╚══════════════════════════════╝  ╚══════════════════════════════╝  ╚══════════════════════════════╝ ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝
/datum/rumor_holder
	var/c_key = ""
	var/const/max_rumors_per_slot = 50
	var/list/character_names[max_rumors_per_slot]
	/// format: list(list("rumor_uid" = datum/rumor, ...), list(...), ...)
	var/list/rumor_slots[max_rumors_per_slot]
	var/list/slots_with_stuff = list()
	var/list/rumors_heard[max_rumors_per_slot] // rumors that have been heard by this holder, to avoid repeating them
	var/last_rumor_time = 0
	var/last_online = 0
	var/was_online_this_round = FALSE
	var/durty = FALSE
	var/list/rumor_cache = list() // cached random rumor for this holder, to avoid lagg, cus only i may be superlagg

/datum/rumor_holder/New(c_key)
	. = ..()
	src.c_key = c_key
	for(var/i in 1 to max_rumors_per_slot)
		rumor_slots[i] = list() // set em up!
		character_names[i] = list()
		rumors_heard[i] = list()

/datum/rumor_holder/Destroy()
	for(var/i in 1 to LAZYLEN(rumor_slots))
		rumor_slots[i] = list() // clear the rumors for this slot
	SSrumormill.clipboards["[c_key]"] = list() // clear the clipboards for this ckey
	SSrumormill.rumors["[c_key]"] = null // clear the rumor holder for this ckey
	. = ..()

/datum/rumor_holder/proc/post_load()
	set_durty(FALSE)
	prune_deleted_rumors()
	recalculate_slots_with_stuff()

/datum/rumor_holder/proc/check_heartbeat()
	if(was_online_this_round)
		return TRUE
	if(GLOB.directory[c_key]) // close enough!
		was_online_this_round = TRUE
		set_durty(TRUE)
		return TRUE
	return FALSE

/datum/rumor_holder/proc/prune_deleted_rumors()
	var/cutoff = world.realtime - (2 WEEKS)
	for(var/i in 1 to max_rumors_per_slot)
		var/list/rumors_in_slot = rumor_slots[i]
		for(var/rumor_uid in rumors_in_slot)
			var/datum/rumor/rumor = rumors_in_slot["[rumor_uid]"]
			if(rumor.deleted_time > 0 && rumor.deleted_time <= cutoff)
				rumors_in_slot -= rumor_uid
				qdel(rumor)

/datum/rumor_holder/proc/get_character_name(slot)
	if(!isnum(slot) || slot < 1 || slot > max_rumors_per_slot)
		slot = text2num(slot) || 1
	var/mob/living/carbon/human/user = extract_mob(c_key)
	if(ishuman(user) && user.prefs_character_slot == slot)
		return user.real_name
	var/list/charnamelist = character_names[slot]
	if(!LAZYLEN(charnamelist))
		return "Someone" // screw it
	return charnamelist[LAZYLEN(charnamelist)] // pick the latest one

/datum/rumor_holder/proc/get_random_rumor_string(hornymode = HORNYMODE_NONE)
	var/datum/rumor/random_rumor = get_random_rumor(hornymode)
	if(!random_rumor)
		return null
	return random_rumor.rumor_text

/// gets a random rumor from *every* slot that has rumors innit
/datum/rumor_holder/proc/get_random_rumor(hornymode = HORNYMODE_NONE)
	if(LAZYLEN(rumor_cache["[hornymode]"]))
		return pick(rumor_cache["[hornymode]"])
	if(!LAZYLEN(slots_with_stuff))
		return SSrumormill.get_random_nethack_rumor(FALSE) // shruggo
	var/list/available_rumors = list()
	for(var/i in slots_with_stuff)
		var/list/rumors_in_slot = rumor_slots[i]
		for(var/rumor_uid in rumors_in_slot)
			var/datum/rumor/rumor = rumors_in_slot["[rumor_uid]"]
			if(hornymode == HORNYMODE_NONE && rumor.is_nsfw)
				continue
			if(hornymode == HORNYMODE_ONLYHORNY && !rumor.is_nsfw)
				continue
			if(rumor.deleted_time > 0)
				continue
			available_rumors += rumor
	if(!LAZYLEN(available_rumors))
		return SSrumormill.get_random_nethack_rumor(FALSE) // shruggo
	rumor_cache["[hornymode]"] = available_rumors
	return pick(available_rumors)

/datum/rumor_holder/proc/decache_rumor(rumor_uid)
	if(!istext(rumor_uid))
		return
	for(var/hornymode in rumor_cache)
		var/list/rumors = rumor_cache["[hornymode]"]
		for(var/datum/rumor/rumor in rumors)
			if(rumor.rumor_uid == rumor_uid)
				rumor_cache["[hornymode]"] -= rumor

/// clicked the new rumor button, so add a new rumor to the system
/datum/rumor_holder/proc/add_new_rumor(mob/user, slot)
	if(!has_room_for_more_rumors(user, slot, TRUE))
		return FALSE
	var/rumor_uid = SSrumormill.GenerateRumorUid()
	var/rumor_text
	if(prob(50))
		var/datum/rumor/nh_rumor = SSrumormill.nethack_rumors.get_a_rumor(HORNYMODE_ONLYHORNY) // aww yeah, sexy nethack rumors
		rumor_text = nh_rumor.rumor_text
	if(!rumor_text)
		var/client/C = GLOB.directory[c_key]
		var/mob/M = C?.mob
		rumor_text = SSrumormill.GetRandomRumor(M)
	add_rumor(slot, rumor_text, rumor_uid, null, null, null, 0, 0, 0, 0, null)
	set_durty(TRUE)
	return TRUE

/// also the deserializer
/datum/rumor_holder/proc/add_rumor(
	slot,
	rumortxt,
	rumor_uid,
	is_nsfw,
	is_public,
	is_specificable,
	deleted_time,
	times_spread,
	created_time,
	modified_time,
	secret,
	)
	if(!rumortxt || !istext(rumortxt))
		return
	var/datum/rumor/really_cool_rumor = rumor_slots[slot]["[rumor_uid]"]
	if(!really_cool_rumor)
		really_cool_rumor = new /datum/rumor(
			src,
			rumor_uid,
			rumortxt,
			is_nsfw,
			is_public,
			is_specificable,
			deleted_time,
			times_spread,
			created_time,
			modified_time,
			secret,
			)
		really_cool_rumor.slot = slot || 1
		rumor_slots[slot]["[rumor_uid]"] = really_cool_rumor
	else
		really_cool_rumor.update_rumor(rumortxt, is_nsfw, is_public, is_specificable)
	set_durty(TRUE)
	return really_cool_rumor

/// copy!
/datum/rumor_holder/proc/add_rumor_from_rumor(datum/rumor/really_cool_rumor, slot)
	if(!really_cool_rumor)
		return
	if(!has_room_for_more_rumors(null, slot, TRUE))
		return FALSE
	var/new_rumor_uid = SSrumormill.GenerateRumorUid()
	var/datum/rumor/copy_rumor = new /datum/rumor(
		src,
		new_rumor_uid,
		really_cool_rumor.rumor_text,
		really_cool_rumor.is_nsfw,
		really_cool_rumor.is_public,
		really_cool_rumor.is_specificable,
		really_cool_rumor.deleted_time,
		really_cool_rumor.times_spread,
		really_cool_rumor.created_time,
		really_cool_rumor.last_modified_time,
		really_cool_rumor.is_secret,
		)
	copy_rumor.slot               = slot || 1
	copy_rumor.last_spread_time   = really_cool_rumor.last_spread_time   || time2text(world.realtime, null, -8)
	copy_rumor.last_modified_time = really_cool_rumor.last_modified_time || time2text(world.realtime, null, -8)
	copy_rumor.created_time       = really_cool_rumor.created_time       || time2text(world.realtime, null, -8)
	copy_rumor.times_spread       = really_cool_rumor.times_spread       || 0
	copy_rumor.deleted_time       = really_cool_rumor.deleted_time       || 0
	rumor_slots[slot]["[copy_rumor.rumor_uid]"] = copy_rumor
	set_durty(TRUE)
	return TRUE

/datum/rumor_holder/proc/remove_rumor(rumor_uid, slot, kill = FALSE)
	var/datum/rumor/really_cool_rumor = rumor_slots[slot]["[rumor_uid]"]
	if(!really_cool_rumor)
		return
	if(kill) // someone did a bad, and the admin said no
		rumor_slots[slot]["[rumor_uid]"] = null
		rumor_slots[slot] -= rumor_uid
		qdel(really_cool_rumor)
	else
		really_cool_rumor.deleted_time = world.realtime
	set_durty(TRUE)
	return TRUE

/datum/rumor_holder/proc/get_rumor(rumor_uid, slot)
	return rumor_slots[slot]["[rumor_uid]"]

/datum/rumor_holder/proc/get_a_rumor(horny_level, slot, deleted_too, obey_used_rumors_for_this_ckey = FALSE)
	var/available_rumors = list()
	var/tried_again = FALSE
	try_again:
	for(var/rumor_uid in rumor_slots[slot])
		var/datum/rumor/rumor= rumor_slots[slot]["[rumor_uid]"]
		if(horny_level == HORNYMODE_NONE && rumor.is_nsfw)
			continue
		if(horny_level == HORNYMODE_ONLYHORNY && !rumor.is_nsfw)
			continue
		if(!deleted_too && rumor.deleted_time > 0)
			continue
		if(obey_used_rumors_for_this_ckey)
			if(SSrumormill.rm_rumors_used["[c_key]"])
				if(SSrumormill.rm_rumors_used["[c_key]"]["[rumor.rumor_uid]"] >= world.time)
					continue
		available_rumors += rumor
	if(!LAZYLEN(available_rumors))
		if(obey_used_rumors_for_this_ckey && !tried_again)
			obey_used_rumors_for_this_ckey = FALSE
			SSrumormill.rm_rumors_used["[c_key]"] = list()
			tried_again = TRUE
			goto try_again
		return SSrumormill.get_random_nethack_rumor(FALSE) // shruggo
	return pick(available_rumors)

/datum/rumor_holder/proc/has_room_for_more_rumors(mob/user, slot, include_deleted = FALSE)
	var/list/all_rumors = get_all_rumors(slot, include_deleted)
	if(LAZYLEN(all_rumors) < max_rumors_per_slot)
		return TRUE
	return FALSE

/datum/rumor_holder/proc/get_all_rumors(slot, and_i_mean_all_of_them)
	var/list/all_rumors = list()
	for(var/rumor_uid in rumor_slots[slot])
		var/datum/rumor/rumor= rumor_slots[slot]["[rumor_uid]"]
		if(rumor.deleted_time && !and_i_mean_all_of_them)
			continue
		all_rumors += rumor
	return all_rumors

/datum/rumor_holder/proc/move_rumor(rumor_uid, slot, down = FALSE)
	var/list/working_list = get_keys(slot)
	if(!down)
		working_list = reverseList(working_list)
	var/my_index = working_list.Find(rumor_uid)
	var/target_index = my_index
	for(var/i in (my_index + 1) to LAZYLEN(working_list))
		if(i < 1 || i > LAZYLEN(working_list))
			return FALSE
		var/rumkey = LAZYACCESS(working_list, i)
		var/datum/rumor/rumor = LAZYACCESS(rumor_slots[slot], rumkey)
		if(!rumor || rumor.deleted_time > 0)
			continue
		target_index = i
		break
	if(target_index == my_index)
		return FALSE
	var/list/rumors_for_slot = rumor_slots[slot]
	// find the true position of both rumors, cus there may be deleteds
	my_index = rumors_for_slot.Find(rumor_uid)
	target_index = rumors_for_slot.Find(working_list[target_index])
	rumors_for_slot.Swap(my_index, target_index)
	rumor_slots[slot] = rumors_for_slot // just in case
	set_durty(TRUE)
	return TRUE

/datum/rumor_holder/proc/get_keys(slot, get_deleteds = FALSE)
	var/list/keys = list()
	for(var/rumorkey in rumor_slots[slot])
		var/datum/rumor/rumor = rumor_slots[slot]["[rumorkey]"]
		if(!get_deleteds)
			if(rumor.deleted_time > 0)
				continue
		keys += rumorkey
	return keys

/* ======================================= */
/// SERIALIZATION STUFF

/// outputs the whole thing, for saving to disk. if saving is FALSE, it will not include deleted rumors
/datum/rumor_holder/proc/serialize_rumor_holder(saving, admin = FALSE)
	if(saving) // to tgui: <RumorHolderData>
		set_durty(FALSE)
	var/list/serialized = list()
	serialized["ckey"]           = src.c_key
	if(admin)
		serialized["is_online"]    = GLOB.directory[src.c_key]
		serialized["last_online"]  = src.last_online
		serialized["was_online"]   = src.check_heartbeat()
	serialized["slot_holder"]    = serialize_all_slots(saving, admin)
	return serialized

/datum/rumor_holder/proc/serialize_all_slots(saving, admin = FALSE)
	var/list/serialized_slots = list() // to tgui: <RumorSlotData[]>
	for(var/i in 1 to LAZYLEN(rumor_slots))
		if(!LAZYLEN(rumor_slots[i]))
			continue
		serialized_slots += list(serialize_slot(i, saving, admin))
	return serialized_slots

/datum/rumor_holder/proc/serialize_slot(slot, saving, admin = FALSE)
	var/list/data = list() // to tgui: <RumorSlotData>
	data["slot"] = slot // this better be a fkn number
	data["character_name"] = character_names[slot]
	data["rumors_heard"] = rumors_heard[slot]
	data["rumors"] = serialize_slot_rumor_list(slot, saving, admin)
	return data

/datum/rumor_holder/proc/serialize_slot_rumor_list(slot, saving, admin = FALSE)
	var/list/all_rumors = list() // to tgui: <RumorData[]>
	var/index = 1
	var/list/rumor_keys = get_keys(slot, (saving || admin))
	for(var/rumor_uid in rumor_keys)
		var/datum/rumor/rumor = rumor_slots[slot]["[rumor_uid]"]
		var/list/rumordat = rumor.serialize_rumor()
		// positioning!
		if(LAZYLEN(rumor_keys) <= 1)
			rumordat["position"] = "hidden"
		else if(index == 1)
			rumordat["position"] = "top"
		else if(index == LAZYLEN(rumor_keys))
			rumordat["position"] = "bottom"
		else
			rumordat["position"] = "mid"
		all_rumors += list(rumordat)
		index += 1
	return all_rumors

/datum/rumor_holder/proc/set_durty(new_durt)
	durty = new_durt
	if(new_durt)
		recalculate_slots_with_stuff()
		trim_rumors_heard()
		rumor_cache = list() // clear the cache, cus its durty now

/datum/rumor_holder/proc/heard_rumor(datum/rumor/cool_rumor, datum/rumor_recipient/me_probably)
	if(!cool_rumor || !me_probably)
		return
	var/slot = extract_current_character_slot(me_probably)
	if(!slot)
		slot = 1
	rumors_heard[slot]["[cool_rumor.rumor_uid]"] = world.time + SSrumormill.rm_heard_rumor_stale_time // dont repeat for a while
	set_durty(TRUE)

/datum/rumor_holder/proc/trim_rumors_heard()
	for(var/i in 1 to LAZYLEN(rumors_heard))
		var/list/rumors_in_slot = rumors_heard[i]
		for(var/rumor_uid in rumors_in_slot)
			if(rumors_in_slot[rumor_uid] <= world.time)
				rumors_in_slot -= rumor_uid
				set_durty(TRUE)

/datum/rumor_holder/proc/recalculate_slots_with_stuff()
	slots_with_stuff = list()
	for(var/i in 1 to LAZYLEN(rumor_slots))
		if(LAZYLEN(rumor_slots[i]))
			slots_with_stuff += i

/// this is a terrible idea, oh well!
/datum/rumor_holder/nethack

/datum/rumor_holder/nethack/New()
	. = ..()
	rumor_slots = list()
	rumor_slots.len = 1
	rumor_slots[1] = list()
	load_six_hundred_frickin_nethack_rumors()

/datum/rumor_holder/nethack/proc/load_six_hundred_frickin_nethack_rumors()
	var/rumortext = rustg_file_read("modular_coyote/code/preference_stuff/nethack_rumors.json")
	var/list/gigahuge_list = json_decode(rumortext)
	var/index = 1
	for(var/probably_a_nethack_rumor in gigahuge_list)
		var/rumor_uid = "nethack_rumor_[index]"
		add_rumor(1, probably_a_nethack_rumor, rumor_uid, FALSE, TRUE, FALSE, 0, 0)
		index += 1

/datum/rumor_holder/nethack/get_a_rumor(horny_level)
	var/rumorindex = pick(rumor_slots[1])
	var/datum/rumor/rumhack = rumor_slots[1]["[rumorindex]"]
	if(!rumhack)
		CRASH("Rumormill: nethack rumor holder has no rumor at index [rumorindex]! This is bad!")
	return rumhack

/datum/rumor_holder/nethack/add_new_rumor(mob/user)
	CRASH("Rumormill: nethack rumor holder cannot add new rumors! This is bad!")

/datum/rumor_holder/nethack/get_random_rumor(hornymode = HORNYMODE_NONE)
	return get_a_rumor(hornymode)

/datum/rumor_holder/nethack/recalculate_slots_with_stuff()
	slots_with_stuff = list(1)

// ╔══════════════════════════════════╗
// ║ ╔══════════════════════════════╗ ║
// ║ ║                              ║ ║
// ║ ║ RUMOR DATA !                 ║ ║
// ║ ║                              ║ ║
// ║ ╚══════════════════════════════╝ ║
// ╚══════════════════════════════════╝
/datum/rumor
	var/slot = 1
	var/created_time
	var/last_modified_time
	var/last_spread_time = 0
	var/rumor_uid = ""
	var/rumor_text = ""
	var/is_nsfw = FALSE
	var/is_public = TRUE
	var/is_specificable = FALSE
	var/is_secret = FALSE
	var/deleted_time = 0 // 0 = not deleted, otherwise the time it was deleted
	var/times_spread = 0
	var/spread_to = list() // ckey = timedid, for this round
	var/datum/rumor_holder/my_holder = null

/datum/rumor/New(
	datum/rumor_holder/rholder,
	rumor_uid,
	rumor_text,
	is_nsfw,
	is_public,
	is_specificable,
	deleted_time,
	times_spread,
	created_time,
	modified_time,
	secret,
	)
	. = ..()
	src.associate_holder(rholder)
	if(!isnull(rumor_uid))
		src.rumor_uid           = rumor_uid
	if(!isnull(rumor_text))
		src.rumor_text          = rumor_text
	if(!isnull(is_nsfw))
		src.is_nsfw             = is_nsfw
	if(!isnull(is_public))
		src.is_public           = is_public
	if(!isnull(is_specificable))
		src.is_specificable     = is_specificable
	if(!isnull(deleted_time))
		src.deleted_time        = deleted_time
	if(!isnull(times_spread))
		src.times_spread        = times_spread
	if(!isnull(created_time))
		src.created_time        = created_time  || time2text(world.realtime, null, -8)
	if(!isnull(last_modified_time))
		src.last_modified_time  = modified_time || time2text(world.realtime, null, -8)
	if(!isnull(is_secret))
		src.is_secret           = secret

/datum/rumor/Destroy(force)
	SSrumormill.send_to_graveyard(src)
	my_holder?.decache_rumor(rumor_uid)
	my_holder = null
	SSrumormill.clipboards["[my_holder.c_key]"] -= src
	. = ..()

/datum/rumor/proc/associate_holder(datum/rumor_holder/rholder)
	if(!rholder)
		return
	src.my_holder = rholder

/datum/rumor/proc/set_created_time(new_time)
	src.created_time = new_time

/datum/rumor/proc/update_rumor(rumor_text, is_nsfw, is_public, is_specificable)
	if(rumor_text && istext(rumor_text))
		src.rumor_text = rumor_text
	src.is_nsfw = is_nsfw
	src.is_public = is_public
	src.is_specificable = is_specificable
	set_holder_durty(TRUE)

/datum/rumor/proc/set_holder_durty(new_durt)
	if(new_durt)
		src.last_modified_time = time2text(world.realtime, null, -8)
	if(my_holder)
		my_holder.set_durty(new_durt)

/datum/rumor/proc/toggle_specifiable()
	src.is_specificable = !src.is_specificable
	set_holder_durty(TRUE)
	return src.is_specificable

/datum/rumor/proc/toggle_public()
	src.is_public = !src.is_public
	set_holder_durty(TRUE)
	return src.is_public

/datum/rumor/proc/toggle_nsfw()
	src.is_nsfw = !src.is_nsfw
	set_holder_durty(TRUE)
	return src.is_nsfw

/datum/rumor/proc/toggle_secret()
	src.is_secret = !src.is_secret
	set_holder_durty(TRUE)
	return src.is_secret

/datum/rumor/proc/edit_text(mob/user)
	var/new_text = tgui_input_text(
		user,
		"Edit the details of this rumor. Maximum length is 512 characters. \
		Special characters may be clipped, multiline should be okay.",
		"Edit rumor: [rumor_text]",
		rumor_text,
		512,
		TRUE,
		TRUE,
		null,
		null,
		TRUE,
	)
	if(new_text == TGUI_TEXT_MODAL_CANCEL_TOKEN)
		to_chat(user, span_notice("Okay never mind!!"))
		return TRUE
	if(!new_text)
		var/r_u_sure = tgui_alert(
			user,
			"Are you sure you want to clear the flavor text for this rumor?",
			"Clear Rumor Text?",
			list("Yes, clear it", "No, cancel!"),
		)
		if(r_u_sure != "Yes, clear it")
			to_chat(user, span_notice("Okay never mind!!"))
			return TRUE
	if(new_text == rumor_text)
		to_chat(user, span_notice("Okay never mind!!"))
		return TRUE
	new_text = "[new_text]" // just in case
	new_text = STRIP_HTML_SIMPLE(new_text, 512) // there sanitized probably
	rumor_text = new_text
	set_holder_durty(TRUE)
	to_chat(user, span_notice("Okay! Updated rumor text to: [new_text]"))
	return TRUE

/datum/rumor/proc/serialize_rumor()
	return list(  // to tgui: <RumorData>
		"uid" = src.rumor_uid,
		"text" = src.rumor_text,
		"horny" = src.is_nsfw,
		"public" = src.is_public,
		"specificable" = src.is_specificable,
		"secret" = src.is_secret,
		"deleted_time" = src.deleted_time,
		"times_spread" = src.times_spread,
		"created_time" = src.created_time,
		"modified_time" = src.last_modified_time,
	)

/datum/rumor_admin_thingy

/datum/rumor_admin_thingy/proc/open_admin_tool(mob/user)
	if(!user || !is_admin(user))
		return
	ui_interact(user, null)

/datum/rumor_admin_thingy/ui_state(mob/user)
	return GLOB.admin_state

/datum/rumor_admin_thingy/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RumorMuncher2000")
		ui.open()

/datum/rumor_admin_thingy/ui_static_data(mob/user)
	return SSrumormill.get_all_rumors_for_admin_tgui()

/datum/rumor_admin_thingy/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!is_admin(usr))
		return
	if(action == "operate_rumormill")
		var/ckey = params["rumor_ckey"]
		var/slut = params["rumor_slot"]
		var/rumor_uid = params["rumor_uid"]
		// var/rumor_am_admin = params["rumor_am_admin"]
		// var/rumor_action = params["rumor_action"]
		var/datum/rumor_holder/rholder = SSrumormill.GetRumorHolder(ckey)
		if(!rholder)
			return
		var/datum/rumor/really_cool_rumor = rholder.get_rumor(rumor_uid, slut)
		if(!really_cool_rumor)
			return
		var/r_text = really_cool_rumor.rumor_text
		var/r_horny = really_cool_rumor.is_nsfw
		var/r_public = really_cool_rumor.is_public
		var/r_specifiable = really_cool_rumor.is_specificable
		var/r_created = really_cool_rumor.created_time
		var/r_modified = really_cool_rumor.last_modified_time
		var/r_times_spread = really_cool_rumor.times_spread
		SSrumormill.delete_rumor(usr, rumor_uid, TRUE)
		to_chat(usr, span_notice("Deleted rumor [rumor_uid] from [ckey]! The text was: [r_text]"))
		to_chat(usr, span_notice("Horny: [r_horny ? "yes" : "no"], Public: [r_public ? "yes" : "no"], Specifiable: [r_specifiable ? "yes" : "no"]"))
		to_chat(usr, span_notice("Created: [r_created], Modified: [r_modified], Times Spread: [r_times_spread]"))
		to_chat(usr, span_notice("Be sure to give em one for me!"))
	return TRUE

ADMIN_VERB(moderate_rumors, R_ADMIN, "Moderate Rumors", "Look through all the rumors, see if any need killing.", ADMIN_CATEGORY_MAIN)
	SSrumormill.open_admin_tool(extract_mob(user)) // user is a client i guess?
	to_chat(user, span_notice("Opened the RumorMuncher2000 for you!"))

ADMIN_VERB(save_rumors, R_ADMIN, "Save Rumors", "Save the rumors!", ADMIN_CATEGORY_MAIN)
	var/allofem = alert(user,
		"Save every loaded rumor to disk, or just the changed ones? Warning: the first option could take a while and lag everyone, and it would be your fault!",
		"Save what Rumors?",
		"ALL of them",
		"Just the changed ones",
	)
	if(allofem == "ALL of them")
		SSrumormill.SaveRumorsToDisk(TRUE)
	else
		SSrumormill.SaveRumorsToDisk(FALSE)
	to_chat(user, span_notice("Saved em!"))

ADMIN_VERB(spread_rumors, R_ADMIN, "Spread Rumors", "Spread the rumors!", ADMIN_CATEGORY_MAIN)
	SSrumormill.spread_those_rumors(TRUE)
	to_chat(user, span_notice("Spread em!"))

ADMIN_VERB(load_and_obliterate_rumors, R_ADMIN, "Load and Obliterate Rumors", "Load the rumors from disk and obliterate the current ones!", ADMIN_CATEGORY_MAIN)
	var/h = alert(user,
		"Are you sure you want to load rumors from disk and obliterate the current ones? This could cause data loss if you're not careful! Consult Dan first!",
		"Load and Obliterate Rumors?",
		"Yes, load and obliterate",
		"No, cancel!",
	)
	if(h != "Yes, load and obliterate")
		to_chat(user, span_notice("Okay never mind!!"))
		return TRUE
	SSrumormill.LoadRumorsFromDisk(TRUE)


