// ╔═══════════════════════╗
// ║ ACCOUNT               ║
// ║ CKEY-WIDE DATA STUFF  ║
// ╚═══════════════════════╝
/datum/rpi_account
	var/acc_owner_ckey = ""
	var/time_created = 0
	var/time_modified = 0
	var/last_payward = 0
	var/list/characters_tracked = list()
	var/list/holders = list()
	var/durty = FALSE
	var/virgin = TRUE

/datum/rpi_account/New(acc_owner_ckey)
	src.acc_owner_ckey = acc_owner_ckey
	if(!load(TRUE))
		new_account()

/datum/rpi_account/proc/tick(deltatime)
	// maybe update holders or other stuff here
	for(var/slot in holders)
		var/datum/rpi_holder/hold = holders[slot]
		if(!hold)
			continue
		hold.tick(deltatime)
		durty |= hold.durty
		hold.update_characters()
		characters_tracked |= hold.characters_tracked

/datum/rpi_account/proc/new_account()
	time_created = time2text(world.realtime)
	time_modified = time2text(world.realtime)
	durty = TRUE
	var/mob/newowner = extract_mob(acc_owner_ckey)
	get_holder(newowner)
	return TRUE

/datum/rpi_account/proc/say_action(mob/living/doer, list/message_data)
	var/datum/rpi_holder/cooldat = get_holder(doer)
	cooldat.judge_chat(message_data)
	durty |= cooldat.durty
	return TRUE

/datum/rpi_account/proc/get_holder(mob/living/doer, slot_for)
	var/slot
	if(!isnull(slot_for))
		slot = slot_for
	else
		slot = extract_current_character_slot(doer)
	slot = "slot_[slot]"
	var/datum/rpi_holder/cooldat = holders[slot]
	if(!cooldat)
		cooldat = new /datum/rpi_holder(acc_owner_ckey, slot)
		holders[slot] = cooldat
	return cooldat

/datum/rpi_account/proc/serialize()
	var/list/dat = list()
	dat["acc_owner_ckey"] = acc_owner_ckey
	dat["time_created"] = time_created
	dat["time_modified"] = time_modified
	// dat["alltime_score"] = alltime_score
	// dat["alltime_highest_score"] = alltime_highest_score
	// dat["alltime_highest_score_time"] = alltime_highest_score_time
	dat["last_payward"] = last_payward
	dat["characters_tracked"] = characters_tracked
	return dat

/datum/rpi_account/proc/deserialize(list/dat)
	acc_owner_ckey = dat["acc_owner_ckey"]
	time_created = dat["time_created"]
	time_modified = dat["time_modified"]
	// alltime_score = dat["alltime_score"]
	// alltime_highest_score = dat["alltime_highest_score"]
	// alltime_highest_score_time = dat["alltime_highest_score_time"]
	last_payward = dat["last_payward"]
	characters_tracked = dat["characters_tracked"]
	return TRUE

/datum/rpi_account/proc/save(force)
	if(!durty && !force)
		return
	var/list/dat = serialize()
	var/jsonifex = json_encode(dat, JSON_PRETTY_PRINT)
	var/accpath = SSrpi.GetPath("account_save", acc_owner_ckey, 1)
	rustg_file_write(jsonifex, accpath)
	for(var/slot in holders)
		var/datum/rpi_holder/hold = holders[slot]
		if(hold)
			hold.save()
	durty = FALSE
	return TRUE

/datum/rpi_account/proc/load(force)
	if(!acc_owner_ckey)
		return
	if(!virgin && !force)
		return
	var/accpath = SSrpi.GetPath("account_save", acc_owner_ckey)
	if(!rustg_file_exists(accpath)) // new player!
		new_account()
		virgin = FALSE
		durty = TRUE
		return
	var/jsonifex = rustg_file_read(accpath)
	if(!jsonifex)
		return
	var/list/jsondefex = json_decode(jsonifex)
	if(LAZYLEN(jsondefex))
		deserialize(jsondefex)
	// load holders too!
	var/list/slotnames = flist(SSrpi.GetPath("holders", acc_owner_ckey))
	var/mob/living/someone = extract_mob(acc_owner_ckey)
	for(var/slot_num_name in slotnames)
		var/slot_pro = SSrpi.Text2Slot(slot_num_name)
		get_holder(someone, slot_pro)
	get_holder(someone)
	virgin = FALSE
	return TRUE
