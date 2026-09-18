// ╔═════════╤═════════════════════════════╗
// ║ File    │ visualchat_subsystem.dm     ║
// ║ Date    │ 1979-12-25                  ║
// ║ Author  │ Daniel "ThroatYoate" Kelly  ║
// ║ License │ CMYK-Pubic-Domain-1.0       ║
// ║ Quote   │ "I can see your cute voice" ║
// ╟─────────┼─────────────────────────────╨──────────────────────────────────────────╖
// ║         │                                                                        ║
// ║  ####   │ Welcome to VisualChat, a visual novel chat destruction system for SS13 ║
// ║  ####   │                                                                        ║
// ║  ####   │ Got soem stuff parts to it!                                            ║
// ║  ####   │ - Player settings! in depth and customizable! (with a lot of options)  ║
// ║  ####   │ --- Saved as jsons cus thats kinda hot                                 ║
// ║  ####   │ - Say data extractor, to get the data from say messages!               ║
// ║         │                                                                        ║
// ╟─────────┼────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ====================================================================  ║
// ╚═════════╧════════════════════════════════════════════════════════════════════════╝

// foldiers structure for VisualChat data
// data/visualchat/
// ├─ logs/
// ├─ metrix/
// ├─ saves/
// └─┬─ [ckey]/
//   └─┬─ chatman.json // cus im the chat man, skibbidy bop
//     ├─┬─ slot_[slot]/
//     │ ├─┬─ human/
//     │ │ └─┬─ saymode___[saymode].json
//     │ │   ├─ saymodecustom___[saymode].json
//     │ │   └─ ...
//     │ └─┬─ silicon/
//     │   └─┬─ saymode___[saymode].json
//     │     ├─ saymodecustom___[saymode].json
//     │     └─ ...
//     └─┬─ mobs/ <-- unused currently, but will be used for per-mobtype settings
//       └─┬─ [mobtype]/
//         └─┬─ saymode___[saymode].json
//           ├─ saymodecustom___[saymode].json
//           └─ ...
// Like the blovy said to the tree: Tree

#define VC_PATH                  "data/visualchat"
#define VC_LOGS                  VC_PATH + "/logs"
#define VC_METRIX                VC_PATH + "/metrix"
#define VC_SAVES                 VC_PATH + "/saves/"
SUBSYSTEM_DEF(visualchat)
	name = "VisualChat"
	wait = 10 SECONDS
	/// format: list("[ckey]" = /datum/vc_account_prefs_manager, etc)
	var/list/chatprefs = list()
	var/datum/vc_metrix/metrix
	var/max_hearable_horny_dist = 300
	var/debug_saving = TRUE
	var/datum/vc_settings_ui_chungus/setzup
	// most recent at the bottom, oldest at the top. for updates or something
	var/list/versions = list(
		"v0.1b - Initial release",
	)
	// accepted hosts
	var/list/valid_hosts = list(
		"catbox.moe" = "https://files.catbox.moe",
		"gyazo.com" = "https://i.gyazo.com",
		"f-list.net" = "https://static.f-list.net/images/charimage",
	)
	var/list/valid_extensions = list(
		"png",
		"jpg",
		"jpeg",
		"gif",
		"webp", // regretably
		"bmp", // do people still use these?
		"tiff", // for the true connoisseurs
		"svg", // idkj maybe it works
		"ico", // todo: a proc that gibs whoever uses this
	)

/datum/controller/subsystem/visualchat/Initialize(start_timeofday)
	setzup = new
	LoadVCSettings()
	var/num_accs = 0
	var/num_saymodes = 0
	for(var/ckey in chatprefs)
		num_accs++
		var/datum/vc_account_prefs_manager/manager = chatprefs[ckey]
		for(var/slot in manager.prefs_per_slot_human)
			var/datum/vc_preference_holder/holder = manager.prefs_per_slot_human[slot]
			for(var/saymode in holder.saymode_prefs)
				num_saymodes++
		for(var/slot in manager.prefs_per_slot_silicon)
			var/datum/vc_preference_holder/holder = manager.prefs_per_slot_silicon[slot]
			for(var/saymode in holder.saymode_prefs)
				num_saymodes++
	to_chat(world, span_captaincast("Initialized VisualChat with [num_accs] accounts and [num_saymodes] saymode preferences!"))

/datum/controller/subsystem/visualchat/fire()
	// save all the things! 6 7!
	SaveVCSettings()

/datum/controller/subsystem/visualchat/proc/LoadVCSettings(killreplace)
	var/list/ckey_folders = flist(VC_SAVES)
	for(var/ckey_folder in ckey_folders)
		GetVCAccountPrefsManager(ckey_folder, killreplace)

