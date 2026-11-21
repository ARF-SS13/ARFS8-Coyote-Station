/datum/episode/filler
	desc = "Just a regular breather episode with nothing too catastrophic happening."
	noname = TRUE
	main_events = list()

	event_threads = list(
		/datum/episode_thread/randomized/filler_informations,
	)

	background_events = list(
		/datum/episode_event/aurora,
		/datum/episode_event/camera_failure,
		/datum/episode_event/bureaucratic_error,
		/datum/episode_event/communications_blackout,
		/datum/episode_event/dolphin_migration,
		/datum/episode_event/electrical_storm,
		/datum/episode_event/sentience,
		/datum/episode_event/vent_clog,
		/datum/episode_event/shuttle_catastrophe,
		/datum/episode_event/shuttle_insurance,
		/datum/episode_event/shuttle_loan,
		/datum/episode_event/stray_cargo,
		/datum/episode_event/stray_cargo_syndicate,
		/datum/episode_event/scrubber_overflow,
		/datum/episode_event/anomaly/bluespace,
		/datum/episode_event/anomaly/dimensional,
		/datum/episode_event/anomaly/ectoplasm,
		/datum/episode_event/anomaly/flux,
		/datum/episode_event/anomaly/grav,
		/datum/episode_event/anomaly/grav_high,
		/datum/episode_event/anomaly/hallucination,
		/datum/episode_event/anomaly/pyro,
		/datum/episode_event/anomaly/vortex,
		/datum/episode_event/anomaly/weather,
		/datum/episode_event/anomaly/weather/thundering,
		/datum/episode_event/bitrunning_glitch,
		/datum/episode_event/brain_trauma,
		/datum/episode_event/carp_migration,
		/datum/episode_event/cme_minimal,
		/datum/episode_event/gravity_generator_blackout,
		/datum/episode_event/grey_tide,
		/datum/episode_event/grid_check,
		/datum/episode_event/market_crash,
		/datum/episode_event/ion_storm,
		/datum/episode_event/mass_hallucination,
		/datum/episode_event/mice_migration,
		/datum/episode_event/wormholes,
		/datum/episode_event/rabbitrelease,
		/datum/episode_event/radiation_leak,
		/datum/episode_event/sentience,
		/datum/episode_event/sentience_all,
		/datum/episode_event/vent_clog_critical,
		/datum/episode_event/vent_clog_major,
		/datum/episode_event/vent_clog_strange,
		/datum/episode_event/scrubber_overflow_catastrophic,
		/datum/episode_event/scrubber_overflow_threatening,
	)

/datum/episode_thread/randomized/filler_informations
	phase_limited = TRUE
	phase_limits = alist(
		ROUND_PHASE_1 = 1,
		ROUND_PHASE_2 = 1,
		ROUND_PHASE_3 = 0,
		ROUND_PHASE_4 = 1,
		ROUND_PHASE_5 = 0,
		ROUND_PHASE_6 = 0,
	)

	events = list(
		/datum/episode_event/threadded/information/filler/phase_1/maintenance_report,
		/datum/episode_event/threadded/information/filler/phase_2/bored_ai_1,
		/datum/episode_event/threadded/information/filler/phase_2/bored_ai_2,
		/datum/episode_event/threadded/information/filler/phase_2/bored_ai_3,
		/datum/episode_event/threadded/information/filler/phase_2/bored_ai_4,
		/datum/episode_event/threadded/information/filler/phase_4/bored_ai_1,
		/datum/episode_event/threadded/information/filler/phase_4/bored_ai_2,
		/datum/episode_event/threadded/information/filler/phase_4/bored_ai_3,
	)

