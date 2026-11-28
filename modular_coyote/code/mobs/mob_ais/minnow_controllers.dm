/**
 * AI controller for carp
 * Expected flow is:
 * * If health is low, mark that we want to run away.
 * * If we want to run away, find nearest target and run out of view of it.
 * * Look for anything we want to eat in the area and target it.
 * * If we don't have a target already, find something to attack.
 * * Go and attack our target (which might be food, or might be a mob).
 */
/datum/ai_controller/basic_controller/carp/minnow
	max_target_distance = 9999
	blackboard = list(
		BB_BASIC_MOB_STOP_FLEEING = TRUE,
		BB_VISION_RANGE = AI_DOG_VISION_RANGE,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic/not_friends,
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/holding_object,
		BB_TARGET_HELD_ITEM = /obj/item/stack/cable_coil,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/random_walk_towards_target/carp
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/make_carp_rift/panic_teleport,
		/datum/ai_planning_subtree/flee_target/from_fisherman,
		/datum/ai_planning_subtree/attack_obstacle_in_path/carp/minnow,
		/datum/ai_planning_subtree/shortcut_to_target_through_carp_rift/minnow,
		/datum/ai_planning_subtree/shortcut_to_target_through_carp_rift/minnow/homer,
		/datum/ai_planning_subtree/make_carp_rift/towards/minnow,
		/datum/ai_planning_subtree/make_carp_rift/towards/minnow/homer,
		/datum/ai_planning_subtree/find_and_hunt_target/look_for_cables/minnow,
		/datum/ai_planning_subtree/seek_electrical_targets,
		/datum/ai_planning_subtree/carp_migration,
	)
	/// Planning subtree for escaping captivity, specific to minnow carp.
/datum/ai_planning_subtree/make_carp_rift/towards
	rift_behaviour = /datum/ai_behavior/make_carp_rift/towards

/datum/ai_planning_subtree/make_carp_rift/towards/minnow
	target_key = BB_CURRENT_HUNTING_TARGET

/datum/ai_planning_subtree/make_carp_rift/towards/minnow/homer
	target_key = BB_HOME_IN_TARGET

/// Planning subtree for aggressive teleportation through a carp rift, specific to minnow carp.
/datum/ai_planning_subtree/shortcut_to_target_through_carp_rift/minnow
	target_key = BB_CURRENT_HUNTING_TARGET

/datum/ai_planning_subtree/shortcut_to_target_through_carp_rift/minnow/homer
	target_key = BB_HOME_IN_TARGET


/// Planning subtree for attacking obstacles in the path, specific to minnow carp.
/datum/ai_planning_subtree/attack_obstacle_in_path/carp/minnow
	target_key = BB_CURRENT_HUNTING_TARGET

/// Makes idle carp wander towards electrical stuff
/datum/idle_behavior/random_walk_towards_target/carp
	target_key = BB_HOME_IN_TARGET

/// Makes carp actively seek and attempt to destroy electrical stuff when idle
/datum/ai_planning_subtree/find_and_hunt_target/look_for_cables/minnow
	target_key = BB_CURRENT_HUNTING_TARGET
	hunting_behavior = /datum/ai_behavior/hunt_target/minnow
	finding_behavior = /datum/ai_behavior/find_hunt_target/minnow_cable
	hunt_targets = list(/obj/structure/cable)
	hunt_range = 10
	hunt_chance = 100

/// Find and validate potential cable targets for the minnow to interact with.
/datum/ai_behavior/find_hunt_target/minnow_cable

