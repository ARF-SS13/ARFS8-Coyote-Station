/datum/map_generator/cave_generator/coyote_assteroid
	weighted_open_turf_types = list(
		/turf/open/misc/asteroid/coyote/freon = 1,
	)
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/coyote              = 120,
		/turf/closed/mineral/random/coyote/high_chance  = 40,
		/turf/closed/mineral/random/coyote/low_chance   = 30,
		/turf/closed/mineral/gibtonite/coyote           = 3,
	)

	weighted_mob_spawn_list = list(
		/obj/effect/spawner/random/lavaland_mob/goliath  = 50,
		/mob/living/basic/mining/goldgrub                = 10,
		/mob/living/basic/mining/basilisk                = 4,
		/mob/living/basic/mining/hivelord                = 3,
	)

	weighted_flora_spawn_list = list(
		/obj/structure/flora/ash/cap_shroom   = 2,
		/obj/structure/flora/ash/leaf_shroom  = 2,
		/obj/structure/flora/ash/seraka       = 2,
		/obj/structure/flora/ash/stem_shroom  = 2,
		/obj/structure/flora/ash/tall_shroom  = 2,
		// this is a great idea and nothing bad can happen acus of it
		/obj/structure/spacevine                     = 2,
		/obj/structure/flora/rock/style_random       = 2,
		/obj/structure/flora/rock/pile               = 2,
		/obj/structure/flora/scrap                   = 2,
		/obj/structure/flora/lunar_plant             = 2,
		/obj/structure/flora/ocean                   = 2,
		/obj/structure/flora/biolumi/coyote          = 2,
		/obj/structure/flora/biolumi/coyote/flower   = 2,
		/obj/structure/flora/biolumi/coyote/plant    = 2,
		/obj/structure/flora/biolumi/coyote/lamp     = 2,
		/obj/structure/flora/ocean/seaweed           = 2,
		/obj/structure/flora/ocean/longseaweed       = 2,
		/obj/structure/flora/ocean/glowweed          = 2,
		/obj/structure/flora/bush/stalky             = 2,
	)

	///Note that this spawn list is also in the icemoon generator
	weighted_feature_spawn_list = list(
		/obj/structure/geyser/hollowwater    = 8,
		/obj/structure/geyser/plasma_oxide   = 8,
		/obj/structure/geyser/protozine      = 8,
		/obj/structure/geyser/random         = 2,
		/obj/structure/geyser/wittel         = 8,
		/obj/structure/geyser/chiral_buffer  = 8,
		/obj/structure/ore_vent/boss         = 1,
	)

	initial_closed_chance  = 40
	smoothing_iterations   = 50
	birth_limit            = 4
	death_limit            = 3
	mob_spawn_chance       = 25
	flora_spawn_chance     = 40
	feature_spawn_chance   = 2

/datum/map_generator/cave_generator/coyote_assteroid/second_floor
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/coyote              = 80,
		/turf/closed/mineral/random/coyote/high_chance  = 20,
		/turf/closed/mineral/random/coyote/low_chance   = 30,
		/turf/closed/mineral/gibtonite/coyote           = 3,
		)

	initial_closed_chance  = 45
	mob_spawn_chance = 15

/datum/map_generator/cave_generator/coyote_assteroid/third_floor
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/coyote              = 80,
		/turf/closed/mineral/random/coyote/high_chance  = 20,
		/turf/closed/mineral/random/coyote/low_chance   = 30,
		/turf/closed/mineral/gibtonite/coyote           = 3,
		)

	initial_closed_chance  = 50
	mob_spawn_chance = 5

