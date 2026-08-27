// ╔═════════════════════════════╦════════════════════════════════════════════════════╗
// ║ EARLY CHARACTER BACKGROUNDS ║ YIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFYIFFYIF ║
// ╠═════════════════════════════╩════════════════════════════════════════════════════╣
// ║The history of your character from before you made it to where you are.           ║
// ╠══════════════════════════════════════════════════════════════════════════════════╣
// ║ YIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFFYIFF ║
// ╚══════════════════════════════════════════════════════════════════════════════════╝

/*
This character snippet system is sorted by what type of snippets the player can pick from.  The following snippet groups are included in no particular order.
This system will eventually be integrated into the records system as a pre-inserted piece of info. Strongly consider adding //records_type = "General/Medical/Personnel"
So that you can prep it to be integrated.

Parents - Your characters parents, and their current situation, or how your relationships are with them.

Siblings - Your characters siblings, and their current situation, or how your relationships are with them.

Planets & Places Lived - Planets or places you have lived in the past that have shaped who you are today.

Childhood Events - Be it good or bad these are events from your childhood that shaped you.

Teenage Events - Events from your teenage years, good or bad.

Marriages, Relationships & Children - Your adult life intimate relationships, and the children that may or may not have come from them.

Criminal Events - Crimes you broke or were framed for - and if you served time for them.

Education - Your education, from childhood onwards.

Work & Occupation History - Jobs your character has held in their life, with experiences that come along with them.

Military & Combat History - Military experience as either a combatant or a civillian in a military zone.

Medical History - Major medical events in the characters past.

Economic Background - The strata of society you were a part of either as a child or perhaps today.

Social & Cultural Background - The kind of society your character was raised by.

Relgion, Belief & Philosophy - Your personal religious and personal beliefs.

Major Accidents & Disasters - Horrible things that happened either involving you directly or second hand.

Secrets - Secrets your character holds dear and attempts to hide for whatever reason.

*/

// Gigantic List of Fuckin' Datums
/datum/character_snippet/background
	category_csnip = CSNIP_BACKGROUND
	abstract_type = /datum/character_snippet/background

/datum/character_snippet/background/parents
	subcategory_csnip = CSNIP_TAB_PARENTS
	abstract_type = /datum/character_snippet/background/parents

/datum/character_snippet/background/siblings
	subcategory_csnip = CSNIP_TAB_SIBLINGS
	abstract_type = /datum/character_snippet/background/siblings

/datum/character_snippet/background/planets
	subcategory_csnip = CSNIP_TAB_PLANETS
	abstract_type = /datum/character_snippet/background/planets

/datum/character_snippet/background/childhood
	subcategory_csnip = CSNIP_TAB_CHILDHOOD
	abstract_type = /datum/character_snippet/background/childhood

/datum/character_snippet/background/teenage
	subcategory_csnip = CSNIP_TAB_TEENAGE
	abstract_type = /datum/character_snippet/background/teenage

/datum/character_snippet/background/relationships
	subcategory_csnip = CSNIP_TAB_RELATIONSHIPS
	abstract_type = /datum/character_snippet/background/relationships

/datum/character_snippet/background/crimes
	subcategory_csnip = CSNIP_TAB_CRIMES
	abstract_type = /datum/character_snippet/background/crimes

/datum/character_snippet/background/education
	subcategory_csnip = CSNIP_TAB_EDUCATION
	abstract_type = /datum/character_snippet/background/education

/datum/character_snippet/background/work
	subcategory_csnip = CSNIP_TAB_WORK
	abstract_type = /datum/character_snippet/background/work

/datum/character_snippet/background/military
	subcategory_csnip = CSNIP_TAB_MILITARY
	abstract_type = /datum/character_snippet/background/military

/datum/character_snippet/background/medical
	subcategory_csnip = CSNIP_TAB_MEDICAL
	abstract_type = /datum/character_snippet/background/medical

/datum/character_snippet/background/economy
	subcategory_csnip = CSNIP_TAB_ECONOMY
	abstract_type = /datum/character_snippet/background/economy

/datum/character_snippet/background/social
	subcategory_csnip = CSNIP_TAB_SOCIAL
	abstract_type = /datum/character_snippet/background/social

/datum/character_snippet/background/beliefs
	subcategory_csnip = CSNIP_TAB_BELIEFS
	abstract_type = /datum/character_snippet/background/beliefs

/datum/character_snippet/background/disaster
	subcategory_csnip = CSNIP_TAB_DISASTER
	abstract_type = /datum/character_snippet/background/disaster

/datum/character_snippet/background/secrets
	subcategory_csnip = CSNIP_TAB_SECRETS
	abstract_type = /datum/character_snippet/background/secrets
//end gigantic list of group datums to help with sorting

//Parents List
/datum/character_snippet/background/parents/corporate_family
	name = "Corporate Family"
	desc = "Both parents worked for a major interstellar corporation, moving frequently between company facilities."
	//records_type = GENERAL

/datum/character_snippet/background/parents/one_corporate_parent
	name = "Corporate Parent"
	desc = "One parent worked for a major corporation while the other maintained the household."
	//records_type = GENERAL

/datum/character_snippet/background/parents/frontier_settlers
	name = "Frontier Settlers"
	desc = "Your parents were settlers on a remote frontier world and were accustomed to making do with whatever was available."
	//records_type = GENERAL

/datum/character_snippet/background/parents/colony_founders
	name = "Colony Founders"
	desc = "Your parents helped establish a small colony far from the core worlds."
	//records_type = GENERAL

/datum/character_snippet/background/parents/failed_colonists
	name = "Failed Colonists"
	desc = "Your parents attempted to establish a colony, but the settlement eventually collapsed."
	//records_type = GENERAL

/datum/character_snippet/background/parents/miners
	name = "Mining Family"
	desc = "Both of your parents worked in mining operations, and you grew up around heavy machinery and industrial equipment."
	//records_type = GENERAL

/datum/character_snippet/background/parents/farmers
	name = "Agricultural Family"
	desc = "Your parents worked in planetary agriculture, raising crops or livestock for a distant settlement."
	//records_type = GENERAL

/datum/character_snippet/background/parents/spacefarers
	name = "Spacefarers"
	desc = "Your parents spent most of their lives aboard ships, stations, and transports rather than on a planet."
	//records_type = GENERAL

/datum/character_snippet/background/parents/military_family
	name = "Military Family"
	desc = "At least one of your parents served in a military organization."
	//records_type = GENERAL

/datum/character_snippet/background/parents/mercenaries
	name = "Mercenary Parents"
	desc = "Your parents worked as soldiers for hire, taking contracts wherever the pay was good."
	//records_type = GENERAL

