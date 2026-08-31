/// Species preference
/datum/preference/choiced/species
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "species"
	priority = PREFERENCE_PRIORITY_SPECIES
	randomize_by_default = FALSE

/datum/preference/choiced/species/deserialize(input, datum/prefs_holder/preferences)
	return GLOB.species_list[sanitize_inlist(input, get_choices_serialized(), SPECIES_VULP)]

/datum/preference/choiced/species/serialize(input)
	var/datum/species/species = input
	return initial(species.id)

/datum/preference/choiced/species/create_default_value()
	return /datum/species/vulpkanin // furry server, furry default

/datum/preference/choiced/species/create_random_value(datum/prefs_holder/preferences)
	return /datum/species/vulpkanin

/datum/preference/choiced/species/init_possible_values()
	var/list/values = list()

	for (var/species_id in get_selectable_species())
		values += GLOB.species_list[species_id]

	//SKYRAT EDIT ADDITION
	for (var/species_id in get_customizable_races())
		values += GLOB.species_list[species_id]
	//SKYRAT EDIT END

	return values

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value, datum/prefs_holder/prefs)
	target.set_species(value, icon_update = FALSE, pref_load = FALSE, override_features = prefs?.features.Copy(), override_mutantparts = prefs?.mutant_bodyparts.Copy(), override_markings = prefs?.body_markings.Copy()) // SKYRAT EDIT - Customization

	//SKYRAT EDIT ADDITION
	target.dna.update_body_size()

	for(var/organ_key in list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_PENIS, ORGAN_SLOT_BREASTS, ORGAN_SLOT_ANUS))
		var/obj/item/organ/genital/gent = target.get_organ_slot(organ_key)
		if(gent)
			gent.aroused = prefs.arousal_preview
			gent.update_sprite_suffix()
	//SKYRAT EDIT END
