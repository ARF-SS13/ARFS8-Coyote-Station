/datum/saymode
	/// The symbol key used to enable this say mode.
	var/key
	/// The corresponding say mode string.
	var/mode
	/// Whether this say mode works with custom say emotes.
	var/allows_custom_say_emotes = FALSE

/// Checks whether this saymode can be used by the given user. May send feedback.
/datum/saymode/proc/can_be_used_by(mob/living/user)
	return TRUE

/**
 * Handles actually modifying or forwarding our message.
 * Returns `SAYMODE_[X]` flags.
 *
 * user - The living speaking using this say mode.
 * message - The message to be said.
 * spans - A list of spans to attach to the message.
 * language - The language the message was said in.
 * message_data - A list of message modifiers, i.e. whispering/singing.
 */
/datum/saymode/proc/handle_message(
	mob/living/user,
	message,
	list/spans = list(),
	datum/language/language,
	list/message_data = list()
)
	return NONE


/datum/saymode/changeling
	key = MODE_KEY_CHANGELING
	mode = MODE_CHANGELING

/datum/saymode/changeling/can_be_used_by(mob/living/user)
	if(!user.mind)
		return FALSE
	if(user.mind.has_antag_datum(/datum/antagonist/fallen_changeling))
		to_chat(user, span_changeling("<b>We're cut off from the hivemind! We've lost everything! EVERYTHING!!</b>"))
		return FALSE
	var/datum/antagonist/changeling/ling_sender = IS_CHANGELING(user)
	if(!ling_sender)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_CHANGELING_HIVEMIND_MUTE))
		to_chat(user, span_warning("The poison in the air hinders our ability to interact with the hivemind."))
		return FALSE
	return TRUE

/datum/saymode/changeling/handle_message/handle_message(
	mob/living/user,
	message,
	list/spans = list(),
	datum/language/language,
	list/message_data = list()
)
	var/datum/antagonist/changeling/ling_sender = IS_CHANGELING(user)
	user.log_talk(message, LOG_SAY, tag = "changeling [ling_sender.changelingID]")
	var/msg = span_changeling("<b>[ling_sender.changelingID]:</b> [message]")
	message_data[SATA_MESSAGE_SPOKEN] = message
	message_data[SATA_MESSAGE_HEARD] = message
	message_data[SATA_SPANS] = spans
	message_data[SATA_DISPLAYED_NAME] = ling_sender.changelingID
	message_data[SATA_ORIGIN] = ling_sender.owner.current
	message_data[SATA_SPEAKER] = ling_sender.owner.current
	user.say_mod(message, message_data)
	message_data[SATA_DISPLAYED_SAYMODE] = "projects over the hivemind..."

	// Send the message to our other changelings.
	for(var/datum/antagonist/changeling/ling_receiver in GLOB.antagonists)
		if(!ling_receiver.owner)
			continue
		var/mob/living/ling_mob = ling_receiver.owner.current
		//removes types that override the presence of being changeling (for example, borged lings still can't hivemind chat)
		if(!isliving(ling_mob) || issilicon(ling_mob) || isbrain(ling_mob))
			continue
		// can't receive messages on the hivemind right now
		if(HAS_TRAIT(ling_mob, TRAIT_CHANGELING_HIVEMIND_MUTE))
			continue
		var/list/recipient_data = message_data.Copy()
		recipient_data[SATA_LISTENER] = ling_mob
		to_chat(ling_mob, msg, type = MESSAGE_TYPE_RADIO, avoid_highlighting = ling_mob == user, extra_data = message_data)

	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		var/linkie = FOLLOW_LINK(ghost, user)
		var/list/ghost_message_data = message_data.Copy()
		ghost_message_data[SATA_HEARER_IS_GHOST] = TRUE
		ghost_message_data[SATA_LINK] = linkie
		to_chat(ghost, "[linkie] [msg]", type = MESSAGE_TYPE_RADIO, extra_data = ghost_message_data)
	return SAYMODE_MESSAGE_HANDLED

/datum/saymode/xeno
	key = MODE_KEY_ALIEN
	mode = MODE_ALIEN
	allows_custom_say_emotes = TRUE

/datum/saymode/xeno/can_be_used_by(mob/living/user)
	if(!user.hivecheck())
		return FALSE
	return TRUE

/datum/saymode/xeno/handle_message/handle_message(
	mob/living/user,
	message,
	list/spans = list(),
	datum/language/language,
	list/message_data = list()
)
	user.alien_talk(message, spans, message_data)
	return SAYMODE_MESSAGE_HANDLED


/datum/saymode/vocalcords
	key = MODE_KEY_VOCALCORDS
	mode = MODE_VOCALCORDS

/datum/saymode/vocalcords/can_be_used_by(mob/living/user)
	if(!iscarbon(user))
		return FALSE
	return TRUE

/datum/saymode/vocalcords/handle_message/handle_message(
	mob/living/user,
	message,
	list/spans = list(),
	datum/language/language,
	list/message_data = list()
)
	var/mob/living/carbon/carbon_user = user
	var/obj/item/organ/vocal_cords/our_vocal_cords = carbon_user.get_organ_slot(ORGAN_SLOT_VOICE)
	if(our_vocal_cords?.can_speak_with())
		our_vocal_cords.handle_speech(message) //message
		our_vocal_cords.speak_with(message) //action
	return SAYMODE_MESSAGE_HANDLED


/datum/saymode/binary //everything that uses .b (silicons, drones)
	key = MODE_KEY_BINARY
	mode = MODE_BINARY
	allows_custom_say_emotes = TRUE

/datum/saymode/binary/can_be_used_by(mob/living/user)
	if(!isdrone(user) && !user.binarycheck())
		return FALSE
	return TRUE

/datum/saymode/binary/handle_message/handle_message(
	mob/living/user,
	message,
	list/spans = list(),
	datum/language/language,
	list/message_data = list()
)
	if(isdrone(user))
		var/mob/living/basic/drone/drone_user = user
		drone_user.drone_chat(message, spans, message_data)
	else if(user.binarycheck())
		user.robot_talk(message, spans, message_data)
	return SAYMODE_MESSAGE_HANDLED


/datum/saymode/holopad
	key = MODE_KEY_HOLOPAD
	mode = MODE_HOLOPAD
	allows_custom_say_emotes = TRUE

/datum/saymode/holopad/can_be_used_by(mob/living/user)
	if(!isAI(user))
		return FALSE
	return TRUE

/datum/saymode/holopad/handle_message/handle_message(
	mob/living/user,
	message,
	list/spans = list(),
	datum/language/language,
	list/message_data = list()
)
	var/mob/living/silicon/ai/ai_user = user
	ai_user.holopad_talk(message, spans, language, message_data)
	return SAYMODE_MESSAGE_HANDLED
