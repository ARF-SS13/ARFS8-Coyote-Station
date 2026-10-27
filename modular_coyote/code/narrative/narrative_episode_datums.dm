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
	/// Low-impact Events that happen frequently,nuisances that occupy the early game
	/// unlocked after phase 1
	var/list/minor_events = list()
	/// Events that happen all the time
	/// Generally unimpactful or helpful
	var/list/background_events = list()

	var/main_event_allowed = TRUE

	// main events happen guaranteed
	// as are storyline events, they are guaranteed to happen in order, so no need for a chance value
	var/minor_chance = 25
	var/background_chance = 25

	var/storyline_next_allowed = 0
	var/communication_next_allowed = 0

	var/last_event_time = 0
	var/last_storyline_event_time = 0
	var/last_minor_event_time = 0
	var/last_background_event_time = 0

	/// The maximum number of main events that can occur in this episode
	/// in case you want to pick from a number of main events
	var/max_main_events = 1

	/// The phase where hints about the main event should start appearing to the players
	var/hint_phase = 2
	/// The phase where the main event is revealed to the players via announcement or station mail
	var/reveal_phase = 3
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
	for(var/datum/episode_event/minor_event       as anything in minor_events)
		minor_events -= minor_event
		minor_events += new minor_event(src)
	for(var/datum/episode_event/background_event  as anything in background_events)
		background_events -= background_event
		background_events += new background_event(src)
	for(var/datum/episode_thread/thread           as anything in event_threads)
		event_threads -= thread
		event_threads += new thread(src)

/datum/episode/Destroy(force)
	QDEL_LIST(main_events)
	QDEL_LIST(minor_events)
	QDEL_LIST(background_events)
	QDEL_LIST(event_threads)
	. = ..()

/// Main ticker for the episode, responsible for triggering events based chances and such
/// What time is it? do the thing whenever, lol
/datum/episode/proc/fire()
	var/phase = SSnarrative.get_phase()
	// find us something to fire, if needed!
	// main events are guaranteed, so we check if we need to fire one
	try_main_event(phase)
	fire_threads(phase)
	// then, we try minor events and background events based on their chances
	if(!try_minor_event(phase))
		try_background_event(phase)

/// these re in order, top to bottom, one must be finished and the second must be firable to uh fire
/datum/episode/proc/fire_threads(phase)
	for(var/datum/episode_thread/thread as anything in event_threads)
		thread.fire(phase)

/datum/episode/proc/try_main_event(phase)
	if(!main_event_allowed)
		return
	var/datum/episode_event/event_to_fire = get_random_valid_event(main_events)
	if(event_to_fire)
		event_to_fire.try_run_event(FALSE, 0)

/datum/episode/proc/try_minor_event(phase)
	if(!prob(minor_chance))
		return
	var/datum/episode_event/event_to_fire = get_random_valid_event(minor_events)
	if(event_to_fire)
		event_to_fire.try_run_event(FALSE, 0)
	return event_to_fire

/datum/episode/proc/try_background_event(phase)
	if(!prob(background_chance))
		return
	var/datum/episode_event/event_to_fire = get_random_valid_event(background_events)
	if(event_to_fire)
		event_to_fire.try_run_event(FALSE, 0)
	return event_to_fire


/// pick a weighted event from a list. checks if it *can fire*
/datum/episode/proc/get_random_valid_event(list/list_of_events)
	for(var/datum/episode_event/event in list_of_events)
		if(!event.is_finished(SSnarrative.get_phase(), FALSE))
			return event
	return null
	var/list/candidates = list()
	for(var/datum/episode_event/event in list_of_events)
		if(event.can_run(SSnarrative.get_phase(), FALSE))
			candidates[event] = event.weight
	if(LAZYLEN(candidates))
		return pickweight(candidates)









