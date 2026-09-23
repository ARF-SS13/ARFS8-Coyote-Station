
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
	var/saymode_cooldown = 45000
	/// player doesnt want their messages to be visualchat delivered to others, for whatrever reason
	var/suppress_accountwide = FALSE
	/// the almightly clipboard, because there is gonna be a LOT of copying and pasting of preferences
	var/datum/vc_clipboard_data/clipboard
	/// color swatchboard!
	var/max_color_swatches = 10
	var/list/color_swatches = list()
	/// used for tgui react memo, cus like, theres a million things that could have changed and we need to know when to re-render
	var/changed_time = 0
	/// if true, this account has been made durty and needs to be saved
	var/durty_account = FALSE
	var/super_durty_account = FALSE // save everything!
	var/list/chatman_data = list()
	var/see_visualchat = TRUE // if false, they dont want to see any visualchat messages, the dinkus
	var/see_visualchat_range = 3 // the tiledistance where u can actually see visualchat messages from others
	var/see_visualchat_range_max = 10 // the maximum distance you can set your visualchat range to
	var/see_visualchat_range_min = 1 // the minimum distance you can set your visualchat range to
	var/show_own_pfp = FALSE

/datum/vc_account_prefs_manager/New(ckey)
	owner_ckey = ckey // it'll be referenced by all its subordinates
	clipboard = new(src)

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
	chatman_data["show_own_pfp"] = show_own_pfp
	chatman_data["see_visualchat"] = see_visualchat
	chatman_data["suppress_account"] = suppress_accountwide

/datum/vc_account_prefs_manager/proc/update_chatman_data()
	chatman_data["last_updated"] = world.realtime
	chatman_data["show_own_pfp"] = show_own_pfp
	chatman_data["see_visualchat"] = see_visualchat
	chatman_data["suppress_account"] = suppress_accountwide
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
		if(isnull(chatman_data["show_own_pfp"]))
			chatman_data["show_own_pfp"] = initial(show_own_pfp)
		show_own_pfp = chatman_data["show_own_pfp"]
		if(isnull(chatman_data["see_visualchat"]))
			chatman_data["see_visualchat"] = initial(see_visualchat)
		see_visualchat = chatman_data["see_visualchat"]
		if(isnull(chatman_data["suppress_account"]))
			chatman_data["suppress_account"] = initial(suppress_accountwide)
		suppress_accountwide = chatman_data["suppress_account"]
		return TRUE
	return FALSE

/datum/vc_account_prefs_manager/proc/get_prefs_holder_for_slot(slot, kind)
	var/datum/vc_preference_holder/hold_out = null
	if(!kind)
		kind = get_mob_kind_for_slot(slot)
	switch(kind)
		if("human")
			hold_out = prefs_per_slot_human["[slot]"]
		if("silicon")
			hold_out = prefs_per_slot_silicon["[slot]"]
		else
			CRASH("Attempted to get a prefs holder for an unsupported kind '[kind]' for ckey '[owner_ckey]'! ERROR CODE: SOFT-BEANBAG-MILKY")
	if(!hold_out) // make one!
		hold_out = new /datum/vc_preference_holder(src, kind, slot)
		switch(kind)
			if("human")
				prefs_per_slot_human["[slot]"] = hold_out
			if("silicon")
				prefs_per_slot_silicon["[slot]"] = hold_out
	return hold_out

/datum/vc_account_prefs_manager/proc/manager_get_saymode(atom/movable/yap, slut, say_mode, tgui = FALSE, bounce_if_default = FALSE) as /datum/vc_saymode
	var/datum/vc_preference_holder/hold_out = get_prefs_holder_for_slot(slut, get_mob_kind_for_slot(slut))
	if(!hold_out || (hold_out.suppress_characterwide && !tgui))
		return null
	return hold_out.prefholder_get_saymode(say_mode, bounce_if_default)

/datum/vc_account_prefs_manager/proc/get_mob_kind_for_slot(slot)
	//! todo: Update to handle non-ckeyed atoms, and non-humanlike mobs (frickable owls)
	var/atom/movable/thing = extract_mob(GLOB.directory[owner_ckey])
	if(!thing)
		CRASH("Attempted to get mob kind for a null mob!")
	// are we human...
	if(issilicon(thing))
		return "silicon"
	// ...or are we dancer
	else
		return "human" // whatever close enough

/datum/vc_account_prefs_manager/proc/set_durty_account()
	durty_account = TRUE

/datum/vc_account_prefs_manager/proc/set_un_durty()
	durty_account = FALSE
	super_durty_account = FALSE
	for(var/holderkey in prefs_per_slot_human)
		var/datum/vc_preference_holder/holder = prefs_per_slot_human[holderkey]
		holder?.set_un_durty()
	for(var/holderkey in prefs_per_slot_silicon)
		var/datum/vc_preference_holder/holder = prefs_per_slot_silicon[holderkey]
		holder?.set_un_durty()

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
	set_un_durty()
	var/client/user_probably = GLOB.directory[owner_ckey]
	if(user_probably)
		to_chat(user_probably, span_notice("Visual Chat preferences saved!"))
	return TRUE

