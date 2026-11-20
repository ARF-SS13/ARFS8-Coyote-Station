
// modifies radio transmissions to be worse
// can:
// - Anonymize the sender of radio transmissions
// - Replace parts of words with staticky noise
// - complete blackout
/datum/episode_event/threadded/radio_interference // for the love of all that is hunkydory, only have one of tghese active at a time! though im not your mom and you can do whatever you want
	event = null
	// per-sendage probabilities for different types of interference
	// in percent
	var/anonymize_chance = 0
	var/corruption_chance = 0
	var/word_corruption_chance = 0
	var/letter_corruption_chance = 0
	var/letter_light_corruption_chance = 0
	var/interference_level = 0
	// per tick probabilities and timing for ongoing interference effects
	var/blackout_chance = 0
	var/blackout_min_duration = 0
	var/blackout_max_duration = 0
	var/blackout_min_cooldown = 0
	var/blackout_max_cooldown = 0

/datum/episode_event/threadded/radio_interference/run_event(force, delay)
	update_current_interference_level()
	update_blackout_status()
	update_radios()
	return TRUE

/datum/episode_event/threadded/radio_interference/OnRadioMessageReceived(
	mob/living/hearer,
	frequency,
	list/data,
	list/spans,
	list/radio_data, // the payload
	obj/item/radio/best_radio
)
	if(!islist(radio_data))
		return
	if(!istype(best_radio, /obj/item/radio))
		return
	if(SSnarrative.current_interference_level <= 0)
		return
	if(blackout(radio_data))
		return
	anonymize(radio_data)
	cool_radio_scramble(
		radio_data[SATA_MESSAGE_SPOKEN],
		corruption_chance,
		word_corruption_chance,
		letter_corruption_chance,
		letter_light_corruption_chance,
		radio_data,
		force = FALSE,
		blackout = SSnarrative.radio_blackout
		)

/datum/episode_event/threadded/radio_interference/proc/blackout(list/radio_data)
	if(SSnarrative.blackout_active_until < world.time)
		return FALSE
	// bluckedout!
	anonymize(radio_data, TRUE)
	cool_radio_scramble(radio_data, 100, 100, 100, 100, radio_data, force = TRUE, blackout = TRUE)
	return TRUE

/datum/episode_event/threadded/radio_interference/proc/anonymize(list/radio_data, force = FALSE, blackout = FALSE)
	if(!prob(anonymize_chance) && !force && !blackout)
		return
	var/static/list/anonynames = list(
		"Staticky Voice",
		"Distorted Signal",
		"Unknown Source",
		"Bitcrushed Voice",
		"Rhythmic Feedback",
		"Harsh Crackle",
		"~Kshht~",
		"~Brrt~",
		"~Crackle~",
		)
	var/anonyname = pick(anonynames)
	radio_data[SATA_DISPLAYED_NAME] = anonyname
	return TRUE

/datum/episode_event/threadded/radio_interference/proc/try_run_blackout()
	if(SSnarrative.blackout_active_until > world.time)
		return
	if(SSnarrative.blackout_cooldown_until > world.time)
		return
	if(!prob(blackout_chance))
		return
	var/blackout_dur = rand(blackout_min_duration, blackout_max_duration)
	var/blackout_cooldown_dur = rand(blackout_min_cooldown, blackout_max_cooldown)
	SSnarrative.blackout_active_until = world.time + SSnarrative.timescale_cooldown(blackout_dur)
	SSnarrative.radio_blackout = TRUE
	SSnarrative.blackout_cooldown_until = world.time + SSnarrative.timescale_cooldown(blackout_cooldown_dur)
	SSnarrative.radios_need_update = TRUE

/datum/episode_event/threadded/radio_interference/proc/update_current_interference_level()
	SSnarrative.anonymize_chance = anonymize_chance
	SSnarrative.word_corruption_chance = word_corruption_chance
	SSnarrative.letter_corruption_chance = letter_corruption_chance
	SSnarrative.letter_light_corruption_chance = letter_light_corruption_chance
	if(SSnarrative.current_interference_level != interference_level)
		SSnarrative.radios_need_update = TRUE
	SSnarrative.current_interference_level = interference_level

