/// binary chat
/mob/living/proc/robot_talk(message, list/spans = list(), list/message_data = list())
	log_sayverb_talk(message, message_data, tag="binary")
	message_data[SATA_MESSAGE_SPOKEN] = message
	message_data[SATA_MESSAGE_HEARD] = message
	message_data[SATA_VC_SOURCE] = message_data[SATA_VC_SOURCE] || src
	message_data[SATA_SPEAKER] = message_data[SATA_SPEAKER] || src
	message_data[SATA_VERB] = say_mod(message, message_data)

	var/designation = "Default Cyborg"
	spans |= SPAN_ROBOT

	if(issilicon(src))
		var/mob/living/silicon/player = src
		designation = trim_left(player.designation + " " + player.job)

	if(HAS_TRAIT(mind, TRAIT_DISPLAY_JOB_IN_BINARY))
		designation = mind.assigned_role.title

	if(HAS_TRAIT(src, TRAIT_LOUD_BINARY))
		// AIs are loud and ugly
		spans |= SPAN_COMMAND

	var/messagepart = generate_messagepart(
		message,
		spans,
		message_data,
	)

	var/namepart = name
	// If carbon, use voice to account for voice changers
	if(iscarbon(src))
		namepart = get_voice(add_id_name = TRUE)

	// AI in carbon body should still have its real name
	var/obj/item/organ/brain/cybernetic/ai/brain = get_organ_slot(ORGAN_SLOT_BRAIN)
	if(istype(brain))
		namepart = brain.mainframe.name
		designation = brain.mainframe.job

	for(var/mob/hearing_mob in GLOB.player_list)
		var/list/herdlist = message_data.Copy()
		if(hearing_mob.binarycheck())
			var/message_thing = ""
			if(isAI(hearing_mob))
				message_thing = span_binarysay("\
						Robotic Talk, \
						<a href='byond://?src=[REF(hearing_mob)];track=[html_encode(namepart)]'>[span_name("[namepart] ([designation])")]</a> \
						<span class='message'>[messagepart]</span>\
					")
				herdlist[SATA_MESSAGE_COMPILED] = message_thing
				to_chat(
					hearing_mob,
					message_thing,
					type = MESSAGE_TYPE_RADIO,
					avoid_highlighting = (src == hearing_mob),
					extra_data = herdlist,
				)
			else
				message_thing = span_binarysay("\
						Robotic Talk, \
						[span_name("[namepart]")] <span class='message'>[messagepart]</span>\
					")
				herdlist[SATA_MESSAGE_COMPILED] = message_thing
				to_chat(
					hearing_mob,
					message_thing,
					type = MESSAGE_TYPE_RADIO,
					avoid_highlighting = (src == hearing_mob),
					extra_data = herdlist,
				)

		if(isobserver(hearing_mob))
			var/following = src

			// If the AI talks on binary chat, we still want to follow
			// its camera eye, like if it talked on the radio

			if(isAI(src))
				var/mob/living/silicon/ai/ai = src
				following = ai.eyeobj

			var/follow_link = FOLLOW_LINK(hearing_mob, following)
			var/message_cool = span_binarysay("\
					[follow_link] \
					Robotic Talk, \
					[span_name("[namepart]")] <span class='message'>[messagepart]</span>\
				")
			herdlist[SATA_MESSAGE_COMPILED] = message_cool
			to_chat(
				hearing_mob,
				message_cool,
				type = MESSAGE_TYPE_RADIO,
				avoid_highlighting = (src == hearing_mob),
				extra_data = herdlist,
			)

/mob/living/silicon/binarycheck()
	var/area/our_area = get_area(src)
	if(our_area.area_flags & BINARY_JAMMING)
		return FALSE
	return TRUE

/mob/living/silicon/radio(message, list/message_data = list(), list/spans, language)
	. = ..()
	if(.)
		return
	if(message_data[MODE_HEADSET])
		if(radio)
			radio.talk_into(src, message, , spans, language, message_data)
		return NOPASS
	else if(message_data[SATA_RADIO_EXTENSION] in GLOB.default_radio_channels)
		if(radio)
			radio.talk_into(src, message, message_data[SATA_RADIO_EXTENSION], spans, language, message_data)
			return NOPASS

	return FALSE
