/// Tactile hand item, for all your tactile needs
/// It can be used for things like licking, groping, kissing, and... healing!
/// middleclick to make it horny
/obj/item/hand_item/tactile
	/// a healthing that the thing can spawn loaded with, for medical purposes
	/// was a coyote bayou thing, pretty much unused
	var/obj/item/stack/medical/healthing
	/// the trait required to use this item for healing
	var/needed_trait_to_heal
	var/tend_word = "licking"
	var/action_verb = "lick"
	var/action_verb_s = "licks"
	var/action_verb_ing = "licking"
	/// the grope or kiss datum associated with this item
	/// for making this thing horny >=3
	var/datum/grope_kiss_MERP/grope
	/// the last grope action performed with this item
	var/list/lastgrope
	/// whether this item is currently in horny mode
	var/horny_mode = FALSE
	/// whether this item is currently in medical mode
	var/medical_mode = FALSE
	/// whether this item is currently doing a thing
	var/working = FALSE
	/// how far away the thing spews its text
	var/text_range = 3
	/// whether this item can taste things
	var/can_taste = FALSE
	abstract_type = /obj/item/hand_item/tactile

/obj/item/hand_item/tactile/examine(mob/user)
	. = ..()
	if(grope)
		. += "Middle-click to toggle horny mode for this item! It is currently [horny_mode?"on":"off"]."
	if(healthing)
		. += "Alt-click to toggle medical mode for this item! It is currently [medical_mode?"on":"off"]."
		if(needed_trait_to_heal)
			if(!HAS_TRAIT(user, needed_trait_to_heal))
				. += "However, you lack the necessary trait to use this item for healing."

/obj/item/hand_item/tactile/on_pre_spawn()
	if(ispath(healthing))
		healthing = new(src)

/obj/item/hand_item/tactile/update_icon()
	if(horny_mode)
		color = "#FF69B4"
	else
		color = initial(color)
	var/matrix/tf = initial(transform)
	if(medical_mode)
		transform = tf.Turn(90)
	else
		transform = tf
	. = ..()

/obj/item/hand_item/tactile/MiddleClick(user)
	if(!grope)
		to_chat(user, span_alert("Your [src] can't exactly be used for horny purposes! (at least not *this* way!)"))
		horny_mode = FALSE
		update_icon()
		return COMSIG_MOB_CANCEL_CLICKON
	if(horny_mode)
		horny_mode = FALSE
		to_chat(user, span_love("Your [src]'s horny mode deactivated."))
	else
		horny_mode = TRUE
		to_chat(user, span_love("Your [src]'s horny mode activated!"))
		to_chat(user, span_love("Be sure to consider their preferences and consent!"))
	update_icon()
	return COMSIG_MOB_CANCEL_CLICKON

/obj/item/hand_item/tactile/AltClick(mob/user)
	. = ..()
	if(!healthing)
		to_chat(user, span_alert("Your [src] can't exactly be used to heal anything! (At least not medically!)"))
		medical_mode = FALSE
		update_icon()
		return COMSIG_MOB_CANCEL_CLICKON
	if(!HAS_TRAIT(user, needed_trait_to_heal))
		to_chat(user, span_alert("You lack the ability to heal anything with your [src]!"))
		medical_mode = FALSE
		update_icon()
		return FALSE
	if(medical_mode)
		medical_mode = FALSE
		to_chat(user, span_notice("Your [src]'s medical mode deactivated."))
	else
		medical_mode = TRUE
		to_chat(user, span_notice("Your [src]'s medical mode activated!"))
	update_icon()
	return COMSIG_MOB_CANCEL_CLICKON

/// / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / ///
/// Forces this thing to do its tactile action instead of bapping ///
/obj/item/hand_item/tactile/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	INVOKE_ASYNC(src, PROC_REF(handle_hand_item_use), src, user, interacting_with)

/// / / / / / / / / / / / / / / / / / / / / / / / / / / / / ///
/// Common hand item use handler for tactile touchy things  ///
/obj/item/hand_item/tactile/proc/handle_hand_item_use(atom/source, mob/living/user, atom/licked)
	if(!isliving(user))
		return FALSE
	if(required_organ_slot && iscarbon(user))
		var/mob/living/carbon/C = user
		if(!C.get_organ_slot(required_organ_slot))
			to_chat(user, span_alert("WHOA, you dont have the right body part to use this! How did you even get this??"))
			qdel(src)
			return FALSE
	if(working)
		to_chat(user, span_alert("You're already [action_verb_ing] something!"))
		return FALSE
	if(!licked)
		return FALSE
	if(horny_mode)
		if(perform_horny_action(user, licked))
			if(!medical_mode)
				return TRUE
	if(medical_mode)
		if(perform_medical_action(user, licked))
			return TRUE
	return perform_tactile_action(user, licked)

