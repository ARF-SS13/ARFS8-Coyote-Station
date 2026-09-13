// ╔═════════╤══════════════════════════════════╗
// ║ File    │ cat_tracker_subsystem.dm         ║
// ║ Date    │ 2024-06-14                       ║
// ║ Author  │ Dan 'MeowGooner' Kelly           ║
// ║ License │ Free Use                         ║
// ║ Quote   │ "I blame this on Pali."          ║
// ╟─────────┼──────────────────────────────────╨────────────────────────────────────────────────────╖
// ║         │                                                                                       ║
// ║  ####   │ Welcome to the cat tracker subsystem, which monitors and manages cat activity         ║
// ║  ####   │ and by cat I mean atoms of a specific tracking category, which can be used to get a   ║
// ║  ####   │ thing relating to a certain kind of atom, anywhere, live, over the internet           ║
// ║  ####   │ Goonstation did this, but better, and it worked great, so im gonna do it too          ║
// ║         │                                                                                       ║
// ╟─────────┼───────────────────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ===================================================================================  ║
// ╚═════════╧═══════════════════════════════════════════════════════════════════════════════════════╝

SUBSYSTEM_DEF(cat_tracker)
	name = "CatTracker"
	flags = SS_NO_INIT | SS_NO_FIRE
	// cats -> things tracked
	var/list/cat_tracker = list()
	// things tracked -> cats
	var/list/tracker_cats = list()
	// its like a dual-linked list, but it gobbles down dicks by the bushel

/datum/controller/subsystem/cat_tracker/proc/TrackCategory(atom/movable/target, list/categories)
	if(!islist(categories))
		categories = list(categories)
	for(var/category in categories)
		if(!cat_tracker[category])
			cat_tracker[category] = list()
		var/datum/weakref/target_ref = WEAKREF(target)
		cat_tracker[category] += target_ref
		if(!tracker_cats[target_ref])
			tracker_cats[target_ref] = list()
		tracker_cats[target_ref] |= category
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(StopTracking)) // just in case

/datum/controller/subsystem/cat_tracker/proc/StopTracking(atom/movable/target, dont_yell_at_me_ppleast = FALSE)
	if(!target)
		CRASH("Cat Tracker: StopTracking called with a null target. This should never happen. Youre all in so much trouble.")
	UnregisterSignal(target, COMSIG_QDELETING)
	var/datum/weakref/target_ref = WEAKREF(target)
	if(!tracker_cats[target_ref])
		return
	for(var/category in tracker_cats[target_ref])
		if(cat_tracker[category])
			cat_tracker[category] -= target_ref
	tracker_cats -= target_ref

/datum/controller/subsystem/cat_tracker/proc/GetTrackedAtoms(category)
	if(!cat_tracker[category])
		return list()
	var/list/tracked_atoms = list()
	for(var/datum/weakref/target_ref in cat_tracker[category])
		var/atom/movable/target = GET_WEAKREF(target_ref)
		if(!target)
			cat_tracker[category] -= target_ref
			continue
		tracked_atoms += target
	return tracked_atoms

