// This file contains everything used by security, or in other combat applications.

/obj/item/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/stingbangs
	name = "box of stingbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause severe injuries or death in repeated use.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/stingbangs/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/box/flashes
	name = "box of flashbulbs"
	desc = "<B>WARNING: Flashes can cause serious eye damage, protective eyewear is required.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/box/wall_flash
	name = "wall-mounted flash kit"
	desc = "This box contains everything necessary to build a wall-mounted flash. <B>WARNING: Flashes can cause serious eye damage, protective eyewear is required.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/wall_flash/PopulateContents()
	var/id = rand(1000, 9999)
	// FIXME what if this conflicts with an existing one?

	new /obj/item/wallframe/button(src)
	new /obj/item/electronics/airlock(src)
	var/obj/item/assembly/control/flasher/remote = new(src)
	remote.id = id
	var/obj/item/wallframe/flasher/frame = new(src)
	frame.id = id
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/screwdriver(src)


/obj/item/storage/box/teargas
	name = "box of tear gas grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness and skin irritation.</B>"
	icon_state = "secbox"
	illustration = "grenade"

/obj/item/storage/box/teargas/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/teargas(src)

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box with 5 emp grenades."
	illustration = "emp"

/obj/item/storage/box/emps/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/prisoner
	name = "box of prisoner IDs"
	desc = "Take away their last shred of dignity, their name."
	icon_state = "secbox"
	illustration = "id"

/obj/item/storage/box/prisoner/PopulateContents()
	..()
	new /obj/item/card/id/advanced/prisoner/one(src)
	new /obj/item/card/id/advanced/prisoner/two(src)
	new /obj/item/card/id/advanced/prisoner/three(src)
	new /obj/item/card/id/advanced/prisoner/four(src)
	new /obj/item/card/id/advanced/prisoner/five(src)
	new /obj/item/card/id/advanced/prisoner/six(src)
	new /obj/item/card/id/advanced/prisoner/seven(src)

/obj/item/storage/box/seccarts
	name = "box of PDA security cartridges"
	desc = "A box full of PDA cartridges used by Security."
	icon_state = "secbox"
	illustration = "pda"

/obj/item/storage/box/seccarts/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/disk/computer/security(src)

/obj/item/storage/box/firingpins
	name = "box of standard firing pins"
	desc = "A box full of standard firing pins, to allow newly-developed firearms to operate."
	icon_state = "secbox"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/firingpins/paywall
	name = "box of paywall firing pins"
	desc = "A box full of paywall firing pins, to allow newly-developed firearms to operate behind a custom-set paywall."

/obj/item/storage/box/firingpins/paywall/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin/paywall(src)

/obj/item/storage/box/firingpins/syndicate
	name = "box of syndicate firing pins"
	desc = "A box full of special syndicate firing pins which allow only syndicate operatives to use weapons with those firing pins."

/obj/item/storage/box/firingpins/syndicate/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin/implant/pindicate(src)

/obj/item/storage/box/lasertagpins
	name = "box of laser tag firing pins"
	desc = "A box full of laser tag firing pins, to allow newly-developed firearms to require wearing brightly coloured plastic armor before being able to be used."
	illustration = "firingpin"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "box of spare zipties"
	desc = "A box full of zipties."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/rubbershot
	name = "box of shotgun shells (Less Lethal - Rubber Shot)"
	desc = "A box full of rubber shot shotgun shells, designed for shotguns."
	icon_state = "rubbershot_box"
	illustration = null
	storage_type = /datum/storage/cartridge_box
/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/lethalshot
	name = "box of shotgun shells (Lethal)"
	desc = "A box full of lethal shotgun shells, designed for shotguns."
	icon_state = "lethalshot_box"
	illustration = null
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/lethalshot/old

/obj/item/storage/box/lethalshot/old/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/shotgun/buckshot/old(src)

/obj/item/storage/box/slugs
	name = "box of shotgun shells (Lethal - Slugs)"
	desc = "A box full of lethal shotgun slugs, designed for shotguns."
	icon_state = "breacher_box"
	illustration = null
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/slugs/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/storage/box/beanbag
	name = "box of shotgun shells (Less Lethal - Beanbag)"
	desc = "A box full of beanbag shotgun shells, designed for shotguns."
	icon_state = "beanbagshot_box"
	illustration = null
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/breacherslug
	name = "box of breaching shotgun shells"
	desc = "A box full of breaching slugs, designed for rapid entry, not very effective against anything else."
	icon_state = "breacher_box"
	illustration = null
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/breacherslug/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/shotgun/breacher(src)

/obj/item/storage/box/large_dart
	name = "box of XL shotgun darts"
	desc = "A box full of shotgun darts with increased chemical storage capacity."
	icon_state = "shotdart_box"
	illustration = null
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/large_dart/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_casing/shotgun/dart/large(src)