/datum/character_snippet/background/parents/pirates
	name = "Pirate Parents"
	desc = "Your parents made their living outside the law as pirates, smugglers, or raiders."
	//records_type = GENERAL

/datum/character_snippet/background/parents/criminal_family
	name = "Criminal Family"
	desc = "Crime was an ordinary part of family life while you were growing up."
	//records_type = GENERAL

/datum/character_snippet/background/parents/scientists
	name = "Scientific Parents"
	desc = "Your parents were researchers who spent much of their lives pursuing scientific projects."
	//records_type = GENERAL

/datum/character_snippet/background/parents/medical_family
	name = "Medical Family"
	desc = "Your parents worked in medicine, and you learned the basics of healthcare from an early age."
	//records_type = GENERAL

/datum/character_snippet/background/parents/engineers
	name = "Engineer Parents"
	desc = "Your parents were engineers, technicians, or machinists who taught you to respect machinery."
	//records_type = GENERAL

/datum/character_snippet/background/parents/wealthy_family
	name = "Wealthy Family"
	desc = "You were born into a financially comfortable family with access to opportunities unavailable to most people."
	//records_type = GENERAL

/datum/character_snippet/background/parents/poor_family
	name = "Poor Family"
	desc = "Your family struggled financially and often had to choose between necessities."
	//records_type = GENERAL

/datum/character_snippet/background/parents/orphaned
	name = "Orphaned"
	desc = "You lost both parents while you were young and were raised by someone else."
	//records_type = GENERAL

/datum/character_snippet/background/parents/abandoned
	name = "Abandoned"
	desc = "One or both of your parents abandoned you while you were young."
	//records_type = GENERAL

/datum/character_snippet/background/parents/adoptive_family
	name = "Adoptive Family"
	desc = "You were adopted at a young age and were raised by parents who were not your biological relatives."
	//records_type = GENERAL

/datum/character_snippet/background/parents/raised_by_single_parent
	name = "Single Parent"
	desc = "You were raised by only one parent, who had to handle the responsibilities of an entire household alone."
	//records_type = GENERAL

/datum/character_snippet/background/parents/communal_upbringing
	name = "Communal Upbringing"
	desc = "You were raised communally, with many adults sharing responsibility for raising children."
	//records_type = GENERAL

/datum/character_snippet/background/parents/religious_family
	name = "Religious Family"
	desc = "Your parents were deeply involved in a religious or spiritual community."
	//records_type = GENERAL

/datum/character_snippet/background/parents/ideological_family
	name = "Ideological Family"
	desc = "Your parents were deeply committed to a political, philosophical, or social ideology."
	//records_type = GENERAL

/datum/character_snippet/background/parents/estranged_parents
	name = "Estranged Parents"
	desc = "You have little or no contact with your parents anymore."
	//records_type = GENERAL

/datum/character_snippet/background/parents/unknown_parents
	name = "Unknown Parents"
	desc = "You never learned the identities of one or both of your biological parents."
	//records_type = GENERAL


//Siblings
/datum/character_snippet/background/siblings/only_child
	name = "Only Child"
	desc = "You grew up without any siblings."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/large_family
	name = "Large Family"
	desc = "You grew up with several siblings and were rarely afforded much privacy."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/older_sibling
	name = "Older Sibling"
	desc = "You have an older sibling who influenced much of your childhood."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/younger_sibling
	name = "Younger Sibling"
	desc = "You grew up with a younger sibling and were expected to help look after them."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/twin
	name = "Twin"
	desc = "You have a twin sibling with whom you shared much of your childhood."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/multiple_twins
	name = "Multiple Birth"
	desc = "You grew up as part of a set of twins, triplets, or another multiple birth."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/estranged_sibling
	name = "Estranged Sibling"
	desc = "You have a sibling with whom you no longer maintain a relationship."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/dead_sibling
	name = "Dead Sibling"
	desc = "One of your siblings died before you reached adulthood."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/missing_sibling
	name = "Missing Sibling"
	desc = "One of your siblings disappeared and was never conclusively found."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/rival_sibling
	name = "Sibling Rivalry"
	desc = "You and one of your siblings spent much of your childhood competing with each other."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/protective_sibling
	name = "Protective Sibling"
	desc = "An older sibling was fiercely protective of you while you were growing up."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/dependent_sibling
	name = "Dependent Sibling"
	desc = "One of your siblings has always depended heavily upon you."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/famous_sibling
	name = "Famous Sibling"
	desc = "One of your siblings became unusually successful or well known."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/criminal_sibling
	name = "Criminal Sibling"
	desc = "One of your siblings became involved in serious criminal activity."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/military_sibling
	name = "Military Sibling"
	desc = "One of your siblings serves or served in a military organization."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/sibling_on_station
	name = "Sibling on the Station"
	desc = "You have a sibling who currently works somewhere in the same organization or station network."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/sibling_in_debt
	name = "Sibling in Debt"
	desc = "One of your siblings accumulated significant financial debts that occasionally become your problem."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/adopted_sibling
	name = "Adopted Sibling"
	desc = "One of your siblings joined the family through adoption."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/unknown_siblings
	name = "Unknown Siblings"
	desc = "You recently learned that you may have biological siblings you never knew existed."
	//records_type = GENERAL

/datum/character_snippet/background/siblings/found_family
	name = "Found Family"
	desc = "Although you lack close biological siblings, you grew up alongside people who became like siblings to you."
	//records_type = GENERAL


//Planets and Places Lived
/datum/character_snippet/background/planets/core_world
	name = "Core World"
	desc = "You spent your childhood on a wealthy and densely populated core world."
	//records_type = GENERAL

/datum/character_snippet/background/planets/frontier_world
	name = "Frontier World"
	desc = "You grew up on a distant frontier world where civilization was sparse."
	//records_type = GENERAL

/datum/character_snippet/background/planets/rimworld
	name = "Rimworld Colony"
	desc = "You spent part of your childhood on a remote colony world where survival depended heavily on the local community."
	//records_type = GENERAL

/datum/character_snippet/background/planets/desert_world
	name = "Desert World"
	desc = "You spent several years living on a hot, arid planet."
	//records_type = GENERAL

/datum/character_snippet/background/planets/ice_world
	name = "Ice World"
	desc = "You were raised for a time on a frigid world where simply staying warm was a daily concern."
	//records_type = GENERAL

/datum/character_snippet/background/planets/jungle_world
	name = "Jungle World"
	desc = "You spent your childhood on a densely vegetated planet filled with dangerous wildlife."
	//records_type = GENERAL

