
// ╔════════════════════════════════════════════════════════════════════════════════════════════╗
// ║ Preference Cluster for a specific character's VC preferences - CHARACTER LEVEL PREFERENCES ║
// ║ Holds all the saymode prefs for that one character           ╔═════════════════════════════╝
// ╚══════════════════════════════════════════════════════════════╝
/datum/vc_preference_holder // i just didnt want to mess with a bunch of wacky lists
	var/datum/vc_account_prefs_manager/parent_manager
	var/slot = "0"
	var/kind = "human"
	/// format: "[saymode]" = /datum/vc_saymode
	var/list/saymode_prefs = list()
	/// if true, dont use any of this character's saymodes in VC
	var/suppress_characterwide = FALSE
	var/durty_character = FALSE

/datum/vc_preference_holder/New(parent)
	parent_manager = parent
	setup_default_saymode_prefs()

/datum/vc_preference_holder/Destroy()
	parent_manager = null
	QDEL_LIST_ASSOC_VAL(saymode_prefs)
	. = ..()

/datum/vc_preference_holder/proc/setup_default_saymode_prefs()
	for(var/datum/vc_saymode/smode as anything in subtypesof(/datum/vc_saymode/default))
		saymode_prefs[smode::saymode] = new smode(src)

/datum/vc_preference_holder/proc/prefholder_get_saymode(saymode_key)
	var/datum/vc_saymode/saymode = saymode_prefs[saymode_key]
	if(!saymode)
		saymode = saymode_prefs[SAYMODE_SAY] // default to say if its not found
		if(!saymode)
			saymode = new /datum/vc_saymode/default/say(src, SAYMODE_SAY)
			saymode_prefs[SAYMODE_SAY] = saymode
	return saymode

/datum/vc_preference_holder/proc/save_character_prefs(super_durty)
	// we have been judged durty at this point, but what of the saymodes?
	var/pafth = "[SSvisualchat.GetSavesFolder()]/[parent_manager.owner_ckey]/slot_[slot]/[kind]"
	for(var/smode in saymode_prefs)
		var/datum/vc_saymode/saymode = saymode_prefs[smode]
		saymode.save_saymode_prefs(pafth, super_durty)
	var/list/char_prefs = list(
		"slot" = slot,
		"kind" = kind,
		"suppress_characterwide" = suppress_characterwide,
		"last_updated" = world.realtime,
	)
	var/datacontent = json_encode(char_prefs, JSON_PRETTY_PRINT)
	var/filename = "[pafth]/character_prefs.json"
	rustg_file_write(datacontent, filename)
	if(SSvisualchat.debug_saving)
		SSvisualchat.ReloadAndCompare(filename, datacontent, "Character Prefs")
	return TRUE

/datum/vc_preference_holder/proc/load_character_prefs()
	var/pafth = "[SSvisualchat.GetSavesFolder()]/[parent_manager.owner_ckey]/slot_[slot]/[kind]/"
	var/filename = "[pafth]character_prefs.json"
	var/datacontent = rustg_file_read(filename)
	if(datacontent)
		var/list/slot_prefs = json_decode(datacontent)
		suppress_characterwide = slot_prefs["suppress_characterwide"]
	// now the files!
	var/list/saymode_files = flist(pafth)
	for(var/sayfilename in saymode_files)
		if(sayfilename == "character_prefs.json")
			continue
		var/list/split = splittext(sayfilename, "___")
		if(LAZYLEN(split) != 2)
			stack_trace("Invalid saymode file name: [sayfilename]")
		var/saymode_text = replacetext(split[1], ".json", "")
		var/datum/vc_saymode/saymode = saymode_prefs[saymode_text]
		if(!saymode) // probably a custom! make one!
			saymode = new /datum/vc_saymode/custom(src, saymode_text)
			saymode_prefs[saymode_text] = saymode
		var/truepath = "[pafth]/[sayfilename]"
		saymode.load_saymode_prefs(truepath)

/datum/vc_preference_holder/proc/set_durty_character()
	durty_character = TRUE
	parent_manager?.set_durty_account()

/datum/vc_preference_holder/proc/am_durty_character() // im such a durty character uwu~
	if(durty_character)
		return TRUE
	for(var/smod in saymode_prefs)
		var/datum/vc_saymode/saymode = saymode_prefs[smod]
		if(saymode?.am_durty_saymode())
			return TRUE
	return FALSE
