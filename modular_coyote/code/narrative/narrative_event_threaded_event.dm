/*
 * These are non-random events that live in narrative threads and are executed under self-defined
 * conditions, so the episode/thread itself can control the execution of its events.
 * Threadded events require start conditions (usually phase), and end conditions (also usually phase)
 *
 * yes i know its spelled threaded, but these threads have thoroughly killed me
 */
/datum/episode_event/threadded
	event = null // you can put an actual event here if you want, if you *want*
	var/ignore_times_ran = TRUE
	var/ignore_cooldown = TRUE
	var/finished = FALSE

/datum/episode_event/threadded/try_run_event(force, delay, phase)
	if(!can_run(phase, force))
		return FALSE
	run_event(force, delay, phase)
	do_post_run(force, phase)
	return TRUE

/// often overridden by specific event types to implement custom run clawgic
/datum/episode_event/threadded/run_event(force, delay, phase)
	return TRUE

/datum/episode_event/threadded/do_post_run(force, phase)
	times_ran += 1
	last_ran = world.time
	try_to_finish(phase)

/datum/episode_event/threadded/can_run(phase, force)
	if(force)
		return TRUE
	if(is_finished(phase))
		return FALSE
	if(!ignore_times_ran)
		if(times_ran >= max_runs)
			return FALSE
	if(!ignore_cooldown)
		if(last_ran + min_cooldown > world.time)
			return FALSE
	phase ||= SSnarrative.get_round_phase()
	if(phase < unlock_phase)
		return FALSE
	return TRUE

/datum/episode_event/threadded/proc/try_to_finish(phase)
	phase ||= SSnarrative.get_round_phase()
	if(!is_finished(phase))
		return FALSE
	finished = TRUE
	on_finished(phase)
	return TRUE

/datum/episode_event/threadded/proc/on_finished(phase)
	return TRUE

/datum/episode_event/threadded/proc/is_finished(phase)
	if(finished)
		return TRUE
	phase ||= SSnarrative.get_round_phase()
	if(phase > end_phase)
		return TRUE
	return finished

/datum/episode_event/threadded/get_cooldown()
	var/delay = rand(min_cooldown, min_cooldown * 2)
	return delay


