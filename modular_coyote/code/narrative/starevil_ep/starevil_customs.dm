
// modifies radio transmissions to be worse
// can:
// - Anonymize the sender of radio transmissions
// - Replace parts of words with staticky noise
// - complete blackout
/datum/episode_event/radio_interference
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

/datum/episode_event/radio_interference/run_event(force, delay)
	update_current_interference_level()
	update_blackout_status()
	update_radios()

/datum/episode_event/radio_interference/OnRadioMessageReceived(
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

/datum/episode_event/radio_interference/proc/blackout(list/radio_data)
	if(SSnarrative.blackout_active_until < world.time)
		return FALSE
	// bluckedout!
	anonymize(radio_data, TRUE)
	cool_radio_scramble(radio_data, 100, 100, 100, 100, radio_data, force = TRUE, blackout = TRUE)
	return TRUE

/datum/episode_event/radio_interference/proc/anonymize(list/radio_data, force = FALSE, blackout = FALSE)
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

/datum/episode_event/radio_interference/proc/try_run_blackout()
	if(SSnarrative.blackout_active_until > world.time)
		return
	if(SSnarrative.blackout_cooldown_until > world.time)
		return
	if(!prob(blackout_chance))
		return
	var/blackout_dur = rand(blackout_min_duration, blackout_max_duration)
	var/blackout_cooldown_dur = rand(blackout_min_cooldown, blackout_max_cooldown)
	SSnarrative.blackout_active_until = world.time + blackout_dur
	SSnarrative.radio_blackout = TRUE
	SSnarrative.blackout_cooldown_until = world.time + blackout_cooldown_dur
	SSnarrative.radios_need_update = TRUE

/datum/episode_event/radio_interference/proc/update_current_interference_level()
	if(SSnarrative.current_interference_level != interference_level)
		SSnarrative.radios_need_update = TRUE
	SSnarrative.current_interference_level = interference_level

/datum/episode_event/radio_interference/proc/update_blackout_status()
	try_run_blackout()
	var/am_blout = SSnarrative.blackout_active_until > world.time
	if(SSnarrative.radio_blackout != am_blout)
		SSnarrative.radios_need_update = TRUE
	SSnarrative.radio_blackout = am_blout

/datum/episode_event/radio_interference/proc/update_radios(force = FALSE)
	if(!SSnarrative.radios_need_update)
		return
	SSnarrative.radios_need_update = FALSE
	var/list/radios = get_every_fucking_radio()
	for(var/obj/item/radio/rad as anything in radios)
		rad.update_interference()

/datum/episode_event/radio_interference/proc/get_every_fucking_radio()
	var/list/radios = list()
	if(SSnarrative.debug_radio_merger_lag)
		rustg_time_reset("radil_mergar_lage")
	for(var/freak in GLOB.all_radios)
		radios |= GLOB.all_radios[freak]
	if(SSnarrative.debug_radio_merger_lag)
		var/debug_duration = rustg_time_microseconds("radil_mergar_lage")
		to_chat(world, span_abductor("Radio merger took [debug_duration] microseconds!"))
	return radios


/datum/episode_event/radio_interference/starevil/phase_1
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

/datum/episode_event/radio_interference/starevil/phase_2
	unlock_phase = 2
	end_phase = 2
	anonymize_chance = 0
	corruption_chance = 5
	word_corruption_chance = 2
	letter_corruption_chance = 10
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 0
	blackout_min_duration = 0
	blackout_max_duration = 0
	blackout_min_cooldown = 0
	blackout_max_cooldown = 0

/datum/episode_event/radio_interference/starevil/phase_3
	unlock_phase = 3
	end_phase = 3
	anonymize_chance = 10
	corruption_chance = 10
	word_corruption_chance = 5
	letter_corruption_chance = 15
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 2
	blackout_min_duration = 5 SECONDS
	blackout_max_duration = 10 SECONDS
	blackout_min_cooldown = 20 SECONDS
	blackout_max_cooldown = 40 SECONDS

/datum/episode_event/radio_interference/starevil/phase_4
	unlock_phase = 4
	end_phase = 4
	anonymize_chance = 50
	corruption_chance = 50
	word_corruption_chance = 10
	letter_corruption_chance = 50
	letter_light_corruption_chance = 50
	interference_level = 3
	blackout_chance = 5
	blackout_min_duration = 5 SECONDS
	blackout_max_duration = 45 SECONDS
	blackout_min_cooldown = 20 SECONDS
	blackout_max_cooldown = 30 SECONDS

/datum/episode_event/radio_interference/starevil/phase_5
	unlock_phase = 5
	end_phase = 5
	anonymize_chance = 0
	corruption_chance = 10
	word_corruption_chance = 0
	letter_corruption_chance = 25
	letter_light_corruption_chance = 100
	interference_level = 1
	blackout_chance = 0

/datum/episode_event/radio_interference/starevil/phase_6
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
/datum/episode_event/lightfucker_pro
	event = null
	var/max_infected_lights = 0
	var/next_infect = 0
	var/min_infect_cooldown = 0
	var/max_infect_cooldown = 0

/datum/episode_event/lightfucker_pro/run_event(force, delay)
	if(max_infected_lights <= 0)
		return
	if(next_infect == 0)
		next_infect = world.time + rand(min_infect_cooldown, max_infect_cooldown)
	if(LAZYLEN(SSmachines.overloading_lights) >= max_infected_lights)
		return
	if(world.time < next_infect)
		return
	next_infect = world.time + rand(min_infect_cooldown, max_infect_cooldown)
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

/datum/episode_event/lightfucker_pro/starevil/phase_1
	unlock_phase = 1
	end_phase = 1
	max_infected_lights = 0

/datum/episode_event/lightfucker_pro/starevil/phase_2
	unlock_phase = 2
	end_phase = 2
	max_infected_lights = 1
	next_infect = 0
	min_infect_cooldown = 10 SECONDS
	max_infect_cooldown = 30 SECONDS

/datum/episode_event/lightfucker_pro/starevil/phase_3
	unlock_phase = 3
	end_phase = 3
	max_infected_lights = 3
	next_infect = 0
	min_infect_cooldown = 5 MINUTES
	max_infect_cooldown = 10 MINUTES

/datum/episode_event/lightfucker_pro/starevil/phase_4
	unlock_phase = 4
	end_phase = 4
	max_infected_lights = 20
	next_infect = 0
	min_infect_cooldown = 2 MINUTES
	max_infect_cooldown = 5 MINUTES

/datum/episode_event/lightfucker_pro/starevil/phase_5
	unlock_phase = 5
	end_phase = 5
	max_infected_lights = 1
	next_infect = 0
	min_infect_cooldown = 1 MINUTES
	max_infect_cooldown = 3 MINUTES

/datum/episode_event/lightfucker_pro/starevil/phase_6
	unlock_phase = 6
	end_phase = 6
	max_infected_lights = 0
	next_infect = 0
	min_infect_cooldown = 1 MINUTES
	max_infect_cooldown = 3 MINUTES

/// CORONAL MASS EJECTION EPISODE EVENT YEAH BUDDY
/datum/episode_event/coronal_mass_ejection
	event = null
	banned_area_flags = parent_type::banned_area_flags | NARRATIVE_AREA_FLAG_SPACE | NARRATIVE_AREA_FLAG_MAINTS | NARRATIVE_AREA_FLAG_ATMOS
	var/list/cme_stock = list()
	var/next_cme_strike = 0
	var/min_cme_cooldown = 10 MINUTES
	var/max_cme_cooldown = 15 MINUTES
	var/min_cme_spawns_per_fire = 1
	var/max_cme_spawns_per_fire = 1

/datum/episode_event/coronal_mass_ejection/run_event(force, delay)
	if(!LAZYLEN(cme_stock))
		return
	if(next_cme_strike == 0)
		next_cme_strike = world.time + rand(min_cme_cooldown, max_cme_cooldown)
	if(world.time < next_cme_strike)
		return
	next_cme_strike = world.time + rand(min_cme_cooldown, max_cme_cooldown)
	// pick a CME
	var/num2spawn = rand(min_cme_spawns_per_fire, max_cme_spawns_per_fire)
	var/list/spawned = list()
	for(var/i in 1 to num2spawn)
		var/obj/effect/cme/C = pick_weight_take(cme_stock)
		if(!istype(C))
			break
		var/tries = 5
		while(tries)
			tries--
			var/turf/T = get_safe_random_station_turf_equal_weight()
			if(!isopenturf(T) || is_in_banned_area(get_area(T), T))
				continue
			new C(T, (1 + (num2spawn * 0.5)))
			spawned += C
			break
	// alert the crew!
	if(LAZYLEN(spawned))
		var/total_badness = 0
		var/list/areas = list()
		for(var/obj/effect/cme/C as anything in spawned)
			total_badness += C.badness
			areas |= get_area(C)
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
		message += "-- Fuzzy Foxxo, Station Diagnostic Subpersona"
		minor_announce(message.Join("\n"), "ARFS Diagnostics Update", sound_override = sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))

