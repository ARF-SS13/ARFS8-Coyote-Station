#define WINDOW_BASE_HEALTH 150
GLOBAL_VAR(meteor_direction)
/datum/episode_event/meteors
	event = null
	var/next_meteor = 0
	var/meteor_interval_min = 1 MINUTES
	var/meteor_interval_max = 5 MINUTES
	var/min_meteors = 1
	var/max_meteors = 3
	var/center_of_mass = FALSE
	var/list/meteor_types = list(
		/obj/effect/meteor/episode/dust = 10,
	)

/datum/episode_event/meteors/run_event(force, delay)
	if(!LAZYLEN(meteor_types))
		return FALSE
	if(!force && next_meteor > world.time)
		return FALSE
	if(!GLOB.meteor_direction)
		GLOB.meteor_direction = pick(GLOB.cardinals)
	var/number_of_meteors = rand(min_meteors, max_meteors)
	var/dley = rand(meteor_interval_min, meteor_interval_max)
	var/timespread = dley / max(number_of_meteors, 1)
	var/curr = 0
	for(var/i in 1 to number_of_meteors)
		curr += timespread
		var/meteor = pick_weight_take(meteor_types)
		spawn_meteor_episode(meteor, curr, center_of_mass)
	next_meteor = world.time + dley
	if(is_finished(force))
		finished = TRUE

/datum/episode_event/meteors/is_finished(force)
	. = ..()
	if(.)
		return TRUE
	for(var/meteor_type in meteor_types)
		if(meteor_types[meteor_type] > 0)
			return FALSE
	return TRUE
/datum/episode_event/meteors/phase_1
	unlock_phase = 1
	end_phase = 1
	min_meteors = 1
	max_meteors = 1
	meteor_interval_min = 10 MINUTES
	meteor_interval_max = 15 MINUTES

/datum/episode_event/meteors/phase_1/dust
	meteor_types = list(
		/obj/effect/meteor/episode/dust = 2,
		/obj/effect/meteor/episode/dust/rich = 1,
	)

/datum/episode_event/meteors/phase_1/sand
	meteor_types = list(
		/obj/effect/meteor/episode/sand = 2,
		/obj/effect/meteor/episode/sand/rich = 1,
	)

/datum/episode_event/meteors/phase_2
	unlock_phase = 2
	end_phase = 2
	meteor_interval_min = 5 MINUTES
	meteor_interval_max = 15 MINUTES

/datum/episode_event/meteors/phase_2/dust
	min_meteors = 4
	max_meteors = 7
	meteor_types = list(
		/obj/effect/meteor/episode/dust = 15,
		/obj/effect/meteor/episode/dust/rich = 20,
	)

/datum/episode_event/meteors/phase_2/sand
	min_meteors = 2
	max_meteors = 3
	meteor_types = list(
		/obj/effect/meteor/episode/sand = 15,
		/obj/effect/meteor/episode/sand/rich = 20,
	)

/datum/episode_event/meteors/phase_3
	unlock_phase = 3
	end_phase = 3
	meteor_interval_min = 5 MINUTES
	meteor_interval_max = 15 MINUTES

/datum/episode_event/meteors/phase_3/dust
	min_meteors = 6
	max_meteors = 7 // 6 7 (jiggles boobs)
	meteor_types = list(
		/obj/effect/meteor/episode/dust = 15,
		/obj/effect/meteor/episode/dust/rich = 20,
	)

/datum/episode_event/meteors/phase_3/sand
	min_meteors = 2
	max_meteors = 3
	meteor_types = list(
		/obj/effect/meteor/episode/sand = 15,
		/obj/effect/meteor/episode/sand/rich = 20,
	)

// phase 4, let them have it
/datum/episode_event/meteors/phase_4
	unlock_phase = 4
	end_phase = 4
	meteor_interval_min = 2 MINUTES
	meteor_interval_max = 7 MINUTES

/datum/episode_event/meteors/phase_4/dust
	min_meteors = 10
	max_meteors = 15
	meteor_types = list(
		/obj/effect/meteor/episode/dust = 10,
		/obj/effect/meteor/episode/dust/rich = 100,
		/obj/effect/meteor/episode/dust/resource = 50,
	)

