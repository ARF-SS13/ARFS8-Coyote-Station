/// Quickly check if this mob's species is considered feral. Will skip most icon generation and switch to a simpler icon render instead of the typical humanoid one.
/mob/living/carbon/proc/IsFeral()
	if(HAS_TRAIT(src, TRAIT_FERAL))
		return TRUE
	return FALSE
/mob/living/proc/UpdateFeralBody()
	return
/mob/living/carbon/UpdateFeralBody()
	if(!IsFeral())
		return
	var/datum/species/S = dna?.species
	if(!S)
		return
	var/prefix
	if(LAZYLEN(S.alt_prefixes))
		prefix = S.alt_prefixes?[dna?.alt_appearance]//Try to access the alternate sprite that was copied from the preferences onto their dna
	if(prefix == "Default" || isnull(prefix))
		prefix = ""
	rotate_on_lying = S.rotate_on_lying
	var/i_state
	var/mycolor
	if(stat == DEAD)
		i_state = "[prefix][S.id][S.icon_dead_suffix]"
	else if(resting || stat || HAS_TRAIT(src, list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_FLOORED)))//Not dead but can't stand up or resting
		i_state = "[prefix][S.id][S.icon_rest_suffix]"
	else
		i_state = "[prefix][S.id]"
	if(HAS_TRAIT(src, TRAIT_MUTANT_COLORS))
		mycolor = client?.prefs?.features?["mcolor"]
		if(isnull(mycolor))
			mycolor = dna?.features?["mcolor"]
	var/mutable_appearance/F = mutable_appearance(S.simple_icon, i_state, BODYPARTS_LAYER, color = "#[mycolor]")
	//Recentering
	if(isnull(S.icon_width))//Their icon_width isn't set so get it now!
		var/icon/I = icon(S.simple_icon)
		S.icon_width = I.Width()
	if(S.icon_width != 32)//We need to recenter!
		F.pixel_x += -((S.icon_width-32)/2)
	remove_overlay(BODYPARTS_LAYER)
	overlays_standing[BODYPARTS_LAYER] = F
	/*
	if (S.slime_mood)
		var/mutable_appearance/sf = mutable_appearance ('icons/mob/slimes.dmi', S.slime_mood, BODYPARTS_LAYER) //Slime face
		overlays_standing[BODYPARTS_LAYER] += sf
	*/
	apply_overlay(BODYPARTS_LAYER)
