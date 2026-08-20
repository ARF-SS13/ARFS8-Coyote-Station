GLOBAL_DATUM_INIT(character_directory, /datum/character_directory, new)
#define READ_PREFS(target, pref) (target.client.prefs.read_preference(/datum/preference/pref) || "Unset")

// ╔═══╦════════════════════════════════╦═══╗
// ║♥♥♥║ CHARACTER DIRECTORY CODE START ║☺☻☺║
// ╚═══╩════════════════════════════════╩═══╝

// This is a global singleton. Keep in mind that all operations should occur on user, not src.
/datum/character_directory
	var/window_name = "Plenty Of Crew Social App v1.0.3"
	var/short_name = "Dating Profile"

/datum/character_directory/proc/get_dating_app_name()
	return window_name

/datum/character_directory/proc/get_dating_app_name_short()
	return short_name

/datum/character_directory/ui_state(mob/user)
	return GLOB.always_state

/datum/character_directory/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ZubbersCharacterDirectory", window_name)
		ui.open()

//We want this information to update any time the player updates their preferences, not just when the panel is refreshed
/datum/character_directory/ui_data(mob/user)
	. = ..()
	var/list/data = .

	//Collect the user's own preferences for the top of the UI
	if (user?.client?.prefs)
		data["personalVisibility"] =  READ_PREFS(user, toggle/show_in_directory)
		data["personalSeeking"] =     READ_PREFS(user, choiced/seeking)
		data["personalGender"] =      READ_PREFS(user, choiced/display_gender)
		// data["personalErpTag"] =      READ_PREFS(user, choiced/erp_status)
		// data["personalVoreTag"] =     READ_PREFS(user, choiced/erp_status_v)
		// data["personalHypnoTag"] =    READ_PREFS(user, choiced/erp_status_hypno)
		// data["personalNonconTag"] =   READ_PREFS(user, choiced/erp_status_nc)
		data["prefsOnly"] = TRUE

	data["canOrbit"] = isobserver(user)

	return data

/datum/character_directory/ui_static_data(mob/user)
	. = ..()
	var/list/data = .

	var/list/directory_mobs = list()
	//We want the directory to display only alive players, not observers or people in the lobby
	for(var/mob/mob in GLOB.alive_player_list)
		// These are the variables we're trying to display in the directory
		var/name              = ""
		var/species           = "Ask"
		var/ooc_notes         = ""
		var/flavor_text       = ""
		var/nsfw_flavor_text  = ""
		var/attraction        = "Unset"
		var/gender            = "Nonbinary"
		var/erp               = "Ask"
		var/vore              = "Ask"
		var/hypno             = "Ask"
		var/noncon            = "Ask"
		// SPLURT EDIT START: INTERACTION PANEL
		var/extreme           = "Ask"
		var/extremeharm       = "Ask"
		var/unholy            = "Ask"
		// SPLURT EDIT END: INTERACTION PANEL
		var/character_ad      = ""
		var/ref               = REF(mob)
		//Just in case something we get is not a mob
		if(!mob)
			continue

		//Different approach for humans and silicons
		if(ishuman(mob))
			var/mob/living/carbon/human/human = mob
			//If someone is obscured without flavor text visible, we don't want them on the Directory.
			if(((human.covered_slots & HIDEFACE) && READ_PREFS(human, toggle/obscurity_examine)) || (HAS_TRAIT(human, TRAIT_UNKNOWN_APPEARANCE)))
				continue
			//Display custom species, otherwise show base species instead
			species = (READ_PREFS(human, text/custom_species))
			if(species == "Unset")
				species = "[human.dna.species.name]"
			//Load standard flavor text preference
			flavor_text = READ_PREFS(human, text/flavor_text)
			if((READ_PREFS(human, choiced/show_nsfw_flavor_text) == "Always On") || ((READ_PREFS(human, choiced/show_nsfw_flavor_text) == "Nude Only") && !(human.w_uniform)))
				nsfw_flavor_text = READ_PREFS(human, text/flavor_text_nsfw)
			else nsfw_flavor_text = "Unavailable"

		else if(issilicon(mob))
			var/mob/living/silicon/silicon = mob
			//If the target is a silicon, we want it to show its brain as its species
			species = READ_PREFS(silicon, choiced/brain_type)
			//Load silicon flavor text in place of normal flavor text
			flavor_text = READ_PREFS(silicon, text/silicon_flavor_text)
			if(READ_PREFS(silicon, choiced/show_nsfw_flavor_text) != "Never")
				nsfw_flavor_text = READ_PREFS(silicon, text/flavor_text_nsfw/silicon)
			else nsfw_flavor_text = "Unavailable"
		//Don't show if they are not a human or a silicon
		else continue
		//List of all the shown ERP preferences in the Directory. If there is none, return "Unset"
		attraction    = READ_PREFS(mob, choiced/seeking)
		gender        = READ_PREFS(mob, choiced/display_gender)
		character_ad  = READ_PREFS(mob, text/character_ad)
		ooc_notes     = READ_PREFS(mob, text/ooc_notes)
		// SPLURT EDIT START: INTERACTION PANEL
		extreme       = READ_PREFS(mob, choiced/erp_status_extm)
		// SPLURT EDIT END: INTERACTION PANEL
		name          = mob.real_name ? mob.name : mob.real_name

		directory_mobs.Add(list(list(
			"name"              = name,
			"species"           = species,
			"ooc_notes"         = ooc_notes,
			"datingapp_seeking" = attraction,
			"gender"            = gender,
			"erp"               = erp,
			"vore"              = vore,
			"hypno"             = hypno,
			"noncon"            = noncon,
			// SPLURT EDIT START: INTERACTION PANEL
			"extreme"           = extreme,
			"extremeharm"       = extremeharm,
			"unholy"            = unholy,
			// SPLURT EDIT END: INTERACTION PANEL
			"character_ad"      = character_ad,
			"flavor_text"       = flavor_text,
			"nsfw_flavor_text"  = nsfw_flavor_text,
			"ref"               = ref
		)))

	data["directory"] = directory_mobs

	return data

/datum/character_directory/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	var/mob/user = usr
	if(!user)
		return

	switch(action)
		if("refresh")
			// This is primarily to stop malicious users from trying to lag the server by spamming this verb
			if(!COOLDOWN_FINISHED(user.client, char_directory_cooldown))
				to_chat(user, "<span class='warning'>Hold your Horses! Its still refreshing! ♥</span>")
				return
			COOLDOWN_START(user.client, char_directory_cooldown, 10)
			update_static_data(user, ui)
			return TRUE
		if("orbit")
			var/ref = params["ref"]
			var/mob/dead/observer/ghost = user
			var/atom/movable/poi = (locate(ref) in GLOB.mob_list)
			if (poi == null)
				return TRUE
			ghost.ManualFollow(poi)
			ghost.reset_perspective(null)
			return TRUE
		if("view")
			var/ref = params["ref"]
			var/datum/examine_panel/panel
			var/mob/living/carbon/target = (locate(ref) in GLOB.mob_list)
			if(issilicon(target))
				var/mob/living/silicon/robot/typed_target = target
				panel = typed_target.examine_panel
				panel.holder = typed_target
			else
				var/mob/living/carbon/human/typed_target = target
				panel = typed_target.tgui
				panel.holder = typed_target
			panel.ui_interact(user)

#undef READ_PREFS
