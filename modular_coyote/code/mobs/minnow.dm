
/mob/living/basic/carp/minnow
	name = "space minnow"
	desc = "A smaller breed of space carp, known for attacking solar cables. \
		Generally harmless, but they hunger for electrical cabling! Beware, minnows and electricity \
		make for an explosive combination!"
	icon = 'icons/mob/simple/carp.dmi'
	icon_state = "minnow"
	icon_living = "minnow"
	icon_dead = "minnow_dead"
	icon_gib = "carp_gib"
	health = 15
	maxHealth = 15
	max_stamina = 80
	obj_damage = 20
	melee_damage_lower = 5
	melee_damage_upper = 10
	ai_controller = /datum/ai_controller/basic_controller/carp/minnow
	layer = TINY_CREATURE_LAYER
	pass_flags = MINNOW_CREATURE_PASS
	mob_size = MOB_SIZE_TINY
	greyscale_config = null
	rush = TRUE

	/// Probability that, if we successfully bite a shocked cable, that we will die to it.
	var/cable_zap_prob = 100

//Mouselike traits
/mob/living/basic/carp/minnow/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	. = ..()
	if(!.)
		return

	if(!proximity_flag)
		return

	if(istype(attack_target, /obj/structure/cable))
		var/turf/floorb = get_turf(attack_target)
		if(floorb && floorb.underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
			if(!isfloorturf(floorb))
				return
			var/turf/open/floor/open_floorb = floorb
			if(open_floorb.overfloor_placed)
				open_floorb.remove_tile(src, FALSE)
			return TRUE
		try_bite_cable(attack_target)
		return TRUE

/// Biting into a cable will cause a mouse to get shocked and die if applicable. Or do nothing if they're lucky.
/mob/living/basic/carp/minnow/proc/try_bite_cable(obj/structure/cable/cable)
	var/turf/here = get_turf(src)
	var/cavail = cable.avail()
	if(cavail && !HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		visible_message(
			span_warning("[src] chews through \the [cable] and fucking explodes! Holy shit!"),
			span_userdanger("As you bite deeply into [cable], you suddenly realize this may have been a bad idea."),
			span_hear("You hear electricity crack."),
		)
		AddComponent(/datum/component/pellet_cloud, projectile_type=/obj/projectile/bullet/pellet/bone_fragment, magnitude = 8)
		SEND_SIGNAL(src, COMSIG_HORRORFORM_EXPLODE)
		do_sparks(3, FALSE, here)
		cavail /= 15
		tesla_zap(
			cable,
			3,
			cavail,
			cavail * 0.5,
		)
		explosion(here, 0, 0, 1, 2, explosion_no_breach = TRUE)
		gib()

	else
		visible_message(
			span_warning("[src] chews through \the [cable]."),
			span_notice("You chew through \the [cable]."),
		)

	playsound(cable, 'sound/effects/sparks/sparks2.ogg', 100, TRUE)
	if(!QDELETED(cable))
		cable.deconstruct()
