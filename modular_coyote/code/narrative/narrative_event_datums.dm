/// The things that go into an episode event, holds data about the event
/datum/episode_event
	// can be an event, or null if this datum is doing something else
	var/datum/round_event_control/event = null
	/// Whether this event should run quietly without notifying players
	var/quiet = FALSE
	/// If it should only alert the first time it runs
	var/alert_once = FALSE
	var/last_ran = 0
	var/times_ran = 0
	var/max_runs = 1
	var/run_until_satisfied = FALSE
	var/finished = FALSE
	/// min time a repeat can happen
	var/min_cooldown = 5 MINUTES
	/// weighted chance to run this
	var/weight = 0
	/// next two are for constant and warmup events, ignored for leadup/main
	/// phase this event unlocks and can start running in at
	var/unlock_phase = 1
	/// the last phase this can run in, inclusive
	var/end_phase = 6

/datum/episode_event/New()
	if(event)
		var/eventype = event::type
		for(var/datum/round_event_control/data in SSgamemode.control)
			if(data.type == eventype)
				event = data
				if(weight == 0)
					weight = data.weight
				break
		CRASH("!!! EVENT NOT FOUND FOR [src.type]: [eventype]!!!")

/datum/episode_event/proc/try_run_event(force, delay)
	if(!can_run(force))
		return
	run_event(force, delay)
	return TRUE

/datum/episode_event/proc/run_event(force, delay)
	SSgamemode.schedule_event(event, delay)
	times_ran += 1
	last_ran = world.time

/datum/episode_event/proc/can_run(force)
	if(force)
		return TRUE
	if(finished)
		return FALSE
	if(is_satisfied(force))
		return FALSE
	if(times_ran >= max_runs)
		return FALSE
	if(last_ran + min_cooldown > world.time)
		return FALSE
	return TRUE

/datum/episode_event/proc/is_satisfied(force)
	if(!run_until_satisfied)
		return TRUE
	if(finished)
		return TRUE
	return times_ran > 0

