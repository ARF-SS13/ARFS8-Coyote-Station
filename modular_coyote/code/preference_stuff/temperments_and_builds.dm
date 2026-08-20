/datum/preference/temperaments_and_builds
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "temperaments_and_builds"

/datum/preference/temperaments_and_builds/deserialize(input, datum/prefs_holder/preferences)
	// input is format list("/datum/temperament_build", "/datum/temperament_build", ...)
	return sanitize_tnb(input)

/datum/preference/temperaments_and_builds/proc/sanitize_tnb(input)
	var/list/splut = input
	if(!LAZYLEN(splut))
		return ""
	var/list/sanitized = list()
	for(var/txpath in splut)
		if(GLOB.all_temperaments_and_builds_datums["[txpath]"])
			sanitized += "[txpath]"
	return sanitized

/datum/preference/temperaments_and_builds/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/preferences)
	if(!preferences)
		value = create_default_value()
		. = FALSE

	target.dna.features["temperaments_and_builds"] = value
	return TRUE

/datum/preference/temperaments_and_builds/is_accessible(datum/prefs_holder/preferences)
	return ..(preferences, TRUE)

/datum/preference/temperaments_and_builds/is_valid(value, datum/prefs_holder/preferences)
	return !!GLOB.all_temperaments_and_builds_datums["[value]" ]

/datum/preference/temperaments_and_builds/create_default_value()
	return list()

// im the giant pref that does all of the tnb
