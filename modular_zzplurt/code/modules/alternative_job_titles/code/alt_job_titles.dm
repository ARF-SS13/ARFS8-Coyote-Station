/datum/job/ai/New()
	var/list/extra_titles = list(
		"Automated Station Caretaker",
		"Automated Station Control",
		"Central Station System",
		"Automatic Station Operator",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/captain/New()
	var/list/extra_titles = list(
		"Station Director",
		"Station Governor",
		"Station Overseer",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chief_engineer/New()
	var/list/extra_titles = list(
		"Construction Coordinator",
		"Head Engineer",
		"Master Architect",
		"Power Plant Director",
		"Project Manager",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/head_of_personnel/New()
	var/list/extra_titles = list(
		"Headpat Of Personnel",
		"Human Resources",
		"Personnel Coordinator",
		"Personnel Manager",
		"Personnel Officer",
		"Records Administrator",
		"Staff Administrator",
		"Head of Fursonnel",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/head_of_security/New()
	var/list/extra_titles = list(
		"Watch Commander",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/quartermaster/New()
	var/list/extra_titles = list(
		"Supply Chief",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/research_director/New()
	var/list/extra_titles = list(
		"Lead Developer",
		"Research Manager",
		"Science Administrator",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chief_medical_officer/New()
	var/list/extra_titles = list(
		"Medical Administrator",
		// "Medical Director",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bridge_assistant/New()
	var/list/extra_titles = list(
		"Assistant of the Day",
		"Command Freeloader",
		"Command Mascot",
		"Folder Manager",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/station_engineer/New()
	var/list/extra_titles = list(
		"Apprentice Engineer",
		"Hazardous Material Operator",
		"Junior Engineer",
		"Station Architect",
		"Structural Engineer",
		"Structural Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/telecomms_specialist/New()
	var/list/extra_titles = list(
		"Communications Technician",
		"Electronics Relay Planner",
		"PDA Service Provider",
		"Systems Reboot Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/assistant/New()
	var/list/extra_titles = list(
		"Bard",
		"Boxer",
		"Clerk",
		"Escort",
		"Freeloader",
		"Intern",
		"Receptionist",
		"Secretary",
		"Wrestler",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bartender/New()
	var/list/extra_titles = list(
		"Barmaid",
		"Drinklady",
		"Drinkman",
		"Sommelier",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/janitor/New()
	var/list/extra_titles = list(
		"Cleanliness Technician",
		"Mess Manager",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chaplain/New()
	var/list/extra_titles = list(
		"Abbot",
		"Bishop",
		"Prior",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/clown/New()
	var/list/extra_titles = list(
		"Chaotic Agent",
		"Performer",
		"Scapegoat",
		"Station Fool",
		// "Comedian",
		// "Jester",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/cook/New()
	var/list/extra_titles = list(
		"Burger Flipper",
		"Lunch Packer",
		"Microwave Technology Specialist",
		"Sandwich Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/curator/New()
	var/list/extra_titles = list(
		"Gossip Coordinator",
		"Scholar",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/lawyer/New()
	var/list/extra_titles = list(
		"Attorney",
		"Legal Consultant",
		// "Internal Affairs Agent",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/mime/New()
	var/list/extra_titles = list(
		"Pantomime",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/scientist/New()
	var/list/extra_titles = list(
		"Junior Scientist",
		"Nanite Programmer",
		"Research Intern",
		"Researcher",
		"Toxins Researcher",
		"Explosion Scientist",
		"Ordnance Calibration Technician",
		"Xenoarchaeologist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/roboticist/New()
	var/list/extra_titles = list(
		"Exo-Suit Mechanic",
		"MOD Mechanic",
		"Ripperdoc",
		"Synth Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chemist/New()
	var/list/extra_titles = list(
		"Apothecarist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/coroner/New()
	var/list/extra_titles = list(
		"Autopsy Specialist",
		"Workplace Accident Specialist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/doctor/New()
	var/list/extra_titles = list(
		"Medical Intern",
		"Medical Resident",
		"Medtech",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/geneticist/New()
	var/list/extra_titles = list(
		"Genetics Researcher",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/virologist/New()
	var/list/extra_titles = list(
		"Biochemist",
		"Microbiologist",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/detective/New()
	var/list/extra_titles = list(
		"Forensic Investigator",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/security_officer/New()
	var/list/extra_titles = list(
		"Civil Protection",
		"Security Agent",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/warden/New()
	var/list/extra_titles = list(
		"Brig Overwatch",
		"Brig Superintendent",
		"Marshal",
		"Security Sergeant",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bitrunner/New()
	var/list/extra_titles = list(
		"Hacker",
		"Jacker",
		"Power Gamer",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/cargo_technician/New()
	var/list/extra_titles = list(
		"Cryptocurrency Technician",
		"Deliveries Officer",
		"Logistics Technician",
		"Mailroom Technician",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/shaft_miner/New()
	var/list/extra_titles = list(
		"Digger",
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

//Honorifics
/datum/id_trim/job/blueshield/New()
	var/list/extra_honorific = list(
		"Blueshield",
	)
	LAZYADD(honorifics, extra_honorific)
	. = ..()

/datum/job/nanotrasen_crew_trainer
	alt_titles = list(
		"Nanotrasen Crew Trainer",
		"Nanotrasen Intern",
		"NT Guidance Officer",
		"Cargo Trainer",
		"Engineering Trainer",
		"Medical Trainer",
		"Science Trainer",
		"Security Trainer",
		"Service Trainer",
	)

/proc/get_security_cyborg_alt_titles()
	return list(
		"Security Cyborg",
		"Synthetic Auxiliary Officer",
	)
