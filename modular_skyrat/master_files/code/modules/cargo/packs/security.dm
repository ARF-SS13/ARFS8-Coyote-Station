//OVERRIDES

/datum/supply_pack/security/ammo

/datum/supply_pack/security/armory/ionrifle
	name = "Ion Carbine Crate"
	cost = CARGO_CRATE_VALUE * 18 //Same as the energy gun crate
	desc = "Contains two Ion Carbines, for when you need to deal with speedy space tiders, mechs, or upstart silicons."
	contains = list(/obj/item/gun/energy/ionrifle/carbine = 2)
	crate_name = "Ion Carbine Crate"
