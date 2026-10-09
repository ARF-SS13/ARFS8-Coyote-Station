/datum/episode_event/ratwiggle_modifier
	min_cooldown = 2 MINUTES
	weight = 10
	unlock_phase = 1
	end_phase = 6
	/// attempts to move the cooldown for ratwiggle events, by this much, to that much
	/// cooldown multiplier for ratwiggle events.
	var/rw_cooldown_percent_change = 0
	var/rw_cooldown_percent_target = 100
	/// budget multiplier for ratwiggle events, more is more, in percent
	var/rw_budget_percent_change = 0
	var/rw_budget_percent_target = 100

	/// if not null, overrides the ratwiggle values
	/// how much this event favors hostile stuff
	var/rw_hostile_weighting
	var/rw_ignore_max_spawnable
	var/rw_ignore_max_spawnable_hostiles

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

	if(!isnull(rw_hostile_weighting))
		SSratwiggle.hostile_weight = rw_hostile_weighting
	if(!isnull(rw_ignore_max_spawnable))
		SSratwiggle.ignore_max_spawnable = rw_ignore_max_spawnable
	if(!isnull(rw_ignore_max_spawnable_hostiles))
		SSratwiggle.ignore_max_spawnable_hostiles = rw_ignore_max_spawnable_hostiles

/datum/episode_event/ratwiggle_modifier/is_satisfied(force)
	// we're satisfied when ssratwiggle has reached its desired state
	if(rw_cooldown_percent_change != 0)
		if(!IS_WITHIN_TOLERANCE(SSratwiggle.cooldown_percent, rw_cooldown_percent_target, rw_cooldown_percent_change))
			return FALSE
	if(rw_budget_percent_change != 0)
		if(!IS_WITHIN_TOLERANCE(SSratwiggle.budget_percent, rw_budget_percent_target, rw_budget_percent_change))
			return FALSE
	if(!isnull(rw_hostile_weighting))
		if(!IS_WITHIN_TOLERANCE(SSratwiggle.hostile_weight, rw_hostile_weighting, 0))
			return FALSE
	if(!isnull(rw_ignore_max_spawnable))
		if(SSratwiggle.ignore_max_spawnable != rw_ignore_max_spawnable)
			return FALSE
	if(!isnull(rw_ignore_max_spawnable_hostiles))
		if(SSratwiggle.ignore_max_spawnable_hostiles != rw_ignore_max_spawnable_hostiles)
			return FALSE
	return TRUE