/datum/controller/subsystem/visualchat/proc/SaveVCSettings()
	for(var/ckey in chatprefs)
		var/datum/vc_account_prefs_manager/manager = chatprefs[ckey]
		manager.save_account()

/datum/controller/subsystem/visualchat/proc/GetSavesFolder(slashem = FALSE)
	var/folder = VC_SAVES
	if(slashem)
		folder += "/"
	return folder

/datum/controller/subsystem/visualchat/proc/ReloadAndCompare(filename, datacontent, context)
	var/old_content = rustg_file_read(filename)
	if(old_content != datacontent)
		LogVCDebug(filename, old_content, datacontent, context, "ReloadAndCompare() found a difference between the old and new content!")

/datum/controller/subsystem/visualchat/proc/LogVCDebug(filename, old_content, datacontent, context, message)
	var/logfile = "[VC_LOGS]/debug.txt"
	if(!rustg_file_exists(logfile))
		rustg_file_write("", logfile)
	var/logtext = "[world.realtime] [context]: [message] ([filename])\n"
	logtext += "--> New Content:\n[datacontent]\n"
	logtext += "--> Old Content:\n[old_content]\n"
	rustg_file_append(logtext, logfile)
	message_admins("VisualChat Debug: [context]: [message] ([filename])")


/datum/controller/subsystem/visualchat/proc/Hornify(mob/reader, list/message_data)
	if(!reader || !reader.client || !LAZYLEN(message_data))
		return
	var/atom/spanker = message_data[SATA_SPEAKER]
	if(get_dist(get_turf(reader), get_turf(spanker)) > max_hearable_horny_dist)
		return
	var/datum/vc_account_prefs_manager/reader_manager = GetVCAccountPrefsManager(reader, FALSE, TRUE)
	if(!reader_manager.see_visualchat)
		return
	/// speaker's key, gotta go looking
	var/list/relevant_datpak = \
		GetRelevantDatPak(message_data[SATA_ORIGIN_OVERRIDE]) || \
		GetRelevantDatPak(message_data[SATA_SPEAKER])         || \
		GetRelevantDatPak(message_data[SATA_ORIGIN])
	if(!LAZYLEN(relevant_datpak))
		return
	var/datum/vc_account_prefs_manager/speaker_manager
	var/atom/override_atom = relevant_datpak["atom"]
	if(override_atom) // its an npc or something, so we need to use the override path instead of the ckey
		speaker_manager = GetVCAccountPrefsManager(override_atom, FALSE, TRUE)
	else
		speaker_manager = GetVCAccountPrefsManager(relevant_datpak["atom"], FALSE, TRUE)
	if(!speaker_manager)
		return
	if(speaker_manager.suppress_accountwide)
		return
	// got it! extract the proper saymode
	var/say_mode = ExtractSaymode(message_data)
	var/slut = relevant_datpak["slot"]
	var/atom/movable/yap = relevant_datpak["atom"]
	var/datum/vc_saymode/saymode = speaker_manager.manager_get_saymode(yap, slut, say_mode)
	if(!saymode) // null if something is suppressed
		return
	var/list/datapaquette = list()
	datapaquette["saymode_data"] = saymode.serialize_saymode(FALSE) // smaller tgui means less plastic
	var/list/msg_dat = list()
	msg_dat["body_text"]               = message_data[SATA_MESSAGE_HEARD]
	msg_dat["body_spans"]              = message_data[SATA_SPANS]
	msg_dat["used_verb"]               = message_data[SATA_DISPLAYED_SAYMODE]
	msg_dat["is_radio"]                = message_data[SATA_IS_RADIO]
	msg_dat["is_emote"]                = message_data[SATA_IS_EMOTE]
	msg_dat["is_emote_quick"]          = message_data[SATA_IS_EMOTE_QUICK]
	msg_dat["am_ghost"]                = message_data[SATA_HEARER_IS_GHOST]
	msg_dat["displayed_name"]          = message_data[SATA_DISPLAYED_NAME]
	msg_dat["radio_color"]             = message_data[SATA_RADIO_FREQ_COLOR]
	msg_dat["radio_freq_name"]         = message_data[SATA_RADIO_TAG]
	msg_dat["language_icon"]           = message_data[SATA_LANGUAGE_ICON]
	msg_dat["language_understood"]     = message_data[SATA_LANGUAGE_UNDERSTOOD]
	msg_dat["ghost_link"]              = message_data[SATA_LINK]
	msg_dat["body_span_class"]         = message_data[SATA_BODY_SPAN_CLASS]
	msg_dat["body_span_color"]         = message_data[SATA_BODY_SPAN_COLOR]
	msg_dat["msg_splice_timeout"]      = speaker_manager.saymode_cooldown
	msg_dat["msg_splice_last_saymode"] = speaker_manager.last_saymode
	datapaquette["message_data"] = msg_dat
	// and send
	return datapaquette

