/datum/episode/vent_critters
	name = "Station Infestation"
	names = list(
		"Station Infestation",
		"Eye of the Swarm",
		"Vermintide Worldwide",
		"Ratwiggle",
		"The Ecology Within",
		"Dial 'M' for Mothroach",
		"Skitter",
		"Pest Uncontrolled",
	)
	desc = "The station suffers an ecological catastrophe, with waves of critters crawling out of the vents \
		and infesting every corner of the station! Can the crew survive the worst infestation in station history?"
	main_events = list(
		/datum/episode_event/spider_infestation/station_infestation,
	)
	storyline_events = list(
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_1,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_2,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_3,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_4,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_5,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_6,
	)
	minor_events = list(
		/datum/episode_event/mice_migration/station_infestation,
		/datum/episode_event/rabbitrelease/station_infestation,
		/datum/episode_event/vent_clog/station_infestation,
		/datum/episode_event/vent_clog_critical/station_infestation,
		/datum/episode_event/vent_clog_major/station_infestation,
		/datum/episode_event/vent_clog_strange/station_infestation,
	)
	background_events = list(
		/datum/episode_event/sentience_all/station_infestation,
		/datum/episode_event/sentience/station_infestation,
		/datum/episode_event/mice_migration/station_infestation,
		/datum/episode_event/rabbitrelease/station_infestation,
	)
