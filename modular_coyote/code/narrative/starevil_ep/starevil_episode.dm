/datum/episode/starevil
	name = "Starevil"
	names = list(
		"Starevil",
		"Celestia's Wrath",
		"Princess Celestia's Drunk Again",
		"Equestria's Solstice",
		"Stellar Badstuff",
		"Solar Fury",
		"Celestial Cataclysm",
		"Equinox of Doom",
		"Twilight's Wrath",
		"Starlight's Furry",
		"Daymare Sun's IT Service",
		"Solarian Flareon",
		"Princess Corona's Mass Ejection",
		"Princess Ion Storm's Deus Ex Solaria",
		"Princess Celestia Breaks Your Radios",
		"Bad Sun Episode, Starring You",
		"Princess Celestia's Fat Ass Smothers The Station",
	)
	desc = "The sun enters a phase of catastrophic brilliance, unleashing its wrath upon the station and all who dwell within. \
		Electronics and other systems are at risk of being fried by the intense solar activity, will the crew's phones and such survive?"
	main_events = list()

	event_threads = list(
		/datum/episode_thread/starevil_radio_interference,
		/datum/episode_thread/starevil_cme_stuff,
		/datum/episode_thread/starevil_lightfucker_pro,
		/datum/episode_thread/starevil_space_painful,
		/datum/episode_thread/starevil_announcements,
	)

	background_events = list(
		/datum/episode_event/aurora,
		/datum/episode_event/radiation_leak,
	)

/datum/episode/New()
	. = ..()
	if(!GLOB.meteor_direction)
		GLOB.meteor_direction = pick(GLOB.cardinals)

///
/datum/episode_thread/starevil_radio_interference
	events = list(
		/datum/episode_event/threadded/radio_interference/starevil/phase_1,
		/datum/episode_event/threadded/radio_interference/starevil/phase_2,
		/datum/episode_event/threadded/radio_interference/starevil/phase_3,
		/datum/episode_event/threadded/radio_interference/starevil/phase_4,
		/datum/episode_event/threadded/radio_interference/starevil/phase_5,
	)

///
/datum/episode_thread/starevil_cme_stuff
	events = list(
		/datum/episode_event/threadded/coronal_mass_ejection/starevil/phase3,
		/datum/episode_event/threadded/coronal_mass_ejection/starevil/phase4,
		/datum/episode_event/threadded/coronal_mass_ejection/starevil/phase5,
	)

/datum/episode_thread/starevil_lightfucker_pro
	events = list(
		/datum/episode_event/threadded/lightfucker_pro/starevil/phase_1,
		/datum/episode_event/threadded/lightfucker_pro/starevil/phase_2,
		/datum/episode_event/threadded/lightfucker_pro/starevil/phase_3,
		/datum/episode_event/threadded/lightfucker_pro/starevil/phase_4,
		/datum/episode_event/threadded/lightfucker_pro/starevil/phase_5,
	)

/datum/episode_thread/starevil_space_painful
	events = list(
		/datum/episode_event/threadded/make_space_painful/starevil/phase_3,
		/datum/episode_event/threadded/make_space_painful/starevil/phase_4,
	)
/datum/episode_thread/starevil_announcements
	events = list(
		/datum/episode_event/threadded/information/starevil_information/phase_1,
		/datum/episode_event/threadded/information/starevil_information/phase_2,
		/datum/episode_event/threadded/information/starevil_information/phase_3,
		/datum/episode_event/threadded/information/starevil_information/phase_4,
		/datum/episode_event/threadded/information/starevil_information/phase_5,
	)
