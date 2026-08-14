/// / / / / ///
/// BITERS  ///
// todo: make biting metal things hurt a lot
/obj/item/hand_item/weapon/biter
	name = "Biter"
	desc = "Talk shit, get bit."
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "bite_item"
	attack_verb_simple = list("chomped", "gnawed", "bit", "crunched", "nommed")
	hitsound = "sound/weapons/bite.ogg"
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "bite"
	just_one = TRUE
	force = 4
	// required_trait = TRAIT_BITE
	subitem_master_path = /obj/item/hand_item/weapon/biter
	subitem_paths = list(
		HI_SUB_DEFAULT = /obj/item/hand_item/weapon/biter/play,
		// HI_SUB_DEFAULT = /obj/item/hand_item/weapon/biter/bite,
		// TRAIT_BIGBITE = /obj/item/hand_item/weapon/biter/big,
		// TRAIT_SABREBITE = /obj/item/hand_item/weapon/biter/sabre,
		// TRAIT_FASTBITE = /obj/item/hand_item/weapon/biter/fast,
		// TRAIT_PLAYBITE = /obj/item/hand_item/weapon/biter/play,
		// TRAIT_SPICYBITE = /obj/item/hand_item/weapon/biter/spicy
	)

/obj/item/hand_item/weapon/biter/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You bare your fangs, ready to chomp through anything in your path!"))

/obj/item/hand_item/weapon/biter/bite

/// PLAY BITER
/obj/item/hand_item/weapon/biter/play
	name = "Play Biter"
	desc = "Someone really should just muzzle you."
	color = "#ff44ff"
	force = 0
	// force_wielded = 0
	// force_unwielded = 0
	attack_speed = 1
	wound_bonus = -999
	exposed_wound_bonus = -999

/obj/item/hand_item/weapon/biter/play/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You bare your teeth with such ferocity! Such a mighty killer!"))

/// / / / ///
/// CLAWS ///
/obj/item/hand_item/weapon/clawer
	name = "Clawer"
	desc = "Thems some claws."
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "claw_item"
	w_class = WEIGHT_CLASS_TINY
	sharpness = SHARP_EDGED
	attack_verb_simple = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	force = 4
	// force_wielded = 40
	// force_unwielded = 30
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "claw"
	// required_trait = TRAIT_CLAW
	subitem_master_path = /obj/item/hand_item/weapon/clawer
	subitem_paths = list(
		HI_SUB_DEFAULT = /obj/item/hand_item/weapon/clawer/play,
		// HI_SUB_DEFAULT = /obj/item/hand_item/weapon/clawer/claws,
		// TRAIT_BIGCLAW = /obj/item/hand_item/weapon/clawer/big,
		// TRAIT_RAZORCLAW = /obj/item/hand_item/weapon/clawer/razor,
		// TRAIT_FASTCLAW = /obj/item/hand_item/weapon/clawer/fast,
		// TRAIT_PLAYCLAW = /obj/item/hand_item/weapon/clawer/play,
		// TRAIT_SPICYCLAW = /obj/item/hand_item/weapon/clawer/spicy,
	)

/obj/item/hand_item/weapon/clawer/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your claws, ready to rip and tear at anything that gets in your way!"))

/obj/item/hand_item/weapon/clawer/claws

/// PLAY CLAWER
/obj/item/hand_item/weapon/clawer/play
	name = "Play Clawer"
	desc = "Basically just a bean thwapper."
	color = "#FF88FF"
	force = 0
	// force_wielded = 0
	// force_unwielded = 0
	attack_speed = 1
	wound_bonus = -999
	exposed_wound_bonus = -999

/obj/item/hand_item/weapon/clawer/play/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your harmless claws, ready to play!"))

/// / / / ///
/// TAILS ///
/obj/item/hand_item/weapon/tail
	name = "tailwhack"
	desc = "A tail. Good for whacking."
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "tail_item"
	w_class = WEIGHT_CLASS_TINY
	force = 15
	can_knockback = TRUE
	spin_attack = TRUE
	use_bodypart_image_slot = ORGAN_SLOT_TAIL
	required_bodypart_slot = ORGAN_SLOT_TAIL
	just_one = TRUE
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "tail"
	subitem_master_path = /obj/item/hand_item/weapon/tail
	subitem_paths = list(
		// HI_SUB_DEFAULT = /obj/item/hand_item/weapon/tail/my_tail,
		HI_SUB_DEFAULT = /obj/item/hand_item/weapon/tail/playful,
		// TRAIT_TAILPLAY = /obj/item/hand_item/weapon/tail/playful,
		// TRAIT_TAILWHIP = /obj/item/hand_item/weapon/tail/fast,
		// TRAIT_TAILSMASH = /obj/item/hand_item/weapon/tail/big,
		// TRAIT_TAILSPICY = /obj/item/hand_item/weapon/tail/spicy,
		// TRAIT_TAILTHAGO = /obj/item/hand_item/weapon/tail/thago
	)

/obj/item/hand_item/weapon/tail/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You swish your tail, ready to smack it into something!"))

/obj/item/hand_item/weapon/tail/my_tail

