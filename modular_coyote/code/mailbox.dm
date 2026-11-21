
//Bluespace mailbox to emulate how mail is delievered from ss14

/obj/structure/mailbox
	icon_state = "mailbox"
	icon = 'modular_coyote/icons/mailbox.dmi'
	abstract_type = /obj/structure
	pressure_resistance = 8
	max_integrity = 300
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT
	layer = BELOW_OBJ_LAYER
	flags_ricochet = RICOCHET_HARD
	receive_ricochet_chance_mod = 0.6
	pass_flags_self = PASSSTRUCTURE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	armor_type = /datum/armor/obj_structure
	burning_particles = /particles/smoke/burning

	//Likely the easiest way to do this, Dan, is to pull the mail spawner from the cargo shuttle and apply it more directly here.
	//We do have access to a few icon states, specifically 'flag' & 'light', which apply a red flag and a green light.
	// I suppose this thing shouldn't work if unpowered, so the light has to be on to be active, perhaps right clicking it turns the machine off?
	// Probably best to just have it spawn its mail on top of itself, like the ss14 mailbox, but what to use the flag for?
	// Perhaps we could use it as a replacement for the bird system?  For now we could keep the flag system turned off though.
