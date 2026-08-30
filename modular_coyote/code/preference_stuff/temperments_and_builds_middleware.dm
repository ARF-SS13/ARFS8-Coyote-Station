/datum/preference_middleware/character_snippets
	var/modding_something = FALSE

/datum/preference_middleware/character_snippets/New(datum/prefs_holder)
	. = ..()
	action_delegations += list(
		"operate_csnip" = PROC_REF(operate_csnip),
	)

// FPREFSORMAT: list("/datum/character_snippet", etc)
/// is given a tnb string, and then we determine what do with it
/datum/preference_middleware/character_snippets/proc/operate_csnip(list/params, mob/user)
	// clear it
	var/csnip_clear_cat = params["csnip_clear_cat"]
	var/static/list/csnip_cats = list(
		"T" = CSNIP_TEMPERAMENT,
		"B" = CSNIP_BUILD,
		"E" = CSNIP_EARLY_BACKGROUND,
		"A" = CSNIP_ADULT_BACKGROUND,
	)
	if(csnip_cats[csnip_clear_cat])
		csnip_clear_cat = csnip_cats[csnip_clear_cat]
		var/datum/preference/character_snippets/prefuse
		switch(csnip_clear_cat)
			if(CSNIP_TEMPERAMENT)
				prefuse = /datum/preference/character_snippets/temperaments
			if(CSNIP_BUILD)
				prefuse = /datum/preference/character_snippets/builds
			if(CSNIP_EARLY_BACKGROUND)
				prefuse = /datum/preference/character_snippets/early_backgrounds
			if(CSNIP_ADULT_BACKGROUND)
				prefuse = /datum/preference/character_snippets/adult_backgrounds
		preferences.write_preference(GLOB.preference_entries[prefuse], list())
		return TRUE

	// modify a background thing!
	var/mod_this_path = params["bg_flavor_mod_path"]
	if(mod_this_path) // it'll open a window for the user to modify the background flavor text
		var/datum/character_snippet/bg_to_mod = SSdans_cool_prefs.get_snippet_by_string_path(mod_this_path) // to check if its a thing
		if(!bg_to_mod)
			return FALSE
		modding_something = TRUE
		var/list/bg_data = preferences.read_preference(/datum/preference/character_snippets/background_extras) || list()
		var/thetext = bg_data["[mod_this_path]"] || ""
		var/new_text = tgui_input_text(
			user,
			"Customize what this background means to your character! For instance, if you have a background of 'has a sister', you could write about them here!<br>\
			Military service? Describe which branch, what you did, and how it affected you!<br>\
			Horrible debt? Describe how bad it is, how you got into it, and how it affects your life!<br>\
			<br>\
			Maximum length is 512 characters. Special characters may be clipped, multiline should be okay.<br>\
			Also these are saved separately, so if you remove the background, the text *should* be retained for if you add it back later!",
			"Expand upon: [bg_to_mod.name]",
			thetext,
			512,
			TRUE,
			TRUE,
			null,
			null,
			TRUE,
			TRUE,
		) // man look at all them args!
		modding_something = FALSE
		if(new_text == TGUI_TEXT_MODAL_CANCEL_TOKEN)
			to_chat(user, span_notice("Okay never mind!!"))
			return TRUE
		if(!new_text)
			modding_something = TRUE
			var/r_u_sure = tgui_alert(
				user,
				"Are you sure you want to clear the flavor text for this background?",
				"Clear Flavor Text?",
				list("Yes, clear it", "No, cancel!"),
			)
			modding_something = FALSE
			if(r_u_sure != "Yes, clear it")
				to_chat(user, span_notice("Okay never mind!!"))
				return TRUE
		modding_something = FALSE
		var/newertext = "[new_text]" || ""
		// ok now set it or something
		bg_data["[mod_this_path]"] = newertext
		preferences.write_preference(GLOB.preference_entries[/datum/preference/character_snippets/background_extras], bg_data)
		to_chat(user, span_notice("Saved!"))
		return TRUE

	// toogle it
	var/chosen_txt = params["csnip_string_path"]
	var/back_which = csnip_cats[params["csnip_back_which"]]
	if(!LAZYLEN(chosen_txt))
		return FALSE
	var/datum/character_snippet/chosen = SSdans_cool_prefs.get_snippet_by_string_path(chosen_txt)
	if(!istype(chosen, /datum/character_snippet))
		return FALSE
	var/datum/preference/character_snippets/prefuse
	switch(chosen.category_csnip)
		if(CSNIP_TEMPERAMENT)
			prefuse = /datum/preference/character_snippets/temperaments
		if(CSNIP_BUILD)
			prefuse = /datum/preference/character_snippets/builds
		if(CSNIP_BACKGROUND)
			switch(back_which)
				if(CSNIP_EARLY_BACKGROUND)
					prefuse = /datum/preference/character_snippets/early_backgrounds
				if(CSNIP_ADULT_BACKGROUND)
					prefuse = /datum/preference/character_snippets/adult_backgrounds
				else
					prefuse = /datum/preference/character_snippets/adult_backgrounds // whatevs
	// FORMAT: list("/datum/character_snippet", etc)
	var/list/player_snips = preferences.read_preference(prefuse)
	/// FORMAT: list("tnb/paths")
	var/has_it = FALSE
	for(var/csnip_string_path in player_snips)
		if(csnip_string_path == "[chosen.type]")
			has_it = TRUE
	var/didsomething = FALSE
	if(!has_it) // lacks tnb, try to add it! gotta be under the limit for the t/b categories!
		// first see if this is part of a set, and if so, remove the other tnb in that set
		if(chosen.set_key)
			for(var/csnip_string_path in player_snips)
				var/datum/character_snippet/other = SSdans_cool_prefs.get_snippet_by_string_path(csnip_string_path)
				if(other && other.set_key == chosen.set_key)
					player_snips -= "[csnip_string_path]"
		if(LAZYLEN(player_snips) < SSdans_cool_prefs.get_max_for(back_which || chosen.category_csnip))
			player_snips += "[chosen.type]"
			didsomething = TRUE
	else
		// already has it, remove
		player_snips -= "[chosen.type]"
		didsomething = TRUE
	if(didsomething)
		preferences.write_preference(GLOB.preference_entries[prefuse], player_snips)
	return TRUE