/datum/character_snippet/background/planets/ocean_world
	name = "Ocean World"
	desc = "You grew up on a planet dominated by enormous oceans and scattered island settlements."
	//records_type = GENERAL

/datum/character_snippet/background/planets/industrial_world
	name = "Industrial World"
	desc = "You were raised on a heavily industrialized planet covered in factories, refineries, and processing plants."
	//records_type = GENERAL

/datum/character_snippet/background/planets/hive_world
	name = "Hive World"
	desc = "You grew up in a gigantic urban settlement where millions of people lived within a relatively small area."
	//records_type = GENERAL

/datum/character_snippet/background/planets/agri_world
	name = "Agricultural World"
	desc = "You spent your formative years on a world dedicated primarily to food production."
	//records_type = GENERAL

/datum/character_snippet/background/planets/mining_world
	name = "Mining World"
	desc = "You grew up around mines, processing facilities, and enormous industrial vehicles."
	//records_type = GENERAL

/datum/character_snippet/background/planets/arcology
	name = "Arcology"
	desc = "You spent most of your childhood inside a self-contained megastructure."
	//records_type = GENERAL

/datum/character_snippet/background/planets/space_station
	name = "Stationborn"
	desc = "You were born and raised aboard a space station."
	//records_type = GENERAL

/datum/character_snippet/background/planets/shipborn
	name = "Shipborn"
	desc = "You spent most of your childhood aboard a spacecraft."
	//records_type = GENERAL

/datum/character_snippet/background/planets/colony_ship
	name = "Colony Ship"
	desc = "You grew up aboard a colony vessel traveling toward a distant settlement."
	//records_type = GENERAL

/datum/character_snippet/background/planets/prison_world
	name = "Prison World"
	desc = "You spent part of your childhood on a planet primarily used for incarceration."
	//records_type = GENERAL

/datum/character_snippet/background/planets/refugee_colony
	name = "Refugee Colony"
	desc = "You grew up in a settlement established by displaced people from another world."
	//records_type = GENERAL

/datum/character_snippet/background/planets/war_zone
	name = "War Zone"
	desc = "You spent your childhood on a planet caught in an active military conflict."
	//records_type = GENERAL

/datum/character_snippet/background/planets/abandoned_colony
	name = "Abandoned Colony"
	desc = "You lived for a time in a struggling settlement that had been largely abandoned by its original owners."
	//records_type = GENERAL

/datum/character_snippet/background/planets/underground_colony
	name = "Underground Colony"
	desc = "You grew up in an underground settlement protected from an otherwise hostile planetary environment."
	//records_type = GENERAL

/datum/character_snippet/background/planets/wealthy_station
	name = "Luxury Station"
	desc = "You spent part of your childhood on an expensive orbital habitat reserved primarily for wealthy residents."
	//records_type = GENERAL

/datum/character_snippet/background/planets/slum_station
	name = "Station Slums"
	desc = "You grew up in the poorer sections of a massive space station."
	//records_type = GENERAL

/datum/character_snippet/background/planets/pirate_station
	name = "Pirate Station"
	desc = "You spent part of your youth on an independent station controlled by smugglers, pirates, or other criminals."
	//records_type = GENERAL

/datum/character_snippet/background/planets/corporate_habitat
	name = "Corporate Habitat"
	desc = "Your family lived inside a corporate-owned residential habitat."
	//records_type = GENERAL

/datum/character_snippet/background/planets/research_station
	name = "Research Habitat"
	desc = "You grew up around scientists and researchers at an isolated research installation."
	//records_type = GENERAL


//Childhood Events
/datum/character_snippet/background/childhood/lost_in_colony
	name = "Lost in the Colony"
	desc = "You became separated from your family in a large settlement and spent several frightening hours trying to find your way home."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/wildlife_attack
	name = "Wildlife Attack"
	desc = "You were attacked by an animal while young and have never completely forgotten the experience."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/saved_by_stranger
	name = "Saved by a Stranger"
	desc = "A stranger intervened during an emergency and saved your life."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/first_aid
	name = "First Aid"
	desc = "You were forced to learn basic first aid after someone close to you was injured."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/first_machine
	name = "First Machine"
	desc = "You became fascinated with machinery after taking apart a household device as a child."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/raised_by_robot
	name = "Raised Around Robots"
	desc = "Automated systems and synthetic workers were an unusually large part of your childhood."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/childhood_friend
	name = "Childhood Friend"
	desc = "You formed a close friendship during childhood that remained important for years."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/childhood_rival
	name = "Childhood Rival"
	desc = "You developed a bitter rivalry with another child over grades, sports, status, or something much more trivial."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/bullied
	name = "Bullied"
	desc = "You were frequently bullied by other children while growing up."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/bully
	name = "Bully"
	desc = "You spent part of your childhood bullying other children."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/colony_crisis
	name = "Colony Crisis"
	desc = "A serious crisis struck your settlement while you were young, forcing everyone to contribute."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/power_failure
	name = "Power Failure"
	desc = "A major power failure left your community without electricity for an extended period."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/food_shortage
	name = "Food Shortage"
	desc = "Your community experienced a serious shortage of food while you were young."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/evacuation
	name = "Emergency Evacuation"
	desc = "You were evacuated from your home during a major emergency."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/war
	name = "Childhood War"
	desc = "Military conflict reached your home while you were still a child."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/raid
	name = "Raid"
	desc = "Your settlement was raided by criminals, pirates, rebels, or soldiers."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/fire
	name = "Station Fire"
	desc = "A major fire broke out near your home and forced your family to evacuate."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/medical_emergency
	name = "Medical Emergency"
	desc = "Someone close to you suffered a serious medical emergency."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/festival
	name = "Colony Festival"
	desc = "You attended a major local festival that became one of your fondest childhood memories."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/strange_artifact
	name = "Strange Artifact"
	desc = "You discovered an unusual object as a child that you never fully understood."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/first_pet
	name = "First Pet"
	desc = "You became responsible for caring for an animal at a young age."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/accidental_invention
	name = "Accidental Invention"
	desc = "You accidentally built something surprisingly useful while playing with machinery."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/first_job
	name = "First Job"
	desc = "You began earning money at a surprisingly young age."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/communal_work
	name = "Community Work"
	desc = "You spent your childhood helping with communal work and learned that everyone had to contribute."
	//records_type = GENERAL

/datum/character_snippet/background/childhood/raised_in_shelter
	name = "Shelter Child"
	desc = "You spent several years living in a communal shelter after your family could no longer provide a stable home."
	//records_type = GENERAL