/datum/ai_behavior/find_hunt_target/minnow_cable/valid_dinner(mob/living/source, obj/structure/cable/dinner, radius)
	if(istype(dinner, /obj/structure/cable))
		if(!dinner.avail())
			return FALSE

	var/turf/below_the_cable = get_turf(dinner)
	if(!isturf(below_the_cable))
		return FALSE

	if(below_the_cable.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
		return TRUE
	if(isfloorturf(below_the_cable))
		var/turf/open/floor/open_floorb = below_the_cable
		if(open_floorb.overfloor_placed)
			return TRUE // potentially able to rip up a floor tile
	return FALSE

/// Behavior for the minnow to hunt cable targets.
/datum/ai_behavior/hunt_target/minnow
	hunt_cooldown = 1 SECONDS

/datum/ai_behavior/hunt_target/minnow/target_caught(mob/living/hunter, atom/hunted)
	if(istype(hunter, /mob/living/basic/carp/minnow))
		var/mob/living/basic/carp/minnow/minnow_hunter = hunter
		if(istype(hunted, /obj/structure/cable))
			var/obj/structure/cable/attack_target = hunted
			var/turf/floorb = get_turf(attack_target)
			if(floorb && floorb.underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
				if(!isfloorturf(floorb))
					return
				var/turf/open/floor/open_floorb = floorb
				if(open_floorb.overfloor_placed)
					open_floorb.remove_tile(src, FALSE)
				return
			minnow_hunter.try_bite_cable(attack_target)
			return
	. = ..()

/// Finds a cable or solar panel or something electrical for the minnow to go fuck up
/datum/ai_planning_subtree/seek_electrical_targets
	var/allowed_key = BB_SEEK_N_DESTROY_ELECTRICAL_STUFF
	var/target_key = BB_HOME_IN_TARGET

/datum/ai_planning_subtree/seek_electrical_targets/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(!controller.blackboard_key_exists(allowed_key) || !controller.blackboard[allowed_key])
		return
	if (!controller.blackboard_key_exists(target_key))
		return seek_electrical_targets(controller, seconds_per_tick)
	var/atom/target = controller.blackboard[target_key]
	if(isnull(target) || QDELETED(target))
		return seek_electrical_targets(controller, seconds_per_tick)
	var/integ_frac = target.get_integrity_percentage()
	if(integ_frac <= target.integrity_failure)
		return seek_electrical_targets(controller, seconds_per_tick)



/// picks something to mess up
/datum/ai_planning_subtree/seek_electrical_targets/proc/seek_electrical_targets(datum/ai_controller/controller, seconds_per_tick)
	if(seek_power_things(controller))
		return // gpot it!
	if(seek_cable_things(controller))
		return
	seek_middle_of_the_map(controller)

/datum/ai_planning_subtree/seek_electrical_targets/proc/seek_power_things(datum/ai_controller/ai_controller)
	var/atom/pawn = ai_controller.pawn
	var/list/yummy_things = list()
	yummy_things |= SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/solar)
	yummy_things |= SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/rtg)
	yummy_things = shuffle(yummy_things)
	var/atom/closest_yummy = null
	for(var/atom/yummy_thing as anything in yummy_things)
		if(yummy_thing.z == pawn.z)
			if(!closest_yummy)
				closest_yummy = yummy_thing
			else if(get_dist(pawn, yummy_thing) < get_dist(pawn, closest_yummy))
				closest_yummy = yummy_thing
	if(closest_yummy)
		ai_controller.set_blackboard_key(target_key, closest_yummy)
		return TRUE
	return FALSE

/datum/ai_planning_subtree/seek_electrical_targets/proc/seek_cable_things(datum/ai_controller/ai_controller)
	var/atom/pawn = ai_controller.pawn
	var/list/indoor_cable = list()
	var/list/outdoor_cable = list()
	var/atom/closest_cable = null
	for(var/obj/structure/cable/wire as anything in GLOB.cable_list)
		if(wire.z != pawn.z)
			continue
		if(!wire.avail())
			continue
		var/turf/cable_turf = get_turf(wire)
		if(!cable_turf)
			continue
		var/datum/gas_mixture/cable_env = cable_turf.return_air()
		if(!cable_env)
			continue
		if(cable_env.return_pressure() <= HAZARD_LOW_PRESSURE) // close enough to a vacuum, and thus, outdoor
			outdoor_cable += wire
		else
			indoor_cable += wire
	outdoor_cable = shuffle(outdoor_cable)
	for(var/obj/structure/cable/outwire as anything in outdoor_cable)
		if(outwire.z == pawn.z)
			if(!closest_cable)
				closest_cable = outwire
			else if(get_dist(pawn, outwire) < get_dist(pawn, closest_cable))
				closest_cable = outwire
	if(closest_cable)
		ai_controller.set_blackboard_key(target_key, closest_cable)
		return TRUE
	indoor_cable = shuffle(indoor_cable)
	for(var/obj/structure/cable/inwire as anything in indoor_cable)
		if(inwire.z == pawn.z)
			if(!closest_cable)
				closest_cable = inwire
			else if(get_dist(pawn, inwire) < get_dist(pawn, closest_cable))
				closest_cable = inwire
	if(closest_cable)
		ai_controller.set_blackboard_key(target_key, closest_cable)
		return TRUE
	return FALSE

/datum/ai_planning_subtree/seek_electrical_targets/proc/seek_middle_of_the_map(datum/ai_controller/ai_controller)
	var/atom/pawn = ai_controller.pawn
	var/turf/middle = null
	var/mid_x = world.maxx / 2
	var/mid_y = world.maxy / 2
	middle = locate(mid_x, mid_y, pawn.z)
	ai_controller.set_blackboard_key(BB_HOME_IN_TARGET, middle, TRUE)

