/// / / / / / / / / / / / / / / / / / / / / / / / / / / ///
/// hand items used primarily as a way to attack things ///
/// generally for things you whack other things with    ///
/obj/item/hand_item/weapon
	name = "attack thing"
	desc = "Use it to attack things, probably. May or may not be part of your body."
	force = 4
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CONDUCTS_ELECTRICITY
	throwforce = 0
	sharpness = SHARP_POINTY
	attack_speed = CLICK_CD_MELEE
	// weapon_special_component = /datum/component/weapon_special/single_turf // todo: port my super cool turf attack thing
	hud_use = TRUE
	/// thing to spawn when used by creatures. unused cus creatures dont hold stuff here
	var/obj/item/hand_item/weapon/for_creatures
	/// extra force applied when its equipped as a glove. unused since they dont go there here
	var/extra_force_as_glove = 0
	/// extra damage applied on top of the base damage of the weapon. unused
	var/extra_damage = 0
	/// type of extra damage applied. unused
	var/extra_damage_type = STAMINA
	/// whether the weapon can knock back targets
	var/can_knockback = FALSE
	/// whether the weapon makes you spin around
	var/spin_attack = FALSE
	/// which bodypart to pull its icon/state from, if any
	var/use_bodypart_image_slot
	/// cached bodypart images for the weapon's icon/state
	var/list/bodypart_images = list()
	abstract_type = /obj/item/hand_item/weapon

/obj/item/hand_item/weapon/Initialize(mapload, mob/handholder)
	. = ..()
	if(can_knockback)
		AddElement(/datum/element/knockback, 1, FALSE, TRUE)

/obj/item/hand_item/weapon/afterattack(mob/living/M, mob/living/user)
	. = ..()
	if(spin_attack)
		user.spin(4, 1) // SPEEN

/obj/item/hand_item/weapon/pickup(mob/living/user)
	. = ..()
	transmute_into_bodypart(user)

// /obj/item/hand_item/weapon/get_associated_item_for_user_trait(mob/living/user)
// 	if(ispath(for_creatures) && isanimal(user) && !isadvancedmob(user))
// 		return SShanditems.get_hand_item_template(for_creatures)
// 	. = ..()

// todo: this
/obj/item/hand_item/weapon/proc/transmute_into_bodypart(mob/user)
	if(!use_bodypart_image_slot)
		return
	if(!iscarbon(user))
		return
	var/datum/genital_images/mynt = SSpornhud.get_genital_datum(user)
	bodypart_images.Cut()
	if(mynt)
		switch(use_bodypart_image_slot)
			if(PHUD_TAIL)
				bodypart_images = mynt.tail.Copy()
			if(PHUD_BUTT)
				bodypart_images = mynt.butt.Copy()
	if(!LAZYLEN(bodypart_images))
		return // use default icon
	icon = "icons/effects/effects.dmi"
	icon = "nothing"
	overlays.Cut()
	for(var/whatever in bodypart_images)
		var/image/I = whatever
		I.dir = NORTH
		overlays += I

// todo: make attack modifiers and such able to do more things
// /obj/item/hand_item/weapon/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
// 	. = ..()
// 	if(!.)
// 		return
// 	if(!istype(target_mob))
// 		return
// 	if(!extra_damage)
// 		return
// 	target_mob.apply_damage(extra_damage, extra_damage_type, "chest", target_mob.run_armor_check("chest", "melee"))
