/// BYOND timestamp corresponding to deadline (Jun. 16, 2025)
#define DEADLINE_TIMESTAMP 8033472000

/mob/dead/new_player
	/// Title screen is ready to receive signals
	var/title_screen_is_ready = FALSE
	/// Whether the player (if unvetted) has acknowledged the deadline warning
	var/unvetted_notified = FALSE

/**
 * Check player vetting status and if necessary warn about upcoming deadline
 *
 * Returns FALSE if unvetted and deadline has passed, TRUE otherwise
 */
/mob/dead/new_player/proc/trigger_unvetted_warning()
	if(!CONFIG_GET(flag/check_vetted))
		unvetted_notified = TRUE
		return TRUE
	if(!SSplayer_ranks.initialized)
		return TRUE
	if(SSplayer_ranks.is_vetted(client, admin_bypass = FALSE))
		unvetted_notified = TRUE
		return TRUE

	// // Time's up
	// if(DEADLINE_TIMESTAMP - world.realtime <= 0)
	// 	tgui_alert(
	// 		src,
	// 		"Unvetted players are no longer allowed to join or observe rounds, please visit #get-vetted in the Discord to submit a vetting application",
	// 		"You are unvetted!",
	// 		timeout = 10 SECONDS,
	// 	)
	// 	return FALSE

	// var/remaining_time = round((DEADLINE_TIMESTAMP - world.realtime) / (1 DAYS), 1)
	// tgui_deadline_alert(
	// 	src,
	// 	"Unvetted players will lose the ability to join or observe rounds in [remaining_time] day\s!",
	// 	"Get vetted by [time2text(DEADLINE_TIMESTAMP, "Month DD YYYY")]!",
	// 	days_remaining = remaining_time,
	// 	timeout = 10 SECONDS,
	// )
	unvetted_notified = TRUE
	return TRUE

/mob/dead/new_player/Topic(href, href_list)
	if(src != usr)
		return

	if(!client)
		return

	if(client.interviewee)
		return FALSE

	if(href_list["play_lobby_button_sound"])
		play_lobby_button_sound("play_lobby_button_sound")
		return

	if(href_list["observe"])
		play_lobby_button_sound("observe")
		if(!unvetted_notified && !trigger_unvetted_warning())
			return FALSE
		make_me_an_observer()
		return

	if(href_list["job_traits"])
		play_lobby_button_sound()
		if(!unvetted_notified && !trigger_unvetted_warning())
			return FALSE
		show_job_traits()
		return

	if(href_list["server_swap"])
		play_lobby_button_sound()
		server_swap()
		return

	if(href_list["view_manifest"])
		play_lobby_button_sound()
		ViewManifest()
		return

	// if(href_list["character_directory"])
	// 	play_lobby_button_sound()
	// 	client.show_character_directory()
	// 	return

	if(href_list["toggle_antag"])
		play_lobby_button_sound()
		var/datum/prefs_holder/preferences = client.prefs
		preferences.write_preference(GLOB.preference_entries[/datum/preference/toggle/be_antag], !preferences.read_preference(/datum/preference/toggle/be_antag))
		client << output(preferences.read_preference(/datum/preference/toggle/be_antag), "title_browser:toggle_antag")
		return

	if(href_list["character_setup"])
		play_lobby_button_sound("preferences")
		var/datum/prefs_holder/preferences = client.prefs
		preferences.current_window = PREFERENCE_TAB_CHARACTER_PREFERENCES
		preferences.update_static_data(src)
		preferences.ui_interact(src)
		return

	if(href_list["game_options"])
		play_lobby_button_sound("preferences")
		var/datum/prefs_holder/preferences = client.prefs
		preferences.current_window = PREFERENCE_TAB_GAME_PREFERENCES
		preferences.update_static_data(usr)
		preferences.ui_interact(usr)
		return

	if(href_list["toggle_ready"])
		// Prevent readying up after the round has begun setting up or is already playing

		if(!prerequisites_met(TRUE))
			play_lobby_button_sound("cantreadyornot")
			return FALSE

		if(!unvetted_notified && !trigger_unvetted_warning())
			play_lobby_button_sound("cantreadyornot")
			return FALSE
		ready = is_ready_to_play() ? PLAYER_NOT_READY : PLAYER_READY_TO_PLAY
		if(ready == PLAYER_READY_TO_PLAY)
			play_lobby_button_sound("ready")
		else
			play_lobby_button_sound("unready")

		client << output(ready, "title_browser:toggle_ready")
		return

	if(href_list["late_join"])
		if(!unvetted_notified && !trigger_unvetted_warning())
			play_lobby_button_sound("cantreadyornot")
			return FALSE
		if(!prerequisites_met())
			play_lobby_button_sound("cantreadyornot")
			return FALSE
		play_lobby_button_sound("join")

		GLOB.latejoin_menu.ui_interact(usr)
		return

	if(href_list["title_is_ready"])
		title_screen_is_ready = TRUE
		return

	if(href_list["polls_menu"])
		play_lobby_button_sound()
		handle_player_polling()
		return

	. = ..()

