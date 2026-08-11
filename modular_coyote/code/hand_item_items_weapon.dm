/// / / / / ///
/// BITERS  ///
// todo: make biting metal things hurt a lot
/obj/item/hand_item/weapon/biter
	name = "Biter"
	desc = "Talk shit, get bit."
	icon = 'modular_coyote/icons/hand_items_items.dmi'
	icon_state = "biter"
	attack_verb_simple = list("chomped", "gnawed", "bit", "crunched", "nommed")
	hitsound = "sound/weapons/bite.ogg"
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "bite"
	just_one = TRUE
	required_trait = TRAIT_BITE
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

/// BIG BITER
/obj/item/hand_item/weapon/biter/big
	name = "Big Biter"
	desc = "Talk shit, get BIG bit."
	color = "#884444"
	force = 40
	force_wielded = 50
	force_unwielded = 40
	attack_speed = CLICK_CD_MELEE

/obj/item/hand_item/weapon/biter/big/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("Your lips part, revealing a set of massive, razor-sharp fangs!"))


/// SABRE TOOTHED BITER
/obj/item/hand_item/weapon/biter/sabre
	name = "Sabre Toothed Biter"
	desc = "Damn bitch, you eat with them teeth?"
	color = "#FF4444"
	force = 45
	force_wielded = 55
	force_unwielded = 45
	attack_speed = CLICK_CD_MELEE * 1.2

/obj/item/hand_item/weapon/biter/sabre/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You slide your long sabreteeth against your lower lip, ready to impale whatever crosses your path!"))


/// FAST BITER
/obj/item/hand_item/weapon/biter/fast
	name = "Fast Biter"
	desc = "Talk shit, get SPEED bit."
	color = "#448844"
	force = 25
	force_wielded = 30
	force_unwielded = 25
	attack_speed = CLICK_CD_MELEE * 0.5

/obj/item/hand_item/weapon/biter/fast/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You click your teeth together, ready to strike with lightning speed!"))


/// PLAY BITER
/obj/item/hand_item/weapon/biter/play
	name = "Play Biter"
	desc = "Someone really should just muzzle you."
	color = "#ff44ff"
	force = 0
	force_wielded = 0
	force_unwielded = 0
	attack_speed = 1
	wound_bonus = -999
	exposed_wound_bonus = -999

/obj/item/hand_item/weapon/biter/play/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You bare your teeth with such ferocity! Such a mighty killer!"))


/// SPICY BITER
/obj/item/hand_item/weapon/biter/spicy
	name = "Spicy Biter"
	desc = "Your sickly little nibbler, good for dropping fools."
	color = "#44FF44"
	force = 35
	force_wielded = 45
	force_unwielded = 35
	extra_damage = 30
	extra_damage_type = STAMINA

/obj/item/hand_item/weapon/biter/spicy/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You bare your fangs, dripping with venom!"))

/// / / / ///
/// CLAWS ///
/obj/item/hand_item/weapon/clawer
	name = "Clawer"
	desc = "Thems some claws."
	icon = 'modular_coyote/icons/hand_items_items.dmi'
	icon_state = "clawer"
	w_class = WEIGHT_CLASS_TINY
	sharpness = SHARP_EDGED
	attack_verb_simple = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	force = 30
	force_wielded = 40
	force_unwielded = 30
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "claw"
	required_trait = TRAIT_CLAW
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

/// BIG CLAWER
/obj/item/hand_item/weapon/clawer/big
	name = "Big Clawer"
	desc = "Thems some BIG ASS claws."
	color = "#884444"
	force = 35
	force_wielded = 45
	force_unwielded = 35
	attack_speed = CLICK_CD_MELEE * 1.5

/obj/item/hand_item/weapon/clawer/big/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your long deadly claws! Goodness they're heavy!"))


/// RAZOR CLAWER
/obj/item/hand_item/weapon/clawer/razor
	name = "Razor Sharp Clawers"
	desc = "RIP AND TEAR."
	color = "#FF4444"
	force = 40
	force_wielded = 50
	force_unwielded = 40
	attack_speed = CLICK_CD_MELEE * 1.2