/datum/episode_event/threadded/radio_interference/proc/update_blackout_status()
	try_run_blackout()
	var/am_blout = SSnarrative.blackout_active_until > world.time
	if(SSnarrative.radio_blackout != am_blout)
		SSnarrative.radios_need_update = TRUE
	SSnarrative.radio_blackout = am_blout

/datum/episode_event/threadded/radio_interference/proc/update_radios(force = FALSE)
	if(!SSnarrative.radios_need_update)
		return
	SSnarrative.radios_need_update = FALSE
	var/list/radios = get_every_fucking_radio()
	for(var/obj/item/radio/rad as anything in radios)
		rad.update_interference()

/datum/episode_event/threadded/radio_interference/proc/get_every_fucking_radio()
	var/list/radios = list()
	if(SSnarrative.debug_radio_merger_lag)
		rustg_time_reset("radil_mergar_lage")
	for(var/freak in GLOB.all_radios)
		radios |= GLOB.all_radios[freak]
	if(SSnarrative.debug_radio_merger_lag)
		var/debug_duration = rustg_time_microseconds("radil_mergar_lage")
		to_chat(world, span_abductor("Radio merger took [debug_duration] microseconds!"))
	return radios


/datum/episode_event/threadded/radio_interference/starevil/phase_1
	unlock_phase = 1
	end_phase = 1
	anonymize_chance = 0
	corruption_chance = 0
	word_corruption_chance = 0
	letter_corruption_chance = 0
	letter_light_corruption_chance = 0
	interference_level = 0
	blackout_chance = 0
	blackout_min_duration = 0
	blackout_max_duration = 0
	blackout_min_cooldown = 0
	blackout_max_cooldown = 0

/datum/episode_event/threadded/radio_interference/starevil/phase_2
	unlock_phase = 2
	end_phase = 2
	anonymize_chance = 0
	corruption_chance = 100
	word_corruption_chance = 1
	letter_corruption_chance = 4
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 0
	blackout_min_duration = 0
	blackout_max_duration = 0
	blackout_min_cooldown = 0
	blackout_max_cooldown = 0

/datum/episode_event/threadded/radio_interference/starevil/phase_3
	unlock_phase = 3
	end_phase = 3
	anonymize_chance = 25
	corruption_chance = 100
	word_corruption_chance = 5
	letter_corruption_chance = 10
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 2
	blackout_min_duration = 5 SECONDS
	blackout_max_duration = 10 SECONDS
	blackout_min_cooldown = 20 SECONDS
	blackout_max_cooldown = 40 SECONDS

/datum/episode_event/threadded/radio_interference/starevil/phase_4
	unlock_phase = 4
	end_phase = 4
	anonymize_chance = 50
	corruption_chance = 100
	word_corruption_chance = 10
	letter_corruption_chance = 80
	letter_light_corruption_chance = 50
	interference_level = 3
	blackout_chance = 5
	blackout_min_duration = 5 SECONDS
	blackout_max_duration = 45 SECONDS
	blackout_min_cooldown = 20 SECONDS
	blackout_max_cooldown = 30 SECONDS

/datum/episode_event/threadded/radio_interference/starevil/phase_5
	unlock_phase = 5
	end_phase = 5
	anonymize_chance = 0
	corruption_chance = 10
	word_corruption_chance = 0
	letter_corruption_chance = 25
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 0

/datum/episode_event/threadded/radio_interference/starevil/phase_6
	unlock_phase = 6
	end_phase = 6
	anonymize_chance = 0
	corruption_chance = 10
	word_corruption_chance = 5
	letter_corruption_chance = 5
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 0

// lightfucker pro
/datum/episode_event/threadded/lightfucker_pro
	event = null
	var/max_infected_lights = 0
	var/next_infect = 0
	var/min_infect_cooldown = 0
	var/max_infect_cooldown = 0

