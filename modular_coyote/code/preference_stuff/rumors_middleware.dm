/datum/preference_middleware/rumors

/datum/preference_middleware/rumors/New(datum/prefs_holder)
	. = ..()
	action_delegations += list(
		"operate_rumormill" = PROC_REF(operate_rumormill),
	)

/// FPREFSORMAT: list("uid" = list("txt" = "rumor text", "horny" = "yes"/"no"), ...)

// enum RumorDefs {
//!   // stuff to the server
//   RAct = "rumor_act",
//   RAdd = "rumor_add",
//   RDelete = "rumor_delete",
//   REditText = "rumor_edit_text",
//   RToggleNSFW = "rumor_toggle_nsfw",
//   RTogglePublic = "rumor_toggle_public",
//   RToggleSpecifiable = "rumor_toggle_specifiable",
//   RUidSend = "rumor_uid",
//   RMoveUp = "rumor_move_up",
//   RMoveDown = "rumor_move_down",
//!   // stuff from the server
//   RUidReceive = "uid",
//   RText = "text",
//   RHorny = "horny",
//   RPublic = "public",
//   RSpecifiable = "specifiable",
//   RPosition = "position",
//!   // values for RPosition
//   RPosTop = "top",
//   RPosMid = "mid",
//   RPosBottom = "bottom",
//   RPosHidden = "hidden",
//!   // values for RHorny
//   RYes = "yes",
//   RNo = "no",
//!   // thing key
//   RAllRumors = "allrumors",

// those suck, heres some new ones
// Singular rumor keys
//   R_Uid              = "uid"
//   R_Text             = "text"
//   R_IsHorny          = "horny"
//   R_IsPublic         = "public"
//   R_IsSpecifiable    = "specifiable"
//   R_Position         = "position"
//   R_TimesSpread      = "times_spread"
//   R_DeletedTime      = "deleted_time"
//   R_CreatedTime      = "created_time"
//   R_ModifiedTime     = "modified_time"
// RumorHolderSlot keys
//   RHS_Slot           = "slot"
//   RHS_CharacterName  = "character_name"
//   RHS_Rumors         = "rumors"
// RumorHolder keys
//   RH_Ckey            = "ckey"
//   RH_LastOnline      = "last_online"
//   RH_SlotHolder      = "slot_holder"
// TGUI -> Server Rumor Action keys
//   RACT_Invoke             = "operate_rumormill"
//   RACT_Add                = "rumor_add"
//   RACT_Delete             = "rumor_delete"
//   RACT_EditText           = "rumor_edit_text"
//   RACT_ToggleNSFW         = "rumor_toggle_nsfw"
//   RACT_TogglePublic       = "rumor_toggle_public"
//   RACT_ToggleSpecifiable  = "rumor_toggle_specifiable"
//   RACT_MoveUp             = "rumor_move_up"
//   RACT_MoveDown           = "rumor_move_down"
// TGUI -> Server Rumor Action values
//   RACTV_Uid               = "rumor_uid"
// }
// TGUI data keys
// "holder_slot" = Data pack used by the prefs menu

/datum/preference_middleware/rumors/proc/operate_rumormill(list/params, mob/user)
	var/d_slot = preferences.default_slot
	switch(params["rumor_act"])
		if("rumor_add")
			SSrumormill.add_new_rumor(user, d_slot)
		if("rumor_delete")
			SSrumormill.delete_rumor(user, params["rumor_uid"], d_slot)
		if("rumor_edit_text")
			SSrumormill.edit_rumor_text(user, params["rumor_uid"], d_slot)
		if("rumor_toggle_nsfw")
			SSrumormill.toggle_rumor_nsfw(user, params["rumor_uid"], d_slot)
		if("rumor_move_up")
			SSrumormill.move_rumor_up(user, params["rumor_uid"], d_slot)
		if("rumor_move_down")
			SSrumormill.move_rumor_down(user, params["rumor_uid"], d_slot)
		if("rumor_toggle_public")
			SSrumormill.toggle_rumor_public(user, params["rumor_uid"], d_slot)
		if("rumor_toggle_specifiable")
			SSrumormill.toggle_rumor_specifiable(user, params["rumor_uid"], d_slot)
		if("rumor_copy_single")
			SSrumormill.CopyRumor(user, user.ckey, params["rumor_uid"], d_slot)
		if("rumor_copy_all")
			SSrumormill.CopyRumor(user, user.ckey, params["rumor_uid_list"], d_slot)
		if("rumor_paste")
			SSrumormill.PasteRumor(user, user.ckey, d_slot)
		else
			return FALSE
	SSrumormill.update_rumor_person(user, d_slot)
	return TRUE

/datum/preference_middleware/rumors/get_ui_data(mob/user)
	var/d_slot = preferences.default_slot
	return SSrumormill.get_rumors_for_tgui(user, d_slot)
