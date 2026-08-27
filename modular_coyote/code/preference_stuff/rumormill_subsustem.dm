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
#define HORNYMODE_NONE 0
#define HORNYMODE_EITHEROR 1
#define HORNYMODE_ONLYHORNY 2
#define RUMOR_LOG   "data/rumormill/rumor_log.txt"
#define RUMOR_STATS "data/rumormill/rumor_stats.json"
#define RUMOR_PATH  "data/rumormill/rumormine/"
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
	var/debug = TRUE
	/// the maximum number of rumors per character slot
	var/max_rumors_per_slot = 50
	/// my clopboard, currently full of twilight sparkle and other things
	var/list/clipboards = list() // thats right, we've got a damn clipboards

/datum/controller/subsystem/rumormill/Initialize(start_timeofday)
	rustg_time_reset("rumors")
	LoadRumorsFromDisk()
	LoadNethackHolder()
	rat = new /datum/rumor_admin_thingy() // squeak
	var/keys_loaded = 0
	var/rumors_loaded = 0
	var/nethack_rumors_loaded = LAZYLEN(nethack_rumors.rumor_slots[1])
	for(var/ckey in rumors)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		keys_loaded += 1
		rumors_loaded += LAZYLEN(rholder.get_all_rumors(FALSE))

	to_chat(world, span_captaincast("Loaded [keys_loaded] rumor subjects!"))
	to_chat(world, span_captaincast("Loaded [rumors_loaded] rumors!"))
	to_chat(world, span_captaincast("Loaded [nethack_rumors_loaded] (mostly) nethack rumors!"))
	var/time = rustg_time_milliseconds("rumors")
	var/seconds = round(time / 1000, 0.01)
	to_chat(world, span_captaincast("And it was all loaded in [seconds] seconds!"))

/datum/controller/subsystem/rumormill/fire(resumed)
	// this is where the rumor spreading will happen, but for now, just save the rumors to disk
	var/yay = SaveRumorsToDisk()
	if(!yay)
		message_admins("RumorMill: Failed to save rumors to disk!")

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
	if(!user || !istext(rumor_uid) || !istext(ckey))
		return
	var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
	var/char_slot = slot || extract_current_character_slot(user)
	var/list/to_copy = list() + rumor_uid // works for lists AND singles!
	var/list/true_copy = list()
	for(var/rumor_ in to_copy)
		var/datum/rumor/cool_rumor = rholder.get_rumor(rumor_, char_slot)
		if(cool_rumor)
			true_copy += list(cool_rumor)
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
	for(var/datum/rumor/cool_rumor in to_paste)
		rholder.add_rumor(cool_rumor, char_slot)
	clipboards[ckey] = list() // clear the clipboards after pasting, so you dont paste it again
	if(user)
		if(prob(5))
			to_chat(user, span_notice("Pasted rumors from your clopboard! Clopboard is now cleared!"))
		else
			to_chat(user, span_notice("Pasted rumors from your clipboards! Clipboard is now cleared!"))

