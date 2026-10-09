// ╔═════════╤══════════════════════════════════╗
// ║ File    │ ratwiggle_subsystem.dm           ║
// ║ Date    │ 2024-06-14                       ║
// ║ Author  │ Dan 'ElizaIsHot' Kelly           ║
// ║ License │ Free Use                         ║
// ║ Quote   │ "Fat rats wiggle the best."      ║
// ╟─────────┼──────────────────────────────────╨────────────────────────────────────────────────────╖
// ║         │                                                                                       ║
// ║  ####   │ Welcome to ratwiggle, which populates the station with obnoxious wildlife             ║
// ║  ####   │                                                                                       ║
// ║  ####   │ Rats and mice and roaches and other vermin, all to crawl out of things and            ║
// ║  ####   │ calse promblems (cause problems) (and to be cute and fun and stuff)                   ║
// ║         │                                                                                       ║
// ╟─────────┼───────────────────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ===================================================================================  ║
// ╚═════════╧═══════════════════════════════════════════════════════════════════════════════════════╝

#define DEBUG_LOG(msg, lvl) if(lvl >= debug_lvl) {AddLogCache(msg, lvl)};

SUBSYSTEM_DEF(ratwiggle)
	name = "RatWiggle"
	flags = SS_BACKGROUND
	wait = 1 MINUTES

	var/list/wiggle_spawners = list()
	var/list/wiggle_tallies = list()
	var/list/wiggle_parameters = list()

	var/cooldown_percent = 100
	var/budget_percent = 100
	var/ignore_max_spawnable_hostiles = FALSE
	var/ignore_max_spawnable = FALSE
	var/hostile_weight = 1
	var/can_spawn_superhostile = FALSE

	var/spawnwave_rate = 10 MINUTES
	var/next_wave = 0

	var/list/logcache = list()
	var/list/banned_areas = list()
	var/debug_phase_override = null
	var/debug_lvl = RW_LOGLVL_WARN
	var/debug_lvl_to_chat = RW_LOGLVL_ERROR
	var/debug_ignore_cooldowns = FALSE
	var/debug_ignore_spawnable_checks = FALSE
	var/debug_extra_info = FALSE

/datum/controller/subsystem/ratwiggle/Initialize(start_timeofday)
	InitializeWiggleSets()
	banned_areas |= typecacheof(SIZE_WHITELISTED_AREAS) // close enough
	banned_areas |= typecacheof(/area/ruin)
	to_chat(world, span_alien("Warning: RatWiggle system engaged!"))
	DEBUG_LOG("RatWiggle subsystem initialized at [start_timeofday]", RW_LOGLVL_INFO)

/datum/controller/subsystem/ratwiggle/proc/InitializeWiggleSets()
	for(var/datum/rw_spawner/spawner as anything in subtypesof(/datum/rw_spawner))
		wiggle_spawners["[spawner::type]"] = new spawner
	for(var/datum/rw_param/parm as anything in subtypesof(/datum/rw_param))
		wiggle_parameters["[parm::phase]"] = new parm

/datum/controller/subsystem/ratwiggle/proc/ForceWiggle()
	fire(FALSE)

/datum/controller/subsystem/ratwiggle/fire(resumed)
	SpawnStuff()
	DEBUG_LOG("RatWiggle subsystem fired. Resumed: [resumed]", RW_LOGLVL_DEBUG)
	SaveLogCache()