//Teenage Events
/datum/character_snippet/background/teenage/first_love
	name = "First Love"
	desc = "You experienced your first serious romantic relationship as a teenager."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/first_breakup
	name = "First Breakup"
	desc = "Your first serious relationship ended badly and taught you some difficult lessons."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/rebellion
	name = "Rebellion"
	desc = "You went through a period of openly rebelling against your family and authority figures."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/running_away
	name = "Ran Away"
	desc = "You ran away from home for a period of time."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/first_job
	name = "Teenage Job"
	desc = "You worked your first serious job as a teenager."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/apprenticeship
	name = "Apprenticeship"
	desc = "You apprenticed under an experienced worker and learned a practical trade."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/military_cadet
	name = "Military Cadet"
	desc = "You joined a military cadet or youth training program."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/gang
	name = "Joined a Gang"
	desc = "You became involved with a local gang or street organization."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/underground_scene
	name = "Underground Scene"
	desc = "You became involved in an underground social or cultural scene."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/illegal_racing
	name = "Illegal Racing"
	desc = "You participated in illegal vehicle or spacecraft racing."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/hacker
	name = "Teenage Hacker"
	desc = "You became fascinated with computers and began experimenting with systems you were not supposed to access."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/smuggler
	name = "Teenage Smuggler"
	desc = "You began carrying contraband for other people."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/political_activism
	name = "Political Activism"
	desc = "You became involved in political activism during your teenage years."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/religious_conversion
	name = "Religious Conversion"
	desc = "You became deeply involved with a religious or spiritual movement as a teenager."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/violent_incident
	name = "Violent Incident"
	desc = "A confrontation during your teenage years escalated into serious violence."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/first_kill
	name = "First Kill"
	desc = "You were involved in an incident where someone died for the first time in your life."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/colony_disaster
	name = "Colony Disaster"
	desc = "A major disaster struck your community during your teenage years."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/survival
	name = "Survival Experience"
	desc = "You were forced to survive without normal civilization for several days."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/first_spaceflight
	name = "First Spaceflight"
	desc = "You left your home planet for the first time during your teenage years."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/stowaway
	name = "Stowaway"
	desc = "You secretly boarded a spacecraft and traveled somewhere without permission."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/medical_training
	name = "Medical Training"
	desc = "You began learning medicine after becoming fascinated by emergency care."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/engineering_training
	name = "Engineering Training"
	desc = "You began learning engineering, electronics, or mechanics from an older mentor."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/academic_success
	name = "Academic Success"
	desc = "You excelled academically and earned recognition for your abilities."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/academic_failure
	name = "Academic Failure"
	desc = "Your formal education went badly and you eventually abandoned it."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/expelled
	name = "Expelled"
	desc = "You were expelled from school or another educational institution."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/teenage_parent
	name = "Teenage Parent"
	desc = "You became a parent while still a teenager."

/datum/character_snippet/background/teenage/experimental_implant
	name = "Experimental Implant"
	desc = "You received an unusual cybernetic or medical implant while young."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/clone
	name = "Cloning Incident"
	desc = "An unusual medical incident resulted in you being cloned, copied, or otherwise medically reconstructed."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/psychic_experience
	name = "Strange Psychic Experience"
	desc = "You experienced something you cannot easily explain involving strange mental phenomena."
	//records_type = GENERAL

/datum/character_snippet/background/teenage/ancient_ruins
	name = "Ancient Ruins"
	desc = "You explored an ancient ruin or abandoned facility as a teenager."
	//records_type = GENERAL


//Relationships
/datum/character_snippet/background/relationships/never_dated
	name = "Never Dated"
	desc = "You have never had a serious romantic relationship."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/casual_relationships
	name = "Casual Relationships"
	desc = "You have had several romantic relationships, but none lasted very long."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/long_term_partner
	name = "Long-Term Partner"
	desc = "You have a long-term romantic partner."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/married
	name = "Married"
	desc = "You are currently married."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/divorced
	name = "Divorced"
	desc = "You were married once but eventually divorced."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/widowed
	name = "Widowed"
	desc = "Your spouse died, leaving you alone."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/engaged
	name = "Engaged"
	desc = "You are currently engaged to be married."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/secret_relationship
	name = "Secret Relationship"
	desc = "You are or were involved in a relationship that you kept hidden from others."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/relationship_with_colleague
	name = "Workplace Romance"
	desc = "You became romantically involved with someone you worked alongside."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/relationship_ended_badly
	name = "Bitter Breakup"
	desc = "A serious relationship ended badly and left lasting resentment."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/one_child
	name = "One Child"
	desc = "You have one child."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/multiple_children
	name = "Several Children"
	desc = "You have several children."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/estranged_child
	name = "Estranged Child"
	desc = "You have a child with whom you no longer have a close relationship."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/adopted_child
	name = "Adopted Child"
	desc = "You adopted a child."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/child_elsewhere
	name = "Child Elsewhere"
	desc = "You have a child who lives somewhere far away."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/unknown_child
	name = "Unknown Child"
	desc = "You have a child whose existence you did not learn about until later in life."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/custody_dispute
	name = "Custody Dispute"
	desc = "You became involved in a bitter dispute over custody of a child."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/family_dependency
	name = "Family Provider"
	desc = "You are financially responsible for supporting members of your family."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/family_fallout
	name = "Family Fallout"
	desc = "A romantic relationship caused a major conflict with your family."
	//records_type = GENERAL

/datum/character_snippet/background/relationships/married_for_money
	name = "Marriage of Convenience"
	desc = "You entered a marriage primarily for financial, legal, political, or practical reasons."
	//records_type = GENERAL