/// extracts list: ("key", "slot", "kind", "overridepath")
/datum/controller/subsystem/visualchat/proc/GetRelevantDatPak(atom/movable/yap)
	if(!yap)
		return null
	var/list/datpak = list()
	// virst chenck for override
	// if(yap.vc_override_key)
	// 	datpak["overridepath"] = yap.vc_override_key
	// 	return datpak
	// virst chegck for cleint
	var/key = yap.prefs_character_ckey
	var/slut = yap.prefs_character_slot
	if(!key || !slut)
		return null
	datpak["key"] = key
	datpak["slot"] = slut
	datpak["atom"] = yap
	return datpak

/datum/controller/subsystem/visualchat/proc/ExtractSaymode(list/message_data)
	if(!LAZYLEN(message_data))
		CRASH("ExtractSaymode() called with no message data!")
	// check special cases
	if(message_data[SATA_IS_RADIO])
		return SAYMODE_RADIO
	if(message_data[SATA_IS_EMOTE])
		return SAYMODE_EMOTE
	if(message_data[SATA_IS_EMOTE_QUICK])
		return SAYMODE_EMOTE_QUICK
	return message_data[SATA_SAYMODE]

/// takes in some kind of input (hipefully text) and splits it into a host and a filename.
/// Returns list(host_key, filename) where host_key is a key from valid_hosts ("DISREGARD" if no match (it knows what to do)).
/// "filename.png" -> list("DISREGARD", "filename.png")
/// "/filename.png" -> list("DISREGARD", "filename.png")
/// "catbox.moe/filename.png" -> list("catbox.moe", "filename.png")
/// "files.catbox.moe/filename.png" -> list("catbox.moe", "filename.png")
/// "https://files.catbox.moe/filename.png" -> list("catbox.moe", "filename.png")
/datum/controller/subsystem/visualchat/proc/SplitUrlFilename(imput)
	if(!istext(imput))
		return list("DISREGARD", "")
	var/working = trim(imput)
	if(!length(working))
		return list("DISREGARD", "")
	. = list("DISREGARD", "DISREGARD")

	working = replacetext(working, "https://", "")
	working = replacetext(working, "http://", "")

	var/list/parts = splittext(working, "/")
	if(!LAZYLEN(parts))
		return list("DISREGARD", "")
	if(LAZYLEN(parts) == 1)
		// hol up, gotta be png, jpg, jpeg, gif, webp, or something
		var/file_thing = parts[1]
		var/list/splut = splittext(file_thing, ".")
		if(LAZYLEN(splut) != 2)
			return .
		if(!LAZYLEN(splut[1]) || !LAZYLEN(splut[2]))
			return .
		var/extension = splut[2]
		if(!(extension in valid_extensions))
			return .
		if(file_thing[1] == "/")
			file_thing = copytext(file_thing, 1, LAZYLEN(file_thing) + 1)
		return list("DISREGARD", file_thing)
	var/filename = parts[LAZYLEN(parts)]
	var/host_key = "DISREGARD"

	breakmecomplitely:
		for(var/chonk in parts)
			for(var/valid_salid in valid_hosts)
				if(findtext(chonk, valid_salid))
					host_key = valid_salid
					break breakmecomplitely
	return list(host_key, filename)

/datum/controller/subsystem/visualchat/proc/ExtractProfilePicLink(host, filename)
	if(!istext(host) || !istext(filename))
		return ""
	if(!(host in valid_hosts))
		return ""
	var/list/splitty = splittext(filename, ".")
	if(LAZYLEN(splitty) != 2)
		return ""
	if(!(splitty[2] in valid_extensions))
		return ""
	return host + "/" + filename

/datum/controller/subsystem/visualchat/proc/ValidateColor(maybecolor)
	if(!istext(maybecolor))
		return "#FFFFFF"
	// ensure it starts with a #
	if(!findtext(maybecolor, "#"))
		maybecolor = "#" + maybecolor
	else if(maybecolor[1] != "#")
		maybecolor = replacetext(maybecolor, "#", "")
		maybecolor = "#" + maybecolor
	// ensure it is about the right number long (#RRGGBB, #RRGGBBAA, or #RGB)
	switch(length(maybecolor))
		if(4, 7, 9)
			goto valid_length // skip
		else
			return "#FFFFFF" // default to white i guess
	valid_length:
	// all characters are valid hex characters
	var/static/valid_hex = "0123456789abcdefABCDEF#"
	for(var/i in 1 to length(maybecolor))
		if(!findtext(valid_hex, maybecolor[i]))
			maybecolor[i] = "F"
	return maybecolor

