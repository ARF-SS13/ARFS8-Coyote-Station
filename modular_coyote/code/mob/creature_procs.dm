/// Quickly check if this mob's species is considered feral. Will skip most icon generation and switch to a simpler icon render instead of the typical humanoid one.
/mob/living/carbon/proc/IsFeral()
	return HAS_TRAIT(src, TRAIT_FERAL)

/mob/living/proc/UpdateFeralBody()
	return

/mob/living/carbon/UpdateFeralBody()
	if(!IsFeral())
		return
	var/datum/species/my_species = dna?.species
	if(!my_species)
		return

	var/prefix
	if(LAZYLEN(my_species.alt_prefixes))
		prefix = my_species.alt_prefixes?[dna?.alt_appearance]//Try to access the alternate sprite that was copied from the preferences onto their dna
	if(prefix == "Default" || isnull(prefix))
		prefix = ""
	rotate_on_lying = my_species.rotate_on_lying
	var/i_state
	var/mycolor = "FFFFFF"
	var/my_mid = my_species.simple_icon_state || my_species.id
	if(stat == DEAD)
		i_state = "[prefix][my_mid][my_species.icon_dead_suffix]"
	else if(resting || stat || HAS_TRAIT(src, list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_FLOORED)))//Not dead but can't stand up or resting
		i_state = "[prefix][my_mid][my_species.icon_rest_suffix]"
	else
		i_state = "[prefix][my_mid]"

	if(HAS_TRAIT(src, TRAIT_MUTANT_COLORS))
		mycolor = client?.prefs?.features?["mcolor"]
		if(isnull(mycolor))
			mycolor = dna?.features?["mcolor"]
	var/mutable_appearance/my_sprite = mutable_appearance(my_species.simple_icon, i_state, BODYPARTS_LAYER, color = "#[mycolor]")
	//Recentering
	if(isnull(my_species.icon_width))//Their icon_width isn't set so get it now!
		var/icon/I = icon(my_species.simple_icon)
		my_species.icon_width = I.Width()
	if(my_species.icon_width != 32)//We need to recenter!
		my_sprite.pixel_x += -((my_species.icon_width-32)/2)
	remove_overlay(BODYPARTS_LAYER)
	overlays_standing[BODYPARTS_LAYER] = my_sprite
	/*
	if (my_species.slime_mood)
		var/mutable_appearance/sf = mutable_appearance ('icons/mob/slimes.dmi', my_species.slime_mood, BODYPARTS_LAYER) //Slime face
		overlays_standing[BODYPARTS_LAYER] += sf
	*/
	apply_overlay(BODYPARTS_LAYER)
