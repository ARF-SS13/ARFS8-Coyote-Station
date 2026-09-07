/obj/item/gun/ballistic/rifle
	name = "Bolt Rifle"
	desc = "Some kind of bolt action rifle. You get the feeling you shouldn't have this."
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "sakhno"
	w_class = WEIGHT_CLASS_BULKY
	force = 13 // it's a heavy baseball bat basically
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'sound/items/weapons/gun/rifle/shot_heavy.ogg'
	fire_sound_volume = 90
	rack_sound = 'sound/items/weapons/gun/rifle/bolt_out.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/rifle/bolt_in.ogg'
	drop_sound = 'sound/items/handling/gun/ballistics/rifle/rifle_drop1.ogg'
	pickup_sound = 'sound/items/handling/gun/ballistics/rifle/rifle_pickup1.ogg'
	tac_reloads = FALSE
	/// Does the bolt need to be open to interact with the gun (e.g. magazine interactions)?
	var/need_bolt_lock_to_interact = FALSE

/obj/item/gun/ballistic/rifle/rack(mob/user = null)
	if (bolt_locked == FALSE)
		balloon_alert(user, "bolt opened")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_appearance()
		return
	drop_bolt(user)


/obj/item/gun/ballistic/rifle/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(need_bolt_lock_to_interact && !bolt_locked && !istype(tool, /obj/item/knife))
		balloon_alert(user, "bolt closed!")
		return

	return ..()

/obj/item/gun/ballistic/rifle/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/examine(mob/user)
	. = ..()
	. += "The bolt is [bolt_locked ? "open" : "closed"]."

////////////////////////////
// LOW POWER PATROL RIFLE ///
// Don't you fucking dare make these more available by putting them in cargo or adding a bunch of them to the map. they are limited by design so that they have to be shared.
// Don't you fucking dare add antag modifications or upgrades to these as it undermines the trust needed to issue them to players.
// Don't you fucking dare make these more powerful or streamlined, as their finnicky nature adds an extra sliver of depth and makes lower power engagements more intense.
// Don't you fucking dare make these shoot bullets because issuing a weapon that inflicts bleeding and breaks windows makes no goddamn sense for a civilian rifle.
// Don't you fucking dare restrict these behind a special job or automate issuing them to crew, as that undercuts character to character interaction and means people will bum rush and hoard them

/obj/item/gun/ballistic/rifle/patrol
	name = "militia patrol rifle"
	desc = "A low-powered rifle made for hunting hazardous space creatures. To be loaned to volunteering crewmembers to patrol the solar arrays and other external areas of the station. Its underpowered design means it can be carried without a weapons permit and on green alert by civilians and security alike."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "patrol_rifle_cargo" // decided I like the brown color better with green energy highlights
	w_class = WEIGHT_CLASS_BULKY
	bolt_type = BOLT_TYPE_STANDARD
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/patrol
	fire_sound = 'sound/items/weapons/resonator_fire.ogg'
	fire_sound_volume = 90
	cartridge_wording = "cartridge"
	need_bolt_lock_to_interact = TRUE
	slot_flags = ITEM_SLOT_BACK
	weapon_weight = WEAPON_HEAVY
	item_flags = null //no permit needed

/obj/item/gun/ballistic/rifle/patrol/update_overlays()
	. = ..()
	if(!bolt_locked && chambered?.loaded_projectile)
		. += "patrol_rifle_ready"
	else if(bolt_locked)
		. += "patrol_rifle_unbolt"
	else
		. += "patrol_rifle_empty"

// to match security's style and distinguish the militia style as NOT security property
/obj/item/gun/ballistic/rifle/patrol/sec
	name = "security patrol rifle"
	icon_state = "patrol_rifle_sec"

////////////////////////////
/// Mosin: Fuzzy edition ///
////////////////////////////