/datum/episode_event/meteors/phase_4/sand
	min_meteors = 5
	max_meteors = 7
	meteor_types = list(
		/obj/effect/meteor/episode/sand = 20,
		/obj/effect/meteor/episode/sand/rich = 150,
		/obj/effect/meteor/episode/sand/resource = 50,
	)

// some sporadic meteors for the hard episode
/datum/episode_event/meteors/phase_4/meteor
	min_meteors = 1
	max_meteors = 2
	center_of_mass = TRUE
	meteor_types = list(
		/obj/effect/meteor/episode/meteor = 10,
		/obj/effect/meteor/episode/meteor/mean = 10,
	)

/datum/episode_event/meteors/phase_4/meteor/easy
	min_meteors = 1
	max_meteors = 1
	meteor_types = list(
		/obj/effect/meteor/episode/meteor = 10,
	)

/datum/episode_event/meteors/phase_5
	unlock_phase = 5
	end_phase = 5
	meteor_interval_min = 5 MINUTES
	meteor_interval_max = 7 MINUTES

/datum/episode_event/meteors/phase_5/dust
	min_meteors = 3
	max_meteors = 4
	meteor_types = list(
		/obj/effect/meteor/episode/dust = 1,
		/obj/effect/meteor/episode/dust/rich = 50,
	)

/datum/episode_event/meteors/phase_5/sand
	min_meteors = 1
	max_meteors = 1
	meteor_types = list(
		/obj/effect/meteor/episode/sand = 1,
		/obj/effect/meteor/episode/sand/rich = 50,
	)

/datum/episode_event/meteors/phase_6
	unlock_phase = 6
	end_phase = 6
	meteor_interval_min = 5 MINUTES
	meteor_interval_max = 10 MINUTES

/datum/episode_event/meteors/phase_6/dust
	min_meteors = 1
	max_meteors = 2
	meteor_types = list(
		/obj/effect/meteor/episode/dust = 1,
		/obj/effect/meteor/episode/dust/rich = 50,
	)

/datum/episode_event/meteors/phase_6/sand
	min_meteors = 2
	max_meteors = 3
	meteor_types = list(
		/obj/effect/meteor/episode/sand = 1,
		/obj/effect/meteor/episode/sand/rich = 50,
	)

/datum/episode_event/meteors/dust/resource
	min_meteors = 2
	max_meteors = 2
	meteor_types = list(
		/obj/effect/meteor/episode/dust/resource = 100,
	)
/datum/episode_event/meteors/sand/resource
	min_meteors = 1
	max_meteors = 1
	meteor_types = list(
		/obj/effect/meteor/episode/sand/resource = 100,
	)







/obj/effect/meteor/episode
	hits = 4
	hitpwr = EXPLODE_LIGHT
	heavy = FALSE
	meteorsound = 'sound/effects/meteorimpact.ogg'
	var/meteorsound_distant = 'sound/effects/explosion/explosion_distant.ogg'
	meteordrop = list(/obj/item/stack/ore/iron = 100)
	floor_hit_effects = FALSE
	threat = 3
	dropamt = 2
	var/alist/damage_profile = alist(
		EXPLODE_DEVASTATE = list(
			"mob_damage_low" = 100,
			"mob_damage_high" = 200,
			"mob_damage_type" = BRUTE,
			"mob_damage_mess_them_up" = TRUE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 2,
			"damage_range" = 8,
		),
		EXPLODE_HEAVY = list(
			"mob_damage_low" = 50,
			"mob_damage_high" = 100,
			"mob_damage_type" = BRUTE,
			"mob_damage_mess_them_up" = TRUE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH,
			"damage_range" = 5,
		),
		EXPLODE_LIGHT = list(
			"mob_damage_low" = 20,
			"mob_damage_high" = 50,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH,
			"damage_range" = 3,
		),
		EXPLODE_NONE = list(
			"mob_damage_low" = 0,
			"mob_damage_high" = 0,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 0.1,
			"damage_range" = 1,
		),
	)

	var/alist/hit_power_rand = alist(
		EXPLODE_NONE = 1,
		EXPLODE_LIGHT = 1,
		EXPLODE_HEAVY = 0,
		EXPLODE_DEVASTATE = 0,
	)
	var/drops_loot_every_hit = FALSE
	var/list/dirts = list(
		/obj/effect/decal/cleanable/generic,
		/obj/effect/decal/cleanable/dirt,
		/obj/effect/decal/cleanable/glass,
		/obj/effect/decal/cleanable/rubble,
	)
	var/next_dirt = 0
	var/dirt_cd_min = 1 SECONDS
	var/dirt_cd_max = 2 SECONDS
	var/list/remembered_window_coords = list()

