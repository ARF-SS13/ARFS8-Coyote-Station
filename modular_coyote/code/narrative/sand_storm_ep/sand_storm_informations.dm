/datum/episode_event/information/sand_storm_information

/datum/episode_event/information/sand_storm_information/phase_1
	unlock_phase = 1
	min_delay = 2 MINUTES
	max_delay = 5 MINUTES

	bridge_mail = TRUE
	bridge_mail_label = "ARFS Shift-Change Maintenance Report"
	bridge_mail_header = "ARFS Shift-Change Maintenance Report"
	bridge_mail_sender = "Nix Isia, Delta-Shift Maintenance Lead"
	bridge_mail_message = "\
		Delta-Shift's maintenance check has been completed successfully, as per ARFS protocols. She's all yours!<br><br>\
		It wasn't easy! Another comet hit Emma*, which ejected a shitload of debris into orbit, which pelted us for \
		the greater part of the shift. It was a real mess, tore up the solar panels and nearly tore open the hull. \
		Of course, nothing Delta-Shift can't handle! We fixed everything and swept up the dust, so whatever state the \
		station ends up most certainly cannot be blamed on us!<br><br>\
		Heads up though, our astrotechs predict that the station will likely orbit through another patch of debris soon into \
		your shift. Likely just a bunch of dust and sand, nothing too catastrophic, but it is still likely to cause a lot \
		of damage to the station. Watch the windows and weaker walls closely during your shift!<br><br>\
		Stay safe out there!<br><br><br>\
		* The moon orbiting Elizabeth**<br>\
		** The planet we're both*** orbiting<br>\
		*** This station and Emma*"

/datum/episode_event/information/sand_storm_information/phase_1_part_2
	unlock_phase = 1
	min_delay = 10 MINUTES
	max_delay = 15 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Approximately 7 days ago, a comet impacted Emma, our host planet's moon. This collision ejected a significant \
		amount of debris into orbit, which as of a few days ago has been steadily intersecting the station's orbital path.\n\n\
		Environmental sensors indicate that the debris is likely to continue intersecting the station's orbit for the \
		forseeable future. Previous shifts have reported the debris composition to be primarily dust and small rocky fragments, \
		which, while not immediately catastrophic, can still pose significant risks to the station's structural integrity and \
		external surfaces, such as windows and weaker walls.\n\n\
		Sensors indicate that the debris will come from the %DIRECTION%, relative to the station's North axis.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = null

/datum/episode_event/information/sand_storm_information/get_announcement_message()
	var/direct = "unknown direction"
	switch(GLOB.meteor_direction)
		if(NORTH)
			direct = "north"
		if(SOUTH)
			direct = "south"
		if(EAST)
			direct = "east"
		if(WEST)
			direct = "west"
	var/msg = replacetext(station_announcement_message, "%DIRECTION%", direct)
	return msg

/datum/episode_event/information/sand_storm_information/phase_2
	unlock_phase = 2
	min_delay = 10 MINUTES
	max_delay = 15 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Environmental sensors indicate that the concentration of debris in the station's orbital path remains significant, \
		expect an increase in debris density and potential impacts on the station's external surfaces in the coming hours.\n\n\
		Exercise caution when near external walls, as impacts from debris can cause harm to personnel and equipment inside \
		the station.\n\n\
		Sensors also indicate that the debris, upon impact, disintegrates into usable material resources, such as iron, glass, \
		plasma, and other valuable materials. The crew should take appropriate precautions when attempting to retrieve these \
		resources, as while the danger remains, the materials can be exceptionally useful for repairs to the station.\n\n\
		As a reminder, the debris will be coming from the %DIRECTION%, relative to the station's North axis.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/sand_storm_information/phase_3
	unlock_phase = 3
	min_delay = 15 MINUTES
	max_delay = 20 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Environmental sensors indicate that the debris concentration continues to rise, and rate of impacts on the station \
		external surfaces is increasing. Sensors are also detecting multiple larger debris fragments approaching the station, \
		potentially capable of causing widespread destruction to the station if impacted. ETA of impact is within the next \
		half an hour. Be prepared for immediate engineering response and take all necessary safety precautions.\n\n\
		As a reminder, the debris will be coming from the %DIRECTION%, relative to the station's North axis.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	station_announcement_color = "red"

/datum/episode_event/information/sand_storm_information/phase_4
	unlock_phase = 4
	min_delay = 5 MINUTES
	max_delay = 7 MINUTES

	station_announcement = TRUE
	station_announcement_title = "ARFS Astro-Environmental Update"
	station_announcement_sender = "GekkerTec Intrasystem Monitoring System"
	station_announcement_message = "\
		Attention crew, this is Arlo-VI with an astro-environmental update.\n\n\
		Environmental sensors indicate that large debris fragments are approaching the station, impacts imminent!\n\n\
		As a reminder, the debris will be coming from the %DIRECTION%, relative to the station's North axis.\n\n\
		-- Arlo-VI, Station Diagnostic Subpersona"
	station_announcement_sound = ANNOUNCER_METEORS
	station_announcement_color = "red"

/datum/episode_event/information/sand_storm_information/phase_5
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
	station_announcement_sound = ANNOUNCER_METEORS
	station_announcement_color = "blue"