/obj/item/gun/ballistic/rifle/mosin
	name = "mosin nagant"
	desc = "An ancient rugged bolt action rifle. Its action runs butter smooth without a speck of cosmoline."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "mosin"
	inhand_icon_state = "mosin"
	worn_icon_state = "mosin"
	w_class = WEIGHT_CLASS_BULKY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/mosin
	bolt_type = BOLT_TYPE_STANDARD
	need_bolt_lock_to_interact = TRUE
	can_be_sawn_off = FALSE // maybe someday, once I got sprites and mechanics for how it might interact with cosmoline
	slot_flags = ITEM_SLOT_BACK
	weapon_weight = WEAPON_HEAVY
	var/gum_chance = 50
	var/cosmoline_level = 0
	var/blood_level_per_clean = 0 // for the rag, from 0 to 10
	var/clean_chance = 0
	var/clean_success = "this shouldn't be happening, notify a coder!"
	var/clean_fail = "this shouldn't be happening, notify a coder!"
	var/cosmoline_suffix = null
/obj/item/gun/ballistic/rifle/mosin/process_fire(mob/user)
	if(gum_chance)
		if(chambered.loaded_projectile)
			if(prob(gum_chance))
				balloon_alert(loc, "gummed up!")
				playsound(loc,'sound/items/weapons/throwtap.ogg', 75, TRUE)
				return FALSE
	return ..()
/obj/item/gun/ballistic/rifle/mosin/proc/should_clean()
	return cosmoline_level > 0

/obj/item/gun/ballistic/rifle/mosin/proc/update_cosmoline()
	switch(cosmoline_level)
		if(0)
			name = "pristine mosin nagant"
			desc = "An ancient rugged bolt action rifle. Its action runs butter smooth without a speck of cosmoline. It's already starting to rust."
			inhand_icon_state = "mosin"
			worn_icon_state = "mosin"
			gum_chance = 2 // it's never zero
			blood_level_per_clean = 0
			clean_chance = 0
			clean_success = "this shouldn't be happening, notify a coder!"
			clean_fail = "this shouldn't be happening, notify a coder!"
		if(1)
			name = "lightly gummed mosin nagant"
			desc = "An ancient rugged bolt action rifle. Its bolt sticks occasionally with leftover cosmoline. You could try to clean it out with a rag but it may take a while."
			cosmoline_suffix = "gummed"
			inhand_icon_state = "mosin"
			worn_icon_state = "mosin"
			gum_chance = 10
			blood_level_per_clean = 1
			clean_chance = 5 // good luck getting the last little bit out
			clean_success = "You finally got the last of the cosmoline out of the rifle's bolt!"
			clean_fail = "You scrub the parts a little but there always seems to be a little more gunk in some small corner."
		if(2)
			name = "cosmoline smeared mosin nagant"
			desc = "An ancient rugged bolt action rifle. It's smeared with cosmoline inside and out. You could use a rag to wipe a fair bit off without too much trouble."
			cosmoline_suffix = "smeared"
			inhand_icon_state = "mosin"
			worn_icon_state = "mosin"
			gum_chance = 25
			blood_level_per_clean = 2
			clean_chance = 30
			clean_success = "You wipe down the rifle, removing all the cosmoline from its surfaces."
			clean_fail = "You wipe down the rifle but it's still rather sticky."
		if(3)
			name = "cosmoline covered mosin nagant"
			desc = "An ancient rugged bolt action rifle. It's covered in a thorough coating of cosmoline protecting it from rust. You could remove it with a rag."
			cosmoline_suffix = "covered"
			inhand_icon_state = "mosin"
			worn_icon_state = "mosin"
			gum_chance = 50
			blood_level_per_clean = 2
			clean_chance = 30
			clean_success = "You wipe down the rifle, cleaning a fair amount of cosmoline off of it."
			clean_fail = "You wipe down the rifle but it's still pretty thoroughly covered in cosmoline."
		if(4)
			name = "cosmoline soaked mosin nagant"
			desc = "An ancient rugged bolt action rifle. It is utterly drenched in an extra helping of cosmoline. You could get a fair bit off with a rag."
			cosmoline_suffix = "soaked"
			inhand_icon_state = "mosin"
			worn_icon_state = "mosin"
			gum_chance = 75
			blood_level_per_clean = 3
			clean_chance = 30
			clean_success = "You finally get most of the caked up cosmoline off."
			clean_fail = "You wipe down the rifle but there's still cosmoline absolutely everywhere!"
		if(5)
			name = "rifle shaped glob of cosmoline"
			desc = "There seems to be more cosmoline than rifle here. A rag could help but there's a lot to scoop off."
			cosmoline_suffix = "shape"
			inhand_icon_state = "cosmoline"
			worn_icon_state = "cosmoline"
			gum_chance = 95
			blood_level_per_clean = 5
			clean_chance = 20
			clean_success = "You clean enough cosmoline off to actually see the rifle now."
			clean_fail = "The rag is drenched without a whole lot of visible progress."
		if(6)
			name = "large glob of cosmoline"
			desc = "This impressive sticky mass of cosmoline has the vague silhouette of a rifle inside it."
			cosmoline_suffix = "glob"
			inhand_icon_state = "cosmoline"
			worn_icon_state = "cosmoline"
			gum_chance = 99
			blood_level_per_clean = 5
			clean_chance = 15
			clean_success = "You've made some progress, the glob is now somewhat rifle shaped."
			clean_fail = "The rag is soaked in a single pass but the glob remains largely unchanged."
		if(7)
			name = "immense mass of cosmoline"
			desc = "A truly enormous blob of cosmoline. It almost looks alive! When the light shines on it just right you can see the outline of a rifle inside. You might be able to find it with a rag."
			cosmoline_suffix = "mass"
			inhand_icon_state = "cosmoline"
			worn_icon_state = "cosmoline"
			gum_chance = 99
			blood_level_per_clean = 5
			clean_chance = 10
			clean_success = "You've made some progress, the glob is now somewhat rifle shaped."
			clean_fail = "The rag is soaked in a single pass but the glob remains largely unchanged."
		if(8)
			name = "monolithic pillar of cosmoline"
			desc = "Legends say that somewhere within this vast blob of cosmoline lies a perfectly preserved mosin without a single flake of rust. You could try to find it with a rag, but this might be better served as a shrine."
			cosmoline_suffix = "pillar"
			inhand_icon_state = "cosmoline"
			worn_icon_state = "cosmoline"
			gum_chance = 99
			blood_level_per_clean = 10
			clean_chance = 5
			clean_success = "You've removed a fair amount of mass, but there's still a lot of cosmoline remaining."
			clean_fail = "Your rag barely makes a dent in the ocean of cosmoline before you."
		else
			name = "ERROR"
	update_appearance()

