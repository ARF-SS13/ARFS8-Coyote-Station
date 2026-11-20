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
	var/ignore_delay = TRUE
	/// Delay: the time after the event is chosen to run before it actually executes
	/// initial delay, minimum time
	var/min_delay = 1 SECONDS
	/// maximum delay, for events that can have a variable start time
	var/max_delay = 1 SECONDS
	/// use an initial delay?
	var/use_initial_delay = TRUE
	var/delayed_until = 0
	var/finished = FALSE

/datum/episode_event/threadded/Destroy(force)
	SSnarrative.life_active_events -= src
	. = ..()

/datum/episode_event/threadded/try_run_event(force, delay, phase)
	if(!can_run(phase, force))
		return FALSE
	run_event(force, delay, phase)
	do_post_run(force, phase)
	return TRUE

/datum/episode_event/threadded/run_event(force, delay, phase)
	return TRUE

/datum/episode_event/threadded/do_post_run(force, phase)
	times_ran += 1
	last_ran = world.time
	try_to_finish(phase)
	if(!is_finished(phase))
		SSnarrative.life_active_events |= src

/datum/episode_event/threadded/can_run(phase, force, delay_doesnt_block)
	if(force)
		return TRUE
	if(is_finished(phase))
		return FALSE
	if(!ignore_times_ran)
		if(times_ran >= max_runs)
			return FALSE
	if(!ignore_delay)
		if(use_initial_delay && delayed_until == 0)
			delayed_until = world.time + get_delay()
		if(delayed_until > world.time && !delay_doesnt_block)
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
	if(does_life_effects)
		SSnarrative.life_active_events -= src
	return TRUE

/datum/episode_event/threadded/proc/is_finished(phase)
	if(finished)
		return TRUE
	phase ||= SSnarrative.get_round_phase()
	if(phase > end_phase)
		return TRUE
	return finished

/datum/episode_event/threadded/proc/get_delay()
	return rand(min_delay, max_delay)

/datum/episode_event/threadded/proc/try_life_effects(mob/living/liver, seconds_per_tick)
	if(!does_life_effects)
		SSnarrative.life_active_events -= src
		return
	if(!can_run())
		return
	do_life_effects(liver, seconds_per_tick)

/datum/episode_event/threadded/proc/do_life_effects(mob/living/liver, seconds_per_tick)
	return