/obj/effect/meteor/episode/Initialize(mapload, turf/target)
	. = ..()
	if(LAZYLEN(hit_power_rand))
		hitpwr = pick_weight(hit_power_rand)
	if(LAZYLEN(hit_power_rand) > 1)
		hitpwr = pick_weight(hit_power_rand)

/obj/effect/meteor/episode/ram_turf(turf/T)
	//then, ram the turf

	if(istype(T, /turf/closed/wall)) //sand is too weak to affect rwalls or walls with similar durability.
		var/turf/closed/wall/wall_to_ram = T
		if(wall_to_ram.hardness < 50)
			if(prob(50-wall_to_ram.hardness))
				return

	var/area/area_to_check = get_area(T)
	if(area_to_check.area_flags & EVENT_PROTECTED) //This event absolutely destroys arrivals, and putting latejoiners into firelock hell is cringe
		return

	switch(hitpwr)
		if(EXPLODE_DEVASTATE)
			SSexplosions.highturf += T
		if(EXPLODE_HEAVY)
			SSexplosions.medturf += T
		if(EXPLODE_LIGHT)
			SSexplosions.lowturf += T
	get_hit(T, !T.density)

/obj/effect/meteor/episode/impact(atom/A)
	if(!A)
		return
	ram_turf(get_turf(A))
	playsound(A, meteorsound, 80, TRUE, 10, pressure_affected = FALSE, ignore_walls = TRUE)
	get_hit(A, FALSE)

/obj/effect/meteor/episode/get_hit(atom/hit_thing, flyover)
	if(!flyover)
		hits--
		meteor_effect()
	cause_havoc(hit_thing, flyover)
	make_debris(hit_thing, flyover)
	if(hits <= 0)
		make_loot()
		qdel(src)

/obj/effect/meteor/episode/proc/cause_havoc(atom/hit_thing, flyover)
	var/object_hurt_amount = damage_profile[hitpwr]["object_hurt_amount"]
	var/damage_range = damage_profile[hitpwr]["damage_range"]
	if(flyover)
		damage_range = rand(1, damage_range)
		object_hurt_amount = rand(object_hurt_amount / 8, object_hurt_amount / 4)
	var/list/effect_turfs = range(get_turf(src), damage_range)
	for(var/turf/coolturf in effect_turfs)
		var/dist = get_dist(coolturf, get_turf(src))

		//setup explosion turf stuff to throw stuff around
		if(!flyover)
			SSexplosions.held_throwturf += coolturf
			coolturf.explosion_throw_details = list()
			coolturf.explosion_throw_details.len = 4
			coolturf.explosion_throw_details[1] = damage_range
			coolturf.explosion_throw_details[2] = get_turf(src)
			coolturf.explosion_throw_details[3] = damage_range + 1
			coolturf.explosion_throw_details[4] = max(hitpwr, EXPLODE_LIGHT)

			if(hitpwr > EXPLODE_NONE)
				if(dist <= 2)
					if(prob(20))
						SSexplosions.lowturf |= coolturf

		var/coords = "[coolturf.x],[coolturf.y],[coolturf.z]"

		for(var/atom/thing_to_hit in coolturf.contents)
			var/mangle = thing_to_hit == hit_thing
			if(istype(thing_to_hit, /obj))
				var/obj/structure_to_hit = thing_to_hit
				if(istype(structure_to_hit, /obj/structure/window) || istype(structure_to_hit, /obj/machinery/door/firedoor))
					if(remembered_window_coords[coords])
						continue // we want to fuck up the windows, not outright obliterate them
					if(prob(80))
						remembered_window_coords[coords] = TRUE
				var/damage_amount = object_hurt_amount / max(dist, 1)
				structure_to_hit.take_damage(damage_amount, BRUTE)
			if(istype(thing_to_hit, /mob/living))
				beat_up_mob(thing_to_hit, dist, mangle)