/obj/item/gun/ballistic/rifle/mosin/Initialize(mapload)
	. = ..()
	update_cosmoline()

/obj/item/gun/ballistic/rifle/mosin/standard
	cosmoline_level = 1

/obj/item/gun/ballistic/rifle/mosin/random

/obj/item/gun/ballistic/rifle/mosin/random/Initialize(mapload)
	if(prob(95))
		cosmoline_level = rand(1,5)
	else if(prob(80))
		cosmoline_level = 6
	else if(prob(80))
		cosmoline_level = 7
	else
		cosmoline_level = 8
	. = ..()

/obj/item/gun/ballistic/rifle/mosin/attackby(obj/item/rag/I, mob/living/user)
	if(istype(I))
		if(cosmoline_level <= 0)
			to_chat(user, "The rifle is already in perfect condition!")
			return
		if(I.blood_level > 10-blood_level_per_clean)
			to_chat(user, "The rag is filthy and needs wrung out before you continue cleaning.")
			return
		if(do_after(user, 3 SECONDS, target = I))
			if(prob(clean_chance))
				to_chat(user, clean_success)
				cosmoline_level -= 1
				update_cosmoline()
			else
				to_chat(user, clean_fail)
			I.blood_level += blood_level_per_clean

/obj/item/gun/ballistic/rifle/mosin/update_overlays()
	. = ..()
	if(cosmoline_level > 0)
		. += "[initial(icon_state)]_[cosmoline_suffix]"