/datum/map_generator/cave_generator/coyote_assteroid/lower_risk
	weighted_open_turf_types = list(
		/turf/open/misc/asteroid/coyote = 1,
	)
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/coyote              = 77,
		/turf/closed/mineral/random/coyote/high_chance  = 25,
		/turf/closed/mineral/random/coyote/low_chance   = 48,
		/turf/closed/mineral/gibtonite/coyote           = 1,
	)

	weighted_mob_spawn_list = list(
		/mob/living/basic/carp/passive = 1,
		/mob/living/basic/carp = 10,
		/mob/living/basic/carp/mega = 1,
	)

	weighted_flora_spawn_list = list(
		/obj/structure/spacevine                     = 2,
		/obj/structure/flora/rock/style_random       = 2,
		/obj/structure/flora/rock/pile               = 2,
		/obj/structure/flora/scrap                   = 2,
		/obj/structure/flora/lunar_plant             = 2,
		/obj/structure/flora/ocean                   = 2,
		/obj/structure/flora/biolumi/coyote          = 2,
		/obj/structure/flora/biolumi/coyote/flower   = 2,
		/obj/structure/flora/biolumi/coyote/plant    = 2,
		/obj/structure/flora/biolumi/coyote/lamp     = 2,
		/obj/structure/flora/ocean/seaweed           = 2,
		/obj/structure/flora/ocean/longseaweed       = 2,
		/obj/structure/flora/ocean/glowweed          = 2,
		/obj/structure/flora/bush/stalky             = 2,
	)

	///Note that this spawn list is also in the icemoon generator
	weighted_feature_spawn_list = list(
		/obj/structure/geyser/hollowwater    = 8,
		/obj/structure/geyser/plasma_oxide   = 8,
		/obj/structure/geyser/protozine      = 8,
		/obj/structure/geyser/random         = 2,
		/obj/structure/geyser/wittel         = 8,
		/obj/structure/geyser/chiral_buffer  = 8,
		/obj/structure/ore_vent/boss         = 1,
	)

	initial_closed_chance  = 40
	smoothing_iterations   = 50
	birth_limit            = 4
	death_limit            = 3
	mob_spawn_chance       = 5
	flora_spawn_chance     = 40
	feature_spawn_chance   = 1


/datum/map_generator/cave_generator/coyote_assteroid/lowest_risk
	weighted_open_turf_types = list(
		/turf/open/misc/asteroid/coyote = 1,
	)
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/coyote              = 90,
		/turf/closed/mineral/random/coyote/high_chance  = 20,
		/turf/closed/mineral/random/coyote/low_chance   = 40,
		/turf/closed/mineral/gibtonite/coyote           = 1,
	)

	weighted_mob_spawn_list = list(
		/mob/living/basic/dolphin = 1,
		/mob/living/basic/dolphin/manatee = 1
	)

	weighted_flora_spawn_list = list(
		/obj/structure/spacevine                     = 2,
		/obj/structure/flora/rock/style_random       = 2,
		/obj/structure/flora/rock/pile               = 2,
		/obj/structure/flora/scrap                   = 2,
		/obj/structure/flora/lunar_plant             = 2,
		/obj/structure/flora/ocean                   = 2,
		/obj/structure/flora/biolumi/coyote          = 2,
		/obj/structure/flora/biolumi/coyote/flower   = 2,
		/obj/structure/flora/biolumi/coyote/plant    = 2,
		/obj/structure/flora/biolumi/coyote/lamp     = 2,
		/obj/structure/flora/ocean/seaweed           = 2,
		/obj/structure/flora/ocean/longseaweed       = 2,
		/obj/structure/flora/ocean/glowweed          = 2,
		/obj/structure/flora/bush/stalky             = 2,
	)

	///Note that this spawn list is also in the icemoon generator
	weighted_feature_spawn_list = list(
		/obj/structure/geyser/hollowwater    = 8,
		/obj/structure/geyser/plasma_oxide   = 8,
		/obj/structure/geyser/protozine      = 8,
		/obj/structure/geyser/random         = 2,
		/obj/structure/geyser/wittel         = 8,
		/obj/structure/geyser/chiral_buffer  = 8,
		/obj/structure/ore_vent/boss         = 1,
	)

	initial_closed_chance  = 48
	smoothing_iterations   = 50
	birth_limit            = 4
	death_limit            = 3
	mob_spawn_chance       = 5
	flora_spawn_chance     = 60
	feature_spawn_chance   = 1

////////////////////COYOTE ROCKS

/turf/closed/mineral/random/coyote
	name = "PLACEHOLDER_NAME: ROCKWALL~"
	desc = "Wow, I wonder what wonders there are to behold in PLACEHOLDER_NAME: ROCKWALL"
	icon = MAP_SWITCH('icons/turf/walls/mountain_wall.dmi', 'icons/turf/mining.dmi') // SKYRAT EDIT CHANGE
	icon_state = "mountainrock"
	color = "#550155"
	base_icon_state = "mountain_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS
	defer_change = TRUE
	turf_type = /turf/open/misc/asteroid/coyote/airless
	baseturfs = /turf/open/misc/asteroid/coyote/airless
	initial_gas_mix = AIRLESS_ATMOS
	defer_change = TRUE
	proximity_based = FALSE //SKYRAT EDIT: Original TRUE
	mineralChance = 15