//Criminal events
/datum/character_snippet/background/crimes/petty_theft
	name = "Petty Theft"
	desc = "You stole something relatively inexpensive."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/shoplifting
	name = "Shoplifting"
	desc = "You stole goods from a store."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/burglary
	name = "Burglary"
	desc = "You broke into a building intending to steal something."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/vehicle_theft
	name = "Vehicle Theft"
	desc = "You stole a vehicle."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/ship_stowaway
	name = "Stowaway"
	desc = "You illegally boarded a spacecraft and traveled without paying."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/smuggling
	name = "Smuggling"
	desc = "You transported illegal or restricted goods between jurisdictions."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/contraband
	name = "Contraband Possession"
	desc = "You were caught possessing something that was illegal to own."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/drug_distribution
	name = "Drug Distribution"
	desc = "You helped distribute illegal drugs or pharmaceuticals."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/fraud
	name = "Fraud"
	desc = "You participated in a scheme involving forged documents, false identities, or financial deception."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/identity_theft
	name = "Identity Theft"
	desc = "You illegally used another person's identity."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/hacking
	name = "Unauthorized Hacking"
	desc = "You illegally accessed a computer system."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/corporate_espionage
	name = "Corporate Espionage"
	desc = "You stole or acquired confidential information belonging to a corporation."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/bribery
	name = "Bribery"
	desc = "You bribed an official, employee, or other person to obtain something."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/blackmail
	name = "Blackmail"
	desc = "You threatened to expose someone's secrets in exchange for money or favors."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/fence
	name = "Fence"
	desc = "You knowingly helped sell stolen goods."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/gang_association
	name = "Gang Association"
	desc = "You were involved with a criminal organization."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/illegal_fighting
	name = "Illegal Fighting"
	desc = "You participated in an unsanctioned fighting ring."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/assault
	name = "Assault"
	desc = "You were involved in a physical assault."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/accomplice
	name = "Accomplice"
	desc = "You helped someone commit a crimes without personally carrying out the central act."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/witness
	name = "Witness to Crime"
	desc = "You witnessed a serious crimes but were never formally charged with anything."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/wrongfully_accused
	name = "Wrongfully Accused"
	desc = "You were accused of a crimes you did not commit."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/juvenile_record
	name = "Juvenile Record"
	desc = "You have a criminal record dating back to your teenage years."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/arrested
	name = "Arrested"
	desc = "You have been arrested at least once."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/imprisoned
	name = "Imprisoned"
	desc = "You spent time incarcerated for a crimes."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/escaped_prison
	name = "Prison Escape"
	desc = "You were once involved in an escape from custody."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/illegal_mining
	name = "Illegal Mining"
	desc = "You participated in an unauthorized mining operation."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/illegal_salvage
	name = "Illegal Salvage"
	desc = "You salvaged abandoned property without legal authorization."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/black_market
	name = "Black Market Dealer"
	desc = "You have dealt with black-market traders."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/piracy
	name = "Piracy"
	desc = "You participated in piracy or helped a pirate crew."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/deserter
	name = "Desertion"
	desc = "You abandoned a military or security organization without authorization."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/poaching
	name = "Poaching"
	desc = "You illegally hunted or captured protected wildlife."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/illegal_ai
	name = "Illegal Artificial Intelligence"
	desc = "You were involved in the creation, possession, or concealment of an unauthorized artificial intelligence."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/cybercrime
	name = "Cybercrime"
	desc = "You participated in a crimes involving computer networks or digital systems."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/organized_crime
	name = "Organized Crime"
	desc = "You were involved with an organized criminal enterprise."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/crime_victim
	name = "Victim of Crime"
	desc = "You were seriously affected by a criminal act committed against you or your family."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/covered_up_crime
	name = "Covered Up a Crime"
	desc = "You helped conceal evidence of a crimes committed by someone else."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/accidental_crime
	name = "Accidental Crime"
	desc = "You unknowingly broke a law because you did not understand the regulations."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/political_crime
	name = "Political Offense"
	desc = "You were arrested or punished for violating laws that you considered unjust."
	//records_type = PERSONNEL

/datum/character_snippet/background/crimes/stolen_identity
	name = "False Identity"
	desc = "You have lived under a false identity at some point in your life."
	//records_type = PERSONNEL


//education
/datum/character_snippet/background/education/formal_education
	name = "Formal Education"
	desc = "You received a conventional education."
	//records_type = GENERAL

/datum/character_snippet/background/education/university
	name = "University Graduate"
	desc = "You completed higher education."
	//records_type = GENERAL

/datum/character_snippet/background/education/dropout
	name = "University Dropout"
	desc = "You attended university but left before graduating."
	//records_type = GENERAL

/datum/character_snippet/background/education/self_taught
	name = "Self-Taught"
	desc = "Most of your useful knowledge was acquired independently rather than through formal education."
	//records_type = GENERAL

/datum/character_snippet/background/education/apprentice
	name = "Apprentice"
	desc = "You learned your trade directly from an experienced practitioner."
	//records_type = GENERAL

/datum/character_snippet/background/education/corporate_training
	name = "Corporate Training"
	desc = "Your education was primarily provided by a corporation."
	//records_type = GENERAL

/datum/character_snippet/background/education/military_academy
	name = "Military Academy"
	desc = "You attended a military academy or officer school."
	//records_type = GENERAL

/datum/character_snippet/background/education/medical_school
	name = "Medical School"
	desc = "You received formal medical education."
	//records_type = GENERAL

/datum/character_snippet/background/education/engineering_school
	name = "Engineering School"
	desc = "You received formal training in engineering."
	//records_type = GENERAL

/datum/character_snippet/background/education/technical_school
	name = "Technical School"
	desc = "You attended a technical institution focused on practical skills."
	//records_type = GENERAL

/datum/character_snippet/background/education/failed_student
	name = "Poor Student"
	desc = "You struggled academically despite completing your education."
	//records_type = GENERAL

/datum/character_snippet/background/education/academic_prodigy
	name = "Academic Prodigy"
	desc = "You consistently performed exceptionally well in school."
	//records_type = GENERAL

/datum/character_snippet/background/education/expelled
	name = "Expelled Student"
	desc = "You were expelled from an educational institution."
	//records_type = GENERAL

/datum/character_snippet/background/education/prison_education
	name = "Prison Education"
	desc = "You learned many of your practical skills while incarcerated."
	//records_type = GENERAL

/datum/character_snippet/background/education/colony_education
	name = "Colony Education"
	desc = "Your education came from a small community where everyone taught whatever they knew."
	//records_type = GENERAL

/datum/character_snippet/background/education/robotic_tutor
	name = "Robotic Tutor"
	desc = "Much of your childhood education was provided by an automated tutor."
	//records_type = GENERAL

/datum/character_snippet/background/education/ancient_texts
	name = "Ancient Texts"
	desc = "You developed an unusual education through studying old books, records, and historical material."
	//records_type = GENERAL

/datum/character_snippet/background/education/no_education
	name = "No Education"
	desc = "You received almost no formal education growing up."
	//records_type = GENERAL


//work history
/datum/character_snippet/background/work/farmhand
	name = "Farmhand"
	desc = "You spent time working in agriculture."
	//records_type = GENERAL

/datum/character_snippet/background/work/miner
	name = "Miner"
	desc = "You worked in mining operations."
	//records_type = GENERAL

/datum/character_snippet/background/work/mechanic
	name = "Mechanic"
	desc = "You worked repairing machinery and vehicles."
	//records_type = GENERAL

/datum/character_snippet/background/work/engineer
	name = "Engineer"
	desc = "You worked maintaining industrial or station infrastructure."
	//records_type = GENERAL

