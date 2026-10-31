/datum/episode_event/information/station_infestation_information

/datum/episode_event/information/station_infestation_information/phase_1
	unlock_phase = 1
	min_delay = 30 SECONDS
	max_delay = 90 SECONDS

	bridge_mail = TRUE
	bridge_mail_label = "ARFS Shift-Change Maintenance Report"
	bridge_mail_header = "ARFS Shift-Change Maintenance Report"
	bridge_mail_sender = "Nix Isia, Delta-Shift Maintenance Lead"
	bridge_mail_message = "\
		Delta-Shift's maintenance check has been completed successfully, as per ARFS protocols. She's all yours!<br>\
		We had some issues with the environmental control systems earlier in the shift, nothing major, just some extra \
		back pressure fluctuations, but everything has been stabilized now. It was likely the deep-station fauna getting \
		a little restless during the shift again, nothing to worry about for you guys though.<br><br>\
		Though, you may want to keep some bug spray and mouse traps handy, just in case the little critters decide to \
		be a bit bolder than usual.<br><br>\
		Other than that, everything is running within normal parameters. Power generation is at a cold stop, as per protocol. \
		Environmental controls are stable, and all systems are nominal.<br><br>\
		Have a nice shift! And do try to leave some of the station intact for me this time. :3<br>"

/datum/episode_event/information/station_infestation_information/phase_2
	unlock_phase = 2
	min_delay = 30 SECONDS
	max_delay = 10 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Diagnostics Update"
	station_announcement_sender = "GekkerTec Environmental Management System"
	station_announcement_message = "\
		Attention crew, this is Fuzzy Foxxo with your station diagnostics update!\n\n\
		Environmental sensors are reporting a marked increase in biological activity within the station's substructures, \
		particularly involving atmospheric control systems and maintenance areas. \
		Not entirely unexpected given the biodome's resident ecological systems. Likely just rat breeding \
		season, though we will continue to monitor the situation and provide updates as necessary.\n\n\
		In the mean time, please remain vigilant of any unusual critter activity throughout the station. Stay safe, \
		those critters can be quite nasty!\n\n\
		-- Fuzzy Foxxo, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "blue"

/datum/episode_event/information/station_infestation_information/phase_3
	unlock_phase = 3
	min_delay = 30 SECONDS
	max_delay = 10 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Diagnostics Update"
	station_announcement_sender = "GekkerTec Environmental Management System"
	station_announcement_message = "\
		Attention crew, this is Fuzzy Foxxo with your station diagnostics update!\n\n\
		Biological activity within the station has steadily increased since the last diagnostics report. Critter hostility has \
		also been escalating, with multiple reports of aggressive critter encounters throughout the station. This is not normal \
		behavior for the station's ecosystem, and immediate caution is advised for everyone on station at all times.\n\n\
		Sensors are also indicating some form of rapid biological proliferation, precise location and identification remain uncertain. \
		If it is anything like the current infestations, the crew may want to take immediate precautions and prepare for possible \
		self-defense measures.\n\n\
		Stay safe, crew!\n\n\
		-- Fuzzy Foxxo, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

// antag release!
/datum/episode_event/information/station_infestation_information/phase_4
	unlock_phase = 4
	min_delay = 30 SECONDS
	max_delay = 10 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Diagnostics Update"
	station_announcement_sender = "GekkerTec Environmental Management System"
	station_announcement_message = "\
		Attention crew, this is Fuzzy Foxxo with your station diagnostics update!\n\n\
		Hostile biological entities have been detected within the station, originating from multiple deep-substructure locations! \
		They seem to be using the station's ventilation machinery and maintenance corridors to move throughout the station!\n\n\
		Crew members are advised to arm themselves with whatever weapons or defensive tools are available to them, and seal off \
		any non-essential access points to prevent further spread of the hostile entities.\n\n\
		Medical is advised to prepare for potential casualties and ensure that all medical supplies are readily accessible.\n\n\
		Security, you know what to do!\n\n\
		Stay safe, crew!\n\n\
		-- Fuzzy Foxxo, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/station_infestation_information/phase_5
	unlock_phase = 5
	min_delay = 30 SECONDS
	max_delay = 10 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Diagnostics Update"
	station_announcement_sender = "GekkerTec Environmental Management System"
	station_announcement_message = "\
		Attention crew, this is Fuzzy Foxxo with your station diagnostics update!\n\n\
		The situation has escalated significantly, with more hostile biological entities emerging from the deep-substructure!\n\n\
		Visual reports indicate the entities to be 'spider-like' in nature, and deadly in close combat. Those fangs look venomous! \
		Additionally, there appear to be larger, faster-moving entities designated 'chryssalid' that pose a severe threat to \
		the crew if encountered. Close combat is likely to end poorly for you! Find a gun and hunker down with your fellow crew \
		members until the threat has been neutralized.\n\n\
		On the brighter side, the spiders and chryssalids appear to be territorial, and thus one will attack the other if encountered.\n\n\
		Stay safe, crew!\n\n\
		-- Fuzzy Foxxo, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/station_infestation_information/phase_6
	unlock_phase = 6
	min_delay = 30 SECONDS
	max_delay = 10 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Diagnostics Update"
	station_announcement_sender = "GekkerTec Environmental Management System"
	station_announcement_message = "\
		Attention crew, this is Fuzzy Foxxo with your station diagnostics update!\n\n\
		Reports indicate that the hostile entities are gradually being contained, and their threat level is decreasing.\n\n\
		I am still reading high levels of biological activity in the station's substructure, however the overall aggression \
		seems to be diminishing. Reason is unclear, my best guess is that whatever external influence that initially triggered \
		the invasion had passed. Very peculiar!\n\n\
		At any rate, if possible, finish off any remaining hostile entities, and give yourselves a pat on the back for your efforts!\n\n\
		Stay safe, crew!\n\n\
		-- Fuzzy Foxxo, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "green"



