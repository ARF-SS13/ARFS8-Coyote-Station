// / / / / / / / / / //
// CUPHAND AND HEAD  //
/obj/item/hand_item/spawner/cuphand
	name = "your cupped hand"
	desc = "Cup your hand to hold liquids. Kinda gross ngl. if you can read this, call 1-800-IM-CODER with error code: OBESE-AVALI-TOIR"
	thing_to_spawn = /obj/item/reagent_containers/cup/glass/sillycup/handcup
	del_on_ground = TRUE // its your hand, if you drop it, it goes back to being your hand!
	hud_icon = 'modular_coyote/icons/hand_items.dmi'
	hud_icon_state = "cuphand"
	hud_use = TRUE

/obj/item/hand_item/spawner/cuphand/on_spawner_put_in_hands(mob/living/user, atom/movable/spawned)
	to_chat(user, span_notice("You cup your hands, ready to hold some liquids!"))

/// The handcup cuphand
/obj/item/reagent_containers/cup/glass/sillycup/handcup
	name = "your cupped hand"
	desc = "A cupped hand ready to hold liquids. Be mindful, this *is* your hand after all!"
	icon_state = "water_cup_e"
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	possible_transfer_amounts = list(5)
	volume = 5
	isGlass = FALSE
	custom_materials = null
	var/datum/weakref/owner

/obj/item/reagent_containers/cup/glass/sillycup/handcup/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/reagent_containers/cup/glass/sillycup/handcup/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	. = ..()

/obj/item/reagent_containers/cup/glass/sillycup/handcup/proc/ownerize(mob/new_owner)
	owner = WEAKREF(new_owner)

/obj/item/reagent_containers/cup/glass/sillycup/handcup/process(seconds_per_tick)
	if(reagents.total_volume <= 0)
		return
	var/mob/living/carbon/carbon_owner = GET_WEAKREF(owner)
	if(!iscarbon(carbon_owner))
		return ..(seconds_per_tick)
	// try to burn em or acid them!
	// gloves?
	var/hand_zone = carbon_owner.get_hand_zone_of_item(src)
	if(!hand_zone)
		return
	var/obj/item/clothing/gloves/glove = carbon_owner.get_item_by_slot(ITEM_SLOT_GLOVES)
	var/glovemult = istype(glove, /obj/item/clothing/gloves) ? glove.cup_temperature_damage_mult : 0
	// non-burning temperature range
	// too hot is above 360 K
	// too cold is below T0C
	var/deg_out_of_range = 0
	var/hot_or_cold = "neither"
	if(reagents.chem_temp < T0C)
		deg_out_of_range = T0C - reagents.chem_temp
		hot_or_cold = "cold"
	else if(reagents.chem_temp > 360)
		deg_out_of_range = reagents.chem_temp - 360
		hot_or_cold = "hot"

	if(deg_out_of_range > 0)
		var/damage = deg_out_of_range * 0.1 * (1 - glovemult)
		// apply the damage to the owner or the cup as needed
		// check if they actually have that part
		if(hand_zone == BODY_ZONE_R_ARM && !carbon_owner.has_right_hand(FALSE) || hand_zone == BODY_ZONE_L_ARM && !carbon_owner.has_left_hand(FALSE))
			return
		if(hand_zone == BODY_ZONE_R_ARM)
			hand_zone = BODY_ZONE_PRECISE_R_HAND
		if(hand_zone == BODY_ZONE_L_ARM)
			hand_zone = BODY_ZONE_PRECISE_L_HAND
		carbon_owner.apply_damage(damage, BURN, hand_zone)
		if(hot_or_cold == "hot")
			to_chat(carbon_owner, span_alert("Your hand is burning from the hot liquid!"))
		else if(hot_or_cold == "cold")
			to_chat(carbon_owner, span_alert("Your hand is freezing from the cold liquid!"))
		playsound(carbon_owner, 'sound/items/weapons/sear.ogg')
		if(prob(20))
			carbon_owner.emote("scream")
		if(carbon_owner.get_fire_loss() > 50)
			to_chat(carbon_owner, span_alert("You drop the liquid in your hand!"))
			try_splash(carbon_owner, carbon_owner)
			qdel(src)
			return
	// now the acid treatment
	var/glove_acidproof = carbon_owner.getarmor(hand_zone, ACID) >= 0.8 // close enough
	if(reagents.ph <= 6 || reagents.ph >= 8)
		if(!glove_acidproof)
			just_slash_em(carbon_owner)
	for(var/datum/reagent/reagent as anything in reagents.reagent_list)
		if(reagent::is_gas)
			just_slash_em(carbon_owner)
		if(reagent::ok_for_cuphand)
			continue
		just_slash_em(carbon_owner)

/obj/item/reagent_containers/cup/glass/sillycup/handcup/proc/just_slash_em(carbon_owner)
	try_splash(carbon_owner, carbon_owner)
	qdel(src)

/datum/reagent/var/is_gas                          = FALSE
/datum/reagent/var/ok_for_cuphand                  = TRUE
/datum/reagent/ants/ok_for_cuphand                 = FALSE
/datum/reagent/blob/ok_for_cuphand                 = FALSE
/datum/reagent/bromine/ok_for_cuphand              = FALSE
/datum/reagent/clf3/ok_for_cuphand                 = FALSE
/datum/reagent/liquid_dark_matter/ok_for_cuphand   = FALSE
/datum/reagent/mercury/ok_for_cuphand              = FALSE
/datum/reagent/phlogiston/ok_for_cuphand           = FALSE
/datum/reagent/reaction_agent/ok_for_cuphand       = FALSE
/datum/reagent/toxin/ok_for_cuphand                = FALSE

