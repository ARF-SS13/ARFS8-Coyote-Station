// ╔═════════╤══════════════════════════════════╗
// ║ File    │ coolprefs_subsystem.dm           ║
// ║ Date    │ 2024-06-14                       ║
// ║ Author  │ Dan 'CoyoteWithAPlan' Kelly      ║
// ║ License │ PG-13                            ║
// ║ Quote   │ "who you calling a sub, system?" ║
// ╟─────────┼──────────────────────────────────╨────────────────────────────────────────────────────╖
// ║         │                                                                                       ║
// ║  Desc   │ This cool customer handles the handling of datumized clicky-block text descriptors.   ║
// ║         │ Currently handles Temperaments, Builds, Early Backgrounds, and Adult Backgrounds      ║
// ║  @@@@   │ Designed to be a low-input-effort way to quickly add on chunks of lore and flavor     ║
// ║  @@@@   │ to your horny homonculi.                                                              ║
// ║         │                                                                                       ║
// ╟─────────┼───────────────────────────────────────────────────────────────────────────────────────╢
// ║  $$$$   │  ###################################################################################  ║
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
	/// our list of early backgrounds, for easy access
	/// format: list("/datum/character_snippet" = datum/character_snippet)
	var/list/early_backgrounds = list()
	/// our list of adult backgrounds, for easier access
	/// format: list("/datum/character_snippet" = datum/character_snippet)
	var/list/adult_backgrounds = list()
	/// spans for each of the above, for easy access
	/// format: list(CSNIP_TEMPERAMENT = span, CSNIP_BUILD = span, TNB_EARLY_BACKGROUND = span, TNB_ADULT_BACKGROUND = span)
	var/list/spans = list(
		CSNIP_TEMPERAMENT = "green",
		CSNIP_BUILD = "notice",
		CSNIP_EARLY_BACKGROUND = "interface",
		CSNIP_ADULT_BACKGROUND = "alien",
	)
	/// all of them!
	/// format: list("/datum/character_snippet" = datum/character_snippet, etc)
	var/list/all_snippets = list()

/datum/controller/subsystem/dans_cool_prefs/Initialize(start_timeofday)
	generate_verbsets()
	generate_snippets()
	sort_snippets()
	all_snippets = temperaments | builds | early_backgrounds | adult_backgrounds
	var/list/initoid = list()
	initoid += "[LAZYLEN(temperaments)] temperaments"
	initoid += "[LAZYLEN(builds)] builds"
	initoid += "[LAZYLEN(early_backgrounds)] early backgrounds"
	initoid += "[LAZYLEN(adult_backgrounds)] adult backgrounds"
	initoid += "[LAZYLEN(verbsets)] ways to butcher your pronouns"
	var/whatdid = english_list(initoid)
	to_chat(world, span_captaincast("Initialized [whatdid]!"))

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
	for(var/csnip_string_path in typesof(/datum/character_snippet))
		var/datum/character_snippet/csnip_path_pro = csnip_string_path
		if(csnip_path_pro == csnip_path_pro::abstract_type)
			continue
		var/cat = csnip_path_pro::csnip_category
		var/list/addto
		switch(cat)
			if(CSNIP_TEMPERAMENT)
				addto = temperaments
			if(CSNIP_BUILD)
				addto = builds
			if(TNB_EARLY_BACKGROUND)
				addto = early_backgrounds
			if(TNB_ADULT_BACKGROUND)
				addto = adult_backgrounds
			else
				continue
		addto["[csnip_path_pro::type]"] = new csnip_path_pro()

/datum/controller/subsystem/dans_cool_prefs/proc/sort_snippets()
	// now this is a delicate operation, because we want to sort the lists by like three different things
	// first by set_key, then by order, then by name, then insert the set_key groups alphabetically by their set_key
	// so we do a multi-pass sort!
	temperaments = sortificate(temperaments)
	builds = sortificate(builds)
	early_backgrounds = sortificate(early_backgrounds)
	adult_backgrounds = sortificate(adult_backgrounds)

