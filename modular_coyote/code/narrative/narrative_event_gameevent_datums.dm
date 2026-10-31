/// abstract!!








/datum/episode_event/aurora
	event = /datum/round_event_control/aurora_caelus

/datum/episode_event/camera_failure
	event = /datum/round_event_control/camera_failure

/datum/episode_event/bureaucratic_error
	event = /datum/round_event_control/bureaucratic_error



/datum/episode_event/communications_blackout
	event = /datum/round_event_control/communications_blackout
	weight = 20
	unlock_phase = 3
	end_phase = 6

/datum/episode_event/dolphin_migration
	event = /datum/round_event_control/dolphin_migration
	min_cooldown = 45 MINUTES
	weight = 45
	unlock_phase = 1
	end_phase = 6

/datum/episode_event/electrical_storm
	event = /datum/round_event_control/electrical_storm
	weight = 5
	unlock_phase = 1
	end_phase = 6

/datum/episode_event/sentience
	event = /datum/round_event_control/sentience
	min_cooldown = 30 MINUTES
	weight = 40
	unlock_phase = 1
	end_phase = 6

/datum/episode_event/vent_clog
	event = /datum/round_event_control/vent_clog
	min_cooldown = 30 MINUTES
	weight = 40
	unlock_phase = 2
	end_phase = 6

/datum/episode_event/shuttle_catastrophe
	event = /datum/round_event_control/shuttle_catastrophe
	unlock_phase = 4
	weight = 5

/datum/episode_event/shuttle_insurance
	event = /datum/round_event_control/shuttle_insurance

/datum/episode_event/shuttle_loan
	event = /datum/round_event_control/shuttle_loan

/datum/episode_event/stray_cargo
	event = /datum/round_event_control/stray_cargo

/datum/episode_event/stray_cargo_syndicate
	event = /datum/round_event_control/stray_cargo/syndicate


/datum/episode_event/scrubber_overflow
	event = /datum/round_event_control/scrubber_overflow
	weight = 5
	unlock_phase = 2
	end_phase = 6


// Higher threat, more midroundy events
/datum/episode_event/anomaly
	unlock_phase = 2

/datum/episode_event/anomaly/bluespace
	event = /datum/round_event_control/anomaly/anomaly_bluespace

/datum/episode_event/anomaly/dimensional
	event = /datum/round_event_control/anomaly/anomaly_dimensional

/datum/episode_event/anomaly/ectoplasm
	event = /datum/round_event_control/anomaly/anomaly_ectoplasm

/datum/episode_event/anomaly/flux
	event = /datum/round_event_control/anomaly/anomaly_flux
	unlock_phase = 3

/datum/episode_event/anomaly/grav
	event = /datum/round_event_control/anomaly/anomaly_grav

/datum/episode_event/anomaly/grav_high
	event = /datum/round_event_control/anomaly/anomaly_grav/high
	unlock_phase = 3

/datum/episode_event/anomaly/hallucination
	event = /datum/round_event_control/anomaly/anomaly_hallucination
	unlock_phase = 1

/datum/episode_event/anomaly/pyro
	event = /datum/round_event_control/anomaly/anomaly_pyro

/datum/episode_event/anomaly/vortex
	event = /datum/round_event_control/anomaly/anomaly_vortex

/datum/episode_event/anomaly/weather
	event = /datum/round_event_control/anomaly/anomaly_weather

/datum/episode_event/anomaly/weather/thundering
	event = /datum/round_event_control/anomaly/anomaly_weather/thundering

/datum/episode_event/bitrunning_glitch
	event = /datum/round_event_control/bitrunning_glitch

/datum/episode_event/brain_trauma
	event = /datum/round_event_control/brain_trauma

/datum/episode_event/carp_migration
	event = /datum/round_event_control/carp_migration

/datum/episode_event/cme_minimal
	event = /datum/round_event_control/cme/minimal

/datum/episode_event/cme_moderate
	event = /datum/round_event_control/cme/moderate

/datum/episode_event/cme_unknown
	event = /datum/round_event_control/cme/unknown

/datum/episode_event/cme_armageddon
	event = /datum/round_event_control/cme/armageddon

/datum/episode_event/cme_extreme
	event = /datum/round_event_control/cme/extreme

/datum/episode_event/cme
	event = /datum/round_event_control/cme

/datum/episode_event/gravity_generator_blackout
	event = /datum/round_event_control/gravity_generator_blackout

/datum/episode_event/grey_tide
	event = /datum/round_event_control/grey_tide
	unlock_phase = 3

/datum/episode_event/grid_check
	event = /datum/round_event_control/grid_check
	unlock_phase = 2

/datum/episode_event/market_crash
	event = /datum/round_event_control/market_crash

