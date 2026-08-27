
/*
 * CS (Character Snippet) System
 * A system for attaching certain descriptors to characters, describing their characters with character descriptors.
 * Shows up in examine! Most of them at least!
 *
 * ANATOMY OF A Character Snippet
 * Tokenized for dynamic pronoun and verb form replacement.
 * - "$THEY $LOOK like $THEYD | enjoy taking $THEIR time riding $THEIR wife into work."
 * - "$THEY $SEEM like the sort to | like to eat $THEIR favorite friends."
 * This allows the system to dynamically adjust the text based on the character's pronouns and verb forms.
 * The "|" character delineates what is the main clause from the additional descriptive clause.
 * For the purpose of colorization! also its gotta be there
 * it also supports stringing multiple descriptors together! sorta
 * also if theres no init_desc, it just uses the desc field and verbifies that
 *
 *  */

/datum/character_snippet
	var/category_csnip = CSNIP_TEMPERAMENT
	var/subcategory_csnip
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
	var/list/cached = list()
	abstract_type = /datum/character_snippet

/datum/character_snippet/New()
	if(init_desc)
		var/list/prepost = splittext(init_desc, "|")
		preamble = trim(prepost[1])
		main_clause = trim(prepost[2])
	. = ..()

/datum/character_snippet/proc/get_desc_text(mob/haver)
	if(cached[haver.gender])
		return cached[haver.gender]
	if(!preamble || !main_clause)
		return verbulate(haver, desc)
	var/list/verbified = verbulate(haver)
	if(preamble_text_color)
		verbified[1] = "<color=" + preamble_text_color + ">" + verbified[1] + "</color>"
	if(main_clause_text_color)
		verbified[2] = "<color=" + main_clause_text_color + ">" + verbified[2] + "</color>"
	cached[haver.gender] = "[verbified[1]] [verbified[2]]"
	return cached[haver.gender]

/datum/character_snippet/proc/get_example(gendre, nombre = "Cutie Cat")
	var/mob/living/carbon/human/pretend
	switch(gendre)
		if(MALE)
			pretend = SSdans_cool_prefs.cutie_cats[MALE]
		if(FEMALE)
			pretend = SSdans_cool_prefs.cutie_cats[FEMALE]
		else
			pretend = SSdans_cool_prefs.cutie_cats[PLURAL]
	pretend.name = nombre
	return get_desc_text(pretend)

/datum/character_snippet/proc/verbulate(mob/haver, override)
	if(override)
		override = verbify(haver, override)
		return override
	var/preamble_treated = verbify(haver, preamble)
	var/main_clause_treated = verbify(haver, main_clause)
	return list(
		preamble_treated,
		main_clause_treated
	)

/datum/csnip_verbset
	var/verbset_token
	var/male_form
	var/female_form
	var/nonbinary_form
	/// if a verb has a multi-word form, check this first to see if it applies instead
	abstract_type = /datum/csnip_verbset

/datum/csnip_verbset/proc/replace_token(tex, mob/haver)
	return replacetextEx(tex, verbset_token, get_form(haver))

/datum/csnip_verbset/proc/get_form(mob/haver)
	switch(haver.gender)
		if(MALE)
			return male_form
		if(FEMALE)
			return female_form
		if(PLURAL)
			return nonbinary_form
		else
			return nonbinary_form

/datum/csnip_verbset/they
	verbset_token = "$THEY"
	male_form = "he"
	female_form = "she"
	nonbinary_form = "they"

/datum/csnip_verbset/theyd
	verbset_token = "$THEYD"
	male_form = "he'd"
	female_form = "she'd"
	nonbinary_form = "they'd"

/datum/csnip_verbset/their
	verbset_token = "$THEIR"
	male_form = "his"
	female_form = "her"
	nonbinary_form = "their"

/datum/csnip_verbset/them
	verbset_token = "$THEM"
	male_form = "him"
	female_form = "her"
	nonbinary_form = "them"

/datum/csnip_verbset/themself
	verbset_token = "$THEYSELF"
	male_form = "himself"
	female_form = "herself"
	nonbinary_form = "themself"

/datum/csnip_verbset/theyre
	verbset_token = "$THEYRE"
	male_form = "he's"
	female_form = "she's"
	nonbinary_form = "they're"

/datum/csnip_verbset/look
	verbset_token = "$LOOK"
	male_form = "looks"
	female_form = "looks"
	nonbinary_form = "look"

/datum/csnip_verbset/seem
	verbset_token = "$SEEM"
	male_form = "seems"
	female_form = "seems"
	nonbinary_form = "seem"

/datum/csnip_verbset/appear
	verbset_token = "$APPEAR"
	male_form = "appears"
	female_form = "appears"
	nonbinary_form = "appear"

/datum/csnip_verbset/present
	verbset_token = "$PRESENT"
	male_form = "presents"
	female_form = "presents"
	nonbinary_form = "present"

/datum/csnip_verbset/give
	verbset_token = "$GIVE"
	male_form = "gives"
	female_form = "gives"
	nonbinary_form = "give"

/datum/csnip_verbset/like
	verbset_token = "$LIKE"
	male_form = "likes"
	female_form = "likes"
	nonbinary_form = "like"

/datum/csnip_verbset/want
	verbset_token = "$WANT"
	male_form = "wants"
	female_form = "wants"
	nonbinary_form = "want"

/datum/csnip_verbset/need
	verbset_token = "$NEED"
	male_form = "needs"
	female_form = "needs"
	nonbinary_form = "need"

/datum/csnip_verbset/have
	verbset_token = "$HAVE"
	male_form = "has"
	female_form = "has"
	nonbinary_form = "have"

/datum/csnip_verbset/do
	verbset_token = "$DO"
	male_form = "does"
	female_form = "does"
	nonbinary_form = "do"

/datum/csnip_verbset/dont
	verbset_token = "$DONT"
	male_form = "doesn't"
	female_form = "doesn't"
	nonbinary_form = "don't"

/datum/csnip_verbset/are
	verbset_token = "$ARE"
	male_form = "is"
	female_form = "is"
	nonbinary_form = "are"

/datum/csnip_verbset/species
	verbset_token = "$SPECIES"
	// this is a special one, it just returns the species name of the mob

/datum/csnip_verbset/species/get_form(mob/haver)
	if(!ishuman(haver))
		return "critter"
	var/spename = get_species_name(haver)
	if(findtext(spename, "human"))
		switch(haver.gender)
			if(MALE)
				spename = "guy"
			if(FEMALE)
				spename = "gal"
			if(PLURAL)
				spename = "critter"
	return spename

/datum/csnip_verbset/nombre
	verbset_token = "$NAME"

/datum/csnip_verbset/nombre/get_form(mob/haver)
	. = "Iosef Mama" // it rantimed
	if(!ismob(haver))
		return "Joe Joename"
	return haver.name

/datum/csnip_verbset/prefs_nombre
	verbset_token = "$PREFS_NAME"

/datum/csnip_verbset/prefs_nombre/get_form(mob/haver)
	. = "Iosef Mama" // it rantimed
	if(!haver.client || !haver.client.prefs)
		return "Joe Joename"
	var/datum/prefs_holder/prefs = haver.client.prefs
	return prefs.read_preference(/datum/preference/name/real_name) || "Joe Joename"
