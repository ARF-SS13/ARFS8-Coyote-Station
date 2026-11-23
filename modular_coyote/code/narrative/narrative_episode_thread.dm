
/*
 * Represents a thread within an episode, which can manage and track the progression of related events.
 * Threads help organize events into coherent sequences and control their execution order.
 *
 * You can have like, a bunch of threads within an episode, each managing its own sequence of events.
 *
 * Threaded episode events only, please!
 */

/datum/episode_thread
	// parent episode that this thread belongs to
	var/datum/episode/parent = null
	// list of events associated with this thread
	var/list/events = list()
	// list of finished events
	var/list/finished_events = list()
	/// cooldown after the end of one event before the next can start
	var/next_event_cooldown = 0 // times are decided by the events themselves
	/// stashed event, cus we picked an event and its set to be on a delay
	var/datum/episode_event/threadded/current_event = null


/datum/episode_thread/New(datum/episode/my_parent)
	if(my_parent)
		parent = my_parent

	for(var/datum/episode_event/threadded/event as anything in events)
		events -= event
		events += new event(parent)

/datum/episode_thread/proc/fire(phase)
	if(world.time < next_event_cooldown)
		return // still in cooldown, cannot fire the next event yet

	current_event = get_current_event(phase, TRUE) // pop!
	if(!current_event)
		return // might be in a cooldown or waiting for the next event to become available

	var/success = current_event.try_run_event(FALSE, 0, phase)
	var/finished = current_event.is_finished()

	if(finished)
		on_event_finished(current_event, success, finished)
		next_event_cooldown = world.time + current_event.get_cooldown() // assuming each event has its own cooldown after finishing
		events -= current_event
		finished_events += current_event
		current_event = null

// fetches the appropriate current event
// advances if the current event has been completed or is no longer valid
/datum/episode_thread/proc/get_current_event(phase, clear_current = FALSE)
	if(current_event && !current_event.is_finished())
		return current_event
	if(clear_current)
		current_event = null
	for(var/datum/episode_event/threadded/event in events)
		if(event.is_finished())
			continue
		if(!event.can_run(phase, FALSE, TRUE))
			continue
		return event

/datum/episode_thread/proc/on_event_finished(datum/episode_event/threadded/current, success, finished)
	// default implementation does nothing, can be overridden by specific threads
	return

/datum/episode_thread/proc/OnRadioMessageReceived(
	atom/movable/hearer,
	frequency,
	list/data,
	list/spans,
	list/radio_data,
	obj/item/radio/best_radio
)
	var/datum/episode_event/threadded/currevent = get_current_event()
	if(currevent)
		currevent.OnRadioMessageReceived(hearer, frequency, data, spans, radio_data, best_radio)

/datum/episode_thread/proc/handle_life_effects(mob/living/them, seconds_per_tick)
	var/datum/episode_event/threadded/currevent = get_current_event()
	if(currevent)
		currevent.try_life_effects(them, seconds_per_tick)


/// picks a random available event from the list of events that can currently run
/// returns null if no events are available
/datum/episode_thread/randomized
	/// whether this thread should enforce phase limits when selecting available events
	/// otherwise it'll continue to select events without considering phase limits
	var/phase_limited = FALSE
	/// how many of our stock of events are allowed to run for each phase
	/// if we run out of non-finished events, we're out anyway
	var/alist/phase_limits = alist(
		ROUND_PHASE_1 = 0,
		ROUND_PHASE_2 = 0,
		ROUND_PHASE_3 = 0,
		ROUND_PHASE_4 = 0,
		ROUND_PHASE_5 = 0,
		ROUND_PHASE_6 = 0,
	)
	/// whether to cpount the limits down when an event finishes, as opposed to when it runs successfully
	var/count_on_finished = TRUE

/datum/episode_thread/randomized/on_event_finished(datum/episode_event/threadded/current, success, finished)
	if(!current)
		return
	var/phase_counted = get_appropriate_phase_for_event(current, null)
	if(phase_limits[phase_counted] == -1)
		return
	if((count_on_finished && finished) || (!count_on_finished && success))
		phase_limits[phase_counted] = max(phase_limits[phase_counted] - 1, 0)

// fetches the appropriate current event
// advances if the current event has been completed or is no longer valid
/datum/episode_thread/randomized/get_current_event(phase)
	if(current_event && !current_event.is_finished())
		return current_event
	var/list/available_events = list()
	for(var/datum/episode_event/threadded/event in events)
		if(phase_limited)
			var/app_phase = get_appropriate_phase_for_event(event, phase)
			if(phase_limits[app_phase] <= 0)
				continue
		if(!event.can_run(phase, FALSE, TRUE))
			continue
		if(event.is_finished())
			continue
		available_events += event
	if(!LAZYLEN(available_events))
		return null
	return pick(available_events)

/datum/episode_thread/randomized/proc/get_appropriate_phase_for_event(datum/episode_event/threadded/event, phase)
	var/phase_start = event.unlock_phase
	var/phase_end = event.end_phase
	phase ||= SSnarrative.get_round_phase()
	var/phase_counted = clamp(phase, phase_start, phase_end)
	return phase_counted









