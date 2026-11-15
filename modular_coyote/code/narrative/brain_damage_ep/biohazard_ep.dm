/datum/episode/brain_damage
	name = "Brain Damage"
	names = list(
		"Bio Brainular Breltdown",
		"Encephalomatic Awfulty",
		"Brainular Health Wackage",
		"Mind Brainulaturn",
		"Migrein Brainflare",
		"Choreanic Sprinofluid",
		"Ebrlectricleptic Squeszure",
		"Grand Mail Sizeures",
		"Broainal",
		"The Thing Hat Wasnt Their Actually",
		"Ow My Brein",
		"Grumnglgh Mattour",
		"Neuroctile Dysflunction,",
		"Mindular Misflaire",
	)
	desc = "A biopsionic influence has begun to affect the station, subtly altering the minds and bodies of the crew. \
		Will the crew recognize and counteract this insidious threat before it overwhelms them?"
	main_events = list()

	event_threads = list(
		/datum/episode_thread/brain_damage_hallucinations,
		/datum/episode_thread/brain_damage_illness,
		/datum/episode_thread/brain_damage_announcements,
	)

	background_events = list(
		/datum/episode_event/scrubber_overflow/brain_damage/earlyround,
		/datum/episode_event/scrubber_overflow/brain_damage/lategame,
		/datum/episode_event/brain_trauma/brain_damage/earlyround,
		/datum/episode_event/brain_trauma/brain_damage/lategame,
		/datum/episode_event/anomaly/hallucination,
		/datum/episode_event/anomaly/ectoplasm,
	)

///
/datum/episode_thread/brain_damage_hallucinations
	events = list(
		/datum/episode_event/brain_damage/hallucinations/phase_1,
		/datum/episode_event/brain_damage/hallucinations/phase_2,
		/datum/episode_event/brain_damage/hallucinations/phase_3,
		/datum/episode_event/brain_damage/hallucinations/phase_4,
		/datum/episode_event/brain_damage/hallucinations/phase_5,
	)

///
/datum/episode_thread/brain_damage_illness
	events = list(
		/datum/episode_event/brain_damage/illness/phase_1,
		/datum/episode_event/brain_damage/illness/phase_2,
		/datum/episode_event/brain_damage/illness/phase_3,
		/datum/episode_event/brain_damage/illness/phase_4,
		/datum/episode_event/brain_damage/illness/phase_5,
	)


///
/datum/episode_thread/brain_damage_announcements
	events = list(
		/datum/episode_event/brain_damage_announcements/phase_1,
		/datum/episode_event/brain_damage_announcements/phase_2,
		/datum/episode_event/brain_damage_announcements/phase_3,
		/datum/episode_event/brain_damage_announcements/phase_4,
		/datum/episode_event/brain_damage_announcements/phase_5,
	)
