/datum/episode_event/vent_clog/station_infestation
	event = /datum/round_event_control/vent_clog
	alert_once = TRUE
	max_runs = 100
	min_cooldown = 10 MINUTES
	weight = 40
	unlock_phase = 2
	end_phase = 6

// invariably dangerous!
/datum/episode_event/vent_clog_critical/station_infestation
	event = /datum/round_event_control/vent_clog/critical
	max_runs = 3
	min_cooldown = 20 MINUTES
	weight = 40
	unlock_phase = 4
	end_phase = 5

// mostly just annoying
/datum/episode_event/vent_clog_major/station_infestation
	event = /datum/round_event_control/vent_clog/major
	max_runs = 3
	min_cooldown = 25 MINUTES
	weight = 40
	unlock_phase = 3
	end_phase = 4

// dangerous, though theres gondolas and viscerators
/datum/episode_event/vent_clog_strange/station_infestation
	event = /datum/round_event_control/vent_clog/strange
	alert_once = TRUE
	max_runs = 4
	min_cooldown = 25 MINUTES
	weight = 40
	unlock_phase = 4
	end_phase = 5

/datum/episode_event/mice_migration/station_infestation
	event = /datum/round_event_control/mice_migration
	quiet = TRUE
	max_runs = 5
	min_cooldown = 10 MINUTES
	weight = 150
	unlock_phase = 2
	end_phase = 6

/datum/episode_event/rabbitrelease/station_infestation
	event = /datum/round_event_control/rabbitrelease
	quiet = TRUE
	max_runs = 5
	min_cooldown = 10 MINUTES
	weight = 150
	unlock_phase = 1
	end_phase = 6

/datum/episode_event/sentience_all/station_infestation
	event = /datum/round_event_control/sentience/all
	max_runs = 1
	weight = 100
	unlock_phase = 3
	end_phase = 6

/datum/episode_event/sentience/station_infestation
	event = /datum/round_event_control/sentience
	alert_once = TRUE
	min_cooldown = 10 MINUTES
	max_runs = 10
	weight = 10
	unlock_phase = 1
	end_phase = 6

/datum/episode_event/scrubber_overflow_catastrophic/station_infestation
	event = /datum/round_event_control/scrubber_overflow/catastrophic
	max_runs = 3
	weight = 10
	unlock_phase = 4
	end_phase = 5

/datum/episode_event/scrubber_overflow_every_vent/station_infestation
	event = /datum/round_event_control/scrubber_overflow/every_vent
	max_runs = 1
	weight = 10
	unlock_phase = 5
	end_phase = 5

/datum/episode_event/scrubber_overflow_threatening/station_infestation
	event = /datum/round_event_control/scrubber_overflow/threatening
	max_runs = 3
	weight = 10
	unlock_phase = 3
	end_phase = 6

/// the grand main event
/datum/episode_event/spider_infestation/station_infestation
	event = /datum/round_event_control/spider_infestation
	max_runs = 1
	weight = 10
	unlock_phase = 4
	end_phase = 6

/// ratwigglers!

/datum/episode_event/ratwiggle_modifier/critter_round
	min_cooldown = 1 MINUTES
	weight = 5
	unlock_phase = 1
	end_phase = 1
	rw_cooldown_percent_change = 0
	rw_cooldown_percent_target = 100
	rw_budget_percent_change = 0
	rw_budget_percent_target = 100

/datum/episode_event/ratwiggle_modifier/critter_round/phase_1
	unlock_phase = 1
	end_phase = 1

/datum/episode_event/ratwiggle_modifier/critter_round/phase_2
	unlock_phase = 2
	end_phase = 2
	rw_cooldown_percent_change = 10
	rw_cooldown_percent_target = 150

/datum/episode_event/ratwiggle_modifier/critter_round/phase_3
	unlock_phase = 3
	end_phase = 3
	rw_cooldown_percent_change = 20
	rw_cooldown_percent_target = 200
	rw_budget_percent_change = 20
	rw_budget_percent_target = 200
	rw_ignore_cooldowns = TRUE
	rw_ignore_max_spawnable = TRUE
	rw_hostile_weighting = 2

/datum/episode_event/ratwiggle_modifier/critter_round/phase_4
	unlock_phase = 4
	end_phase = 4
	rw_cooldown_percent_change = 100
	rw_cooldown_percent_target = 1000
	rw_budget_percent_change = 100
	rw_budget_percent_target = 1000
	rw_ignore_cooldowns = TRUE
	rw_ignore_cooldowns_hostiles = TRUE
	rw_super_hostile = TRUE
	rw_only_hostiles = TRUE
	rw_hostile_weighting = 100
	rw_ignore_max_spawnable = TRUE
	rw_ignore_max_spawnable_hostiles = TRUE

/datum/episode_event/ratwiggle_modifier/critter_round/phase_5
	unlock_phase = 5
	end_phase = 5
	rw_cooldown_percent_change = 100
	rw_cooldown_percent_target = 10 // denumount
	rw_budget_percent_change = 100
	rw_budget_percent_target = 10
	rw_hostile_weighting = 0.01
	rw_ignore_max_spawnable = FALSE
	rw_ignore_max_spawnable_hostiles = FALSE

/datum/episode_event/ratwiggle_modifier/critter_round/phase_6
	unlock_phase = 6
	end_phase = 6
	rw_cooldown_percent_change = 100
	rw_cooldown_percent_target = 10 // denumount
	rw_budget_percent_change = 100
	rw_budget_percent_target = 10
	rw_hostile_weighting = 0.01
	rw_ignore_max_spawnable = FALSE
	rw_ignore_max_spawnable_hostiles = FALSE
	rw_ignore_cooldowns = FALSE
	rw_ignore_cooldowns_hostiles = FALSE
	rw_super_hostile = FALSE
	rw_only_hostiles = FALSE


