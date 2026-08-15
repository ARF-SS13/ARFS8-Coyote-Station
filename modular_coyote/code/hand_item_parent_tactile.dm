/// Tactile hand item, for all your tactile needs
/// used to be better, but now its less good
/obj/item/hand_item/tactile
	var/action_verb = "lick"
	var/action_verb_s = "licks"
	var/action_verb_ing = "licking"
	/// how far away the thing spews its text
	var/text_range = 3
	/// whether this item can taste things
	var/can_taste = FALSE
	abstract_type = /obj/item/hand_item/tactile

/// / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / ///
/// Forces this thing to do its tactile action instead of bapping ///
/obj/item/hand_item/tactile/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	INVOKE_ASYNC(src, PROC_REF(handle_hand_item_use), src, user, interacting_with)

/// / / / / / / / / / / / / / / / / / / / / / / / / / / / / ///
/// Common hand item use handler for tactile touchy things  ///
/obj/item/hand_item/tactile/proc/handle_hand_item_use(atom/source, mob/living/user, atom/licked)
	if(!isliving(user))
		return FALSE
	if(required_bodypart_slot && iscarbon(user))
		var/mob/living/carbon/C = user
		if(!C.get_organ_slot(required_bodypart_slot))
			to_chat(user, span_alert("WHOA, you dont have the right body part to use this! How did you even get this??"))
			qdel(src)
			return FALSE
	if(!licked)
		return FALSE
	return perform_tactile_action(user, licked)

/obj/item/hand_item/tactile/proc/perform_tactile_action(mob/living/user, atom/target)
	do_message(user, target)
	do_sounds(user, target)
	if(can_taste)
		taste_if_possible(user, target)
	return TRUE

/obj/item/hand_item/tactile/proc/do_sounds(mob/living/user, atom/target)
	var/list/sounds2play = list()
	// sounds2play += hitsound
	sounds2play += hitsound
	if(LAZYLEN(sounds2play))
		playsound(target, pick(sounds2play), 85, TRUE)

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
		text_range,
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

//? code\modules\mob\living\taste.dm
//todo: write a cool cute in-depth tasting interaction system
// neat
/obj/item/hand_item/tactile/proc/taste_if_possible(mob/living/user, atom/target)
	if(!can_taste)
		return
	if(!isliving(target))
		return FALSE
	var/mob/living/carbon/human/target_human = target

	var/taste = target_human?.dna?.features["taste"]
	if(!taste)
		to_chat(src, span_warning("[target_human] doesn't seem to have a taste."))
		return FALSE

	to_chat(src, span_notice("[target_human] tastes like [taste]."))
	to_chat(target_human, span_notice("[src] licks you."))