/obj/effect/meteor/episode/proc/beat_up_mob(mob/living/mob_to_hit, dist, mangle = FALSE)
	if(!isliving(mob_to_hit))
		return
	var/mob_hurt_low = damage_profile[hitpwr]["mob_damage_low"]
	var/mob_hurt_high = damage_profile[hitpwr]["mob_damage_high"]
	var/mob_damage_type = damage_profile[hitpwr]["mob_damage_type"]
	var/mob_mess_them_up = damage_profile[hitpwr]["mob_damage_mess_them_up"]

	var/damage_amount = rand(mob_hurt_low, mob_hurt_high) / max(1, dist)
	playsound(mob_to_hit, 'sound/items/weapons/genhit3.ogg', pressure_affected = FALSE)
	to_chat(mob_to_hit, span_userdanger("You were caught in the blast of \a [name]!"))
	if(mob_mess_them_up)
		mob_to_hit.Knockdown(3 SECONDS * hitpwr)
	if(mangle)
		mob_to_hit.Stun(6 SECONDS * hitpwr)
		damage_amount *= 2
	var/body_zone = pick(mob_to_hit.get_all_limbs())
	mob_to_hit.apply_damage(damage_amount, mob_damage_type, body_zone, mob_to_hit.run_armor_check(body_zone, MELEE))

/obj/effect/meteor/episode/make_debris(atom/hit_thing, flyover)
	if(flyover)
		if(world.time < next_dirt)
			return
		next_dirt = world.time + rand(dirt_cd_min, dirt_cd_max)
	var/list/impact_turfs = list()
	var/dirt_range = 9
	for(var/turf/T in range(get_turf(hit_thing), dirt_range))
		if(!T.density)
			impact_turfs += T
	if(!LAZYLEN(impact_turfs))
		impact_turfs = list(get_turf(src))
	if(LAZYLEN(impact_turfs) && LAZYLEN(dirts))
		if(flyover)
			var/to_place = rand(1, max(1, floor(LAZYLEN(impact_turfs) * 0.2)))
			for(var/i in 1 to to_place)
				var/turf/T = pick(impact_turfs)
				impact_turfs -= T
				if(isgroundlessturf(T) && prob(90))
					continue
				var/atom/thing_to_spawn = pick(dirts)
				if(thing_to_spawn)
					new thing_to_spawn(T)
		else
			for(var/turf/T in impact_turfs)
				if(isgroundlessturf(T) && prob(90))
					continue
				var/dist = get_dist(get_turf(hit_thing), T)
				var/probability = max(0, 100 - dist * 5)
				if(prob(100 - probability))
					continue
				var/atom/thing_to_spawn = pick(dirts)
				if(thing_to_spawn)
					new thing_to_spawn(T)

/obj/effect/meteor/episode/proc/make_loot()
	for(var/i in 1 to dropamt)
		var/atom/thing_to_spawn = pick_weight(meteordrop)
		if(!thing_to_spawn)
			return
		new thing_to_spawn(get_turf(src))