/datum/episode_event/coronal_mass_ejection/starevil/phase3
	unlock_phase = 3
	end_phase = 3
	cme_stock = list(
		/obj/effect/cme = 2,
	)
	min_cme_cooldown = 10 MINUTES
	max_cme_cooldown = 15 MINUTES
	min_cme_spawns_per_fire = 1
	max_cme_spawns_per_fire = 1

/datum/episode_event/coronal_mass_ejection/starevil/phase4
	unlock_phase = 4
	end_phase = 4
	cme_stock = list(
		/obj/effect/cme = 50,
		/obj/effect/cme/moderate = 30,
		/obj/effect/cme/extreme = 10,
		/obj/effect/cme/armageddon = 2,
	)
	min_cme_cooldown = 3 MINUTES
	max_cme_cooldown = 5 MINUTES
	min_cme_spawns_per_fire = 1
	max_cme_spawns_per_fire = 3

/datum/episode_event/coronal_mass_ejection/starevil/phase5
	unlock_phase = 5
	end_phase = 5
	cme_stock = list(
		/obj/effect/cme = 100,
		/obj/effect/cme/moderate = 50,
	)
	min_cme_cooldown = 10 MINUTES
	max_cme_cooldown = 15 MINUTES
	min_cme_spawns_per_fire = 1
	max_cme_spawns_per_fire = 1







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
					if(prob(letter_light_corruption_chance) || (blackout && prob(80)))
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

GLOBAL_LIST_INIT(corruptions, corruptions = list(
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
		))
