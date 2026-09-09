/datum/job/lawyer
	title = JOB_LAWYER
	description = "Operate in a legal capacity on behalf of the crew, \
		issue monetary awards for successful lawsuits, insurance payouts, or any other reason."
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOP
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "LAWYER"

	outfit = /datum/outfit/job/lawyer
	plasmaman_outfit = /datum/outfit/plasmaman/bar

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV

	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_LAWYER
	departments_list = list(
		/datum/job_department/service,
		)
	rpg_title = "Magistrate"
	family_heirlooms = list(/obj/item/gavelhammer, /obj/item/book/manual/wiki/security_space_law)

	job_flags = STATION_JOB_FLAGS

	job_tone = "objection"

/datum/outfit/job/lawyer
	name = "Lawyer"
	jobtype = /datum/job/lawyer

	id_trim = /datum/id_trim/job/lawyer
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit
	suit = /obj/item/clothing/suit/toggle/lawyer
	belt = /obj/item/modular_computer/pda/lawyer
	ears = /obj/item/radio/headset/headset_srvsec
	shoes = /obj/item/clothing/shoes/laceup
	neck = /obj/item/clothing/neck/tie/red/tied
	l_pocket = /obj/item/laser_pointer/red
	r_pocket = /obj/item/clothing/accessory/lawyers_badge
	l_hand = /obj/item/storage/briefcase/lawyer

	chameleon_extras = /obj/item/stamp/law

/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return ..()

	var/static/use_purple_suit = FALSE //If there is one lawyer, they get the default blue suit. If another lawyer joins the round, they start with a purple suit.
	if(use_purple_suit)
		uniform = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple
	else
		use_purple_suit = TRUE
	..()

/datum/outfit/job/lawyer/get_types_to_preload()
	. = ..()
	. += /obj/item/clothing/under/rank/civilian/lawyer/purpsuit
	. += /obj/item/clothing/suit/toggle/lawyer/purple

// checks to give to crewmates who've been awarded lawsuits or prizes
/obj/item/card/lawyer_check
	name = "debug money order (HELP! CODER!)"
	desc = "An official certificate representing an awarded sum of money. Swipe your ID card over it to transfer the funds. Limit of one per person to prevent theft or embezzlement."
	icon = 'icons/obj/card_old.dmi'
	icon_state = "budgetcard"

	var/points = 0

/obj/item/card/lawyer_check/examine(mob/user)
	. = ..()
	. += span_notice("This card is worth [points] credit\s.")

/obj/item/card/lawyer_check/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!isidcard(attacking_item))
		return ..()
	var/obj/item/card/id/attacking_id = attacking_item
	if(!points)
		balloon_alert(user, "already redeemed")
		return
	if(attacking_id.registered_account.money_order_cashed)
		balloon_alert(user, "transfer denied")
		return
	balloon_alert(user, "starting transfer")
	if(do_after(user, 3 SECONDS, target = attacking_item))
		if(!points)
			balloon_alert(user, "already redeemed")
			return
		attacking_id.registered_account.account_balance += points
		points = 0
		attacking_id.registered_account.money_order_cashed = TRUE
		name = "redeemed [name]"
		balloon_alert(user, "transfer successful")
		playsound(loc,'sound/effects/cashregister.ogg', 75, TRUE)

/obj/item/card/lawyer_check/twofifty
	name = "money order (250)"
	points = 250

/obj/item/card/lawyer_check/fivehundred
	name = "money order (500)"
	icon_state = "budgetcard_500"
	points = 500

/obj/item/card/lawyer_check/onethousand
	name = "money order (1000)"
	icon_state = "budgetcard_1000"
	points = 1000

