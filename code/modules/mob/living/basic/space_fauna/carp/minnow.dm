/mob/living/basic/carp/minnow
	name = "space minnow"
	desc = "A smaller breed of space carp, known for attacking solar cables."
	icon = 'icons/mob/simple/carp.dmi'
	icon_state = "minnow"
	icon_living = "minnow"
	icon_dead = "minnow_dead"
	greyscale_config = null
	health = 15
	maxHealth = 15
	max_stamina = 80
	obj_damage = 50
	melee_damage_lower = 5
	melee_damage_upper = 10
	butcher_results = list(/obj/item/food/fishmeat/carp = 1, /obj/item/stack/sheet/animalhide/carp = 1)
	var/cable_zap_prob = 85
	ai_controller = /datum/ai_controller/basic_controller/carp/minnow

/mob/living/basic/carp/minnow/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	. = ..()
	if(!.)
		return

	if(!proximity_flag)
		return

	if(istype(attack_target, /obj/structure/cable))
		try_bite_cable(attack_target)
		return TRUE

/// Biting into a cable will cause a mouse to get shocked and die if applicable. Or do nothing if they're lucky.
/mob/living/basic/carp/minnow/proc/try_bite_cable(obj/structure/cable/cable)
	if(cable.avail() && !HAS_TRAIT(src, TRAIT_SHOCKIMMUNE) && prob(cable_zap_prob))
		visible_message(
			span_warning("[src] chews through \the [cable]. It's toast!"),
			span_userdanger("As you bite deeply into [cable], you suddenly realize this may have been a bad idea."),
			span_hear("You hear electricity crack."),
		)
		// Finely toasted
		ADD_TRAIT(src, TRAIT_BEING_SHOCKED, TRAIT_GENERIC)
		// Unfortunately we can't check the return value of electrocute_act before displaying a message,
		// as it's possible the damage from electrocution results in our hunter being deleted.
		// But what are the odds of the shock failing? Hahaha...
		electrocute_act(maxHealth * 2, cable, flags = SHOCK_SUPPRESS_MESSAGE)

	else
		visible_message(
			span_warning("[src] chews through \the [cable]."),
			span_notice("You chew through \the [cable]."),
		)

	playsound(cable, 'sound/effects/sparks/sparks2.ogg', 100, TRUE)
	cable.deconstruct()

/datum/ai_controller/basic_controller/carp/minnow
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic/not_friends,
		BB_BASIC_MOB_FLEE_DISTANCE = 3,
		BB_TARGET_PRIORITY_TRAIT = TRAIT_SCARY_FISHERMAN,
		BB_CARPS_FEAR_FISHERMAN = TRUE,
	)
	ai_traits = PASSIVE_AI_FLAGS
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/find_target_prioritize_traits,
		/datum/ai_planning_subtree/make_carp_rift/panic_teleport,
		/datum/ai_planning_subtree/flee_target/from_fisherman,
		/datum/ai_planning_subtree/attack_obstacle_in_path/carp,
		/datum/ai_planning_subtree/shortcut_to_target_through_carp_rift,
		/datum/ai_planning_subtree/make_carp_rift/aggressive_teleport,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/no_fisherman,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/carp_migration,
		/datum/ai_planning_subtree/find_and_hunt_target/look_for_cables/minnow,
	)

/datum/ai_planning_subtree/find_and_hunt_target/look_for_cables/minnow
	hunt_range = 4