/datum/controller/subsystem/ratwiggle/proc/SpawnStuff()
	if(debug_extra_info)
		WriteDebugState()
	if(world.time < next_wave)
		return
	var/round_phase = SSnarrative.get_round_phase(debug_phase_override)
	var/datum/rw_param/param = wiggle_parameters["[round_phase]"]
	if(!param)
		DEBUG_LOG("No param for round phase [round_phase]! SpawnStuff aborted!", RW_LOGLVL_ERROR)
		return

	var/cd = spawnwave_rate * (cooldown_percent / 100) * (param.spawn_rate_percent / 100)
	next_wave = world.time + cd

	var/list/wiggles = list() // /datum = number
	for(var/faze in wiggle_spawners)
		var/datum/rw_spawner/spawner = wiggle_spawners[faze]
		if(round_phase < spawner.min_phase || round_phase > spawner.max_phase)
			DEBUG_LOG(
				"Skipping spawner [spawner]: round phase [round_phase] outside ([spawner.min_phase] to [spawner.max_phase])",
				RW_LOGLVL_DEBUG)
			continue
		if(spawner.super_hostile && !can_spawn_superhostile)
			continue
		if(!spawner.SpawnableOK() && !debug_ignore_spawnable_checks)
			DEBUG_LOG(
				"Skipping spawner [spawner.type]: spawnable check failed (alive: [spawner.total_alive]/[spawner.max_alive], existing: [spawner.total_existing]/[spawner.total_existing], total spawned: [spawner.total_spawned]/[spawner.max_spawnable])",
				RW_LOGLVL_DEBUG)
			continue
		if(!spawner.CooldownOK() && !debug_ignore_cooldowns)
			DEBUG_LOG(
				"Skipping spawner [spawner.type]: cooldown check failed (next spawn time: [spawner.next_spawn_time], current time: [world.time])",
				RW_LOGLVL_DEBUG)
			continue
		var/weight = spawner.weight
		if(spawner.hostile)
			weight *= hostile_weight
		wiggles[spawner] = weight
	// pick one! weighted~
	var/list/spawned = list()
	var/total_budget = round(rand(param.spawn_budget_min, param.spawn_budget_max) * (budget_percent / 100))
	var/tb_started = total_budget
	DEBUG_LOG("Spawning stuff for round phase [round_phase]. Total budget: [total_budget]", RW_LOGLVL_DEBUG)
	var/safety = 20
	while(total_budget > 0 && wiggles.len && safety > 0)
		safety--
		var/datum/rw_spawner/spawner = pick_weight_remove(wiggles)
		// remove all the rare ones, rares can only be picked first try
		for(var/datum/rw_spawner/spaw in wiggles)
			if(spaw.rare)
				wiggles -= spaw
		if(!spawner)
			break

		var/num_to_spawn = rand(spawner.spawnwave_min, spawner.spawnwave_max)
		DEBUG_LOG("Attempting to spawn [num_to_spawn] of spawner [spawner.type]", RW_LOGLVL_DEBUG)
		var/list/what2spawn = spawner.spawn_types.Copy()
		var/safety2 = 20
		while(num_to_spawn > 0 && total_budget > 0 && what2spawn.len && safety2 > 0)
			var/mob/living/basic/creature = pick_weight_remove(what2spawn)
			if(!creature)
				DEBUG_LOG("No creature picked from what2spawn list, breaking out of spawn loop.", RW_LOGLVL_DEBUG)
				break
			var/cost = 1 * spawner.value_multiplier
			if(cost > total_budget)
				DEBUG_LOG("Not enough budget to spawn [creature::name] (cost: [cost], total budget: [total_budget]). Breaking out of spawn loop.", RW_LOGLVL_DEBUG)
				break
			if(!SpawnCreature(creature, spawner))
				DEBUG_LOG("Failed to spawn creature [creature::name] from spawner [spawner.type].", RW_LOGLVL_DEBUG)
				continue
			spawned["[creature::name]"] += 1
			num_to_spawn--
			total_budget -= cost
	DEBUG_LOG("Finished spawning stuff for round phase [round_phase]. Total budget left: [total_budget] (started with [tb_started])", RW_LOGLVL_DEBUG)
	DEBUG_LOG("Spawned the following creatures: [english_list(spawned)]", RW_LOGLVL_INFO)
	DEBUG_LOG("Safety counter left: [safety] / 20", RW_LOGLVL_DEBUG)

