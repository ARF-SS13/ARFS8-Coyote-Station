/datum/supply_pack/security
	group = "Security"
	access = ACCESS_SECURITY
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/armor
	name = "Armor Crate"
	desc = "Three vests of well-rounded, decently-protective armor."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/suit/armor/vest = 3)
	crate_name = "armor crate"

/datum/supply_pack/security/modsuit_plating
	name = "Security MOD plating"
	desc = "A single security MOD suit plating"
	cost = CARGO_CRATE_VALUE
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/mod/construction/plating/security)
	crate_name = "MOD plating crate"

/datum/supply_pack/security/disabler
	name = "Disabler Crate"
	desc = "Three stamina-draining disabler weapons."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/gun/energy/disabler = 3)
	crate_name = "disabler crate"

/datum/supply_pack/security/forensics
	name = "Forensics Crate"
	desc = "Stay hot on the criminal's heels with Nanotrasen's Detective Essentials™. \
		Contains a forensics scanner, six evidence bags, camera, special board for evidences, tape recorder, stick of chalk, \
		and of course, a fedora."
	cost = CARGO_CRATE_VALUE * 2.5
	access_view = ACCESS_MORGUE
	contains = list(/obj/item/detective_scanner,
					/obj/item/storage/box/evidence,
					/obj/item/camera,
					/obj/item/taperecorder,
					/obj/item/toy/crayon/white,
					/obj/item/clothing/head/fedora/det_hat,
					/obj/item/wallframe/detectiveboard
				)
	crate_name = "forensics crate"

/datum/supply_pack/security/helmets
	name = "Helmets Crate"
	desc = "Contains three standard-issue brain buckets."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/sec = 3)
	crate_name = "helmet crate"

/datum/supply_pack/security/securitybarriers
	name = "Security Barrier Grenades"
	desc = "Stem the tide with four Security Barrier grenades."
	access_view = ACCESS_BRIG
	contains = list(/obj/item/grenade/barrier = 4)
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "security barriers crate"

/datum/supply_pack/security/securityclothes
	name = "Security Clothing Crate"
	desc = "Contains appropriate outfits for the station's private security force. \
		Contains outfits for the Warden, Head of Security, and two Security Officers. \
		Each outfit comes with a rank-appropriate jumpsuit, suit, and beret."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/under/rank/security/officer/formal = 2,
					/obj/item/clothing/suit/jacket/officer/blue = 2,
					/obj/item/clothing/head/beret/sec/navyofficer = 2,
					/obj/item/clothing/under/rank/security/warden/formal,
					/obj/item/clothing/suit/jacket/warden/blue,
					/obj/item/clothing/head/beret/sec/navywarden,
					/obj/item/clothing/under/rank/security/head_of_security/formal,
					/obj/item/clothing/suit/jacket/hos/blue,
					/obj/item/clothing/head/hats/hos/beret/navyhos,
				)
	crate_name = "security clothing crate"

/datum/supply_pack/security/stingpack
	name = "Stingbang Grenade Pack"
	desc = "Contains five \"stingbang\" grenades, perfect for stopping \
		riots and playing morally unthinkable pranks."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/stingbangs)
	crate_name = "stingbang grenade pack crate"

/datum/supply_pack/security/supplies
	name = "Security Supplies Crate"
	desc = "Contains seven flashbangs, seven teargas grenades, six flashes, and seven handcuffs."
	cost = CARGO_CRATE_VALUE * 3.5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas,
					/obj/item/storage/box/flashes,
					/obj/item/storage/box/handcuffs,
				)
	crate_name = "security supply crate"

/datum/supply_pack/security/maintenance_kits
	name = "Gun Maintenance Kits"
	desc = "Three gun maintenance kits for the repair and maintenance of a firearm."
	access_view = ACCESS_BRIG
	contains = list(/obj/item/gun_maintenance_supplies = 3)
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "gun maintenance kit crate"

