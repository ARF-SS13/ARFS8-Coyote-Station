
/mob/living/basic/minnow
	name = "space carp"
	desc = "A smaller breed of space carp, known for attacking solar cables."
	icon = 'icons/mob/simple/carp.dmi'
	icon_state = "minnow"
	icon_living = "minnow"
	icon_dead = "minnow_dead"
	icon_gib = "carp_gib"
	gold_core_spawnable = HOSTILE_SPAWN
	mob_biotypes = MOB_ORGANIC | MOB_BEAST | MOB_AQUATIC
	health = 15
	maxHealth = 15
	max_stamina = 80
	pressure_resistance = 200
	combat_mode = TRUE
	obj_damage = 20
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_sound = 'sound/items/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	melee_attack_cooldown = 1.5 SECONDS
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	faction = list(FACTION_CARP)
	butcher_results = list(/obj/item/food/fishmeat/carp = 1, /obj/item/stack/sheet/animalhide/carp = 1)
	ai_controller = /datum/ai_controller/basic_controller/carp
	initial_language_holder = /datum/language_holder/carp
	habitable_atmos = null
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = 1500

	/// If true we will run away from attackers even at full health
	var/cowardly = FALSE
	/// Cytology cells you can swab from this creature
	var/cell_line = CELL_LINE_TABLE_CARP
	/// What colour is our 'healing' outline?
	var/regenerate_colour = COLOR_PALE_GREEN
	/// Ability which lets carp teleport around
	var/datum/action/cooldown/mob_cooldown/lesser_carp_rift/teleport
	/// Commands you can give this carp once it is tamed, not static because subtypes can modify it
	var/tamed_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
	)
	/// Probability that, if we successfully bite a shocked cable, that we will die to it.
	var/cable_zap_prob = 85
	/// Carp want to eat raw meat
	var/static/list/desired_food = list(/obj/item/food/meat/slab, /obj/item/food/meat/rawcutlet)
	/// Carp want to eat delicious six pack plastic rings
	var/static/list/desired_trash = list(/obj/item/storage/cans)
	/// Structures that AI carp are willing to attack. This prevents them from deconstructing supermatter cooling equipment.
	var/static/list/allowed_obstacle_targets = typecacheof(list(
		/obj/structure/closet,
		/obj/machinery/door,
		/obj/structure/door_assembly,
		/obj/structure/filingcabinet,
		/obj/structure/frame,
		/obj/structure/grille,
		/obj/structure/plasticflaps,
		/obj/structure/rack,
		/obj/structure/reagent_dispensers, // Carp can have a little welding fuel, as a treat
		/obj/structure/table,
		/obj/machinery/vending,
		/obj/structure/window,
	))

/datum/emote/minnow
	abstract_type = /datum/emote/minnow
	mob_type_allowed_typecache = /mob/living/basic/carp
	mob_type_blacklist_typecache = list()

/datum/emote/minnow
	key = "bloop"
	key_third_person = "bloops"
	message = "bloops!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/mob/living/basic/minnow/Initialize(mapload, mob/tamer)
	ADD_TRAIT(src, TRAIT_FREE_HYPERSPACE_MOVEMENT, INNATE_TRAIT) //Need to set before init cause if we init in hyperspace we get dragged before the trait can be added
	. = ..()
	add_traits(list(TRAIT_HEALS_FROM_CARP_RIFTS, TRAIT_SPACEWALK), INNATE_TRAIT)

	if (cell_line)
		AddElement(/datum/element/swabable, cell_line, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)
	AddElement(/datum/element/simple_flying)
	if (!cowardly)
		AddElement(/datum/element/ai_flee_while_injured)
	setup_eating()

	AddComponent(/datum/component/speechmod, replacements = strings("crustacean_replacement.json", "crustacean"))
	AddComponent(/datum/component/aggro_emote, emote_list = string_list(list("gnashes")))
	AddComponent(/datum/component/regenerator, outline_colour = regenerate_colour)
	AddComponent(/datum/component/profound_fisher)
	if (tamer)
		tamed(tamer, feedback = FALSE)
		befriend(tamer)
	else
		var/static/list/food_types = list(/obj/item/food/meat)
		AddComponent(/datum/component/tameable, food_types = food_types, tame_chance = 10, bonus_tame_chance = 5)

	teleport = new(src)
	teleport.Grant(src)
	ai_controller.set_blackboard_key(BB_CARP_RIFT, teleport)
	ai_controller.set_blackboard_key(BB_OBSTACLE_TARGETING_WHITELIST, allowed_obstacle_targets)

/mob/living/basic/minnow/Destroy()
	QDEL_NULL(teleport)
	return ..()

/// Tell the elements and the blackboard what food we want to eat
/mob/living/basic/minnow/proc/setup_eating()
	AddElement(/datum/element/basic_eating, food_types = desired_food)
	AddElement(/datum/element/basic_eating, heal_amt = 0, damage_amount = 10, damage_type = BRUTE, food_types = desired_trash) // We are killing our planet
	var/list/foods_list = desired_food + desired_trash
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(foods_list))


/// Called when another mob has forged a bond of friendship with this one, passed the taming mob as 'tamer'
/mob/living/basic/minnow/tamed(mob/living/tamer, atom/food, feedback = TRUE)
	AddComponent(/datum/component/obeys_commands, tamed_commands)
	if (!feedback)
		return
	spin(spintime = 10, speed = 1)
	visible_message("[src] spins in a circle as it seems to bond with [tamer].")

/// Teleport when you right click away from you
/mob/living/basic/minnow/ranged_secondary_attack(atom/atom_target, modifiers)
	teleport.Trigger(target = atom_target)

/// Gives the carp a list of weakrefs of destinations to try and travel between when it has nothing better to do
/mob/living/basic/minnow/proc/migrate_to(list/datum/weakref/migration_points)
	ai_controller.can_idle = FALSE
	ai_controller.set_ai_status(AI_STATUS_ON) // We need htem to actually walk to the station
	var/list/actual_points = list()
	for(var/datum/weakref/point_ref as anything in migration_points)
		var/turf/point_resolved = point_ref.resolve()
		if(QDELETED(point_resolved))
			return // invalid list, we can't migrate to this
		actual_points += point_resolved

	ai_controller.set_blackboard_key(BB_CARP_MIGRATION_PATH, actual_points)

/mob/living/basic/minnow/death(gibbed)
	. = ..()

	REMOVE_TRAIT(src, TRAIT_FREE_HYPERSPACE_MOVEMENT, INNATE_TRAIT)

/mob/living/basic/minnow/revive(full_heal_flags, excess_healing, force_grab_ghost)
	. = ..()

	ADD_TRAIT(src, TRAIT_FREE_HYPERSPACE_MOVEMENT, INNATE_TRAIT)

//Mouselike traits
/mob/living/basic/minnow/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	. = ..()
	if(!.)
		return

	if(!proximity_flag)
		return

	if(istype(attack_target, /obj/structure/cable))
		try_bite_cable(attack_target)
		return TRUE

/// Biting into a cable will cause a mouse to get shocked and die if applicable. Or do nothing if they're lucky.
/mob/living/basic/minnow/proc/try_bite_cable(obj/structure/cable/cable)
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
