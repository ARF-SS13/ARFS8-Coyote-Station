// ╔═════════╤══════════════════════════════════╗
// ║ File    │ coolprefs_subsystem.dm           ║
// ║ Date    │ 2024-06-14                       ║
// ║ Author  │ Dan 'CoyoteWithAPlan' Kelly      ║
// ║ License │ PG-13                            ║
// ║ Quote   │ "who you calling a sub, system?" ║
// ╟─────────┼──────────────────────────────────╨────────────────────────────────────────────────────╖
// ║         │                                                                                       ║
// ║  ####   │ This cool customer handles the handling of datumized clicky-block text descriptors.   ║
// ║  ####   │ Currently handles Temperaments, Builds, Early Backgrounds, and Adult Backgrounds      ║
// ║  ####   │ Designed to be a low-input-effort way to quickly add on chunks of lore and flavor     ║
// ║  ####   │ to your horny homonculi.                                                              ║
// ║         │                                                                                       ║
// ║  !!!!   │ Backgrounds are funky though, they pull from a single list of datums, but are applied ║
// ║  !!!!   │ to two different preference keys on the player! Pretty clever huh?                    ║
// ║         │                                                                                       ║
// ╟─────────┼───────────────────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ===================================================================================  ║
// ╚═════════╧═══════════════════════════════════════════════════════════════════════════════════════╝

SUBSYSTEM_DEF(dans_cool_prefs)
	name = "DansCoolPrefs"
	flags = SS_NO_FIRE

	/// our list of all the verbsets, for easier access
	/// format: list(/datum/verbset, /datum/verbset, etc) <- not like the others!
	var/list/verbsets = list()
	/// our list of all the temperaments, for easy access
	/// format: list("/datum/character_snippet" = datum/character_snippet)
	var/list/temperaments = list()
	/// our list of all the builds, for easy access
	/// format: list("/datum/character_snippet" = datum/character_snippet)
	var/list/builds = list()
	/// our list of backgrounds, for easy access
	/// format: list("/datum/character_snippet" = datum/character_snippet)
	var/list/backgrounds = list()
	var/max_backgrounds_per_page = 10
	/// spans for each of the above, for easy access
	/// format: list(CSNIP_TEMPERAMENT = span, CSNIP_BUILD = span, TNB_EARLY_BACKGROUND = span, TNB_ADULT_BACKGROUND = span)
	var/list/spans = list(
		CSNIP_TEMPERAMENT = "green",
		CSNIP_BUILD = "notice",
		CSNIP_EARLY_BACKGROUND = "interface",
		CSNIP_ADULT_BACKGROUND = "alien",
	)
	var/list/cutie_cats = list()

	var/max_temperaments = 2
	var/min_temperaments = 1

	var/max_builds = 2
	var/min_builds = 1

	var/max_early_backgrounds = 151
	var/min_early_backgrounds = 2

	var/max_adult_backgrounds = 151
	var/min_adult_backgrounds = 2

	/// all of them!
	/// format: list("/datum/character_snippet" = datum/character_snippet, etc)
	var/list/all_snippets = list()

	var/max_rumors = 50

/datum/controller/subsystem/dans_cool_prefs/Initialize(start_timeofday)
	generate_verbsets()
	generate_snippets()
	generate_cutie_cats()
	sort_snippets()
	all_snippets = temperaments | builds | backgrounds
	var/list/initoid = list()
	initoid += "[LAZYLEN(temperaments)] temperaments"
	initoid += "[LAZYLEN(builds)] builds"
	initoid += "[LAZYLEN(backgrounds)] backgrounds"
	initoid += "[LAZYLEN(verbsets)] ways to butcher your pronouns"
	var/whatdid = english_list(initoid)
	to_chat(world, span_captaincast("Initialized [whatdid]!"))

/datum/controller/subsystem/dans_cool_prefs/proc/generate_cutie_cats()
	QDEL_LIST_ASSOC_VAL(cutie_cats) // kill all cutie cats
	cutie_cats = list()
	cutie_cats[MALE]         = new /mob/living/carbon/human/cutiecat()
	cutie_cats[FEMALE]       = new /mob/living/carbon/human/cutiecat/girl()
	cutie_cats[PLURAL]       = new /mob/living/carbon/human/cutiecat/nb()
	cutie_cats["otherwise"]  = new /mob/living/carbon/human/cutiecat/nb()

/datum/controller/subsystem/dans_cool_prefs/proc/generate_verbsets()
	verbsets = list()
	for(var/csnip_verbset_path in typesof(/datum/csnip_verbset))
		var/datum/csnip_verbset/csnip_verbset_pro = csnip_verbset_path
		if(csnip_verbset_pro == csnip_verbset_pro::abstract_type)
			continue
		verbsets += new csnip_verbset_pro()