/obj/item/hand_item/tactile/proc/perform_medical_action(mob/living/user, mob/living/target)
	if(!healthing)
		medical_mode = FALSE
		return FALSE
	if(!isliving(user) || !isliving(target))
		return
	var/mob/living/mlemmed = target
	if(iscarbon(mlemmed) && !mlemmed.get_bodypart(user.zone_selected))
		return FALSE
	if(!istype(healthing))
		healthing = new healthing(src)
		if(!istype(healthing))
			return FALSE
	if(!healthing.try_heal(mlemmed, user))
		return FALSE
	return TRUE

/obj/item/hand_item/tactile/proc/perform_horny_action(mob/living/user, mob/living/target)
	return SShanditems.grope_kiss(src, user, target)

/obj/item/hand_item/tactile/proc/perform_tactile_action(mob/living/user, atom/target)
	do_message(user, target)
	do_sounds(user, target)
	if(can_taste)
		taste_if_possible(user, target)
	return TRUE

// non-horny, non-medical tactile action message
/obj/item/hand_item/tactile/proc/do_message(mob/living/user, atom/target)
	visible_message(
		user,
		"[user] [action_verb_s] [target].",
		"You [action_verb] [target].",
		"You hear [action_verb_ing].",
		text_range
	)

/obj/item/hand_item/tactile/proc/do_sounds(mob/living/user, atom/target)
	var/list/sounds2play = list()
	// sounds2play += hitsound
	sounds2play += hitsound
	if(LAZYLEN(sounds2play))
		playsound(target, pick(sounds2play), 85, TRUE)

/obj/item/hand_item/tactile/proc/perform_tactile_action(mob/living/user, atom/target)
	/// give other things a chance to handle being licked, and if they did, stop here cus they do it
	var/lick_ret = SEND_SIGNAL(target, COMSIG_LICK_RETURN, user, target)
	if(lick_ret)
		return lick_ret
	. = ..()

/obj/item/hand_item/tactile/proc/do_message(mob/living/user, atom/licked)
	var/list/lick_words = get_lick_words(user)
	var/line_others
	var/line_self
	var/line_heard
	var/subj_third
	var/subj_second
	if(user == licked)
		subj_third = "[user.p_their()]"
		subj_second = "your"
	else
		subj_third = "[licked.p_their()]"
		subj_second = "[licked.p_their()]"
	line_others = "[user] [lick_words[HI_LICK_INTENT]] [action_verb_s] [subj_third] [lick_words[HI_LICK_LOCATION]]."
	line_self = "You [lick_words[HI_LICK_INTENT]] [action_verb] [subj_second] [lick_words[HI_LICK_LOCATION]]."
	line_heard = "You hear [action_verb_ing]."
	visible_message(
		user,
		line_others,
		line_self,
		line_heard,
		LICK_SOUND_TEXT_RANGE
	)

/obj/item/hand_item/tactile/proc/get_lick_words(mob/living/user)
	if(!user)
		return
	. = list(LICK_LOCATION = "spot", LICK_INTENT = "like a dork") //👀 Dan I swear to god.
	switch(user.zone_selected)
		if(BODY_ZONE_CHEST)
			.[HI_LICK_LOCATION] = "chest"
		if(BODY_ZONE_HEAD)
			.[HI_LICK_LOCATION] = "face"
		if(BODY_ZONE_L_ARM)
			.[HI_LICK_LOCATION] = "left arm"
		if(BODY_ZONE_R_ARM)
			.[HI_LICK_LOCATION] = "right arm"
		if(BODY_ZONE_L_LEG)
			.[HI_LICK_LOCATION] = "left leg"
		if(BODY_ZONE_R_LEG)
			.[HI_LICK_LOCATION] = "right leg"
		if(BODY_ZONE_PRECISE_EYES)
			.[HI_LICK_LOCATION] = "eyes"
		if(BODY_ZONE_PRECISE_MOUTH)
			.[HI_LICK_LOCATION] = "lips"
		if(BODY_ZONE_PRECISE_GROIN)
			.[HI_LICK_LOCATION] = "butt"
		if(BODY_ZONE_PRECISE_L_HAND)
			.[HI_LICK_LOCATION] = "left hand"
		if(BODY_ZONE_PRECISE_R_HAND)
			.[HI_LICK_LOCATION] = "right hand"
		if(BODY_ZONE_PRECISE_L_FOOT)
			.[HI_LICK_LOCATION] = "left foot"
		if(BODY_ZONE_PRECISE_R_FOOT)
			.[HI_LICK_LOCATION] = "right foot"
	switch(user.combat_mode)
		if(INTENT_HELP)
			.[HI_LICK_INTENT] = "gently"
		if(INTENT_DISARM)
			.[HI_LICK_INTENT] = "briskly"
		if(INTENT_GRAB)
			.[HI_LICK_INTENT] = "aggressively"
		if(INTENT_HARM)
			.[HI_LICK_INTENT] = "very aggressively"

/obj/item/hand_item/tactile/proc/taste_if_possible(mob/living/user, atom/target)
	if(!can_taste)
		return
	if(!iscarbon(user))
		return
	var/mob/living/carbon/C = user
	C.taste(null, target)

