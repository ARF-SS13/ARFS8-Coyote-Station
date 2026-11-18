/*
*	CME EVENT SYSTEM
*	SEE _CME_DEFINES.DM FOR SETTINGS.
*/

/* Welcome to the CME control system.
*
*	This controls the CME event, or coronal mass ejection event, which causes multiple EMP bubbles to form around the station
*	depending on conditons and time. There are currently 4 settings of CME, all of which have settings defined in the
*	cme defines DM file. See that for more info
*
*	Armageddon is truly going to fuck the station, use it sparingly.
*/

/datum/round_event_control/cme
	name = "Coronal Mass Ejection: Random"
	typepath = /datum/round_event/cme
	weight = 0
	max_occurrences = 0
	earliest_start = 45 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "Spawns a CME event of varied severities"

/datum/round_event/cme
	start_when = 6
	end_when	= 66
	announce_when = 10
	var/cme_intensity
	var/cme_frequency_lower
	var/cme_frequency_upper
	var/list/cme_start_locs = list()

/datum/round_event_control/cme/unknown
	name = "Coronal Mass Ejection: Unknown"
	typepath = /datum/round_event/cme/unknown
	weight = 15
	min_players = 75
	max_occurrences = 1
	description = "Spawns a CME event of a unknown severity"

/datum/round_event/cme/unknown
	cme_intensity = CME_UNKNOWN

/datum/round_event_control/cme/minimal
	name = "Coronal Mass Ejection: Minimal"
	typepath = /datum/round_event/cme/minimal
	weight = 0
	max_occurrences = 0
	description = "Spawns a CME event of minimum severity"

/datum/round_event/cme/minimal
	cme_intensity = CME_MINIMAL

/datum/round_event_control/cme/moderate
	name = "Coronal Mass Ejection: Moderate"
	typepath = /datum/round_event/cme/moderate
	weight = 0
	max_occurrences = 0
	description = "Spawns a CME event of moderate severity"

/datum/round_event/cme/moderate
	cme_intensity = CME_MODERATE

/datum/round_event_control/cme/extreme
	name = "Coronal Mass Ejection: Extreme"
	typepath = /datum/round_event/cme/extreme
	weight = 0
	min_players = 75
	max_occurrences = 0
	description = "Spawns a CME event of extreme severity"

/datum/round_event/cme/extreme
	cme_intensity = CME_EXTREME

/datum/round_event_control/cme/armageddon
	name = "Coronal Mass Ejection: Armageddon"
	typepath = /datum/round_event/cme/armageddon
	weight = 0
	max_occurrences = 0
	description = "Spawns a CME event of Arnageddon severity. WARNING this is round ending severe."

/datum/round_event/cme/armageddon
	cme_intensity = CME_ARMAGEDDON

/datum/round_event/cme/setup()
	if(!cme_intensity)
		cme_intensity = pick(CME_MINIMAL, CME_UNKNOWN, CME_MODERATE, CME_EXTREME)
	switch(cme_intensity)
		if(CME_UNKNOWN)
			cme_frequency_lower = CME_MODERATE_FREQUENCY_LOWER
			cme_frequency_upper = CME_MODERATE_FREQUENCY_UPPER
			start_when = rand(CME_MODERATE_START_LOWER, CME_MODERATE_START_UPPER)
			end_when = start_when + CME_MODERATE_END
		if(CME_MINIMAL)
			cme_frequency_lower = CME_MINIMAL_FREQUENCY_LOWER
			cme_frequency_upper = CME_MINIMAL_FREQUENCY_UPPER
			start_when = rand(CME_MINIMAL_START_LOWER, CME_MINIMAL_START_UPPER)
			end_when = start_when + CME_MINIMAL_END
		if(CME_MODERATE)
			cme_frequency_lower = CME_MODERATE_FREQUENCY_LOWER
			cme_frequency_upper = CME_MODERATE_FREQUENCY_UPPER
			start_when = rand(CME_MODERATE_START_LOWER, CME_MODERATE_START_UPPER)
			end_when = start_when + CME_MODERATE_END
		if(CME_EXTREME)
			cme_frequency_lower = CME_EXTREME_FREQUENCY_LOWER
			cme_frequency_upper = CME_EXTREME_FREQUENCY_UPPER
			start_when = rand(CME_EXTREME_START_LOWER, CME_EXTREME_START_UPPER)
			end_when = start_when + CME_EXTREME_END
		if(CME_ARMAGEDDON)
			cme_frequency_lower = CME_ARMAGEDDON_FREQUENCY_LOWER
			cme_frequency_upper = CME_ARMAGEDDON_FREQUENCY_UPPER
			start_when = rand(CME_ARMAGEDDON_START_LOWER, CME_ARMAGEDDON_START_UPPER)
			end_when = start_when + CME_ARMAGEDDON_END
		else
			message_admins("CME setup failure, aborting.")
			kill()

	for(var/turf/open/floor/T in world)
		var/area/turf_area = get_area(T)
		if(is_station_level(T.z) && !istype(turf_area, /area/solars) && !istype(turf_area, /area/icemoon))
			cme_start_locs += T