/// spawns 1 (one) critter somewhere, usually on the station
/datum/controller/subsystem/ratwiggle/proc/SpawnCreature(
	mob/living/basic/creaturetype,
	datum/rw_spawner/spawner)
	if(!creaturetype || !spawner)
		return
	// check if we can actually spawn this thing, and where
	if(!spawner || !spawner.spawn_types.len)
		DEBUG_LOG("Spawner [spawner.type] has no spawn types defined, cannot spawn creature [creaturetype::name].", RW_LOGLVL_ERROR)
		return
	var/turf/spawnhere = GetSpawnLocation(spawner, creaturetype)
	if(!spawnhere)
		DEBUG_LOG("Failed to find a valid spawn location for creature [creaturetype::name] from spawner [spawner.type].", RW_LOGLVL_WARN)
		return
	var/mob/living/basic/critter = new creaturetype(get_turf(spawnhere))
	critter.do_squish(squishx = 1.2, squishy = 0.6, timer = 20)
	critter.balloon_alert_to_viewers("!")
	spawner.RecordSpawn(critter)
	DEBUG_LOG("Spawned creature [creaturetype::name] at [get_turf(critter)] from spawner [spawner.type].", RW_LOGLVL_INFO)
	return TRUE

/datum/controller/subsystem/ratwiggle/proc/GetSpawnLocation(datum/rw_spawner/spawner, mob/living/basic/creaturetype)
	if(!spawner || !ispath(creaturetype))
		DEBUG_LOG("Invalid spawner or creature type provided to GetSpawnLocation.", RW_LOGLVL_ERROR)
		return null
	var/turf/place
	if(prob(spawner.maints_chance))
		DEBUG_LOG("Attempting to find a maintenance spawn location.", RW_LOGLVL_DEBUG)
		place = find_maintenance_spawn(TRUE, FALSE)
		if(place)
			DEBUG_LOG("Found a maintenance spawn location: [place]", RW_LOGLVL_DEBUG)
			return place
		DEBUG_LOG("Failed to find a maintenance spawn location, falling back to regular spawn logic.", RW_LOGLVL_DEBUG)
	var/list/possibilities = spawner.spawnable_from.Copy()
	if(!LAZYLEN(possibilities))
		DEBUG_LOG("No possible spawn locations available from spawner [spawner.type], aborting spawn.", RW_LOGLVL_WARN)
		return null
	var/safety = 20
	while(!place && possibilities.len && safety > 0)
		safety--
		var/entry = pick_weight_remove(possibilities)
		if(!entry)
			DEBUG_LOG("No valid entry picked from possibilities, breaking out of spawn loop.", RW_LOGLVL_DEBUG)
			break
		// get a thing!
		var/list/maybeplaces = SScat_tracker.GetTrackedAtoms(entry)
		if(!LAZYLEN(maybeplaces))
			DEBUG_LOG("No possible spawn locations found for cat [entry], continuing to next possibility.", RW_LOGLVL_INFO)
			continue
		var/safety2 = 20
		while(!place && maybeplaces.len && safety2 > 0)
			safety2--
			// got a cat, but which? some have special rules!
			var/atom/movable/coolthing = pick_n_take(maybeplaces)
			if(!coolthing)
				DEBUG_LOG("Failed to pick a valid movable thing from maybeplaces, breaking out of inner spawn loop.", RW_LOGLVL_DEBUG)
				break
			var/turf/thingturf = get_turf(coolthing)
			if(!thingturf)
				DEBUG_LOG("Coolthing [coolthing.type] has no valid turf, skipping.", RW_LOGLVL_WARN)
				continue
			DEBUG_LOG("Considering spawn location at turf [thingturf.x], [thingturf.y], [thingturf.z] for cat [entry].", RW_LOGLVL_DEBUG)
			//on station, sorta?
			if(spawner.only_on_station)
				DEBUG_LOG("Spawner is restricted to only on-station locations, checking if turf [thingturf.x], [thingturf.y], [thingturf.z] is on the station.", RW_LOGLVL_DEBUG)
				var/area/A = get_area(thingturf)
				if(!A || !(A.type in GLOB.the_station_areas))
					DEBUG_LOG("Turf [thingturf.x], [thingturf.y], [thingturf.z] is not on the station, skipping.", RW_LOGLVL_DEBUG)
					continue
			if(spawner.obey_banned_areas)
				var/area/A = get_area(thingturf)
				if(!A)
					DEBUG_LOG("Turf [thingturf.x], [thingturf.y], [thingturf.z] has no valid area, skipping. W. what?", RW_LOGLVL_ERROR)
					continue
				if(banned_areas[A.type])
					DEBUG_LOG("Turf [thingturf.x], [thingturf.y], [thingturf.z] is in a banned area, skipping.", RW_LOGLVL_DEBUG)
					continue
			switch(entry)
				if(CATTRACK_TRASHCARTS, CATTRACK_LOCKERS, CATTRACK_SECURE_LOCKERS, CATTRACK_CRATES)
					DEBUG_LOG("Considering special rules for cat [entry].", RW_LOGLVL_DEBUG)
					if(!istype(coolthing, /obj/structure/closet))
						SScat_tracker.StopTracking(coolthing)
						DEBUG_LOG("Tracked cat [entry] has a thing that isn't the expected type. [coolthing] is not a closet, in the closet-like category.", RW_LOGLVL_ERROR)
						stack_trace("WOW, tracked cat [entry] has a thing that isnt the thing it is supposed to be! [coolthing] is not a closet, but is tracked as one!")
						break // okay everyone out
					var/obj/structure/closet/closetthing = coolthing
					if(!closetthing.opened)
						DEBUG_LOG("Closet [closetthing] is not open, skipping.", RW_LOGLVL_DEBUG)
						continue
				if(CATTRACK_VENTS, CATTRACK_SCRUBBERS)
					DEBUG_LOG("Considering special rules for cat [entry].", RW_LOGLVL_DEBUG)
					if(!istype(coolthing, /obj/machinery/atmospherics/components/unary))
						SScat_tracker.StopTracking(coolthing)
						DEBUG_LOG("Tracked cat [entry] has a thing that isn't the expected type. [coolthing] is not an air pump, in the vent/scrubber category.", RW_LOGLVL_ERROR)
						stack_trace("WOW, tracked cat [entry] has a thing that isnt the thing it is supposed to be! [coolthing] is not an air pump, but is tracked as one!")
						break // okay everyone out
					var/obj/machinery/atmospherics/components/unary/ventthing = coolthing
					if(!ventthing.anchored || ventthing.welded || !(LAZYACCESS(ventthing.nodes, 1)) || !ventthing.on || !ventthing.is_operational)
						DEBUG_LOG("Vent/Scrubber [ventthing] is not active, skipping.", RW_LOGLVL_DEBUG)
						continue
			// gotta check atmos against what the mob's requirements are, if it has any
			var/list/acceptable_gas_bounds = creaturetype::habitable_atmos
			DEBUG_LOG("Checking atmos for turf [thingturf.x], [thingturf.y], [thingturf.z] against acceptable gas bounds.", RW_LOGLVL_DEBUG)
			if(LAZYLEN(acceptable_gas_bounds))
				var/datum/gas_mixture/mixture = thingturf.return_air()
				if(!check_gases(mixture.gases, acceptable_gas_bounds))
					DEBUG_LOG("Turf [thingturf.x], [thingturf.y], [thingturf.z] failed gas check, skipping.", RW_LOGLVL_DEBUG)
					continue
			DEBUG_LOG("Turf [thingturf.x], [thingturf.y], [thingturf.z] passed all checks, placing cat [entry] here.", RW_LOGLVL_DEBUG)
			place = thingturf
		return place
	return null

