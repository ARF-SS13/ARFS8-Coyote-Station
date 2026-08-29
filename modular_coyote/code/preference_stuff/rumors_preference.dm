/datum/preference/rumors // oh yeah it does nothing, have fun!
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "the_actual_rumors"


// purely a prefs thingy
/datum/preference/rumors/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/preferences)
	return TRUE

/datum/preference/rumors/is_accessible(datum/prefs_holder/preferences)
	return ..(preferences, TRUE)

/datum/preference/rumors/create_default_value()
	return TRUE

/datum/preference/rumors/deserialize(input, datum/prefs_holder/preferences)
	return TRUE

/datum/preference/rumors/is_valid(value, datum/prefs_holder/preferences)
	return TRUE



/datum/preference/toggle/rumors
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_PLAYER
	savefile_key = "rumors"
	abstract_type = /datum/preference/toggle/rumors

/datum/preference/toggle/rumors/hear_rumors
	savefile_key = "hear_rumors"
/datum/preference/toggle/rumors/hear_horny_rumors
	savefile_key = "hear_horny_rumors"

// purely a prefs thingy
/datum/preference/toggle/rumors/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/preferences)
	return TRUE

/datum/preference/toggle/rumors/is_accessible(datum/prefs_holder/preferences)
	return ..(preferences, TRUE)

/datum/preference/toggle/rumors/create_default_value()
	return list()
