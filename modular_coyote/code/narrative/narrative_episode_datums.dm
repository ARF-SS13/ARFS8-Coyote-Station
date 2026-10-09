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
	/// unlocked after phase 2
	var/list/storyline_events = list()
	/// Low-impact Events that happen frequently,nuisances that occupy the early game
	/// unlocked after phase 1
	var/list/minor_events = list()
	/// Events that happen all the time
	/// Generally unimpactful or helpful
	var/list/background_events = list()

	// main events happen guaranteed
	var/storyline_chance = 50
	var/minor_chance = 25
	var/background_chance = 75

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

	/// no events should occur during this initial grace period at the start of the round
	var/roundstart_grace = 5 MINUTES

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
	for(var/datum/episode_event/main_event as anything in main_events)
		main_events += new main_event()
	for(var/datum/episode_event/storyline_event as anything in storyline_events)
		storyline_events += new storyline_event()
	for(var/datum/episode_event/minor_event as anything in minor_events)
		minor_events += new minor_event()
	for(var/datum/episode_event/background_event as anything in background_events)
		background_events += new background_event()

/datum/episode/Destroy(force)
	QDEL_LIST(main_events)
	QDEL_LIST(storyline_events)
	QDEL_LIST(minor_events)
	QDEL_LIST(background_events)
	. = ..()













