/datum/episode/sand_storm
	name = "Sand Storm"
	names = list(
		"Sand Storm",
		"The Dunes of Space",
		"Deserted Horizons",
		"Hail to the Sand",
		"Dirtiest Devil",
		"Rock Bad",
		"Sand in the Gears",
		"Blown Away",
	)
	desc = "A massive sand storm engulfs the station, bringing with it blinding dust and relentless winds. \
		The crew must navigate the treacherous conditions and survive the harsh desert-like environment!"
	main_events = list(
		/datum/episode_event/meteors,
	)
	event_threads = list(
		/datum/episode_thread/sand_storm,
		/datum/episode_thread/sand_storm_announcements,
	)

	background_events = list(
		/datum/episode_event/mice_migration/sand_storm,
		/datum/episode_event/vent_clog/sand_storm,
		/datum/episode_event/vent_clog_critical/sand_storm,
		/datum/episode_event/vent_clog_major/sand_storm,
		/datum/episode_event/vent_clog_strange/sand_storm,
		/datum/episode_event/mice_migration/sand_storm,
	)

///
/datum/episode_thread/sand_storm
	events = list(
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_1,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_2,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_3,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_4,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_5,
		/datum/episode_event/ratwiggle_modifier/critter_round/phase_6,
	)

///
/datum/episode_thread/sand_storm_announcements
	events = list(
		/datum/episode_event/information/sand_storm_information/phase_1,
		/datum/episode_event/information/sand_storm_information/phase_2,
		/datum/episode_event/information/sand_storm_information/phase_3,
		/datum/episode_event/information/sand_storm_information/phase_4,
	)
