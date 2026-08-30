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

/datum/preference/choiced/species/compile_constant_data()
	var/list/data = list()
	data["species_list"] = list()
	data["category_map"] = list()

	for (var/species_id in (get_selectable_species() + get_customizable_races())) //SKYRAT EDIT CHANGE
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = GLOB.species_prototypes[species_type]
		data["species_list"][species_id] = get_species_data(species)
		var/list/tree = speciespath2map_ids(species_type)
		data["category_map"][species_id] = tree
	return data

/datum/preference/choiced/species/ui_static_data(mob/user)
	var/list/data = list()
	data["species"] = list()
	data["species"]["species_list"] = list()
	data["species"]["category_map"] = list()

	for (var/species_id in (get_selectable_species() + get_customizable_races())) //SKYRAT EDIT CHANGE
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = GLOB.species_prototypes[species_type]
		data["species"]["species_list"][species_id] = get_species_data(species)
		var/list/tree = speciespath2map_ids(species_type)
		data["species"]["category_map"][species_id] = tree
	return data

/proc/get_species_data(datum/species/species)
	var/list/spedat = list()
	var/spedesc = species.get_species_description()
	var/spelore = species.get_species_lore()
	spedat["name"]              = species.name
	spedat["id"]                = species.id
	spedat["desc"]              = LAZYLISTIFY(spedesc)
	spedat["lore"]              = LAZYLISTIFY(spelore)
	spedat["icon"]              = sanitize_css_class_name(species.name)
	spedat["use_skintones"]     = (TRAIT_USES_SKINTONES in species.inherent_traits)
	spedat["sexes"]             = species.sexes
	spedat["enabled_features"]  = species.get_features()
	spedat["perks"]             = species.get_species_perks()
	spedat["diet"]              = species.get_species_diet()
	spedat["sort_bottom"]       = species.sort_bottom //BUBBER EDIT ADDITION: Do we sort the species to the bottom?
	spedat["alt_prefixes"]      = species.alt_prefixes
	spedat["order"]             = species.ordering
	spedat["category"]          = species.category
	spedat["sub_category"]      = species.sub_category
	spedat["sub_sub_category"]  = species.sub_sub_category
	spedat["default_species"]   = species.default_species
	return spedat