/obj/item/hand_item/weapon/clawer/razor/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your razor sharp claws! The wind whistles through them."))


/// FAST CLAWER
/obj/item/hand_item/weapon/clawer/fast
	name = "Fast Clawer"
	desc = "Thems some FAST ASS claws."
	color = "#448844"
	force = 30
	force_wielded = 40
	force_unwielded = 30
	attack_speed = CLICK_CD_MELEE * 0.5

/obj/item/hand_item/weapon/clawer/fast/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your claws, light and agile!"))


/// PLAY CLAWER
/obj/item/hand_item/weapon/clawer/play
	name = "Play Clawer"
	desc = "Basically just a bean thwapper."
	color = "#FF88FF"
	force = 0
	force_wielded = 0
	force_unwielded = 0
	attack_speed = 1
	wound_bonus = -999
	exposed_wound_bonus = -999

/obj/item/hand_item/weapon/clawer/play/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your harmless claws, ready to play!"))


/// SPICY CLAWER
/obj/item/hand_item/weapon/clawer/spicy
	name = "Spicy Clawer"
	desc = "My gross little litter box rakes, good for puttings idiots on the ground."
	color = "#44FF44"
	force = 30
	force_wielded = 40
	force_unwielded = 30
	extra_damage = 30
	extra_damage_type = STAMINA
	associated_trait = TRAIT_SPICYCLAW
	required_trait = TRAIT_SPICYCLAW

/obj/item/hand_item/weapon/clawer/spicy/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your claws, dripping with venom!"))

/// / / / / / / ///
/// ARM BLADES  ///
// /obj/item/hand_item/weapon/arm_blade
// 	name = "arm blade"
// 	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
// 	icon = 'icons/obj/items_and_weapons.dmi'
// 	icon_state = "arm_blade"
// 	inhand_icon_state = "arm_blade"
// 	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
// 	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
// 	w_class = WEIGHT_CLASS_HUGE
// 	force = 40
// 	force_wielded = 50
// 	force_unwielded = 40
// 	hitsound = 'sound/weapons/bladeslice.ogg'
// 	attack_verb_simple = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
// 	sharpness = SHARP_EDGED
// 	associated_trait = TRAIT_ARMBLADE
// 	required_trait = TRAIT_ARMBLADE

// /obj/item/hand_item/weapon/arm_blade/on_successful_give(mob/living/user, reason)
// 	to_chat(user, span_notice("Your arm crunches into a horrifying, deadly blade!"))

// /obj/item/hand_item/weapon/arm_blade/cyber
// 	name = "Cyber blade"
// 	desc = "A advanced cybernetic blade made out of numerous materials that cleaves through people as a hot knife through butter."
// 	icon = 'icons/obj/items_and_weapons.dmi'
// 	icon_state = "cyber_blade"
// 	inhand_icon_state = "cyber_blade"
// 	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
// 	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
// 	associated_trait = TRAIT_CYBERKNIFE
// 	required_trait = TRAIT_CYBERKNIFE

// /obj/item/hand_item/weapon/arm_blade/cyber/on_successful_give(mob/living/user, reason)
// 	to_chat(user, span_notice("Your arm re-forges itself into a sleek cybernetic blade!"))

/// / / / / ///
/// SHOVERS ///
// /obj/item/hand_item/weapon/shover // pak chooie unf
// 	name = "shover"
// 	desc = "Stay back!"
// 	icon = 'icons/obj/items_and_weapons.dmi'
// 	icon_state = "latexballon"
// 	inhand_icon_state = "nothing"
// 	attack_verb_simple = list("shoved", "pushed")
// 	hitsound = "sound/weapons/thudswoosh.ogg"
// 	force = 0
// 	force_wielded = 0
// 	throwforce = 0
// 	wound_bonus = 0
// 	can_knockback = TRUE
// 	hud_use = FALSE

