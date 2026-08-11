




////// old code in case the above doesnt work
// /obj/item/hand_item/butt/proc/buttify(mob/user)
// 	if(!iscarbon(user))
// 		return
// 	var/mob/living/carbon/human/H = user
// 	if(!H.has_butt())
// 		return
// 	icon = "icons/effects/effects.dmi"
// 	icon = "nothing"
// 	var/obj/item/organ/genital/butt/B = H.getorganslot(ORGAN_SLOT_BUTT)
// 	var/datum/sprite_accessory/sprite_acc = B.get_sprite_accessory()
// 	icon = 'icons/obj/genitals/butt_onmob.dmi'
// 	icon_state = B.get_icon_state(user, sprite_acc, FALSE, "FRONT")
// 	dir = NORTH
// 	var/datum/preferences/P = extract_prefs(user)
// 	color = "#[P.features["butt_color"]]"
// 	force = 6 * B.size
// 	attack_speed = (CLICK_CD_MELEE / 3) * B.size
// 	switch(B.size)
// 		if(1 to 2)
// 			w_class = WEIGHT_CLASS_TINY
// 		if(3)
// 			w_class = WEIGHT_CLASS_SMALL
// 		if(4)
// 			w_class = WEIGHT_CLASS_NORMAL
// 		if(5)
// 			w_class = WEIGHT_CLASS_BULKY
// 		if(6 to 7)
// 			w_class = WEIGHT_CLASS_HUGE
// 		if(8 to INFINITY)
// 			w_class = WEIGHT_CLASS_GIGANTIC

/// / / / / / / / / / / / / / / / / / / / / / / / / / ///
/// And a bunch of stuff we probably dont use anymore ///


// /obj/item/hand_item/cantrip
// 	name = "Cantrip"
// 	desc = "it's magic yo."
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "clawer"
// 	w_class = WEIGHT_CLASS_TINY
// 	attack_verb_simple = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
// 	force = 15
// 	backstab_multiplier = 1.8
// 	throwforce = 0
// 	wound_bonus = 4
// 	attack_speed = CLICK_CD_MELEE * 0.7
// 	item_flags = DROPDEL | HAND_ITEM
// 	weapon_special_component = /datum/component/weapon_special/single_turf


// /obj/item/hand_item/cantrip/godhand
// 	icon_state = "disintegrate"
// 	inhand_icon_state = "disintegrate"
// 	icon = 'icons/obj/items_and_weapons.dmi'
// 	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
// 	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
// 	name = "Shocking Grasp"
// 	desc = "A basic cantrip that allows the caster to inflict nasty shocks on touch"
// 	item_flags = ABSTRACT | DROPDEL
// 	force = 30
// 	backstab_multiplier = 1.6
// 	hitsound = 'sound/weapons/sear.ogg'
// 	damtype = BURN
// 	attack_verb_simple = list("seared", "zapped", "fried", "shocked")


// /obj/item/hand_item/merp_doer
// 	name = "MERP doer"
// 	desc = "Click someone with this thing to open the MERP interactions menu! From there, you can do all sorts of lewd or not-so-lewd things with them (or yourself!!)!"
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "blushfox"

// /obj/item/hand_item/merp_doer/attack(mob/living/M, mob/living/user)
// 	SEND_SIGNAL(user, COMSIG_CLICK_CTRL_SHIFT, M)
// 	qdel(src)

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// /obj/item/hand_item/subtle_catapult
// 	name = "discrete action delivery system"
// 	desc = "Do lewd things in public, without anyone (but whoever you're doing it to) knowing!"
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "blushfox"
// 	item_flags = ABSTRACT | HAND_ITEM | NO_TURN
// 	max_reach = 70
// 	var/message
// 	var/aoe_range = 1