/datum/controller/subsystem/visualchat/proc/GetPreviewTextForSaymode(datum/vc_saymode/saymode)
	if(!istype(saymode))
		return "And then john turned to the camera and said, hey, this is a bug"
	var/smode = saymode.saymode
	if(LAZYLEN(preview_texts[smode]))
		return pick(preview_texts[smode])
	else
		return pick(preview_texts[SAYMODE_SAY])

/datum/controller/subsystem/visualchat/proc/GetTotalChatmen()
	var/total = 0
	var/list/ckey_folders = flist(VC_SAVES)
	total = LAZYLEN(ckey_folders)
	return total

/datum/controller/subsystem/visualchat/proc/GetVCAccountPrefsManager(smth, replace_if_present = FALSE, make = TRUE)
	if(istext(smth))
		smth = ckey(smth)
	var/thekey = extract_ckey(smth) // aghosts cause @
	if(!thekey)
		return null
	var/datum/vc_account_prefs_manager/vapm = chatprefs[thekey]
	if(vapm && replace_if_present)
		// if we want to replace it, then we need to destroy the old one first
		qdel(vapm)
		vapm = null
	if(!vapm && make)
		//attempt a load, maybe its just not here yet
		vapm = new /datum/vc_account_prefs_manager(smth)
		chatprefs[thekey] = vapm
		vapm.load_account() // load the data from disk, if it exists. otherwise it makes a new one, then saves it
	return vapm

/datum/controller/subsystem/visualchat/proc/GetStaticDataForSettingsUI(mob/user)
	// beep, beep, beep, here comes the dumptruck of data backing into your client
	var/list/dat = list()
	// hers what we need:
	// - the saymode data for every saymode they have, for the current slot, of human and silicon
	// - suppression toggles for account, character, and saymode
	var/datum/prefs_holder/P = extract_prefs_holder(user)
	var/datum/vc_account_prefs_manager/manager = GetVCAccountPrefsManager(user, FALSE, TRUE)
	var/slut = extract_current_character_slot(user, FALSE)
	var/datum/vc_preference_holder/holdiers_flavor_crystal = manager.get_prefs_holder_for_slot(slut)
	dat["saymodes"] = holdiers_flavor_crystal.get_all_saymodes_for_tgui()
	dat["suppress_account"] = manager.suppress_accountwide
	dat["suppress_character"] = holdiers_flavor_crystal.suppress_characterwide
	dat["see_visualchat"] = manager.see_visualchat
	dat["see_visualchat_range"] = manager.see_visualchat_range
	dat["see_visualchat_range_max"] = manager.see_visualchat_range_max
	dat["see_visualchat_range_min"] = manager.see_visualchat_range_min
	// individual saymode suppression toggles are in the saymode data itself
	dat["human_or_silicon"] = holdiers_flavor_crystal.kind
	dat["color_swatches"] = manager.color_swatches
	dat["clipboard"] = manager.get_clipboard()
	dat["changed_time"] = manager.changed_time
	dat["valid_hosts"] = list()
	for(var/host in SSvisualchat.valid_hosts)
		dat["valid_hosts"] += host
	dat["valid_extensions"] = SSvisualchat.valid_extensions
	// and some stuff about the user theyself
	var/maybename = user.real_name || user.name
	if(ckey(maybename) == user.ckey)
		if(holdiers_flavor_crystal == "human")
			maybename = P.read_preference(/datum/preference/name/real_name) || user.name
		else
			maybename = P.read_preference(/datum/preference/name/cyborg) || user.name
	dat["user_name"] = maybename
	return dat

/datum/controller/subsystem/visualchat/proc/PerformActForSettingsUI(action, list/params, datum/tgui/ui, datum/ui_state/state)
	// thingz it can do:
	// - update saymode preferences
	// --- slot taken from mob, human/silicon taken from params, everything else is params too
	// - update suppression toggles for account, character, and saymode
	// - update visualchat settings like see_visualchat and see_visualchat_range
	// - update color swatches
	// --- swatchify a color
	// --- modify an existing swatch
	// --- add/remove a swatch
	// - operate clipboard
	// --- copy three different things to the clipboard
	// --- paste from the clipboard
	if(!ui || !ui.user)
		CRASH("Oh good golly gosh, UI or user is null! ERROR CODE: FAT-EXPIE-STUCK-IN-LIFEPOD")
	var/mob/user = ui.user





