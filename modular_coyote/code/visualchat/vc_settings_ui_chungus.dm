/// hi im a holder for the settings ui
/datum/vc_settings_ui_chungus

/datum/vc_settings_ui_chungus/proc/open_admin_tool(mob/user)
	if(!user || !is_admin(user))
		return
	ui_interact(user, null)

/datum/vc_settings_ui_chungus/ui_state(mob/user)
	return GLOB.always_state

/datum/vc_settings_ui_chungus/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VisualChatSetupWizard")
		ui.open()

/datum/vc_settings_ui_chungus/ui_static_data(mob/user)
	return SSvisualchat.GetStaticDataForSettingsUI(user)

/datum/vc_settings_ui_chungus/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	return SSvisualchat.PerformActForSettingsUI(action, params, ui, state)