// arfs: .38 ammo boxes. old style so you gotta handle your cartridges one by one
/obj/item/storage/box/c38
	name = "box of .38 special ammunition"
	desc = "A box full of standard revolver cartridges."
	icon = 'modular_skyrat/modules/aesthetics/storage/storage.dmi'
	icon_state = "secbox_xl"
	illustration = "cartridge"
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/c38/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38(src)

/obj/item/storage/box/c38/trac
	name = "box of .38 special TRAC ammunition"
	desc = "A box full of revolver cartridges with imbedding trackers."
	illustration = "cartridge_trac"
/obj/item/storage/box/c38/trac/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38/trac(src)

/obj/item/storage/box/c38/match
	name = "box of .38 special match ammunition"
	desc = "A box full of high quality trickshot revolver cartridges."
	illustration = "cartridge_match"
/obj/item/storage/box/c38/match/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38/match(src)

/obj/item/storage/box/c38/rubber
	name = "box of .38 special rubber ammunition"
	desc = "A box full of nonlethal revolver cartridges."
	illustration = "cartridge_rubber"
/obj/item/storage/box/c38/rubber/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38/match/bouncy(src)

/obj/item/storage/box/c38/dumdum
	name = "box of .38 special DumDum ammunition"
	desc = "A box full of hollow-point revolver cartridges."
	illustration = "cartridge_dumdum"
/obj/item/storage/box/c38/dumdum/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38/dumdum(src)

/obj/item/storage/box/c38/hotshot
	name = "box of .38 special Hot Shot ammunition"
	desc = "A box full of incendiary revolver cartridges."
	illustration = "cartridge_hotshot"
/obj/item/storage/box/c38/hotshot/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38/hotshot(src)

/obj/item/storage/box/c38/iceblox
	name = "box of .38 special Iceblox ammunition"
	desc = "A box full of cryogenic revolver cartridges."
	illustration = "cartridge_iceblox"
/obj/item/storage/box/c38/iceblox/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/c38/iceblox(src)

/obj/item/storage/box/m762r
	name = "box of 7.62x54mmR ammunition"
	desc = "A box full of mosin nagant cartridges."
	icon = 'modular_skyrat/modules/aesthetics/storage/storage.dmi'
	icon_state = "secbox_xl"
	illustration = "cartridge"
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/m762r/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/m762r(src)

/obj/item/storage/box/m762r/surplus
/obj/item/storage/box/m762r/surplus/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/m762r/surplus(src)

/obj/item/storage/box/patrol
	name = "box of patrol rifle ammunition"
	desc = "A box full of patrol rifle cartridges."
	icon = 'modular_skyrat/modules/aesthetics/storage/storage.dmi'
	icon_state = "secbox_xl"
	illustration = "cartridge_patrol"
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/patrol/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/patrol(src)

// for the service version
/obj/item/storage/box/patrol/brown
	icon_state = "brownbox_xl"

/obj/item/storage/box/patrol_practice
	name = "box of patrol rifle practice ammunition"
	desc = "A box full of nonlethal patrol rifle practice cartridges."
	icon = 'modular_skyrat/modules/aesthetics/storage/storage.dmi'
	icon_state = "secbox_xl"
	illustration = "cartridge_patrol_d"
	storage_type = /datum/storage/cartridge_box

/obj/item/storage/box/patrol_practice/PopulateContents()
	for(var/i in 1 to 12)
		new /obj/item/ammo_casing/patrol/practice(src)

/obj/item/storage/box/patrol_practice/brown
	icon_state = "brownbox_xl"

/obj/item/storage/box/emptysandbags
	name = "box of empty sandbags"
	illustration = "sandbag"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/holy_grenades
	name = "box of holy hand grenades"
	desc = "Contains several grenades used to rapidly purge heresy."
	illustration = "grenade"

/obj/item/storage/box/holy_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy(src)

/obj/item/storage/box/fireworks
	name = "box of fireworks"
	desc = "Contains an assortment of fireworks."
	illustration = "sparkler"

/obj/item/storage/box/fireworks/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	new /obj/item/toy/snappop(src)

/obj/item/storage/box/fireworks/dangerous
	desc = "This box has a small label on it stating that it's from the Gorlex Marauders. Contains an assortment of \"fireworks\"."

/obj/item/storage/box/fireworks/dangerous/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	if(prob(20))
		new /obj/item/grenade/frag(src)
	else
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/firecrackers
	name = "box of firecrackers"
	desc = "A box filled with illegal firecrackers. You wonder who still makes these."
	icon_state = "syndiebox"
	illustration = "firecracker"

/obj/item/storage/box/firecrackers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/firecracker(src)

/obj/item/storage/box/sparklers
	name = "box of sparklers"
	desc = "A box of Nanotrasen brand sparklers, burns hot even in the cold of space-winter."
	illustration = "sparkler"

/obj/item/storage/box/sparklers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/sparkler(src)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."

/obj/item/storage/box/evidence/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/evidencebag(src)
