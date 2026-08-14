/// / / / / / / ///
/// HAND ITEMS! ///
/// For all of the items that are really just the user's hand used in different ways, mostly (all, really) from emotes
/obj/item/hand_item
	name = "your hand"
	desc = "Gimme five (or however many fingers you have, if you have any)!"
	force = 0
	throwforce = 0
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM
	abstract_type = /obj/item/hand_item
	tap_uses_hitsound = TRUE

	/// am I disabled?
	var/disabled = FALSE
	/// admemes only?
	var/admin_only = FALSE

	/// UI stuff
	/// Icon used for the hud button for this thing
	var/hud_icon = 'modular_coyote/icons/hand_items.dmi' // override this please
	/// Icon state used for the hud button for this thing
	var/hud_icon_state = "default" // this too
	/// Whether the hud icon should be used for this hand item
	var/hud_use = FALSE
	/// Description used for the hud button for this thing
	/// leave blamk to just use the item desc
	var/hud_desc

	/*
	 * TRAIT-SWITCHED BASE ITEM SWITCH TRAIT SYSTEM THING
	 *
	 * use cases:
	 * - a generic *bite that will spawn you the proper biter based on a trait
	 * - a generic hud/button button that does the above thing
	 *
	 * Defined on a 'hub' item that has a set of sub-items that are chosen based on user traits
	 * When the hub item is asked to be given to the player, or is polled for hud button stuff
	 * it will first go through its sub items to determine which one should be used.
	 *
	 * it is defined through a few methods!
	 * - sub_item_master_path: defines the hub item, generally treated as an abstract, though it doesnt have to be
	 * - subitem_paths: list of traits, and the corresponding sub-item that said trait should spawn
	 *   - format: list(TRAIT_BINGUS, /obj/item/hand_item/subitem_path)
	 *
	 * Those two are required for the trait-switched sub-item system to function correctly.
	 * But what if no traits match? Well thats where the default fallback comes into play!!
	 * Theres actually three ways to set it
	 * 1. Just ignore it, the item will default to the hub item itself if nothing is explicitly set as the default.
	 * 2. Set the default_subitem_path variable to the desired sub-item path.
	 * 3. Use a special marker in the subitem_paths list to indicate which sub-item should be the default.
	 *   - just add HI_SUB_DEFAULT = /obj/item/hand_item/subitem_path and it'll make that the deafult
	 *
	 * But what if i dont want to do sub-items?
	 * Just leave subitem_paths and subitem_master_path null
	 *
	 * i swear this was a lot cooler on coyote bayou, where we actually used other tail whackers and such
	 * */
	var/list/subitem_paths
	var/obj/item/hand_item/subitem_master_path
	var/obj/item/hand_item/default_subitem_path
	/*
	 * Required trait for the user to have to actually spawn this thing
	 * If set on a subitem master, this requirement overrides this var for all its subitems.
	 * Though you probably shouldnt set it on subitems directly, just the master hub thing
	 */
	var/required_trait // if set, can only be given if the user has this trait
	/*
	 * Required bodypart slot for the user to have to actually spawn this thing
	 * If set on a subitem master, this requirement overrides this var for all its subitems.
	 * Though you probably shouldnt set it on subitems directly, just the master hub thing
	 */
	var/required_bodypart_slot
	/// Whether this hand item can be stored in an inventory
	var/inventoryable = FALSE
	/// Whether the game should check if you have one out already, and prevent you from equipping another if so
	var/just_one = FALSE // if you should only have one at a time, so you cant dual wield your own butt
	/// Whether this hand item should be deleted if it fails to be given to the user
	var/del_on_fail = TRUE
	/// Whether this hand item can only be obtained in an outside area
	var/outside_only = FALSE // if TRUE, can only be gotten in an outside area

	/// Stuff relating to the template singleton item version of this thing, stored in the subsys
	/// This thing is a template. doesnt really mean much but its a var!
	var/template = FALSE
	/// Used on the template singleton item to track cooldowns for each user, pretty clever huh?
	/// format: list(ckey = time when you can use it again)
	var/list/cool_cooldowns = list() // for things that have cooldowns on their use
	/// Duration in desiseconds for the cooldown of this hand item
	var/cooldown_time = 0 // how long the cooldown is, in seconds. If 0, no cooldown will be applied
	/// Trait that, if the user has it, will override the cooldown for this hand item
	var/cooldown_override_trait // if the user has this trait, cooldowns will not be applied to them
	/// seasonal stuff i guess
	var/list/required_months = list() // if set, only spawns in these months (1-12)
	/// Is it in season? cached for sanic speed i guess? set by init
	var/in_season_cache

