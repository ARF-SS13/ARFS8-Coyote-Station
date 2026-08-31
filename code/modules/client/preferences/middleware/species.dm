GLOBAL_LIST_EMPTY(species_static_tgui)

/// Handles the assets for species icons
/datum/preference_middleware/species
	action_delegations = list(
		"handle_species_thing" = PROC_REF(handle_species_thing),
	)

/datum/preference_middleware/species/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/spritesheet/species),
	)

/datum/preference_middleware/species/proc/handle_species_thing(list/params, mob/user)
	var/requested_species = params["species"] // species id, not typepath
	if(!requested_species)
		return FALSE
	var/spetype = GLOB.species_list[requested_species]
	if(!spetype)
		return FALSE
	var/datum/species/species = GLOB.species_prototypes[spetype]
	if(!species)
		return FALSE
	// now hold up there! gotta check if its a folder!
	// if it is, we need to set the default species for that folder instead
	var/datum/species/target_species = species
	if(species.is_folder)
		var/defspe_type = species.default_species // typepath
		if(!defspe_type)
			defspe_type = /datum/species/vulpkanin // yiff yiff
		target_species = GLOB.species_prototypes[defspe_type]
	// now hold up one more time! gotta do the thing like it shoulda done with the
	var/datum/preference/choiced/species/spec_pref = GLOB.preference_entries[/datum/preference/choiced/species]
	var/requested_preference_key = spec_pref.savefile_key
	var/value = target_species.id

	for (var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
		if (preference_middleware.pre_set_preference(user, requested_preference_key, value))
			return TRUE

	var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
	if (isnull(requested_preference))
		return FALSE

	// SAFETY: `update_preference` performs validation checks
	if (!preferences.update_preference(requested_preference, value))
		return FALSE

	//SKYRAT EDIT
	preferences.update_body_parts(requested_preference)
	for(var/datum/preference_middleware/preference_middleware as anything in preferences.middleware)
		if(preference_middleware.post_set_preference(user, requested_preference_key, value))
			return TRUE
	//SKYRAT EDIT END
	return TRUE

/datum/preference_middleware/species/get_ui_data(mob/user)
	var/list/data = list()
	var/datum/species/mine_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = GLOB.species_prototypes[mine_type]
	if(!species)
		preferences.write_preference(GLOB.preference_entries[/datum/preference/choiced/species], /datum/species/vulpkanin)
	data["player_species"] = species.id
	return data

/datum/preference_middleware/species/get_ui_static_data(mob/user)
	var/list/data = list()
	data["server_species_data"] = compile_species_static_data()
	return data

/// need...
/// list of base+category species into a flat map
/// map for which species to display in slot 2 if slot 1 is a category
/// map for which species to display in slot 3 if slot 2 is a subcategory
/proc/compile_species_static_data()
	if(LAZYLEN(GLOB.species_static_tgui))
		return GLOB.species_static_tgui
	GLOB.species_static_tgui = list()

	var/list/data = list()
	// "species.id" = list(lots of data)
	data["species_list"] = list()

	var/list/los = get_selectable_species() + get_customizable_races()
	var/list/list_of_species_obj = list()
	for (var/species_id in los)
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = GLOB.species_prototypes[species_type]
		list_of_species_obj += species
	list_of_species_obj = sort_list(list_of_species_obj, /proc/cmp_name_asc)
	var/datum/species/vulpkanin/vulp = GLOB.species_prototypes[/datum/species/vulpkanin]
	data["species_list"][vulp.id] = get_species_data(vulp) // i like foxes
	for (var/datum/species/species as anything in list_of_species_obj)
		if(istype(species, /datum/species/vulpkanin))
			continue
		var/list/spedat = get_species_data(species)
		data["species_list"][species.id] = spedat

	GLOB.species_static_tgui = data
	return GLOB.species_static_tgui

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
	spedat["is_folder"]         = species.is_folder
	return spedat

/proc/cmp_species_ordering(datum/species/species1, datum/species/species2)
	if(species1.ordering < species2.ordering)
		return -1
	else if(species1.ordering > species2.ordering)
		return 1
	else
		return 0


/datum/asset/spritesheet/species
	name = "species"
	early = TRUE

/datum/asset/spritesheet/species/create_spritesheets()
	var/list/to_insert = list()

	for (var/species_id in get_selectable_species() | get_customizable_races()) // SKYRAT EDIT CHANGE - ORIGINAL: for (var/species_id in get_selectable_species())
		var/datum/species/species_type = GLOB.species_list[species_id]

		var/mob/living/carbon/human/dummy/consistent/dummy = new
		dummy.set_species(species_type)
		dummy.equipOutfit(/datum/outfit/job/assistant/consistent, visuals_only = TRUE)
		dummy.dna.species.prepare_human_for_preview(dummy)

		var/icon/dummy_icon = getFlatIcon(dummy)
		dummy_icon.Scale(64, 64)
		dummy_icon.Crop(15, 64 - 31, 15 + 31, 64)
		dummy_icon.Scale(64, 64)
		to_insert[sanitize_css_class_name(initial(species_type.name))] = dummy_icon

		SSatoms.prepare_deletion(dummy)

	for (var/spritesheet_key in to_insert)
		Insert(spritesheet_key, to_insert[spritesheet_key])


