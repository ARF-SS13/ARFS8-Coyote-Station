/datum/episode
	var/name = "The Gang Misses The Coderbus"
	var/list/names = list(
		"The Wheel of Runtimes",
	)
	var/desc = "The station tries to use an improperly configured episode! Will Dan survive all the bug reports?"
	/// One of these will be our big main round event, like blob or meteors or something
	/// though if one resolves too quickly we might need another main event to keep things going
	var/list/main_events = list()
	/// Events that are meant to be run in order, forming a narrative or storyline throughout the episode
	/// can use phases to control when each part of the storyline can run, even if
	/// note that if you set it up wrong, it wont progress, idiot
	var/list/event_threads = list()
	/// Random events that are related to the main storyline that happen intermittently abbnd independantly of the story
	/// uses phases to determine when they can occur
	var/list/background_events = list()
	/// Events that happen in the background, usually low-impact and frequent
	/// usually unrelated to the main storyline (shuttle crash, random anomalies, etc)
	var/list/misc_events = list(
		/datum/episode_event/aurora,
		/datum/episode_event/camera_failure,
		/datum/episode_event/bureaucratic_error,
		/datum/episode_event/shuttle_catastrophe,
		/datum/episode_event/shuttle_insurance,
		/datum/episode_event/shuttle_loan,
		/datum/episode_event/stray_cargo,
		/datum/episode_event/stray_cargo_syndicate,
		/datum/episode_event/anomaly/bluespace,
		/datum/episode_event/anomaly/dimensional,
		/datum/episode_event/anomaly/ectoplasm,
		/datum/episode_event/anomaly/flux,
		/datum/episode_event/anomaly/grav,
		/datum/episode_event/anomaly/grav_high,
		/datum/episode_event/anomaly/hallucination,
		/datum/episode_event/anomaly/pyro,
		/datum/episode_event/anomaly/vortex,
		/datum/episode_event/anomaly/weather,
		/datum/episode_event/anomaly/weather/thundering,
		/datum/episode_event/bitrunning_glitch,
		/datum/episode_event/brain_trauma,
		/datum/episode_event/grey_tide,
		/datum/episode_event/grid_check,
		/datum/episode_event/mass_hallucination,
		/datum/episode_event/processor_overload,
		/datum/episode_event/mice_migration,
		/datum/episode_event/wormholes,
	)

	var/main_event_status = 0 // 1 for runned

	// main events happen guaranteed
	// as are storyline events, they are guaranteed to happen in order, so no need for a chance value

	var/background_next_allowed = 0
	var/misc_next_allowed = 0

	var/event_fire_variance_min = 10 SECONDS
	var/event_fire_variance_max = 4 MINUTES

	// timer things
	var/background_cooldown_min_phase_1 = 10 MINUTES
	var/background_cooldown_max_phase_1 = 15 MINUTES

	var/background_cooldown_min_phase_2 = 5 MINUTES
	var/background_cooldown_max_phase_2 = 10 MINUTES

	var/background_cooldown_min_phase_3 = 3 MINUTES
	var/background_cooldown_max_phase_3 = 5 MINUTES

	var/background_cooldown_min_phase_4 = 7 MINUTES
	var/background_cooldown_max_phase_4 = 10 MINUTES

	var/background_cooldown_min_phase_5 = 5 MINUTES
	var/background_cooldown_max_phase_5 = 7 MINUTES

	var/background_cooldown_min_phase_6 = 20 MINUTES
	var/background_cooldown_max_phase_6 = 25 MINUTES

	var/misc_cooldown_min_phase_1 = 5 MINUTES
	var/misc_cooldown_max_phase_1 = 10 MINUTES

	var/misc_cooldown_min_phase_2 = 5 MINUTES
	var/misc_cooldown_max_phase_2 = 10 MINUTES

	var/misc_cooldown_min_phase_3 = 5 MINUTES
	var/misc_cooldown_max_phase_3 = 10 MINUTES

	var/misc_cooldown_min_phase_4 = 5 MINUTES
	var/misc_cooldown_max_phase_4 = 10 MINUTES

	var/misc_cooldown_min_phase_5 = 5 MINUTES
	var/misc_cooldown_max_phase_5 = 10 MINUTES

	var/misc_cooldown_min_phase_6 = 5 MINUTES
	var/misc_cooldown_max_phase_6 = 10 MINUTES

	/// The maximum number of main events that can occur in this episode
	/// in case you want to pick from a number of main events
	var/max_main_events = 1

	/// the phase where the main event is expected to occur, usually following the reveal phase
	var/main_event_phase = 4

	// the recommended numbers for this episode!
	var/recommended_players = 0
	var/recommended_engis = 0
	var/recommended_sec = 0
	var/recommended_med = 0
	var/recommended_sci = 0

