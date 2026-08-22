GLOBAL_LIST_INIT(max_tnb_sel, list(
	TNB_TEMPERAMENT = 2,
	TNB_BUILD = 2,
))

/datum/preference_middleware/temperaments_and_builds/New(datum/prefs_holder)
	. = ..()
	action_delegations += list(
		"operate_tnb" = PROC_REF(operate_tnb),
	)
/// PREFS FORMAT: list("temperaments" = list("/datum/temperament_build"), "builds" = list("/datum/temperament_build"))
/// is given a tnb string, and then we determine what do with it
/datum/preference_middleware/temperaments_and_builds/proc/operate_tnb(list/params, mob/user)
	// clear it
	var/tnb_clear_cat = params["tnb_clear_cat"]
	if(tnb_clear_cat == "T" || tnb_clear_cat == "B")
		var/list/curr = preferences.read_preference(/datum/preference/temperaments_and_builds)
		curr |= list(TNB_TEMPERAMENT = list(), TNB_BUILD = list())
		if(tnb_clear_cat == "T")
			curr[TNB_TEMPERAMENT] = list()
		else if(tnb_clear_cat == "B")
			curr[TNB_BUILD] = list()
		preferences.write_preference(GLOB.preference_entries[/datum/preference/temperaments_and_builds], curr)
		return TRUE

	// toogle it
	var/chosen_txt = params["tnb_string_path"]
	if(!LAZYLEN(chosen_txt))
		return FALSE
	var/datum/temperament_build/chosen = GLOB.all_temperaments_and_builds_datums["[chosen_txt]"]
	if(!istype(chosen))
		return FALSE
	// FORMAT: list("temperaments" = list("/datum/temperament_build"), "builds" = list("/datum/temperament_build"))
	var/list/player_tnbs = preferences.read_preference(/datum/preference/temperaments_and_builds)
	player_tnbs |= list(TNB_TEMPERAMENT = list(), TNB_BUILD = list())
	/// FORMAT: list("temperaments" = list("tnb/paths"), "builds" = list("tnb/paths"))
	var/has_it = FALSE
	for(var/tnb_cat in player_tnbs)
		for(var/tnb_string_path in player_tnbs[tnb_cat])
			if(tnb_string_path == "[chosen.type]")
				has_it = TRUE
	var/didsomething = FALSE
	if(!has_it) // lacks tnb, try to add it! gotta be under the limit for the t/b categories!
		// first see if this is part of a set, and if so, remove the other tnb in that set
		if(chosen.set_key)
			for(var/tnb_cat in player_tnbs)
				for(var/tnb_string_path in player_tnbs[tnb_cat])
					var/datum/temperament_build/other = GLOB.all_temperaments_and_builds_datums["[tnb_string_path]"]
					if(other && other.set_key == chosen.set_key)
						player_tnbs["[tnb_cat]"] -= "[tnb_string_path]"
		if(LAZYLEN(player_tnbs["[chosen.tnb_category]"]) < GLOB.max_tnb_sel["[chosen.tnb_category]"])
			player_tnbs["[chosen.tnb_category]"] += "[chosen.type]"
			didsomething = TRUE
	else
		// already has it, remove
		player_tnbs["[chosen.tnb_category]"] -= "[chosen.type]"
		didsomething = TRUE
	if(didsomething)
		preferences.write_preference(GLOB.preference_entries[/datum/preference/temperaments_and_builds], player_tnbs)
	return TRUE

// idk how prefs work, so imma just do it the way makes sense
/datum/preference_middleware/temperaments_and_builds/get_ui_static_data(mob/user)
	var/gendy = preferences.read_preference(/datum/preference/choiced/gender)
	var/namey = preferences.read_preference(/datum/preference/name/real_name)
	var/list/data = list()
	data["max_temperaments"] = GLOB.max_tnb_sel[TNB_TEMPERAMENT]
	data["max_builds"] = GLOB.max_tnb_sel[TNB_BUILD]
	data["server_temperaments"] = list()
	data["server_builds"] = list()
	for(var/tbtxt in GLOB.all_temperaments_and_builds_datums)
		var/datum/temperament_build/tb = GLOB.all_temperaments_and_builds_datums["[tbtxt]"]
		var/list/tnbingus_entry = list()
		tnbingus_entry["name"] = tb.name
		tnbingus_entry["desc"] = tb.desc
		tnbingus_entry["category"] = tb.tnb_category
		tnbingus_entry["example"] = tb.get_example(gendy, namey)
		tnbingus_entry["path"] = "[tb.type]"
		tnbingus_entry["set_key"] = tb.set_key
		if(tb.tnb_category == TNB_TEMPERAMENT)
			data["server_temperaments"] += list(tnbingus_entry)
		else if(tb.tnb_category == TNB_BUILD)
			data["server_builds"] += list(tnbingus_entry)
	return data

/datum/preference_middleware/temperaments_and_builds/get_ui_data(mob/user)
	var/gendy = preferences.read_preference(/datum/preference/choiced/gender)
	var/namey = preferences.read_preference(/datum/preference/name/real_name)
	var/list/data = list()
	data["player_temperaments"] = list()
	data["player_builds"] = list()
	var/list/player_tnbs = preferences.read_preference(/datum/preference/temperaments_and_builds)
	for(var/tnb_cat in player_tnbs)
		for(var/tnb in player_tnbs[tnb_cat])
			var/datum/temperament_build/tb = GLOB.all_temperaments_and_builds_datums["[tnb]"]
			if(!tb)
				continue
			var/list/tnbingus_entry = list()
			tnbingus_entry["name"] = tb.name
			tnbingus_entry["desc"] = tb.desc
			tnbingus_entry["category"] = tb.tnb_category
			tnbingus_entry["example"] = tb.get_example(gendy, namey)
			tnbingus_entry["path"] = "[tb.type]"
			tnbingus_entry["set_key"] = tb.set_key
			tnbingus_entry["order"] = tb.order
			if(tb.tnb_category == TNB_TEMPERAMENT)
				data["player_temperaments"] += list(tnbingus_entry)
			else if(tb.tnb_category == TNB_BUILD)
				data["player_builds"] += list(tnbingus_entry)
	data["max_temperaments"] = GLOB.max_tnb_sel[TNB_TEMPERAMENT]
	data["max_builds"] = GLOB.max_tnb_sel[TNB_BUILD]
	return data

