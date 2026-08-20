GLOBAL_LIST_INIT(max_tnb_sel, list(
	TNB_TEMPERAMENT = 2,
	TNB_BUILD = 2,
))

/datum/preference_middleware/temperaments_and_builds/New(datum/prefs_holder)
	. = ..()
	action_delegations += list(
		"toggle_tnb" = PROC_REF(toggle_tnb),
	)

/// is given a tnb string, and then we determine what do with it
/datum/preference_middleware/temperaments_and_builds/proc/toggle_tnb(list/params, mob/user)
	var/chosen_txt = params["tnb_path"]
	if(!LAZYLEN(chosen_txt))
		return FALSE
	var/datum/temperament_build/chosen = GLOB.all_temperaments_and_builds_datums["[chosen_txt]"]
	if(!istype(chosen))
		return FALSE
	// FORMAT: list("/datum/temperaments_and_builds/path")
	var/list/player_tnbs = preferences.read_preference(/datum/preference/temperaments_and_builds)
	/// FORMAT: list("temperaments" = list("tnb/paths"), "builds" = list("tnb/paths"))
	var/list/sorted = list()
	var/has_it = FALSE
	for(var/tnbtxt in player_tnbs)
		if(tnbtxt == chosen_txt)
			has_it = TRUE
		var/datum/temperament_build/tb = GLOB.all_temperaments_and_builds_datums["[tnbtxt]"]
		if(!tb)
			continue
		LAZYADD(sorted["[tb.tnb_type]"], tb)
	var/is_addition = !has_it
	if(is_addition) // lacks tnb, try to add it! gotta be under the limit for the t/b categories!
		if(LAZYLEN(sorted["[chosen.tnb_type]"]) < GLOB.max_tnb_sel["[chosen.tnb_type]"])
			LAZYADD(sorted["[chosen.tnb_type]"], chosen)
	else
		// already has it, remove
		LAZYREMOVE(sorted["[chosen.tnb_type]"], chosen)
	preferences.write_preference(/datum/preference/temperaments_and_builds, sorted)
	return TRUE

// idk how prefs work, so imma just do it the way makes sense
/datum/preference_middleware/temperaments_and_builds/get_ui_static_data(mob/user)
	var/list/data = list()
	var/list/tnbingus = list()
	tnbingus["temperaments"] = list()
	tnbingus["builds"] = list()
	for(var/tbtxt in GLOB.all_temperaments_and_builds_datums)
		var/datum/temperament_build/tb = GLOB.all_temperaments_and_builds_datums["[tbtxt]"]
		var/list/tnbingus_entry = list()
		tnbingus_entry["path"] = tbtxt
		tnbingus_entry["name"] = tb.name
		tnbingus_entry["category"] = tb.tnb_type
		tnbingus_entry["example"] = tb.get_example()
		if(tb.tnb_type == TNB_TEMPERAMENT)
			tnbingus["temperaments"] += list(tnbingus_entry)
		else if(tb.tnb_type == TNB_BUILD)
			tnbingus["builds"] += list(tnbingus_entry)
	data["tnb"] = tnbingus
	return data

/datum/preference_middleware/temperaments_and_builds/get_ui_data(mob/user)
	var/list/data = list()
	data["tnb_selected"] = preferences.read_preference(/datum/preference/temperaments_and_builds)
	return data