/mob/dead/new_player/Login()
	. = ..()
	show_title_screen()

/**
 * Shows the titlescreen to a new player.
 */
/mob/dead/new_player/proc/show_title_screen()
	if (client?.interviewee)
		return

	winset(src, "title_browser", "is-disabled=false;is-visible=true")
	winset(src, "status_bar", "is-visible=false")

	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/lobby) //Sending pictures to the client
	assets.send(src)

	update_title_screen()

/**
 * Hard updates the title screen HTML, it causes visual glitches if used.
 */
/mob/dead/new_player/proc/update_title_screen()
	var/dat = get_title_html()
	//SPLURT EDIT START - Splashscreen toggle
	//src << browse(SStitle.current_title_screen, "file=loading_screen.gif;display=0")
	var/hide_splashscreen = (client && client.prefs.read_preference(/datum/preference/toggle/hide_splashscreen)) || (!client?.maturity_prompt_whitelist && CONFIG_GET(flag/age_prompt_system))
	var/splashscreen_to_load = SStitle.current_title_screen
	if(splashscreen_to_load && splashscreen_to_load != DEFAULT_TITLE_LOADING_SCREEN && hide_splashscreen)
		splashscreen_to_load = DEFAULT_TITLE_SCREEN_IMAGE
	src << browse(splashscreen_to_load, "file=loading_screen.gif;display=0")
	//SPLURT EDIT END
	src << browse(dat, "window=title_browser")

