/// FORMAT: list("/datum/character_snippet/<type>" = instantiated singleton of that)
GLOBAL_LIST_INIT(all_temperaments_and_builds_datums, init_tnb())//←═╕
// format: list(instantiated singleton of each /datum/tnb_verbset)  │
GLOBAL_LIST_INIT(all_verbsets, init_verbsets()) // set by ╞═══════════not really
GLOBAL_DATUM_INIT(cutie_cat_boy, /mob/living/carbon/human/cutiecat, new(null)) // cutie cat who lives in nullspace
GLOBAL_DATUM_INIT(cutie_cat_girl, /mob/living/carbon/human/cutiecat/girl, new(null)) // cutie cat who lives in nullspace
GLOBAL_DATUM_INIT(cutie_cat_nb, /mob/living/carbon/human/cutiecat/nb, new(null)) // cutie cat who lives in nullspace

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

/datum/character_snippet
	var/category_csnip = CSNIP_TEMPERAMENT
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
	/// is this tnb_cat part of a set? this is the set key to swap out
	var/set_key = ""
	/// order for sorting in the menu, lower is higher
	var/order = 0
	abstract_type = /datum/character_snippet

/datum/character_snippet/New()
	var/list/prepost = splittext(init_desc, "|")
	preamble = trim(prepost[1])
	main_clause = trim(prepost[2])
	. = ..()

/datum/character_snippet/proc/get_desc_text(mob/haver)
	var/list/verbified = verbify(haver)
	if(preamble_text_color)
		verbified[1] = "<color=" + preamble_text_color + ">" + verbified[1] + "</color>"
	if(main_clause_text_color)
		verbified[2] = "<color=" + main_clause_text_color + ">" + verbified[2] + "</color>"
	return "[verbified[1]] [verbified[2]]"

/datum/character_snippet/proc/get_example(gendre, nombre = "Cutie Cat")
	switch(gendre)
		if(MALE)
			GLOB.cutie_cat_boy.name = nombre
			return get_desc_text(GLOB.cutie_cat_boy)
		if(FEMALE)
			GLOB.cutie_cat_girl.name = nombre
			return get_desc_text(GLOB.cutie_cat_girl)
		else
			GLOB.cutie_cat_nb.name = nombre
			return get_desc_text(GLOB.cutie_cat_nb)

/datum/character_snippet/proc/verbify(mob/haver)
	var/preamble_treated = preamble
	var/main_clause_treated = main_clause
	for(var/datum/tnb_verbset/verbset in GLOB.all_verbsets)
		var/form = verbset.get_form(haver.gender, haver)
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

/datum/tnb_verbset/proc/get_form(gend, mob/haver)
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

/datum/tnb_verbset/look
	verbset_token = "$LOOK"
	male_form = "looks"
	female_form = "looks"
	nonbinary_form = "look"

/datum/tnb_verbset/seem
	verbset_token = "$SEEM"
	male_form = "seems"
	female_form = "seems"
	nonbinary_form = "seem"

/datum/tnb_verbset/appear
	verbset_token = "$APPEAR"
	male_form = "appears"
	female_form = "appears"
	nonbinary_form = "appear"

/datum/tnb_verbset/present
	verbset_token = "$PRESENT"
	male_form = "presents"
	female_form = "presents"
	nonbinary_form = "present"

/datum/tnb_verbset/give
	verbset_token = "$GIVE"
	male_form = "gives"
	female_form = "gives"
	nonbinary_form = "give"

/datum/tnb_verbset/like
	verbset_token = "$LIKE"
	male_form = "likes"
	female_form = "likes"
	nonbinary_form = "like"

/datum/tnb_verbset/want
	verbset_token = "$WANT"
	male_form = "wants"
	female_form = "wants"
	nonbinary_form = "want"

/datum/tnb_verbset/need
	verbset_token = "$NEED"
	male_form = "needs"
	female_form = "needs"
	nonbinary_form = "need"

/datum/tnb_verbset/have
	verbset_token = "$HAVE"
	male_form = "has"
	female_form = "has"
	nonbinary_form = "have"

/datum/tnb_verbset/do
	verbset_token = "$DO"
	male_form = "does"
	female_form = "does"
	nonbinary_form = "do"

/datum/tnb_verbset/dont
	verbset_token = "$DONT"
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

/datum/tnb_verbset/species/get_form(gend, mob/haver)
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
