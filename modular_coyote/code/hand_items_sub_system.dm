GLOBAL_LIST_INIT(outdoor_tiles, list(
	/turf/open/lava,
	/turf/open/water,
))

/proc/is_outdoors(atom/A)
	var/turf/T = get_turf(A)
	if(!T)
		return FALSE
	var/area/areo = get_area(T)
	if(!areo)
		return FALSE
	if(areo.outdoors)
		return TRUE
	for(var/outdoor_path in GLOB.outdoor_tiles)
		var/turf/T_est = outdoor_path
		if(istype(T, T_est))
			return TRUE
	return FALSE

SUBSYSTEM_DEF(handitems)
	name = "HandItems"
	flags = SS_NO_FIRE

	/// our loaded hand items, keyed cutely
	/// list(/path/to/hand/item = /instantiated/hand/item)
	var/list/hand_items = list()
	var/list/gropekissers = list()
	var/list/hudcheck_items = list()
	var/allow_hud_buttons = TRUE
	var/list/hud_map = list()

/datum/controller/subsystem/handitems/Initialize(start_timeofday)
	generate_hand_items()
	generate_grope_kissers()
	generate_hudcheck_items()
	to_chat(world, span_abductor("Initialized [LAZYLEN(hand_items)] hand items and [LAZYLEN(gropekissers)]-ish ways to fondle your friends!"))

/// Generate our hand items, and store them in our list for later use
/datum/controller/subsystem/handitems/proc/generate_hand_items()
	if(LAZYLEN(hand_items))
		QDEL_LIST_ASSOC_VAL(hand_items)
	for(var/gooby in typesof(/obj/item/hand_item))
		var/obj/item/hand_item/hi = new gooby()
		hi.templateify()
		hand_items[hi.type] = hi

/datum/controller/subsystem/handitems/proc/generate_grope_kissers()
	if(LAZYLEN(gropekissers))
		QDEL_LIST_ASSOC_VAL(gropekissers)
	for(var/booby in typesof(/datum/grope_kiss_MERP))
		var/datum/grope_kiss_MERP/gkm = new booby()
		gropekissers[gkm.type] = gkm

/// spits out a list of all the types of hand items to attempt extracting hud buttons
/datum/controller/subsystem/handitems/proc/generate_hudcheck_items()
	if(LAZYLEN(hudcheck_items))
		hudcheck_items = list()
	var/list/candidates = list()
	var/list/subitems = list()
	for(var/hi_cand in hand_items)
		var/obj/item/hand_item/hi = hand_items[hi_cand]
		if(!hi.hud_use)
			continue
		candidates += hi.type
		// check if its got subitems
		if(LAZYLEN(hi.subitem_paths))
			subitems |= hi.subitem_paths
			subitems -= hi.subitem_master_path
	candidates -= subitems

/datum/controller/subsystem/handitems/proc/grope_kiss(obj/item/hand_item/hitem, mob/living/user, mob/living/target)
	// if(!istype(hitem))
	// 	return FALSE
	// if(!hitem.horny_mode)
	// 	return FALSE
	// if(!LAZYLEN(gropekissers))
	// 	return FALSE
	// var/datum/grope_kiss_MERP/grope = LAZYACCESS(gropekissers, hitem.grope)
	// if(!grope)
	// 	return FALSE
	// var/list/used_grope = grope.make_visible_message(user, target, hitem.lastgrope)
	// if(used_grope)
	// 	hitem.lastgrope = used_grope
	// 	return TRUE