/datum/character_snippet/background/work/electrician
	name = "Electrician"
	desc = "You worked with electrical systems."
	//records_type = GENERAL

/datum/character_snippet/background/work/plumber
	name = "Plumber"
	desc = "You maintained pipes, pumps, tanks, and other fluid systems."
	//records_type = GENERAL

/datum/character_snippet/background/work/chef
	name = "Chef"
	desc = "You worked preparing food."
	//records_type = GENERAL

/datum/character_snippet/background/work/bartender
	name = "Bartender"
	desc = "You worked serving drinks and listening to other people's problems."
	//records_type = GENERAL

/datum/character_snippet/background/work/janitor
	name = "Janitor"
	desc = "You worked cleaning facilities and dealing with the messes everyone else left behind."
	//records_type = GENERAL

/datum/character_snippet/background/work/doctor
	name = "Doctor"
	desc = "You worked as a medical professional."
	//records_type = GENERAL

/datum/character_snippet/background/work/nurse
	name = "Nurse"
	desc = "You worked providing medical care and assisting doctors."
	//records_type = GENERAL

/datum/character_snippet/background/work/scientist
	name = "Scientist"
	desc = "You worked in scientific research."
	//records_type = GENERAL

/datum/character_snippet/background/work/security
	name = "Security Officer"
	desc = "You worked in law enforcement or security."
	//records_type = GENERAL

/datum/character_snippet/background/work/courier
	name = "Courier"
	desc = "You spent time transporting packages, documents, or people."
	//records_type = GENERAL

/datum/character_snippet/background/work/trader
	name = "Trader"
	desc = "You made your living buying and selling goods."
	//records_type = GENERAL

/datum/character_snippet/background/work/merchant
	name = "Merchant"
	desc = "You operated or worked in a commercial business."
	//records_type = GENERAL

/datum/character_snippet/background/work/salvager
	name = "Salvager"
	desc = "You made money recovering useful materials from abandoned locations."
	//records_type = GENERAL

/datum/character_snippet/background/work/mercenary
	name = "Mercenary"
	desc = "You worked as a soldier for hire."
	//records_type = GENERAL

/datum/character_snippet/background/work/pirate
	name = "Pirate"
	desc = "You spent part of your life aboard a pirate vessel."
	//records_type = GENERAL

/datum/character_snippet/background/work/ship_crew
	name = "Ship Crew"
	desc = "You worked aboard a spacecraft."
	//records_type = GENERAL

/datum/character_snippet/background/work/colonist
	name = "Colonist"
	desc = "You helped establish or maintain a new settlement."
	//records_type = GENERAL

/datum/character_snippet/background/work/teacher
	name = "Teacher"
	desc = "You worked teaching others."
	//records_type = GENERAL

/datum/character_snippet/background/work/research_assistant
	name = "Research Assistant"
	desc = "You worked assisting scientists with experiments and laboratory work."
	//records_type = GENERAL

/datum/character_snippet/background/work/corporate_employee
	name = "Corporate Employee"
	desc = "You spent years working for a large corporation."
	//records_type = GENERAL

/datum/character_snippet/background/work/freelancer
	name = "Freelancer"
	desc = "You rarely held conventional employment and instead survived by taking temporary jobs."
	//records_type = GENERAL

/datum/character_snippet/background/work/unemployed
	name = "Unemployed"
	desc = "You spent a significant period of your life without stable employment."
	//records_type = GENERAL


//Military and combat experience
/datum/character_snippet/background/military/civilian
	name = "Civilian"
	desc = "You have never served in a military organization."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/militia
	name = "Colonial Militia"
	desc = "You served in a local militia."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/army
	name = "Army Veteran"
	desc = "You served in a conventional military."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/navy
	name = "Navy Veteran"
	desc = "You served aboard military spacecraft."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/marine
	name = "Marine Veteran"
	desc = "You served as part of a military marine force."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/security
	name = "Security Veteran"
	desc = "You served in professional law enforcement."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/mercenary
	name = "Mercenary Veteran"
	desc = "You spent years fighting for whoever could afford your services."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/ship_security
	name = "Ship Security"
	desc = "You worked as security aboard civilian spacecraft."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/bodyguard
	name = "Bodyguard"
	desc = "You worked protecting an individual or organization."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/convoy_guard
	name = "Convoy Guard"
	desc = "You protected cargo convoys traveling through dangerous territory."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/frontier_defender
	name = "Frontier Defender"
	desc = "You fought to protect a frontier settlement."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/war_survivor
	name = "War Survivor"
	desc = "You survived an armed conflict."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/deserter
	name = "Deserter"
	desc = "You abandoned your military service before completing your obligation."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/veteran_injury
	name = "Combat Injury"
	desc = "You suffered a significant injury during military service."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/combat_medic
	name = "Combat Medic"
	desc = "You provided medical care during armed conflicts."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/logistics
	name = "Military Logistics"
	desc = "You supported military operations through transportation, supply, and logistics."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/quartermaster
	name = "Quartermaster"
	desc = "You were responsible for managing military supplies."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/prisoner_of_war
	name = "Prisoner of War"
	desc = "You were captured and held prisoner during a conflict."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY

/datum/character_snippet/background/military/refugee
	name = "War Refugee"
	desc = "You were forced to flee your home because of war."
	//records_type = PERSONNEL
	//records_type_2 = SECURITY


//Medical History
/datum/character_snippet/background/medical/childhood_illness
	name = "Childhood Illness"
	desc = "You suffered a serious illness as a child but eventually recovered."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/surgery
	name = "Major Surgery"
	desc = "You underwent a major surgical procedure earlier in life."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/cybernetic
	name = "Cybernetic Implant"
	desc = "You have at least one cybernetic implant."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/prosthetic
	name = "Prosthetic"
	desc = "You lost a body part and received a prosthetic replacement."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/cloning
	name = "Cloning"
	desc = "You have been cloned or reconstructed after death."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/near_death
	name = "Near Death"
	desc = "You nearly died at some point in your life."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/coma
	name = "Coma"
	desc = "You spent an extended period unconscious due to an accident or illness."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/radiation
	name = "Radiation Exposure"
	desc = "You were exposed to dangerous radiation."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/chemical_exposure
	name = "Chemical Exposure"
	desc = "You were seriously exposed to a hazardous chemical."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/experimental_treatment
	name = "Experimental Treatment"
	desc = "You underwent an experimental medical treatment."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/black_market_treatment
	name = "Black Market Medicine"
	desc = "You received medical treatment from an unlicensed practitioner."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/medical_debt
	name = "Medical Debt"
	desc = "Medical treatment left you with significant financial debt."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/doctor_family
	name = "Doctor's Child"
	desc = "A medically trained family member taught you basic healthcare."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/first_responder
	name = "First Responder"
	desc = "You were trained to respond to emergencies."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/quarantine
	name = "Quarantine"
	desc = "You were once confined during a disease outbreak."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/plague_survivor
	name = "Plague Survivor"
	desc = "You survived a serious epidemic."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/genetic_treatment
	name = "Genetic Treatment"
	desc = "You received a significant genetic modification or medical treatment."
	//records_type = MEDICAL

