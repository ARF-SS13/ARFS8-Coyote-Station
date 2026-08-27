/datum/preference/character_slot_uid // oh yeah it does nothing, have fun!
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "character_slot_uid"

/datum/preference/character_slot_uid/deserialize(input, datum/prefs_holder/preferences)
	return input

// purely a prefs thingy
/datum/preference/character_slot_uid/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/preferences)
	return TRUE

/datum/preference/character_slot_uid/is_accessible(datum/prefs_holder/preferences)
	return TRUE

/datum/preference/character_slot_uid/is_valid(value, datum/prefs_holder/preferences)
	return TRUE

/datum/preference/character_slot_uid/create_default_value()
	return GeneratePrefsUniqueID()

// "Giggleton-Abernathy-Angerman-the-Delightful-Cute-Happily-Running-Beautiful-Carp-Shark-12345"
/proc/GeneratePrefsUniqueID()
	var/uid = "UID"
	var/clown = pick(GLOB.clown_names)
	var/wiz1 = pick(GLOB.wizard_first)
	var/wiz2 = pick(GLOB.wizard_second)
	var/adj1 = pick(GLOB.adjectives)
	var/adj2 = pick(GLOB.adjectives)
	var/adj3 = pick(GLOB.adjectives)
	var/adv = pick(GLOB.adverbs)
	var/ingverb = pick(GLOB.ing_verbs)
	var/carpshark1 = pick(GLOB.carp_names + GLOB.megacarp_first_names)
	var/carpshark2 = pick(GLOB.megacarp_last_names)
	var/num = rand(10000, 99999)
	uid += "-[clown]-[wiz1]-[wiz2]-the-[adj1]-[adj2]-[adv]-[ingverb]-[adj3]-[carpshark1]-[carpshark2]-[num]"
	uid = replace(uid, " ", "-")
	uid = replace(uid, "'", "")
	uid = replace(uid, "\"", "")
	return uid