/// clicked the new rumor button, so add a new rumor to the system
/// will be random or something
/datum/controller/subsystem/rumormill/proc/add_new_rumor(mob/user, slot, loud)
	if(!user)
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	if(!slot)
		slot = extract_current_character_slot(user)
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
		var/datum/rumor/so_called_dead_rumor = rholder.get_rumor(rumor_uid, slot)
		var/rumor_text = so_called_dead_rumor.rumor_text
		to_chat(user, span_captaincast("Deleted that rumor! The text was: [rumor_text]"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/edit_rumor_text(mob/user, rumor_uid, slot)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!cool_rumor)
		return
	cool_rumor.edit_text(user)
	return TRUE

/datum/controller/subsystem/rumormill/proc/toggle_rumor_nsfw(mob/user, rumor_uid, slot, loud)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!cool_rumor)
		return
	var/now_state = cool_rumor.toggle_nsfw(user)
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
	var/datum/rumor/cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!cool_rumor)
		return
	var/new_public = cool_rumor.toggle_public(user)
	if(loud)
		to_chat(user, span_notice("Okay! That rumor is now [new_public ? "public" : "private"]!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/toggle_rumor_specifiable(mob/user, rumor_uid, slot, loud)
	if(!user || !istext(rumor_uid))
		return
	var/user_ckey = user.ckey
	var/datum/rumor_holder/rholder = GetRumorHolder(user_ckey)
	var/datum/rumor/cool_rumor = rholder.get_rumor(rumor_uid, slot)
	if(!cool_rumor)
		return
	var/new_specifiable = cool_rumor.toggle_specifiable(user)
	if(loud)
		var/will_now
		if(new_specifiable)
			will_now = "will now include additional identifiable information about your character"
		else
			will_now = "will no longer include additional identifiable information about your character"
		to_chat(user, span_notice("Okay! That rumor [will_now]!"))
	return TRUE

/datum/controller/subsystem/rumormill/proc/get_rumors_for_tgui(mob/user, slot)
	var/list/data = list()
	var/datum/rumor_holder/my_holder = SSrumormill.GetRumorHolder(user.client.ckey)
	var/charslot = slot || extract_current_character_slot(user)
	data["player_rumor_slot"] = my_holder.serialize_slot(charslot)
	return data

// used for the admin tool. also gets deleted rumors, just to spot no no people
/datum/controller/subsystem/rumormill/proc/get_all_rumors_for_admin_tgui()
	var/list/data = list()
	data["rumor_block"] = list()
	data["rumor_keys"] = list()
	var/list/yiffkeys = list()
	for(var/c__key in rumors)
		yiffkeys += c__key
	yiffkeys = sort_list(yiffkeys) // sorted!
	for(var/ckey in yiffkeys)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		data["rumor_block"]["[ckey]"] = list()
		data["rumor_block"]["[ckey]"]["their_rumors"] = rholder.serialize_slot_rumor_list(TRUE)
		var/client/C = LAZYACCESS(GLOB.directory, ckey)
		var/mob/M = C?.mob
		data["rumor_block"]["[ckey]"]["is_online"] = C ? TRUE : FALSE
		data["rumor_block"]["[ckey]"]["player_name"] = M?.name
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
 *       "character_name"  = "Dank Elly",
 *       "rumors"          = list(
 *         list(
 *           "uid"           = "unique_id",
 *           "text"          = "the rumor text",
 *           "horny"         = "yes" or "no",
 *           "public"        = "yes" or "no",
 *           "specificable"  = "yes" or "no",
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
			var/slotnum = slot["slot"] // 1, 2, etc
			if(!isnum(slotnum))
				slotnum = text2num(slotnum) || 1
			var/character_name = slot["character_name"]
			rholder.character_names[slotnum] = character_name
			var/list/rumors_in_slot = slot["rumors"]

			// the list of rumors in this slot
			for(var/list/rumordat in rumors_in_slot)
				var/rumor_uid = rumordat["uid"]
				var/rumor_text = rumordat["text"]
				var/rumor_horny = rumordat["horny"]
				var/rumor_public = rumordat["public"]
				var/rumor_deleted_time = rumordat["deleted_time"]
				var/rumor_specificable = rumordat["specificable"]
				var/rumor_times_spread = rumordat["times_spread"]
				var/rumor_created_time = rumordat["created_time"]
				var/rumor_modified_time = rumordat["modified_time"]
				rholder.add_rumor(
					slotnum,
					rumor_text,
					rumor_uid,
					rumor_horny == "yes",
					rumor_public == "yes",
					rumor_specificable == "yes",
					rumor_deleted_time,
					rumor_times_spread,
					rumor_created_time,
					rumor_modified_time,
				)
		rumors["[ckey]"] = rholder
		rholder.set_durty(FALSE) // we JUST loaded it

/datum/controller/subsystem/rumormill/proc/SaveRumorsToDisk()
	var/coolyay = TRUE
	for(var/ckey in rumors)
		var/datum/rumor_holder/rholder = GetRumorHolder(ckey)
		if(!rholder.durty)
			continue
		var/rumor_core = rholder.serialize_rumor_holder(TRUE)
		var/filename = RUMOR_FILE("[ckey]_rumors.json")
		var/datta = json_encode(rumor_core)
		rustg_file_write(datta, filename)
		var/client/C = LAZYACCESS(GLOB.directory, ckey)
		if(C)
			to_chat(C, span_notice("RumorMill: Saved your rumors to disk!"))
		var/yay = TRUE
		output_debug("RumorMill: Saved rumors for [ckey] to disk at [filename]!")
		output_debug("RumorMill: Saved rumors for [ckey] to disk at [filename]!")
		var/datta2 = rustg_file_read(filename)
		if(!datta2)
			yay = FALSE
			output_debug("RumorMill: Failed to read back the file we just saved for [ckey] at [filename]!")
		else
			if(datta2 != datta)
				yay = FALSE
				output_debug("RumorMill: The file we just saved for [ckey] at [filename] does not match the data we wrote to it!")
			var/list/rson = json_decode(datta2)
			if(!rson || !islist(rson) || !LAZYLEN(rson))
				yay = FALSE
				output_debug("RumorMill: Failed to decode the file we just saved for [ckey] at [filename]!")
			var/list/rson2 = json_decode(datta)
			if(!rson2 || !islist(rson2) || !LAZYLEN(rson2))
				yay = FALSE
				output_debug("RumorMill: Failed to decode the data we wrote to the file for [ckey] at [filename]!")
			if(yay)
				output_debug("RumorMill: The file we just saved for [ckey] at [filename] matches the data we wrote to it, hooray!")
		if(!yay)
			coolyay = FALSE
			output_debug("RumorMill: Failed to save rumors for [ckey] to disk at [filename]!")
			to_chat(extract_client(ckey), span_notice("RumorMill: Failed to save your rumors to disk! Please report this to an admin!"))
		else
			rholder.set_durty(FALSE) // we just saved it, so its not durty anymore
	return coolyay

/datum/controller/subsystem/rumormill/proc/output_debug(text)
	if(!debug)
		return
	var/now = time2text(world.realtime, -8) // PST timezone
	if(!fexists(RUMOR_LOG))
		rustg_file_write("", RUMOR_LOG)
	rustg_file_append(RUMOR_LOG, "[now]: [text]\n")
	message_admins("RumorMill Debug: [text]")

/datum/controller/subsystem/rumormill/proc/GenerateRumorUid()
	// a 1 in 40 scrotillion chance of collision, winner gets a kiss
	var/uid = "[rand(100000, 999999)]"
	for(var/i in 1 to 10)
		if(prob(10))
			uid += "-spanky"
		uid += "-[rand(100000, 999999)]"
	return "uid_[uid]"

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

/datum/controller/subsystem/rumormill/proc/update_rumor_person(mob/user, slot)
	if(!user)
		return
	if(!isliving(user))
		return
	var/datum/rumor_holder/rholder = GetRumorHolder(user.ckey)
	rholder.character_names[slot] = user.real_name
	rholder.set_durty(TRUE)

// ╔══════════════════════════════════╗
// ║ ╔══════════════════════════════╗ ║
// ║ ║                              ║ ║
// ║ ║ RUMOR HOLDER                 ║ ║
// ║ ║                              ║ ║
// ║ ╚══════════════════════════════╝ ║
// ╚══════════════════════════════════╝
/datum/rumor_holder
	var/c_key = ""
	var/const/max_rumors_per_slot = 50
	var/list/character_names[max_rumors_per_slot]
	/// format: list(list("rumor_uid" = datum/rumor, ...), list(...), ...)
	var/list/rumor_slots[max_rumors_per_slot]
	var/last_rumor_time = 0
	var/last_online = 0
	var/was_online_this_round = FALSE
	var/durty = FALSE

/datum/rumor_holder/New(c_key)
	. = ..()
	src.c_key = c_key
	for(var/i in 1 to max_rumors_per_slot)
		rumor_slots[i] = list() // set em up!
		character_names[i] = ""

/datum/rumor_holder/Destroy()
	for(var/i in 1 to LAZYLEN(rumor_slots))
		rumor_slots[i] = list() // clear the rumors for this slot
	SSrumormill.clipboards["[c_key]"] = list() // clear the clipboards for this ckey
	SSrumormill.rumors["[c_key]"] = null // clear the rumor holder for this ckey
	. = ..()

/datum/rumor_holder/proc/check_heartbeat()
	if(was_online_this_round)
		return TRUE
	if(GLOB.directory[c_key]) // close enough!
		was_online_this_round = TRUE
		set_durty(TRUE)
		return TRUE
	return FALSE

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
	add_rumor(slot, rumor_text, rumor_uid, FALSE, FALSE, FALSE, 0, 0)
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
	)
	if(!rumortxt || !istext(rumortxt))
		return
	var/datum/rumor/cool_rumor = rumor_slots[slot]["[rumor_uid]"]
	if(!cool_rumor)
		cool_rumor = new /datum/rumor(
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
			)
		cool_rumor.slot = slot || 1
		rumor_slots[slot]["[rumor_uid]"] = cool_rumor
	else
		cool_rumor.update_rumor(rumortxt, is_nsfw, is_public, is_specificable)
	set_durty(TRUE)
	return cool_rumor

/// copy!
/datum/rumor_holder/proc/add_rumor_from_rumor(datum/rumor/cool_rumor, slot)
	if(!cool_rumor)
		return
	var/datum/rumor/copy_rumor = new /datum/rumor(
		src,
		cool_rumor.rumor_uid,
		cool_rumor.rumor_text,
		cool_rumor.is_nsfw,
		cool_rumor.is_public,
		cool_rumor.is_specificable,
		cool_rumor.deleted_time,
		cool_rumor.times_spread,
		cool_rumor.created_time,
		cool_rumor.last_modified_time,
		)
	copy_rumor.slot = slot || 1
	copy_rumor.last_spread_time = cool_rumor.last_spread_time || world.realtime
	copy_rumor.last_modified_time = cool_rumor.last_modified_time || world.realtime
	copy_rumor.created_time = cool_rumor.created_time || world.realtime
	copy_rumor.times_spread = cool_rumor.times_spread || 0
	copy_rumor.deleted_time = cool_rumor.deleted_time || 0
	rumor_slots[slot]["[copy_rumor.rumor_uid]"] = copy_rumor
	set_durty(TRUE)
	return TRUE

/datum/rumor_holder/proc/remove_rumor(rumor_uid, slot, kill = FALSE)
	var/datum/rumor/cool_rumor = rumor_slots[slot]["[rumor_uid]"]
	if(!cool_rumor)
		return
	if(kill) // someone did a bad, and the admin said no
		rumor_slots[slot]["[rumor_uid]"] = null
		rumor_slots[slot] -= rumor_uid
		qdel(cool_rumor)
	else
		cool_rumor.deleted_time = world.realtime
	set_durty(TRUE)
	return TRUE

/datum/rumor_holder/proc/get_rumor(rumor_uid, slot)
	return rumor_slots[slot]["[rumor_uid]"]

/datum/rumor_holder/proc/get_a_rumor(horny_level, slot)
	var/available_rumors = list()
	for(var/rumor_uid in rumor_slots[slot])
		var/datum/rumor/rumor= rumor_slots[slot]["[rumor_uid]"]
		if(horny_level == HORNYMODE_NONE && rumor.is_nsfw)
			continue
		if(horny_level == HORNYMODE_ONLYHORNY && !rumor.is_nsfw)
			continue
		available_rumors += rumor
	if(!available_rumors)
		return null
	return pick(available_rumors)

/datum/rumor_holder/proc/has_room_for_more_rumors(mob/user, slot)
	var/list/all_rumors = get_all_rumors(slot)
	if(LAZYLEN(all_rumors) >= SSrumormill.max_rumors_per_slot)
		return FALSE
	return TRUE

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
	rumors_for_slot.Swap(my_index, target_index)
	rumor_slots[slot] = rumors_for_slot // just in case
	set_durty(TRUE)
	return TRUE

/datum/rumor_holder/proc/get_keys(slot, get_deleteds = FALSE)
	var/list/keys = list()
	for(var/rumorkey in rumor_slots[slot])
		if(!get_deleteds)
			var/datum/rumor/rumor = rumor_slots[slot]["[rumorkey]"]
			if(rumor.deleted_time > 0)
				continue
		keys += rumorkey
	return keys

/* ======================================= */
/// SERIALIZATION STUFF

/// outputs the whole thing, for saving to disk. if saving is FALSE, it will not include deleted rumors
/datum/rumor_holder/proc/serialize_rumor_holder(saving)
	if(saving)
		set_durty(FALSE)
	var/list/serialized = list()
	serialized["ckey"] = src.c_key
	serialized["last_online"] = src.last_online
	serialized["slot_holder"] = serialize_all_slots(saving)
	return serialized

/datum/rumor_holder/proc/serialize_all_slots(saving)
	var/list/serialized_slots = list()
	for(var/i in 1 to LAZYLEN(rumor_slots))
		serialized_slots += list(serialize_slot(i, saving))
	return serialized_slots

/datum/rumor_holder/proc/serialize_slot(slot, saving)
	var/list/data = list()
	data["rumors"] = serialize_slot_rumor_list(slot, saving)
	data["character_name"] = character_names[slot]
	data["slot"] = slot // this better be a fkn number
	return data

/datum/rumor_holder/proc/serialize_slot_rumor_list(slot, deleteds_too)
	var/list/all_rumors = list()
	var/index = 1
	for(var/rumor_uid in rumor_slots[slot])
		var/datum/rumor/rumor = rumor_slots[slot]["[rumor_uid]"]
		if(!rumor)
			continue
		if(rumor.deleted_time && !deleteds_too)
			continue
		var/list/rumordat = rumor.serialize_rumor()
		// positioning!
		if(LAZYLEN(rumor_slots[slot]) <= 1)
			rumordat["position"] = "hidden"
		else if(index == 1)
			rumordat["position"] = "top"
		else if(index == LAZYLEN(rumor_slots[slot]))
			rumordat["position"] = "bottom"
		else
			rumordat["position"] = "mid"
		all_rumors += list(rumordat)
		index += 1
	return all_rumors

/datum/rumor_holder/proc/set_durty(new_durt)
	durty = new_durt

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
	)
	. = ..()
	src.associate_holder(rholder)
	src.rumor_uid           = rumor_uid
	src.rumor_text          = rumor_text
	src.is_nsfw             = is_nsfw
	src.is_public           = is_public
	src.is_specificable     = is_specificable
	src.deleted_time        = deleted_time
	src.times_spread        = times_spread
	src.created_time        = created_time  || time2text(world.realtime)
	src.last_modified_time  = modified_time || time2text(world.realtime)

/datum/rumor/Destroy(force)
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
		src.last_modified_time = time2text(world.realtime)
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
	rumor_text = new_text
	set_holder_durty(TRUE)
	to_chat(user, span_notice("Okay! Updated rumor text to: [new_text]"))
	return TRUE

/datum/rumor/proc/serialize_rumor()
	return list(
		"uid" = src.rumor_uid,
		"text" = src.rumor_text,
		"horny" = src.is_nsfw,
		"public" = src.is_public,
		"specificable" = src.is_specificable,
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
	if(action == "operate_rumormill_admin")
		var/ckey = params["rumor_ckey"]
		var/rumor_uid = params["rumor_uid"]
		var/datum/rumor_holder/rholder = SSrumormill.GetRumorHolder(ckey)
		if(!rholder)
			return
		var/datum/rumor/cool_rumor = rholder.get_rumor(rumor_uid)
		if(!cool_rumor)
			return
		var/r_text = cool_rumor.rumor_text
		var/r_horny = cool_rumor.is_nsfw
		var/r_public = cool_rumor.is_public
		var/r_specifiable = cool_rumor.is_specificable
		var/r_created = cool_rumor.created_time
		var/r_modified = cool_rumor.last_modified_time
		var/r_times_spread = cool_rumor.times_spread
		SSrumormill.delete_rumor(usr, rumor_uid, TRUE)
		to_chat(usr, span_notice("Deleted rumor [rumor_uid] from [ckey]! The text was: [r_text]"))
		to_chat(usr, span_notice("Horny: [r_horny ? "yes" : "no"], Public: [r_public ? "yes" : "no"], Specifiable: [r_specifiable ? "yes" : "no"]"))
		to_chat(usr, span_notice("Created: [r_created], Modified: [r_modified], Times Spread: [r_times_spread]"))
		to_chat(usr, span_notice("Be sure to give em one for me!"))

ADMIN_VERB(moderate_rumors, R_ADMIN, "Moderate Rumors", "Look through all the rumors, see if any need killing.", ADMIN_CATEGORY_MAIN)
	SSrumormill.open_admin_tool(user)

ADMIN_VERB(save_rumors, R_ADMIN, "Save Rumors", "Save the rumors!", ADMIN_CATEGORY_MAIN)
	SSrumormill.SaveRumorsToDisk()

ADMIN_VERB(load_and_obliterate_rumors, R_ADMIN, "Load and Obliterate Rumors", "Load the rumors from disk and obliterate the current ones!", ADMIN_CATEGORY_MAIN)
	SSrumormill.LoadRumorsFromDisk(TRUE)


