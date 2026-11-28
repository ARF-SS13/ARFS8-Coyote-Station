/// How close you need to get to the destination in order to consider yourself there
#define MINNOW_DESTINATION_SEARCH_RANGE 3

/datum/ai_planning_subtree/minnow_solar_hunter

/datum/ai_planning_subtree/minnow_solar_hunter/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	// We have a destination, try to approach it
	var/turf/moving_to = controller.blackboard[BB_MINNOW_TARGET]
	if(!isnull(moving_to))
		// we spawn in space, maybe. space has multiple z levels!
		// if not at the same z level as our destination, try to move vertically first
		if(controller.pawn.z != moving_to.z)
			var/dir_toward_good = get_dir_multiz(controller.pawn, moving_to)
			var/turf/vert_step
			if(dir_toward_good & UP)
				dir_toward_good = UP // filter!
				vert_step = get_step_multiz(controller.pawn, moving_to)
			else if(dir_toward_good & DOWN)
				dir_toward_good = DOWN
				vert_step = get_step_multiz(controller.pawn, moving_to)
			if(!vert_step)
				return SUBTREE_RETURN_FINISH_PLANNING // If we can't move vertically, stop planning for now
			// can we move this way?
			var/mob/living/basic/me = controller.pawn
			var/can_go_this_way = me.can_z_move(dir_toward_good, get_turf(me), vert_step)
			if(!can_go_this_way)
				return SUBTREE_RETURN_FINISH_PLANNING // If we can't move this way, stop planning for now
			me.Move(vert_step)
			return SUBTREE_RETURN_FINISH_PLANNING // After moving vertically, stop planning for now


		var/turf/next_step = get_step_towards(controller.pawn, moving_to)
		// Attempt to teleport around if we're blocked
		if(next_step.is_blocked_turf(exclude_mobs = TRUE))
			controller.queue_behavior(/datum/ai_behavior/attack_obstructions/carp, BB_MINNOW_TARGET)
		controller.queue_behavior(/datum/ai_behavior/step_towards_turf, BB_MINNOW_TARGET)
		// We've gotten close enough to it, clear it so we can select a new point (or do nothing)
		if(get_dist(controller.pawn, moving_to) <= MINNOW_DESTINATION_SEARCH_RANGE)
			controller.clear_blackboard_key(BB_MINNOW_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	// We have a path to follow but no destination, select one
	if(length(controller.blackboard[BB_MINNOW_PATH]))
		controller.queue_behavior(/datum/ai_behavior/find_next_minnow_migration_step, BB_MINNOW_PATH, BB_MINNOW_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

/**
 * # Find next minnow migration step
 * Records the next turf we want to travel to into the blackboard for other actions
 */
/datum/ai_behavior/find_next_minnow_migration_step

/datum/ai_behavior/find_next_minnow_migration_step/perform(seconds_per_tick, datum/ai_controller/controller, path_key, target_key)
	var/list/blackboard_points = controller.blackboard[path_key]
	for(var/turf/migration_point as anything in blackboard_points)
		// By the end of this loop we will either have a valid migration point set, or an empty list in our blackboard
		blackboard_points -= migration_point
		if(get_dist(controller.pawn, migration_point) > MINNOW_DESTINATION_SEARCH_RANGE)
			controller.set_blackboard_key(target_key, migration_point)
			return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED
	return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED

#undef MINNOW_DESTINATION_SEARCH_RANGE