/// can we actually join the thing?
/mob/dead/new_player/proc/prerequisites_met(amreadying)
	if(amreadying)
		if(SSticker.current_state >= GAME_STATE_SETTING_UP)
			to_chat(src, span_notice("The round is starting. You cannot ready up at this time."))
			return FALSE
	var/am_admin = is_admin(client)
	var/list/bads = list()
	if(CONFIG_GET(flag/min_flavor_text))
		var/datum/prefs_holder/preferences = client.prefs
		var/uses_silicon_flavortext = (is_silicon_job(preferences?.get_highest_priority_job()) && length_char(client?.prefs?.read_preference(/datum/preference/text/silicon_flavor_text)) < CONFIG_GET(number/silicon_flavor_text_character_requirement))
		var/uses_normal_flavortext = (!is_silicon_job(preferences?.get_highest_priority_job()) && length_char(client?.prefs?.read_preference(/datum/preference/text/flavor_text)) < CONFIG_GET(number/flavor_text_character_requirement))
		if(uses_silicon_flavortext)
			var/need = CONFIG_GET(number/silicon_flavor_text_character_requirement)
			var/got = length_char(client?.prefs?.read_preference(/datum/preference/text/silicon_flavor_text))
			bads["silicon_flavor_text"] = list(got, need)
			return
		if(uses_normal_flavortext)
			var/need = CONFIG_GET(number/flavor_text_character_requirement)
			var/got = length_char(client?.prefs?.read_preference(/datum/preference/text/flavor_text))
			bads["flavor_text"] = list(got, need)
			return
	var/list/tnbs = client?.prefs?.read_preference(/datum/preference/temperaments_and_builds)
	var/temperament_count = 0
	var/build_count = 0
	for(var/tnb_category in tnbs)
		if(tnb_category == TNB_TEMPERAMENT)
			temperament_count = LAZYLEN(tnbs[tnb_category])
		else if(tnb_category == TNB_BUILD)
			build_count = LAZYLEN(tnbs[tnb_category])
	if(temperament_count < GLOB.max_tnb_sel[TNB_TEMPERAMENT])
		bads["temperament"] = list(temperament_count, GLOB.max_tnb_sel[TNB_TEMPERAMENT])
	if(build_count < GLOB.max_tnb_sel[TNB_BUILD])
		bads["build"] = list(build_count, GLOB.max_tnb_sel[TNB_BUILD])

	if(!LAZYLEN(bads))
		return TRUE // okay have a good round!

	var/chooses = list(
		"Okay!",
		"Sure!",
		"I understand!",
	)

	var/message = "Oh dear, your character needs some extra work before you can get into the round!\n"
	message += "Here's what's missing:\n\n"
	if("silicon_flavor_text" in bads)
		message += "<b>Silicon Flavor Text</b>\n"
		message += "Your flavor text is [bads["silicon_flavor_text"][1]] characters long./n"
		message += "However, you need at least [bads["silicon_flavor_text"][2]] characters of Silicon Flavor Text to ready up for the round.\n\n"
	if("flavor_text" in bads)
		message += "<b>Flavor Text</b>\n"
		message += "Your flavor text is [bads["flavor_text"][1]] characters long.\n"
		message += "However, you need at least [bads["flavor_text"][2]] characters of Flavor Text to ready up for the round.\n\n"
	if("temperament" in bads)
		message += "<b>Temperament</b>\n"
		message += "You have [bads["temperament"][1]] temperament(s) selected.\n"
		message += "However, you need at least [bads["temperament"][2]] temperament(s) to ready up for the round.\n\n"
	if("build" in bads)
		message += "<b>Build</b>\n"
		message += "You have [bads["build"][1]] build(s) selected.\n"
		message += "However, you need at least [bads["build"][2]] build(s) to ready up for the round.\n\n"
	if(am_admin)
		message += "\n...however, you're an admin! You can ignore these requirements and ready up anyway if you want."
		chooses = list(
			"Let me in anyway!",
			"Okay ill go do that i guess!"
		)
	else
		message += "\nPlease fix these issues before you can ready up for the round! ♥"
	to_chat(src, span_abductor(message))
	var/confirm = tgui_alert(
		src,
		message,
		"Oh no!",
		chooses,
	)
	if(am_admin && confirm == "Let me in anyway!")
		return TRUE
	return FALSE

/datum/asset/simple/lobby
	assets = list(
		"FixedsysExcelsior3.01Regular.ttf" = 'html/browser/FixedsysExcelsior3.01Regular.ttf',
	)

/**
 * Removes the titlescreen entirely from a mob.
 */
/mob/dead/new_player/proc/hide_title_screen()
	if(client?.mob)
		winset(client, "title_browser", "is-disabled=true;is-visible=false")
		winset(client, "status_bar", "is-visible=true")