/datum/episode_event/threadded/lightfucker_pro/run_event(force, delay)
	if(max_infected_lights <= 0)
		return
	if(next_infect == 0)
		next_infect = world.time + SSnarrative.timescale_cooldown(rand(min_infect_cooldown, max_infect_cooldown))
	if(LAZYLEN(SSmachines.overloading_lights) >= max_infected_lights)
		return
	if(world.time < next_infect)
		return
	next_infect = world.time + SSnarrative.timescale_cooldown(rand(min_infect_cooldown, max_infect_cooldown))
	var/obj/machinery/light/did = null
	// find a valadable light
	var/list/lights = SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light)
	var/tries = 30
	while(tries > 0 && !did)
		tries--
		var/obj/machinery/light/L = pick(lights)
		if(!L)
			break
		if(!L.can_overload())
			continue
		var/area/A = get_area(L)
		if(is_in_banned_area(A))
			continue
		L.set_overloading(TRUE)
		did = L
		break
	return TRUE

/datum/episode_event/threadded/lightfucker_pro/is_finished(phase)
	. = ..()
	if(.)
		return TRUE
	if(max_infected_lights <= 0)
		return TRUE
	if(LAZYLEN(SSmachines.overloading_lights) >= max_infected_lights)
		return TRUE
	return FALSE

/datum/episode_event/threadded/lightfucker_pro/starevil/phase_1
	unlock_phase = 1
	end_phase = 1
	max_infected_lights = 0

/datum/episode_event/threadded/lightfucker_pro/starevil/phase_2
	unlock_phase = 2
	end_phase = 2
	max_infected_lights = 1
	next_infect = 0
	min_infect_cooldown = 10 SECONDS
	max_infect_cooldown = 30 SECONDS

/datum/episode_event/threadded/lightfucker_pro/starevil/phase_3
	unlock_phase = 3
	end_phase = 3
	max_infected_lights = 3
	next_infect = 0
	min_infect_cooldown = 5 MINUTES
	max_infect_cooldown = 10 MINUTES

/datum/episode_event/threadded/lightfucker_pro/starevil/phase_4
	unlock_phase = 4
	end_phase = 4
	max_infected_lights = 20
	next_infect = 0
	min_infect_cooldown = 2 MINUTES
	max_infect_cooldown = 5 MINUTES

/datum/episode_event/threadded/lightfucker_pro/starevil/phase_5
	unlock_phase = 5
	end_phase = 5
	max_infected_lights = 1
	next_infect = 0
	min_infect_cooldown = 1 MINUTES
	max_infect_cooldown = 3 MINUTES

/datum/episode_event/threadded/lightfucker_pro/starevil/phase_6
	unlock_phase = 6
	end_phase = 6
	max_infected_lights = 0
	next_infect = 0
	min_infect_cooldown = 1 MINUTES
	max_infect_cooldown = 3 MINUTES

/// CORONAL MASS EJECTION EPISODE EVENT YEAH BUDDY
/datum/episode_event/threadded/coronal_mass_ejection
	event = null
	banned_area_flags = parent_type::banned_area_flags | NARRATIVE_AREA_FLAG_SPACE | NARRATIVE_AREA_FLAG_MAINTS | NARRATIVE_AREA_FLAG_ATMOS
	var/list/cme_stock = list()
	var/next_cme_strike = 0
	var/min_cme_cooldown = 10 MINUTES
	var/max_cme_cooldown = 15 MINUTES
	var/min_cme_spawns_per_fire = 1
	var/max_cme_spawns_per_fire = 1

/datum/episode_event/threadded/coronal_mass_ejection/run_event(force, delay)
	if(!LAZYLEN(cme_stock))
		return
	if(next_cme_strike == 0)
		next_cme_strike = world.time + SSnarrative.timescale_cooldown(rand(min_cme_cooldown, max_cme_cooldown))
	if(world.time < next_cme_strike)
		return
	next_cme_strike = world.time + SSnarrative.timescale_cooldown(rand(min_cme_cooldown, max_cme_cooldown))
	// Adjust the CME time, based on how messed up the radio communication is
	// cus these can cause some serious damage if not found, and the announcement is kinda important
	var/extramod = 1
	if(SSnarrative.radio_blackout)
		extramod += 1.5
	if(SSnarrative.word_corruption_chance > 5)
		extramod += 1
	if(SSnarrative.letter_corruption_chance > 50)
		extramod += 1
	// pick a CME
	var/num2spawn = rand(min_cme_spawns_per_fire, max_cme_spawns_per_fire)
	var/list/spawned = list()
	for(var/i in 1 to num2spawn)
		var/obj/effect/cme/C = pick_weight_take(cme_stock)
		if(!ispath(C))
			break
		var/tries = 5
		while(tries)
			tries--
			var/turf/T = get_safe_random_station_turf_equal_weight()
			if(!isopenturf(T) || is_in_banned_area(get_area(T), T))
				continue
			new C(T, (1 + (num2spawn * 0.5) + (extramod - 1)))
			spawned += C
			break
	// alert the crew!
	if(LAZYLEN(spawned))
		var/total_badness = 0
		var/list/areas = list()
		for(var/obj/effect/cme/C as anything in spawned)
			total_badness += C.badness
			var/area/A = get_area(C)
			areas |= A.name
		var/area_names = english_list(areas)
		var/list/message = list()
		message += "Anomalous bluespace stellar translocation activity detected in [area_names]!"
		switch(total_badness)
			if(0 to 1)
				message += "Intensity: Mild. Approach with caution."
			if(2 to 3)
				message += "Intensity: Moderate. Swift neutralization advised!"
			if(4 to 10)
				message += "Intensity: Extreme! Swift neutralization advised!"
			if(11 to 20)
				message += "Intensity: Catastrophic!! Widespread destruction imminent! Neutralization required!"
			else
				message += "Intensity: Omega! Multiple cataclysmic anomalies detected! Neutralize immediately, or all is lost!"
		message += "Consult Research for anomaly neutralization devices!"
		message += "Warning: Be alert for fires, extreme heat, and electrical discharges in affected areas!"
		message += "-- Fuzzy Foxxo, Station Operations Subpersona"
		var/messtring = message.Join("\n")
		// messtring = cool_radio_scramble(
		// 	messtring,
		// 	100,
		// 	SSnarrative.word_corruption_chance,
		// 	SSnarrative.letter_corruption_chance,
		// 	SSnarrative.letter_light_corruption_chance
		// )
		minor_announce(messtring, "ARFS Diagnostics Update", sound_override = sound('modular_skyrat/modules/cme/sound/cme_warning.ogg', volume = 40))
	return TRUE

/datum/episode_event/threadded/coronal_mass_ejection/starevil/is_finished(force)
	. = ..()
	if(.)
		return TRUE
	for(var/C in cme_stock)
		if(cme_stock[C] > 0)
			return FALSE
	return TRUE

/datum/episode_event/threadded/coronal_mass_ejection/starevil/phase3
	unlock_phase = 3
	end_phase = 3
	cme_stock = list(
		/obj/effect/cme = 1,
	)
	min_cme_cooldown = 10 MINUTES
	max_cme_cooldown = 15 MINUTES
	min_cme_spawns_per_fire = 1
	max_cme_spawns_per_fire = 1

/datum/episode_event/threadded/coronal_mass_ejection/starevil/phase4
	unlock_phase = 4
	end_phase = 4
	cme_stock = list(
		/obj/effect/cme = 50,
		/obj/effect/cme/moderate = 30,
		/obj/effect/cme/extreme = 10,
		/obj/effect/cme/armageddon = 2,
	)
	use_initial_delay = FALSE
	min_cme_cooldown = 9 MINUTES
	max_cme_cooldown = 10 MINUTES
	min_cme_spawns_per_fire = 1
	max_cme_spawns_per_fire = 2

/datum/episode_event/threadded/coronal_mass_ejection/starevil/phase5
	unlock_phase = 5
	end_phase = 5
	cme_stock = list(
		/obj/effect/cme = 100,
	)
	min_cme_cooldown = 15 MINUTES
	max_cme_cooldown = 20 MINUTES
	min_cme_spawns_per_fire = 1
	max_cme_spawns_per_fire = 1

/// makes space painful
/datum/episode_event/threadded/make_space_painful
	event = null
	does_life_effects = TRUE
	var/does_damage
	var/brute_armor = MELEE
	var/min_brute_dps = 0
	var/max_brute_dps = 0
	var/fire_armor = FIRE
	var/min_burn_dps = 0
	var/max_burn_dps = 0
	var/burn_temperature = PLASMA_UPPER_TEMPERATURE
	var/min_tox_dps = 0
	var/max_tox_dps = 0
	var/tox_armor = BIO
	var/tox_respects_toxinlovers = TRUE
	var/damage_chance = 0
	/// if not null, stop applying damage when this object is damaged
	/// otherwise, check the mobs stat
	var/stop_hurting_when_this_damaged
	var/alist/valid_stats = alist(
		CONSCIOUS = TRUE,
		SOFT_CRIT = TRUE,
		HARD_CRIT = TRUE,
	)
	var/fire_stack = 0
	var/max_fire_stack = 5
	var/min_temp_change = 0
	var/max_temp_change = 0
	var/list/damage_messages = list()
	var/list/fire_messages = list()
	var/list/sounds = list()

/datum/episode_event/threadded/make_space_painful/do_life_effects(mob/living/liver, seconds_per_tick)
	if(!isliving(liver) || !damage_chance)
		return
	// are they outside?
	var/turf/T = get_turf(liver)
	if(!isspaceturf(T))
		var/area/A = T.loc
		if(!istype(A, /area/space))
			return // not in space, probably
	if(!prob(damage_chance))
		return
	// damage sector
	// too messed up?
	if(isnull(stop_hurting_when_this_damaged))
		if(!valid_stats[liver.stat])
			return // stat aint in the thin gwe want to be
	else
		var/hurtedness = liver.get_total_damage()
		if(hurtedness >= stop_hurting_when_this_damaged)
			return
	// okay mess em up!
	var/did_something = FALSE
	var/space_suited = liver.calculate_affecting_pressure(0) >= (ONE_ATMOSPHERE * 0.9)
	var/uninsulation = 1
	if(iscarbon(liver))
		var/mob/living/carbon/carbor = liver
		uninsulation -= carbor.get_insulation_protection(burn_temperature) || 0
	if(does_damage())
		var/brute_dps = rand(min_brute_dps, max_brute_dps)
		var/burn_dps = rand(min_burn_dps, max_burn_dps)
		var/tox_dps = rand(min_tox_dps, max_tox_dps)
		var/overall_mult = 1
		if(space_suited)
			overall_mult *= 0.5
		burn_dps *= max(uninsulation, 0.05)
		// and the individual type multipliers for armor
		var/brute_armor_mult = 1
		var/burn_armor_mult = 1
		var/tox_armor_mult = 1
		if(brute_dps > 0)
			brute_armor_mult = 100 - liver.run_armor_check(
				def_zone = null,
				attack_flag = brute_armor,
				silent=TRUE,
			)
		if(burn_dps > 0)
			burn_armor_mult = 100 - liver.run_armor_check(
				def_zone = null,
				attack_flag = fire_armor,
				silent=TRUE,
			)
		if(tox_dps > 0)
			tox_armor_mult = 100 - liver.run_armor_check(
				def_zone = null,
				attack_flag = tox_armor,
				silent=TRUE,
			)
		brute_dps *= (brute_armor_mult / 100) * overall_mult * seconds_per_tick
		burn_dps *= (burn_armor_mult / 100) * overall_mult * seconds_per_tick
		tox_dps *= (tox_armor_mult / 100) * overall_mult * seconds_per_tick
		if(!tox_respects_toxinlovers && HAS_TRAIT(liver, TRAIT_TOXINLOVER))
			tox_dps *= -1 // basically ignoring toxinlover
		if(brute_dps || burn_dps || tox_dps)
			did_something = TRUE
			liver.take_overall_damage(
				brute_dps,
				burn_dps,
			)
			liver.adjust_tox_loss(tox_dps)
	// fire them!
	if(fire_stack)
		var/litaf = liver.on_fire
		liver.adjust_fire_stacks(fire_stack, /datum/status_effect/fire_handler/fire_stacks/spaceproof)
		liver.ignite_mob(!LAZYLEN(fire_messages))
		if(!litaf && liver.on_fire)
			if(LAZYLEN(fire_messages))
				var/fire_message = pick(fire_messages)
				if(fire_message)
					to_chat(liver, span_userdanger(fire_message))
			did_something = TRUE
	if(did_something)
		if(prob(5))
			if(LAZYLEN(damage_messages))
				var/damage_message = pick(damage_messages)
				if(damage_message)
					to_chat(liver, span_userdanger(damage_message))
			if(LAZYLEN(sounds))
				var/sound = pick(sounds)
				if(sound)
					liver.playsound_local(liver, sound, 60, TRUE)