/obj/item/gun/ballistic/rifle/mosin/rack(mob/user = null)
	if(gum_chance)
		if(prob(gum_chance / 2)) // not as big a chance as when trying to fire it
			balloon_alert(loc, "gummed up!")
			playsound(loc,'sound/items/weapons/throwtap.ogg', 75, TRUE)
			return FALSE
	. = ..()

///////////////////////
// BOLT ACTION RIFLE //
///////////////////////

/obj/item/gun/ballistic/rifle/boltaction
	name = "\improper Sakhno Precision Rifle"
	desc = "A Sakhno Precision Rifle, a bolt action weapon that was (and certainly still is) popular with \
		frontiersmen, cargo runners, private security forces, explorers, and other unsavoury types. This particular \
		pattern of the rifle dates back all the way to 2440."
	sawn_desc = "A sawn-off Sakhno Precision Rifle, popularly known as an \"Obrez\". \
		There was probably a reason it wasn't manufactured this short to begin with. \
		Despite the terrible nature of the modification, the weapon seems otherwise in good condition."

	icon_state = "sakhno"
	inhand_icon_state = "sakhno"
	worn_icon_state = "sakhno"

	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	can_be_sawn_off = TRUE
	weapon_weight = WEAPON_HEAVY
	need_bolt_lock_to_interact = TRUE
	var/jamming_chance = 20
	var/unjam_chance = 10
	var/jamming_increment = 5
	var/jammed = FALSE
	var/can_jam = FALSE

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/boltaction/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 41, offset_y = 14, bayonet_overlay = "bayonet_thin")

/obj/item/gun/ballistic/rifle/boltaction/sawoff(mob/user)
	. = ..()
	if(.)
		spread = 36
		SET_BASE_PIXEL(0, 0)
		update_appearance()

/obj/item/gun/ballistic/rifle/boltaction/attack_self(mob/user)
	if(jammed)
		if(prob(unjam_chance))
			jammed = FALSE
			unjam_chance = initial(unjam_chance)
		else
			unjam_chance += 10
			balloon_alert(user, "jammed!")
			playsound(user,'sound/items/weapons/jammed.ogg', 75, TRUE)
			return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/process_fire(mob/user)
	if(can_jam)
		if(chambered.loaded_projectile)
			if(prob(jamming_chance))
				jammed = TRUE
			jamming_chance += jamming_increment
			jamming_chance = clamp (jamming_chance, 0, 100)
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/blow_up(mob/user)
	. = FALSE
	if(chambered?.loaded_projectile)
		process_fire(user, user, FALSE)
		. = TRUE

/obj/item/gun/ballistic/rifle/boltaction/harpoon
	name = "ballistic harpoon gun"
	desc = "A weapon favored by carp hunters, but just as infamously employed by agents of the Animal Rights Consortium against human aggressors. Because it's ironic."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "speargun"
	inhand_icon_state = "speargun"
	worn_icon_state = "speargun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/harpoon
	fire_sound = 'sound/items/weapons/gun/sniper/shot.ogg'
	can_be_sawn_off = FALSE

	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/boltaction/surplus
	name = "\improper Sakhno M2442 Army"
	desc = "A modification of the Sakhno Precision Rifle, \"Sakhno M2442 Army\" is stamped into the side. \
		It is unknown what army this pattern of rifle was made for or if it was ever even used by an army \
		of any sort. What you can discern, however, is that its previous owner did not treat the weapon well. \
		For some reason, there's moisture all through the internals."
	sawn_desc = "A sawn-off Sakhno Precision Rifle, popularly known as an \"Obrez\". \
		\"Sakhno M2442 Army\" is stamped into the side of it. \
		There was probably a reason it wasn't manufactured this short to begin with. \
		Cutting the weapon down seems to have not helped with the moisture problem."
	icon_state = "sakhno_tactifucked"
	inhand_icon_state = "slopno"
	worn_icon_state = "slopno"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/surplus
	can_jam = TRUE

/obj/item/gun/ballistic/rifle/boltaction/surplus/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 41, offset_y = 14, bayonet_overlay = "bayonet_thin_surplus")

