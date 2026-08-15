/proc/get_ultimate_type(datum/thingy)
	var/list/pathchunks = splittext("[thingy.type]", "/")
	return pathchunks[LAZYLEN(pathchunks)]

/datum/emote/living/carbon/hand_item
	hands_use_check = TRUE
	abstract_type = /datum/emote/living/carbon/hand_item
	var/obj/item/hand_item/hand_item_path

/datum/emote/living/carbon/hand_item/New()
	if(!key)
		key = "[get_ultimate_type(src)]"
	. = ..()

/datum/emote/living/carbon/hand_item/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	SShanditems.give_hand_item(user, hand_item_path)

/// the them ones

/datum/emote/living/carbon/hand_item/circle/hand_item_path     = /obj/item/hand_item/circlegame
/datum/emote/living/carbon/hand_item/noogie/hand_item_path     = /obj/item/hand_item/noogie
/datum/emote/living/carbon/hand_item/slap/hand_item_path       = /obj/item/hand_item/slapper
/datum/emote/living/carbon/hand_item/hand/hand_item_path       = /obj/item/hand_item/hand
/datum/emote/living/carbon/hand_item/shoesteal/hand_item_path  = /obj/item/hand_item/stealer
/datum/emote/living/carbon/hand_item/kiss/hand_item_path       = /obj/item/hand_item/kisser
/datum/emote/living/carbon/hand_item/cuphand/hand_item_path    = /obj/item/hand_item/spawner/cuphand
/datum/emote/living/carbon/hand_item/lick/hand_item_path       = /obj/item/hand_item/tactile/licker
/datum/emote/living/carbon/hand_item/bite/hand_item_path       = /obj/item/hand_item/weapon/biter
/datum/emote/living/carbon/hand_item/claw/hand_item_path       = /obj/item/hand_item/weapon/clawer
/datum/emote/living/carbon/hand_item/tail/hand_item_path       = /obj/item/hand_item/weapon/tail
/datum/emote/living/carbon/hand_item/butt/hand_item_path       = /obj/item/hand_item/weapon/butt
/datum/emote/living/carbon/hand_item/beans/hand_item_path      = /obj/item/hand_item/weapon/beans
/datum/emote/living/carbon/hand_item/bonk/hand_item_path       = /obj/item/hand_item/bonkinghand







// /datum/emote/living/carbon/bonk
// 	key = "bonk"
// 	key_third_person = "bonks"
// 	hands_use_check = TRUE

// /datum/emote/living/carbon/bonk/run_emote(mob/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/bonkinghand)

// /datum/emote/living/carbon/circle
// 	key = "circle"
// 	key_third_person = "circles"
// 	hands_use_check = TRUE

// /datum/emote/living/carbon/circle/run_emote(mob/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/circlegame)

// /datum/emote/living/carbon/noogie
// 	key = "noogie"
// 	key_third_person = "noogies"
// 	hands_use_check = TRUE

// /datum/emote/living/carbon/noogie/run_emote(mob/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/noogie)

// /datum/emote/living/carbon/slap
// 	key = "slap"
// 	key_third_person = "slaps"
// 	hands_use_check = TRUE
// 	cooldown = 3 SECONDS // to prevent endless table slamming

// /datum/emote/living/carbon/slap/run_emote(mob/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/slapper)

// /datum/emote/living/carbon/hand
// 	key = "hand"
// 	key_third_person = "hands"
// 	hands_use_check = TRUE


// /datum/emote/living/carbon/hand/run_emote(mob/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/hand)

// /datum/emote/living/carbon/shoesteal
// 	key = "shoesteal"
// 	key_third_person = "shoesteals"
// 	hands_use_check = TRUE
// 	cooldown = 3 SECONDS

// /datum/emote/living/carbon/shoesteal/run_emote(mob/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/stealer)
// /datum/emote/living/kiss
// 	key = "kiss"
// 	key_third_person = "kisses"
// 	cooldown = 3 SECONDS

// /datum/emote/living/kiss/run_emote(mob/living/user, params, type_override, intentional)
// 	. = ..()
// 	SShanditems.give_hand_item(user, /obj/item/hand_item/kisser)
	// var/kiss_type = /obj/item/hand_item/kisser

	// if(HAS_TRAIT(user, TRAIT_GARLIC_BREATH))
	// 	kiss_type = /obj/item/hand_item/kisser/french

	// if(HAS_TRAIT(user, TRAIT_CHEF_KISS))
	// 	kiss_type = /obj/item/hand_item/kisser/chef

	// if(HAS_TRAIT(user, TRAIT_SYNDIE_KISS))
	// 	kiss_type = /obj/item/hand_item/kisser/syndie

	// if(HAS_TRAIT(user, TRAIT_KISS_OF_DEATH))
	// 	kiss_type = /obj/item/hand_item/kisser/death

	// var/datum/action/cooldown/ink_spit/ink_action = locate() in user.actions
	// if(ink_action?.IsAvailable())
	// 	kiss_type = /obj/item/hand_item/kisser/ink
	// else
	// 	ink_action = null

	// var/obj/item/kiss_blower = new kiss_type(user)
	// if(user.put_in_hands(kiss_blower))
	// 	to_chat(user, span_notice("You ready your kiss-blowing hand."))
	// 	ink_action?.StartCooldown()
	// 	return

	// qdel(kiss_blower)
	// to_chat(user, span_warning("You're incapable of blowing a kiss in your current state."))
