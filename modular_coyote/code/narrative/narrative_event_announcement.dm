/datum/episode_event/information
	quiet = FALSE
	alert_once = FALSE
	max_runs = 1
	is_progressive = TRUE
	min_cooldown = 30 SECONDS
	unlock_phase = 1
	min_delay = 30 SECONDS
	max_delay = 10 MINUTES
	// bridge mail stuff
	var/bridge_mail = FALSE
	var/bridge_mail_label = "ARFS Diagnostics Report"
	var/bridge_mail_header = "ARFS Diagnostics Report"
	var/bridge_mail_sender = "ARFS Diagnostics System"
	var/bridge_mail_message = "Oh no!"
	// station announcement stuff (works with bridge mail)
	var/station_announcement = FALSE
	var/station_announcement_title = "ARFS Diagnostics Update"
	var/station_announcement_sender = "ARFS"
	var/station_announcement_message = "Oh no!"
	var/station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	var/station_announcement_color = "green"

/datum/episode_event/information/run_event(force, delay)
	if(bridge_mail)
		send_bridge_mail()
	if(station_announcement)
		send_station_announcement()
	finished = TRUE
	return TRUE


/datum/episode_event/information/proc/send_bridge_mail()
	. = "<b><center>[bridge_mail_header]</center></b>"
	. += "<hr>"
	. += "<p style=\"text-align: justify;\">[bridge_mail_message]</p>"
	. += "<hr>"
	. += "<p style=\"text-align: justify;\">- [bridge_mail_sender]</p>"
	print_command_report(., "[bridge_mail_label]", announce = !station_announcement)
	return TRUE

/datum/episode_event/information/proc/send_station_announcement()
	if(!station_announcement_sound)
		station_announcement_sound = ANNOUNCER_COMMAND_REPORT
	priority_announce(
		station_announcement_message,
		station_announcement_title,
		station_announcement_sound,
		ANNOUNCEMENT_TYPE_PRIORITY,
		sender_override = station_announcement_sender,
		has_important_message = TRUE,
		color_override = station_announcement_color,
	)
	return TRUE



