// / / / / / / / / / / / / / / / / / / / / / / //
// hand items that instead spawn other things  //
/obj/item/hand_item/spawner
	name = "spawner item"
	desc = "Instead of giving the player this thing, it spawns something else and deletes itself!"
	icon = 'icons/obj/bed.dmi' // the icon doesnt really matter, it wont be shown anyways
	icon_state = "bed"
	var/atom/movable/thing_to_spawn
	var/del_on_ground = FALSE // if TRUE, the thing this spawns will be deleted if it fails to be put in someone's hands
	abstract_type = /obj/item/hand_item/spawner

/obj/item/hand_item/spawner/on_pre_spawn(mob/living/user)
	. = TRUE // stop the rest of the spawn code from running, since we dont actually want to spawn this thing!
	if(!ispath(thing_to_spawn))
		stack_trace("Invalid [thing_to_spawn] in [src] to spawn! Bad! Fix your code!")
		to_chat(user, span_alert("This thing isnt set up to spawn a thing! Call 1-800-IM-CODER with error code: FURRY-NAKED-EXPIE"))
		qdel(src)
		return
	var/atom/movable/spawned = new thing_to_spawn(get_turf(user))
	if(isitem(spawned))
		if(user.put_in_hands(spawned))
			on_spawner_put_in_hands(user, spawned)
		else
			on_spawner_put_on_ground(user, spawned)
	else
		on_spawner_put_on_ground(user, spawned)
	qdel(src) // delete the spawner item, since we dont actually want it to exist

// does something if we already have one of these, returns FALSE to proceed with normal giving, TRUE to stop it
/obj/item/hand_item/spawner/get_path_to_check(mob/living/user)
	return thing_to_spawn

/obj/item/hand_item/spawner/get_path_looseness(mob/living/user)
	return FALSE // strict nonlooseness

/obj/item/hand_item/spawner/proc/on_spawner_put_in_hands(mob/living/user, atom/movable/spawned)
	// override me!

/obj/item/hand_item/spawner/proc/on_spawner_put_on_ground(mob/living/user, atom/movable/spawned)
	if(del_on_ground)
		qdel(spawned)