/datum/reagent/carbon_dioxide/is_gas  = TRUE
/datum/reagent/chlorine/is_gas        = TRUE
/datum/reagent/halon/is_gas           = TRUE
/datum/reagent/healium/is_gas         = TRUE
/datum/reagent/hydrogen/is_gas        = TRUE
/datum/reagent/hypernoblium/is_gas    = TRUE
/datum/reagent/nitrogen/is_gas        = TRUE
/datum/reagent/nitrous_oxide/is_gas   = TRUE
/datum/reagent/oxygen/is_gas          = TRUE
/datum/reagent/plasma_oxide/is_gas    = TRUE
/datum/reagent/pluoxium/is_gas        = TRUE
/datum/reagent/zauker/is_gas          = TRUE

/obj/item/clothing/gloves
	var/cup_temperature_damage_mult = 0.5
	var/cup_resists_touch_reaction_for = 5 SECONDS
	var/cup_resists_touch_reaction_until = 0

/obj/item/clothing/gloves/color/yellow
	cup_temperature_damage_mult = 0 // insuls

// / / / / / / / / / //
// rocks             //
// /obj/item/hand_item/spawner/rock
// 	name = "rock"
// 	desc = "A simple rock. Probably not good for much, but you can try hitting things with it!"
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "rock"
// 	thing_to_spawn = /obj/item/ammo_casing/caseless/rock
// 	cooldown_time = 2.5 SECONDS
// 	cooldown_override_trait = TRAIT_MONKEYLIKE
// 	hud_icon = 'modular_coyote/icons/hand_items.dmi'
// 	hud_icon_state = "rock"
// 	hud_use = TRUE

// /obj/item/hand_item/spawner/rock/on_spawner_put_in_hands(mob/living/user, atom/movable/spawned)
// 	to_chat(user, span_notice("You scoop up a hefty rock!"))

// /obj/item/hand_item/spawner/rock/on_spawner_put_on_ground(mob/living/user, atom/movable/spawned)
// 	to_chat(user, span_notice("You find a hefty rock on the ground! Your hands are too full to pick it up, but it's there!"))

// /obj/item/hand_item/spawner/rock/on_failed_give_message(mob/living/user, reason)
// 	if(reason == HI_ON_COOLDOWN)
// 		var/timeleft = SShanditems.get_cooldown_time_left(user, src)
// 		to_chat(user, span_alert("You scared all the rocks away! They'll be back in [DisplayTimeText(timeleft)] though."))
// 		return TRUE
// 	. = ..()

// // / / / / / / / / //
// // brick           //
// /obj/item/hand_item/spawner/brick
// 	name = "brick"
// 	desc = "A simple brick. Probably not good for much, but you can try hitting things with it!"
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "brick"
// 	thing_to_spawn = /obj/item/ammo_casing/caseless/brick
// 	cooldown_time = 2.5 SECONDS
// 	cooldown_override_trait = TRAIT_QUICK_BUILD

// /obj/item/hand_item/spawner/brick/on_spawner_put_in_hands(mob/living/user, atom/movable/spawned)
// 	to_chat(user, span_notice("You pick up a sturdy brick!"))

// /obj/item/hand_item/spawner/brick/on_spawner_put_on_ground(mob/living/user, atom/movable/spawned)
// 	to_chat(user, span_notice("You find a sturdy brick on the ground! Your hands are too full to pick it up, but it's there!"))

// /obj/item/hand_item/spawner/brick/on_failed_give_message(mob/living/user, reason)
// 	if(reason == HI_ON_COOLDOWN)
// 		var/timeleft = SShanditems.get_cooldown_time_left(user, src)
// 		to_chat(user, span_alert("You scared all the bricks away! They'll be back in [DisplayTimeText(timeleft)] though."))
// 		return TRUE
// 	. = ..()

// /obj/item/hand_item/spawner/snowball
// 	name = "snowball"
// 	desc = "A simple snowball. Probably not good for much, but you can try hitting things with it!"
// 	icon = 'icons/obj/in_hands.dmi'
// 	icon_state = "snowball"
// 	thing_to_spawn = /obj/item/toy/snowball
// 	required_months = list(12, 1, 2) // only available in december, january, and february!
// 	cooldown_time = 1 SECONDS

// /obj/item/hand_item/spawner/snowball/on_spawner_put_in_hands(mob/living/user, atom/movable/spawned)
// 	to_chat(user, span_notice("You pack together a fluffy snowball!"))

// /obj/item/hand_item/spawner/snowball/on_spawner_put_on_ground(mob/living/user, atom/movable/spawned)
// 	to_chat(user, span_notice("You nudge some snow on the gound into a snowball! Your hands are too full to pick it up, but it's there!"))

// /obj/item/hand_item/spawner/snowball/on_failed_give_message(mob/living/user, reason)
// 	if(reason == HI_OUT_OF_SEASON)
// 		to_chat(user, span_alert("It's a little warm for snowballs, isn't it? You'll have to wait for the wintery months to get some!"))
// 		return TRUE
// 	if(reason == HI_ON_COOLDOWN)
// 		var/timeleft = SShanditems.get_cooldown_time_left(user, src)
// 		to_chat(user, span_alert("You scared all the snow away! They'll be back in [DisplayTimeText(timeleft)] though."))
// 		return TRUE
