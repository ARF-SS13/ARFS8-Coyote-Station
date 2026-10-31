/datum/episode_event/ratwiggle_modifier
	min_cooldown = 2 MINUTES
	weight = 10
	unlock_phase = 1
	end_phase = 6
	max_runs = -1
	is_progressive = TRUE
	/// attempts to move the cooldown for ratwiggle events, by this much, to that much
	/// cooldown multiplier for ratwiggle events.
	var/rw_cooldown_percent_change = 0
	var/rw_cooldown_percent_target = 100
	/// budget multiplier for ratwiggle events, more is more, in percent
	var/rw_budget_percent_change = 0
	var/rw_budget_percent_target = 100

	/// if not null, overrides the ratwiggle values
	/// how much this event favors hostile stuff
	var/rw_hostile_weighting = 1
	var/rw_super_hostile = FALSE
	var/rw_only_hostiles = FALSE
	var/rw_ignore_max_spawnable = FALSE
	var/rw_ignore_max_spawnable_hostiles = FALSE
	var/rw_ignore_cooldowns = FALSE
	var/rw_ignore_cooldowns_hostiles = FALSE

/datum/episode_event/ratwiggle_modifier/run_event(force)
	if(rw_cooldown_percent_change)
		SSratwiggle.cooldown_percent = drift_towards_by(
			SSratwiggle.cooldown_percent,
			rw_cooldown_percent_target,
			rw_cooldown_percent_change)
	if(rw_budget_percent_change)
		SSratwiggle.budget_percent = drift_towards_by(
			SSratwiggle.budget_percent,
			rw_budget_percent_target,
			rw_budget_percent_change)

		SSratwiggle.hostile_weight = rw_hostile_weighting
		SSratwiggle.can_spawn_superhostile = rw_super_hostile
		SSratwiggle.ignore_max_spawnable = rw_ignore_max_spawnable
		SSratwiggle.ignore_cooldowns = rw_ignore_cooldowns
		SSratwiggle.only_hostiles = rw_only_hostiles
		SSratwiggle.can_spawn_superhostile = rw_super_hostile
		SSratwiggle.ignore_cooldowns_hostiles = rw_ignore_cooldowns_hostiles
		SSratwiggle.ignore_max_spawnable_hostiles = rw_ignore_max_spawnable_hostiles
	if(is_finished(force))
		finished = TRUE

/datum/episode_event/ratwiggle_modifier/is_finished(force)
	. = ..()
	if(.)
		return TRUE
	// we're finished when ssratwiggle has reached its desired state
	if(rw_cooldown_percent_change != 0)
		if(!IS_WITHIN_TOLERANCE(SSratwiggle.cooldown_percent, rw_cooldown_percent_target, rw_cooldown_percent_change))
			return FALSE
	if(rw_budget_percent_change != 0)
		if(!IS_WITHIN_TOLERANCE(SSratwiggle.budget_percent, rw_budget_percent_target, rw_budget_percent_change))
			return FALSE
	if(!isnull(rw_hostile_weighting))
		if(!IS_WITHIN_TOLERANCE(SSratwiggle.hostile_weight, rw_hostile_weighting, 0))
			return FALSE
	if(SSratwiggle.can_spawn_superhostile != rw_super_hostile)
		return FALSE
	if(SSratwiggle.ignore_max_spawnable != rw_ignore_max_spawnable)
		return FALSE
	if(SSratwiggle.ignore_cooldowns != rw_ignore_cooldowns)
		return FALSE
	if(SSratwiggle.ignore_cooldowns_hostiles != rw_ignore_cooldowns_hostiles)
		return FALSE
	if(SSratwiggle.ignore_max_spawnable_hostiles != rw_ignore_max_spawnable_hostiles)
		return FALSE
	return TRUE