// /obj/item/hand_item/weapon/shover/on_successful_give(mob/living/user, reason)
// 	to_chat(user, span_notice("You hold a hand up, ready to shove something around!"))

/// / / / ///
/// TAILS ///
/obj/item/hand_item/weapon/tail
	name = "tailwhack"
	desc = "A tail. Good for whacking."
	icon = 'modular_coyote/icons/hand_item_items.dmi'
	icon_state = "severedtail"
	w_class = WEIGHT_CLASS_TINY
	force = 15
	can_knockback = TRUE
	spin_attack = TRUE
	use_bodypart_image_slot = PHUD_TAIL
	just_one = TRUE
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "tail"
	required_trait = TRAIT_TAIL
	subitem_master_path = /obj/item/hand_item/weapon/tail
	subitem_paths = list(
		// HI_SUB_DEFAULT = /obj/item/hand_item/weapon/tail/my_tail,
		HI_SUB_DEFAULT = /obj/item/hand_item/weapon/tail/playful,
		TRAIT_TAILPLAY = /obj/item/hand_item/weapon/tail/playful,
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
	force_wielded = 0
	attack_speed = 3
	weapon_special_component = /datum/component/weapon_special/single_turf
	associated_trait = TRAIT_TAILPLAY // yeah im into tailplay, what of it?
	required_trait = TRAIT_TAILPLAY

/obj/item/hand_item/weapon/tail/playful/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You ready your soft, harmless tail, ready to give someone a cute lil whap!"))

/obj/item/hand_item/weapon/tail/fast
	name = "fast tail"
	desc = "A speedy tail that's very good at whackin' fast."
	color = "#448844"
	force = 18
	attack_speed = CLICK_CD_MELEE * 0.6
	associated_trait = TRAIT_TAILWHIP
	required_trait = TRAIT_TAILWHIP

/obj/item/hand_item/weapon/tail/fast/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You swish your tail! It moves gracefully through the air."))

/obj/item/hand_item/weapon/tail/big
	name = "big tail"
	desc = "A big tail that whacks hard."
	color = "#884444"
	force = 25
	associated_trait = TRAIT_TAILSMASH
	required_trait = TRAIT_TAILSMASH

/obj/item/hand_item/weapon/tail/big/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You give your tail a wiggle, rippling with brute force!"))

/obj/item/hand_item/weapon/tail/spicy
	name = "spicy tail"
	desc = "A tail with something that can inject venom on it."
	color = "#44FF44"
	force = 15
	extra_damage = 30
	extra_damage_type = STAMINA
	associated_trait = TRAIT_TAILSPICY
	required_trait = TRAIT_TAILSPICY

/obj/item/hand_item/weapon/tail/spicy/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("You extend your tail's venomous tip, ready to inject."))

/obj/item/hand_item/weapon/tail/thago
	name = "dangerous tail"
	desc = "A god damn mighty tail that would kill an allosaurus.  Maybe."
	color = "#FF4444"
	force = 40
	attack_speed = CLICK_CD_MELEE * 1.2
	associated_trait = TRAIT_TAILTHAGO
	required_trait = TRAIT_TAILTHAGO

/obj/item/hand_item/weapon/tail/thago/on_successful_give(mob/living/user, reason)
	to_chat(user, span_notice("Your mighty tail thumps against the ground with a dull thud, ready to pulverize anything in its path!"))

/// / / / ///
/// BEANS ///
/obj/item/hand_item/weapon/beans
	name = "beans"
	desc = "Them's ya' beans. Touch em' to things."
	icon = 'modular_coyote/icons/hand_items_items.dmi'
	icon_state = "bean"
	color = "#ff88bb"
	attack_verb_simple = list()
	hitsound = "sound/effects/attackblob.ogg"
	force = 0
	force_wielded = 0
	throwforce = 0
	attack_speed = 0
	extra_damage = 1 // its mildly annoying!
	extra_damage_type = STAMINA
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "beans"
	required_trait = TRAIT_BEANS

