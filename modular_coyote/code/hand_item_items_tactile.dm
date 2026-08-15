/// / / / / ///
/// LICKER  ///
/// Course our first hand item would be a tongue
/obj/item/hand_item/tactile/licker
	name = "tongue"
	desc = "Mlem."
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "tongue"
	attack_verb_simple = list("licked", "lapped", "mlemmed")
	hitsound = 'modular_coyote/sounds/lick.ogg'
	siemens_coefficient = 5 // hewwo mistow ewectwic fence mlem mlem
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "lick"
	action_verb = "lick"
	action_verb_s = "licks"
	action_verb_ing = "licking"
	can_taste = TRUE
	just_one = TRUE
	// grope = /datum/grope_kiss_MERP/lick
	hud_use = TRUE
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "lick"

/obj/item/hand_item/tactile/licker/on_failed_give_message(mob/user, reason)
	if(reason == HI_HANDS_FULL)
		to_chat(user, span_alert("Your hands are too full to lick anything!"))
		return TRUE
	. = ..()

// ////////////////////////
// /obj/item/hand_item/tactile/triage //chimken
// 	name = "triage kit"
// 	desc = "A small collection of vital medical supplies."
// 	icon = 'icons/fallout/objects/medicine/drugs.dmi'
// 	icon_state = "traumapack"
// 	attack_verb_simple = list("tended", "treated", "healed")
// 	hitsound = 'sound/items/tendingwounds.ogg'
// 	hud_icon = 'modular_coyote/icons/hand_items.dmi'
// 	hud_icon_state = "tend"
// 	needed_trait_to_heal = TRAIT_HEAL_TEND
// 	required_trait = TRAIT_HEAL_TEND
// 	tend_word = "tending"
// 	action_verb = "tend"
// 	action_verb_s = "tends"
// 	action_verb_ing = "tending"
// 	can_taste = FALSE
// 	hud_use = FALSE
// 	disabled = TRUE

// /obj/item/hand_item/tactile/triage/on_failed_give_message(mob/user, reason)
// 	if(reason == HI_HANDS_FULL)
// 		to_chat(user, span_alert("Your hands are too full to tend anything!"))
// 		return TRUE
// 	. = ..()

// ////////////////////////
// /obj/item/hand_item/tactile/toucher //being repurposed as a way to 'feel' the world around the player.  Specifically other players though, lets be real.
// 	name = "touch"
// 	desc = "A finger, for touching things."
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "feeder"
// 	attack_verb_simple = list("touched", "poked", "prodded")
// 	hitsound = 'sound/items/tendingwounds.ogg'
// 	hud_icon = 'modular_coyote/icons/hand_items.dmi'
// 	hud_icon_state = "touch"
// 	needed_trait_to_heal = TRAIT_HEAL_TOUCH
// 	tend_word = "touching"
// 	action_verb = "touch"
// 	action_verb_s = "touches"
// 	action_verb_ing = "touching"
// 	// grope = /datum/grope_kiss_MERP
// 	can_taste = FALSE
// 	hud_use = TRUE

// /obj/item/hand_item/tactile/toucher/on_failed_give_message(mob/user, reason)
// 	if(reason == HI_HANDS_FULL)
// 		to_chat(user, span_alert("Your hands are too full to touch anything!"))
// 		return TRUE
// 	. = ..()

// ////////////////////////
// /obj/item/hand_item/kisser
// 	name = "kisser"
// 	desc = "A kisser, for smooching things."
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "kisser"
// 	attack_verb_simple = list("kissed", "smooched", "snogged")
// 	tap_uses_hitsound = TRUE
// 	hitsound_list = list(
// 		'sound/effects/kiss.ogg',
// 		'modular_splurt/sound/interactions/kiss/kiss1.ogg',
// 		'modular_splurt/sound/interactions/kiss/kiss2.ogg',
// 		'modular_splurt/sound/interactions/kiss/kiss3.ogg',
// 		'modular_splurt/sound/interactions/kiss/kiss4.ogg',
// 	)
// 	hud_icon = 'modular_coyote/icons/hand_items.dmi'
// 	hud_icon_state = "kiss"
// 	needed_trait_to_heal = TRAIT_HEAL_TOUCH
// 	tend_word = "smooching"
// 	action_verb = "kiss"
// 	action_verb_s = "kisses"
// 	action_verb_ing = "kissing"
// 	can_taste = FALSE
// 	// grope = /datum/grope_kiss_MERP/kiss
// 	hud_use = TRUE
// 	can_taste = TRUE // a good kiss is one you can *taste*

// /obj/item/hand_item/kisser/on_failed_give_message(mob/user, reason)
// 	if(reason == HI_HANDS_FULL)
// 		to_chat(user, span_alert("Your hands are too full to kiss anything!"))
// 		return TRUE
// 	. = ..()
