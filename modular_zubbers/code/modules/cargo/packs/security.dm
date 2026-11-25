/datum/supply_pack/security/armory/wt550
	name = "WT-550 Autorifle Crate"
	desc = "Contains a pair of WT-550 Autorifles loaded with lethal ammo. Ballistic firearms are not part of the standard security service kit, however they may still be requisitioned for emergent situations in which energy blasts or powercells may fail."
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/obj/item/gun/ballistic/automatic/wt550 = 2)
	crate_name = "wt-550 autorifle crate"

/datum/supply_pack/security/armory/wt550_ammo_regular
	name = "WT-550 Autorifle Ammo Crate"
	desc = "Contains 4 magazines with standard lethal rounds for the WT-550."
	cost = CARGO_CRATE_VALUE * 4 //these are printable, price can be lowered safely to 800ish
	contains = list(/obj/item/ammo_box/magazine/wt550m9 = 4)
	crate_name = "wt-550 magazine crate (regular)"

/datum/supply_pack/security/secmed_technician
	name = "Security Medic Kit Crate - Technician"
	crate_name = "security medic crate"
	desc = "Contains a medical technician kit."
	access = ACCESS_SECURITY
	cost = CARGO_CRATE_VALUE * 7.125
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_paramedic/stocked,
	)

/datum/supply_pack/security/secmed_surgical
	name = "Security Medic Kit Crate - Surgical"
	crate_name = "security medic crate"
	desc = "Contains a first responder surgical kit."
	access = ACCESS_SECURITY
	cost = CARGO_CRATE_VALUE * 3.9
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_surgical/stocked,
	)

/datum/supply_pack/security/secmed_medical
	name = "Security Medic Kit Crate - Medical"
	crate_name = "security medic crate"
	desc = "Contains a large satchel medical kit."
	access = ACCESS_SECURITY
	cost = CARGO_CRATE_VALUE * 7.125
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_medkit/stocked,
	)

	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_SECURITY

/datum/supply_pack/security/armory/swat
	desc = "Contains two fullbody sets of tough, fireproof suits designed in a joint \
		effort by IS-ERI and Nanotrasen. Each set contains a suit, helmet, mask, combat belt, a pepperball gun, \
		and gorilla gloves."

/datum/supply_pack/security/armory/swat/New()
	. = ..()
	contains += list(/obj/item/storage/toolbox/guncase/skyrat/pistol/pepperball = 2)

/datum/supply_pack/security/armory/mechthermal
	access = FALSE
	access_any = list(ACCESS_SECURITY, ACCESS_ROBOTICS)
	access_view = FALSE

/datum/supply_pack/security/Tasers
	name = "Taser Crate"
	desc = "Contains three hybrid tasers, a non-lethal weapon that fires electric projectiles and features a secondary disabler."
	cost = CARGO_CRATE_VALUE * 5.5
	contains = list(/obj/item/gun/energy/e_gun/advtaser = 3)
	access = ACCESS_SECURITY

/datum/supply_pack/security/combine
	name = "Civil Protection Uniforms"
	desc = "Extra supplies we got from some weird old guy in a blue suit. Contains six uniforms, \
		vests, boots, gloves and helmets."
	cost = 1116
	order_flags = ORDER_CONTRABAND
	contains = list(/obj/item/clothing/head/helmet/metrocophelmet = 6,
		/obj/item/clothing/suit/armor/vest/alt/sec/metrocop = 6,
		/obj/item/clothing/under/rank/security/metrocop = 6,
		/obj/item/clothing/gloves/color/black/security/metrocop = 6,
		/obj/item/clothing/shoes/jackboots/combine = 6,
		/obj/item/trash/can = 3,
			)
	crate_name = "benefactor supply crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/security/armory/tacticool_laser_crate
	name = "Tacticool energy gun crate"
	desc = "Three tacticool energy guns to express your individuality compared to all those other energy gun users!"
	cost = CARGO_CRATE_VALUE * 8
	contains = list(
		/obj/item/gun/energy/tacticool,
		/obj/item/gun/energy/tacticool,
		/obj/item/gun/energy/tacticool,
	)