/obj/item/gun/ballistic/rifle/boltaction/prime
	name = "\improper Sakhno-Zhihao Sporting Rifle"
	desc = "An upgrade and modernisation of the original Sakhno rifle, made with such wonders as \
		modern materials, a scope, and other impressive technological advancements that, to be honest, \
		were already around when the original weapon was designed. Surprisingly for a rifle of this type, \
		the scope actually has magnification, rather than being decorative."
	icon_state = "zhihao"
	inhand_icon_state = "zhihao"
	worn_icon_state = "zhihao"
	can_be_sawn_off = TRUE
	sawn_desc = "A sawn-off Sakhno-Zhihao Sporting Rifle... Doing this was a sin, I hope you're happy. \
		You are now probably one of the few people in the universe to ever hold an \"Obrez Moderna\". \
		All you had to do was take an allen wrench to the stock to take it off. But no, you just had to \
		go for the saw."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/phasic

/obj/item/gun/ballistic/rifle/boltaction/prime/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

/obj/item/gun/ballistic/rifle/boltaction/prime/sawoff(mob/user)
	. = ..()
	if(.)
		name = "\improper Obrez Moderna" // wear it loud and proud

/obj/item/gun/ballistic/rifle/boltaction/donkrifle
	name = "\improper Donk Co. Jezail"
	desc = "A mass-manufactured bolt-action sporting rifle with a distinctively long barrel. Powerful enough to take down a space bear from a thousand paces. The lengthened barrel gives it good accuracy and power, even at range."
	w_class = WEIGHT_CLASS_HUGE
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	icon_state = "jezail"
	inhand_icon_state = "jezail"
	worn_icon_state = "jezail"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/jezail
	can_be_sawn_off = TRUE
	sawn_desc = "A mass-manufactured bolt-action sporting rifle with a distinctively long barrel. Powerful enough to take down a space bear from a thousand paces. Its barrel has been cut off, so its power and accuracy have been impaired."

/obj/item/gun/ballistic/rifle/boltaction/donkrifle/sawoff(mob/user) //the heavy price one pays for fitting this in a backpack
	. = ..()
	if(.)
		projectile_damage_multiplier = 0.75
		spread = 50

/obj/item/gun/ballistic/rifle/rebarxbow
	name = "heated rebar crossbow"
	desc = "A handcrafted crossbow. \
		   Aside from conventional sharpened iron rods, it can also fire specialty ammo made from the atmos crystalizer - zaukerite, metallic hydrogen, and healium rods all work. \
		   Very slow to reload - you can craft the crossbow with a crowbar to loosen the crossbar, but risk a misfire, or worse..."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "rebarxbow"
	inhand_icon_state = "rebarxbow"
	worn_icon_state = "rebarxbow"
	rack_sound = 'sound/items/weapons/gun/sniper/rack.ogg'
	mag_display = FALSE
	empty_indicator = TRUE
	bolt_type = BOLT_TYPE_OPEN
	semi_auto = FALSE
	internal_magazine = TRUE
	can_modify_ammo = FALSE
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_SUITSTORE
	bolt_wording = "bowstring"
	magazine_wording = "rod"
	cartridge_wording = "rod"
	weapon_weight = WEAPON_HEAVY
	initial_caliber = CALIBER_REBAR
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/normal
	fire_sound = 'sound/items/xbow_lock.ogg'
	can_be_sawn_off = FALSE
	tac_reloads = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.2)
	var/draw_time = 3 SECONDS
	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/rebarxbow/rack(mob/user = null)
	if (bolt_locked)
		drop_bolt(user)
		return
	balloon_alert(user, "bowstring loosened")
	playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
	handle_chamber(empty_chamber =  FALSE, from_firing = FALSE, chamber_next_round = FALSE)
	bolt_locked = TRUE
	update_appearance()

/obj/item/gun/ballistic/rifle/rebarxbow/drop_bolt(mob/user = null)
	if(!do_after(user, draw_time, target = src))
		return
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	balloon_alert(user, "bowstring drawn")
	chamber_round()
	bolt_locked = FALSE
	update_appearance()