/datum/controller/subsystem/ratwiggle/proc/SaveLogCache()
	if(!LAZYLEN(logcache))
		return
	for(var/list/entry in logcache)
		var/msg = entry[1]
		var/lvl = entry[2]
		DebugLog(msg, lvl)
	logcache = list()

/datum/controller/subsystem/ratwiggle/proc/DebugLog(msg, lvl)
	var/now = time2text(world.realtime, "DD/MM/YYYY hh:mm:ss")
	var/roundtime = DisplayTimeText(world.time)
	var/level = ""
	switch(lvl)
		if(RW_LOGLVL_DEBUG)
			level = "\[DEBUG\]"
		if(RW_LOGLVL_INFO)
			level = "\[INFO\]"
		if(RW_LOGLVL_WARN)
			level = "\[!WARN!\]"
		if(RW_LOGLVL_ERROR)
			level = "\[!!ERROR!\]"
	var/line1 = "[now] [level] @ [roundtime] (phase [SSnarrative.get_round_phase(debug_phase_override)])[!isnull(debug_phase_override)? " <DEBUG OVERRIDE = [debug_phase_override]>": ""]"
	var/line2 = "--> [msg]"
	var/full_line = "[line1]\n[line2]\n"
	logcache += full_line
	if(lvl >= debug_lvl_to_chat)
		message_admins(full_line)
	if(!rustg_file_exists(RW_LOGPATH))
		rustg_file_write(full_line, RW_LOGPATH)
	else
		rustg_file_append(full_line, RW_LOGPATH)

