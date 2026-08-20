/// FORMAT: list("/datum/temperament_build/<type>" = instantiated singleton of that)
GLOBAL_LIST_INIT(all_temperaments_and_builds_datums, init_tnb())//←═╕
// format: list(instantiated singleton of each /datum/tnb_verbset)  │
GLOBAL_LIST_EMPTY(all_verbsets) // set by ╞═════════════════════════╛
GLOBAL_DATUM_INIT(cutie_cat_boy, /mob/living/carbon/human/cutiecat, new(null)) // cutie cat who lives in nullspace
GLOBAL_DATUM_INIT(cutie_cat_girl, /mob/living/carbon/human/cutiecat/girl, new(null)) // cutie cat who lives in nullspace
GLOBAL_DATUM_INIT(cutie_cat_nb, /mob/living/carbon/human/cutiecat/nb, new(null)) // cutie cat who lives in nullspace

/proc/init_tnb()
	GLOB.all_temperaments_and_builds_datums = list()
	for(var/tnb_path in typesof(/datum/temperament_build))
		var/datum/temperament_build/tnb_path_pro = tnb_path
		if(tnb_path_pro == tnb_path_pro::abstract_type)
			continue
		GLOB.all_temperaments_and_builds_datums["[tnb_path_pro]"] = new tnb_path_pro()

	GLOB.all_verbsets = list()
	for(var/tnb_verbset_path in typesof(/datum/tnb_verbset))
		var/datum/tnb_verbset/tnb_verbset_pro = tnb_verbset_path
		if(tnb_verbset_pro == tnb_verbset_pro::abstract_type)
			continue
		GLOB.all_verbsets += new tnb_verbset_pro()

/proc/get_mob_tnb_text(mob/haver)
	if(!ishuman(haver))
		return list()
	var/mob/living/carbon/human/humaver = haver
	var/list/tnb_paths = humaver?.dna?.features["temperaments_and_builds"]
	if(!LAZYLEN(tnb_paths))
		return list()
	// divy into T and B datums
	var/list/temperaments = list()
	var/list/builds = list()
	for(var/tnb in tnb_paths)
		var/datum/temperament_build/tnb_datum = GLOB.all_temperaments_and_builds_datums["[tnb]"]
		if(!tnb_datum)
			continue
		switch(tnb_datum.tnb_type)
			if(TNB_TEMPERAMENT)
				temperaments += tnb_datum
			if(TNB_BUILD)
				builds += tnb_datum
	var/list/translated = list()
	translated["temperaments"] = list(temperaments)
	translated["builds"] = list(builds)
	return translated

/mob/living/carbon/human/cutiecat
	name = "Mr. Cutie Cat"
	gender = MALE

/mob/living/carbon/human/cutiecat/Initialize(mapload)
	randomize_species()
	. = ..()

/mob/living/carbon/human/cutiecat/proc/create_dna()
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

/proc/get_mob_tnb_paths(mob/haver)
	if(!ishuman(haver))
		return list()
	var/mob/living/carbon/human/humaver = haver
	var/list/tnb_paths = humaver?.dna?.features["temperaments_and_builds"]
	if(!LAZYLEN(tnb_paths))
		return list()
	return tnb_paths


/*
 * TNB (Temperament and Build)
 * A system for attaching certain descriptors to characters, describing their temperament and build.
 * Shows up in examine!
 *
 * ANATOMY OF A TEMPERAMENT AND BUILD
 * Tokenized for dynamic pronoun and verb form replacement.
 * - "$THEY $LOOK like $THEYD | enjoy taking $THEIR time riding $THEIR wife into work."
 * - "$THEY $SEEM like the sort to | like to eat $THEIR favorite friends."
 * This allows the system to dynamically adjust the text based on the character's pronouns and verb forms.
 * The "|" character delineates what is the main clause from the additional descriptive clause.
 * For the purpose of colorization! also its gotta be there
 * it also supports stringing multiple descriptors together! sorta
 *
 *  */

/datum/temperament_build
	var/tnb_type = TNB_TEMPERAMENT
	/// the display name of the temperament or build, in prefs
	var/name = ""
	/// description for the menu thing
	var/desc = ""
	/// pre-separated whole thing
	var/init_desc = ""
	/// the textual description of the temperament or build
	var/preamble = ""
	/// the textual description of the temperament or build
	var/main_clause = ""
	/// preamble text color, if blank then it just doesnt "FFFFFF"
	var/preamble_text_color
	/// the main clause text color, if blank then it just doesnt "FFFFFF"
	var/main_clause_text_color
	abstract_type = /datum/temperament_build

/datum/temperament_build/New()
	var/list/prepost = splittext(init_desc, "|")
	preamble = trim(prepost[1])
	main_clause = trim(prepost[2])
	. = ..()