/obj/item/hand_item/Initialize(mapload, mob/handholder)
	if(!inventoryable) // cant stuff your butt in your backpack... i guess?
		ADD_TRAIT(src, TRAIT_NO_STORAGE_INSERT, TRAIT_GENERIC)
	if(handholder)
		customize_to_user(handholder)
	// RegisterSignal(src, COMSIG_MOB_MIDDLECLICKON, PROC_REF(on_middleclicked))
	. = ..()

/obj/item/hand_item/Destroy()
	UnregisterSignal(src, COMSIG_MOB_MIDDLECLICKON)
	. = ..()

/obj/item/hand_item/proc/templateify()
	item_flags = NONE
	resistance_flags |= INDESTRUCTIBLE
	template = TRUE
	setup_subitems()

// /obj/item/hand_item/proc/on_middleclicked(mob/living/user)
// 	// default behavior for middle clicking a hand item
// 	return

/// For all of the items that are really just the user's hand used in different ways, mostly (all, really) from emotes
/obj/item/hand_item/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	SEND_SIGNAL(user, COMSIG_LIVING_HAND_ITEM_ATTACK, target_mob)

/// Sets up the subitems for this hand item, based on the subitem master path and other criteria
/// For things that dont have subitems, which is a lot of things, this will essentially do nothing
/obj/item/hand_item/proc/setup_subitems()
	if(!LAZYLEN(subitem_paths))
		return
	if(!ispath(subitem_master_path))
		return
	// past this point, we have subitems! Master holds the data, the rest dont!
	if(src.type != subitem_master_path)
		subitem_paths.Cut() // remove all subitem paths for non-master items
		return // only the master item gets this data, just so nothing else can go wrong
	// first we gotta find the default
	if(!ispath(default_subitem_path))
		for(var/trait2check in subitem_paths)
			if(trait2check == HI_SUB_DEFAULT)
				default_subitem_path = subitem_paths[trait2check]
				break
	if(!ispath(default_subitem_path))
		default_subitem_path = subitem_master_path
	// all done!

/// Gives the user a copy of this thing, or a suitable replacement if one exists
/// Returns the new hand item if successful, FALSE otherwise
/obj/item/hand_item/proc/give_to_user(mob/living/user, just_checking = FALSE, is_replacement = FALSE)
	if(!user)
		return FALSE
	if(!is_replacement)
		var/obj/item/hand_item/instead = find_suitable_replacement_if_any(user)
		if(istype(instead))
			return instead.give_to_user(user, just_checking, TRUE)
	if(type == abstract_type)
		return FALSE
	if(admin_only && !is_admin(user))
		return FALSE
	if(!item_is_in_season(user, just_checking))
		return FALSE
	if(!user_is_outside(user, just_checking))
		return FALSE
	if(!has_required_trait(user, just_checking))
		return FALSE
	if(is_on_cooldown(user, just_checking))
		return FALSE
	if(!has_an_available_hand(user, just_checking))
		return FALSE
	if(does_user_already_have_one(user, just_checking))
		return FALSE
	if(just_checking)
		return TRUE
	var/obj/item/hand_item/new_thing = new src.type(user, user)
	if(new_thing.on_pre_spawn(user))
		return FALSE
	return new_thing.on_post_spawn(user)

/// Retrieves the proper hand item to be used for hudding
/// returns a hand item template
/obj/item/hand_item/proc/get_hud_template(mob/living/user, is_replacement = FALSE)
	if(!user)
		return null
	// first, get the appropriate HUD template for the user
	if(!is_replacement)
		var/obj/item/hand_item/instead = find_suitable_replacement_if_any(user)
		if(istype(instead))
			return instead.get_hud_template(user, TRUE)
	if(!hud_use)
		return null
	var/hud_icon_use = hud_icon || icon
	var/hud_icon_state_use = hud_icon_state || icon_state
	return list(
		HI_HUD_PATH = src.type,
		HI_HUD_ICON = hud_icon_use,
		HI_HUD_ICON_STATE = hud_icon_state_use,
	)

