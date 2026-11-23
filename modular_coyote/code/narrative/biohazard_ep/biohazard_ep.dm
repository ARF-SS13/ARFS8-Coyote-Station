/datum/episode/biohazard
	name = "Biohazard"
	names = list(
		"Biohazard Blitz",
		"Biohazard",
		"Biohazardous Situation",
		"Contagion Calamity",
		"Contagion Chaos",
		"Contagion Crisis",
		"Contaminated Horizons",
		"Microbial Mayhem",
		"Microbial Meltdown",
		"Microbial Menace",
		"Pathogen Panic",
		"Pathogen Peril",
		"Pathogen Predicament",
		"Plague Panic",
		"Plague Predicament",
		"Plague Protocol",
		"Quarantine Catastrophe",
		"Quarantine Quandary",
		"Viral Outbreak",
		"Viral Vendetta",
		"Viral Vortex",
	)
	desc = "A deadly biohazard has infiltrated the station, spreading rapidly and threatening the crew's survival. \
		Will the crew contain the outbreak and survive the microbial menace?"
	main_events = list()

	event_threads = list(
		/datum/episode_thread/biohazard_vent_spew,
		/datum/episode_thread/biohazard_diseases,
		/datum/episode_thread/biohazard_announcements,
	)

	background_events = list(
		/datum/episode_event/threadded/scrubber_overflow/biohazard_ep,
		/datum/episode_event/threadded/scrubber_overflow_threatening/biohazard_ep,
		/datum/episode_event/threadded/scrubber_overflow_catastrophic/biohazard_ep,
		/datum/episode_event/threadded/scrubber_overflow_every_vent/biohazard_ep,
	)

/datum/episode/New()
	. = ..()
	if(!GLOB.meteor_direction)
		GLOB.meteor_direction = pick(GLOB.cardinals)

///
/datum/episode_thread/biohazard_vent_spew
	events = list(
		/datum/episode_event/threadded/biohazard_vent_spew/phase_1,
		/datum/episode_event/threadded/biohazard_vent_spew/phase_2,
		/datum/episode_event/threadded/biohazard_vent_spew/phase_3,
		/datum/episode_event/threadded/biohazard_vent_spew/phase_4,
		/datum/episode_event/threadded/biohazard_vent_spew/phase_5,
		/datum/episode_event/threadded/biohazard_vent_spew/phase_6,
	)

/datum/episode_thread/biohazard_diseases
	events = list(
		/datum/episode_event/threadded/biohazard_diseases/phase_1,
		/datum/episode_event/threadded/biohazard_diseases/phase_2,
		/datum/episode_event/threadded/biohazard_diseases/phase_3,
		/datum/episode_event/threadded/biohazard_diseases/phase_4,
		/datum/episode_event/threadded/biohazard_diseases/phase_5,
		/datum/episode_event/threadded/biohazard_diseases/phase_6,
	)


///
/datum/episode_thread/biohazard_announcements
	events = list(
		/datum/episode_event/threadded/biohazard_announcements/phase_1,
		/datum/episode_event/threadded/biohazard_announcements/phase_2,
		/datum/episode_event/threadded/biohazard_announcements/phase_3,
		/datum/episode_event/threadded/biohazard_announcements/phase_4,
		/datum/episode_event/threadded/biohazard_announcements/phase_5,
	)