/datum/episode_event/threadded/make_space_painful/proc/does_damage()
	if(!isnull(does_damage))
		return does_damage
	if(min_brute_dps != 0 && max_brute_dps != 0)
		goto yes
	if(min_burn_dps != 0 && max_burn_dps != 0)
		goto yes
	if(min_tox_dps != 0 && max_tox_dps != 0)
		goto yes
	does_damage = FALSE
	goto donezo
	yes:
	does_damage = TRUE
	goto donezo
	donezo:
	return does_damage // bite me

/datum/episode_event/threadded/make_space_painful/starevil/phase_3
	unlock_phase = 3
	end_phase = 3
	fire_armor = FIRE
	min_burn_dps = 1
	max_burn_dps = 2
	burn_temperature = PLASMA_UPPER_TEMPERATURE
	damage_chance = 5
	stop_hurting_when_this_damaged = 50
	valid_stats = alist(
		CONSCIOUS = TRUE,
	)
	fire_stack = 1
	damage_messages = list(
		"Solar winds lap at your flesh!",
		"The sun burns!",
		"Stellar heat sears your skin!",
	)
	fire_messages = list(
		"Solar flames engulf your body! It burns even in the vacuum of space!"
	)

/datum/episode_event/threadded/make_space_painful/starevil/phase_4
	unlock_phase = 4
	end_phase = 4
	event = null
	fire_armor = FIRE
	min_burn_dps = 5
	max_burn_dps = 10
	burn_temperature = PLASMA_UPPER_TEMPERATURE
	damage_chance = 25
	stop_hurting_when_this_damaged = null
	valid_stats = alist(
		CONSCIOUS = TRUE,
	)
	fire_stack = 1
	damage_messages = list(
		"The Sun! IT BURNS!! Get back inside!",
	)
	fire_messages = list(
		"Solar flames engulf your body! It burns even in the vacuum of space!"
	)







// to use when i want to make events look great and have time to do it, whcihs it not gnow
/datum/episode_event/threadded/change_space_appearance
	var/planet_layer =     /atom/movable/screen/parallax_layer/planet
	var/first_layer =      /atom/movable/screen/parallax_layer/layer_1
	var/second_layer =     /atom/movable/screen/parallax_layer/layer_2
	var/third_layer =      /atom/movable/screen/parallax_layer/layer_3
	var/asteroids_layer =  /atom/movable/screen/parallax_layer/asteroids
	var/space_gas_layer =  /atom/movable/screen/parallax_layer/random/space_gas




/atom/movable/screen/parallax_layer/layer_1/starevil


/atom/movable/screen/parallax_layer/layer_2/starevil


/atom/movable/screen/parallax_layer/layer_3/starevil


/atom/movable/screen/parallax_layer/planet/starevil

/atom/movable/screen/parallax_layer/asteroids
	icon_state = "asteroids"
	layer = 4


/atom/movable/screen/parallax_layer/random/space_gas/starevil
	var/starcolor = "#ffb790"
	parallax_color = list(
		0,0,0,0,
		2,2,0,0,
		0,0,0,0,
		0,0,0,1,
		0,0,0,0) // pale yellow, color matrix

/atom/movable/screen/parallax_layer/random/space_gas/starevil/apply_global_effects()
	. = ..()
	set_base_starlight(starcolor)

/atom/movable/screen/parallax_layer/random/space_gas/starevil/p2

/atom/movable/screen/parallax_layer/random/space_gas/starevil/p3