/obj/item/gun/ballistic/rifle/rebarxbow/shoot_live_shot(mob/living/user)
	..()
	rack()

/obj/item/gun/ballistic/rifle/rebarxbow/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/rebarxbow/shoot_with_empty_chamber(mob/living/user)
	if(chambered || !magazine || !length(magazine.contents))
		return ..()
	drop_bolt(user)

/obj/item/gun/ballistic/rifle/rebarxbow/examine(mob/user)
	. = ..()
	. += "The crossbow is [bolt_locked ? "not ready" : "ready"] to fire."

/obj/item/gun/ballistic/rifle/rebarxbow/update_overlays()
	. = ..()
	if(!magazine)
		. += "[initial(icon_state)]" + "_empty"
	if(!bolt_locked)
		. += "[initial(icon_state)]" + "_bolt_locked"

/obj/item/gun/ballistic/rifle/rebarxbow/forced
	name = "stressed rebar crossbow"
	desc = "Some idiot decided that they would risk shooting themselves in the face if it meant they could have a draw this crossbow a bit faster. Hopefully, it was worth it."
	// Feel free to add a recipe to allow you to change it back if you would like, I just wasn't sure if you could have two recipes for the same thing.
	can_misfire = TRUE
	draw_time = 1.5
	misfire_probability = 25
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/force

/obj/item/gun/ballistic/rifle/rebarxbow/syndie
	name = "syndicate rebar crossbow"
	desc = "The syndicate liked the bootleg rebar crossbow NT engineers made, so they showed what it could be if properly developed. \
			Holds three shots without a chance of exploding, and features a built in scope. Compatible with all known crossbow ammunition."
	icon_state = "rebarxbowsyndie"
	inhand_icon_state = "rebarxbowsyndie"
	worn_icon_state = "rebarxbowsyndie"
	w_class = WEIGHT_CLASS_NORMAL
	initial_caliber = CALIBER_REBAR
	draw_time = 1
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/syndie

/obj/item/gun/ballistic/rifle/rebarxbow/syndie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2) //enough range to at least be useful for stealth

/// PIPE GUNS ///

/obj/item/gun/ballistic/rifle/boltaction/pipegun
	name = "pipegun"
	desc = "A symbol that the true masters of this place are not those who merely inhabit it, but the one willing to twist it towards a killing intent."
	icon_state = "pipegun"
	inhand_icon_state = "pipegun"
	worn_icon_state = "pipegun"
	fire_sound = 'sound/items/weapons/gun/sniper/shot.ogg'
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 8, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 8, /datum/material/cardboard = SHEET_MATERIAL_AMOUNT)
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun

	projectile_damage_multiplier = 1.35
	obj_flags = UNIQUE_RENAME
	can_be_sawn_off = FALSE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	pb_knockback = 3

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/examine_lore, \
		lore_hint = span_notice("You can [EXAMINE_HINT("look closer")] to recall a tale about [src]."), \
		lore = "<b>You were told this story, in hushed tones, from a wizened man in a grey jumpsuit...</b><br><br>\
		It is said that the first slaying committed on a Nanotrasen space station was by an assistant.<br><br>\
		That this act, done by toolbox, maybe spear, was what consigned their kind to a life of destitution, rejection and violence.<br><br>\
		They carry the weight of this act visibly; the grey jumpsuit. Breathing deeply filtered air. And with bloodsoaked yellow hands clenched into fists.<br><br>\
		Eyes, sharp and waiting. Hunters in the dark.<br><br>\
		Eventually, these killing spirits sought to stake a claim on the metal tombs they were trapped within. Rejecting their status. Determined to be something more.<br><br>\
		This weapon is one such tool. And it is a grim one indeed. Wrought from scrap, pulled from the station's walls and floors and the very nails holding it together.<br>\
		<br>\
		It is a symbol that the true masters of this place are not those who merely inhabit it. But the one willing to twist it towards a killing intent." \
	)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 35, offset_y = 10)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/handle_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	. = ..()
	do_sparks(1, TRUE, src)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/pistol
	name = "pipe pistol"
	desc = "It is foolish to think that anyone wearing the grey is incapable of hurting you, simply because they are not baring their teeth."
	icon_state = "pipepistol"
	inhand_icon_state = "pipepistol"
	worn_icon_state = "gun"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 7, /datum/material/cardboard = SHEET_MATERIAL_AMOUNT)
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun/pistol
	projectile_damage_multiplier = 0.50
	spread = 15 //kinda inaccurate
	burst_size = 3 //but it empties the entire magazine when it fires
	burst_delay = 0.3 // and by empties, I mean it does it all at once
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	semi_auto = TRUE

	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/pistol/add_bayonet_point()
	return

