/datum/preference/character_snippets
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "character_snippets"
	abstract_type = /datum/preference/character_snippets

/// PREFS FORMAT: list("temperaments" = list("/datum/character_snippet"), "builds" = list("/datum/character_snippet"))
/datum/preference/character_snippets/deserialize(input, datum/prefs_holder/preferences)
	// input is format list("/datum/character_snippet", "/datum/character_snippet", ...)
	return sanitize_csnip(input)

/// format: list("temperaments" = list("/datum/character_snippet"), "builds" = list("/datum/character_snippet"))
/datum/preference/character_snippets/proc/sanitize_csnip(input)
	if(!SSdans_cool_prefs.initialized)
		return input // we'll... check it later
	var/list/splut = input
	if(!islist(splut))
		splut = list()
	var/list/sanitized = list()
	for(var/csnip_string_path in splut)
		var/datum/character_snippet/csnip_datum = SSdans_cool_prefs.get_snippet_by_string_path(csnip_string_path)
		if(!csnip_datum)
			stack_trace("wtf, no character snippet thing for path [csnip_string_path]!")
			continue
		sanitized += "[csnip_string_path]"
	return sanitized

/datum/preference/character_snippets/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/preferences)
	if(!preferences)
		value = create_default_value()
		. = FALSE

	target.dna.features["[savefile_key]"] = value
	return TRUE

/datum/preference/character_snippets/is_accessible(datum/prefs_holder/preferences)
	return ..(preferences, TRUE)

/datum/preference/character_snippets/is_valid(value, datum/prefs_holder/preferences)
	if(islist(value))
		var/list/valist = value
		for(var/csnip_string_path in valist)
			if(!SSdans_cool_prefs.get_snippet_by_string_path(csnip_string_path))
				return FALSE
	return TRUE

/datum/preference/character_snippets/create_default_value()
	return list()

// thgese get saved :)
/datum/preference/character_snippets/temperaments
	savefile_key = "temperaments"
/datum/preference/character_snippets/builds
	savefile_key = "builds"
/datum/preference/character_snippets/early_backgrounds
	savefile_key = "early_backgrounds"
/datum/preference/character_snippets/adult_backgrounds
	savefile_key = "adult_backgrounds"
/datum/preference/character_snippets/background_extras
	savefile_key = "background_extras"

/datum/preference/character_snippets/background_extras/sanitize_csnip(input)
	if(!SSdans_cool_prefs.initialized)
		return input // we'll... check it later
	var/list/splut = input
	if(!islist(splut))
		splut = list()
	if(LAZYLEN(splut) <= 0)
		return // its fine
	var/list/cleaned = list()
	for(var/key,value in splut)
		if(!key || !value)
			continue
		var/datum/character_snippet/csnip_datum = SSdans_cool_prefs.get_snippet_by_string_path("[key]")
		if(!csnip_datum)
			stack_trace("wtf, no character snippet thing for path [key]!")
			continue
		cleaned["[key]"] = value
	return cleaned