/datum/controller/subsystem/handitems/proc/give_hand_item(mob/living/user, obj/item/hand_item/hitem)
	if(!user)
		return FALSE
	if(!isliving(user))
		to_chat(user, span_alert("You're a ghost (or something), shoo!"))
		return FALSE
	if(istype(hitem, /obj/item/hand_item))
		hitem = hitem.type
	if(!ispath(hitem))
		to_chat(user, span_phobia("[hitem] is not a valid path to a hand item! Call 1-800-IM-CODER and tell them error code BIG-STRONG-ALPHA-THRUMBO"))
		stack_trace("Invalid hand item path given to give_hand_item: [hitem]")
		return FALSE
	var/obj/item/hand_item/hi_temp = get_hand_item_template(hitem)
	if(!hi_temp)
		to_chat(user, span_phobia("No template found for [hitem]! Call 1-800-IM-CODER and tell them error code WILD-SLEEPY-BOOMRAT"))
		stack_trace("No template found for [hitem] in give_hand_item: [hitem]")
		return FALSE
	return hi_temp.give_to_user(user)

/datum/controller/subsystem/handitems/proc/get_hand_item_template(obj/item/hand_item/hi_path)
	if(istype(hi_path, /obj/item/hand_item))
		hi_path = hi_path.type
	if(!ispath(hi_path))
		to_chat(world, span_phobia("[hi_path] is not a valid path to a hand item! Call 1-800-IM-CODER and tell them error code BIG-STRONG-ALPHA-THRUMBO"))
		stack_trace("Invalid hand item path given to get_hand_item_template: [hi_path]")
		return null
	var/obj/item/hand_item/hi_temp = LAZYACCESS(hand_items, hi_path)
	if(!hi_temp)
		to_chat(world, span_phobia("No template found for [hi_path]! Call 1-800-IM-CODER and tell them error code WILD-SLEEPY-BOOMRAT"))
		stack_trace("No template found for [hi_path] in get_hand_item_template: [hi_path]")
		return null
	return hi_temp

/datum/controller/subsystem/handitems/proc/get_cooldown_time_left(mob/living/user, obj/item/hand_item/hi)
	if(!user || !hi)
		return 0
	if(!istype(hi))
		return 0
	var/datum/weakref/user_ref = WEAKREF(user)
	var/obj/item/hand_item/hi_temp = get_hand_item_template(hi.type)
	var/time_can_use_it = LAZYACCESS(hi_temp.cooldowns, user_ref)
	if(time_can_use_it > world.time)
		return time_can_use_it - world.time
	else
		return 0

/// generates the popup thingy for the hand items on the ui doodle
/datum/controller/subsystem/handitems/proc/get_hand_item_popup(mob/living/user, atom/origin)
	if(!user)
		return null
	var/list/hi_candidates = list()




	for(var/hi in hand_items)
		var/obj/item/hand_item/hi_temp = get_hand_item_template(hi)
		var/obj/item/hand_item/hi_huduse = hi_temp.get_hud_template(user)
		if(!hi_huduse) // dont show
			continue
		hi_candidates |= hi_temp
	if(!LAZYLEN(hi_candidates))
		return null
	// sort candidates by name, alphabetically
	hi_candidates = sort_list(hi_candidates, /proc/cmp_name_asc)
	// got the stuff, now to make the popup
	var/list/popup_choices = list()
	var/list/popup_decoder = list()
	for(var/obj/item/hand_item/hi_cand in hi_candidates)
		if(!hud_map[hi_cand.type])
			var/icon/ico_use = hi_cand.hud_icon || hi_cand.icon
			var/ico_state_use = hi_cand.hud_icon_state || hi_cand.icon_state
			var/image/img_use = image(icon = ico_use, icon_state = ico_state_use)
			hud_map[hi_cand.type] = img_use
		popup_choices["[hi_cand.name]"] = hud_map[hi_cand.type]
		popup_decoder["[hi_cand.name]"] = hi_cand.type
	var/choice = show_radial_menu(user, origin, popup_choices, radius = 28, ultradense = TRUE, linedir = NORTH)
	if(!choice || !isliving(user))
		return
	var/true_hi_cand_type = popup_decoder[choice]
	return SShanditems.give_hand_item(user, true_hi_cand_type)