/datum/supply_pack/security/firingpins
	name = "Standard Firing Pins Crate"
	desc = "Upgrade your arsenal with 10 standard firing pins."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins = 2)
	crate_name = "firing pins crate"

/datum/supply_pack/security/firingpins/paywall
	name = "Paywall Firing Pins Crate"
	desc = "Specialized firing pins with a built-in configurable paywall."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins/paywall = 2)
	crate_name = "paywall firing pins crate"

/datum/supply_pack/security/justiceinbound
	name = "Standard Justice Enforcer Crate"
	desc = "This is it. The Bee's Knees. The Creme of the Crop. The Pick of the Litter. \
		The best of the best of the best. The Crown Jewel of Nanotrasen. \
		The Alpha and the Omega of security headwear. Guaranteed to strike fear into the hearts \
		of each and every criminal aboard the station. Also comes with a security gasmask."
	cost = CARGO_CRATE_VALUE * 6 //justice comes at a price. An expensive, noisy price.
	order_flags = ORDER_CONTRABAND
	contains = list(/obj/item/clothing/head/helmet/toggleable/justice,
					/obj/item/clothing/mask/gas/sechailer,
				)
	crate_name = "security clothing crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/security/baton
	name = "Stun Batons Crate"
	desc = "Arm the Civil Protection Forces with three stun batons. Batteries included."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/melee/baton/security/loaded = 3)
	crate_name = "stun baton crate"

/datum/supply_pack/security/wall_flash
	name = "Wall-Mounted Flash Crate"
	desc = "Contains four wall-mounted flashes."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/wall_flash = 4)
	crate_name = "wall-mounted flash crate"

/datum/supply_pack/security/constable
	name = "Traditional Equipment Crate"
	desc = "Spare equipment found in a warehouse. Contains a constable's outfit, \
		whistle, and conversion kit."
	cost = CARGO_CRATE_VALUE * 2.2
	order_flags = ORDER_CONTRABAND
	contains = list(/obj/item/clothing/under/rank/security/constable,
					/obj/item/clothing/head/costume/constable,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/whistle,
					/obj/item/conversion_kit,
				)
	crate_name = "traditional equipment crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/// Armory packs

/datum/supply_pack/security/armory
	group = "Armory"
	access = ACCESS_ARMORY
	access_view = ACCESS_ARMORY
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/bulletarmor
	name = "Bulletproof Armor Crate"
	desc = "Contains three sets of bulletproof armor. Guaranteed to reduce a bullet's \
		stopping power by over half."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/suit/armor/bulletproof = 3)
	crate_name = "bulletproof armor crate"

/datum/supply_pack/security/armory/bullethelmets
	name = "Bulletproof Helmets Crate"
	desc = "Contains three bulletproof helmets."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/alt = 3)
	crate_name = "bulletproof helmets crate"

/datum/supply_pack/security/armory/chemimp
	name = "Chemical Implants Crate"
	desc = "Contains five Remote Chemical implants."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/chemimp)
	crate_name = "chemical implant crate"

/datum/supply_pack/security/armory/dragnet
	name = "DRAGnet Translocation Shotgun Crate"
	desc = "Contains two \"Dynamic Rapid-Apprehension of the Guilty Network\" translocation shotguns, \
		a recent breakthrough in law enforcement prisoner management technology. Includes a DRAGnet beacon."
	cost = CARGO_CRATE_VALUE * 18
	contains = list(
		/obj/item/gun/energy/e_gun/dragnet = 2,
		/obj/item/dragnet_beacon = 1
	)
	crate_name = "\improper DRAGnet crate"

/datum/supply_pack/security/armory/energy
	name = "SC-2 Energy Carbine Crate"
	desc = "Contains three hybrid energy guns, capable of firing both nonlethal and lethal \
		blasts of light."
	cost = CARGO_CRATE_VALUE * 18
	contains = list(/obj/item/gun/energy/e_gun = 3)
	crate_name = "energy carbine crate"

