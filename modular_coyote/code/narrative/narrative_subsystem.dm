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
	wait = 10 SECONDS
	dependencies = list(
		// we kinda need it lol
		/datum/controller/subsystem/gamemode,
	)

	var/list/all_episodes = list()
	var/list/potential_episodes = list()
	var/datum/episode/current_episode = null
	// so people who are fucking each other's brains out wont count towards the pop
	var/list/comfy_trackers = list()
	var/spider_chance = 0
	var/ratboy_chance = 0
	var/phase_1_start = 0
	var/phase_2_start = 30 MINUTES
	var/phase_3_start = 1 HOURS
	var/phase_4_start = 1.5 HOURS
	var/phase_5_start = 2 HOURS
	var/phase_6_start = 2.5 HOURS
	var/phase_min = 1
	var/phase_max = 6
	var/phase_override = null

/datum/controller/subsystem/narrative/Initialize()
	build_episode_list()
	// load_episode_history()
	. = ..()
	var/list/thingse = list(
		"Stay tuned!",
		"Don't touch that dial!",
		"Coming soon to a space station near you!",
	)
	spawn(10 SECONDS)
		to_chat(world, span_boldnotice("Initialized [LAZYLEN(all_episodes)] distinct potential episodes! [pick(thingse)]"))

/datum/controller/subsystem/narrative/fire(resumed)
	if(!current_episode)
		check_tv_guide()
		return
	current_episode.fire()

/datum/controller/subsystem/narrative/proc/build_episode_list()
	for(var/datum/episode/ep as anything in subtypesof(/datum/episode))
		all_episodes += new ep()

/// spends the first couple minutes of the round checking the player count and such for
/// which episodes may be a good idea to do. or just picks one at random cus i gotta get this damn thing done at some point
/datum/controller/subsystem/narrative/proc/check_tv_guide()
	if(LAZYLEN(all_episodes))
		current_episode = pick(all_episodes)
	else
		CRASH("No episodes available to pick from! Screw you!")


// make these check the current episode for the spider and ratboy chances instead of using static values
/datum/controller/subsystem/narrative/proc/GetSpiderChance()
	return spider_chance

/datum/controller/subsystem/narrative/proc/GetRatboyChance()
	return ratboy_chance

/datum/controller/subsystem/narrative/proc/get_round_phase(override)
	var/round_phase = 1
	if(!isnull(override))
		round_phase = override
	else if(!isnull(phase_override))
		round_phase = phase_override
	else
		var/roundtime_elapsed = world.time - SSticker.round_start_time
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








/datum/comfy_tracker
	var/user_ckey = ""
	var/last_meaningful_action = 0
