#define BG_LACKS_IT 0
#define BG_HAS_AS_EARLY 1
#define BG_HAS_AS_ADULT 2
#define BG_HAS_AS_BOTH 3
/datum/preference_middleware/character_snippets/get_ui_data(mob/user)
	var/gendy     = preferences.read_preference(/datum/preference/choiced/gender)
	var/namey     = preferences.read_preference(/datum/preference/name/real_name)
	var/list/data = list()
	data["player_temperaments"]      = list()
	data["player_builds"]            = list()
	data["player_early_backgrounds"] = list()
	data["player_adult_backgrounds"] = list()
	var/static/list/csnip_prefs = subtypesof(/datum/preference/character_snippets)
	var/list/player_csnips = list()
	for(var/preffy in csnip_prefs)
		player_csnips["[preffy]"] = preferences.read_preference(preffy)
	for(var/csnip_pref in player_csnips)
		var/list/valist = player_csnips[csnip_pref]
		for(var/csnip_string in valist)
			var/list/slug = SSdans_cool_prefs.get_tgui_data_for_snippet(csnip_string, gendy, namey)
			switch(csnip_pref)
				if("/datum/preference/character_snippets/temperaments")
					data["player_temperaments"]       += list(slug)
				if("/datum/preference/character_snippets/builds")
					data["player_builds"]             += list(slug)
				if("/datum/preference/character_snippets/early_backgrounds")
					data["player_early_backgrounds"]  += list(slug)
				if("/datum/preference/character_snippets/adult_backgrounds")
					data["player_adult_backgrounds"]  += list(slug)
	data["player_backgrounds"] =  preferences.read_preference(/datum/preference/character_snippets/background_extras) || list()
	return data

#undef BG_LACKS_IT
#undef BG_HAS_AS_EARLY
#undef BG_HAS_AS_ADULT
#undef BG_HAS_AS_BOTH
