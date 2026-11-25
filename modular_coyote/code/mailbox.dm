
//Bluespace mailbox to emulate how mail is delievered from ss14

/obj/structure/mailbox
	name = "tele-mailbox"
	desc = "A fancy bluespace transduction endpoint tuned to the encrypted TeleSci frequencies commonly \
		used for interstellar transport of small parcels and messages, cleverly disguised as an ordinary mailbox. \
		When active, it will periodically receive various bits of mail from all over the greater stellar neighborhood, \
		often addressed to those on this very station! From who? Doesn't really matter, but they are paying for safe delivery!"
	icon_state = "mailbox"
	icon = 'modular_coyote/icons/mailbox.dmi'
	max_integrity = 30000
	density = TRUE
	anchored = TRUE
	var/on = FALSE
	var/max_nearby_mails = 20
	var/per_mail_interval = 15 MINUTES
	var/min_mail_per_spawn = 1
	var/max_mail_per_spawn = 20
	var/timeleft_till_next_mail = 0
	var/help_document_delay = 20 SECONDS
	var/help_document_cooldown = 0
	var/spark_cooldown = 0

	//Likely the easiest way to do this, Dan, is to pull the mail spawner from the cargo shuttle and apply it more directly here.
	//We do have access to a few icon states, specifically 'flag' & 'light', which apply a red flag and a green light.
	// I suppose this thing shouldn't work if unpowered, so the light has to be on to be active, perhaps right clicking it turns the machine off?
	// Probably best to just have it spawn its mail on top of itself, like the ss14 mailbox, but what to use the flag for?
	// Perhaps we could use it as a replacement for the bird system?  For now we could keep the flag system turned off though.

/obj/structure/mailbox/Initialize(mapload)
	. = ..()
	// turn it on!
	register_context()
	toggle_onness()

/obj/structure/mailbox/examine(mob/user)
	. = ..()
	. += span_notice("If you leave a crate near this thing, it will automatically stack the mail on top of it!")
	. += span_notice("This doesn't require any power to operate, it is merely a passive receiver of interstellar mail!")
	if(too_many_nearby_mails())
		. += span_notice("There are too many nearby mails! The flag will be raised to indicate this.")

/obj/structure/mailbox/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_LMB] = "Toggle mailbox power / floor clamps"
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Print Help Document"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/mailbox/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	toggle_onness(user)

/obj/structure/mailbox/click_alt(mob/user)
	. = ..()
	print_help_document(user)

/obj/structure/mailbox/proc/toggle_onness(mob/user)
	on = !on
	anchored = on
	playsound(src, 'sound/machines/click.ogg', 40, TRUE)
	playsound(src, 'sound/machines/creak.ogg', 70, TRUE)
	if(on)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	sparkle()
	update_icon()

/obj/structure/mailbox/update_overlays()
	. = ..()
	if(on)
		. += mutable_appearance(icon, "light")
		. += emissive_appearance(icon, "light", src)
	if(too_many_nearby_mails())
		. += mutable_appearance(icon, "flag")
		. += emissive_appearance(icon, "flag", src)

/obj/structure/mailbox/process(seconds_per_tick)
	if(!on)
		return
	timeleft_till_next_mail -= (seconds_per_tick SECONDS)
	if(timeleft_till_next_mail > 0)
		update_icon()
		return
	timeleft_till_next_mail = per_mail_interval
	if(too_many_nearby_mails())
		update_icon()
		sparkle()
		return
	arrive_some_mail()
	update_icon()

/obj/structure/mailbox/proc/sparkle()
	if(spark_cooldown > world.time)
		return
	spark_cooldown = world.time + 1.5 SECONDS
	do_quantum_sparks(1, FALSE, src)

/obj/structure/mailbox/proc/arrive_some_mail()
	var/turf/placement_turf
	for(var/directio in GLOB.alldirs)
		var/turf/adj_turf = get_step(src, directio)
		for(var/obj/structure/struc in adj_turf)
			if(istype(struc, /obj/structure/table))
				placement_turf = adj_turf
				goto yiff
			if(istype(struc, /obj/structure/closet))
				placement_turf = adj_turf
				goto yiff
	if(!placement_turf)
		placement_turf = get_turf(src)
	yiff:
	var/crewoids = min_mail_per_spawn + LAZYLEN(get_mailable_minds())
	var/mail_count = min(rand(min_mail_per_spawn, crewoids), max_mail_per_spawn)
	// destination confirmed!
	playsound(src, 'sound/machines/ping.ogg', 40, TRUE)
	summon_mail_effect(placement_turf)
	spawn(1.5 SECONDS)
		make_some_mail(placement_turf, mail_count)

// vweemffph!
/obj/structure/mailbox/proc/summon_mail_effect(turf/placement_turf)
	new /obj/effect/temp_visual/tele_residual(placement_turf)
	spawn(1.5 SECONDS)
		new /obj/effect/temp_visual/tele_swirl(placement_turf)
		playsound(placement_turf, 'modular_coyote/sounds/cool_stuff/goon_telesci.ogg', 80, FALSE)

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
	playsound(src, 'modular_coyote/sounds/cool_stuff/goon_printer_thermal.ogg', 50, TRUE)
	if(user)
		user.put_in_hands(mhd)

