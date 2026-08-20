// ╔═══╦════════════════════════════════╦═══╗
// ║♥♥♥║CHARACTER DIRECTORY PREFERENCES ║☺☻☺║
// ╚═══╩════════════════════════════════╩═══╝


//We want players to be able to decide whether they show up in the directory or not
/datum/preference/toggle/show_in_directory
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "show_in_directory"
	savefile_identifier = PREFERENCE_PLAYER

//The advertisement that you show to people looking through the directory
/datum/preference/text/character_ad
	savefile_key = "character_ad"
	category = PREFERENCE_CATEGORY_OOC_PREFS
	savefile_identifier = PREFERENCE_CHARACTER
	maximum_value_length = MAX_FLAVOR_LEN

//TGUI gets angry if you don't define a default on text preferences
/datum/preference/text/character_ad/create_default_value()
	return ""

//Any text preference needs this for some reason
/datum/preference/text/character_ad/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

// ╔═══╦══════════╦═══╗
// ║♥♥♥║ SEEKING! ║♥♥♥║
// ╠═══╬══════════╩═══╩═══════════════════════════════════════╦═══╗
// ║☺☻☺║ I am a (something else) looking for [a one of these] ║☺☻☺║
// ╚═══╩══════════════════════════════════════════════════════╩═══╝
/datum/preference/choiced/seeking
	savefile_key = "datingapp_seeking"
	category = PREFERENCE_CATEGORY_OOC_PREFS
	savefile_identifier = PREFERENCE_CHARACTER
	var/list/boo = list(
		"Something, not sure",
		"A fling",
		"Something short term",
		"Something short term, open to long",
		"Something long term",
		"Something long term, open to short",
		"A friend",
	)

/datum/preference/choiced/seeking/init_possible_values()
	// return list("Gay", "Lesbian", "Straight", "Skolio", "Bi", "Pan", "Poly", "Omni", "Ace", "Aro", "Aro/Ace", "Unset", "Check OOC")
	return boo.Copy()

/datum/preference/choiced/seeking/create_default_value()
	return LAZYACCESS(boo, 1)

/datum/preference/choiced/seeking/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

// ╔═══╦═════════╦═══╗
// ║♥♥♥║ Gender! ║♥♥♥║
// ╠═══╬═════════╩═══╩═══════════════════════════════╦═══╗
// ║☺☻☺║ I am a [this] looking for [a saucey puppet] ║☺☻☺║
// ╚═══╩═════════════════════════════════════════════╩═══╝
/datum/preference/choiced/display_gender
	savefile_key = "display_gender"
	category = PREFERENCE_CATEGORY_OOC_PREFS
	savefile_identifier = PREFERENCE_CHARACTER
	var/list/genderz = list(
		"Unset",
		"Male",
		"Female",
		"Null",
		"Plural",
		"Nonbinary",
		"Omni",
		"Trans",
		"Transmasc",
		"Transfem",
		"Andro",
		"Gyno",
		"Fluid",
	)

/datum/preference/choiced/display_gender/init_possible_values()
	return genderz.Copy()

/datum/preference/choiced/display_gender/create_default_value()
	return LAZYACCESS(genderz, 1)

/datum/preference/choiced/display_gender/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE
//Can't believe Bubberstation invented attraction and gender in the year December 2023


// ╔═══╦═══════════════╦═══╗
// ║♥♥♥║ Receptive to! ║♥♥♥║
// ╠═══╬═══════════════╩═══╩══════════════════════════╦═══╗
// ║☺☻☺║ If you want to get my attention, try thiese! ║☺☻☺║
// ║☺☻☺║ todo: add support for multiple choices!      ║☺☻☺║
// ╚═══╩══════════════════════════════════════════════╩═══╝
/datum/preference/choiced/dating_receptive_to
	savefile_key = "display_receptive_to"
	category = PREFERENCE_CATEGORY_OOC_PREFS
	savefile_identifier = PREFERENCE_CHARACTER
	var/list/receptive_toes = list(
		"Anything",
		"Subtle approaches",
		"Forward approaches",
		"Gifts!",
		"Compliments!",
		"Small talk",
	)

/datum/preference/choiced/dating_receptive_to/init_possible_values()
	return receptive_toes.Copy()

/datum/preference/choiced/dating_receptive_to/create_default_value()
	return LAZYACCESS(receptive_toes, 1)

/datum/preference/choiced/dating_receptive_to/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE
//Can't believe Bubberstation invented attraction and gender in the year December 2023

/// Pref for all the things with the same "Yes", "No", "No ERP", "Check OOC", "Unset", "Maybe" setting
/// Saves us on copypaste code
/datum/preference/choiced/directory_character_prefs
	savefile_key = "char_directory_char_prefs" // This is so unit checks don't scream
	abstract_type = /datum/preference/choiced/directory_character_prefs

/datum/preference/choiced/directory_character_prefs/init_possible_values()
	return list("Yes", "No", "No ERP", "Check OOC", "Unset", "Maybe")

/datum/preference/choiced/directory_character_prefs/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/directory_character_prefs/create_default_value()
	return "Unset"

/datum/preference/choiced/directory_character_prefs/furry_pref
	savefile_key = "furry_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/directory_character_prefs/scalie_pref
	savefile_key = "scalie_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/directory_character_prefs/other_pref
	savefile_key = "other_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/directory_character_prefs/demihuman_pref
	savefile_key = "demihuman_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/directory_character_prefs/human_pref
	savefile_key = "human_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER
