///
/datum/rw_spawner
	var/weight = 50
	var/rare = FALSE

	var/min_phase = 0
	var/max_phase = 0

	var/max_alive = 0
	var/total_alive = 0

	var/total_existing = 0
	var/max_existing = 0

	var/total_spawned = 0
	var/max_spawnable = 0

	var/total_killed = 0
	var/value_multiplier = 1

	var/min_delay_between_spawns = 10 MINUTES
	var/max_delay_between_spawns = 15 MINUTES
	var/next_spawn_time = 0

	var/hostile = FALSE
	var/super_hostile = FALSE

	var/spawnwave_max = 0
	var/spawnwave_min = 0
	var/obey_banned_areas = TRUE
	var/maints_chance = 25
	var/space_chance = 0
	var/only_on_station = TRUE // false for carps and such
	var/only_off_station = FALSE // true for carps and such
	var/list/spawn_types = list()
	var/list/spawnable_from = list(
		CATTRACK_VENTS = 100,
		CATTRACK_TRASHPILES = 25,
		CATTRACK_VENDINGMACHINES = 25,
		CATTRACK_TABLES = 5,
	)
	var/list/spawned = list() // /weakrefs = "alive" or "dead"

/datum/rw_spawner/Destroy()
	for(var/datum/weakref/c_ref in spawned)
		var/mob/living/creature = GET_WEAKREF(c_ref)
		if(!creature)
			continue
		UnregisterSignal(creature, COMSIG_LIVING_DEATH)
		UnregisterSignal(creature, COMSIG_QDELETING)
	. = ..()

/datum/rw_spawner/proc/CooldownOK()
	if(SSratwiggle.debug_ignore_cooldowns)
		return TRUE
	var/now = world.time
	if(now < next_spawn_time)
		return FALSE
	return TRUE

/datum/rw_spawner/proc/SpawnableOK()
	if(SSratwiggle.debug_ignore_spawnable_checks)
		return TRUE
	if(!rare)
		if(SSratwiggle.ignore_max_spawnable)
			return TRUE
		if(hostile)
			if(SSratwiggle.ignore_max_spawnable_hostiles)
				return TRUE
	if(total_spawned >= max_spawnable)
		return FALSE
	if(total_alive >= max_alive)
		return FALSE
	if(total_existing >= max_existing)
		return FALSE
	return TRUE

/datum/rw_spawner/proc/RecordSpawn(mob/living/creature)
	var/datum/weakref/c_ref = WEAKREF(creature)
	if(c_ref in spawned)
		SSratwiggle.AddLogCache("Attempted to record spawn of creature [creature] that is already recorded in tally. Somethings fishy.", RW_LOGLVL_ERROR)
		return
	var/now = world.time
	var/cd = rand(min_delay_between_spawns, max_delay_between_spawns)
	cd *= (SSratwiggle.cooldown_percent / 100)
	next_spawn_time = now + cd
	total_spawned += 1
	total_alive += 1
	total_existing += 1
	RegisterSignal(creature, COMSIG_LIVING_DEATH, PROC_REF(RecordDeath))
	RegisterSignal(creature, COMSIG_QDELETING, PROC_REF(RecordDelete))
	spawned[c_ref] = "alive"

/datum/rw_spawner/proc/RecordDeath(mob/living/creature)
	UnregisterSignal(creature, COMSIG_LIVING_DEATH)
	spawned[WEAKREF(creature)] = "dead"
	total_alive -= 1
	total_killed += 1

/datum/rw_spawner/proc/RecordDelete(mob/living/creature)
	UnregisterSignal(creature, COMSIG_QDELETING)
	UnregisterSignal(creature, COMSIG_LIVING_DEATH)
	var/datum/weakref/c_ref = WEAKREF(creature)
	if(spawned[c_ref] != "dead")
		total_alive -= 1
	total_existing -= 1

/datum/rw_spawner/rats
	min_phase = 0
	max_phase = 6
	max_alive = 10
	max_existing = 10
	max_spawnable = 20
	value_multiplier = 1
	spawnwave_max = 5
	spawnwave_min = 1
	spawn_types = list(
		/mob/living/basic/mouse/brown = 10,
		/mob/living/basic/mouse/white = 10,
		/mob/living/basic/mouse/gray = 10,
		/mob/living/basic/mouse/brown/tom = 1,
	)

/datum/rw_spawner/rats/mean
	weight = 20
	min_phase = 2
	max_phase = 6
	max_alive = 3
	max_existing = 5
	max_spawnable = 20
	value_multiplier = 2
	spawnwave_max = 2
	spawnwave_min = 1
	hostile = TRUE
	spawn_types = list(
		/mob/living/basic/mouse/rat = 1,
	)

/datum/rw_spawner/roaches
	weight = 100
	min_phase = 0
	max_phase = 6
	max_alive = 10
	max_existing = 20
	max_spawnable = 50
	value_multiplier = 1
	spawnwave_max = 5
	spawnwave_min = 1
	spawn_types = list(
		/mob/living/basic/cockroach = 10,
		/mob/living/basic/cockroach/bloodroach = 1, //ew
	)
	spawnable_from = list(
		CATTRACK_VENTS = 25,
		CATTRACK_TRASHPILES = 25,
		CATTRACK_TRASH = 10,
		CATTRACK_TRASHCARTS = 25,
		CATTRACK_VENDINGMACHINES = 25,
		CATTRACK_TABLES = 5,
		CATTRACK_LOCKERS = 5,
		CATTRACK_SECURE_LOCKERS = 5,
		CATTRACK_CRATES = 5,
	)

/datum/rw_spawner/roaches/mean
	weight = 20
	min_phase = 2
	max_phase = 6
	max_alive = 3
	max_existing = 10
	max_spawnable = 20
	value_multiplier = 2
	spawnwave_max = 2
	spawnwave_min = 1
	hostile = TRUE
	spawn_types = list(
		/mob/living/basic/cockroach/sewer = 5,
	)

/datum/rw_spawner/frogs
	weight = 10
	rare = TRUE
	min_phase = 0
	max_phase = 6
	max_alive = 2
	max_existing = 10
	max_spawnable = 20
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	spawn_types = list(
		/mob/living/basic/frog = 10,
		/mob/living/basic/frog/rare = 1,
	)
	spawnable_from = list(
		CATTRACK_VENTS = 100,
		CATTRACK_TRASHPILES = 25,
		CATTRACK_TRASHCARTS = 25,
		CATTRACK_VENDINGMACHINES = 25,
	)

/datum/rw_spawner/frogs/mean
	weight = 10
	rare = TRUE
	min_phase = 4
	max_phase = 6
	max_alive = 1
	max_existing = 5
	max_spawnable = 20
	value_multiplier = 2
	spawnwave_max = 1
	spawnwave_min = 1
	hostile = FALSE
	spawn_types = list(
		/mob/living/basic/frog/crazy = 5,
		/mob/living/basic/frog/crazy/rare = 1,
	)

/datum/rw_spawner/spiders
	weight = 30
	min_phase = 0
	max_phase = 6
	max_alive = 3
	max_existing = 10
	max_spawnable = 20
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	spawn_types = list(
		/mob/living/basic/spider/maintenance = 1,
	)

/datum/rw_spawner/lightgeist
	weight = 1
	rare = TRUE
	min_phase = 5 // only near round end
	max_phase = 6
	max_alive = 1
	max_existing = 1
	max_spawnable = 2
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	spawn_types = list(
		/mob/living/basic/lightgeist = 1,
	)

/datum/rw_spawner/bat
	weight = 25
	min_phase = 3
	max_phase = 6
	max_alive = 2
	max_existing = 5
	max_spawnable = 10
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	maints_chance = 100
	spawn_types = list(
		/mob/living/basic/bat = 25,
	)

/datum/rw_spawner/lizard
	weight = 25
	min_phase = 1
	max_phase = 3 // too good for this world
	max_alive = 3
	max_existing = 5
	max_spawnable = 10
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	maints_chance = 25
	spawn_types = list(
		/mob/living/basic/lizard = 25,
		/mob/living/basic/lizard/tegu = 10,
		/mob/living/basic/lizard/space = 5,
	)

/datum/rw_spawner/cyberfox
	weight = 5
	rare = TRUE
	min_phase = 2
	max_phase = 6
	max_alive = 1
	max_existing = 1
	max_spawnable = 1
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	maints_chance = 25
	spawn_types = list(
		/mob/living/basic/pet/syndifox/cyberfox = 1,
	)
	spawnable_from = list(
		CATTRACK_VENTS = 25,
		CATTRACK_TRASHPILES = 25,
	)

/datum/rw_spawner/stoat
	weight = 15
	min_phase = 0
	max_phase = 3
	max_alive = 2
	max_existing = 3
	max_spawnable = 3
	value_multiplier = 1
	spawnwave_max = 1
	spawnwave_min = 1
	spawn_types = list(
		/mob/living/basic/stoat = 1,
	)
	spawnable_from = list(
		CATTRACK_VENTS = 25,
		CATTRACK_TRASHPILES = 25,
		CATTRACK_TRASHCARTS = 25,
		CATTRACK_VENDINGMACHINES = 25,
	)


