///Regular backpack
/datum/storage/backpack
	max_total_storage = 21
	max_slots = 21

/datum/storage/backpack/cbt
	uses_equipped_slot_restriction = TRUE
	equipped_slot_hands_always_ok = TRUE
	equipped_slot_non_held_always_ok = TRUE
	equipped_slot_whitelist = list(
		ITEM_SLOT_HANDS,
		ITEM_SLOT_OCLOTHING,
		ITEM_SLOT_ICLOTHING,
		ITEM_SLOT_LPOCKET,
		ITEM_SLOT_RPOCKET,
	)

/datum/storage/backpack/satchel
	max_total_storage = 15
	max_slots = 21

/datum/storage/backpack/messengerbag
	max_total_storage = 12
	max_slots = 21

/datum/storage/backpack/New(
	atom/parent,
	max_slots,
	max_specific_storage,
	max_total_storage,
)
	. = ..()
	set_holdable(exception_hold_list = /obj/item/fish_tank)

///Saddle backpack
/datum/storage/backpack/saddle
	max_total_storage = 26

///Satchel flat
/datum/storage/backpack/satchel_flat
	max_total_storage = 15

/datum/storage/backpack/satchel_flat/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(cant_hold_list = /obj/item/storage/backpack/satchel/flat) //muh recursive backpacks

///Santa bag
/datum/storage/backpack/santabag
	max_total_storage = 60
