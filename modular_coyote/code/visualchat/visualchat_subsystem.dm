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
	var/debug_saving = FALSE
	var/debug_pfp = FALSE
	var/debug_mommy = FALSE
	var/debug_seed_offsetter = "urcute"
	var/debug_seed_auto = FALSE
	var/datum/vc_settings_ui_chungus/setzup
	// most recent at the bottom, oldest at the top. for updates or something
	var/list/versions = list(
		"v0.1b - Initial release",
	)
	// accepted hosts
	var/list/valid_hosts = list(
		"catbox.moe" = "https://files.catbox.moe",
		// "gyazo.com" = "https://i.gyazo.com", // gyazo ded
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
	var/list/current_previews = list()

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

/*
 * Some insight into what the message datas are the point of them and what they a
 * Current system need the folloring:
 * * the local atom that's making the message.
 * * * though if this is the radio... idfk
 * * the client that's responsible for making the message, for purposes of getting the damn stuff
 * * the compiled message words and such. used to be like pieced out but thats for later DLC
 * * The saymode, for purpose of determining which image and or style to use
 * *
 * */

/datum/controller/subsystem/visualchat/proc/Hornify(mob/reader, list/message_data)
	if(!reader || !reader.client || !LAZYLEN(message_data))
		return
	var/datum/vc_account_prefs_manager/reader_manager = GetVCAccountPrefsManager(reader, FALSE, TRUE)
	if(!reader_manager.see_visualchat)
		return
	var/atom/spanker = message_data[SATA_SPEAKER]
	if(get_dist(get_turf(reader), get_turf(spanker)) > reader_manager.see_visualchat_range)
		return
	// note: speaker and source arent necessarily the same thing!
	/// speaker's key, gotta go looking
	var/atom/vc_source_atom
	var/char_slot = 1
	var/char_key
	var/datum/vc_account_prefs_manager/speaker_manager
	var/list/possible_sources = list(
		message_data[SATA_VC_SOURCE_OVERRIDE],
		message_data[SATA_VC_SOURCE],
		message_data[SATA_SPEAKER]
	)
	for(var/atom/source_atom in possible_sources)
		if(source_atom.vc_override_key)
			vc_source_atom = source_atom
			speaker_manager = GetVCAccountPrefsManager(source_atom, FALSE, TRUE)
			break
		char_key = extract_ckey(source_atom)
		if(!char_key)
			continue
		speaker_manager = GetVCAccountPrefsManager(char_key, FALSE, TRUE)
		char_slot = extract_current_character_slot(source_atom)
		vc_source_atom = source_atom
		break
	if(!speaker_manager)
		return
	if(speaker_manager.suppress_accountwide)
		return
	if(!message_data[SATA_MESSAGE_HEARD] && !message_data[SATA_MESSAGE_COMPILED])
		return // say what, now?
	// got it! extract the proper saymode
	var/say_mode = ExtractSaymode(message_data)
	var/datum/vc_preference_holder/phol = speaker_manager.get_prefs_holder_for_slot(char_slot)
	if(!phol)
		return
	var/datum/vc_saymode/saymode = speaker_manager.manager_get_saymode(vc_source_atom, char_slot, say_mode, bounce_if_default=TRUE)
	if(!saymode) // null if something is suppressed
		return
	// var/merge_into_oncoming_traffic = ShouldMergeIntoOncoming(saymode, speaker_manager)
	var/list/datapaquette = list()
	datapaquette["saymode_data"] = saymode.serialize_saymode(FALSE) // smaller data means less plastic
	var/list/msg_dat = list()
	if(!Sanify(message_data, spanker))
		return
	// hide if speaker ckey is listener ckey
	if(debug_mommy)
		to_chat(world, "namedisplayed: [message_data[SATA_DISPLAYED_NAME]]")
		to_chat(world, "displayedsaymode: [message_data[SATA_DISPLAYED_SAYMODE]]")
		to_chat(world, "body: [message_data[SATA_MESSAGE_HEARD]]")
		to_chat(world, "compiled: [message_data[SATA_MESSAGE_COMPILED]]")
	var/hide_pfp = FALSE
	if(extract_ckey(reader) == extract_ckey(vc_source_atom))
		if(!speaker_manager.show_own_pfp)
			hide_pfp = TRUE
	msg_dat["name_displayed"]          = message_data[SATA_DISPLAYED_NAME] || ""
	msg_dat["displayed_saymode"]       = message_data[SATA_DISPLAYED_SAYMODE] || ""
	msg_dat["body_text"]               = message_data[SATA_MESSAGE_HEARD] || ""
	msg_dat["compiled_message"]        = message_data[SATA_MESSAGE_COMPILED] || ""
	msg_dat["am_ghost"]                = message_data[SATA_HEARER_IS_GHOST] || FALSE
	msg_dat["ghost_link"]              = message_data[SATA_LINK] || ""
	msg_dat["clipboard"]               = speaker_manager.get_clipboard()
	msg_dat["hide_pfp"]                = hide_pfp
	// msg_dat["merge_name_too"]          = merge_into_oncoming_traffic // so tempting at this point
	msg_dat["msg_splice_timeout"]      = speaker_manager.saymode_cooldown || 0
	msg_dat["msg_splice_last_saymode"] = speaker_manager.last_saymode || ""
	msg_dat["differentiator"]          = phol.differentiator
	if(debug_seed_auto)
		debug_seed_offsetter = ""
		for(var/i in 1 to 10)
			debug_seed_offsetter += pick(GLOB.alphabet_upper)
		phol.set_differentiator_value()
	datapaquette["message_data"] = msg_dat
	speaker_manager.last_saymode = saymode.saymode
	// and send
	return datapaquette

/// set a flag that lets the renderer attempt to include the compiled name when merging VC messages
/// what counts as applicable? Well!
/// If the saymodes
// /datum/controller/subsystem/visualchat/proc/ShouldMergeIntoOncoming(datum/vc_saymode/saymode, datum/speaker_manager)


/datum/controller/subsystem/visualchat/proc/Sanify(list/message_data, atom/spanker)
	if(!message_data)
		return
	if(!spanker)
		return
	// we need some things to always be present: a name, a displayed saymode, body text, compiled message
	if(!message_data[SATA_DISPLAYED_NAME])
		message_data[SATA_DISPLAYED_NAME] = spanker.name
	if(!message_data[SATA_DISPLAYED_SAYMODE])
		message_data[SATA_DISPLAYED_SAYMODE] = "says,"
	if(message_data[SATA_MESSAGE_HEARD] && !message_data[SATA_MESSAGE_COMPILED])
		message_data[SATA_MESSAGE_COMPILED] = message_data[SATA_MESSAGE_HEARD]
	if(message_data[SATA_MESSAGE_COMPILED] && !message_data[SATA_MESSAGE_HEARD])
		message_data[SATA_MESSAGE_HEARD] = message_data[SATA_MESSAGE_COMPILED]
	message_data[SATA_HEARER_IS_GHOST] = message_data[SATA_HEARER_IS_GHOST] || FALSE
	message_data[SATA_LINK]            = message_data[SATA_LINK] || ""
	return TRUE

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
	return message_data[SATA_SAYMODE] || SAYMODE_SAY

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
	host = valid_hosts[host] // you know what they say, all hosts host host
	if(!host)
		return ""
	// ok, host is fine, what about the filename?
	var/list/splitty = splittext(filename, ".")
	if(LAZYLEN(splitty) != 2)
		return ""
	if(!(splitty[2] in valid_extensions))
		return ""
	return host + "/" + filename // tgui will figure out if this link actually goes somewhere........ maybe

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
	if(!current_previews[smode])
		if(LAZYLEN(preview_texts[smode]))
			current_previews[smode] = pick(preview_texts[smode])
		else
			current_previews[smode] = pick(preview_texts[SAYMODE_SAY])
	return current_previews[smode]

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
	dat["show_own_pfp"] = manager.show_own_pfp
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
		if(holdiers_flavor_crystal.kind == "human")
			maybename = P.read_preference(/datum/preference/name/real_name) || user.name
		else
			maybename = P.read_preference(/datum/preference/name/cyborg) || user.name
	dat["user_name"] = maybename
	dat["user_ckey"] = user.ckey
	return dat

/datum/controller/subsystem/visualchat/proc/OpenSettingsControlPanel(mob/user)
	if(!user || !user.client)
		return
	setzup.open_settings_controlpanel(user)

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
	var/saymode_kind = params["saymode"]
	var/human = params["h_or_s"]
	var/slut = extract_current_character_slot(user, FALSE)
	var/datum/vc_account_prefs_manager/mgr = GetVCAccountPrefsManager(user, FALSE, TRUE)
	var/datum/vc_preference_holder/pholder = mgr.get_prefs_holder_for_slot(slut, human)
	var/datum/vc_saymode/smode = pholder.prefholder_get_saymode(saymode_kind, FALSE)
	switch(action)
		if("set_host")
			smode.update_saymode_setting("pfp_image_link_url_host", params["host"], TRUE)
			. = TRUE
		if("set_link")
			smode.update_saymode_setting("pfp_image_link_url_filename", params["link"], TRUE)
			. = TRUE
		if("copy")
			to_chat(user, span_green("copied [params["link"]] to clipboard! Paste it with ctrl+v!"))
			// mgr.copy_to_clipboard("SAYMODE", saymode_kind, slut, null, null, null)
			. = TRUE
		if("paste")//datakind, saymode, slot, setting, value, setting_kind
			// mgr.paste_from_clipboard("SAYMODE", saymode_kind, slut, null, null, null)
			. = TRUE
		if("set_see_visualchat_range")
			mgr.see_visualchat_range = clamp(params["range"], mgr.see_visualchat_range_min, mgr.see_visualchat_range_max)
			. = TRUE
		if("toggle_vc")
			mgr.see_visualchat = !mgr.see_visualchat
			. = TRUE
		if("toggle_vc_send")
			mgr.suppress_accountwide = !mgr.suppress_accountwide
			. = TRUE
		if("update")
			// to_chat(user, span_notice("Updating Image Settings..."))
			. = TRUE
		if("toggle_show_own_pfp")
			mgr.show_own_pfp = !mgr.show_own_pfp
			. = TRUE
	if(.)
		smode.set_durty_saymode()

// acts:
// change_setting
// copy
// open_host
// paste
// set_host
// set_link
// set_see_visualchat_range
// swatch_apply
// swatch_snatch
// toggle_vc
// toggle_vc_send

// ...identSlug
// ckey: data.user_ckey
// clicked_host: host
// copy_mode: VCCopyMode.Saymode
// copy_mode: VCCopyMode.Setting
// h_or_s: data.human_or_silicon
// h_or_s: human_or_silicon
// host: value
// human_or_silicon: data.human_or_silicon
// link: value
// new_value: newValue
// paste_mode: VCCopyMode.Saymode
// paste_mode: VCCopyMode.Setting
// range: value
// saymode: item.saymode_kind
// setting_key: key
// setting_kind: kind
// setting_oldvalue: value
// setting_path: path
// swatch_color: selectedSwatch
// swatch_index: selectedSwatchIndex













































