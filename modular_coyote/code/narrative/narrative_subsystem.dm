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

	var/list/all_episodes = list()
	var/list/potential_episodes = list()
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
		switch(world.time)
			if(phase_1_start to phase_2_start)
				round_phase = 1 // startup peacetime, only minor issues
			if(phase_2_start to phase_3_start)
				round_phase = 2 // early game, minor issues start to appear
			if(phase_3_start to phase_4_start)
				round_phase = 3 // the main threats get ready
			if(phase_4_start to phase_5_start)
				round_phase = 4 // the main threat begins!
			if(phase_5_start to phase_6_start)
				round_phase = 5 // midlate game, main threat is active, time to fight
			if(phase_6_start to INFINITY)
				round_phase = 6 // continuation of 5, until the main threat is defeated, or the round ends at 3 hours
			else
				round_phase = 6 // continuation of 5, until the main threat is defeated, or the round ends at 3 hours
	round_phase = clamp(round_phase, phase_min, phase_max)
	return round_phase








/datum/comfy_tracker
	var/user_ckey = ""
	var/last_meaningful_action = 0
