/datum/episode/New()
	if(LAZYLEN(names))
		name = pick(names)
	// init the events
	for(var/datum/episode_event/main_event        as anything in main_events)
		main_events -= main_event
		main_events += new main_event(src)
	for(var/datum/episode_event/misc_event       as anything in misc_events)
		misc_events -= misc_event
		misc_events += new misc_event(src)
	for(var/datum/episode_event/background_event  as anything in background_events)
		background_events -= background_event
		background_events += new background_event(src)
	for(var/datum/episode_thread/thread           as anything in event_threads)
		event_threads -= thread
		event_threads += new thread(src)
	//initial random event cooldowns
	misc_next_allowed = world.time + rand(misc_cooldown_min_phase_1, misc_cooldown_max_phase_1)
	background_next_allowed = world.time + rand(background_cooldown_min_phase_1, background_cooldown_max_phase_1)

/datum/episode/Destroy(force)
	QDEL_LIST(main_events)
	QDEL_LIST(misc_events)
	QDEL_LIST(background_events)
	QDEL_LIST(event_threads)
	. = ..()

/// Main ticker for the episode, responsible for triggering events based chances and such
/// What time is it? do the thing whenever, lol
/datum/episode/proc/fire()
	var/phase = SSnarrative.get_round_phase()
	// find us something to fire, if needed!
	// main events are guaranteed, so we check if we need to fire one
	try_main_event(phase)
	// try to advance the storyline
	fire_threads(phase)
	// then, we try minor events and background events based on their chances
	try_random_event(phase)

/// these re in order, top to bottom, one must be finished and the second must be firable to uh fire
/datum/episode/proc/fire_threads(phase)
	for(var/datum/episode_thread/thread as anything in event_threads)
		thread.fire(phase)

/datum/episode/proc/try_main_event(phase)
	if(!main_event_allowed(phase))
		return
	var/datum/episode_event/event_to_fire = get_random_valid_event(main_events)
	if(!event_to_fire)
		return
	var/iance = rand(event_fire_variance_min, event_fire_variance_max)
	var/fired = event_to_fire.try_run_event(FALSE, iance)
	if(fired)
		main_event_fired(event_to_fire)
	return fired

/datum/episode/proc/try_random_event(phase)
	// one at a time!
	var/list/eventlist = list()
	var/which
	if(minor_event_allowed(phase))
		eventlist |= misc_events
		which = "misc"
	else if(background_event_allowed(phase))
		eventlist |= background_events
		which = "background"

	if(!LAZYLEN(eventlist))
		return
	var/iance = rand(event_fire_variance_min, event_fire_variance_max)
	var/datum/episode_event/event_to_fire = get_random_valid_event(eventlist)
	if(!event_to_fire)
		return
	if(!event_to_fire.try_run_event(FALSE, iance))
		return
	var/cd = get_random_event_cooldown(phase, which)
	if(which == "misc")
		misc_next_allowed = world.time + cd
	else if(which == "background")
		background_next_allowed = world.time + cd
	return TRUE

/// pick a weighted event from a list. checks if it *can fire*
/datum/episode/proc/get_random_valid_event(list/list_of_events)
	if(!list_of_events || !LAZYLEN(list_of_events))
		return null
	var/list/candidates = list()
	for(var/datum/episode_event/event in list_of_events)
		if(event.can_run(SSnarrative.get_round_phase(), FALSE))
			candidates[event] = event.weight
	if(LAZYLEN(candidates))
		return pick_weight(candidates)
	return null

/datum/episode/proc/main_event_allowed(phase)
	//? todo: something to check if the main event resolved sooner than expected and adjust main_event_status accordinglyn
	if(main_event_status == 1)
		return FALSE
	if(phase < main_event_phase)
		return FALSE
	return TRUE

/datum/episode/proc/minor_event_allowed(phase)
	return misc_next_allowed <= world.time

/datum/episode/proc/background_event_allowed(phase)
	return background_next_allowed <= world.time

/datum/episode/proc/get_random_event_cooldown(phase, kind)
	phase ||= SSnarrative.get_round_phase()
	var/low_varname = "[kind]_cooldown_min_phase_[phase]"
	var/high_varname = "[kind]_cooldown_max_phase_[phase]"
	if(isnull(vars[low_varname]) || isnull(vars[high_varname]))
		return 0
	var/lowest = vars[low_varname]
	var/highest = vars[high_varname]
	return rand(lowest, highest)

/datum/episode/proc/main_event_fired(event)
	main_event_status = 1







