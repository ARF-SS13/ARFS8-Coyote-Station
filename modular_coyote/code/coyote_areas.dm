/area/station/asteroid/coyote
	name = "\improper Nearby Asteroid"
	icon_state = "station_asteroid"
	area_flags = VALID_TERRITORY | NO_GRAVITY
	area_flags_mapping = UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	area_flags = NONE
	outdoors = TRUE
	allow_shuttle_docking = TRUE
	map_generator = /datum/map_generator/cave_generator/coyote_assteroid

/area/station/asteroid/coyote/second_floor
	map_generator = /datum/map_generator/cave_generator/coyote_assteroid/second_floor

/area/station/asteroid/coyote/third_floor
	map_generator = /datum/map_generator/cave_generator/coyote_assteroid/third_floor

/area/station/asteroid/coyote/lower_risk
	map_generator = /datum/map_generator/cave_generator/coyote_assteroid/lower_risk

/area/station/asteroid/coyote/lowest_risk
	map_generator = /datum/map_generator/cave_generator/coyote_assteroid/lowest_risk

/area/station/asteroid/coyote/unexplored

/area/station/asteroid/coyote/explored

/area/station/asteroid/coyote/abandoned

/area/station/asteroid/coyote/laborcamp
	name = "Labor Camp"
	icon_state = "mining_labor"

/area/station/asteroid/coyote/laborcamp/security
	name = "Labor Camp Security"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER


