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
	// generate_grope_kissers()
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

// /datum/controller/subsystem/handitems/proc/generate_grope_kissers()
// 	if(LAZYLEN(gropekissers))
// 		QDEL_LIST_ASSOC_VAL(gropekissers)
// 	for(var/booby in typesof(/datum/grope_kiss_MERP))
// 		var/datum/grope_kiss_MERP/gkm = new booby()
// 		gropekissers[gkm.type] = gkm

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
/// now in screen-object flavor!
/datum/controller/subsystem/handitems/proc/get_hud_object_data(mob/living/user)
	if(!user)
		return null
	var/list/hi_candidates = list()
	for(var/hi in hand_items)
		var/obj/item/hand_item/hi_temp = get_hand_item_template(hi)
		var/list/hi_hud_data = hi_temp.get_hud_template(user)
		if(!LAZYLEN(hi_hud_data)) // dont show
			continue
		hi_candidates |= list(hi_hud_data)
	if(!LAZYLEN(hi_candidates))
		return null
	// sort candidates by name, alphabetically
	hi_candidates = sort_list(hi_candidates, /proc/cmp_hud_name)
	// spam a buinch of screen object buttons
	return hi_candidates // your problem now!


/proc/cmp_hud_name(list/a, list/b)
	var/obj/item/hand_item/a_hi = a[HI_HUD_PATH]
	var/obj/item/hand_item/b_hi = b[HI_HUD_PATH]
	return sorttext(a_hi.name, b_hi.name)


/atom/movable/screen/hand_item_folder
	name = "hand items"
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "hand_item_folder_closed"
	screen_loc = "EAST-4:22,SOUTH+1:7"
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/open = FALSE
	/// the px to push upward for each hand item
	/// px height of button, + padding underneath
	var/pushup_px = 15 + 1
	var/list/clickies = list()

/atom/movable/screen/hand_item_folder/Click(location, control, params)
	toggle_it()

/atom/movable/screen/hand_item_folder/proc/toggle_it()
	var/mob/pwner = hud.mymob
	if(!pwner)
		return
	if(!SShanditems.initialized)
		to_chat(pwner, span_abductor("Dunno how you did this, but this thing isnt ready yet!"))
		return
	if(open)
		close_folder(pwner)
	else
		open_folder(pwner)

/atom/movable/screen/hand_item_folder/proc/open_folder(mob/user)
	if(LAZYLEN(clickies)) // oh dear
		close_folder(user)
		return
	var/list/hitem_datas = SShanditems.get_hud_object_data(user)
	if(!LAZYLEN(hitem_datas))
		var/msg = "Oh dear, you dont have any hand items you can use! How embarrassing!"
		to_chat(user, span_alert(msg))
		balloon_alert(user, msg)
		return
	var/i = 1
	for(var/list/hitem_data in hitem_datas)
		// create a new hand item clicky for each hand item
		var/atom/movable/screen/hand_item_clicky/hi_clicky = new()
		hi_clicky.hand_itemize(src, hitem_data, i)
		i++
		clickies += hi_clicky
	icon_state = "hand_item_folder_open"
	open = TRUE

/atom/movable/screen/hand_item_folder/proc/close_folder(mob/user)
	if(!LAZYLEN(clickies))
		return
	for(var/atom/movable/screen/hand_item_clicky/clecky in clickies)
		qdel(clecky)
	clickies = list()
	icon_state = "hand_item_folder_closed"
	open = FALSE

/atom/movable/screen/hand_item_folder/proc/subthing_got_clicked()
	close_folder(hud.mymob)


/// defines one of many hand item clicky buttons on screen
/// generates, and listens to, the hand item folder button
/atom/movable/screen/hand_item_clicky
	name = "hand item clicky"
	desc = "Click me to give you whatever this is!"
	icon = 'modular_coyote/icons/hand_items.dmi'
	icon_state = "hand_item_clicky"
	screen_loc = /atom/movable/screen/hand_item_folder::screen_loc
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/obj/item/hand_item/my_hand_item
	var/atom/movable/screen/hand_item_folder/parent

/atom/movable/screen/hand_item_clicky/Destroy()
	set_parent(null)
	parent = null
	. = ..()

/atom/movable/screen/hand_item_clicky/MouseEntered(location, control, params)
	. = ..()
	openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/hand_item_clicky/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/atom/movable/screen/hand_item_clicky/Click(location, control, params)
	var/mob/user = parent.hud.mymob
	if(!user)
		return
	SShanditems.give_hand_item(user, my_hand_item)
	parent.subthing_got_clicked()

/atom/movable/screen/hand_item_clicky/proc/hand_itemize(
	atom/movable/screen/hand_item_folder/to_parent,
	list/hitem_data = list(),
	i)
	set_parent(to_parent)
	// screen_loc = shift_screen_loc(parent.screen_loc, 0, parent.pushup_px * i)
	transform = transform.Translate(0, parent.pushup_px * i)
	my_hand_item  = hitem_data[HI_HUD_PATH]
	name          = my_hand_item::name
	desc          = my_hand_item::desc
	icon          = hitem_data[HI_HUD_ICON]
	icon_state    = hitem_data[HI_HUD_ICON_STATE]
	parent.hud.mymob.client.screen += src

/atom/movable/screen/hand_item_clicky/proc/set_parent(new_value)
	if(parent)
		UnregisterSignal(parent, COMSIG_QDELETING)
	parent = new_value
	if(parent)
		RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(handle_parent_del))

/atom/movable/screen/hand_item_clicky/proc/handle_parent_del()
	SIGNAL_HANDLER
	set_parent(null)


