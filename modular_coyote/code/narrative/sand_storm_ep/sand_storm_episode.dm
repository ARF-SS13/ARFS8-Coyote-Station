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
		"Sand and Deliver",
		"Grains of Wrath",
		"Sand Trap",
		"Blown to Bits",
		"Sandwich of Doom",
		"Grain Expectations",
		"Sand and Punishment",
		"Grainstorm",
		"Sandwich of Misfortune",
		"Grain of Truth",
		"Sandwich of Fate",
		"Meteor Mayhem",
		"Rock and Sand",
		"X Marks the Sand",
	)
	desc = "A massive sand storm engulfs the station, bringing with it a hailstorm of sand and debris that threatens \
		to erode the station down to an airless nub! Will the crew survive the rocky onslaught?"
	main_events = list()

	event_threads = list(
		/datum/episode_thread/dust_storm,
		/datum/episode_thread/sand_storm,
		/datum/episode_thread/meteor_storm,
		/datum/episode_thread/sand_storm_announcements,
	)

	background_events = list(
		/datum/episode_event/meteors/dust/resource,
		/datum/episode_event/meteors/sand/resource,
	)

/datum/episode/New()
	. = ..()
	if(!GLOB.meteor_direction)
		GLOB.meteor_direction = pick(GLOB.cardinals)

///
/datum/episode_thread/dust_storm
	events = list(
		/datum/episode_event/meteors/phase_1/dust,
		/datum/episode_event/meteors/phase_2/dust,
		/datum/episode_event/meteors/phase_3/dust,
		/datum/episode_event/meteors/phase_4/dust,
		/datum/episode_event/meteors/phase_5/dust,
		/datum/episode_event/meteors/phase_6/dust,
	)

/datum/episode_thread/sand_storm
	events = list(
		/datum/episode_event/meteors/phase_1/sand,
		/datum/episode_event/meteors/phase_2/sand,
		/datum/episode_event/meteors/phase_3/sand,
		/datum/episode_event/meteors/phase_4/sand,
		/datum/episode_event/meteors/phase_5/sand,
		/datum/episode_event/meteors/phase_6/sand,
	)

/datum/episode_thread/meteor_storm
	events = list(
		/datum/episode_event/meteors/phase_4/meteor,
	)

/datum/episode_thread/meteor_storm_easy
	events = list(
		/datum/episode_event/meteors/phase_4/meteor/easy,
	)

///
/datum/episode_thread/sand_storm_announcements
	events = list(
		/datum/episode_event/information/sand_storm_information/phase_1,
		/datum/episode_event/information/sand_storm_information/phase_1_part_2,
		/datum/episode_event/information/sand_storm_information/phase_2,
		/datum/episode_event/information/sand_storm_information/phase_3,
		/datum/episode_event/information/sand_storm_information/phase_4,
		/datum/episode_event/information/sand_storm_information/phase_5,
	)
