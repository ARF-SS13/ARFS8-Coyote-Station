
/datum/episode_event/biohazard_vent_spew
	event = /datum/round_event_control/scrubber_overflow
	weight = 5
	unlock_phase = 2
	end_phase = 6

/datum/episode_event/scrubber_overflow_catastrophic/biohazard
	event = /datum/round_event_control/scrubber_overflow/catastrophic

/datum/episode_event/scrubber_overflow_every_vent/biohazard
	event = /datum/round_event_control/scrubber_overflow/every_vent

/datum/episode_event/scrubber_overflow_threatening/biohazard
	event = /datum/round_event_control/scrubber_overflow/threatening




/datum/round_event_control/scrubber_overflow/biohazard
	name = "Scrubber Overflow: Biohazard Episode Base"
	typepath = /datum/round_event/scrubber_overflow/biohazard

/datum/round_event_control/scrubber_overflow/biohazard/phase_1
	name = "Scrubber Overflow: Biohazard Episode Phase 1"
	typepath = /datum/round_event/scrubber_overflow/biohazard/phase_1

/datum/round_event_control/scrubber_overflow/biohazard/phase_2
	name = "Scrubber Overflow: Biohazard Episode Phase 2"
	typepath = /datum/round_event/scrubber_overflow/biohazard/phase_2

/datum/round_event_control/scrubber_overflow/biohazard/phase_3
	name = "Scrubber Overflow: Biohazard Episode Phase 3"
	typepath = /datum/round_event/scrubber_overflow/biohazard/phase_3

/datum/round_event_control/scrubber_overflow/biohazard/phase_4
	name = "Scrubber Overflow: Biohazard Episode Phase 4"
	typepath = /datum/round_event/scrubber_overflow/biohazard/phase_4

/datum/round_event_control/scrubber_overflow/biohazard/phase_5
	name = "Scrubber Overflow: Biohazard Episode Phase 5"
	typepath = /datum/round_event/scrubber_overflow/biohazard/phase_5

/datum/round_event_control/scrubber_overflow/biohazard/phase_6
	name = "Scrubber Overflow: Biohazard Episode Phase 6"
	typepath = /datum/round_event/scrubber_overflow/biohazard/phase_6

/// the events
/datum/round_event/scrubber_overflow/biohazard
	name = "Scrubber Overflow Event: Biohazard Episode Base"





/datum/round_event/scrubber_overflow/biohazard/threatening
	danger_chance = 10
	reagents_amount = 100

/datum/round_event/scrubber_overflow/biohazard/catastrophic
	danger_chance = 30
	reagents_amount = 150


/datum/round_event/scrubber_overflow/biohazard/every_vent
	overflow_probability = 100
	reagents_amount = 100