/// MAIL HELP DOC
/obj/item/paper/mail_help_doc
	name = "Vixen Express Mail Delivery Field Pamphlet"
	color = COLOR_OFF_WHITE
	default_raw_text = {"
	<center>MAIL AND YOU</center>
	<hr>
	<p>Thank you for your interest in Vixen Express, moving at the speed of foxness.</p>
	<p>As a valued participant in our Care Packages for Cute Crew Members program, you play a crucial role in delivering bonuses to deserving crew members across the station.</p>
	<p>To get started, you will need your provided Tele-Mailbox. If you do not have one or cannot find it, please skip to the end of this document.</p>
	<p>First, turn on your Tele-Mailbox. You will know it is on by the glowing green indicator light on the left-hand side of the device.</p>
	<p>Note: Electricity is not required for the Tele-Mailbox to function, the internal power supply is charged with every arrival of mail through the system.</p>
	<p>Once your Tele-Mailbox is active, it will automatically receive incoming mail. This will occur periodically, no further action is required on your part to collect it.</p>
	<p>The received mail will arrive either on top of the Tele-Mailbox, or on top of any adjacent storage crates for your convenience.</p>
	<p>The mail will list an intended recipient by name and shift-assignment. The listed recipient is the only person able to open and claim the contents of the mail.</p>
	<p>Did you know: The Vixen Express Care Package mail is actually a to-point wireless delivery beacon which, upon verification of correct delivery, will teleport a reward via your sector's bluespace network directly to the recipient!</p>
	<p>Upon successful delivery, bonus funds will be automatically credited to the recipient's account and department, along with the cargo department for facilitating the delivery.</p>
	<p>Remember: Only the intended recipient can claim the contents of the mail. Attempting to open mail not addressed to you will result in failure and potential penalties.</p>
	<p>Thank you for participating in the Vixen Express Care Package program. Our fortunes rise and fall together.</p>
	<hr>
	<center>Troubleshooting</center>
	<ul>
		<li>Device does not dispense mail.</li>
		<ul>
			<li>Ensure the Tele-Mailbox is powered on and the green indicator light is illuminated.</li>
			<li>Check for any adjacent storage crates where the mail might have been placed.</li>
			<li>Count the number of mail items nearby the device, and ensure that the count is less than 20.</li>
			<ul>
				<li>The device will raise a red flag if the number of nearby mail items exceeds its handling capacity.</li>
			</ul>
		</ul>
		<li>Device scoots around easily.</li>
		<ul>
			<li>Ensure the Tele-Mailbox is placed on a stable surface.</li>
			<li>Activate the device. While inactive, its mobility is unrestricted and it may slide or scoot easily.</li>
		</ul>
		<li>Device is not present.</li>
		<ul>
			<li>Check the surrounding area for any misplaced Tele-Mailbox units.</li>
			<li>Ensure that the device has not been moved or removed by other personnel.</li>
			<li>If the device is still missing, please contact our 24/7 F1 Administrative Helpline for assistance in acquiring a new Tele-Mailbox.</li>
		</ul>
		<li>Recipient is sexually engaged or otherwise preoccupied.</li>
		<ul>
			<li>Wait until the recipient is no longer preoccupied.</li>
			<li>Ensure that the recipient is aware of the incoming delivery.</li>
			<li>Respect the recipient's privacy and do not attempt to deliver the mail while they are preoccupied.</li>
			<li>You may use the recipient's ID card if you are able to obtain it with their consent to facilitate the delivery.</li>
		</ul>
		<li>Recipient refuses delivery.</li>
		<ul>
			<li>Firmly request the recipient to accept the delivery.</li>
			<li>Determine the reason for the refusal and attempt to address any concerns the recipient may have.</li>
			<li>You may use the recipient's ID card if you are able to obtain it with their consent to facilitate the delivery.</li>
		</ul>
		<li>Recipient is in cryostorage or otherwise considered no longer on-station.</li>
		<ul>
			<li>Contact a member of the command staff to retrieve the recipient's ID card.</li>
			<li>Leave the mail at a designated secure location for later retrieval by the recipient or authorized personnel.</li>
			<li>Document the delivery attempt and the location where the mail was left for future reference.</li>
		</ul>
	</ul>
	"}

/// COLL FXEXS
/obj/effect/temp_visual/tele_swirl
	icon = 'modular_coyote/icons/effects.dmi'
	icon_state = "portswirl"
	duration = 1.5 SECONDS
	randomdir = FALSE
	pixel_y = 10

/obj/effect/temp_visual/tele_residual
	name = "residual glowie"
	icon = 'modular_coyote/icons/effects.dmi'
	icon_state = "residual"
	duration = 11.5 SECONDS
	randomdir = FALSE