/datum/controller/subsystem/dans_cool_prefs/proc/generate_snippets()
	temperaments = list()
	builds = list()
	backgrounds = list()
	for(var/csnip_string_path in typesof(/datum/character_snippet))
		var/datum/character_snippet/csnip_path_pro = csnip_string_path
		if(csnip_path_pro == csnip_path_pro::abstract_type)
			continue
		var/cat = csnip_path_pro::category_csnip
		var/list/addto
		switch(cat)
			if(CSNIP_TEMPERAMENT)
				addto = temperaments
			if(CSNIP_BUILD)
				addto = builds
			if(CSNIP_EARLY_BACKGROUND, CSNIP_ADULT_BACKGROUND, CSNIP_BACKGROUND)
				addto = backgrounds
			else
				continue
		addto["[csnip_path_pro::type]"] = new csnip_path_pro()

/datum/controller/subsystem/dans_cool_prefs/proc/sort_snippets()
	// now this is a delicate operation, because we want to sort the lists by like three different things
	// first by set_key, then by order, then by name, then insert the set_key groups alphabetically by their set_key
	// so we do a multi-pass sort!
	temperaments = sortificate(temperaments)
	builds = sortificate(builds)
	backgrounds = sortificate(backgrounds)

/datum/controller/subsystem/dans_cool_prefs/proc/sortificate(list/unsorted)
	// format: list("/datum/character_snippet" = datum/character_snippet, etc)
	var/list/non_setted = list()
	// format: list("set_key" = list("/datum/character_snippet" = datum/character_snippet, etc))
	var/list/sets = list()
	var/list/set_keys = list()
	for(var/csnipkey in unsorted)
		var/datum/character_snippet/csnip_datum = unsorted[csnipkey]
		if(!csnip_datum)
			continue
		if(!csnip_datum.set_key)
			non_setted |= csnip_datum
			continue
		set_keys |= csnip_datum.set_key
		LAZYADD(sets["[csnip_datum.set_key]"], csnip_datum)
	set_keys = sort_list(set_keys)
	var/list/sorted_sets = list()
	for(var/setkey in set_keys)
		var/list/sorted_set = sort_list(sets["[setkey]"], /proc/cmp_csnip_order)
		sorted_sets["[setkey]"] = sorted_set
	// sets are now sorted by name, with the members sorted by order. yay!
	// now for the unsetted
	var/list/non_setted_sorted = sort_list(non_setted, /proc/cmp_csnip)
	// now we strip out the keys and reassemble the list in the order we want, with the sets first, then the non_setted
	var/list/flatter = list()
	var/list/flatter_decoder = list()
	// and uh, put all the names and set_keys into a single list
	for(var/set_key in sorted_sets)
		flatter += "[set_key]____SETBINGUS"
	for(var/datum/character_snippet/csnip_datum in non_setted_sorted)
		var/namekey = "[csnip_datum.name]"
		while(flatter_decoder[namekey])
			namekey += "_"
		flatter += namekey
		flatter_decoder[namekey] = csnip_datum
	// alphabetize them all
	var/list/slorted_keys = sort_list(flatter, /proc/cmp_text_asc)
	var/list/finaller = list()
	// and i guess like just kinda do this
	for(var/sorted_key in slorted_keys)
		var/datum/character_snippet/csnip_datum = flatter_decoder[sorted_key]
		if(!csnip_datum)
			if(!findtext(sorted_key, "____SETBINGUS"))
				continue
			var/set_key = replacetext(sorted_key, "____SETBINGUS", "")
			var/list/set_members = sorted_sets["[set_key]"]
			for(var/datum/character_snippet/csnip_datum_2 in set_members)
				finaller["[csnip_datum_2.type]"] = csnip_datum_2
			continue
		finaller["[csnip_datum.type]"] = csnip_datum
	return finaller // yeah that oughta do it

/proc/cmp_csnip(datum/character_snippet/a, datum/character_snippet/b)
	return sorttext(b.name, a.name)

/proc/cmp_csnip_order(datum/character_snippet/a, datum/character_snippet/b)
	return a.order - b.order

/datum/controller/subsystem/dans_cool_prefs/proc/get_min_for(csnip_category = "butt")
	switch(csnip_category)
		if(CSNIP_TEMPERAMENT)
			return min_temperaments
		if(CSNIP_BUILD)
			return min_builds
		if(CSNIP_EARLY_BACKGROUND)
			return min_early_backgrounds
		if(CSNIP_ADULT_BACKGROUND)
			return min_adult_backgrounds
		if("butt") // give em all of em i guess!
			return list(
				CSNIP_TEMPERAMENT = min_temperaments,
				CSNIP_BUILD = min_builds,
				CSNIP_EARLY_BACKGROUND = min_early_backgrounds,
				CSNIP_ADULT_BACKGROUND = min_adult_backgrounds,
			)
	return 0