/proc/cool_radio_scramble(
	message_in,
	corruption_chance,
	word_corruption_chance,
	letter_corruption_chance,
	letter_light_corruption_chance,
	list/radio_data,
	force = FALSE,
	blackout = FALSE
)
	message_in = LAZYLEN(radio_data) ? radio_data[SATA_MESSAGE_SPOKEN] : message_in
	if(!corruption_chance)
		return message_in
	if(!prob(corruption_chance) && !force)
		return message_in
	var/list/words = splittext(message_in, " ")
	var/static/list/fuzz = list("░", "▒", "▓", "█",)

	for(var/i in 1 to LAZYLEN(words))
		var/worb = words[i]
		var/replo = ""
		if(prob(word_corruption_chance) || (blackout && prob(50)))
			for(var/j in 1 to LAZYLEN(worb))
				replo += pick(fuzz)
		else
			for(var/j in 1 to LAZYLEN(worb))
				if(blackout || prob(letter_corruption_chance))
					var/bv = lowertext("[worb[j]]")
					var/list/corrdat = list()
					if(prob(letter_light_corruption_chance) && !blackout)
						corrdat = GLOB.corruptions[bv]
					if(!LAZYLEN(corrdat))
						corrdat = GLOB.corruptions[pick(GLOB.corruptions)]
						if(!LAZYLEN(corrdat))
							corrdat = fuzz
					replo += pick(corrdat)
				else
					replo += worb[j]
					continue
		words[i] = replo
	message_in = words.Join(" ")
	if(LAZYLEN(radio_data))
		radio_data[SATA_MESSAGE_HEARD] = message_in
		radio_data[SATA_MESSAGE_HEARD_OVERRIDE] = message_in
	return message_in

