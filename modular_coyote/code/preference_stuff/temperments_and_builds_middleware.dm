GLOBAL_LIST_INIT(max_tnb_sel, list(
	CSNIP_TEMPERAMENT = 2,
	CSNIP_BUILD = 2,
))

/datum/preference_middleware/temperaments_and_builds/New(datum/prefs_holder)
	. = ..()
	action_delegations += list(
		"operate_tnb" = PROC_REF(operate_tnb),
	)

// FPREFSORMAT: list("/datum/character_snippet", etc)
/// is given a tnb string, and then we determine what do with it
/datum/preference_middleware/temperaments_and_builds/proc/operate_tnb(list/params, mob/user)
	// clear it
	var/tnb_clear_cat = params["tnb_clear_cat"]
	var/static/list/csnip_cats = list("T" = CSNIP_TEMPERAMENT, "B" = CSNIP_BUILD, "E" = CSNIP_EARLY_BACKGROUND, "A" = CSNIP_ADULT_BACKGROUND)
	if(tnb_clear_cat && csnip_cats[tnb_clear_cat])
		tnb_clear_cat = csnip_cats[tnb_clear_cat]
		var/list/curr = preferences.read_preference(/datum/preference/temperaments_and_builds)
		curr |= list(CSNIP_TEMPERAMENT = list(), CSNIP_BUILD = list())
		if(tnb_clear_cat == "T")
			curr[CSNIP_TEMPERAMENT] = list()
		else if(tnb_clear_cat == "B")
			curr[CSNIP_BUILD] = list()
		preferences.write_preference(GLOB.preference_entries[/datum/preference/temperaments_and_builds], curr)
		return TRUE

	// toogle it
	var/chosen_txt = params["tnb_string_path"]
	if(!LAZYLEN(chosen_txt))
		return FALSE
	var/datum/character_snippet/chosen = SSdans_cool_prefs.get_snippet_by_string_path(chosen_txt)
	if(!istype(chosen, /datum/character_snippet))
		return FALSE
	var/datum/preference/temperaments_and_builds/prefuse
	switch(chosen.category_csnip)
		if(CSNIP_TEMPERAMENT)
			prefuse = /datum/preference/char_snippets/temperaments
		if(CSNIP_BUILD)
			prefuse = /datum/preference/char_snippets/builds
		if(CSNIP_EARLY_BACKGROUND)
			prefuse = /datum/preference/char_snippets/early_backgrounds
		if(CSNIP_ADULT_BACKGROUND)
			prefuse = /datum/preference/char_snippets/adult_backgrounds
	// FORMAT: list("/datum/character_snippet", etc)
	var/list/player_snips = preferences.read_preference(prefuse)
	/// FORMAT: list("tnb/paths")
	var/has_it = FALSE
	for(var/tnb_string_path in player_snips)
		if(tnb_string_path == "[chosen.type]")
			has_it = TRUE
	var/didsomething = FALSE
	if(!has_it) // lacks tnb, try to add it! gotta be under the limit for the t/b categories!
		// first see if this is part of a set, and if so, remove the other tnb in that set
		if(chosen.set_key)
			for(var/tnb_string_path in player_snips)
				var/datum/character_snippet/other = SSdans_cool_prefs.get_snippet_by_string_path(tnb_string_path)
				if(other && other.set_key == chosen.set_key)
					player_snips -= "[tnb_string_path]"
		if(LAZYLEN(player_snips) < SSdans_cool_prefs.get_max_for[chosen.category_csnip])
			player_snips += "[chosen.type]"
			didsomething = TRUE
	else
		// already has it, remove
		player_snips -= "[chosen.type]"
		didsomething = TRUE
	if(didsomething)
		preferences.write_preference(GLOB.preference_entries[prefuse], player_snips)
	return TRUE

// idk how prefs work, so imma just do it the way makes sense
/datum/preference_middleware/temperaments_and_builds/get_ui_static_data(mob/user)
	var/gendy = preferences.read_preference(/datum/preference/choiced/gender)
	var/namey = preferences.read_preference(/datum/preference/name/real_name)
	var/list/data = list()
	data["max_temperaments"]          = GLOB.max_tnb_sel[CSNIP_TEMPERAMENT]
	data["max_builds"]                = GLOB.max_tnb_sel[CSNIP_BUILD]
	data["server_temperaments"]       = list()
	data["server_builds"]             = list()
	data["server_early_backgrounds"]  = list()
	data["server_adult_backgrounds"]  = list()
	for(var/csnip_string_path in SSdans_cool_prefs.all_snippets)
		var/datum/character_snippet/csnip_datum = SSdans_cool_prefs.get_snippet_by_string_path(csnip_string_path)
		if(!csnip_datum)
			stack_trace("wtf, no character snippet thing for path [csnip_string_path]!")
			continue
		var/list/csnippus_entry = list()
		csnippus_entry["name"]      = csnip_datum.name
		csnippus_entry["desc"]      = csnip_datum.desc
		csnippus_entry["category"]  = csnip_datum.category_csnip
		csnippus_entry["example"]   = csnip_datum.get_example(gendy, namey)
		csnippus_entry["path"]      = "[csnip_datum.type]"
		csnippus_entry["set_key"]   = csnip_datum.set_key
		csnippus_entry["order"]     = csnip_datum.order
		switch(csnip_datum.category_csnip)
			if(CSNIP_TEMPERAMENT)
				data["server_temperaments"] += list(csnippus_entry)
			else if(CSNIP_BUILD)
				data["server_builds"] += list(csnippus_entry)
			else if(CSNIP_EARLY_BACKGROUND)
				data["server_early_backgrounds"] += list(csnippus_entry)
			else if(CSNIP_ADULT_BACKGROUND)
				data["server_adult_backgrounds"] += list(csnippus_entry)
	return data

/datum/preference_middleware/temperaments_and_builds/get_ui_data(mob/user)
	var/gendy = preferences.read_preference(/datum/preference/choiced/gender)
	var/namey = preferences.read_preference(/datum/preference/name/real_name)
	var/list/data = list()
	data["player_temperaments"] = list()
	data["player_builds"] = list()
	data["player_early_backgrounds"] = list()
	data["player_adult_backgrounds"] = list()
	var/static/list/csnip_prefs = subtypesof(/datum/preference/char_snippets)
	var/list/player_csnips = list()
	for(var/preffy in csnip_prefs)
		player_csnips |= preferences.read_preference(preffy)
	for(var/csnip_string in player_csnips)
		var/datum/character_snippet/csnip_datum = SSdans_cool_prefs.get_snippet_by_string_path(csnip_string)
		if(!csnip_datum)
			continue
		var/list/csnippus_entry = list()
		csnippus_entry["name"] = csnip_datum.name
		csnippus_entry["desc"] = csnip_datum.desc
		csnippus_entry["category"] = csnip_datum.category_csnip
		csnippus_entry["example"] = csnip_datum.get_example(gendy, namey)
		csnippus_entry["path"] = "[csnip_datum.type]"
		csnippus_entry["set_key"] = csnip_datum.set_key
		csnippus_entry["order"] = csnip_datum.order
		switch(csnip_datum.category_csnip)
			if(CSNIP_TEMPERAMENT)
				data["player_temperaments"] += list(csnippus_entry)
			else if(CSNIP_BUILD)
				data["player_builds"] += list(csnippus_entry)
			else if(CSNIP_EARLY_BACKGROUND)
				data["player_early_backgrounds"] += list(csnippus_entry)
			else if(CSNIP_ADULT_BACKGROUND)
				data["player_adult_backgrounds"] += list(csnippus_entry)
	return data

