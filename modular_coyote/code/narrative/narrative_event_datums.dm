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
	var/max_runs = -1
	/// cooldown: the time after the event has run before another event can run (mostly for threaded)
	/// min time a repeat or the next event can happen
	var/min_cooldown = 5 MINUTES
	/// max time a repeat or the next event can happen
	var/max_cooldown = 10 MINUTES
	/// weighted chance to run this
	var/weight = 1
	/// next two are for constant and warmup events, ignored for leadup/main
	/// phase this event unlocks and can start running in at
	var/unlock_phase = 1
	/// the last phase this can run in, inclusive
	var/end_phase = 6
	/// banned areas, turns into a typecache
	var/banned_area_flags = NARRATIVE_AREA_FLAG_ERP_ZONES | NARRATIVE_AREA_FLAG_RUINS
	/// hook into the narrative subsystem's life effects signal for progressive events that need to react to living mob updates
	var/does_life_effects = FALSE

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

/datum/episode_event/proc/try_run_event(force, delay, phase)
	var/list/happencode = list()
	if(!can_run(phase, force, happencode))
		return FALSE
	if(run_event(force, delay))
		do_post_run(force)
	return TRUE

/// often overridden by specific event types to implement custom run clawgic
/datum/episode_event/proc/run_event(force, delay)
	if(!event)
		return FALSE
	SSgamemode.schedule_event(event, delay, passed_ignore = TRUE, passed_announce = !quiet)
	return TRUE

/datum/episode_event/proc/do_post_run(force)
	times_ran += 1
	last_ran = world.time

/datum/episode_event/proc/can_run(phase, force)
	if(force)
		return TRUE
	if(max_runs != -1 && times_ran >= max_runs)
		return FALSE
	if(last_ran + min_cooldown > world.time)
		return FALSE
	phase ||= SSnarrative.get_round_phase()
	if(phase < unlock_phase || phase > end_phase)
		return FALSE
	return TRUE

/datum/episode_event/proc/get_cooldown()
	return rand(min_cooldown, max_cooldown)
/datum/episode_event/proc/OnRadioMessageReceived(
	atom/movable/hearer,
	frequency,
	list/data,
	list/spans,
	list/radio_data,
	obj/item/radio/best_radio
)
	// Default implementation does nothing, meant to be overridden by specific events.
	return

/datum/episode_event/proc/is_in_banned_area(area/A, atom/thing)
	if(!islist(SSnarrative.banned_area_cache["[banned_area_flags]"]))
		SSnarrative.typecache_banned_areas(banned_area_flags)
	if(!LAZYLEN(SSnarrative.banned_area_cache["[banned_area_flags]"]))
		return FALSE
	if(!isarea(A))
		if(istype(thing))
			A = get_area(thing)
		if(!isarea(A))
			return FALSE
	return SSnarrative.banned_area_cache["[banned_area_flags]"][A]

/datum/episode_event/proc/try_life_effects(mob/living/liver, seconds_per_tick)
	if(!does_life_effects)
		return
	if(!can_run())
		return
	do_life_effects(liver, seconds_per_tick)

/datum/episode_event/proc/do_life_effects(mob/living/liver, seconds_per_tick)
	return

