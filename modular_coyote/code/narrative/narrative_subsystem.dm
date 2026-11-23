// ╔═════════╤═════════════════════════╗
// ║ File    │ narrative_subsystem.dm  ║
// ║ Date    │ 1974-06-14 12:52 EST    ║
// ║ Author  │ Dan 'Carpswarm' Kelly   ║
// ║ License │ FLOSS                   ╚═══════════════════════════╗
// ║ Quote   │ "In this episode, the gang gets attacked by sharks" ║
// ╟─────────┼─────────────────────────────────────────────────────╨────────────────────────────────╖
// ║         │                                                                                      ║
// ║  ####   │ A custom event scheduler for semiguided 'episode' style rounds, where theres a       ║
// ║  ####   │ buildup, reveal, the main baddie, and wrap up. Cus stories are better when they      ║
// ║  ####   │ are a story, not just random events! though we still got those lol                   ║
// ║  ####   │                                                                                      ║
// ║  ####   │ Categorizes events into threat levels, which are set to happen after certain times   ║
// ║  ####   │ in the round. These are picked by the A-Plot to guide the story. Chosen events are   ║
// ║  ####   │ generally themized to fit a certain vibe and buildup and such.                       ║
// ║         │                                                                                      ║
// ╟─────────┼──────────────────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ==================================================================================  ║
// ╚═════════╧══════════════════════════════════════════════════════════════════════════════════════╝

SUBSYSTEM_DEF(narrative)
	name = "Narrative"
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND | SS_KEEP_TIMING
	wait = 5 SECONDS
	dependencies = list(
		// we kinda need it lol
		/datum/controller/subsystem/gamemode,
	)
	var/wait_override

	var/list/all_episodes = list()
	var/datum/episode/current_episode = null
	var/datum/episode/forced_episode = null
	var/datum/narrative_vote_option/winning_option = null
	var/action_episode_wanted = FALSE
	var/ignore_pop_count = FALSE
	// so people who are fucking each other's brains out wont count towards the pop
	var/list/comfy_trackers = list()
	var/spider_chance = 50
	var/ratboy_chance = 50

	var/action_scalar_override = null

	var/list/vote_options = list()

	var/list/life_active_events = list()

	var/list/banned_area_cache = list()

	var/anonymize_chance = 0
	var/word_corruption_chance = 0
	var/letter_corruption_chance = 0
	var/letter_light_corruption_chance = 0

	var/current_interference_level = 0
	var/radio_blackout = FALSE
	var/radios_need_update = FALSE
	var/blackout_active_until = 0
	var/blackout_cooldown_until = 0

	var/phase_1_start = 0
	var/phase_2_start = 30 MINUTES
	var/phase_3_start = 1 HOURS
	var/phase_4_start = 1.5 HOURS
	var/phase_5_start = 2 HOURS
	var/phase_6_start = 2.5 HOURS
	var/phase_min = 1
	var/phase_max = 6
	var/phase_override = null

	var/timescale_factor = 1

	var/debug_radio_merger_lag = FALSE

	var/datum/narrative_episode_vote/votie
	var/awaiting_vote = TRUE

/datum/controller/subsystem/narrative/Initialize()
	build_episode_list()
	start_the_vote()
	// load_episode_history()
	. = ..()
	var/list/thingse = list(
		"Stay tuned!",
		"Don't touch that dial!",
		"Coming soon to a space station near you!",
	)
	spawn(20 SECONDS)
		to_chat(world, span_boldnotice("Initialized [LAZYLEN(all_episodes)] distinct potential episodes! [pick(thingse)]"))

/datum/controller/subsystem/narrative/fire(resumed)
	if(!current_episode)
		if(awaiting_vote)
			awaiting_vote = check_da_vote()
			return
		check_tv_guide()
		return
	current_episode.fire()
	if(timescale_factor == 1)
		wait = initial(wait)
		return
	if(!isnull(wait_override))
		wait = wait_override
	else
		wait = initial(wait) / timescale_factor

/datum/controller/subsystem/narrative/proc/start_the_vote()
	vote_options = list()
	vote_options += new /datum/narrative_vote_option/high_intensity()
	vote_options += new /datum/narrative_vote_option/medium_intensity()
	vote_options += new /datum/narrative_vote_option/low_intensity()
	votie = new /datum/narrative_episode_vote()
	votie.start_vote()

/datum/controller/subsystem/narrative/proc/has_vote_active()
	if(!votie)
		return FALSE
	return votie.vote_active