/datum/character_snippet/background/medical/organ_transplant
	name = "Organ Transplant"
	desc = "You received an organ transplant."
	//records_type = MEDICAL


//Economic background
/datum/character_snippet/background/economy/wealthy
	name = "Wealthy"
	desc = "You grew up with considerable financial security."
	//records_type = GENERAL

/datum/character_snippet/background/economy/comfortable
	name = "Comfortable"
	desc = "Your family was financially stable without being especially wealthy."
	//records_type = GENERAL

/datum/character_snippet/background/economy/poor
	name = "Poor"
	desc = "Your family lived with persistent financial difficulties."
	//records_type = GENERAL

/datum/character_snippet/background/economy/deep_poverty
	name = "Deep Poverty"
	desc = "You grew up without reliable access to many basic necessities."
	//records_type = GENERAL

/datum/character_snippet/background/economy/debt
	name = "Family Debt"
	desc = "Your family accumulated substantial debt."
	//records_type = GENERAL

/datum/character_snippet/background/economy/inherited_debt
	name = "Inherited Debt"
	desc = "You inherited significant debts from a family member."
	//records_type = GENERAL

/datum/character_snippet/background/economy/lucky_inheritance
	name = "Inheritance"
	desc = "You unexpectedly inherited money or property."
	//records_type = GENERAL

/datum/character_snippet/background/economy/lost_inheritance
	name = "Lost Inheritance"
	desc = "Your family once had substantial wealth but lost it."
	//records_type = GENERAL

/datum/character_snippet/background/economy/corporate_contract
	name = "Corporate Contract"
	desc = "Your family was bound to a corporation through employment or debt."
	//records_type = GENERAL

/datum/character_snippet/background/economy/indentured
	name = "Indentured Labor"
	desc = "You or your family were once bound to work off a debt."
	//records_type = GENERAL

/datum/character_snippet/background/economy/black_market
	name = "Black Market Income"
	desc = "You have relied on illegal markets to make ends meet."
	//records_type = GENERAL

/datum/character_snippet/background/economy/gambler
	name = "Gambling"
	desc = "You developed a history of gambling with your money."
	//records_type = GENERAL

/datum/character_snippet/background/economy/bankruptcy
	name = "Bankruptcy"
	desc = "You or your family declared bankruptcy."
	//records_type = GENERAL

/datum/character_snippet/background/economy/entrepreneur
	name = "Entrepreneur"
	desc = "You attempted to build your own business."
	//records_type = GENERAL

/datum/character_snippet/background/economy/business_failure
	name = "Business Failure"
	desc = "A business you were involved with failed."
	//records_type = GENERAL

/datum/character_snippet/background/economy/business_success
	name = "Business Success"
	desc = "You once operated a successful business."
	//records_type = GENERAL

/datum/character_snippet/background/economy/lottery
	name = "Lottery Winner"
	desc = "You once won a substantial amount of money through a lottery or similar game."
	//records_type = GENERAL

/datum/character_snippet/background/economy/financial_fraud
	name = "Financial Fraud"
	desc = "You became involved in a scheme involving money, investments, or financial manipulation."
	//records_type = GENERAL



//Social Background
/datum/character_snippet/background/social/isolated
	name = "Isolated Childhood"
	desc = "You grew up in an isolated community with little contact with outsiders."
	//records_type = GENERAL

/datum/character_snippet/background/social/crowded
	name = "Crowded Childhood"
	desc = "You grew up surrounded by large numbers of people and rarely experienced solitude."
	//records_type = GENERAL

/datum/character_snippet/background/social/celebrity
	name = "Celebrity Childhood"
	desc = "You grew up around someone famous and became accustomed to public attention."
	//records_type = GENERAL

/datum/character_snippet/background/social/anonymous
	name = "Anonymous Life"
	desc = "You grew up somewhere so large that nobody knew or cared who you were."
	//records_type = GENERAL

/datum/character_snippet/background/social/cultural_outsider
	name = "Cultural Outsider"
	desc = "You grew up in a culture very different from the one you currently inhabit."
	//records_type = GENERAL

/datum/character_snippet/background/social/immigrant
	name = "Immigrant"
	desc = "You moved to a new world and had to adapt to a different society."
	//records_type = GENERAL

/datum/character_snippet/background/social/refugee
	name = "Refugee"
	desc = "You were forced to relocate because your original home became unsafe."
	//records_type = GENERAL

/datum/character_snippet/background/social/nomad
	name = "Nomadic"
	desc = "You rarely stayed in one place for long."
	//records_type = GENERAL

/datum/character_snippet/background/social/community_leader
	name = "Community Leader"
	desc = "You were raised in a family that held an important position within a small community."
	//records_type = GENERAL

/datum/character_snippet/background/social/outcast
	name = "Outcast"
	desc = "You were considered an outsider by the community you grew up in."
	//records_type = GENERAL

/datum/character_snippet/background/social/religious_community
	name = "Religious Community"
	desc = "You were raised within a close-knit religious community."
	//records_type = GENERAL

/datum/character_snippet/background/social/commune
	name = "Commune"
	desc = "You were raised in a communal society where property and responsibilities were largely shared."
	//records_type = GENERAL

/datum/character_snippet/background/social/corporate_culture
	name = "Corporate Culture"
	desc = "Corporate life was deeply integrated into your upbringing."
	//records_type = GENERAL

/datum/character_snippet/background/social/frontier_culture
	name = "Frontier Culture"
	desc = "You were raised in a culture that valued independence and self-sufficiency."
	//records_type = GENERAL

/datum/character_snippet/background/social/station_culture
	name = "Station Culture"
	desc = "You grew up in the unique culture of a large space station."
	//records_type = GENERAL

/datum/character_snippet/background/social/pirate_culture
	name = "Pirate Culture"
	desc = "You grew up around pirates and became familiar with their customs."
	//records_type = GENERAL

/datum/character_snippet/background/social/military_culture
	name = "Military Culture"
	desc = "Your upbringing was heavily influenced by military traditions and discipline."
	//records_type = GENERAL