/datum/controller/subsystem/dans_cool_prefs/proc/sortificate(list/unsorted)
	// format: list("/datum/character_snippet" = datum/character_snippet, etc)
	var/list/non_setted = list()
	// format: list("set_key" = list("/datum/character_snippet" = datum/character_snippet, etc))
	var/list/sets = list()
	for(var/csnipkey in unsorted)
		var/datum/character_snippet/csnip_datum = unsorted[csnipkey]
		if(!csnip_datum)
			continue
		if(!csnip_datum.set_key)
			non_setted["[csnipkey]"] = csnip_datum
			continue
		LAZYADD(sets["[csnip_datum.set_key]"], csnip_datum)
	// now we sort the sets by their set_key, and then sort each set by order
	var/list/sorted_sets = list()
	for(var/set_key in sets)
		sorted_sets["[set_key]"] = sort_list(sets["[set_key]"], /proc/cmp_csnip_order)
	// now we sort the non_setted by alphabetical order, and then append them to the end of the sorted_sets
	var/list/non_setted_sorted = sort_list(non_setted, /proc/cmp_csnip)
	// now we strip out the keys and reassemble the list in the order we want, with the sets first, then the non_setted
	var/list/flatter = list()
	// and uh, put all the names and set_keys into a single list
	for(var/set_key in sorted_sets)
		flatter += set_key
	for(var/nonset_key in non_setted_sorted)
		var/datum/character_snippet/csnip_datum = non_setted_sorted[nonset_key]
		flatter += "[csnip_datum.name]"
	// alphabetize them all
	var/slorted_keys = sort_list(flatter, /proc/cmp_text_asc)
	var/list/finaller = list()
	// and i guess like just kinda do this
	for(var/sorted_key in slorted_keys)
		if(sorted_sets[sorted_key])
			for(var/csnip_key in sorted_sets[sorted_key])
				finaller["[csnip_key]"] = sorted_sets[sorted_key][csnip_key]
		if(non_setted_sorted[sorted_key])
			finaller["[sorted_key]"] = non_setted_sorted[sorted_key]
	return finaller // yeah that oughta do it

/proc/cmp_csnip(datum/character_snippet/a, datum/character_snippet/b)
	return sorttext(b.name, a.name)

/proc/cmp_csnip_order(datum/character_snippet/a, datum/character_snippet/b)
	return sorttext(b.order, a.order)


/datum/controller/subsystem/dans_cool_prefs/proc/get_snippet_by_string_path(spath)
	if(!LAZYLEN(spath))
		return null
	return all_snippets["[spath]"]

/datum/controller/subsystem/dans_cool_prefs/proc/get_text(mob/haver, which = CSNIP_TEMPERAMENT, htmld = FALSE)
	if(!ishuman(haver))
		return "They happen to be something cool beans!"
	var/datum/dna/dna = haver?.dna
	if(!dna)
		return "They happen to be something even more cool beans!"
	var/list/to_use = list()
	var/feature_key = "idk"
	switch(which)
		if(CSNIP_TEMPERAMENT)
			to_use = temperaments
			feature_key = "csnip_temperaments"
		if(CSNIP_BUILD)
			to_use = builds
			feature_key = "csnip_builds"
		if(CSNIP_EARLY_BACKGROUND)
			to_use = early_backgrounds
			feature_key = "csnip_early_backgrounds"
		if(CSNIP_ADULT_BACKGROUND)
			to_use = adult_backgrounds
			feature_key = "csnip_adult_backgrounds"
	// format: list(/datum/character_snippet, /datum/character_snippet, etc)
	var/list/csnip_paths = dna.features[feature_key]
	if(!LAZYLEN(csnip_paths))
		return null // no csnip paths, so no text
	var/list/translated = list()
	for(var/datum/character_snippet/csnip_datum in csnip_paths)
		var/message = csnip_datum.get_desc_text(haver)
		message = span_class(spans["[which]"], message)
		translated += message
	var/sep = htmld ? "<br>" : "\n"
	var/thething = translated.Join(sep)
	return thething






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