/obj/effect/meteor/episode/meteor_effect()
	var/turf/impact = get_turf(src)
	var/list/station_zs = SSmapping.levels_by_trait(ZTRAIT_STATION)
	// var/impact_is_on_station_z = impact && (impact.z in station_zs)

	if(heavy)
		for(var/mob/M in GLOB.player_list)
			if((M.orbiting) && (SSaugury.watchers[M]))
				continue
			var/turf/T = get_turf(M)
			if(!T || T.z != src.z)
				continue
			var/dist = get_dist(M.loc, src.loc)
			var/shake_intensity = 0
			var/shake_time = 0
			switch(dist)
				if(0 to 10)
					shake_intensity = 3
					shake_time = 1 SECONDS
				if(11 to 20)
					shake_intensity = 2
					shake_time = 0.5 SECONDS
				if(21 to 50)
					shake_intensity = 1
					shake_time = 0.25 SECONDS
				else
					continue
			shake_camera(M, shake_intensity, shake_time)

	playsound(get_turf(src), meteorsound, rand(50,75), TRUE, 25, ignore_walls = TRUE, pressure_affected = FALSE)
	if(meteorsound_distant)
		for(var/mob/M in GLOB.player_list)
			if(get_dist(get_turf(M), impact) < 10)
				continue
			var/turf/listen_T = get_turf(M)
			if(!listen_T)
				continue
			if(!(listen_T.z in station_zs))
				continue
			// audible anywhere on the map, 90 at impact, decreases to 40 at distance 50, and never goes below 40
			var/volume = max(40, 90 * (1 - get_dist(impact, listen_T) / 50))
			M.playsound_local(src, meteorsound_distant, volume, TRUE, distance_multiplier = 0)


///////////////////////
//Meteor types
///////////////////////

//Sand
/obj/effect/meteor/episode/dust
	name = "space dust cluster"
	icon_state = "dust"
	hits = 1
	hit_power_rand = alist(
		EXPLODE_NONE = 1,
	)
	meteorsound = 'sound/items/dodgeball.ogg'
	damage_profile = alist(
		EXPLODE_DEVASTATE = list(
			"mob_damage_low" = 10,
			"mob_damage_high" = 20,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 0.5,
			"damage_range" = 8,
		),
		EXPLODE_HEAVY = list(
			"mob_damage_low" = 10,
			"mob_damage_high" = 20,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 0.5,
			"damage_range" = 5,
		),
		EXPLODE_LIGHT = list(
			"mob_damage_low" = 10,
			"mob_damage_high" = 20,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 0.5,
			"damage_range" = 3,
		),
		EXPLODE_NONE = list(
			"mob_damage_low" = 10,
			"mob_damage_high" = 15,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 0.5,
			"damage_range" = 3,
		),
	)
	meteordrop = list(
		/obj/item/stack/ore/iron/loot                   = 200,
		/obj/item/stack/ore/iron/loot/med               = 100,
		/obj/item/stack/ore/diamond/loot                = 1,
		/obj/item/stack/ore/diamond/loot/med            = 1,
		/obj/item/stack/ore/glass/loot                  = 200,
		/obj/item/stack/ore/glass/loot/med              = 100,
		/obj/item/stack/ore/bluespace_crystal/loot      = 5,
		/obj/item/stack/ore/bluespace_crystal/loot/med  = 5,
		/obj/item/stack/ore/gold/loot                   = 5,
		/obj/item/stack/ore/gold/loot/med               = 5,
		/obj/item/stack/ore/plasma/loot                 = 5,
		/obj/item/stack/ore/plasma/loot/med             = 5,
		/obj/item/stack/ore/silver/loot                 = 5,
		/obj/item/stack/ore/silver/loot/med             = 5,
		/obj/item/stack/ore/bananium/loot               = 5,
		/obj/item/stack/ore/bananium/loot/med           = 5,
		/obj/item/stack/ore/titanium/loot               = 5,
		/obj/item/stack/ore/titanium/loot/med           = 5,
		/obj/item/stack/ore/uranium/loot                = 5,
		/obj/item/stack/ore/uranium/loot/med            = 5,
	)
	dropamt = 1