/datum/controller/subsystem/dans_cool_prefs/proc/get_max_for(csnip_category = "butt")
	switch(csnip_category)
		if(CSNIP_TEMPERAMENT)
			return max_temperaments
		if(CSNIP_BUILD)
			return max_builds
		if(CSNIP_EARLY_BACKGROUND)
			return max_early_backgrounds
		if(CSNIP_ADULT_BACKGROUND)
			return max_adult_backgrounds
		if("butt") // give em all of em i guess!
			return list(
				CSNIP_TEMPERAMENT = max_temperaments,
				CSNIP_BUILD = max_builds,
				CSNIP_EARLY_BACKGROUND = max_early_backgrounds,
				CSNIP_ADULT_BACKGROUND = max_adult_backgrounds,
			)
	return 0

/datum/controller/subsystem/dans_cool_prefs/proc/get_snippet_by_string_path(spath)
	if(!LAZYLEN(spath))
		return null
	return all_snippets["[spath]"]

/datum/controller/subsystem/dans_cool_prefs/proc/get_text(mob/mobver, which = CSNIP_TEMPERAMENT, htmld = FALSE)
	if(!ishuman(mobver))
		return "They happen to be something cool beans!"
	var/mob/living/carbon/human/haver = mobver
	var/datum/dna/dna = haver?.dna
	if(!dna)
		return "They happen to be something even more cool beans!"
	var/feature_key = "idk"
	switch(which)
		if(CSNIP_TEMPERAMENT)
			feature_key = "csnip_temperaments"
		if(CSNIP_BUILD)
			feature_key = "csnip_builds"
		if(CSNIP_EARLY_BACKGROUND)
			feature_key = "csnip_early_backgrounds"
		if(CSNIP_ADULT_BACKGROUND)
			feature_key = "csnip_adult_backgrounds"
	// format: list(/datum/character_snippet, /datum/character_snippet, etc)
	var/list/csnip_paths = dna.features[feature_key]
	if(!LAZYLEN(csnip_paths))
		return null // no csnip paths, so no text
	var/list/translated = list()
	for(var/csnip_string_path in csnip_paths)
		var/datum/character_snippet/csnip_datum = get_snippet_by_string_path(csnip_string_path)
		if(!csnip_datum)
			continue
		var/spain = spans["[which]"]
		var/message = csnip_datum.get_desc_text(haver)
		message = span_class(spain, message)
		translated += message
	var/sep = htmld ? "<br>" : "\n"
	var/thething = translated.Join(sep)
	return thething

/datum/controller/subsystem/dans_cool_prefs/proc/get_tgui_data_for_snippet(
	csnip_string_path,
	gendy,
	namey)
	var/datum/character_snippet/csnip_datum = get_snippet_by_string_path(csnip_string_path)
	if(!csnip_datum)
		var/static/list/kyes = list("name", "desc", "category", "subcategory", "example", "path", "set_key", "order")
		var/list/empty = list()
		for(var/ky in kyes)
			empty["[ky]"] = ":c"
		return empty
	var/list/csnippus_entry = list()
	csnippus_entry["name"]      = csnip_datum.name
	csnippus_entry["desc"]      = csnip_datum.desc
	csnippus_entry["category"]  = csnip_datum.category_csnip
	csnippus_entry["subcategory"] = csnip_datum.subcategory_csnip // tab
	csnippus_entry["example"]   = csnip_datum.get_example(gendy, namey)
	csnippus_entry["path"]      = "[csnip_datum.type]"
	csnippus_entry["set_key"]   = csnip_datum.set_key
	csnippus_entry["order"]     = csnip_datum.order
	return csnippus_entry

/mob/living/carbon/human/cutiecat
	name = "Mr. Cutie Cat"
	gender = MALE

/mob/living/carbon/human/cutiecat/create_dna()
	dna = new /datum/dna(src)
	var/datum/species/cool = pick(
		/datum/species/skeleton,
		/datum/species/vulpkanin,
		/datum/species/lizard,
		/datum/species/vulpkanin,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/teshari,
		/datum/species/akula,
	)
	dna.species = new cool()

/mob/living/carbon/human/cutiecat/girl
	name = "Ms. Cutie Cat"
	gender = FEMALE

/mob/living/carbon/human/cutiecat/nb
	name = "Mx. Cutie Cat"
	gender = PLURAL