/datum/supply_pack/security/armory/laser
	name = "SC-1 Laser Carbine Crate"
	desc = "Contains three standard issue laser guns, for when the going gets tough."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/gun/energy/laser = 3)
	crate_name = "\improper laser carbine crate"

/datum/supply_pack/security/armory/laser_carbine
	name = "SC-1A Laser Auto-Carbine Crate"
	desc = "Contains three laser auto-carbines, featuring a rapid burst of slightly weaker laser projectiles."
	cost = CARGO_CRATE_VALUE * 9
	contains = list(/obj/item/gun/energy/laser/carbine = 3)
	crate_name = "\improper laser auto-carbine crate"

/datum/supply_pack/security/armory/practice_carbine
	name = "SC-1N Practice Carbine Crate"
	desc = "Contains three nonlethal training carbines. Not intended for field use."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/gun/energy/laser/carbine/practice = 3)
	crate_name = "\improper practice carbine crate"

/datum/supply_pack/security/armory/laser_pistol
	name = "SC-1P Laser Pistol Crate"
	desc = "Contains three compact laser pistols. Easily concealed lethal firearms are not part of the standard security kit. Distribution is not adviced without command clearance and good reason."
	cost = CARGO_CRATE_VALUE * 18
	contains = list(/obj/item/gun/energy/laser/pistol = 3)
	crate_name = "\improper laser pistol crate"

/datum/supply_pack/security/armory/laser_shotgun
	name = "SC-1S Scatter Carbine Crate"
	desc = "Contains three laser scatterguns with adjustable refractors."
	cost = CARGO_CRATE_VALUE * 9
	contains = list(/obj/item/gun/energy/laser/scatter = 3)
	crate_name = "\improper scatter carbine crate"

/datum/supply_pack/security/armory/laser_assault
	name = "SC-4 assault laser rifle Crate"
	desc = "Contains three miltary-grade laser rifles. High power, high capacity, EMP shielded. What more could you ask for? No, you can't have a gygax. No you can't have a pulse rifle either. Shush."
	cost = CARGO_CRATE_VALUE * 50
	contains = list(/obj/item/gun/energy/laser/assault = 3)
	crate_name = "\improper scatter carbine crate"

/datum/supply_pack/security/armory/disabler_smg
	name = "Disabler SMG Crate"
	desc = "Contains three disabler SMGs, capable of rapidly firing weak disabler beams."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/gun/energy/disabler/smg = 3)
	crate_name = "disabler smg crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/exileimp
	name = "Exile Implants Crate"
	desc = "Contains five Exile implants."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/exileimp)
	crate_name = "exile implant crate"

/datum/supply_pack/security/armory/fire
	name = "Incendiary Weapons Crate"
	desc = "Burn, baby burn. Contains three incendiary grenades, three plasma canisters, \
		and a flamethrower."
	cost = CARGO_CRATE_VALUE * 7
	access = ACCESS_COMMAND
	contains = list(/obj/item/flamethrower/full,
					/obj/item/tank/internals/plasma = 3,
					/obj/item/grenade/chem_grenade/incendiary = 3,
				)
	crate_name = "incendiary weapons crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	order_flags = ORDER_DANGEROUS

/datum/supply_pack/security/armory/mindshield
	name = "Mindshield Implants Crate"
	desc = "Prevent against radical thoughts with three Mindshield implants."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/storage/lockbox/loyalty)
	crate_name = "mindshield implant crate"

/datum/supply_pack/security/armory/trackingimp
	name = "Tracking Implants Crate"
	desc = "Contains four tracking implants."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/trackimp)
	crate_name = "tracking implant crate"

/datum/supply_pack/security/armory/laserarmor
	name = "Reflector Vest Crate"
	desc = "Contains two vests of highly reflective material. Each armor piece \
		diffuses a laser's energy by over half, as well as offering a good chance \
		to reflect the laser entirely."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/clothing/suit/armor/laserproof = 2)
	crate_name = "reflector vest crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/riotarmor
	name = "Riot Armor Crate"
	desc = "Contains three sets of heavy body armor. Advanced padding protects \
		against close-ranged weaponry, making melee attacks feel only half as \
		potent to the user."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/clothing/suit/armor/riot = 3)
	crate_name = "riot armor crate"

