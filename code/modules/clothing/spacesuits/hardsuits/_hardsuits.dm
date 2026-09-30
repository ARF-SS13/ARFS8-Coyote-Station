//Repeating softsuit information here, despite it being a child object so that it can be referenced more quickly as we redesign the concept of hardsuits into protected-softsuits.

/obj/item/clothing/head/helmet/space/hard
	name = "reinforced space helmet"
	icon = 'icons/obj/clothing/head/spacehelm.dmi'
	worn_icon = 'icons/mob/clothing/head/spacehelm.dmi'
	icon_state = "spaceold" //Deserves its own icons if possible
	inhand_icon_state = "space_helmet"
	desc = "A special helmet with solar UV shielding to protect your eyes from harmful rays. This one has been modified with reinforced protective materials." //Remember to put info about it being up-armored in this.
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS
	armor_type = /datum/armor/head_helmet //Matches security helmet by default
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	interaction_flags_click = NEED_DEXTERITY
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	strip_delay = 5 SECONDS
	equip_delay_other = 5 SECONDS
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	dog_fashion = null
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	///How much this helmet affects fishing difficulty
	var/fishing_modifier = 3 //what the actual fuck does this have to do with fishing????  Why???
	///Icon state applied when we get spraypainted/peppersprayed. If null, does not add the dirt component
	var/visor_dirt = "helm_dirt"

/obj/item/clothing/head/helmet/space/Initialize(mapload)
	. = ..()
	if(visor_dirt)
		AddComponent(/datum/component/clothing_dirt, visor_dirt)
	if(fishing_modifier)
		AddElement(/datum/element/adjust_fishing_difficulty, fishing_modifier)
	add_stabilizer()

/obj/item/clothing/head/helmet/space/proc/add_stabilizer(loose_hat = TRUE)
	AddComponent(/datum/component/hat_stabilizer, loose_hat = loose_hat)


/obj/item/clothing/suit/space/hard
	name = "reinforced space suit"
	desc = "A suit that protects against low pressure environments. Has a big 13 on the back. It has been modified to be more reliable and given limited protective armor."
	icon_state = "spaceold"
	icon = 'icons/obj/clothing/suits/spacesuit.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	worn_icon = 'icons/mob/clothing/suits/spacesuit.dmi'
	inhand_icon_state = "s_suit"
	w_class = WEIGHT_CLASS_BULKY
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/internals,
		/obj/item/tank/jetpack/captain,
		)
	slowdown = 1
	armor_type = /datum/armor/suit_armor //uparmored to match the basic vest
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDESEXTOY|HIDETAIL|HIDETAUR //SKYRAT EDIT CHANGE - ADDED HIDETAIL, HIDETAUR. ADDED HIDESEXTOY TO PREVENT VISUAL BUGS.
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	strip_delay = 8 SECONDS
	equip_delay_other = 8 SECONDS
	resistance_flags = NONE
	actions_types = list(/datum/action/item_action/toggle_spacesuit)
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING
	/// The default temperature setting
	var/temperature_setting = BODYTEMP_NORMAL
	/// If this is a path, this gets created as an object in Initialize.
	var/obj/item/stock_parts/power_store/cell = /obj/item/stock_parts/power_store/cell/high
	/// Status of the cell cover on the suit
	var/cell_cover_open = FALSE
	/// Status of the thermal regulator
	var/thermal_on = FALSE
	/// If this is FALSE the batery status UI will be disabled. This is used for suits that don't use bateries like the changeling's flesh suit mutation.
	var/show_hud = TRUE
	///How much this suit affects fishing difficulty
	var/fishing_modifier = 5


