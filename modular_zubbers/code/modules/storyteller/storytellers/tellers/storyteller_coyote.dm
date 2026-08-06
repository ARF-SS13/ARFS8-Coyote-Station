/datum/storyteller/coyote
	name = "Coyote Versus Space"
	desc = "This storyteller focuses more on the environmental side of danger than that of your fellow crew. \
	Events are heavily weighted towards PVE threats toward the station and crew, and you can (generally) rely on your fellow spacefolk to be (at least somewhat) benign!"
	welcome_text = "Welcome, Space Coyote!"

	event_repetition_multiplier = 0.8

	track_data = /datum/storyteller_data/tracks/coyote

	tag_multipliers = list(
		TAG_COMBAT = 0.3,
		TAG_DESTRUCTIVE = 0.4,
		TAG_CHAOTIC = 0.2,
		TAG_CREW_ANTAG = 0,
		TAG_TEAM_ANTAG = 0,
		TAG_OUTSIDER_ANTAG = 0,
	)
	storyteller_type = STORYTELLER_TYPE_ALWAYS_AVAILABLE
	antag_divisor = 99999

/datum/storyteller_data/tracks/coyote
	threshold_mundane = 800
	threshold_moderate = 1200
	threshold_major = 7000
	threshold_crewset = 2400000
	threshold_ghostset = 6000000
