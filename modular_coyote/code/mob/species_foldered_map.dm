GLOBAL_LIST_INIT(species_foldered_map, generate_foldered_species_map())

/// so. we have species, and some of those species are actually categories of species
/// for instance, "pocketmasters" is a category of species, of like crumblesaurs and binguloths and
/// something like vululutions are a subcategory of species within that category.
/// This creates a nightmarish map of species that are foldered into categories, and subcategories, and subsubcategories, etc.
/proc/generate_foldered_species_map()
	// format:
	// s_map = list(
	//   /datum/species = TRUE, //species that are not in a category
	//   /datum/species/category = list(
	//     /datum/species/category/subcategory = list(
	//       /datum/species/category/subcategory/subsubcategory = list(
	//         /datum/species/category/subcategory/subsubcategory/species = new this thing
	//       )
	//     )
	//   )
	// )
	var/list/s_map = list()
	for(var/datum/species/yif as anything in subtypesof(/datum/species))
		var/cat = yif::category
		var/subcat = yif::sub_category
		var/subsubcat = yif::sub_sub_category
		if(cat)
			if(!cat[cat])
				cat[cat] = list()
			if(subcat)
				if(!cat[cat][subcat])
					cat[cat][subcat] = list()
				if(subsubcat)
					if(!cat[cat][subcat][subsubcat])
						cat[cat][subcat][subsubcat] = list()
					cat[cat][subcat][subsubcat][yif] = new yif
				else
					cat[cat][subcat][yif] = new yif
			else
				cat[cat][yif] = new yif
		else
			s_map[yif] = new yif

	return s_map

/proc/speciespath2map(datum/species/spec)
	var/list/out = list(
		"slot_1" = "nothing",
		"slot_2" = "nothing",
		"slot_3" = "nothing",
		"default_species" = "nothing"
	)
	var/datum/species/ultimate = spec::type
	if(!spec::category)
		out["slot_1"] = ultimate
		return out
	var/datum/species/category = spec::category
	if(!category::sub_category)
		out["slot_1"] = category
		out["slot_2"] = ultimate
		out["default_species"] = category::default_species
		return out
	var/datum/species/sub_category = spec::sub_category
	if(!sub_category::sub_sub_category)
		out["slot_1"] = category
		out["slot_2"] = sub_category
		out["slot_3"] = ultimate
		out["default_species"] = sub_category::default_species
	return out

/proc/speciespath2map_ids(datum/species/spec)
	var/list/out = speciespath2map(spec)
	for(var/i in out)
		if(out[i])
			var/datum/species/s = out[i]
			out[i] = s::id
	return out






