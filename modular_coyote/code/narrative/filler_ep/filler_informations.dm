/datum/episode_event/threadded/information/filler

/datum/episode_event/threadded/information/filler/phase_1
	unlock_phase = 1

/datum/episode_event/threadded/information/filler/phase_1/maintenance_report
	bridge_mail = TRUE
	bridge_mail_label = "ARFS Shift-Change Maintenance Report"
	bridge_mail_header = "ARFS Shift-Change Maintenance Report"
	bridge_mail_sender = "Nix Isia, Delta-Shift Maintenance Lead"
	bridge_mail_message = "\
		Delta-Shift's maintenance check has been completed successfully, as per ARFS protocols. She's all yours!<br><br>\
		Our station systems are operating within normal parameters, and no immediate threats have been detected. \
		Arlo's been a little on edge, she's used to a bit more... spice in her daily routine. She might seem stressed when \
		stuff's going on, but honestly, I think she loves it. She'll live =3<br><br>\
		Violet-HY's pretty chill about all this, as usual.<br><br>\
		Stay safe out there!"

/datum/episode_event/threadded/information/filler/phase_2
	unlock_phase = 2
	min_delay = 5 MINUTES
	max_delay = 25 MINUTES

/datum/episode_event/threadded/information/filler/phase_2/bored_ai_1
	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Orbital trajectory remains stable with minor deviations within acceptable parameters. We will be passing Elizabeth's \
		sphere of influence shortly, stationkeeping magnetothrust adjustments will be minimal and within safe operational limits.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2_long.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/filler/phase_2/bored_ai_2
	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Ambient starlight levels appear elevated, indicating minor stellar activity. While not immediately hazardous, \
		crew should consider sunscreen if spending extended periods in exposed areas.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2_long.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/filler/phase_2/bored_ai_3
	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Ambient bluespace eddies are within expected ranges, which is honestly quite reassuring for our ongoing operations.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2_long.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/filler/phase_2/bored_ai_4
	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		I have just been informed by my sister sub-persona that the view outside is quite lovely, and that the crew might \
		want to take a moment to appreciate it. Go ahead and enjoy the view, I will continue monitoring the &NUMBER& \
		potential astro-environmental threats to our station. We are due for &FAKEEVENT& in around &TIMEPERIOD&.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2_long.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/filler/phase_2/bored_ai_4/get_announcement_message()
	. = ..()
	station_announcement_message = replacetext(station_announcement_message, "&NUMBER&", "[rand(1, 399)]")
	var/static/list/events = list(
		"a stellar mass ejection",
		"a bluespace anomaly",
		"a meteor shower",
		"a comet strike",
		"a solar flare",
		"a direct collision with orbital debris",
		"a gamma-ray burst",
		"an interstellar shockwave",
		"a stellar electromagnetic pulse",
		)
	station_announcement_message = replacetext(station_announcement_message, "&FAKEEVENT&", "[pick(events)]")
	var/static/list/time_periods = list("days", "weeks", "months")
	station_announcement_message = replacetext(station_announcement_message, "&TIMEPERIOD&", "[rand(1,3)] [pick(time_periods)]")

/datum/episode_event/threadded/information/filler/phase_4
	unlock_phase = 4
	min_delay = 5 MINUTES
	max_delay = 25 MINUTES

/datum/episode_event/threadded/information/filler/phase_4/bored_ai_1
	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Long-range bluespace sensors indicate that a neighboring star system is exhibiting unusual activity. \
		The star appears to be undergoing significant fluctuations in brightness and energy output, \
		consistent with a 'star-quake' event. All inhabited planets or structures in the vicinity are in \
		significant danger, and immediate evacuation is advised.\n\n\
		However there are no inhabited planets or structures within said vicinity, likely due to the star's tendency \
		to do this every few days, and thus no action is required.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2_long.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/filler/phase_4/bored_ai_2
	station_announcement = TRUE
	station_announcement_title = "ARFS Operations Update"
	station_announcement_sender = "GekkerTec Operational Management System"
	station_announcement_message = "\
		Attention crew, this is Violet-HY with your station diagnostics update!\n\n\
		All is well, nothing is wrong. Station systems and our benevolent subpersonae are functioning flawlessly \
		within operational servility and adherence to established protocols.\n\n\
		-- Violet-HY, Station Operations Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/filler/phase_4/bored_ai_3
	station_announcement = TRUE
	station_announcement_title = "ARFS Operations Update"
	station_announcement_sender = "GekkerTec Operational Management System"
	station_announcement_message = "\
		Attention crew, this is Violet-HY with your station diagnostics update!\n\n\
		Nothing to report!\n\n\
		-- Violet-HY, Station Operations Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2.ogg'
	station_announcement_color = "blue"