/// Checks if the hand item should be shown in the UI menu for the user
/// true if it should be shown, false if it should not
/obj/item/hand_item/proc/should_show_up_in_ui_menu(mob/living/user)
	if(!user)
		return FALSE
	if(!hud_use)
		return FALSE
	if(type == abstract_type)
		return FALSE
	if(!has_required_trait(user, TRUE))
		return FALSE
	if(!item_is_in_season(user, TRUE))
		return FALSE
	if(!user_is_outside(user, TRUE))
		return FALSE
	return TRUE

/// Checks if the hand item should only be used outdoors and if the user meets that condition
/// true if theyre outside, false if they arent outside
/// todo: make space be considered something other than outdoors or indoors, cus its space
/obj/item/hand_item/proc/user_is_outside(mob/living/user, just_checking = FALSE)
	return TRUE // todo: make this both work, and also matter
	// if(!outside_only)
	// 	return TRUE
	// if(is_outdoors(user))
	// 	return TRUE
	// if(!just_checking)
	// 	on_failed_give(user, HI_OUTSIDE_ONLY)
	// return FALSE

/// tis it the season to use this thing?
/// true if tis, false if tisnt
/obj/item/hand_item/proc/item_is_in_season(mob/living/user, just_checking = FALSE)
	if(!isnull(in_season_cache))
		if(!in_season_cache && !just_checking)
			on_failed_give(user, HI_OUT_OF_SEASON)
		return in_season_cache
	if(!LAZYLEN(required_months))
		in_season_cache = TRUE
		return in_season_cache
	var/time = world.timeofday
	var/MM = text2num(time2text(time, "MM"))
	if(MM in required_months)
		in_season_cache = TRUE
		return in_season_cache
	if(!just_checking)
		on_failed_give(user, HI_OUT_OF_SEASON)
	in_season_cache = FALSE
	return in_season_cache

/// Checks if the hand item is currently on cooldown for the user
/// true if on cooldown, false otherwise
/obj/item/hand_item/proc/is_on_cooldown(mob/living/user, just_checking = FALSE)
	if(!cooldown_time)
		return FALSE
	if(cooldown_override_trait && HAS_TRAIT(user, cooldown_override_trait))
		return FALSE
	var/time_can_use_it = LAZYACCESS(cool_cooldowns, user.ckey)
	if(time_can_use_it > world.time)
		if(!just_checking)
			on_failed_give(user, HI_ON_COOLDOWN)
		return TRUE
	return FALSE

/// Tries to find the appropirate replacement hand item for the user based on their traits and the hand item's associated trait settings.
/// Returns the suitable replacement hand item if one exists, otherwise returns FALSE.
/obj/item/hand_item/proc/find_suitable_replacement_if_any(mob/living/user, just_checking)
	if(!LAZYLEN(subitem_paths))
		return FALSE
	var/obj/item/hand_item/subitem
	for(var/trait2check in subitem_paths)
		if(HAS_TRAIT(user, trait2check))
			subitem = subitem_paths[trait2check]
			break
	if(!subitem)
		subitem = default_subitem_path
		if(!subitem)
			stack_trace("Failed to find a suitable subitem for hand item [src]. Check the subitem paths for [src]. ERROR CODE: PASSIONTAIL-ISLE")
			return FALSE
	// nab the appropriate hand item from the subbysis
	subitem = SShanditems.get_hand_item_template(subitem)
	if(!istype(subitem))
		stack_trace("Failed to retrieve hand item template for subitem path [subitem]. Check the hand item definitions. ERROR CODE: PIKACHU-INSIDE-LAPRAS")
		return FALSE
	return subitem

/// Checks if the user has the required trait to use this thing
/// true if do, false if dont
/obj/item/hand_item/proc/has_required_trait(mob/living/user, just_checking = FALSE)
	if(!required_trait)
		return TRUE
	if(HAS_TRAIT(user, required_trait))
		return TRUE
	if(!just_checking)
		on_failed_give(user, HI_MISSING_REQUIRED_TRAIT)
	return FALSE

/// Checks if the user has both hands occupied.
/// TruE if hands full, FALSE otherwise.
/obj/item/hand_item/proc/has_an_available_hand(mob/living/user, just_checking = FALSE)
	if(user.get_active_held_item() && user.get_inactive_held_item())
		if(!just_checking)
			on_failed_give(user, HI_HANDS_FULL)
		return FALSE
	return TRUE