// /obj/item/hand_item/subtle_catapult/examine(mob/user)
// 	. = ..()
// 	// . += span_green("AOE range: Your tile, plus [aoe_range] tiles in every direction.")
// 	. += span_green("Current message:")
// 	. += span_notice(message ? message : "None.")
// 	. += span_green("--")
// 	. += span_green("HOW 2 USE:")
// 	. += span_notice("1. Click it in hand to start writing a message.")
// 	. += span_notice("2. Click this on someone to send that message to them.")
// 	. += span_notice("3. Or CtrlShift click it to pick anyone in view")
// 	. += span_notice("You can also alt-click it to view your previous messages, and even select them to send!")
// 	. += span_notice("It will ask you to confirm before sending, so don't worry about accidentally sending something you didn't mean to!")
// 	. += span_notice("Also dont worry about dropping it or anything, it should still take whatever you wrote with it!")
// 	. += span_green("--")

// /obj/item/hand_item/subtle_catapult/pre_attack(atom/A, mob/living/user, params, attackchain_flags, damage_multiplier)
// 	. = TRUE
// 	if(!extract_client(A))
// 		return
// 	if(message)
// 		StartSendMessage(user, A)
// 	else
// 		EditMessage(user, A)

// /obj/item/hand_item/subtle_catapult/attack_self(mob/user)
// 	. = ..()
// 	EditMessage(user)

// /obj/item/hand_item/subtle_catapult/AltClick(mob/user)
// 	. = ..()
// 	var/list/messages = SSchat.GetHornyHistory(user)
// 	if(!LAZYLEN(messages))
// 		to_chat(user, span_alert("You haven't made any messages yet!"))
// 		return
// 	var/selected = input(
// 		user,
// 		"Here's a list of the messages you've made with this! Pick one to load it into this tool!",
// 		"Select a message to send!",
// 		message,
// 	) as null|anything in messages
// 	if(selected)
// 		message = selected
// 		to_chat(user, span_green("Message loaded!"))
// 	else
// 		to_chat(user, span_alert("Message selection cancelled!"))

// /obj/item/hand_item/subtle_catapult/CtrlShiftClick(mob/user)
// 	. = ..()
// 	var/list/ppl = hearers(10, user)
// 	for(var/mob/M in ppl)
// 		if(!extract_client(M))
// 			ppl -= M
// 		if(!isliving(M))
// 			ppl -= M
// 		if(M == user)
// 			ppl -= M
// 	var/mob/whomst = input(
// 		user,
// 		"Who would you like to send a message to?",
// 		"Select a target!",
// 		null
// 	) as null|anything in ppl
// 	if(whomst)
// 		if(message)
// 			StartSendMessage(user, whomst)
// 		else
// 			EditMessage(user, whomst)
// 	else
// 		to_chat(user, span_alert("Message selection cancelled!"))

// /obj/item/hand_item/subtle_catapult/dropped(mob/user)
// 	. = ..()
// 	SSchat.StashHornyThing(user)

// /obj/item/hand_item/subtle_catapult/proc/EditMessage(mob/user, mob/living/M, and_send)
// 	var/head = M ? "Prepare a message for [M]!" : "Prepare a message!"
// 	var/msg = stripped_multiline_input_or_reflect(user, EMOTE_HEADER_TEXT, head, message, 99999)
// 	if(msg)
// 		to_chat(user, span_green("Message prepared:"))
// 		to_chat(user, span_notice(msg))
// 		to_chat(user, span_green("Click [M] to send it!"))
// 		message = msg
// 		SSchat.StoreHornyMessage(user, msg)
// 		if(M)
// 			StartSendMessage(user, M)
// 	else
// 		to_chat(user, span_alert("Message cancelled! Nothing's changed!!"))

// /obj/item/hand_item/subtle_catapult/proc/StartSendMessage(mob/user, mob/living/M)
// 	if(!message)
// 		return
// 	if(!M || !user)
// 		return
// 	// if(M == user || !M.client)
// 	// 	return
// 	var/shomsg = message
// 	if(LAZYLEN(shomsg) > 700)
// 		shomsg = copytext(shomsg, 0, 700) + "..."
// 	// first we ask em, you sure you wanna do this?
// 	var/confirm = alert(user, "You are about to send this message to [M]:\n\n[message]\n\nAre you sure you want to do this?", "Send message?", "Yes", "No")
// 	if(confirm != "Yes")
// 		to_chat(user, span_alert("Okay nevermind!!"))
// 		return
// 	DeliverMessage(user, M)

// /obj/item/hand_item/subtle_catapult/proc/DeliverMessage(mob/user, mob/living/M)
// 	var/original_message = message
// 	var/to_send = message

// 	user.log_message(to_send, LOG_SUBTLE)
// 	var/msg_check = user.say_narrate_replace(to_send, user)
// 	if(msg_check)
// 		to_send = span_subtle("<i>[msg_check]</i>")
// 	else
// 		to_send = span_subtle("<b>[user]</b> " + "<i>[user.say_emphasis(to_send)]</i>")

// 	var/datum/emote/E
// 	E = E.emote_list["subtle"]

// 	var/datum/rental_mommy/chat/mommy = E.BuildMommy(user, to_send)
// 	mommy.original_message = original_message
// 	mommy.exclusive_targets = list(M, user)

// 	// Visible to_send, as in only visible to you and them
// 	user.visible_message(
// 		message = to_send,
// 		data = list("mom" = mommy))

// 	//broadcast to ghosts, if they have a client, are dead, arent in the lobby, allow ghostsight, and, if subtler, are admemes
// 	user.emote_for_ghost_sight(mommy.message, TRUE, 0)
// 	mommy.checkin()
// 	user.playsound_local(get_turf(user), 'sound/f13effects/sunsetsounds/blush.ogg', 80, FALSE)
// 	M.playsound_local(get_turf(M), 'sound/f13effects/sunsetsounds/blush.ogg', 80, FALSE)

///////////////////////////////////////////////////
//// FLIRT ITEM ///////////////////////////////////
// /obj/item/hand_item/flirter
// 	name = "Flirtation Device" // in the event of a crash, your hand can be used as a flirtation device
// 	desc = "This thing is used to flirt with people! Or it would if it initialized properly. Oops."
// 	icon = 'icons/mob/actions.dmi'
// 	icon_state = "velvet_chords"
// 	max_reach = 30 // love knows no bounds
// 	var/flirtkey = "hi"

// /obj/item/hand_item/flirter/proc/flirtify(datum/flirt/F) // Fs in chat
// 	if(!istype(F))
// 		qdel(src) // dies of illiteracy
// 		return
// 	flirtkey = F.key
// 	name = F.flirtname
// 	desc = F.flirtdesc
// 	icon = F.flirticon
// 	icon_state = F.flirticon_state
// 	return TRUE

// /obj/item/hand_item/flirter/pre_attack(atom/A, mob/living/user, params, attackchain_flags, damage_multiplier)
// 	. = STOP_ATTACK_PROC_CHAIN // never let this thing hit anyone ever for any ever anytime
// 	if(!isliving(A))
// 		return
// 	if(!SSchat.run_directed_flirt(user, A, flirtkey))
// 		return
// 	qdel(src)

// /obj/item/hand_item/flirter/attack_self(mob/user)
// 	. = STOP_ATTACK_PROC_CHAIN // never let this thing hit anyone ever for any ever anytime
// 	if(!isliving(user))
// 		return
// 	if(!SSchat.run_aoe_flirt(user, flirtkey))
// 		return
// 	qdel(src)

////////////////////////////////////////////////////////
//// FLIRT TARGETTER ///////////////////////////////////
// /obj/item/hand_item/flirt_targetter
// 	name = "Flirtation Targetter" // in the event of a crash, your hand can be used as a flirtation device
// 	desc = "Click someone with this, and the next Flirt button you press will be directed at them! There's no range restriction, so, yeah!"
// 	icon = 'icons/mob/actions.dmi'
// 	icon_state = "velvet_chords"
// 	max_reach = 30 // love knows no bounds

// /obj/item/hand_item/flirt_targetter/pre_attack(atom/A, mob/living/user, params, attackchain_flags, damage_multiplier)
// 	. = STOP_ATTACK_PROC_CHAIN // never let this thing hit anyone ever for any ever anytime
// 	if(!isliving(A))
// 		return
// 	if(!SSchat.add_flirt_target(user, A))
// 		return
// 	to_chat(user, span_notice("You'll now send a flirt to [A] when you press the next Flirt button. Happy flirting!"))
// 	qdel(src)