/obj/item/gun/ballistic/rifle/boltaction/pipegun/prime
	name = "regal pipegun"
	desc = "To call this 'regal' is a cruel irony. For the only noteworthy quality of nobility is in how it is wielded to kill. \
		All monarchs deserve to be crowned. But none will remember the dead tyrant for the red stain they left on the carpet."
	icon_state = "regal_pipegun"
	inhand_icon_state = "regal_pipegun"
	worn_icon_state = "regal_pipegun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun/prime
	projectile_damage_multiplier = 2
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 9.15,
		/datum/material/wood = SHEET_MATERIAL_AMOUNT *8,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.15,
		/datum/material/cardboard = SHEET_MATERIAL_AMOUNT,
	)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/pistol/prime
	name = "regal pipe pistol"
	desc = "What value is there in honesty towards the dishonest? So that they might twist the arm and slit the wrist? \
		The open palm is no sign of weakness; it is to draw the eyes away from the other hand, lying in wait."
	icon_state = "regal_pipepistol"
	inhand_icon_state = "regal_pipepistol"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun/pistol/prime
	projectile_damage_multiplier = 1
	burst_size = 6 // WHOLE CLIP
	spread = 0

/// MAGICAL BOLT ACTIONS ///

/obj/item/gun/ballistic/rifle/enchanted
	name = "enchanted bolt action rifle"
	desc = "Careful not to lose your head."
	icon_state = "enchanted_rifle"
	inhand_icon_state = "enchanted"
	worn_icon_state = "enchanted_rifle"
	slot_flags = ITEM_SLOT_BACK
	var/guns_left = 30
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/enchanted
	can_be_sawn_off = FALSE

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/enchanted/dropped()
	. = ..()
	guns_left = 0
	magazine = null
	chambered = null

/obj/item/gun/ballistic/rifle/enchanted/proc/discard_gun(mob/living/user)
	user.throw_item(pick(oview(7,get_turf(user))))

/obj/item/gun/ballistic/rifle/enchanted/attack_self()
	return

/obj/item/gun/ballistic/rifle/enchanted/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!.)
		return
	if(guns_left)
		var/obj/item/gun/ballistic/rifle/enchanted/gun = new type
		gun.guns_left = guns_left - 1
		discard_gun(user)
		user.swap_hand()
		user.put_in_hands(gun)
	else
		user.dropItemToGround(src, TRUE)

// SNIPER //

/obj/item/gun/ballistic/rifle/sniper_rifle
	name = "anti-materiel sniper rifle"
	desc = "A boltaction anti-materiel rifle, utilizing .50 BMG cartridges. While technically outdated in modern arms markets, it still works exceptionally well as \
		an anti-personnel rifle. In particular, the employment of modern armored MODsuits utilizing advanced armor plating has given this weapon a new home on the battlefield. \
		It is also able to be suppressed... somehow."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "sniper"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	inhand_icon_state = "sniper"
	worn_icon_state = null
	fire_sound = 'sound/items/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	load_sound = 'sound/items/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/items/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/items/weapons/gun/general/heavy_shot_suppressed.ogg'
	recoil = 2
	accepted_magazine_type = /obj/item/ammo_box/magazine/sniper_rounds
	internal_magazine = FALSE
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	mag_display = TRUE
	tac_reloads = FALSE
	rack_delay = 1 SECONDS
	can_suppress = TRUE
	can_unsuppress = TRUE
	suppressor_x_offset = 3
	suppressor_y_offset = 3

