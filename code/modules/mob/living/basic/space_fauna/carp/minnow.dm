/mob/living/basic/carp/minnow
	name = "space minnow"
	desc = "A smaller breed of space carp, known for attacking solar cables."
	icon_state = "minnow"
	icon_living = "minnow"
	icon_dead = "minnow_dead"
	health = 15
	maxHealth = 15
	max_stamina = 80
	obj_damage = 50
	melee_damage_lower = 5
	melee_damage_upper = 10
	butcher_results = list(/obj/item/food/fishmeat/carp = 1, /obj/item/stack/sheet/animalhide/carp = 1)

	ai_controller = /datum/ai_controller/basic_controller/carp/minnow

/datum/ai_controller/basic_controller/carp/minnow
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic/not_friends,
		BB_BASIC_MOB_FLEE_DISTANCE = 3,
		BB_TARGET_PRIORITY_TRAIT = TRAIT_SCARY_FISHERMAN,
		BB_CARPS_FEAR_FISHERMAN = TRUE,
	)
	ai_traits = PASSIVE_AI_FLAGS
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/find_target_prioritize_traits,
		/datum/ai_planning_subtree/make_carp_rift/panic_teleport,
		/datum/ai_planning_subtree/flee_target/from_fisherman,
		/datum/ai_planning_subtree/attack_obstacle_in_path/carp,
		/datum/ai_planning_subtree/shortcut_to_target_through_carp_rift,
		/datum/ai_planning_subtree/make_carp_rift/aggressive_teleport,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/no_fisherman,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/carp_migration,
		/datum/ai_planning_subtree/find_and_hunt_target/look_for_cables,
	)