/datum/episode_event/ion_storm
	event = /datum/round_event_control/ion_storm

/datum/episode_event/meteor_wave
	event = /datum/round_event_control/meteor_wave

/datum/episode_event/meteor_wave_meaty
	event = /datum/round_event_control/meteor_wave/meaty

/datum/episode_event/meteor_wave_candy
	event = /datum/round_event_control/meteor_wave/candy

/datum/episode_event/meteor_wave_catastrophic
	event = /datum/round_event_control/meteor_wave/catastrophic

/datum/episode_event/meteor_wave_dust_storm
	event = /datum/round_event_control/meteor_wave/dust_storm

/datum/episode_event/meteor_wave_threatening
	event = /datum/round_event_control/meteor_wave/threatening

/datum/episode_event/mass_hallucination
	event = /datum/round_event_control/mass_hallucination

/datum/episode_event/processor_overload
	event = /datum/round_event_control/processor_overload
	unlock_phase = 3

/datum/episode_event/mice_migration
	event = /datum/round_event_control/mice_migration

/datum/episode_event/wormholes
	event = /datum/round_event_control/wormholes
	unlock_phase = 3

/datum/episode_event/rabbitrelease
	quiet = TRUE
	event = /datum/round_event_control/rabbitrelease
	weight = 20

/datum/episode_event/radiation_leak
	event = /datum/round_event_control/radiation_leak

/datum/episode_event/sandstorm
	event = /datum/round_event_control/sandstorm

/datum/episode_event/sandstorm_classic
	event = /datum/round_event_control/sandstorm_classic

/datum/episode_event/sentience
	event = /datum/round_event_control/sentience

/datum/episode_event/sentience_all
	event = /datum/round_event_control/sentience/all

/datum/episode_event/space_dust
	event = /datum/round_event_control/space_dust

/datum/episode_event/stray_meteor
	event = /datum/round_event_control/stray_meteor

/datum/episode_event/vent_clog_critical
	event = /datum/round_event_control/vent_clog/critical

/datum/episode_event/vent_clog_major
	event = /datum/round_event_control/vent_clog/major

/datum/episode_event/vent_clog_strange
	event = /datum/round_event_control/vent_clog/strange

/datum/episode_event/scrubber_overflow_catastrophic
	event = /datum/round_event_control/scrubber_overflow/catastrophic

/datum/episode_event/scrubber_overflow_every_vent
	event = /datum/round_event_control/scrubber_overflow/every_vent

/datum/episode_event/scrubber_overflow_threatening
	event = /datum/round_event_control/scrubber_overflow/threatening

/datum/episode_event/portal_storm_narsie
	event = /datum/round_event_control/portal_storm_narsie

/datum/episode_event/portal_storm_syndicate
	event = /datum/round_event_control/portal_storm_syndicate


// Main Event events
/// abstract!
/datum/episode_event/main
	// both of these are generally ignored by the main runner thing, mainly here if u wanna random event em
	max_runs = 1
	unlock_phase = 4

/datum/episode_event/main/abductor
	event = /datum/round_event_control/abductor

/datum/episode_event/main/alien_infestation
	event = /datum/round_event_control/alien_infestation

/datum/episode_event/main/nuke_ops
	event = /datum/round_event_control/antagonist/team/nuke_ops

/datum/episode_event/main/blob
	event = /datum/round_event_control/blob

/datum/episode_event/main/brand_intelligence
	event = /datum/round_event_control/brand_intelligence

/datum/episode_event/main/carp_migration/pipe_carp
	event = /datum/round_event_control/carp_migration/pipe_carp

/datum/episode_event/main/changeling
	event = /datum/round_event_control/changeling

/datum/episode_event/main/fleshmind
	event = /datum/round_event_control/fleshmind

/// Its a rod, but like 10 tiles wide
/datum/episode_event/main/icarus_sunbeam // will basically destroy the station repeatedly
	event = /datum/round_event_control/icarus_sunbeam

/datum/episode_event/main/immovable_rod
	event = /datum/round_event_control/immovable_rod

/datum/episode_event/main/space_ninja
	event = /datum/round_event_control/space_ninja

/datum/episode_event/main/spacevine
	event = /datum/round_event_control/spacevine

/datum/episode_event/main/slaughter
	event = /datum/round_event_control/slaughter

/datum/episode_event/main/space_dragon
	event = /datum/round_event_control/space_dragon

/datum/episode_event/main/spider_infestation
	event = /datum/round_event_control/spider_infestation

/datum/episode_event/main/revenant
	event = /datum/round_event_control/revenant

/datum/episode_event/main/mold
	event = /datum/round_event_control/mold

/datum/episode_event/main/morph
	event = /datum/round_event_control/morph

/datum/episode_event/main/nightmare
	event = /datum/round_event_control/nightmare




