/datum/vc_account_prefs_manager/proc/load_account()
	if(!load_chatman_data())
		make_brand_new_account(GLOB.directory[owner_ckey]) // welcome to visual chat, you horny doggo
		return
	// saves -> ckey -> slot_1 thru slot_n -> human or silicon -> other stuff
	var/filename = "[SSvisualchat.GetSavesFolder()][owner_ckey]/"
	var/list/sluts = flist("[filename]")
	for(var/slotfile in sluts)
		if(slotfile == "chatman.json")
			continue
		slotfile = replacetext(slotfile, "slot_", "") // get just the number
		slotfile = replacetext(slotfile, "/", "") // get just the number!
		var/datum/vc_preference_holder/humholder = get_prefs_holder_for_slot(slotfile, "human")
		humholder.load_character_prefs()
		var/datum/vc_preference_holder/siliholder = get_prefs_holder_for_slot(slotfile, "silicon")
		siliholder.load_character_prefs()

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

///
/// CLIPBOARD MANAGEMENT
/// Versatile af
/// Can copy from:
/// - singular settings
/// - whole saymode settings
/// - character slots (human or silicon, but not both at once)
/datum/vc_account_prefs_manager/proc/copy_to_clipboard(datakind, saymode, slot, setting, value, setting_kind)
	var/humanordancer = get_mob_kind_for_slot(slot)
	var/datum/vc_preference_holder/source_holder = get_prefs_holder_for_slot(slot, humanordancer)
	if(!source_holder)
		CRASH("Attempted to copy clipboard data from a null prefs holder for ckey '[owner_ckey]' and slot '[slot]' and humanordancer '[humanordancer]'! ERROR CODE: OVERSTUFFED-TUBEFED-DUNE")
	// clear the clibbord
	return clipboard.copy_to_clipboard(source_holder, datakind, humanordancer, slot, saymode, setting, value, setting_kind)

/datum/vc_account_prefs_manager/proc/paste_from_clipboard(datakind, saymode, slot, setting, value, setting_kind)
	var/humanordancer = get_mob_kind_for_slot(slot)
	var/datum/vc_preference_holder/target_holder = get_prefs_holder_for_slot(slot, humanordancer)
	if(!target_holder)
		CRASH("Attempted to paste clipboard data to a null prefs holder for ckey '[owner_ckey]'! ERROR CODE: EMPTY-CLIPBOARD")
	return clipboard.paste_from_clipboard(target_holder, datakind, saymode, setting, value, setting_kind)

/datum/vc_account_prefs_manager/proc/get_clipboard()
	var/list/clipdata = list()
	if(!clipboard.got_it())
		clipdata["haz"] = FALSE
	else
		clipdata["haz"] = TRUE
		clipdata["source_datakind"]      = clipboard.source_datakind
		clipdata["source_kind"]          = clipboard.source_kind
		clipdata["source_slot"]          = clipboard.source_slot
		clipdata["source_saymode"]       = clipboard.source_saymode
		clipdata["source_setting"]       = clipboard.source_setting
		clipdata["source_value"]         = clipboard.source_value
		clipdata["source_setting_kind"]  = clipboard.source_setting_kind
	return clipdata

/// swatches
/datum/vc_account_prefs_manager/proc/add_color_swatch(clyouler)
	if(!clyouler)
		return FALSE
	color_swatches |= clyouler
	if(LAZYLEN(color_swatches) > max_color_swatches)
		color_swatches.Cut(1,2)
	return TRUE

/datum/vc_account_prefs_manager/proc/remove_color_swatch(clyouler)
	if(!clyouler)
		return FALSE
	color_swatches -= clyouler
	return TRUE



/datum/vc_clipboard_data
	var/datum/vc_account_prefs_manager/parent_manager
	/// preferences holder we're pulling the data from (weakref)
	/// pasted data will come from this holder
	var/datum/weakref/source_holder_ref
	var/source_datakind // "SINGLE", "SAYMODE", or "CHARACTER"
	var/source_kind
	var/source_slot
	var/source_saymode
	var/source_setting
	var/source_value
	var/source_setting_kind

/datum/vc_clipboard_data/New(manager)
	parent_manager = manager

/datum/vc_clipboard_data/proc/clear_clipboard()
	source_datakind = null
	source_holder_ref = null
	source_kind = null
	source_slot = null
	source_saymode = null
	source_setting = null
	source_value = null
	source_setting_kind = null

