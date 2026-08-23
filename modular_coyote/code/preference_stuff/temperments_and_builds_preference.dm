/datum/preference/temperaments_and_builds
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "temperaments_and_builds"

/// PREFS FORMAT: list("temperaments" = list("/datum/character_snippet"), "builds" = list("/datum/character_snippet"))
/datum/preference/temperaments_and_builds/deserialize(input, datum/prefs_holder/preferences)
	// input is format list("/datum/character_snippet", "/datum/character_snippet", ...)
	return sanitize_tnb(input)

/// format: list("temperaments" = list("/datum/character_snippet"), "builds" = list("/datum/character_snippet"))
/datum/preference/temperaments_and_builds/proc/sanitize_tnb(input)
	var/list/splut = input
	if(!LAZYLEN(splut) || !islist(splut))
		return list(CSNIP_TEMPERAMENT = list(), CSNIP_BUILD = list())
	splut |= list(CSNIP_TEMPERAMENT = list(), CSNIP_BUILD = list())
	var/list/sanitized = list()
	for(var/tnb_cat in splut)
		for(var/tnb_string_path in splut[tnb_cat])
			if(GLOB.all_temperaments_and_builds_datums["[tnb_string_path]"])
				var/datum/character_snippet/tb = GLOB.all_temperaments_and_builds_datums["[tnb_string_path]"]
				LAZYADD(sanitized["[tb.category_csnip]"], "[tnb_string_path]")
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
	if(islist(value))
		var/list/valist = value
		for(var/tnb_cat in valist)
			for(var/tnb in valist[tnb_cat])
				if(!GLOB.all_temperaments_and_builds_datums["[tnb]"])
					return FALSE
	return TRUE

/datum/preference/temperaments_and_builds/create_default_value()
	return list(CSNIP_TEMPERAMENT = list(), CSNIP_BUILD = list())

// im the giant pref that does all of the tnb