/datum/character_snippet/background/social/celebrity
	name = "Local Celebrity"
	desc = "You became locally famous for something you did while growing up."
	//records_type = GENERAL

/datum/character_snippet/background/social/infamous
	name = "Infamous Family"
	desc = "Your family was known throughout your community, although not necessarily for good reasons."
	//records_type = GENERAL
	//records_type_2 = PERSONNEL


//Beliefs
/datum/character_snippet/background/beliefs/religious_upbringing
	name = "Religious Upbringing"
	desc = "You were raised within an organized religion."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/left_religion
	name = "Left the Faith"
	desc = "You were raised religious but eventually abandoned your family's faith."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/converted
	name = "Converted"
	desc = "You adopted a new religion or philosophy later in life."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/atheist_family
	name = "Atheist Family"
	desc = "You were raised in a household where religion played little or no role."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/spiritual
	name = "Spiritual"
	desc = "You developed personal spiritual beliefs without joining an organized religion."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/cult_survivor
	name = "Cult Survivor"
	desc = "You were raised within or temporarily joined a secretive religious movement."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/philosopher
	name = "Philosopher"
	desc = "You became deeply interested in questions about morality, existence, and society."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/corporate_loyalist
	name = "Corporate Loyalist"
	desc = "You were raised to believe strongly in the ideals of your corporation."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/frontier_individualist
	name = "Frontier Individualist"
	desc = "You were raised to believe that individuals should rely primarily upon themselves."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/collectivist
	name = "Collectivist"
	desc = "You were raised in a culture that emphasized communal responsibility."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/nihilist
	name = "Nihilist"
	desc = "You developed a deeply pessimistic view of existence."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/optimist
	name = "Optimist"
	desc = "You developed an unusually hopeful view of the future."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/ancestor_worship
	name = "Ancestor Tradition"
	desc = "Your culture placed significant importance on remembering and honoring ancestors."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/folk_beliefs
	name = "Folk Beliefs"
	desc = "You grew up with superstitions and traditional beliefs that were never formally organized."
	//records_type = GENERAL

/datum/character_snippet/background/beliefs/ai_believer
	name = "Machine Faith"
	desc = "You developed a beliefs system centered around artificial intelligence, machines, or synthetic life."
	//records_type = GENERAL


//Disaster Events
/datum/character_snippet/background/disaster/shipwreck
	name = "Shipwreck"
	desc = "A spacecraft you were aboard suffered a catastrophic accident."
//records_type = GENERAL

/datum/character_snippet/background/disaster/escape_pod
	name = "Escape Pod"
	desc = "You once survived an emergency evacuation in an escape pod."
//records_type = GENERAL

/datum/character_snippet/background/disaster/explosion
	name = "Explosion"
	desc = "You survived a serious explosion."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/fire
	name = "Fire"
	desc = "You survived a major fire."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/hull_breach
	name = "Hull Breach"
	desc = "You experienced a hull breach while aboard a spacecraft or station."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/meteor
	name = "Meteor Strike"
	desc = "A meteor strike caused serious damage to somewhere you were living."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/reactor
	name = "Reactor Accident"
	desc = "You survived an accident involving a nuclear or other high-energy reactor."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/plasma_leak
	name = "Plasma Leak"
	desc = "You were present during a dangerous plasma or fuel leak."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/colony_collapse
	name = "Colony Collapse"
	desc = "A settlement you depended upon collapsed."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/power_grid
	name = "Power Grid Failure"
	desc = "A major power failure left your community struggling to survive."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/famine
	name = "Famine"
	desc = "You survived a period when food became dangerously scarce."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/disease_outbreak
	name = "Disease Outbreak"
	desc = "You survived a serious disease outbreak."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/hostile_wildlife
	name = "Wildlife Disaster"
	desc = "A dangerous animal population became a serious threat to your settlement."

/datum/character_snippet/background/disaster/solar_flare
	name = "Solar Flare"
	desc = "You experienced a severe solar storm that disrupted communications and technology."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/evacuation
	name = "Mass Evacuation"
	desc = "You were part of a mass evacuation from a doomed settlement."

/datum/character_snippet/background/disaster/stranded
	name = "Stranded"
	desc = "You were stranded somewhere without reliable communication or supplies."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/rescue
	name = "Rescue"
	desc = "You survived a disaster only because another person or group rescued you."
	//records_type = GENERAL

/datum/character_snippet/background/disaster/disaster_caused
	name = "Caused a Disaster"
	desc = "You accidentally caused an event that seriously endangered other people."
	//records_type = GENERAL


//Secrets
/datum/character_snippet/background/secrets/secret_identity
	name = "Secret Identity"
	desc = "You have concealed your true identity from the people around you."

/datum/character_snippet/background/secrets/secret_family
	name = "Secret Family"
	desc = "You have a family connection that you have never revealed."

/datum/character_snippet/background/secrets/secret_crime
	name = "Secret Crime"
	desc = "You committed a crimes that nobody ever discovered."

/datum/character_snippet/background/secrets/secret_death
	name = "Secret Death"
	desc = "Someone died because of something you did or failed to do, and nobody knows the truth."

/datum/character_snippet/background/secrets/false_credentials
	name = "False Credentials"
	desc = "Some of your qualifications or documents are fraudulent."

/datum/character_snippet/background/secrets/false_age
	name = "False Age"
	desc = "The age you claim is not your actual age."

/datum/character_snippet/background/secrets/hidden_wealth
	name = "Hidden Wealth"
	desc = "You secretly possess money or property that nobody knows about."

/datum/character_snippet/background/secrets/hidden_debt
	name = "Hidden Debt"
	desc = "You owe someone a substantial amount of money but have kept it secret."

/datum/character_snippet/background/secrets/secret_affiliation
	name = "Secret Affiliation"
	desc = "You secretly belong to an organization, faction, or movement."

/datum/character_snippet/background/secrets/secret_past
	name = "Secret Past"
	desc = "You have deliberately hidden a significant portion of your past."

/datum/character_snippet/background/secrets/secret_child
	name = "Secret Child"
	desc = "You have a child whose existence you have concealed."

/datum/character_snippet/background/secrets/secret_spouse
	name = "Secret Marriage"
	desc = "You are secretly married or were secretly married."

/datum/character_snippet/background/secrets/witness_protection
	name = "Protected Witness"
	desc = "You were once relocated or given a new identity after cooperating with authorities."

/datum/character_snippet/background/secrets/wanted
	name = "Wanted"
	desc = "Someone, somewhere, still wants you arrested."

/datum/character_snippet/background/secrets/fake_death
	name = "Faked Death"
	desc = "At some point you deliberately allowed others to believe you were dead."