/datum/supply_pack/security/armory/riothelmets
	name = "Riot Helmets Crate"
	desc = "Contains three riot helmets."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/clothing/head/helmet/toggleable/riot = 3)
	crate_name = "riot helmets crate"

/datum/supply_pack/security/armory/riotshields
	name = "Riot Shields Crate"
	desc = "For when the greytide gets really uppity. Contains three riot shields."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/shield/riot = 3)
	crate_name = "riot shields crate"

/datum/supply_pack/security/armory/swat
	name = "SWAT Crate"
	desc = "Contains two fullbody sets of tough, fireproof suits designed in a joint \
		effort by IS-ERI and Nanotrasen. Each set contains a suit, helmet, mask, combat belt, \
		and gorilla gloves."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/clothing/head/helmet/swat/nanotrasen = 2,
					/obj/item/clothing/suit/armor/swat = 2,
					/obj/item/clothing/mask/gas/sechailer/swat = 2,
					/obj/item/storage/belt/military/assault = 2,
					/obj/item/clothing/gloves/tackler/combat = 2,
				)
	crate_name = "swat crate"

/datum/supply_pack/security/sunglasses
	name = "Sunglasses Crate"
	desc = "A single pair of flash-proof sunglasses."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/glasses/sunglasses = 1)
	crate_name = "sunglasses crate"

/datum/supply_pack/security/armory/mechthermal
	name = "Heavy Thermal Guns Crate"
	desc = "Contains two experimental thermal cannons for use by mechs. \
		When used simultaneously, their excess power used to heat and cool the opposing weapon, \
		increasing the reload speed."
	cost = CARGO_CRATE_VALUE * 25
	contains = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/thermal/cryo,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/thermal/inferno,
	)
	crate_name = "thermal cannons crate"

/datum/supply_pack/security/blood_worm_testers
	name = "Hemoparasite Testing Crate"
	desc = "Contains four single-use hemoparasite testing tools. \
		These devices accurately report whether a patient is inhabited by a hemoparasite, such as the infamous space-faring blood worm. \
		The DeForest Medical Corporation claims no liability for any mental and/or physical trauma caused to patients from the improper use of these devices."
	cost = CARGO_CRATE_VALUE * 50 // These aren't meant to be bought en-masse.
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/blood_worm_tester = 4)
	crate_name = "hemoparasite testing crate"

// I am DEVIOUS and CRUEL! you get two speedloaders, no more. you'll have to manually reload and reuse them.
// you're using a revolver. it shouldn't be streamlined. it's your fidget toy so embrace it
/datum/supply_pack/security/c38_standard
	name = ".38 Special Ammo Crate (Bulk)"
	desc = "Contains bulk .38 Special ammo to keep the detective's revolver fed."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/c38 = 2)
	crate_name = ".38 Special ammo crate (bulk)"

/datum/supply_pack/security/c38_specialty
	name = ".38 Special Ammo Crate (Specialty)"
	desc = "Contains specialty .38 Special ammo for nonstandard circumstances."
	cost = CARGO_CRATE_VALUE * 4 // arfs: unsure if too much cost. will see
	contains = list(/obj/item/storage/box/c38/rubber,
					/obj/item/storage/box/c38/dumdum,
				)
	crate_name = ".38 Special ammo crate (specialty)"

/datum/supply_pack/security/c38_precision
	name = ".38 Special Ammo Crate (Precision)"
	desc = "Contains precision engineered .38 Special ammo for trickshots and tracking targets."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/c38/match,
					/obj/item/storage/box/c38/trac,
				)
	crate_name = ".38 Special ammo crate (precision)"

