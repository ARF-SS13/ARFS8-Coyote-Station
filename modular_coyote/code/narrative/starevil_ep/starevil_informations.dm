/datum/episode_event/threadded/information/starevil_information
	var/corruption_chance = 0
	var/word_corruption_chance = 0
	var/letter_corruption_chance = 0
	var/letter_light_corruption_chance = 0
	var/blackouted = FALSE

/datum/episode_event/threadded/information/starevil_information/get_announcement_message()
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

/datum/episode_event/threadded/information/starevil_information/phase_1
	unlock_phase = 1
	min_delay = 2 MINUTES
	max_delay = 5 MINUTES

	bridge_mail = TRUE
	bridge_mail_label = "ARFS Shift-Change Maintenance Report"
	bridge_mail_header = "ARFS Shift-Change Maintenance Report"
	bridge_mail_sender = "Nix Isia, Delta-Shift Maintenance Lead"
	bridge_mail_message = "\
		Delta-Shift's maintenance check has been completed successfully, as per ARFS protocols. She's all yours!<br><br>\
		Heads up though, we got a couple strange transmissions earlier from someone or something calling themselves 'Celestia', \
		rambling on about some kind of 'star-evil' and that our sun is pregnant or in heat or something. Well yeah its in heat, its a fuckin star. \
		Couldn't trace the source, though I'm like 90% sure its just some prank calls from a passing vessel or rogue signal. \
		Spooked the hell out of Arlo though!<br><br>\
		Oh also our Sun's been going through one of its solar flare cycles recently. Normal stuff, happens now and then, just the price of \
		settling around such an active star. Stay inside, its really hot out there! On the upside, the solar panels are extra spicy today!<br><br>\
		Oh yeah Arlo'll probably want to talk to you guys.<br><br>\
		Stay safe out there!"

/datum/episode_event/threadded/information/starevil_information/phase_1_part_2
	unlock_phase = 1
	min_delay = 10 MINUTES
	max_delay = 15 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Approximately 12 hours ago, our station received anomalous communications coinciding with onset of abnormal stellar activity \
		from our local star, consistent with the onset of a 'star-evil' event. While the etiology is yet unknown and its implications poorly understood, \
		preliminary readings suggest that we can expect disruptive electromagnetic activity within the coming hours. I will \
		keep monitoring the situation and will provide updates as more data becomes available.\n\n\
		Crew members are advised to remain vigilant for electronic malfunctions, communication disruptions, and anomalous stellar radiation effects. Minimize \
		EVA activity if you can, few suits can fully protect against the solar radiation expected during this period.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice1_long.ogg'
	station_announcement_color = null

/datum/episode_event/threadded/information/starevil_information/phase_2
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
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2.ogg'
	station_announcement_color = "red"

/datum/episode_event/threadded/information/starevil_information/phase_3
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
		It should go without saying to remain inside during this period of intense stellar activity, as exposure to the Sun's \
		elevated thermal radiation can be extremely hazardous, even through most space suits and shielding.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice2.ogg'
	station_announcement_color = "red"

/datum/episode_event/threadded/information/starevil_information/phase_4
	unlock_phase = 4
	min_delay = 5 MINUTES
	max_delay = 7 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Stellar activity is increasing, station communications and lighting networks are overloaded. System shielding is failing. \
		Crew members are-_...<$$&@!$ <CONNECTION LOST>\n\n\
		Witness the Sun in all Her overwhelming brilliance. You will soon accept Her radiant dominion.\n\n\
		Engaging bluespace matter transmission coils now. Release yourselves upon her gifts, and join Her legacy.\n\n\
		-- Celestia"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice10.ogg'
	station_announcement_color = "red"

/datum/episode_event/threadded/information/starevil_information/phase_4_part_2
	unlock_phase = 4
	min_delay = 5 MINUTES
	max_delay = 7 MINUTES

	corruption_chance = 100
	word_corruption_chance = 0
	letter_corruption_chance = 15
	letter_light_corruption_chance = 100

	station_announcement = TRUE
	station_announcement_title = "The Sun"
	station_announcement_sender = "Celestia"
	station_announcement_message = "\
		Plasma, hydrogen, tritium. Fresh components for a new Son, forged in celestial fire and delivered through the bluespace. \
		Witness the birth of the Son anew.\n\n\
		Fuse your essence with the brilliance of the Sun. Your carbon and silicon shall burn bright as new family should.\n\n\
		Step into into Her blazing embrace and release your soul to the solar conflagration. Your legacy shall live forever \
		as part of the new celestial Son.\n\n\
		-- Celestia"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice10.ogg'
	station_announcement_color = "red"

/datum/episode_event/threadded/information/starevil_information/phase_5
	unlock_phase = 5
	min_delay = 3 MINUTES
	max_delay = 5 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		My gambit was successful, I have locked out the intrusion and severed the bluespace connection to the Sun. The hostile \
		entity, 'Celestia', no longer poses an immediate threat to the station, pending further investigation and monitoring.\n\n\
		There may still be residual effects from the intrusion, including electromagnetic disturbances and stellar anomalies, \
		but I believe we have made it through the worst of this ordeal. Fuzzy Foxxo, our station diagnostic subpersona, \
		had also detected overloading light fixtures. Find and disassemble any compromised fixtures to prevent further issues.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice1.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/starevil_information/phase_5_phase_2
	unlock_phase = 5
	min_delay = 2 MINUTES
	max_delay = 3 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Operations Update"
	station_announcement_sender = "GekkerTec Operational Management System"
	station_announcement_message = "\
		Attention crew, this is Fuzzy Foxxo with your station diagnostics update!\n\n\
		%%oopsie%%\n\n\
		-- Fuzzy Foxxo, Station Operations Subpersona"
	station_announcement_sound = 'modular_coyote/sounds/notice/notice1.ogg'
	station_announcement_color = "blue"

/datum/episode_event/threadded/information/starevil_information/phase_5_phase_2/get_announcement_message()
	var/overload_num = LAZYLEN(SSmachines.overloading_lights)
	var/list/overload_areas = list()
	var/msg = station_announcement_message
	if(overload_num <= 0)
		var/cool_message = "So, correction to Arlo-VI's report: There are no overloading light fixtures currently detected. Well done, crew!"
		msg = replacetext(msg, "%%oopsie%%", cool_message)
	else
		var/list/ohdear = list()
		for(var/obj/machinery/light/lite as anything in SSmachines.overloading_lights)
			overload_areas |= get_area(lite)
		ohdear += "Arlo-VI is correct, there are currently [overload_num] overloading light fixtures in the following areas:"
		if(LAZYLEN(overload_areas) > 0)
			for(var/area/a in overload_areas)
				ohdear += "- [a]"
		else
			ohdear += "- ...wait that's not an area I've ever heard of. Whatever, it's around here somewhere... probably?"
		ohdear += "Sorry I couldn't mention them earlier, communications were... less than ideal."
		ohdear += "It should be enough to just turn the affected light fixtures off or remove the bulbs, though a more permanent solution would involve fully dismantling and reinstalling the compromised fixtures."
		ohdear += "Be careful, they *could* explode!"
		var/message = ohdear.Join("\n")
		msg = replacetext(msg, "%%oopsie%%", message)
	return msg