/obj/item/gun/ballistic/rifle/sniper_rifle/examine(mob/user)
	. = ..()
	. += span_warning("<b>It seems to have a warning label:</b> Do NOT, under any circumstances, attempt to 'quickscope' with this rifle.")

/obj/item/gun/ballistic/rifle/sniper_rifle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 4) //enough range to at least make extremely good use of the penetrator rounds

/obj/item/gun/ballistic/rifle/sniper_rifle/reset_fire_cd()
	. = ..()
	if(suppressed)
		playsound(src, 'sound/machines/eject.ogg', 25, TRUE, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(src, 'sound/machines/eject.ogg', 50, TRUE)

/obj/item/gun/ballistic/rifle/sniper_rifle/syndicate
	desc = "A boltaction anti-materiel rifle, utilizing .50 BMG cartridges. While technically outdated in modern arms markets, it still works exceptionally well as \
		an anti-personnel rifle. In particular, the employment of modern armored MODsuits utilizing advanced armor plating has given this weapon a new home on the battlefield. \
		It is also able to be suppressed... somehow. This one seems to have a little picture of someone in a blood-red MODsuit stenciled on it, pointing at a green floppy disk. \
		Who knows what that might mean."
	pin = /obj/item/firing_pin/implant/pindicate

// SKS semi-automatic rifle //

/obj/item/gun/ballistic/rifle/sks
	name = "\improper Sakhno SKS semi-automatic rifle"
	desc = "A revival of the ancient SKS semi-automatic rifle, redesigned to utilize .310 Strilka rounds. Produced to celebrate the \
		establishment of the Third Soviet Union in the Spinward Sector. In the wake of the union's collapse, these weapons now hold a \
		unique place in history amongst the populace of the sector. However, they are strangely rarer than the Sakhno M2442 Army. \
		Frontier settlers are known for owning one of these for hunting purposes. Or fighting off annoying tax collectors."
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "sks"
	worn_icon_state = "sks"
	inhand_icon_state = "sks"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/sks
	need_bolt_lock_to_interact = TRUE
	semi_auto = TRUE
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 0.5
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 8, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 5.5, /datum/material/cardboard = SHEET_MATERIAL_AMOUNT)

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/sks/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 38, offset_y = 12)

/obj/item/gun/ballistic/rifle/sks/chekhov
	name = "\improper Chekhov's SKS semi-automatic rifle"
	desc = "A revival of the ancient SKS semi-automatic rifle, redesigned to utilize .310 Strilka rounds. The name \
		'Chekhov' is engraved in the side of the stock. You feel like this had some kind of significance at one point, \
		but you cannot be sure as to what that might have been. Or whether that true meaning has yet to reveal itself."

/obj/item/gun/ballistic/rifle/sks/empty
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/sks/empty

// lahti-l39 anti material rifle //

/obj/item/gun/ballistic/automatic/lahti
	name = "\improper Lahti L-39"
	desc = "The Lahti L-39, now manufactured in space with better materials making it more portable and reliable- still loaded in the same massive cartridge, \
		this thing was made to go through a tank and come out the other end- imagine what it could do to an exosuit, there's also a completely useless sight which is totally obstructed by the magazine."
	icon = 'icons/obj/weapons/guns/lahtil39.dmi'
	icon_state = "lahtil"
	inhand_icon_state = "sniper"
	worn_icon_state = "sniper"
	fire_sound = 'sound/items/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	load_sound = 'sound/items/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/items/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/items/weapons/gun/general/heavy_shot_suppressed.ogg'
	mag_display = FALSE
	recoil = 15
	w_class = WEIGHT_CLASS_BULKY
	accepted_magazine_type = /obj/item/ammo_box/magazine/lahtimagazine
	fire_delay = 8 SECONDS
	slowdown = 2
	burst_size = 1
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	suppressor_x_offset = 3
	suppressor_y_offset = 3
