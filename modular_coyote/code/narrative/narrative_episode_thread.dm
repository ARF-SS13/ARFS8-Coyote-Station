
/*
 * Represents a thread within an episode, which can manage and track the progression of related events.
 * Threads help organize events into coherent sequences and control their execution order.
 * kinda a list, but better, cus its a datum
 *
 * You can have like, a bunch of threads within an episode, each managing its own sequence of events.
 *
 */

/datum/episode_thread
	// parent episode that this thread belongs to
	var/datum/episode/parent = null
	// list of events associated with this thread
	var/list/events = list()
	/// cooldown after the end of one event before the next can start
	var/next_event_cooldown = 0 // times are decided by the events themselves


/datum/episode_thread/New(datum/episode/my_parent)
	if(my_parent)
		parent = my_parent

	for(var/datum/episode_event/event as anything in events)
		events -= event
		events += new event(parent)

/datum/episode_thread/proc/fire()
	if(world.time < next_event_cooldown)
		return // still in cooldown, cannot fire the next event yet

	var/datum/episode_event/current = get_current_event()
	if(!current)
		return // might be in a cooldown or waiting for the next event to become available

	. = current.try_run_event()

	if(current.is_finished())
		next_event_cooldown = world.time + current.get_cooldown() // assuming each event has its own cooldown after finishing

// fetches the appropriate current event
// advances if the current event has been completed or is no longer valid
/datum/episode_thread/proc/get_current_event()
	for(var/datum/episode_event/event in events)
		if(event.is_finished())
			continue
		return event

