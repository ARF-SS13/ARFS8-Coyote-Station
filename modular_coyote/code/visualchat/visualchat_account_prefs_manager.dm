
/// ╔═══════════════════════════════════════════════════════════════════╗
/// ║ ╔════════════════════════════════════╗  ACCOUNT LEVEL PREFERENCES ║
/// ║ ║ VISUAL CHAT PREFERENCES MANAGEMENT ║  ╔═════════════════════════╝
/// ║ ╚════════════════════════════════════╝  ╚═════════════════════════╗
/// ║ Manages the cluster of a player's current visual chat preferences ║
/// ║ Ckey for player account, slot for the character slot, plus some   ║
/// ║ extras for mobs and such                                          ║
/// ╚═══════════════════════════════════════════════════════════════════╝
/datum/vc_account_prefs_manager
	var/owner_ckey
	/// So! this is the directory for the unholy clusters of visual chat preferences per player.
	/// prefs_per_slot_human: for normal-spawned characters from the character setup menu
	///   Generally whats used for the vast majority of players
	///   format: "[slot]" = /datum/vc_prefs_holder
	var/list/prefs_per_slot_human = list()
	/// prefs_per_slot_silicon: for silicon characters, like AIs or robots
	///   dogborgs and such pull from this, though it'll fallback to the human slot if it doesn't exist... maybe
	///   format: "[slot]" = /datum/vc_prefs_holder
	var/list/prefs_per_slot_silicon = list()
	/// prefs_per_mob: for mobs that arent borne of the character setup menu, like rats and ash drakes
	///   Checked when this ckey acts as a mob, of this type or any subtype of it
	///   Has a default of /mob
	///   format: "[mob_type]" = /datum/vc_prefs_holder
	var/list/prefs_per_mob = list()
	/// prefs_npc: the datum used for this non-player character, if its a non-player character that is
	var/datum/vc_preference_holder/prefs_npc // unused, coming soon to a visual chat near you
	/// cooldown for showing the whole VC message, for like, repeat similar-style messages
	var/last_saymode
	var/last_saymode_time = 0
	/// milliseconds!
	var/saymode_cooldown = 15000
	/// player doesnt want their messages to be visualchat delivered to others, for whatrever reason
	var/suppress_accountwide = FALSE
	/// the almightly clipboard, because there is gonna be a LOT of copying and pasting of preferences
	var/list/clipboard = list()
	/// color swatchboard!
	var/list/color_swatches = list()
	/// if true, this account has been made durty and needs to be saved
	var/durty_account = FALSE
	var/super_durty_account = FALSE // save everything!
	var/list/chatman_data = list()
	var/see_visualchat = TRUE // if false, they dont want to see any visualchat messages, the dinkus

/datum/vc_account_prefs_manager/New(ckey)
	owner_ckey = ckey // it'll be referenced by all its subordinates

/datum/vc_account_prefs_manager/Destroy()
	owner_ckey = null
	QDEL_LIST_ASSOC_VAL(prefs_per_slot_human)
	QDEL_LIST_ASSOC_VAL(prefs_per_slot_silicon)
	QDEL_LIST_ASSOC_VAL(prefs_per_mob)
	clipboard = list()
	color_swatches = list()
	SSvisualchat.chatprefs -= "[owner_ckey]"
	. = ..()

/datum/vc_account_prefs_manager/proc/make_brand_new_account(client/clientser)
	if(!clientser || !clientser.ckey)
		CRASH("Attempted to make a new VC account for a null user or user with no ckey!!!!!!!!!!")
	new_chatman(clientser?.mob) // squirrelly little things
	super_durty_account = TRUE
	save_account()

/datum/vc_account_prefs_manager/proc/new_chatman(mob/user)
	if(!user || !user.ckey)
		CRASH("Attempted to make a new chatman for a null user or user with no ckey!!!!!!!!!!")
	chatman_data = list()
	chatman_data["version"] = SSvisualchat.versions[LAZYLEN(SSvisualchat.versions)]
	chatman_data["ckey"] = user.ckey
	chatman_data["date_made"] = world.realtime
	chatman_data["last_updated"] = world.realtime
	chatman_data["serial_number"] = SSvisualchat.GetTotalChatmen() + 1
	chatman_data["tracked_characters"] = list() | user.real_name
	chatman_data["favorite_shark"] = "[pick(GLOB.megacarp_first_names)] [pick(GLOB.megacarp_last_names)]"

/datum/vc_account_prefs_manager/proc/update_chatman_data()
	chatman_data["last_updated"] = world.realtime
	var/client/user = GLOB.directory[owner_ckey]
	if(user?.mob)
		if(isnull(chatman_data["tracked_characters"]))
			chatman_data["tracked_characters"] = list()
		chatman_data["tracked_characters"] |= user.mob.real_name

/datum/vc_account_prefs_manager/proc/save_chatman_data()
	var/pafth = "[SSvisualchat.GetSavesFolder()]/[owner_ckey]/chatman.json"
	var/datacontent = json_encode(chatman_data, JSON_PRETTY_PRINT)
	rustg_file_write(datacontent, pafth)
	if(SSvisualchat.debug_saving)
		SSvisualchat.ReloadAndCompare(pafth, datacontent, "Chatman Data")

