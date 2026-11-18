/datum/episode/station_infestation
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
		"Infestation Devastation",
		"Critterpocalypse",
		"It Came From the Vents",
		"Critter Bad",
		"Battlefield Maints",
		"Cryssalid Cruiseliner",
		"Ten Thousand Thousand Slimy Things",
		"Spiders Are The Worst Mob In The Game I Fucking Swear If I See Another One I Am Going To Shit My Pants",
	)
	desc = "The station suffers an ecological catastrophe, with waves of critters crawling out of the vents \
		and infesting every corner of the station! Can the crew survive the worst infestation in station history?"
	main_events = list(
		/datum/episode_event/spider_infestation/station_infestation,
	)
	event_threads = list(
		/datum/episode_thread/station_infestation,
		/datum/episode_thread/station_infestation_announcements,
	)

	background_events = list(
		/datum/episode_event/mice_migration/station_infestation,
		/datum/episode_event/vent_clog/station_infestation,
		/datum/episode_event/vent_clog_critical/station_infestation,
		/datum/episode_event/vent_clog_major/station_infestation,
		/datum/episode_event/vent_clog_strange/station_infestation,
		/datum/episode_event/mice_migration/station_infestation,
	)

/datum/episode_thread/station_infestation
	events = list(
		/datum/episode_event/threadded/ratwiggle_modifier/critter_round/phase_1,
		/datum/episode_event/threadded/ratwiggle_modifier/critter_round/phase_2,
		/datum/episode_event/threadded/ratwiggle_modifier/critter_round/phase_3,
		/datum/episode_event/threadded/ratwiggle_modifier/critter_round/phase_4,
		/datum/episode_event/threadded/ratwiggle_modifier/critter_round/phase_5,
		/datum/episode_event/threadded/ratwiggle_modifier/critter_round/phase_6,
	)

/datum/episode_thread/station_infestation_announcements
	events = list(
		/datum/episode_event/threadded/information/station_infestation_information/phase_1,
		/datum/episode_event/threadded/information/station_infestation_information/phase_2,
		/datum/episode_event/threadded/information/station_infestation_information/phase_3,
		/datum/episode_event/threadded/information/station_infestation_information/phase_4,
		/datum/episode_event/threadded/information/station_infestation_information/phase_4_part_2,
		/datum/episode_event/threadded/information/station_infestation_information/phase_5,
	)
