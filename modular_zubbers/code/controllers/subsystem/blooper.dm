#define BLOOPER_CONFIG_PATH "modular_coyote/bloopers/blooper_config.json"

SUBSYSTEM_DEF(blooper)
	name = "Blooper"
	flags = SS_NO_FIRE | SS_NO_INIT

	var/list/blooper_list
	var/angry_letter
	var/version
	var/debug = TRUE

/datum/controller/subsystem/blooper/OnConfigLoad()
	blooper_list = initialize_blooper_datums()
	to_chat(world, span_abductor("Initialized [LAZYLEN(blooper_list)] annoying say sounds[angry_letter?" and one angry letter to some guy":""]!"))
	if(debug && version)
		to_chat(world, span_abductor("Blooper file version: [version]"))

/datum/controller/subsystem/blooper/proc/initialize_blooper_datums()
	var/list/blooper_datums = list()
	if(!rustg_file_exists("[BLOOPER_CONFIG_PATH]"))
		logger.Log(LOG_CATEGORY_DEBUG, "blooper_config.json not found.")
		return blooper_datums
	var/list/blooper_entries = safe_json_decode(rustg_file_read("[BLOOPER_CONFIG_PATH]"))
	if(isnull(blooper_entries))
		stack_trace("Blooper config is malformed!")
		return blooper_datums
	for(var/entry in blooper_entries)
		// These fields are required
		if(!isnull(entry["comment"]))
			angry_letter = TRUE
			continue // gotta include the message that moseley is an idiot
		if(!isnull(entry["version_debug"]))
			version = entry["version_debug"]
			continue
		if(isnull(entry["name"]) || isnull(entry["id"]) || isnull(entry["files"]) || !length(entry["files"]))
			stack_trace("Blooper config entry was missing required field!")
			continue
		var/datum/blooper/new_blooper = new()
		new_blooper.name = entry["name"]
		new_blooper.id = entry["id"]
		for(var/file in entry["files"])
			var/soundfile = "[file]"
			if(debug)
				if(!rustg_file_exists(soundfile))
					message_admins("HELP! [entry["name"]] blooper has INVALID SOUND!!! [soundfile]!!!!")
			new_blooper.soundpath_list += sound("[soundfile]")
		new_blooper.min_pitch = entry["min_pitch"] || BLOOPER_DEFAULT_MINPITCH
		new_blooper.max_pitch = entry["max_pitch"] || BLOOPER_DEFAULT_MAXPITCH
		new_blooper.min_vary  = entry["min_vary"]  || BLOOPER_DEFAULT_MINVARY
		new_blooper.max_vary  = entry["max_vary"]  || BLOOPER_DEFAULT_MAXVARY
		new_blooper.min_speed = entry["min_speed"] || BLOOPER_DEFAULT_MINSPEED
		new_blooper.max_speed = entry["max_speed"] || BLOOPER_DEFAULT_MAXSPEED
		blooper_datums[new_blooper.id] = new_blooper
	return blooper_datums

#undef BLOOPER_CONFIG_PATH
