/datum/computer_file/program/character_directory
	filename = "only_spess"
	filedesc = "OnlySpace Dating App v1.0.2"
	extended_desc = "Find your SpaceMate!"
	program_open_overlay = "generic"
	undeletable = TRUE
	size = 0
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_HEADER
	tgui_id = null
	program_icon = "smile"


/datum/computer_file/program/character_directory/simple_act(mob/user)
	if(user?.client)
		user.client.open_character_directory()
	return TRUE