/datum/temperament_build/proc/get_desc_text(mob/haver)
	var/list/verbified = verbify(haver)
	if(preamble_text_color)
		verbified[1] = "<color=" + preamble_text_color + ">" + verbified[1] + "</color>"
	if(main_clause_text_color)
		verbified[2] = "<color=" + main_clause_text_color + ">" + verbified[2] + "</color>"
	return "[verbified[1]] [verbified[2]]"

/datum/temperament_build/proc/get_example()
	return get_desc_text(pick(GLOB.cutie_cat_boy, GLOB.cutie_cat_girl, GLOB.cutie_cat_nb))

/datum/temperament_build/proc/verbify(mob/haver)
	var/preamble_treated = preamble
	var/main_clause_treated = main_clause
	for(var/datum/tnb_verbset/verbset in GLOB.all_verbsets)
		var/form = verbset.get_form(haver.gender)
		preamble_treated = replacetextEx(preamble_treated, verbset.verbset_token, form)
		main_clause_treated = replacetextEx(main_clause_treated, verbset.verbset_token, form)
	return list(
		preamble_treated,
		main_clause_treated
	)


/datum/tnb_verbset
	var/verbset_token
	var/male_form
	var/female_form
	var/nonbinary_form
	/// if a verb has a multi-word form, check this first to see if it applies instead
	var/datum/tnb_verbset/check_first
	abstract_type = /datum/tnb_verbset

/datum/tnb_verbset/proc/get_form(gend)
	switch(gend)
		if(MALE)
			return male_form
		if(FEMALE)
			return female_form
		if(PLURAL)
			return nonbinary_form
		else
			return nonbinary_form

/datum/tnb_verbset/they
	verbset_token = "$THEY"
	male_form = "he"
	female_form = "she"
	nonbinary_form = "they"

/datum/tnb_verbset/theyd
	verbset_token = "$THEYD"
	male_form = "he'd"
	female_form = "she'd"
	nonbinary_form = "they'd"

/datum/tnb_verbset/their
	verbset_token = "$THEIR"
	male_form = "his"
	female_form = "her"
	nonbinary_form = "their"

/datum/tnb_verbset/them
	verbset_token = "$THEM"
	male_form = "him"
	female_form = "her"
	nonbinary_form = "them"

/datum/tnb_verbset/themself
	verbset_token = "$THEYSELF"
	male_form = "himself"
	female_form = "herself"
	nonbinary_form = "themself"

/datum/tnb_verbset/theyre
	verbset_token = "$THEYRE"
	male_form = "he's"
	female_form = "she's"
	nonbinary_form = "they're"

/datum/tnb_verbset/looks
	verbset_token = "$LOOKS"
	male_form = "looks"
	female_form = "looks"
	nonbinary_form = "look"

/datum/tnb_verbset/seems
	verbset_token = "$SEEMS"
	male_form = "seems"
	female_form = "seems"
	nonbinary_form = "seem"

/datum/tnb_verbset/appears
	verbset_token = "$APPEARS"
	male_form = "appears"
	female_form = "appears"
	nonbinary_form = "appear"

/datum/tnb_verbset/presents
	verbset_token = "$PRESENTS"
	male_form = "presents"
	female_form = "presents"
	nonbinary_form = "present"

/datum/tnb_verbset/gives
	verbset_token = "$GIVES"
	male_form = "gives"
	female_form = "gives"
	nonbinary_form = "give"

/datum/tnb_verbset/likes
	verbset_token = "$LIKES"
	male_form = "likes"
	female_form = "likes"
	nonbinary_form = "like"

/datum/tnb_verbset/wants
	verbset_token = "$WANTS"
	male_form = "wants"
	female_form = "wants"
	nonbinary_form = "want"

/datum/tnb_verbset/needs
	verbset_token = "$NEEDS"
	male_form = "needs"
	female_form = "needs"
	nonbinary_form = "need"

/datum/tnb_verbset/has
	verbset_token = "$HAS"
	male_form = "has"
	female_form = "has"
	nonbinary_form = "have"

/datum/tnb_verbset/does
	verbset_token = "$DOES"
	male_form = "does"
	female_form = "does"
	nonbinary_form = "do"

/datum/tnb_verbset/doesnt
	verbset_token = "$DOESNT"
	male_form = "doesn't"
	female_form = "doesn't"
	nonbinary_form = "don't"

/datum/tnb_verbset/are
	verbset_token = "$ARE"
	male_form = "is"
	female_form = "is"
	nonbinary_form = "are"

/datum/tnb_verbset/species
	verbset_token = "$SPECIES"
	// this is a special one, it just returns the species name of the mob

/datum/tnb_verbset/species/proc/get_form(gend, mob/haver)
	if(!ishuman(haver))
		return "critter"
	var/spename = get_species_name(haver)
	if(findtext(spename, "human"))
		switch(gend)
			if(MALE)
				spename = "guy"
			if(FEMALE)
				spename = "gal"
			if(PLURAL)
				spename = "critter"
	return spename
