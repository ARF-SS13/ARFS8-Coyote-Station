/*
// ╔═══╦════════════════════════════════╦═══╗
// ║♥♥♥║ CHARACTER DIRECTORY SUBSYSTEM! ║♥♥♥║
// ╠═══╬════════════════════════════════╩═══╩══════════════════════════════════════════════╦═══╗
// ║☺☻☺║ A planned update for the character directory to read and display offline profiles ║☺☻☺║
// ╚═══╩═══════════════════════════════════════════════════════════════════════════════════╩═══╝

#define DATING_PROFILE_PATH "data/horny_dating_profiles.json"
#define DATINGHEAD_TIME_STARTED "file_creation"
#define DATINGIDENT_HEAD "header"
#define DATINGIDENT_PROFILES "profiles"

SUBSYSTEM_DEF(dating_app)
	name = "DatingApp"
	flags = SS_NO_FIRE

	/// our loaded hand items, keyed cutely
	/// list("player_uid" = /datum/dating_data)
	var/list/loaded_profiles = list()
	var/datum/dating_app_header/dah

/datum/controller/subsystem/dating_app/Initialize(start_timeofday)
	load_character_profiles()
	to_chat(world, span_abductor("Loaded [LAZYLEN(loaded_profiles)] dating profiles!"))

/datum/controller/subsystem/dating_app/proc/load_character_profiles()
	if(!rustg_file_exists(DATING_FILE_PATH))
		create_new_dating_database()
	var/list/saved_profiles = safe_json_decode(rustg_file_read(DATING_PROFILE_PATH)) || list()

/// first use, probably! generate the base horny
/datum/controller/subsystem/dating_app/proc/create_new_dating_database()
	var/list/init_dat = list()
	init_dat["[DATINGIDENT_HEAD]"] = list()
	init_dat["[DATINGIDENT_HEAD]"]["[DATINGHEAD_TIME_STARTED]"] = world.time
	var/saveson = json_encode(init_dat)
	rustg_file_write(saveson, DATING_PROFILE_PATH)





/// metrics and such go here
/datum/dating_app_header
	var/timedate_created = ""

/datum/dating_app_header/New(list/saved)
	. = ..()
	load_from(saved)

/datum/dating_app_header/proc/load_from(list/saved_data = list())
	if(!saved_data["[DATINGIDENT_HEAD]"])
		apply_defaults()
		return
	var/list/headerdata = saved_data["[DATINGIDENT_HEAD]"]
	timedate_created = headerdata["[DATINGHEAD_TIME_STARTED]"]
	if(!timedate_created)
		apply_default_timedate_created()

/datum/dating_app_header/proc/apply_defaults()
	apply_default_timedate_created()

/datum/dating_app_header/proc/apply_default_timedate_created()
	timedate_created = world.realtime

/datum/dating_app_header/proc/export()
	var/list/header_data = list()
	header_data["[DATINGHEAD_TIME_STARTED]"] = timedate_created
	return header_data


 */
