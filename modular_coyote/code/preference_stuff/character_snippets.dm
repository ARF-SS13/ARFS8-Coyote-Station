/// Sends information needed for uplinks
/datum/asset/json/csnip
	name = "csnip"
	early = TRUE

/datum/asset/json/csnip/generate()
	var/list/maxes = SSdans_cool_prefs.get_max_for()
	var/list/mins  = SSdans_cool_prefs.get_min_for()
	var/list/data  = list()
	data["max_temperaments"]      = maxes[CSNIP_TEMPERAMENT]
	data["max_builds"]            = maxes[CSNIP_BUILD]
	data["max_early_backgrounds"] = maxes[CSNIP_EARLY_BACKGROUND]
	data["max_adult_backgrounds"] = maxes[CSNIP_ADULT_BACKGROUND]

	data["min_temperaments"]      = mins[CSNIP_TEMPERAMENT]
	data["min_builds"]            = mins[CSNIP_BUILD]
	data["min_early_backgrounds"] = mins[CSNIP_EARLY_BACKGROUND]
	data["min_adult_backgrounds"] = mins[CSNIP_ADULT_BACKGROUND]

	data["server_temperaments"]           = list()
	data["server_builds"]                 = list()
	data["server_tab_groups"]             = list()
	data["server_tabs"]                   = list()
	data["server_backgrounds"]            = list()
	data["server_backgrounds_paginated"]  = list()
	var/list/paginated_slugs = list()
	var/list/current_page = list()
	for(var/csnip_string_path in SSdans_cool_prefs.all_snippets)
		var/list/slug = SSdans_cool_prefs.get_tgui_data_for_snippet(csnip_string_path, pick(MALE, FEMALE, PLURAL), "Dan Kelly")
		switch(slug["category"])
			if(CSNIP_TEMPERAMENT)
				data["server_temperaments"] += list(slug)
			if(CSNIP_BUILD)
				data["server_builds"] += list(slug)
			if(CSNIP_BACKGROUND, CSNIP_EARLY_BACKGROUND, CSNIP_ADULT_BACKGROUND)
				data["server_backgrounds"] += list(slug)
				current_page += list(slug)
				if(LAZYLEN(current_page) >= SSdans_cool_prefs.max_backgrounds_per_page)
					paginated_slugs += list(current_page)
					current_page = list()
				var/tab = slug["subcategory"]
				LAZYADD(data["server_tab_groups"][tab], slug)
				data["server_tabs"] |= tab
	if(LAZYLEN(current_page))
		paginated_slugs += list(current_page)
	data["server_tabs"] = sort_list(data["server_tabs"]) || list() // alphebeticalisze
	data["server_backgrounds_paginated"] += paginated_slugs
	return data
