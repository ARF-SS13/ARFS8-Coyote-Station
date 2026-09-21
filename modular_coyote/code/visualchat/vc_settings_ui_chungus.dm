/// hi im a holder for the settings ui
/datum/vc_settings_ui_chungus

/datum/vc_settings_ui_chungus/proc/open_settings_controlpanel(mob/user)
	ui_interact(user, null)

/datum/vc_settings_ui_chungus/ui_state(mob/user)
	return GLOB.always_state

/datum/vc_settings_ui_chungus/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VisualChatSetupWizard")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/vc_settings_ui_chungus/ui_static_data(mob/user)
	return SSvisualchat.GetStaticDataForSettingsUI(user)

/datum/vc_settings_ui_chungus/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	return SSvisualchat.PerformActForSettingsUI(action, params, ui, state)

ADMIN_VERB(admin_open_visualchat_ui, R_ADMIN, "VisualChat settings UI", "VisualChat settings UI.", ADMIN_CATEGORY_MAIN)
	SSvisualchat.OpenSettingsControlPanel(extract_mob(user)) // user is a client i guess?
	to_chat(user, span_notice("Opened the VisualChat settings UI for you!"))


