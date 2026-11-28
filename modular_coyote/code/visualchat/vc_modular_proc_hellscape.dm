/mob/Login()
	. = ..()
	if(!prefs_character_ckey)
		prefs_character_ckey = ckey(client.ckey)
	if(!prefs_character_slot)
		prefs_character_slot = extract_current_character_slot(src, TRUE)
	var/datum/vc_account_prefs_manager/speaker_manager = SSvisualchat.GetVCAccountPrefsManager(ckey(client.ckey), FALSE)
	speaker_manager.get_prefs_holder_for_slot(prefs_character_slot)

/// into which slot in the prefs save file does this characters data comes from?
/atom/var/prefs_character_slot // number
/// the first ckey to ever enter this mob, for the purposes of visualchat account management
/atom/var/prefs_character_ckey // text
/// foir things that are like not players but also use a visualchat account
/atom/var/vc_override_key // text