/turf/closed/mineral/random/coyote/high_chance
	mineralChance = 25

/turf/closed/mineral/random/coyote/low_chance
	mineralChance = 5

/turf/closed/mineral/random/coyote/mineral_chances()
	return list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stack/ore/diamond = 1,
		/obj/item/stack/ore/gold = 10,
		/obj/item/stack/ore/iron = 40,
		/obj/item/stack/ore/plasma = 20,
		/obj/item/stack/ore/silver = 12,
		/obj/item/stack/ore/titanium = 11,
		/obj/item/stack/ore/uranium = 5,
		/turf/closed/mineral/gibtonite/volcanic = 4,
	)

/turf/closed/mineral/gibtonite/coyote
	name              = /turf/closed/mineral/random/coyote::name
	desc              = /turf/closed/mineral/random/coyote::desc + "...?"
	icon              = /turf/closed/mineral/random/coyote::icon
	icon_state        = /turf/closed/mineral/random/coyote::icon_state
	color             = /turf/closed/mineral/random/coyote::color
	base_icon_state   = /turf/closed/mineral/random/coyote::base_icon_state
	smoothing_flags   = /turf/closed/mineral/random/coyote::smoothing_flags
	canSmoothWith     = /turf/closed/mineral/random/coyote::canSmoothWith
	defer_change      = /turf/closed/mineral/random/coyote::defer_change
	turf_type         = /turf/closed/mineral/random/coyote::turf_type
	baseturfs         = /turf/closed/mineral/random/coyote::baseturfs
	initial_gas_mix   = /turf/closed/mineral/random/coyote::initial_gas_mix
	defer_change      = /turf/closed/mineral/random/coyote::defer_change

/turf/closed/indestructible/rock/coyote
	name              = "sealed stone hull"
	desc              = "A nigh-indestructible sheet of alien stone as of yet still unknown to your so-called 'science'. Now in grape-ade flavor!"
	icon              = /turf/closed/mineral/random/coyote::icon
	icon_state        = /turf/closed/mineral/random/coyote::icon_state
	color             = /turf/closed/mineral/random/coyote::color
	base_icon_state   = /turf/closed/mineral/random/coyote::base_icon_state
	smoothing_flags   = /turf/closed/mineral/random/coyote::smoothing_flags
	canSmoothWith     = /turf/closed/mineral/random/coyote::canSmoothWith
	baseturfs         = /turf/closed/mineral/random/coyote::baseturfs
	initial_gas_mix   = /turf/closed/mineral/random/coyote::initial_gas_mix

/turf/closed/indestructible/rock/coyote/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon        = /turf/open/misc/asteroid/coyote::icon        // = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state  = /turf/open/misc/asteroid/coyote::icon_state  // = "basalt"
	return TRUE


/turf/open/misc/asteroid/coyote
	gender = PLURAL // got that they/them turfussy
	name = "PLACEHOLDER_NAME: SOIL"
	desc = " PLACEHOLDER_NAME: SOIL!"
	icon = 'icons/turf/snow.dmi'
	damaged_dmi = 'icons/turf/snow.dmi'
	icon_state = "snow"
	base_icon_state = "snow"
	color = "#FFCCFF"
	baseturfs = /turf/open/misc/asteroid/coyote
	turf_type = /turf/open/misc/asteroid/coyote
	slowdown = 2
	flags_1 = NONE
	bullet_sizzle = TRUE
	dig_result = /obj/item/stack/sheet/mineral/snow
	worm_chance = 30

/turf/open/misc/asteroid/coyote/airless
	initial_gas_mix = AIRLESS_ATMOS
	baseturfs = /turf/open/misc/asteroid/coyote/airless
	turf_type = /turf/open/misc/asteroid/coyote/airless
	worm_chance = 30