/obj/effect/meteor/episode/dust/rich
	name = "rich space dust cluster"
	icon_state = "dust"
	hits = 1
	hit_power_rand = alist(
		EXPLODE_NONE = 50,
		EXPLODE_LIGHT = 1,
		EXPLODE_HEAVY = 1,
	)

	meteordrop = list(
		/obj/item/stack/ore/iron/loot/med                = 100,
		/obj/item/stack/ore/iron/loot/high               = 200,
		/obj/item/stack/ore/diamond/loot/med             = 10,
		/obj/item/stack/ore/diamond/loot/high            = 10,
		/obj/item/stack/ore/glass/loot/med               = 100,
		/obj/item/stack/ore/glass/loot/high              = 200,
		/obj/item/stack/ore/bluespace_crystal/loot/med   = 10,
		/obj/item/stack/ore/bluespace_crystal/loot/high  = 10,
		/obj/item/stack/ore/gold/loot/med                = 10,
		/obj/item/stack/ore/gold/loot/high               = 10,
		/obj/item/stack/ore/plasma/loot/med              = 10,
		/obj/item/stack/ore/plasma/loot/high             = 10,
		/obj/item/stack/ore/silver/loot/med              = 10,
		/obj/item/stack/ore/silver/loot/high             = 10,
		/obj/item/stack/ore/bananium/loot/med            = 10,
		/obj/item/stack/ore/bananium/loot/high           = 10,
		/obj/item/stack/ore/titanium/loot/med            = 10,
		/obj/item/stack/ore/titanium/loot/high           = 10,
		/obj/item/stack/ore/uranium/loot/med             = 10,
		/obj/item/stack/ore/uranium/loot/high            = 10,
	)
	dropamt = 2

/obj/effect/meteor/episode/dust/resource
	name = "material rich space dust cluster"
	icon_state = "dust"
	hits = 1
	hit_power_rand = alist(
		EXPLODE_NONE = 50,
		EXPLODE_LIGHT = 1,
		EXPLODE_HEAVY = 1,
	)

	meteordrop = list(
		/obj/item/stack/ore/iron/loot/med                = 100,
		/obj/item/stack/ore/iron/loot/high               = 200,
		/obj/item/stack/ore/glass/loot/med               = 100,
		/obj/item/stack/ore/glass/loot/high              = 200,
		/obj/item/stack/ore/titanium/loot/med            = 10,
		/obj/item/stack/ore/titanium/loot/high           = 10,
	)
	dropamt = 3


/obj/effect/meteor/episode/sand
	name = "space sand cluster"
	icon_state = "dust"
	hits = 2
	hit_power_rand = alist(
		EXPLODE_NONE = 5,
		EXPLODE_LIGHT = 20,
	)
	meteorsound = 'sound/items/weapons/gun/smg/shot.ogg'
	damage_profile = alist(
		EXPLODE_DEVASTATE = list(
			"mob_damage_low" = 100,
			"mob_damage_high" = 200,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 3,
			"damage_range" = 8,
		),
		EXPLODE_HEAVY = list(
			"mob_damage_low" = 50,
			"mob_damage_high" = 100,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 2,
			"damage_range" = 7,
		),
		EXPLODE_LIGHT = list(
			"mob_damage_low" = 20,
			"mob_damage_high" = 50,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 2,
			"damage_range" = 6,
		),
		EXPLODE_NONE = list(
			"mob_damage_low" = 10,
			"mob_damage_high" = 15,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH,
			"damage_range" = 5,
		),
	)
	meteordrop = list(
		/obj/item/stack/ore/iron/loot                   = 200,
		/obj/item/stack/ore/iron/loot/med               = 100,
		/obj/item/stack/ore/diamond/loot                = 1,
		/obj/item/stack/ore/diamond/loot/med            = 1,
		/obj/item/stack/ore/glass/loot                  = 200,
		/obj/item/stack/ore/glass/loot/med              = 100,
		/obj/item/stack/ore/bluespace_crystal/loot      = 5,
		/obj/item/stack/ore/bluespace_crystal/loot/med  = 2,
		/obj/item/stack/ore/gold/loot                   = 5,
		/obj/item/stack/ore/gold/loot/med               = 2,
		/obj/item/stack/ore/plasma/loot                 = 5,
		/obj/item/stack/ore/plasma/loot/med             = 2,
		/obj/item/stack/ore/silver/loot                 = 5,
		/obj/item/stack/ore/silver/loot/med             = 2,
		/obj/item/stack/ore/bananium/loot               = 5,
		/obj/item/stack/ore/bananium/loot/med           = 2,
		/obj/item/stack/ore/titanium/loot               = 5,
		/obj/item/stack/ore/titanium/loot/med           = 2,
		/obj/item/stack/ore/uranium/loot                = 5,
		/obj/item/stack/ore/uranium/loot/med            = 2,
	)
	dropamt = 1

