/mob/living/proc/alien_talk(message, list/spans = list(), list/message_data = list(), shown_name = real_name, big_voice = FALSE)
	log_sayverb_talk(message, message_data, tag = "alien hivemind")
	message = trim(message)
	if(!message)
		return
	message_data[SATA_ORIGIN] = src
	message_data[SATA_SPEAKER] = src
	message_data[SATA_MESSAGE_SPOKEN] = message
	message_data[SATA_MESSAGE_HEARD] = message

	var/message_a = generate_messagepart(message, spans, message_data)
	var/hivemind_spans = "alien"
	message_data[SATA_SPANS] = list(hivemind_spans)
	if(big_voice)
		hivemind_spans += " big"
		message_data[SATA_SPANS] += "big"
	var/rendered = "<i><span class='[hivemind_spans]'>Hivemind, [span_name("[shown_name]")] <span class='message'>[message_a]</span></span></i>"
	for(var/mob/player in GLOB.player_list)
		var/list/player_message_data = message_data.Copy()
		player_message_data[SATA_LISTENER] = player
		if(!player.stat && player.hivecheck())
			to_chat(player, rendered, type = MESSAGE_TYPE_RADIO, avoid_highlighting = player == src, extra_data = player_message_data)
		else if(player in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(player, src)
			player_message_data[SATA_HEARER_IS_GHOST] = TRUE
			player_message_data[SATA_LINK] = link
			to_chat(player, "[link] [rendered]", type = MESSAGE_TYPE_RADIO, extra_data = player_message_data)

/mob/living/carbon/alien/adult/royal/queen/alien_talk(message, list/spans = list(), list/message_data = list(), shown_name = name, big_voice = TRUE)
	..(message, spans, message_data, shown_name, TRUE)

/mob/living/carbon/hivecheck()
	var/obj/item/organ/alien/hivenode/N = get_organ_by_type(/obj/item/organ/alien/hivenode)
	if(N && !N.recent_queen_death) //Mob has alien hive node and is not under the dead queen special effect.
		return TRUE