/// goes through all the spawners and tallies and writes out which ones can spawn, which ones are at their limits, and what the current tallies are
/datum/controller/subsystem/ratwiggle/proc/WriteDebugState()
	var/round_phase = SSnarrative.get_round_phase(debug_phase_override)
	var/debugmsg = "RatWiggle Debug State at [DisplayTimeText(world.timeofday)] (phase [round_phase])\n"
	for(var/faze in wiggle_spawners)
		var/datum/rw_spawner/spawner = wiggle_spawners[faze]
		if(!spawner)
			debugmsg += "Spawner [spawner.type] does not exist.\n"
			continue
		if(spawner.total_alive >= spawner.max_alive || spawner.total_existing >= spawner.total_existing)
			debugmsg += "Spawner [spawner.type] is at its limits: alive [spawner.total_alive]/[spawner.max_alive], existing [spawner.total_existing]/[spawner.total_existing]\n"
		debugmsg += "Spawner [spawner.type] tally: alive [spawner.total_alive]/[spawner.max_alive], existing [spawner.total_existing]/[spawner.total_existing]\n"
		if(spawner.total_alive >= spawner.max_alive)
			debugmsg += "Spawner [spawner.type] is at its alive limit ([spawner.total_alive]/[spawner.max_alive]).\n"
		if(spawner.total_existing >= spawner.total_existing)
			debugmsg += "Spawner [spawner.type] is at its total limit ([spawner.total_existing]/[spawner.total_existing]).\n"
		if(round_phase < spawner.min_phase || round_phase > spawner.max_phase)
			debugmsg += "Spawner [spawner.type] is inactive this phase ([round_phase] outside [spawner.min_phase]-[spawner.max_phase]).\n"
		else
			debugmsg += "Spawner [spawner.type] is active this phase ([round_phase] within [spawner.min_phase]-[spawner.max_phase]).\n"
		debugmsg += "Spawner [spawner.type] can spawn from the following categories: [spawner.spawnable_from.Join(", ")]\n"
		debugmsg += "Spawner [spawner.type] can spawn the following types: [spawner.spawn_types.Join(", ")]\n"
		debugmsg += "Spawner [spawner.type] spawn wave min: [spawner.spawnwave_min], max: [spawner.spawnwave_max], value multiplier: [spawner.value_multiplier]\n"
		if(spawner.only_on_station)
			debugmsg += "Spawner [spawner.type] is restricted to only on-station locations.\n"
		if(spawner.maints_chance)
			debugmsg += "Spawner [spawner.type] has a [spawner.maints_chance]% chance to spawn in maintenance.\n"
	debugmsg += "Current log cache length: [logcache.len] lines.\n"
	DEBUG_LOG(debugmsg, RW_LOGLVL_DEBUG)

/datum/controller/subsystem/ratwiggle/proc/AddLogCache(message, level)
	logcache += list(list(message, level))






ADMIN_VERB(ratwiggle_force_spawns, R_ADMIN, "Ratwiggle Force Spawns", "Force all ratwiggle spawners to attempt spawning immediately.", ADMIN_CATEGORY_MAIN)
	SSratwiggle.ForceWiggle()
	SSratwiggle.SaveLogCache() // for d-bug
	to_chat(user, span_notice("Forced some ratwiggle spawns for you!"))


