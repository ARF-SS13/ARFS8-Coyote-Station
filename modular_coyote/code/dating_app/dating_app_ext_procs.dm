/// Cooldown so ppl cant spam it so good
/client/var/char_directory_cooldown = 0

/// Admins can access the CD from ahost
ADMIN_VERB(show_character_directory, R_ADMIN, "Show Character Directory", "View the character directory.", ADMIN_CATEGORY_FUN)
// /client/verb/show_character_directory()
	if(!isAdminObserver(user.mob))
		to_chat(user, span_hypnophrase("For technical limitation reasons "))
	user.open_character_directory()

// PROC WHAT OPENS IT
/client/proc/open_character_directory()
	var/mob/doer_mob = mob
	if(!COOLDOWN_FINISHED(src, char_directory_cooldown))
		to_chat(src, span_alert("Hold your horses! It's still refreshing!"))
		return
	COOLDOWN_START(src, char_directory_cooldown, 1 SECONDS)

//Check if there's not already a character directory open; open a new one if one is not present
	GLOB.character_directory.ui_interact(doer_mob)