/datum/vc_clipboard_data/proc/got_it()
	if(source_datakind && source_holder_ref)
		return TRUE
	return FALSE

/datum/vc_clipboard_data/proc/copy_to_clipboard(datum/vc_preference_holder/source_holder, datakind, pref_kind, pref_slot, pref_saymode, pref_setting, pref_value, pref_setting_kind)
	clear_clipboard()
	if(!source_holder)
		CRASH("Attempted to copy clipboard data from a null prefs holder! ERROR CODE: OVERWEIGHT-EXPIE-HIPS")
	/// source_datakinds!
	/// "SINGLE" = single setting
	/// "SAYMODE" = entire saymode settings
	/// "CHARACTER" = entire character slot settings
	switch(datakind)
		if("SINGLE")
			if(!pref_kind || !pref_slot || !pref_saymode || !pref_setting || !pref_value || !pref_setting_kind)
				CRASH("Attempted to serialize clipboard source_data with an invalid SINGLE source_datakind '[datakind]'! ERROR CODE: OVERWEIGHT-EXPIE-THIGHS")
		if("SAYMODE")
			if(!pref_kind || !pref_slot || !pref_saymode)
				CRASH("Attempted to serialize clipboard source_data with an invalid SAYMODE source_datakind '[datakind]'! ERROR CODE: OVERWEIGHT-EXPIE-BELLY")
		if("CHARACTER")
			if(!pref_kind || !pref_slot)
				CRASH("Attempted to serialize clipboard source_data with an invalid CHARACTER source_datakind '[datakind]'! ERROR CODE: OVERWEIGHT-EXPIE-BUTTOCKS")
		else
			CRASH("Attempted to serialize clipboard source_data with an invalid source_datakind '[datakind]'! ERROR CODE: OVERWEIGHT-EXPIE-FUPA")

	source_kind          = pref_kind
	source_slot          = pref_slot
	source_saymode       = pref_saymode
	source_setting       = pref_setting
	source_value         = pref_value
	source_setting_kind  = pref_setting_kind
	source_datakind      = datakind
	source_holder_ref    = WEAKREF(source_holder)
	return TRUE

/// we have a from, now we need a to!
/datum/vc_clipboard_data/proc/paste_from_clipboard(datum/vc_preference_holder/paste_to, paste_saymode, paste_setting, paste_value, paste_setting_kind)
	// paste_to = destination holder, where the data should be applied
	if(!paste_to)
		CRASH("Attempted to deserialize clipboard data from an empty clipboard! ERROR CODE: EMPTY-CLIPBOARD")
	var/datum/vc_preference_holder/source = GET_WEAKREF(source_holder_ref) // source holder, where the data came from
	// and yes, source and paste_to can be the same thing
	if(!source)
		clear_clipboard()
		CRASH("Attempted to deserialize clipboard data with a null preference holder! ERROR CODE: NULL-HOLDER")
	switch(source_datakind)
		if("SINGLE")
			if(!source_saymode || !source_setting || !source_value || !source_setting_kind)
				clear_clipboard()
				CRASH("Attempted to deserialize clipboard data with an invalid SINGLE source_datakind '[source_datakind]'! ERROR CODE: OVERWEIGHT-EXPIE-THIGHS")
			if(!paste_saymode || !paste_setting || !paste_value || !paste_setting_kind)
				CRASH("Attempted to deserialize clipboard data with an invalid SINGLE source_datakind '[source_datakind]'! ERROR CODE: SLENDER-EXPIE-TOES")
			// destination isnt always the same as the source setting
			var/datum/vc_setting/source_setting_foreal = source.prefholder_get_saymode(source_saymode)?.get_setting(source_setting)
			var/datum/vc_setting/destination_setting = paste_to.prefholder_get_saymode(paste_saymode)?.get_setting(paste_setting)
			if(!source_setting_foreal || !destination_setting)
				clear_clipboard()
				CRASH("Attempted to deserialize clipboard data with a null source or destination setting! ERROR CODE: NULL-SETTING")
			if(source_setting_foreal.st_kind != destination_setting.st_kind)
				return FALSE // cant paste a setting of one kind to a setting of another kind
			destination_setting.update_terminal_setting(paste_value)
			return TRUE
		if("SAYMODE")
			if(!source_saymode)
				CRASH("Attempted to deserialize clipboard data with an invalid SAYMODE source_datakind '[source_datakind]'! ERROR CODE: OVERWEIGHT-EXPIE-BELLY")
			var/datum/vc_saymode/sorc_smode = source.prefholder_get_saymode(source_saymode)
			var/datum/vc_saymode/destination_saymode = paste_to.prefholder_get_saymode(paste_saymode)
			destination_saymode.copy_saymode_settings_from(sorc_smode)
			return TRUE
		if("CHARACTER")
			paste_to.copy_character_settings_from(source)
			return TRUE