/datum/round_event/cme/announce(fake)
	if(fake)
		priority_announce("Critical Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [rand(200, 300)] seconds. \
		All synthetic and non-organic lifeforms should seek shelter immediately! \
		Ensure all sensitive equipment is shielded.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
	else
		switch(cme_intensity)
			if(CME_UNKNOWN)
				priority_announce("Coronal mass ejection detected! Expected intensity: UNKNOWN. Impact in: [round((start_when * SSevents.wait) * 0.1, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Neutralize magnetic field bubbles at all costs.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_MINIMAL)
				priority_announce("Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((start_when * SSevents.wait) * 0.1, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Neutralize magnetic field bubbles at all costs.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_MODERATE)
				priority_announce("Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((start_when * SSevents.wait) * 0.1, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Neutralize magnetic field bubbles at all costs.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_EXTREME)
				addtimer(CALLBACK(src, PROC_REF(cme_level_callback), SEC_LEVEL_ORANGE, TRUE, FALSE), (round((start_when * SSevents.wait) * 0.1, 0.1)) SECONDS)
				priority_announce("Critical Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((start_when * SSevents.wait) * 0.1, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Neutralize magnetic field bubbles at all costs.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_ARMAGEDDON)
				addtimer(CALLBACK(src, PROC_REF(cme_level_callback), SEC_LEVEL_GAMMA, TRUE, TRUE), (round((start_when * SSevents.wait) * 0.1, 0.1)) SECONDS)
				priority_announce("Neutron Mass Ejection Detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((start_when * SSevents.wait) * 0.1, 0.1)] seconds. \
				All personnel should proceed to their nearest warpgate for evacuation, the Terran Government has issued this mandatory alert.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))

/datum/round_event/cme/tick(seconds_between_ticks)
	if(ISMULTIPLE(activeFor, rand(cme_frequency_lower, cme_frequency_upper)))
		var/turf/spawnpoint = pick(cme_start_locs)
		spawn_cme(spawnpoint, cme_intensity)

/datum/round_event/cme/proc/cme_level_callback(sec_level = SEC_LEVEL_ORANGE, engi = TRUE, maint = FALSE)
	INVOKE_ASYNC(SSsecurity_level, TYPE_PROC_REF(/datum/controller/subsystem/security_level/, minimum_security_level), sec_level, engi, maint)

/datum/round_event/cme/proc/spawn_cme(turf/spawnpoint, intensity)
	if(intensity == CME_UNKNOWN)
		intensity = pick(CME_MINIMAL, CME_MODERATE, CME_EXTREME)
		if(intensity == CME_EXTREME)
			INVOKE_ASYNC(SSsecurity_level, TYPE_PROC_REF(/datum/controller/subsystem/security_level/, minimum_security_level), SEC_LEVEL_ORANGE, TRUE, FALSE)

	var/area/loc_area_name = get_area(spawnpoint)
	minor_announce("WARNING! [uppertext(intensity)] PULSE EXPECTED IN: [loc_area_name.name]", "Solar Flare Log:")
	switch(intensity)
		if(CME_MINIMAL)
			var/obj/effect/cme/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)
		if(CME_MODERATE)
			var/obj/effect/cme/moderate/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)
		if(CME_EXTREME)
			var/obj/effect/cme/extreme/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)
		if(CME_ARMAGEDDON)
			var/obj/effect/cme/armageddon/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)


/datum/round_event/cme/end()
	minor_announce("The station has cleared the solar flare, please proceed to repair electronic failures.", "CME cleared:")


/*
*	CME BUBBLES
*/

/obj/effect/cme
	desc = "A bluespace anomaly connecting our lovely station to the heart of our lovely nearby star. \
		You might want to do something about this before it explodes!"
	name = "Class I bluespace stellar ejecta translocation anomaly"
	icon = 'modular_skyrat/modules/cme/icons/cme_effect.dmi'
	icon_state = "cme_effect"
	var/flavortext = "Looks fairly small, on the lower end of the intensity spectrum for these anomalies. \
		It'll still mess you up if you ignore it, though!"
	color = COLOR_BLUE_LIGHT
	light_range = 5
	light_power = 2
	light_color = COLOR_BLUE_LIGHT
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	plane = ABOVE_LIGHTING_PLANE
	can_atmos_pass = ATMOS_PASS_DENSITY
	var/badness = 1
	var/delay_duration = CME_MINIMAL_BUBBLE_BURST_TIME
	var/burst_time = 0
	var/cme_light_range_lower = CME_MINIMAL_LIGHT_RANGE_LOWER
	var/cme_light_range_upper = CME_MINIMAL_LIGHT_RANGE_UPPER
	var/cme_heavy_range_lower = CME_MINIMAL_HEAVY_RANGE_LOWER
	var/cme_heavy_range_upper = CME_MINIMAL_HEAVY_RANGE_UPPER
	var/neutralized = FALSE
	var/loots = 1
	var/explode_light = 1
	var/explode_heavy = 0
	var/explode_devastate = 0
	var/explode_fire = 5

	var/next_gas_spurt = 0
	var/gas_spurt_interval_min = 30 SECONDS
	var/gas_spurt_interval_max = 60 SECONDS
	var/gas_emit_spawn = "o2=5;hydrogen=5;TEMP=450"

	var/next_zap = 0
	var/zap_interval_min = 10 SECONDS
	var/zap_interval_max = 10 SECONDS
	var/zap_range = 5
	var/zap_damage = 10
	var/zap_sound = 'modular_coyote/sounds/effects/zapblast.ogg'

	var/list/gasses_emit_tick = list(
		"o2=1;hydrogen=1;TEMP=450",
	)
	var/gas_emit_burst = "plasma=10;TEMP=500"
	var/gas_emit_burst_safe = "halon=30;TEMP=293.15"
	var/spawn_sound = 'modular_coyote/sounds/cme_event/cme_spawn.ogg'
	var/burst_sound = 'modular_coyote/sounds/cme_event/cme_explode.ogg'
	var/gas_spurt_sound = 'modular_coyote/sounds/cme_event/cme_sizzle.ogg'
	var/neutralize_sound = 'modular_coyote/sounds/cme_event/cme_neutralized.ogg'
	var/datum/looping_sound/cme_existing/soundloop

/obj/effect/cme/moderate
	name = "Class II bluespace stellar ejecta translocation anomaly"
	flavortext = "This anomaly poses a significant threat, being a larger portal to the nearby star. \
		Be careful, this anomaly can mess you up!"
	color = COLOR_VIVID_YELLOW
	light_color = COLOR_VIVID_YELLOW
	badness = 2
	delay_duration = CME_MODERATE_BUBBLE_BURST_TIME
	cme_light_range_lower = CME_MODERATE_LIGHT_RANGE_LOWER
	cme_light_range_upper = CME_MODERATE_LIGHT_RANGE_UPPER
	cme_heavy_range_lower = CME_MODERATE_HEAVY_RANGE_LOWER
	cme_heavy_range_upper = CME_MODERATE_HEAVY_RANGE_UPPER
	loots = 2
	explode_light = 2
	explode_heavy = 0
	explode_devastate = 0
	explode_fire = 7
	gas_spurt_interval_min = 10 SECONDS
	gas_spurt_interval_max = 20 SECONDS
	gas_emit_spawn = "o2=15;plasma=15;TEMP=550"
	zap_interval_min = 5 SECONDS
	zap_interval_max = 15 SECONDS
	zap_range = 7
	zap_damage = 20
	gasses_emit_tick = list(
		"o2=4;plasma=4;TEMP=450",
		"o2=3;hydrogen=3;TEMP=450",
	)
	gas_emit_burst = "plasma=15;hydrogen=30;o2=45;TEMP=500"
	gas_emit_burst_safe = "halon=30;TEMP=293.15"


/obj/effect/cme/extreme
	name = "Class X bluespace stellar ejecta translocation anomaly"
	flavortext = "This anomaly is extremely dangerous, forming a massive portal to the nearby star. \
		Exercise extreme caution when approaching this anomaly!"
	color = COLOR_RED
	light_color = COLOR_RED
	badness = 5
	delay_duration = CME_EXTREME_BUBBLE_BURST_TIME
	cme_light_range_lower = CME_EXTREME_LIGHT_RANGE_LOWER
	cme_light_range_upper = CME_EXTREME_LIGHT_RANGE_UPPER
	cme_heavy_range_lower = CME_EXTREME_HEAVY_RANGE_LOWER
	cme_heavy_range_upper = CME_EXTREME_HEAVY_RANGE_UPPER
	loots = 3
	explode_light = 4
	explode_heavy = 2
	explode_devastate = 0
	explode_fire = 12
	gas_spurt_interval_min = 5 SECONDS
	gas_spurt_interval_max = 15 SECONDS
	gas_emit_spawn = "o2=30;plasma=10;tritium=10;hydrogen=10;TEMP=550"
	zap_interval_min = 5 SECONDS
	zap_interval_max = 15 SECONDS
	zap_range = 7
	zap_damage = 20
	gasses_emit_tick = list(
		"o2=4;plasma=4;TEMP=450",
		"o2=3;hydrogen=3;TEMP=450",
		"o2=2;tritium=2;TEMP=450",
	)
	gas_emit_burst = "plasma=30;hydrogen=30;o2=60;TEMP=500"
	gas_emit_burst_safe = "halon=30;TEMP=293.15"

/obj/effect/cme/armageddon
	badness = 10
	name = "Class Ω bluespace stellar ejecta translocation anomaly"
	flavortext = "A massive one-way portal to the heart of the nearby star! Destroy it immediately \
		before it obliterates everything around it!"
	color = COLOR_VIOLET
	light_color = COLOR_VIOLET
	delay_duration = CME_ARMAGEDDON_BUBBLE_BURST_TIME
	cme_light_range_lower = CME_ARMAGEDDON_LIGHT_RANGE_LOWER
	cme_light_range_upper = CME_ARMAGEDDON_LIGHT_RANGE_UPPER
	cme_heavy_range_lower = CME_ARMAGEDDON_HEAVY_RANGE_LOWER
	cme_heavy_range_upper = CME_ARMAGEDDON_HEAVY_RANGE_UPPER
	loots = 5
	explode_light = 5
	explode_heavy = 6
	explode_devastate = 4
	explode_fire = 15
	gas_spurt_interval_min = 5 SECONDS
	gas_spurt_interval_max = 7 SECONDS
	gas_emit_spawn = "o2=15;plasma=15;TEMP=550"
	zap_interval_min = 5 SECONDS
	zap_interval_max = 15 SECONDS
	zap_range = 10
	zap_damage = 30
	gasses_emit_tick = list(
		"o2=4;plasma=4;TEMP=450",
		"o2=3;hydrogen=3;TEMP=450",
		"o2=5;tritium=5;TEMP=450"
	)
	gas_emit_burst = "tritium=100;hydrogen=50;plasma=50;o2=200;TEMP=500"
	gas_emit_burst_safe = "halon=30;TEMP=293.15"

/obj/effect/cme/Initialize(mapload, burst_time_mult = 1)
	. = ..()
	burst_time = (delay_duration * burst_time_mult) + world.time
	next_gas_spurt = rand(gas_spurt_interval_min, gas_spurt_interval_max) + world.time
	next_zap = rand(zap_interval_min, zap_interval_max) + world.time
	playsound(src, spawn_sound, 100, TRUE, 20, ignore_walls = TRUE)
	var/turf/open/T = get_turf(src)
	if(gas_emit_spawn && isopenturf(T))
		T.atmos_spawn_air(gas_emit_spawn)
	START_PROCESSING(SSprocessing, src)
	soundloop = new(src, TRUE)

/obj/effect/cme/Destroy(force)
	QDEL_NULL(soundloop)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/effect/cme/examine(mob/user)
	. = ..()
	var/timeleft = DisplayTimeText(burst_time - world.time)
	if(flavortext)
		. += span_notice(flavortext)
	if(neutralized)
		. += span_green("The anomalous rift appears to have been neutralized, and should fade away in around [timeleft].")
		return
	. += span_alert("WARNING: Rift is active! Expected detonation in around [span_phobia(timeleft)].")
	. += span_alert("Beware its electrical and gaseous emissions!")
	. += span_green("It appears to be similar to common anomalies, try using an anomaly neutralizer!")

/obj/effect/cme/process(seconds_per_tick)
	if(world.time > burst_time)
		spew_gas(TRUE)
		bfg_zap(TRUE)
		burst()
		return
	if(!neutralized)
		spew_gas()
		bfg_zap()

/obj/effect/cme/proc/spew_gas(force = FALSE)
	if(!LAZYLEN(gasses_emit_tick))
		return
	if(neutralized)
		return
	if(!force && world.time < next_gas_spurt)
		return
	next_gas_spurt = rand(gas_spurt_interval_min, gas_spurt_interval_max) + world.time
	var/turf/open/T = get_turf(src)
	if(isopenturf(T))
		T.atmos_spawn_air(pick(gasses_emit_tick))
	playsound(src, gas_spurt_sound, 100, TRUE)

/obj/effect/cme/proc/bfg_zap(force = FALSE)
	if(!force && world.time < next_zap)
		return
	if(neutralized)
		return
	next_zap = rand(zap_interval_min, zap_interval_max) + world.time
	playsound(src, zap_sound, 100, TRUE, 20, ignore_walls = TRUE)
	tesla_zap(
		src,
		zap_range,
		zap_damage * 600,
		zap_damage * 100,
	)

/obj/effect/cme/proc/burst()
	if(neutralized)
		visible_message(span_notice("[src] fizzles out into nothingness."))
		new /obj/effect/particle_effect/fluid/smoke/bad(loc)
		qdel(src)
		return
	var/turf/open/T = get_turf(src)
	if(gas_emit_burst && isopenturf(T))
		T.atmos_spawn_air(gas_emit_burst)
	var/pulse_range_light = rand(cme_light_range_lower, cme_light_range_upper)
	var/pulse_range_heavy = rand(cme_heavy_range_lower, cme_heavy_range_upper)
	empulse(
		src,
		pulse_range_heavy,
		pulse_range_light
		)
	playsound(src, burst_sound, 100, TRUE)
	explosion(
		src,
		explode_light,
		explode_heavy,
		explode_devastate,
		explode_fire,
		explosion_no_breach = TRUE
		)
	qdel(src)

/obj/effect/cme/singularity_pull()
	burst()

/obj/effect/cme/proc/anomalyNeutralize()
	var/turf/T = get_turf(src)
	playsound(src, neutralize_sound, 100, TRUE)
	new /obj/effect/particle_effect/fluid/smoke/bad(T)
	color = COLOR_WHITE
	light_color = COLOR_WHITE
	neutralized = TRUE
	for(var/i in 1 to loots)
		var/atom/movable/loot = pick_weight(GLOB.cme_loot_list)
		new loot(T)