/turf/open/misc/asteroid/coyote/freon
	initial_gas_mix = OPENTURF_FREON_ATMOS
	baseturfs = /turf/open/misc/asteroid/coyote/freon
	turf_type = /turf/open/misc/asteroid/coyote/freon
	worm_chance = 30

/obj/structure/flora/biolumi/coyote
	name = "glowing plants"
	desc = "Several sticks with bulbous, bioluminescent tips."
	icon = 'modular_skyrat/modules/jungle/icons/jungleflora.dmi'
	icon_state = "stick"
	gender = PLURAL // got that they/them bioluminussy
	light_range = 15
	light_power = 0.5
	max_integrity = 50
	variants = 9
	random_light = list(
		"#6AFF00",
		"#00FFEE",
		"#D9FF00",
		"#FFC800",
		"#FF3355",
		"#3355FF",
		"#218033",
		"#114545",
		)

/obj/structure/flora/biolumi/coyote/flower
	name = "glowing flower"
	desc = "Beautiful, bioluminescent flower."
	icon_state = "flower"
	variants = 2

/obj/structure/flora/biolumi/coyote/plant
	name = "glowing plant"
	desc = "Glowing sphere encased in jungle leaves."
	icon_state = "mine"
	variants = 4

/obj/structure/flora/biolumi/coyote/lamp
	name = "plant lamp"
	desc = "Bioluminescent plant much in a shape of a street lamp."
	icon_state = "lamp"
	variants = 2





//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

/datum/map_generator/cave_generator/coyote_assteroid/untitled_document
	weighted_open_turf_types = list(
		/turf/open/misc/asteroid/coyote/freon = 1,
	)
	weighted_closed_turf_types = list(
		/turf/closed/mineral/random/coyote              = 100,
		/turf/closed/mineral/random/coyote/high_chance  = 40,
		/turf/closed/mineral/random/coyote/low_chance   = 30,
		/turf/closed/mineral/gibtonite/coyote           = 10,
	)

	weighted_mob_spawn_list = list(
		/obj/effect/spawner/random/lavaland_mob/goliath  = 50,
		/mob/living/basic/mining/goldgrub                = 10,
		/mob/living/basic/mining/basilisk                = 4,
		/mob/living/basic/mining/hivelord                = 3,
	)

	weighted_flora_spawn_list = list(
		/obj/structure/flora/ash/cacti        = 1,
		/obj/structure/flora/ash/cap_shroom   = 2,
		/obj/structure/flora/ash/fireblossom  = 2,
		/obj/structure/flora/ash/leaf_shroom  = 2,
		/obj/structure/flora/ash/seraka       = 2,
		/obj/structure/flora/ash/stem_shroom  = 2,
		/obj/structure/flora/ash/tall_shroom  = 2,
		// this is a great idea and nothing bad can happen acus of it
		/obj/structure/spacevine                     = 2,
		/obj/structure/flora/rock/style_random       = 2,
		/obj/structure/flora/rock/pile               = 2,
		/obj/structure/flora/scrap                   = 2,
		/obj/structure/flora/lunar_plant             = 2,
		/obj/structure/flora/ocean                   = 2,
		/obj/structure/flora/biolumi/coyote          = 2,
		/obj/structure/flora/biolumi/coyote/flower   = 2,
		/obj/structure/flora/biolumi/coyote/plant    = 2,
		/obj/structure/flora/biolumi/coyote/lamp     = 2,
		/obj/structure/flora/ocean/seaweed           = 2,
		/obj/structure/flora/ocean/longseaweed       = 2,
		/obj/structure/flora/bush/stalky             = 2,
	)

	///Note that this spawn list is also in the icemoon generator
	weighted_feature_spawn_list = list(
		/obj/structure/geyser/hollowwater    = 8,
		/obj/structure/geyser/plasma_oxide   = 8,
		/obj/structure/geyser/protozine      = 8,
		/obj/structure/geyser/random         = 2,
		/obj/structure/geyser/wittel         = 8,
		/obj/structure/geyser/chiral_buffer  = 8,
		/obj/structure/ore_vent/boss         = 1,
	)

	initial_closed_chance  = 45
	smoothing_iterations   = 50
	birth_limit            = 4
	death_limit            = 3
	mob_spawn_chance       = 25
	flora_spawn_chance     = 40
	feature_spawn_chance   = 2

