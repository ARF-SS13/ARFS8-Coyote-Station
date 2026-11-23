
//Bluespace mailbox to emulate how mail is delievered from ss14

/obj/structure/mailbox
	name = "tele-mailbox"
	desc = "A fancy bluespace transduction endpoint tuned to the encrypted TeleSci frequencies commonly \
		used for interstellar transport of small parcels and messages, cleverly disguised as an ordinary mailbox. \
		When active, it will periodically receive various bits of mail from all over the greater stellar neighborhood, \
		often addressed to those on this very station! From who? Doesn't really matter, but they are paying for safe delivery!"
	icon_state = "mailbox"
	icon = 'modular_coyote/icons/mailbox.dmi'
	max_integrity = 300
	move_resist = MOVE_FORCE_VERY_STRONG
	anchored = TRUE
	var/on = FALSE
	var/max_nearby_mails = 20
	var/per_mail_interval = 5 MINUTES
	var/timeleft_till_next_mail = 0
	var/help_document_delay = 20 SECONDS
	var/help_document_cooldown = 0

	//Likely the easiest way to do this, Dan, is to pull the mail spawner from the cargo shuttle and apply it more directly here.
	//We do have access to a few icon states, specifically 'flag' & 'light', which apply a red flag and a green light.
	// I suppose this thing shouldn't work if unpowered, so the light has to be on to be active, perhaps right clicking it turns the machine off?
	// Probably best to just have it spawn its mail on top of itself, like the ss14 mailbox, but what to use the flag for?
	// Perhaps we could use it as a replacement for the bird system?  For now we could keep the flag system turned off though.

/obj/structure/mailbox/Initialize(mapload)
	. = ..()
	// turn it on!
	toggle_onness()

/obj/structure/mailbox/examine(mob/user)
	. = ..()
	. += span_notice("If you leave a crate near this thing, it will automatically stack the mail on top of it!")
	. += span_notice("This doesn't require any power to operate, it is merely a passive receiver of interstellar mail!")
	if(too_many_nearby_mails())
		. += span_notice("There are too many nearby mails! The flag will be raised to indicate this.")

/obj/structure/mailbox/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_LMB] = "Toggle mailbox power"
	context[SCREENTIP_CONTEXT_RMB] = "Toggle floor clamps"
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Print Help Document"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/mailbox/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	toggle_onness(user)

/obj/structure/mailbox/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	toggle_floor_clamps(user)

/obj/structure/mailbox/click_alt(mob/user)
	. = ..()
	print_help_document(user)

/obj/structure/mailbox/proc/toggle_onness(mob/user)
	on = !on
	if(on)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	do_quantum_sparks(1, FALSE, src)
	update_icon()

/obj/structure/mailbox/update_overlays()
	if(on)
		. += mutable_appearance(icon, "light")
		. += emissive_appearance(icon, "light", src)
	if(too_many_nearby_mails())
		. += mutable_appearance(icon, "flag")
		. += emissive_appearance(icon, "flag", src)
	. = ..()

/obj/structure/mailbox/process(seconds_per_tick)
	timeleft_till_next_mail -= (seconds_per_tick SECONDS)
	if(timeleft_till_next_mail <= 0)
		// spawn mail here
		timeleft_till_next_mail = per_mail_interval


/obj/structure/mailbox/proc/too_many_nearby_mails()
	var/numaround = 0
	for(var/obj/item/mail/m in range(2, src))
		numaround++
		if(numaround > max_nearby_mails)
			return TRUE
	return FALSE

/obj/structure/mailbox/proc/print_help_document(mob/user)
	if(help_document_cooldown > world.time)
		return
	help_document_cooldown = world.time + help_document_delay
	var/obj/item/paper/mail_help_doc/mhd = new(get_turf(src))





/obj/item/paper/mail_help_doc
	name = "Interstellar Mail for Cute Mail Deliverers"
	default_raw_text = {"
	<center>MAIL AND YOU</center>
	<hr>
	<p>
	"}



