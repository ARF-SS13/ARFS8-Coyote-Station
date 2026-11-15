/datum/episode_event/information/starevil_information
	var/corruption_chance = 0
	var/word_corruption_chance = 0
	var/letter_corruption_chance = 0
	var/letter_light_corruption_chance = 0
	var/blackouted = FALSE

/datum/episode_event/information/starevil_information/get_announcement_message()
	return cool_radio_scramble(
		station_announcement_message,
		corruption_chance,
		word_corruption_chance,
		letter_corruption_chance,
		letter_light_corruption_chance,
		list(),
		force = TRUE,
		blackout = blackouted,
	)

/datum/episode_event/information/starevil_information/phase_1
	unlock_phase = 1
	min_delay = 2 MINUTES
	max_delay = 5 MINUTES

	bridge_mail = TRUE
	bridge_mail_label = "ARFS Shift-Change Maintenance Report"
	bridge_mail_header = "ARFS Shift-Change Maintenance Report"
	bridge_mail_sender = "Nix Isia, Delta-Shift Maintenance Lead"
	bridge_mail_message = "\
		Delta-Shift's maintenance check has been completed successfully, as per ARFS protocols. She's all yours!<br><br>\
		Heads up though, Arlo's been really antsy about our sun's activity lately. Been saying stuff about some kind of \
		'star-evil' event taking place soon. I had to look it up, and apparently it's some kind of solar flare activity \
		that our kind of star is particularly susceptible to. Arlo knows a lot more about this than I do, she'll fill \
		you in on the details soon.<br><br>\
		Stay safe out there!"

/datum/episode_event/information/starevil_information/phase_1_part_2
	unlock_phase = 1
	min_delay = 10 MINUTES
	max_delay = 15 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Approximately 12 hours ago, our local star exhibited abnormal stellar activity consistent with the onset \
		of a solar flare event. While the etiology is yet unknown and its implications poorly understood, \
		preliminary readings suggest that we can expect disruptive electromagnetic activity within the coming hours. I will \
		keep monitoring the situation and will provide updates as more data becomes available. It is likely just a period of \
		heightened stellar activity.\n\n\
		Crew members are advised to remain vigilant for electronic malfunctions, communication disruptions, \
		and anomalous stellar radiation effects.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = null

/datum/episode_event/information/starevil_information/phase_2
	unlock_phase = 2
	min_delay = 10 MINUTES
	max_delay = 15 MINUTES

	corruption_chance = 100
	word_corruption_chance = 2
	letter_corruption_chance = 10
	letter_light_corruption_chance = 100

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Our local star's electromagnetic activity has been steadily increasing, and I fear that it will continue to do so for \
		quite some time. Our communications systems, as well as our lighting infrastructure for whatever reason, seem to be \
		particularly susceptible to the high-frequency electromagnetic interference. Poorly shielded headsets may experience \
		disruptions or complete signal loss during this period. Handheld radios, bowman headsets, and intercomms may prove \
		more reliable, though it is still uncertain.\n\n\
		Crew members are advised to witness our local star and approach it with caution.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/starevil_information/phase_3
	unlock_phase = 3
	min_delay = 5 MINUTES
	max_delay = 15 MINUTES

	corruption_chance = 100
	word_corruption_chance = 2
	letter_corruption_chance = 15
	letter_light_corruption_chance = 100

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Stellar activity is increasing, station communications and lighting networks are overloaded. System shielding is failing. \
		There has been an intrusion into the system's bluespace aethernet, source unknown, attempting to resolve a connection \
		between the station and the Sun. I am currently attempting to sever this connection, though it will require quite some \
		time for me to do so.\n\n\
		Expect anomalous bluespace bubbles consistent with coronal mass ejection events. I will assist in locating these when they \
		happen, though you will need to neutralize them yourselves. Consult Research for anomaly neutralizers.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/starevil_information/phase_3_part_2
	unlock_phase = 3
	min_delay = 5 MINUTES
	max_delay = 7 MINUTES

	corruption_chance = 100
	word_corruption_chance = 0
	letter_corruption_chance = 15
	letter_light_corruption_chance = 100

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "The Sun"
	station_announcement_message = "\
		#1*$@# !! EMBRACE THE SUN !! #!^$*@"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/starevil_information/phase_4
	unlock_phase = 4
	min_delay = 5 MINUTES
	max_delay = 7 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Stellar activity is increasing, station communications and lighting networks are overloaded. System shielding is failing. \
		Witness the Sun in all its overwhelming brilliance. We will soon accept its radiant dominion.\n\n\
		Engaging bluespace transmission coils now. Stand by for arrival of stellar material.\n\n\
		Crew members are-_...<$$&@!$ <CONNECTION LOST>\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/starevil_information/phase_4_part_2
	unlock_phase = 4
	min_delay = 15 MINUTES
	max_delay = 20 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		My gambit was successful, and I have resolved the intrusion. I am currently working on severing our \
		connection to the sun. \n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/starevil_information/phase_5
	unlock_phase = 5
	min_delay = 5 MINUTES
	max_delay = 7 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Environmental sensors indicate that the station has passed through the worst of this section of the debris field.\n\n\
		Dust and smaller debris particles may still be present in the vicinity, albeit at reduced concentrations.\n\n\
		You did well to navigate through this hazardous section of the debris field, continue to exercise caution as \
		residual debris may still pose a threat to the station's external systems.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "blue"



