/datum/preference/rumors // oh yeah it does nothing, have fun!
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "rumors"
	abstract_type = /datum/preference/rumors

/datum/preference/rumors/the_actual_rumors
	savefile_key = "the_actual_rumors"

/// PREFS FORMAT: list("uid" = list("txt" = "rumor text", "horny" = "yes"/"no"), ...)
/datum/preference/rumors/deserialize(input, datum/prefs_holder/preferences)
	return input

/datum/preference/rumors/proc/sanitize_rumors(input)
	// if(!islist(input))
	// 	return list()
	// if(!LAZYLEN(input))
	// 	return input // fair
	// var/list/sanitized = list()
	// for(var/rumor_uid in input)
	// 	var/list/rumordat = input["[rumor_uid]"]
	// 	if(!islist(rumordat))
	// 		continue
	// 	var/rumor_text = rumordat["txt"]
	// 	var/rumor_horny = rumordat["horny"]
	// 	if(!istext(rumor_text) || !istext(rumor_horny))
	// 		continue
	// 	sanitized["[rumor_uid]"] = list("txt" = "[rumor_text]", "horny" = "[rumor_horny]")
	return input

// purely a prefs thingy
/datum/preference/rumors/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/preferences)
	return TRUE

/datum/preference/rumors/is_accessible(datum/prefs_holder/preferences)
	return ..(preferences, TRUE)

/datum/preference/rumors/is_valid(value, datum/prefs_holder/preferences)
	// if(islist(value))
	// 	var/list/valist = value
	// 	for(var/rumor_uid in valist)
	// 		var/list/rumordat = valist["[rumor_uid]"]
	// 		if(!islist(rumordat))
	// 			return FALSE
	return TRUE

/datum/preference/rumors/create_default_value()
	return list()
