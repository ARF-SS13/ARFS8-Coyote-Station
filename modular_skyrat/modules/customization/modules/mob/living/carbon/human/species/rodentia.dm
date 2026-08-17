/datum/species/rodentia
	name = "Rodentia" //Concept pulled from SS14.  Love you Chokovit. <3 ~Fenny
	id = SPECIES_RODENTIA
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_MUTANT_COLORS,
		TRAIT_SENSITIVESNOUT,
		TRAIT_MURIDAE,
		TRAIT_TRASHCAN,
		TRAIT_LIGHT_STEP,
		TRAIT_STRONG_STOMACH,
		TRAIT_NIGHT_VISION,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	inherent_factions = list(FACTION_RAT)
	mutant_bodyparts = list()
	damage_modifier = -10 //This is because they're like bananas, and die like skaven. :)
	mutanttongue = /obj/item/organ/tongue/mouse // also they fit in interesting places =3
	payday_modifier = 1.0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant,
	)
	sort_bottom = TRUE //BUBBER EDIT ADDITION: We want to sort this to the bottom because it's a custom species template.
	var/datum/action/cooldown/spell/sniff/food_sniff

/datum/species/rodentia/on_species_gain(mob/living/carbon/newrat, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(ishuman(newrat))
		food_sniff = new
		food_sniff.Grant(newrat)

/datum/species/rodentia/on_species_loss(mob/living/carbon/newrat, datum/species/new_species, pref_load)

	if(food_sniff)
		food_sniff.Remove(newrat)
	return ..()

/datum/species/rodentia/get_default_mutant_bodyparts()
	return list(
		"tail"      = list(/datum/sprite_accessory/tails/mammal/wagging/murid::name, FALSE),
		"snout"     = list(/datum/sprite_accessory/snouts/splurt/rodentthick::name, TRUE),
		"ears"      = list(/datum/sprite_accessory/ears/mutant/murid::name, TRUE),
		"legs"      = list(DIGITIGRADE_LEGS, FALSE),
		"horns"     = list("None", FALSE),
		"taur"      = list("None", FALSE),
		"fluff"     = list("None", FALSE),
		"wings"     = list("None", FALSE),
		"head_acc"  = list("None", FALSE),
		"neck_acc"  = list("None", FALSE),
	)

/datum/species/rodentia/randomize_features()
	var/list/features = ..()
	var/main_color = "#FFFFFF"
	var/second_color = "#b8b8b8"
	var/third_color = "#4D4D4D"
	features[FEATURE_MUTANT_COLOR] = main_color
	features[FEATURE_MUTANT_COLOR_TWO] = second_color
	features[FEATURE_MUTANT_COLOR_THREE] = third_color
	return features

/datum/species/rodentia/get_random_body_markings(list/passed_features)
	var/name = SPRITE_ACCESSORY_NONE
	var/list/candidates = GLOB.body_marking_sets.Copy()
	for(var/candi in candidates)
		var/datum/body_marking_set/setter = GLOB.body_marking_sets[candi]
		if(setter.recommended_species && !(id in setter.recommended_species))
			candidates -= candi
	if(length(candidates))
		name = pick(candidates)
	var/datum/body_marking_set/BMS = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(BMS)
		markings = assemble_body_markings_from_set(BMS, passed_features, src)
	return markings

/datum/species/rodentia/get_species_description()
	return list("A cute \[citation needed\] rodent!")

/datum/species/rodentia/get_species_lore()
	return list("Make sure you fill out your own custom species lore!")

/datum/species/rodentia/prepare_human_for_preview(mob/living/carbon/human/human)
	var/main_color = "#FFFFFF"
	var/secondary_color = "#e7c0e9"
	human.dna.features[FEATURE_MUTANT_COLOR] = main_color
	human.dna.features[FEATURE_MUTANT_COLOR_TWO] = secondary_color
	human.dna.features[FEATURE_MUTANT_COLOR_THREE] = secondary_color
	human.dna.mutant_bodyparts[FEATURE_EARS] = list(
		MUTANT_INDEX_NAME = /datum/sprite_accessory/ears/mutant/murid::name,
		MUTANT_INDEX_COLOR_LIST = list(main_color, secondary_color, "#4D4D4D")
		)
	human.dna.mutant_bodyparts[FEATURE_SNOUT] = list(
		MUTANT_INDEX_NAME = /datum/sprite_accessory/snouts/splurt/rodentthick::name,
		MUTANT_INDEX_COLOR_LIST = list(main_color, secondary_color, secondary_color)
		)
	human.dna.mutant_bodyparts[FEATURE_TAIL_GENERIC] = list(
		MUTANT_INDEX_NAME = /datum/sprite_accessory/tails/mammal/wagging/murid::name,
		MUTANT_INDEX_COLOR_LIST = list(main_color, "#e9c9e5", secondary_color)
		)
	regenerate_organs(human, src, visual_only = TRUE)
	human.update_body(TRUE)

/datum/species/rodentia/create_pref_unique_perks()
	var/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "paw",
		SPECIES_PERK_NAME = "Light Step",
		SPECIES_PERK_DESC = "Light on their toes, Rodentia don't make a lot of noise generally. At least not from moving!",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "utensils",
		SPECIES_PERK_NAME = "Tough Stomach",
		SPECIES_PERK_DESC = "Hard times call for hard choices. Rodentia can stomach more things that would make the compactor cringe.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "eye",
		SPECIES_PERK_NAME = "Low-Light Vision",
		SPECIES_PERK_DESC = "Rodentia have big eyes and are very good at seeing in low light environments.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "cheese",
		SPECIES_PERK_NAME = "Muridae Traits",
		SPECIES_PERK_DESC = "Rodentia, due to their incisors, have a very specific cadence and form of speach.  It's really quite grating.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "trash",
		SPECIES_PERK_NAME = "Trash Diet",
		SPECIES_PERK_DESC = "Rodentia are survivors. They can eat just about anything no one else would really want to - as long as its not poisonous.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "box-tissue",
		SPECIES_PERK_NAME = "Sensitive Snout",
		SPECIES_PERK_DESC = "Rodentia have very sensitive snouts, be gentle!",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "heart-pulse",
		SPECIES_PERK_NAME = "Easily Hurt",
		SPECIES_PERK_DESC = "Rodentia are well known for being a bit easily hurt. Their frames just aren't very robust.",
	))

	return to_add