/obj/effect/meteor/episode/sand/rich
	name = "rich space sand cluster"
	icon_state = "dust"
	hits = 2
	hit_power_rand = alist(
		EXPLODE_NONE = 10,
		EXPLODE_LIGHT = 5,
	)
	meteorsound = 'sound/items/weapons/gun/smg/shot.ogg'

	dropamt = 2

/obj/effect/meteor/episode/sand/resource
	name = "richer space sand cluster"
	icon_state = "dust"
	hits = 1
	hit_power_rand = alist(
		EXPLODE_NONE = 5,
		EXPLODE_LIGHT = 10,
		EXPLODE_HEAVY = 1,
	)
	meteorsound = 'sound/items/weapons/gun/smg/shot.ogg'

	meteordrop = list(
		/obj/item/stack/ore/iron/loot/high               = 100,
		/obj/item/stack/ore/diamond/loot/high            = 20,
		/obj/item/stack/ore/glass/loot/high              = 100,
		/obj/item/stack/ore/bluespace_crystal/loot/high  = 10,
		/obj/item/stack/ore/gold/loot/high               = 25,
		/obj/item/stack/ore/plasma/loot/high             = 35,
		/obj/item/stack/ore/silver/loot/high             = 25,
		/obj/item/stack/ore/bananium/loot/high           = 5,
		/obj/item/stack/ore/titanium/loot/high           = 80,
		/obj/item/stack/ore/uranium/loot/high            = 15,
	)
	dropamt = 3

/obj/effect/meteor/episode/meteor
	name = "space meteor"
	icon_state = "small"
	hits = 3
	hit_power_rand = alist(
		EXPLODE_NONE = 2,
		EXPLODE_LIGHT = 50,
		EXPLODE_HEAVY = 5,
	)
	meteorsound = 'sound/effects/meteorimpact.ogg'
	damage_profile = alist(
		EXPLODE_DEVASTATE = list(
			"mob_damage_low" = 100,
			"mob_damage_high" = 200,
			"mob_damage_type" = BRUTE,
			"mob_damage_mess_them_up" = TRUE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 2,
			"damage_range" = 11,
		),
		EXPLODE_HEAVY = list(
			"mob_damage_low" = 50,
			"mob_damage_high" = 100,
			"mob_damage_type" = BRUTE,
			"mob_damage_mess_them_up" = TRUE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH,
			"damage_range" = 10,
		),
		EXPLODE_LIGHT = list(
			"mob_damage_low" = 20,
			"mob_damage_high" = 50,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 2,
			"damage_range" = 9,
		),
		EXPLODE_NONE = list(
			"mob_damage_low" = 20,
			"mob_damage_high" = 25,
			"mob_damage_type" = BRUTE,
			"object_hurt_amount" = WINDOW_BASE_HEALTH * 1.5,
			"damage_range" = 8,
		),
	)
	meteordrop = list(
		/obj/item/stack/ore/iron/loot = 200,
		/obj/item/stack/ore/diamond/loot = 10,
		/obj/item/stack/ore/glass/loot = 10,
		/obj/item/stack/ore/bluespace_crystal/loot = 5,
		/obj/item/stack/ore/gold/loot = 5,
		/obj/item/stack/ore/plasma/loot = 30,
		/obj/item/stack/ore/silver/loot = 5,
		/obj/item/stack/ore/bananium/loot = 5,
		/obj/item/stack/ore/titanium/loot = 100,
		/obj/item/stack/ore/uranium/loot = 5,
	)
	dropamt = 4
	var/explode_chance_dev = 100
	var/explode_chance_heavy = 50
	var/explode_chance_light = 15
	var/explode_chance_flame = 100
	var/explode_range_dev = 1
	var/explode_range_heavy = 2
	var/explode_range_light = 3
	var/explode_range_flame = 5