/obj/item/hand_item/weapon/beans/on_successful_give(mob/user, reason)
	to_chat(user, span_notice("You ready your beans for WAR!!"))
	return TRUE

/obj/item/hand_item/weapon/beans/war
	name = "war beans"
	desc = "Them's ya' war beans. Touch em' to things you want dead."
	color = "#ff4444"
	force = 4
	force_wielded = 8
	required_trait = TRAIT_WARBEANS

/obj/item/hand_item/weapon/beans/on_successful_give(mob/user, reason)
	to_chat(user, span_notice("You ready your warbeans for REAL WAR!!"))
	return TRUE

/// / / / /// // unbreak in case of butt
/// BUTT  ///
// /obj/item/hand_item/weapon/butt
// 	name = "butt"
// 	desc = "Very smoochable."
// 	icon = 'icons/ass/assfemale.png' // rofl
// 	attack_verb_simple = list("smecked", "bwapped", "bumped", "clapped", "quapped", "vooped", "whomped")
// 	w_class = WEIGHT_CLASS_GIGANTIC // your butt is HUGE!!!!
// 	force = 15
// 	weapon_special_component = /datum/component/weapon_special/single_turf
// 	use_bodypart_image_slot = PHUD_BUTT
// 	spin_attack = TRUE
// 	just_one = TRUE
// 	hud_icon = 'modular_coyote/icons/hand_items.dmi'
// 	hud_icon_state = "butt"
// 	required_trait = TRAIT_BUTT

// /obj/item/hand_item/weapon/butt/on_successful_give(mob/living/user, reason)
// 	var/mob/living/carbon/human/H = user
// 	if(!H.has_butt())
// 		to_chat(user, span_notice("You give your rear end a wiggle, ready to thrust that thing into someone's face!"))
// 		return
// 	var/obj/item/organ/genital/butt/B = H.getorganslot(ORGAN_SLOT_BUTT)
// 	if(!B)
// 		to_chat(user, span_notice("You give your rear a wiggle, ready to thrust that thing into someone's face!"))
// 		return
// 	switch(B.size)
// 		if(1 to 2) // tiny butt
// 			to_chat(user, span_notice("You give your slender tushie a wiggle, ready to crack a few ribs!"))
// 		if(3) // small butt
// 			to_chat(user, span_notice("You give your modest behind a wiggle, ready to crack a few ribs!"))
// 		if(4) // average butt
// 			to_chat(user, span_notice("You give your ample backside a wiggle, ready to hip check something into the ground!"))
// 		if(5) // thicc butt
// 			to_chat(user, span_notice("You give your hefty booty a jiggle, ready to hip check something into the ground!"))
// 		if(6 to 7) // huge butt
// 			to_chat(user, span_notice("You give those massive wrecking balls of yours a powerful shake, ready to demolish anything that gets in their way!"))
// 		if(8 to INFINITY) // gargantuan hyper butt
// 			to_chat(user, span_notice("You give that colossal caboose of yours a thunderous quake, ready to flatten anything that gets in its way!"))
// 		else // invalid quantum state of a butt
// 			to_chat(user, span_notice("You give your rear end a wiggle, ready to thrust that thing into someone's face!"))

// /obj/item/hand_item/weapon/butt/equipped(mob/user, slot)
// 	. = ..()
// 	buttify(user)

// /obj/item/hand_item/weapon/butt/pickup(mob/living/user)
// 	. = ..()
// 	buttify(user)

// /// modifies your butt's damage and attack speed based off its size
// /// why yes this is in fact gameplay mechanics defined by ERP stuff
// /obj/item/hand_item/weapon/butt/proc/buttify(mob/user)
// 	if(!iscarbon(user))
// 		return
// 	var/mob/living/carbon/human/H = user
// 	if(!H.has_butt())
// 		return
// 	var/obj/item/organ/genital/butt/B = H.getorganslot(ORGAN_SLOT_BUTT)
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