/mob/dead/new_player/proc/play_lobby_button_sound(which)
	var/snd = 'modular_coyote/sounds/menu/add_click.ogg'
	switch(which)
		if("preferences")
			snd = 'modular_coyote/sounds/menu/save_click.ogg'
		if("observe", "join", "ready")
			snd = 'modular_coyote/sounds/menu/tab_click.ogg'
		if("unready")
			snd = 'modular_coyote/sounds/menu/remove_click.ogg'
		if("cantreadyornot")
			snd = 'modular_coyote/sounds/menu/bad_click.ogg'
		if("play_lobby_button_sound")
			snd = 'modular_coyote/sounds/menu/remove.ogg'
		else
			snd = 'modular_coyote/sounds/menu/add_click.ogg'
	SEND_SOUND(src, sound(snd))

/**
 * Allows the player to select a server to join from any loaded servers.
 */
/mob/dead/new_player/proc/server_swap()
	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	if(LAZYLEN(servers) == 1)
		var/server_name = servers[1]
		var/server_ip = servers[server_name]
		var/confirm = tgui_alert(src, "Are you sure you want to swap to [server_name] ([server_ip])?", "Swapping server!", list("Connect me!", "Stay here"))
		if(confirm == "Connect me!")
			to_chat_immediate(src, "So long, spaceman.")
			client << link(server_ip)
		return
	var/server_name = tgui_input_list(src, "Please select the server you wish to swap to:", "Swap servers!", servers)
	if(!server_name)
		return
	var/server_ip = servers[server_name]
	var/confirm = tgui_alert(src, "Are you sure you want to swap to [server_name] ([server_ip])?", "Swapping server!", list("Connect me!", "Stay here!"))
	if(confirm == "Connect me!")
		to_chat_immediate(src, "So long, spaceman.")
		src.client << link(server_ip)

/**
 * Shows currently available job traits
 */
/mob/dead/new_player/proc/show_job_traits()
	if (!client || client.interviewee)
		return
	if(!length(GLOB.lobby_station_traits))
		to_chat(src, span_warning("There are currently no job traits available!"))
		return
	var/list/available_lobby_station_traits = list()
	for (var/datum/station_trait/trait as anything in GLOB.lobby_station_traits)
		if (!trait.can_display_lobby_button(client))
			continue
		available_lobby_station_traits += trait

	if(!LAZYLEN(available_lobby_station_traits))
		to_chat(src, span_warning("There are currently no job traits available!"))
		return

	var/datum/station_trait/clicked_trait = tgui_input_list(src, "Select a job trait to sign up for:", "Job Traits", available_lobby_station_traits)

	if(!clicked_trait)
		return

	clicked_trait.on_lobby_button_click(src)

/**
 * Shows the player a list of current polls, if any.
 */
/mob/dead/new_player/proc/playerpolls()
	if(!usr || !client)
		return

	var/output
	if (!SSdbcore.Connect())
		return
	var/isadmin = FALSE
	if(client?.holder)
		isadmin = TRUE
	var/datum/db_query/query_get_new_polls = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("poll_question")]
		WHERE (adminonly = 0 OR :isadmin = 1)
		AND Now() BETWEEN starttime AND endtime
		AND deleted = 0
		AND id NOT IN (
			SELECT pollid FROM [format_table_name("poll_vote")]
			WHERE ckey = :ckey
			AND deleted = 0
		)
		AND id NOT IN (
			SELECT pollid FROM [format_table_name("poll_textreply")]
			WHERE ckey = :ckey
			AND deleted = 0
		)
	"}, list("isadmin" = isadmin, "ckey" = ckey))

	if(!query_get_new_polls.Execute())
		qdel(query_get_new_polls)
		return
	if(query_get_new_polls.NextRow())
		output +={"<a class="menu_button menu_newpoll" href='byond://?src=[text_ref(src)];polls_menu=1'>POLLS (NEW)</a>"}
	else
		output +={"<a class="menu_button" href='byond://?src=[text_ref(src)];polls_menu=1'>POLLS</a>"}
	qdel(query_get_new_polls)
	if(QDELETED(src))
		return
	return output

#undef DEADLINE_TIMESTAMP