/datum/controller/subsystem/narrative/proc/check_da_vote()
	if(current_episode)
		return
	if(!votie)
		return
	if(forced_episode)
		return
	if(!votie.vote_active)
		return
	// is it over? as in, is game playing now yet?
	if(SSticker.current_state < GAME_STATE_PLAYING)
		return TRUE
	// ok determine which episode we're doing
	votie.tally_and_finish()
	awaiting_vote = FALSE
	// should be a number bertween 1 and 3
	var/numbor = trunc(votie.vote_result)
	var/fractio = fract(votie.vote_result)
	if(fractio > 0)
		if(fractio >= 0.5)
			if(prob(fractio * 100))
				numbor += 1
		else if(fractio < 0.5)
			if(prob((1 - fractio) * 100))
				numbor -= 1
	numbor = clamp(numbor, 1, 3)
	switch(numbor)
		if(1)
			action_episode_wanted = FALSE
		if(2)
			action_episode_wanted = prob(50)
		if(3)
			action_episode_wanted = TRUE
			ignore_pop_count = TRUE
	winning_option = get_option_for_numbor(numbor)
	message_admins("Narrative vote: [numbor], action_episode_wanted=[action_episode_wanted], ignore_pop_count=[ignore_pop_count]")
	check_tv_guide()

/datum/controller/subsystem/narrative/proc/build_episode_list()
	for(var/datum/episode/ep as anything in subtypesof(/datum/episode))
		all_episodes += new ep()

/datum/controller/subsystem/narrative/proc/get_option_for_numbor(numbor)
	for(var/datum/narrative_vote_option/opt in vote_options)
		if(opt.option_value == numbor)
			return opt
	return null

/datum/controller/subsystem/narrative/proc/get_splash_vote_options(ckey)
	if(!votie || !votie.vote_active)
		return null
	ckey = extract_ckey(ckey)
	var/list/options = list()
	var/voted_for = votie.votes[ckey] // 1, 2, 3, or null
	for(var/datum/narrative_vote_option/opt in vote_options)
		options[opt] = (voted_for == opt.option_value)
	return options

/datum/controller/subsystem/narrative/proc/get_action_scalar(inverted = FALSE)
	if(!isnull(action_scalar_override))
		if(inverted)
			return 1 / action_scalar_override
		return action_scalar_override
	if(!winning_option)
		return 1
	if(inverted)
		return winning_option.action_scalar_inverse
	return winning_option.action_scalar

/// spends the first couple minutes of the round checking the player count and such for
/// which episodes may be a good idea to do. or just picks one at random cus i gotta get this damn thing done at some point
/datum/controller/subsystem/narrative/proc/check_tv_guide()
	if(forced_episode)
		for(var/datum/episode/ep as anything in all_episodes)
			if(ep.type == forced_episode::type)
				current_episode = ep
				return
	if(LAZYLEN(all_episodes))
		var/list/potential_episodes = list()
		for(var/datum/episode/ep as anything in all_episodes)
			if(!action_episode_wanted && !ep.is_actiony)
				potential_episodes += ep
				continue
			else if(action_episode_wanted && ep.is_actiony)
				potential_episodes += ep
		if(LAZYLEN(potential_episodes))
			current_episode = pick(potential_episodes)
		else
			current_episode = pick(all_episodes)
	else
		CRASH("No episodes available to pick from! Screw you!")
	if(current_episode)
		current_episode.start_episode(winning_option)


// make these check the current episode for the spider and ratboy chances instead of using static values
/datum/controller/subsystem/narrative/proc/GetSpiderChance()
	return spider_chance

/datum/controller/subsystem/narrative/proc/GetRatboyChance()
	return ratboy_chance

/datum/controller/subsystem/narrative/proc/get_episode_title(capspls)
	if(current_episode)
		if(current_episode.noname)
			return null
		if(capspls)
			return uppertext(current_episode.name)
		return current_episode.name
	return null

/datum/controller/subsystem/narrative/proc/handle_life_effects(mob/living/them, seconds_per_tick)
	if(!LAZYLEN(life_active_events))
		return
	for(var/datum/episode_event/threadded/event as anything in life_active_events)
		event.try_life_effects(them, seconds_per_tick)

/datum/controller/subsystem/narrative/proc/OnRadioMessageReceived(
	atom/movable/hearer,
	frequency,
	list/data,
	list/spans,
	list/radio_data,
	obj/item/radio/best_radio
)
	if(!current_episode)
		return
	if(!isliving(hearer))
		return
	var/mob/living/hearer_living = hearer
	if(!hearer_living.client)
		return
	current_episode.OnRadioMessageReceived(hearer_living, frequency, data, spans, radio_data, best_radio)

/datum/controller/subsystem/narrative/proc/get_round_phase(override)
	var/round_phase = 1
	if(!isnull(override))
		round_phase = override
	else if(!isnull(phase_override))
		round_phase = phase_override
	else
		var/roundtime_elapsed = get_scaled_time()
		if(roundtime_elapsed < phase_2_start)
			round_phase = 1
		else if(roundtime_elapsed < phase_3_start)
			round_phase = 2
		else if(roundtime_elapsed < phase_4_start)
			round_phase = 3
		else if(roundtime_elapsed < phase_5_start)
			round_phase = 4
		else if(roundtime_elapsed < phase_6_start)
			round_phase = 5
		else
			round_phase = 6
	round_phase = clamp(round_phase, phase_min, phase_max)
	return round_phase

