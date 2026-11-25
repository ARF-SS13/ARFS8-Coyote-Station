/datum/job/engineering_guard
	alt_titles = list(
		"Engineering Guard",
		"Atmospheric Security",
	)

/datum/job/security_medic
	alt_titles = list(
		"Security Medic",
		"Field Medic",
		"Security Corpsman",
		"Brig Physician",
		"Combat Medic",
		"Special Operations Medic",
		"Novice Security Medic",
	)

//New titles for Blacksmith
/datum/job/blacksmith
	alt_titles = list(
		"Blacksmith",
		"Ithastrist",
		"Metalurgist",
		"Metal Worker",
		"Metalsmith",
		"Forge Artisan",
		"Forgemaster",
		"Weaponsmith",
		"Armorsmith",
	)

/datum/job/bridge_assistant
	alt_titles = list(
		"Bridge Assistant",
		"Bridge Secretary",
		"Command Deck Assistant",
		"Bridge Aide",
		"Bridge Attendant",
		"Captain's Assistant",
		"Bridge Support",
		"Bridge Liaison",
		"Bridge Concierge",
		"Bridge Steward",
		"Bridge Custodian",
		"Junior Officer of the Deck",
		"Bridge Butler",
		"Bridge Caretaker",
		"Assistant to the Captain",
		"Coffee Brewer",
		"Supervisor of Coffee",
		"Command Aide",
		"Bridge Maid",
		"Command Cadet",
		"Bridge Underling",
		"Bridge Taskrunner",
		"Paperwork Specialist",
		"Manager Representative",
		"Bridge Bunny",
	)

/datum/job/paramedic/New()
	alt_titles |= list(
		"Body Retrieval Specialist",
	)
	. = ..()