/obj/item/hand_item/weapon/tail/playful
	name = "playful tail"
	desc = "A playful tail, good for teasing."
	force = 0
	// force_wielded = 0
	attack_speed = 3
	// weapon_special_component = /datum/component/weapon_special/single_turf
	// associated_trait = TRAIT_TAILPLAY // yeah im into tailplay, what of it?
	// required_trait = TRAIT_TAILPLAY

/obj/item/hand_item/weapon/tail/playful/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your soft, harmless tail, ready to give someone a cute lil whap!"))

/// / / / ///
/// BEANS ///
/obj/item/hand_item/weapon/beans
	name = "beans"
	desc = "Them's ya' beans. Touch em' to things."
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "beans_item"
	color = "#ff88bb"
	attack_verb_simple = list()
	hitsound = "sound/effects/attackblob.ogg"
	force = 0
	// force_wielded = 0
	throwforce = 0
	attack_speed = 0 // spammable, amazingly annoying
	extra_damage = 1 // its mildly annoying!
	extra_damage_type = STAMINA
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "beans"
	subitem_master_path = /obj/item/hand_item/weapon/beans
	subitem_paths = list(
		HI_SUB_DEFAULT = /obj/item/hand_item/weapon/beans,
	)

/obj/item/hand_item/weapon/beans/on_successful_give(mob/user, reason)
	to_chat(user, span_notice("You ready your beans for WAR!!"))
	return TRUE

/obj/item/hand_item/weapon/beans/war
	name = "war beans"
	desc = "Them's ya' war beans. Touch em' to things you want dead."
	color = "#ff4444"
	force = 4
	// force_wielded = 8
	admin_only = TRUE // yeah
	// required_trait = TRAIT_WARBEANS

/obj/item/hand_item/weapon/beans/on_successful_give(mob/user, reason)
	to_chat(user, span_notice("You ready your warbeans for REAL WAR!!"))
	return TRUE

/// / / / /// // unbreak in case of butt
/// BUTT  ///
/obj/item/hand_item/weapon/butt
	name = "butt"
	desc = "Very smoochable."
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "butt_item"
	attack_verb_simple = list("smecked", "bwapped", "bumped", "clapped", "quapped", "vooped", "whomped")
	w_class = WEIGHT_CLASS_GIGANTIC // your butt is HUGE!!!!
	force = 5
	// weapon_special_component = /datum/component/weapon_special/single_turf
	use_bodypart_image_slot = ORGAN_SLOT_BUTT
	spin_attack = TRUE
	just_one = TRUE
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "butt"

/obj/item/hand_item/weapon/butt/on_successful_give(mob/living/user, reason)
	var/mob/living/carbon/human/H = user
	if(!H.has_butt())
		to_chat(user, span_notice("You give your rear end a wiggle, ready to thrust that thing into someone's face!"))
		return
	var/obj/item/organ/genital/butt/B = H.get_organ_slot(ORGAN_SLOT_BUTT)
	if(!B)
		to_chat(user, span_notice("You give your rear a wiggle, ready to thrust that thing into someone's face!"))
		return
	switch(B.genital_size)
		if(1 to 2) // tiny butt
			to_chat(user, span_notice("You give your slender tushie a wiggle, ready to crack a few ribs!"))
		if(3) // small butt
			to_chat(user, span_notice("You give your modest behind a wiggle, ready to crack a few ribs!"))
		if(4) // average butt
			to_chat(user, span_notice("You give your ample backside a wiggle, ready to hip check something into the ground!"))
		if(5) // thicc butt
			to_chat(user, span_notice("You give your hefty booty a jiggle, ready to hip check something into the ground!"))
		if(6 to 7) // huge butt
			to_chat(user, span_notice("You give those massive wrecking balls of yours a powerful shake, ready to demolish anything that gets in their way!"))
		if(8 to INFINITY) // gargantuan hyper butt
			to_chat(user, span_notice("You give that colossal caboose of yours a thunderous quake, ready to flatten anything that gets in its way!"))
		else // invalid quantum state of a butt
			to_chat(user, span_notice("You give your rear end a wiggle, ready to thrust that thing into someone's face!"))

// /obj/item/hand_item/weapon/butt/equipped(mob/user, slot)
// 	. = ..()
// 	transmute_into_bodypart(user)

// /obj/item/hand_item/weapon/butt/pickup(mob/living/user)
// 	. = ..()
// 	transmute_into_bodypart(user)

/// modifies your butt's damage and attack speed based off its size
/// why yes this is in fact gameplay mechanics defined by ERP stuff
/obj/item/hand_item/weapon/butt/transmute_into_bodypart(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.has_butt())
		return
	var/obj/item/organ/genital/butt/B = H.get_organ_slot(ORGAN_SLOT_BUTT)
	// force = 6 * B.size
	attack_speed = (CLICK_CD_MELEE / 3) * B.genital_size
	switch(B.genital_size)
		if(1 to 2)
			w_class = WEIGHT_CLASS_TINY
		if(3)
			w_class = WEIGHT_CLASS_SMALL
		if(4)
			w_class = WEIGHT_CLASS_NORMAL
		if(5)
			w_class = WEIGHT_CLASS_BULKY
		if(6 to 7)
			w_class = WEIGHT_CLASS_HUGE
		if(8 to INFINITY)
			w_class = WEIGHT_CLASS_GIGANTIC
	. = ..()
