//    such a good boye,.,,., <═══════════════════════════╗      ╔═════════════════════════════════╗
//                                                       ╚══════╝                                 ║
// ╔══════════════════════════════════════════════════════════════════════════════════════════╗   ║
// ║ Preference for a specific saymode, like say, ask, emote, etc - SAYMODE LEVEL PREFERENCES ║   ║
// ║ Holds all the styling and settings for that saymode          ╔═══════════════════════════╝   ╚═══════════╗
// ╚══════════════════════════════════════════════════════════════╝                                        ╔══╝
/datum/vc_saymode    //                               ╔═══╗                ╔═══════════════════════════════╝
	var/datum/vc_preference_holder/parent_holder //     ║   ╚═════════╗      ║
	var/saymode = SAYMODE_SAY // Braixen Brai!          ║             ║      ║
	// Hey did u know that im ══════════════════════════╝             ╚══════╝
	var/list/settings = list() // format: "[setting]" = /datum/vc_setting
	var/list/defaults = list()
	var/durty_saymode = FALSE
	/// if true, dont use this saymode in VC
	var/suppress = FALSE
	var/custom = FALSE
	/// invoke token
	var/invoken

/datum/vc_saymode/New(parent_holder, saymode)
	parent_holder = parent_holder
	if(saymode)
		src.saymode = saymode
	build_settings()

/datum/vc_saymode/Destroy(force)
	parent_holder = null
	QDEL_LIST_ASSOC_VAL(settings)
	. = ..()

/datum/vc_saymode/proc/build_settings(kill_em_all)
	if(LAZYLEN(settings))
		if(kill_em_all)
			QDEL_LIST_ASSOC_VAL(settings)
		else
			return
	for(var/datum/vc_setting/setting as anything in subtypesof(/datum/vc_setting))
		settings[setting::st_key] = new setting(src)
		if(defaults[setting.st_key])
			update_saymode_setting(setting.st_key, defaults[setting.st_key], FALSE) // we do things by the (laggy) book

/datum/vc_saymode/proc/set_durty_saymode()
	if(durty_saymode)
		return
	durty_saymode = TRUE
	parent_holder?.set_durty_character(durty_saymode)

/datum/vc_saymode/proc/am_durty_saymode()
	return durty_saymode

/datum/vc_saymode/proc/save_saymode_prefs(pafth, super_durty)
	if(!durty_saymode)
		if(!super_durty)
			return FALSE
	var/filename = "[pafth]/"
	if(is_custom_saymode())
		filename += "saymodecustom___[saymode].json"
	else
		filename += "saymode___[saymode].json"
	var/list/seri = serialize_saymode(FALSE)
	var/datacontent = json_encode(seri, JSON_PRETTY_PRINT)
	rustg_file_write(datacontent, filename)
	if(SSvisualchat.debug_saving)
		SSvisualchat.ReloadAndCompare(filename, datacontent, "Saymode Prefs")
	return TRUE

/datum/vc_saymode/proc/load_saymode_prefs(pafth) // pafth includes the saymode file name
	// first, wipe everything nice and cleanlike
	build_settings(TRUE)
	var/datacontent = rustg_file_read(pafth)
	if(datacontent)
		var/list/seri = json_decode(datacontent)
		deserialize_saymode(seri)

/datum/vc_saymode/proc/update_saymode_setting(key, new_value, durtify = TRUE)
	if(!settings[key])
		return
	get_setting(key).update_terminal_setting(new_value)
	if(durtify)
		set_durty_saymode()

/datum/vc_saymode/proc/deserialize_saymode(list/settings2load)
	custom = settings2load["custom"]
	invoken = settings2load["invoke_token"]
	if(custom && invoken)
		saymode = settings2load["saymode"]
	for(var/key in settings2load["settings"])
		if(settings[key])
			update_saymode_setting(key, settings2load["settings"][key], FALSE)

/datum/vc_saymode/proc/serialize_saymode(for_tgui)
	var/list/serialized = list()
	serialized["saymode"] = saymode
	serialized["custom"] = custom
	serialized["invoke_token"] = invoken
	serialized["settings"] = list()
	for(var/key in settings)
		serialized["settings"][key] = get_setting(key).serialize_setting(for_tgui)
	if(for_tgui)
		var/datum/vc_setting/preview_text_setting = get_setting("preview_text")
		if(preview_text_setting.is_empty_or_default())
			var/newtext = SSvisualchat.GetPreviewTextForSaymode(src)
			serialized["settings"]["preview_text"] = newtext
			get_setting("preview_text").update_terminal_setting(newtext)
	return serialized

/datum/vc_saymode/proc/is_custom_saymode()
	return custom && invoken

/datum/vc_saymode/proc/get_setting(key) as /datum/vc_setting
	return settings[key]

// default saymode daymodes
/datum/vc_saymode/default
	var/order = 0
/datum/vc_saymode/default/say
	saymode = SAYMODE_SAY
	order = 1
/datum/vc_saymode/default/ask
	saymode = SAYMODE_ASK
	order = 2
/datum/vc_saymode/default/whisper
	saymode = SAYMODE_WHISPER
	order = 3
/datum/vc_saymode/default/exclaim
	saymode = SAYMODE_EXCLAIM
	order = 4
/datum/vc_saymode/default/yell
	saymode = SAYMODE_YELL
	order = 5
/datum/vc_saymode/default/sing
	saymode = SAYMODE_SING
	order = 6
/datum/vc_saymode/default/emote
	saymode = SAYMODE_EMOTE
	order = 7
	defaults = list(
		"name_show" = FALSE,
	)
/datum/vc_saymode/default/emote_quick
	saymode = SAYMODE_EMOTE_QUICK
	order = 8
	defaults = list(
		"pfp_show" = FALSE,
		"name_show" = FALSE,
		"message_show" = FALSE,
	)
/datum/vc_saymode/default/radio
	saymode = SAYMODE_RADIO
	order = 9
	defaults = list(
		"pfp_show" = FALSE,
		"message_show" = FALSE,
	)

/datum/vc_saymode/custom