/datum/supply_pack/security/c38_thermal
	name = ".38 Special Ammo Crate (Thermal)"
	desc = "Contains chemical .38 Special ammo for exploiting temperature weaknesses in exotic targets."
	cost = CARGO_CRATE_VALUE * 6 // arfs: extra fancy, extra spendy. these have always hard to get ahold of
	contains = list(/obj/item/storage/box/c38/hotshot,
					/obj/item/storage/box/c38/iceblox,
				)
	crate_name = ".38 Special ammo crate (thermal)"

/datum/supply_pack/security/armory/sec_shotgun
	name = "Shotgun Crate (Security)"
	desc = "Contains a pair of shotguns in standard security color. They come preloaded with beanbags and a set of empty bandoliers."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/gun/ballistic/shotgun/snowsec = 2,
					/obj/item/storage/belt/shotgun_bandolier = 2,
				)
	crate_name = "shotgun crate"

/datum/supply_pack/security/armory/hunting_shotgun
	name = "Shotgun Crate (Hunting)"
	desc = "Contains a pair of shotguns with classy wood furniture. They come preloaded with buckshot so you can get to carp killing quicker."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/gun/ballistic/shotgun/hunting = 2,
					/obj/item/storage/belt/shotgun_bandolier = 2,
				)
	crate_name = "shotgun crate"

/datum/supply_pack/security/armory/tactical_shotgun
	name = "Shotgun Crate (Tactical)"
	desc = "Contains a pair of shotguns with extended tubes and holographic sights. They come preloaded with rubber shot for optimal clown suppression."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(/obj/item/gun/ballistic/shotgun/tactical = 2,
					/obj/item/storage/belt/shotgun_bandolier = 2,
				)
	crate_name = "shotgun crate"

/datum/supply_pack/security/armory/shotshell_lethal
	name = "Shotshell Ammo Crate (Lethal)"
	desc = "Contains three boxes of lethal shotgun shells for carp hunting and more!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/lethalshot = 2,
					/obj/item/storage/box/slugs = 1,
				)
	crate_name = "shotshell ammo crate"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/armory/shotshell_lesslethal
	name = "Shotshell Ammo Crate (Less Lethal)"
	desc = "Contains three boxes of less lethal shotgun shells for riot control. WARNING: LESS LETHAL DOES NOT MEAN NONLETHAL! These should not be used on normal crew under standard circumstances."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/rubbershot = 2,
					/obj/item/storage/box/beanbag = 1,
				)
	crate_name = "shotshell ammo crate"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/armory/mosin_nagant
	name = "Mosin Nagant Crate"
	desc = "Contains six mosin nagant rifles packed in cosmoline. Most ballistics have been supplanted by much safer energy firearms, however A few have stuck around for their exceptional reliability, simplicity, and abundance. The mosin nagant is some of those things."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/gun/ballistic/rifle/mosin/random = 6,
					/obj/item/rag = 1,
				)
	crate_name = "mosin nagant crate"

/datum/supply_pack/security/armory/mosin_ammo
	name = "Mosin Nagant Ammo Crate"
	desc = "Contains six boxes of ammunition for the mosin nagant. Nanotrassen does not supply stripper clips because a very confused shareholder wants to preserve the company's family friendly image."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/storage/box/m762r = 6)
	crate_name = "mosin nagant ammo crate"

/datum/supply_pack/security/patrol_ammo
	name = "Patrol Rifle Ammo Crate"
	desc = "Contains two boxes of ammo for the patrol rifle. The cartridges are non-rechargeable and proprietary in design, for YOUR safety."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/patrol = 2)
	crate_name = "patrol rifle ammo crate"

/datum/supply_pack/security/patrol_ammo_practice
	name = "Patrol Rifle Practice Ammo Crate"
	desc = "Contains two boxes of nonlethal training ammo for the patrol rifle. The cartridges are non-rechargeable and proprietary in design, for YOUR safety."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/patrol_practice = 2)
	crate_name = "patrol rifle ammo crate"