/datum/vc_account_prefs_manager/proc/load_chatman_data()
	var/pafth = "[SSvisualchat.GetSavesFolder()]/[owner_ckey]/chatman.json"
	var/exists = rustg_file_exists(pafth)
	if(!exists)
		return FALSE
	var/datacontent = rustg_file_read(pafth)
	if(datacontent)
		chatman_data = json_decode(datacontent)
		return TRUE
	return FALSE

/datum/vc_account_prefs_manager/proc/get_prefs_holder_for_slot(slot, kind)
	var/datum/vc_preference_holder/hold_out = null
	switch(kind)
		if("human")
			hold_out = prefs_per_slot_human["[slot]"]
		if("silicon")
			hold_out = prefs_per_slot_silicon["[slot]"]
	if(!hold_out) // make one!
		hold_out = new /datum/vc_preference_holder(src)
		switch(kind)
			if("human")
				prefs_per_slot_human["[slot]"] = hold_out
			if("silicon")
				prefs_per_slot_silicon["[slot]"] = hold_out
	return hold_out

/datum/vc_account_prefs_manager/proc/manager_get_saymode(atom/movable/yap, slut, say_mode)
	// are we human....
	var/human_or_silicon = "human"
	// ...or are we dancers
	if(issilicon(yap))
		human_or_silicon = "silicon"
	var/datum/vc_preference_holder/hold_out = get_prefs_holder_for_slot(slut, human_or_silicon)
	if(!hold_out || hold_out.suppress_characterwide)
		return null
	return hold_out.prefholder_get_saymode(yap, slut, say_mode)

/datum/vc_account_prefs_manager/proc/set_durty_account()
	durty_account = TRUE

/// Save the account data to disk, if it has been marked as durty
/datum/vc_account_prefs_manager/proc/save_account(super_durty_account)
	if(!am_durty())
		return FALSE
	update_chatman_data()
	save_chatman_data()
	for(var/holderkey in prefs_per_slot_human)
		var/datum/vc_preference_holder/holder = prefs_per_slot_human[holderkey]
		var/succ = holder?.save_character_prefs(super_durty_account)
		if(isnull(succ))
			stack_trace("Failed to save human slot [holderkey] for ckey [owner_ckey]!")
			message_admins("Failed to save human slot [holderkey] for ckey [owner_ckey]!")
	for(var/holderkey in prefs_per_slot_silicon)
		var/datum/vc_preference_holder/holder = prefs_per_slot_silicon[holderkey]
		var/succ = holder?.save_character_prefs(super_durty_account)
		if(isnull(succ))
			stack_trace("Failed to save silicon slot [holderkey] for ckey [owner_ckey]!")
			message_admins("Failed to save silicon slot [holderkey] for ckey [owner_ckey]!")
	durty_account = FALSE
	var/client/user_probably = GLOB.directory[owner_ckey]
	if(user_probably)
		to_chat(user_probably, span_notice("Visual Chat preferences saved!"))
	return TRUE

/datum/vc_account_prefs_manager/proc/load_account()
	if(!load_chatman_data())
		make_brand_new_account(GLOB.directory[owner_ckey]) // welcome to visual chat, you horny doggo
		return
	// saves -> ckey -> slot_1 thru slot_n -> human or silicon -> other stuff
	var/filename = "[SSvisualchat.GetSavesFolder()]/[owner_ckey]/"
	var/list/sluts = flist("[filename]")
	for(var/slotfile in sluts)
		var/list/humansluts = flist("[filename]/[slotfile]/human/")
		for(var/humanfile in humansluts)
			var/datum/vc_preference_holder/holder = get_prefs_holder_for_slot(slotfile, "human")
			holder.load_character_prefs()
		var/list/siliconsluts = flist("[filename]/[slotfile]/silicon/")
		for(var/siliconfile in siliconsluts)
			var/datum/vc_preference_holder/holder = get_prefs_holder_for_slot(slotfile, "silicon")
			holder.load_character_prefs()

/datum/vc_account_prefs_manager/proc/am_durty()
	if(durty_account || super_durty_account)
		return TRUE
	for(var/holderkey in prefs_per_slot_human)
		var/datum/vc_preference_holder/holder = prefs_per_slot_human[holderkey]
		if(holder?.am_durty_character())
			return TRUE
	for(var/holderkey in prefs_per_slot_silicon)
		var/datum/vc_preference_holder/holder = prefs_per_slot_silicon[holderkey]
		if(holder?.am_durty_character())
			return TRUE
	return FALSE


/// ╔═════════════════════════════════════════════════════════════╗
/// ║ TGUI FOR SETUP                                              ║
/// ║ All the settings data for a given character slot            ║
/// ║ However it also grabs the silicon prefs for the silicon tab ║
/// ║ and the list of mob types for the mob dropdown              ║
/// ║ And clipboard, and swatches, and all that grooby bumfalo    ║
/// ╚═════════════════════════════════════════════════════════════╝
/datum/vc_account_prefs_manager/proc/get_tgui_for_setup(slot, kind)

