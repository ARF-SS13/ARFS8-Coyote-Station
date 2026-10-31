/// The things that go into an episode event, holds data about the event

/*
 * Notes about storyline and communication events, which imma call progressive events
 * Their life cycle is kinda like this:
 * - episode reads its list of prog events
 * - checks each if its finished. if finished, skip forever
 * - if not finish, check if it can run it normally
 * - When finished, lockout the ep-TWIZZLERS DAN-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ok
 *  */

/datum/episode_event
	// can be an event, or null if this datum is doing something else
	var/datum/round_event_control/event = null
	// parent episode that this event belongs to
	var/datum/episode/parent = null
	/// Whether this event should run quietly without notifying players
	var/quiet = FALSE
	/// If it should only alert the first time it runs
	var/alert_once = FALSE
	var/last_ran = 0
	var/times_ran = 0
	var/max_runs = 1
	/// storyline/communication event stuff, for events that can repeat until a certain condition is finished
	var/is_progressive = FALSE
	/// marks that this storyline/communication event is finished, and can move onto the next one
	var/finished = FALSE
	/// min time a repeat or the next event can happen
	var/min_cooldown = 5 MINUTES
	/// weighted chance to run this
	var/weight = 1
	/// next two are for constant and warmup events, ignored for leadup/main
	/// phase this event unlocks and can start running in at
	var/unlock_phase = 1
	/// the last phase this can run in, inclusive
	var/end_phase = 6
	/// initial delay, minimum time
	var/min_delay = 1 MINUTES
	/// maximum delay, for events that can have a variable start time
	var/max_delay = 10 MINUTES


/datum/episode_event/New(datum/episode/our_episode)
	parent = our_episode
	if(ispath(event))
		var/eventype = event::type
		for(var/datum/round_event_control/data in SSgamemode.control)
			if(data.type == eventype)
				event = data
				if(weight == 1)
					weight = data.weight
				break
		if(!istype(event, /datum/round_event_control))
			CRASH("!!! EVENT NOT FOUND FOR [src.type]: [eventype]!!!")

/datum/episode_event/proc/try_run_event(force, delay)
	if(!can_run(SSnarrative.get_round_phase(), force))
		return FALSE
	if(run_event(force, delay))
		do_post_run(force)
	return TRUE

/datum/episode_event/proc/run_event(force, delay)
	if(!event)
		return FALSE
	SSgamemode.schedule_event(event, delay, passed_ignore = TRUE, passed_announce = !quiet)
	return TRUE

/datum/episode_event/proc/do_post_run(force)
	times_ran += 1
	last_ran = world.time
	if(is_progressive && is_finished())
		finished = TRUE

/datum/episode_event/proc/can_run(phase, force)
	if(force)
		return TRUE
	if(is_progressive && is_finished())
		return FALSE
	if(max_runs != -1 && times_ran >= max_runs)
		return FALSE
	if(last_ran + min_cooldown > world.time)
		return FALSE
	phase ||= SSnarrative.get_round_phase()
	if(is_progressive)
		if(phase < unlock_phase)
			return FALSE
	else
		if(phase < unlock_phase || phase > end_phase)
			return FALSE
	return TRUE

/// fpor progressive evetns
/datum/episode_event/proc/is_finished(phase)
	phase ||= SSnarrative.get_round_phase()
	if(phase < unlock_phase || phase > end_phase)
		return TRUE
	return finished

/datum/episode_event/proc/get_cooldown()
	var/delay = rand(min_cooldown, min_cooldown * 2)
	return delay