/obj/effect/meteor/episode/meteor/meteor_effect()
	..()
	var/dev = 0
	var/heavy = 0
	var/light = 0
	var/flame = 0
	if(hitpwr >= EXPLODE_DEVASTATE)
		dev = prob(explode_chance_dev) * explode_range_dev
	if(hitpwr >= EXPLODE_HEAVY)
		if(dev)
			heavy = explode_range_heavy
		else
			heavy = prob(explode_chance_heavy) * explode_range_heavy
	if(hitpwr >= EXPLODE_LIGHT)
		if(heavy || dev)
			light = explode_range_light
		else
			light = prob(explode_chance_light) * explode_range_light
	if(dev || heavy || light)
		flame = explode_range_flame
	else
		flame = prob(explode_chance_flame) * explode_range_flame
	if(dev || heavy || light || flame)
		explosion(
			src,
			dev,
			heavy,
			light,
			flame,
			flame,
			smoke = TRUE,
			adminlog = FALSE)

/obj/effect/meteor/episode/meteor/mean
	name = "mean space meteor"
	icon_state = "small"
	hits = 3
	hit_power_rand = alist(
		EXPLODE_NONE = 5,
		EXPLODE_LIGHT = 40,
		EXPLODE_HEAVY = 100,
		EXPLODE_DEVASTATE = 1,
	)

	meteordrop = list(
		/obj/item/stack/ore/iron/loot = 200,
		/obj/item/stack/ore/diamond/loot = 100,
		/obj/item/stack/ore/glass/loot = 10,
		/obj/item/stack/ore/bluespace_crystal/loot = 5,
		/obj/item/stack/ore/gold/loot = 5,
		/obj/item/stack/ore/plasma/loot = 30,
		/obj/item/stack/ore/silver/loot = 5,
		/obj/item/stack/ore/bananium/loot = 5,
		/obj/item/stack/ore/titanium/loot = 100,
		/obj/item/stack/ore/uranium/loot = 5,
	)
	dropamt = 8
	explode_chance_dev = 100
	explode_chance_heavy = 50
	explode_chance_light = 75
	explode_chance_flame = 100
	explode_range_dev = 1
	explode_range_heavy = 2
	explode_range_light = 3
	explode_range_flame = 10


// matloots
/obj/item/stack/ore/iron/loot
	amount = 10
/obj/item/stack/ore/iron/loot/med
	amount = 30
/obj/item/stack/ore/iron/loot/high
	amount = 50

/obj/item/stack/ore/glass/loot
	amount = 10
/obj/item/stack/ore/glass/loot/med
	amount = 30
/obj/item/stack/ore/glass/loot/high
	amount = 50

/obj/item/stack/ore/diamond/loot
	amount = 2
/obj/item/stack/ore/diamond/loot/med
	amount = 3
/obj/item/stack/ore/diamond/loot/high
	amount = 4

/obj/item/stack/ore/bluespace_crystal/loot
	amount = 2
/obj/item/stack/ore/bluespace_crystal/loot/med
	amount = 3
/obj/item/stack/ore/bluespace_crystal/loot/high
	amount = 4

/obj/item/stack/ore/gold/loot
	amount = 5
/obj/item/stack/ore/gold/loot/med
	amount = 7
/obj/item/stack/ore/gold/loot/high
	amount = 12

/obj/item/stack/ore/plasma/loot
	amount = 5
/obj/item/stack/ore/plasma/loot/med
	amount = 7
/obj/item/stack/ore/plasma/loot/high
	amount = 15

/obj/item/stack/ore/silver/loot
	amount = 5
/obj/item/stack/ore/silver/loot/med
	amount = 10
/obj/item/stack/ore/silver/loot/high
	amount = 27

/obj/item/stack/ore/bananium/loot
	amount = 2
/obj/item/stack/ore/bananium/loot/med
	amount = 4
/obj/item/stack/ore/bananium/loot/high
	amount = 7

/obj/item/stack/ore/titanium/loot
	amount = 10
/obj/item/stack/ore/titanium/loot/med
	amount = 20
/obj/item/stack/ore/titanium/loot/high
	amount = 35

/obj/item/stack/ore/uranium/loot
	amount = 5
/obj/item/stack/ore/uranium/loot/med
	amount = 7
/obj/item/stack/ore/uranium/loot/high
	amount = 10