GLOBAL_LIST_INIT(corruptions, list(
		"a" = list("@", "4", "Æ", "α", "á", "à", "ä", "â", "ᵜ", "ª", "Ɐ", "Ⱥ", "Ꜳ", "ꜳ", "Ꜽ", "Ꜻ"),
		"b" = list("8", "ß", "Ƃ", "β", "฿", "Ƀ"),
		"c" = list("ç", "¢", "Ƈ", "Ȼ", "Ꞓ", "ꞓ"),
		"d" = list("Ð", "Ɖ", "ȡ", "Ꞁ", "ꞁ"),
		"e" = list("€", "É", "È", "Ë", "Ê", "Ǝ", "Ɇ", "3", "ᴣ", "Ξ", "ɛ", "ɝ", "ɶ", "₠", "€", "≡"),
		"f" = list("Ƒ", "Ꞙ", "ꞙ", "ƒ", "ϝ", "ꟸ", "ꟹ"),
		"g" = list("9", "Ǥ", "ǥ", "ɠ", "Ꞡ", "ꞡ", "6", "ɢ", "Ձ", "Ճ", "Ծ", "Ժ", "Թ", "Ջ"),
		"h" = list("Ħ", "ħ", "Ȟ", "ȟ", "I", "Ԩ", "Ӝ", "ꜧ", "ꜩ", "Ḩ", "ḩ"),
		"i" = list("1", "!", "Í", "Ì", "Ï", "Î", "ɨ", "ı", "|", "ɩ", "ι", "ɪ", "ɩ", "ı", "¡"),
		"j" = list("Ɉ", "ɉ", "ʝ", "ɟ", "ʄ"),
		"k" = list("Ƙ", "ƙ", "Ꞣ", "ꞣ", "9", "H", "ĸ"),
		"l" = list("£", "Ŀ", "ŀ", "Ƚ", "ƚ", "1", "|", "↑", "↓", "↕", "║", "│", "Λ", "λ"),
		"m" = list("ɱ", "ϻ", "ꟽ", "ɯ", "ɰ", "ɱ", "ɳ", "ɲ", "ɴ"),
		"n" = list("Ñ", "ñ", "Ɲ", "Ƞ", "ɲ", "ɱ", "ϻ", "ꟽ", "ɯ", "ɰ", "ɱ", "ɳ", "ɲ", "ɴ"),
		"o" = list("0", "Ó", "Ò", "Ö", "Ô", "Ø", "Ǿ", "ɵ", "()", "◯", "○", "●"),
		"p" = list("Þ", "þ", "Ƥ", "ƥ", "q", "b", "d"),
		"q" = list("Ɋ", "ɋ", "9", "g", "b", "d", "p", ),
		"r" = list("Ŕ", "ŕ", "Ȑ", "ȑ", "Ɍ", "ɍ", "7", "ɼ", "ɽ", "ɾ", "ɿ"),
		"s" = list("$", "5", "Ś", "ś", "Š", "š", "Ş", "ş", "§", "Ƨ", "ƨ"),
		"t" = list("7", "+", "Ŧ", "ŧ", "Ƭ", "ƭ", "†", "ƫ", "Ʈ", "Ư", "ʈ"),
		"u" = list("Ú", "Ù", "Ü", "Û", "Ǔ", "Ǖ", "Ǘ", "Ǚ", "Ǜ", "ʉ", "µ", "υ", "ʊ"),
		"v" = list("Ʋ", "Ꝟ", "ꝟ", "√", "♥", "∨", "⩒"),
		"w" = list("Ŵ", "ŵ", "ɯ", "vv", "ɰ", "ɱ", "ɳ"),
		"x" = list("Ẍ", "ẍ", "Ẋ", "ẋ", "×", "χ", "><"),
		"y" = list("Ý", "Ÿ", "Ƴ", "ƴ", "¥", "Ɏ", "ɏ", "ʏ", "T", "τ", "t", "ɣ", "γ", "ψ", "Ψ", "ʎ", "ʏ", "ɥ", "Ỵ", "ỵ"),
		"z" = list("2", "Ž", "ž", "Ƶ", "ƶ", "ʐ", "ʑ", "Ȥ", "ȥ", "ƺ", "ƻ", "ȿ", "Ʒ", "ʒ"),
		"0" = list("O", "o", "()", "◯", "○", "●"),
		"1" = list("I", "l", "!", "|", "Ɩ", "١"),
		"2" = list("Z", "z", "Ƶ", "ƶ", "ʐ", "ʑ"),
		"3" = list("E", "e", "Ǝ", "Ɇ", "3"),
		"4" = list("A", "a", "4", "Δ", "Λ"),
		"5" = list("S", "s", "5", "$", "Ƨ", "ƨ"),
		"6" = list("G", "g", "6", "9"),
		"7" = list("T", "t", "7", "+"),
		"8" = list("B", "b", "8"),
		"9" = list("g", "q", "9"),
		"." = list(",", "·", "•", "˙", "。", "｡"),
		"," = list(".", "·", "•", "˙", "。", "｡"),
		"!" = list("1", "I", "l", "|", "¡"),
		"?" = list("¿", "7", "ʔ", "ʕ"),
		";" = list(":", "؛"),
		":" = list(";", "："),
		"(" = list(")", "[", "]", "{", "}", "<", ">", "⟨", "⟩"),
		")" = list("(", "[", "]", "{", "}", "<", ">", "⟨", "⟩"),
		"{" = list("}", "(", ")", "[", "]", "<", ">", "⟨", "⟩"),
		"}" = list("{", "(", ")", "[", "]", "<", ">", "⟨", "⟩"),
		"<" = list(">", "(", ")", "[", "]", "{", "}", "⟨", "⟩"),
		">" = list("<", "(", ")", "[", "]", "{", "}", "⟨", "⟩"),
		"*" = list("×", "✕", "✖", "✗", "✘"),
		"&" = list("and", "⅋", "⩓", "⩔"),
		"#" = list("№", "♯", "✱", "＊"),
		"%" = list("‰", "‱", "⩘", "⩙"),
		"@" = list("Ⓐ", "＠", "⍺", "α"),
		"^" = list("˄", "ˇ", "ˆ", "‵"),
		"~" = list("˜", "∼", "≈"),
		"`" = list("´", "‘", "’", "‛"),
		"|" = list("I", "l", "1", "¡"),
		"'" = list("`", "‘", "’", "‛"),
		"/" = list("\\", "∕", "／", "⧸", "⧹", "⧺", "⧻"),
		))