/datum/controller/subsystem/narrative/proc/get_scaled_time()
	return (world.time - SSticker.round_start_time) * timescale_factor

/datum/controller/subsystem/narrative/proc/timescale_cooldown(vale)
	return vale / timescale_factor

/datum/controller/subsystem/narrative/proc/typecache_banned_areas(flags)
	if(LAZYLEN(SSnarrative.banned_area_cache["[flags]"]))
		return // already there
	SSnarrative.banned_area_cache["[flags]"] = list()
	var/list/typecache_precum = list()
	if(flags & NARRATIVE_AREA_FLAG_ERP_ZONES)
		typecache_precum |= SIZE_WHITELISTED_AREAS
	if(flags & NARRATIVE_AREA_FLAG_RUINS)
		typecache_precum |= /area/ruin
	if(flags & NARRATIVE_AREA_FLAG_SPACE)
		typecache_precum |= /area/space
	if(flags & NARRATIVE_AREA_FLAG_MAINTS)
		typecache_precum |= /area/station/maintenance
	if(flags & NARRATIVE_AREA_FLAG_ATMOS)
		typecache_precum |= /area/station/engineering/atmos
	SSnarrative.banned_area_cache["[flags]"] = typecacheof(typecache_precum)

/*
	* currently just a vote to determine the heat level the players want
	* each vote has a value: low, normal, intense
	* results arent gonna be revealed, but
*/
/datum/narrative_episode_vote
	/// The result of the vote, null if undecided
	var/vote_result = null
	/// The list of individual votes cast
	var/list/votes = list()
	/// is the vote going?
	var/vote_active = FALSE

/datum/narrative_episode_vote/proc/start_vote()
	vote_active = TRUE
	vote_result = null
	votes = list()

/datum/narrative_episode_vote/proc/cast_vote(who, choose)
	if(!vote_active)
		return
	who = extract_ckey(who)
	votes[who] = choose

/datum/narrative_episode_vote/proc/override_result(new_result)
	vote_result = new_result
	vote_active = FALSE // good game, i win

/datum/narrative_episode_vote/proc/tally_and_finish()
	if(LAZYLEN(votes) <= 0) // nobody voted? fuck you, im picking
		vote_result = 2
		goto just_end_it
	// average out the votes to determine the most popular choice
	var/votevalue_sum = 0
	for(var/ckey in votes)
		votevalue_sum += votes[ckey]
	vote_result = votevalue_sum / LAZYLEN(votes)
	just_end_it:
	vote_active = FALSE
	message_admins("Narrative vote concluded with result: [vote_result]")






/datum/narrative_vote_option
	var/option_name = ""
	var/option_description = ""
	var/option_value = 0
	var/action_scalar = 1
	var/action_scalar_inverse = 1
	var/action_scalar_min = 1
	var/action_scalar_max = 1

/datum/narrative_vote_option/ New()
	action_scalar = rand(action_scalar_min*1000, action_scalar_max*1000) / 1000 // cus rand does ints, and i want decimales
	action_scalar_inverse = 1 / action_scalar

/datum/narrative_vote_option/high_intensity
	option_name = "Ayla, the Full Throttle Fennec"
	option_description = \
		"Vote for Ayla the Full Throttle Fennec as our storyteller. This energetic critter has some serious zoomies that will \
		make for an intense, if chaotic, storytelling experience! It's all action for this sandy little thing... until she \
		inevitably crashes about halfway through the shift and falls asleep."
	option_value = 3
	action_scalar_min = 1.5
	action_scalar_max = 1.75

/datum/narrative_vote_option/medium_intensity
	option_name = "Anna, the Active Vulpine"
	option_description = \
		"Vote for Anna the Active Vulpine as our storyteller. The middle sister of the three, she brings a steady paw to the \
		happenings of the station, here to tell a story that isn't quite as intense as Ayla's, yet with more things happening \
		than Mia's low-key approach."
	option_value = 2
	action_scalar_min = 0.75
	action_scalar_max = 1.15

/datum/narrative_vote_option/low_intensity
	option_name = "Mia, the Eepy Vixen"
	option_description = \
		"Vote for Mia the Eepy Vixen as our storyteller. Mia's a little low-energy, she'd like a bit less intensity if that's \
		alright with you. While her storytelling tends to be fairly chill, the she still likes to toss in occasional \
		bursts of stuff happening to keep things interesting at the very least!"
	option_value = 1
	// no action scalar for low intensity, it only runs filler episodes that dont really scale










/datum/comfy_tracker
	var/user_ckey = ""
	var/last_meaningful_action = 0