/// happens after the item is created, but before it is given to user
/// returns TRUE to stop the give, FALSE to continue with normal giving
/// can be used to spawn something else instead, or to cancel giving entirely
/obj/item/hand_item/proc/on_pre_spawn(mob/living/user)
	return FALSE

/// happens after the item is done spawning and is, ideally, in the players hands
/// returns TRUE if the thing was given, FALSE if it wasnt
/obj/item/hand_item/proc/on_post_spawn(mob/living/user)
	if(user.put_in_hands(src))
		return on_successful_give(user, HI_GAVE)
	else
		return on_failed_give(user, HI_HANDS_FULL)

/// CHecks if the user already has one of these things, and if so, TRUEes it
/// false means they dont got one, or they can have multiplez
/obj/item/hand_item/proc/does_user_already_have_one(mob/living/user, just_checking = FALSE)
	if(!just_one)
		return FALSE
	var/loose_pathing = get_path_looseness(user)
	var/obj/item/path_to_check = src.type
	var/obj/item/base_path_to_check = get_path_to_check(user)
	var/obj/item/existing
	for(var/obj/item/AM as anything in (user.get_all_contents_type(src.type)))
		if(loose_pathing)
			if(ispath(AM.type, path_to_check) || ispath(AM.type, base_path_to_check))
				existing = AM
				break
		else
			if(AM.type == path_to_check || AM.type == base_path_to_check)
				existing = AM
				break
	if(existing)
		return on_already_has_one(user, existing, just_checking)
	else
		return FALSE

/// Called when the user already has one of these items, allows for handling the situation and optionally stopping the give.
/obj/item/hand_item/proc/on_already_has_one(mob/living/user, obj/item/hand_item/existing, just_checking = FALSE)
	if(!just_one)
		return FALSE
	if(!just_checking)
		on_failed_give(user, HI_ALREADY_HAVE_ONE)
	return TRUE

/obj/item/hand_item/proc/get_path_to_check(mob/living/user)
	if(subitem_master_path)
		return subitem_master_path
	if(default_subitem_path)
		return default_subitem_path
	return type

/obj/item/hand_item/proc/get_path_looseness(mob/living/user)
	return TRUE

/// lets u do a thing to customize the thing to the user
/// used for making butts look like your butt, also tails, maybe more uwu
/obj/item/hand_item/proc/customize_to_user(mob/user)

/// Called after the item has been successfully given to the user, allows for additional customization or effects.
/obj/item/hand_item/proc/on_successful_give(mob/user, reason)
	on_successful_give_message(user, reason)
	return TRUE

/// Called to display a message to the user after the item has been successfully given.
/obj/item/hand_item/proc/on_successful_give_message(mob/user, reason)
	switch(reason)
		if(HI_GAVE)
			to_chat(user, span_notice("You ready your [src]!"))
		else
			to_chat(user, span_notice("You got ye [src]!"))

/// Called when the item fails to be given to the user, allows for cleanup or additional effects.
/obj/item/hand_item/proc/on_failed_give(mob/user, reason)
	on_failed_give_message(user, reason)
	if(del_on_fail && !template)
		qdel(src)
	return TRUE

/// Called to display a message to the user after the item fails to be given.
/obj/item/hand_item/proc/on_failed_give_message(mob/user, reason)
	switch(reason)
		if(HI_OUTSIDE_ONLY)
			to_chat(user, span_alert("You can't get ye [src] here! Try going outside?"))
		if(HI_OUT_OF_SEASON)
			to_chat(user, span_alert("You can't get ye [src] right now! Maybe try again in a different season?"))
		if(HI_ON_COOLDOWN)
			var/time_left = SShanditems.get_cooldown_time_left(user, src)
			to_chat(user, span_alert("You can't get ye [src] right now! Try again in [DisplayTimeText(time_left)]?"))
		if(HI_MISSING_REQUIRED_TRAIT)
			to_chat(user, span_alert("You can't get ye [src]! You lack the necessary trait to use it!"))
		if(HI_ALREADY_HAVE_ONE)
			to_chat(user, span_alert("You can't get ye [src]! You already have one!"))
		if(HI_HANDS_FULL)
			to_chat(user, span_alert("You can't get ye [src]! Your hands are full! Try emptying one of them?"))
		else
			to_chat(user, span_alert("You can't get ye [src]!"))
