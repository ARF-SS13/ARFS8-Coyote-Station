/datum/species
	//The species id is the living and standing icon state of the creature.
	var/rotate_on_lying = FALSE
	/// The width of the simple_icon file. Used to auto-center your sprite.
	var/icon_width = 32
	/// The icon file to use if your species has a non-humanoid body. (TRAIT_FERAL)
	var/simple_icon
	/// The icon state to use if your species has a non-humanoid body. (TRAIT_FERAL)
	var/simple_icon_state = ""
	/// This is appended to the end of the "id" variable in order to set the DEAD icon state of species that use the simple_icon
	var/icon_dead_suffix
	/// This is appended to the end of the "id" variable in order to set the RESTING/PRONE icon state of species that use the simple_icon
	var/icon_rest_suffix
	/// simple_icon species will default to using the "id" variable for their icon state, but you can select one of these prefixes which will change your icon state to [alt_prefix][id]
	var/list/alt_prefixes
	/// If set to true, will force it into the roundstart races list regardless of what the config says
	var/roundstart = FALSE
	/// If they're a slime, this is their face.
	var/slime_mood
	/// Set to a path, and this'll count as a category for all its children
	/// it'll show up in the list, but not actually make you be that species, like 'pokemon'
	var/datum/species/category
	/// same as category, but its a subspecies of a species, like a kind of pokemon
	var/datum/species/sub_category
	var/datum/species/sub_sub_category
	// ^^ if either of these are set, the species will show up in the prefs menu, BUT, and this is BUT
	// BUT, they wont actually set your character to that species! it'll instead set it to whatevers set
	// as default for the category or sub_category... or the first one in the list, or something
	var/datum/species/default_species

/datum/species/feral
	name = "REPORT THIS AS A BUG"
	inherent_biotypes = MOB_ORGANIC
	meat = /obj/item/food/meat/slab
	abstract_type = /datum/species/feral
	inherent_biotypes = MOB_ORGANIC|MOB_BEAST
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_FERAL,
		TRAIT_HARD_SOLES,
		TRAIT_NO_UNDERWEAR,
		TRAIT_NODISMEMBER,
		TRAIT_CAN_MOUNT_HUMANS,
		TRAIT_CAN_MOUNT_CYBORGS,
		)
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/feral,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/feral,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/feral,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/feral,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/feral,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/feral,
	)

/obj/item/bodypart/head/feral
	show_icon = FALSE
/obj/item/bodypart/chest/feral
	show_icon = FALSE
/obj/item/bodypart/arm/left/feral
	show_icon = FALSE
/obj/item/bodypart/arm/right/feral
	show_icon = FALSE
/obj/item/bodypart/leg/left/feral
	show_icon = FALSE
/obj/item/bodypart/leg/right/feral
	show_icon = FALSE

//Start Pokemon//
//Alphabetical Please//

/datum/species/feral/pokemon
	simple_icon = 'modular_coyote/icons/mob/pokemon64.dmi'
	roundstart = TRUE // this is a category, so it wont actually be selectable
	icon_dead_suffix = "_d"
	icon_rest_suffix = "_rest"
	icon_width = 64
	ordering = 20 // under the normal species, above the ones i dont like
	category = /datum/species/feral/pokemon // propagation!
	default_species = /datum/species/feral/pokemon/phox/braixen

/datum/species/feral/pokemon/aerodactyl
	name = "Aerodactyl" // Feral
	id = "Aerodactyl"
	simple_icon_state = "Aerodactyl"

// --- ABSOL FOLDER --- //
/datum/species/feral/pokemon/absol
	name = "Absol" // Feral
	id = "absolFolder"
	ordering = 142
	sub_category = /datum/species/feral/pokemon/absol

/datum/species/feral/pokemon/absol/normal
	name = "Absol" // Feral
	id = "absol"
	simple_icon_state = "absol"
	ordering = 359
	default_species = TRUE

/datum/species/feral/pokemon/absol/megaabsol
	name = "Mega Absol" // Feral
	id = "megaabsol"
	simple_icon_state = "megaabsol"
	ordering = 359
// --- ABSOL FOLDER END --- //

// --- PHOX FOLDER --- //
/datum/species/feral/pokemon/phox
	name = "Phox" // Feral
	id = "phoxFolder"
	ordering = 653
	sub_category = /datum/species/feral/pokemon/phox
	default_species = /datum/species/feral/pokemon/phox/braixen

/datum/species/feral/pokemon/phox/fennekin
	name = "Fennekin" // Feral
	id = "fennekin"
	simple_icon_state = "fennekin"
	ordering = 653

/datum/species/feral/pokemon/phox/braixen
	name = "Braixen" // Feral
	id = "braixen"
	simple_icon_state = "braixen"
	ordering = 654
// --- PHOX FOLDER END --- //

// --- EEVEELUTION FOLDER --- //
/datum/species/feral/pokemon/eeveelution
	name = "Eeveelution" // Feral
	id = "eeveelutionsFolder"
	sub_category = /datum/species/feral/pokemon/eeveelution
	default_species = /datum/species/feral/pokemon/eeveelution/eevee
	ordering = 132

/datum/species/feral/pokemon/eeveelution/eevee
	name = "Eevee" // Feral
	id = "eevee"
	simple_icon_state = "eevee"
	ordering = 133
	alt_prefixes = list("Old Color" = "old")

/datum/species/feral/pokemon/eeveelution/vaporeon
	name = "Vaporeon" // Feral
	id = "vaporeon"
	simple_icon_state = "vaporeon"
	ordering = 134

/datum/species/feral/pokemon/eeveelution/jolteon
	name = "Jolteon" // Feral
	id = "jolteon"
	simple_icon_state = "jolteon"
	ordering = 135

/datum/species/feral/pokemon/eeveelution/flareon
	name = "Flareon" // Feral
	id = "flareon"
	simple_icon_state = "flareon"
	ordering = 136
	alt_prefixes = list("Old Color" = "old")

/datum/species/feral/pokemon/eeveelution/espeon
	name = "Espeon" // Feral
	id = "espeon"
	simple_icon_state = "espeon"
	ordering = 196
	alt_prefixes = list("Old Color" = "old")

/datum/species/feral/pokemon/eeveelution/umbreon
	name = "Umbreon" // Feral
	id = "umbreon"
	simple_icon_state = "umbreon"
	ordering = 197
	alt_prefixes = list("Old Color" = "old")

/datum/species/feral/pokemon/eeveelution/leafeon
	name = "Leafeon" // Feral
	id = "leafeon"
	simple_icon_state = "leafeon"
	ordering = 470

/datum/species/feral/pokemon/eeveelution/glaceon
	name = "Glaceon" // Feral
	id = "glaceon"
	simple_icon_state = "glaceon"
	ordering = 471

/datum/species/feral/pokemon/eeveelution/sylveon
	name = "Sylveon" // Feral
	id = "sylveon"
	simple_icon_state = "sylveon"
	ordering = 700

/datum/species/feral/pokemon/vaporeon
	name = "Vaporeon" // Feral
	id = "vaporeon"
	simple_icon_state = "vaporeon"
	ordering = 134

// --- EEVEELUTION FOLDER END --- //

/datum/species/feral/pokemon/aggron
	name = "Aggron" // Feral
	id = "aggron"
	simple_icon_state = "aggron"
	ordering = 306

/datum/species/feral/pokemon/articuno
	name = "Articuno" // Feral
	id = "articuno"
	simple_icon_state = "articuno"
	ordering = 144
	simple_icon = 'modular_coyote/icons/mob/pokemon96.dmi'
	icon_width = 96

/datum/species/feral/pokemon/blastoise
	name = "Blastoise" // Feral
	id = "blastoise"
	simple_icon_state = "blastoise"
	ordering = 9

/datum/species/feral/pokemon/celebi
	name = "Celebi" // Feral
	id = "celebi"
	simple_icon_state = "celebi"
	ordering = 251

// --- CHARMANDER FOLDER --- //
/datum/species/feral/pokemon/charmander
	name = "Charmander" // Feral
	id = "charmanderFolder"
	sub_category = /datum/species/feral/pokemon/charmander
	ordering = 4
	default_species = /datum/species/feral/pokemon/charmander/charmander

/datum/species/feral/pokemon/charmander/charmander
	name = "Charmander" // Feral
	id = "charmander"
	simple_icon_state = "charmander"
	ordering = 4

/datum/species/feral/pokemon/charmander/charizard
	name = "Charizard" // Feral
	id = "charizard"
	simple_icon_state = "charizard"
	ordering = 6
// --- CHARMANDER FOLDER END --- //

/datum/species/feral/pokemon/cubone
	name = "Cubone" // Feral
	id = "cubone"
	simple_icon_state = "cubone"
	ordering = 104

/datum/species/feral/pokemon/ditto
	name = "Ditto" // Feral
	id = "ditto"
	simple_icon_state = "ditto"
	ordering = 132

// --- DRAGONAIR FOLDER --- //
/datum/species/feral/pokemon/dragonair
	name = "Dragonair" // Feral
	id = "dragonairFolder"
	sub_category = /datum/species/feral/pokemon/dragonair
	default_species = /datum/species/feral/pokemon/dragonair/dratini
	ordering = 147

/datum/species/feral/pokemon/dragonair/dratini
	name = "Dratini" // Feral
	id = "dratini"
	simple_icon_state = "dratini"
	ordering = 147

/datum/species/feral/pokemon/dragonair/dragonair
	name = "Dragonair" // Feral
	id = "dragonair"
	simple_icon_state = "dragonair"
	ordering = 148

/datum/species/feral/pokemon/dragonair/shinydragonair
	name = "Shiny Dragonair" // Feral
	id = "shinydragonair"
	simple_icon_state = "shinydragonair"
	ordering = 148

/datum/species/feral/pokemon/dragonair/dragonite
	name = "Dragonite" // Feral
	id = "dragonite"
	simple_icon_state = "dragonite"
	ordering = 149
// --- DRAGONAIR FOLDER END --- //

/datum/species/feral/pokemon/dunsparce
	name = "Dunsparce" // Feral
	id = "dunsparce"
	simple_icon_state = "dunsparce"
	ordering = 206

/datum/species/feral/pokemon/flygon
	name = "Flygon" // Feral
	id = "flygon"
	simple_icon_state = "flygon"
	ordering = 330

// --- FURRET FOLDER --- //
/datum/species/feral/pokemon/furret
	name = "Furret" // Feral
	id = "furretFolder"
	sub_category = /datum/species/feral/pokemon/furret
	default_species = /datum/species/feral/pokemon/furret/furret
	ordering = 162

/datum/species/feral/pokemon/furret/furret
	name = "Furret" // Feral
	id = "furret"
	simple_icon_state = "furret"
	ordering = 162

/datum/species/feral/pokemon/furret/shiny
	name = "Shiny Furret" // Feral
	id = "furret_shiny"
	simple_icon_state = "furret_shiny"
	ordering = 162
// --- FURRET FOLDER END --- //

// --- GALLADE FOLDER --- //
/datum/species/feral/pokemon/gardevoir
	name = "Gardevoir" // Feral
	id = "gardevoirFolder"
	sub_category = /datum/species/feral/pokemon/gardevoir
	default_species = /datum/species/feral/pokemon/gardevoir/gardevoir
	ordering = 282

/datum/species/feral/pokemon/gardevoir/gallade
	name = "Gallade" // Feral
	id = "gallade"
	simple_icon_state = "gallade"
	ordering = 475

/datum/species/feral/pokemon/gardevoir/gardevoir
	name = "Gardevoir" // Feral
	id = "gardevoir"
	simple_icon_state = "gardevoir"
	ordering = 282
// --- GALLADE FOLDER END --- //

// --- GHOST FOLDER --- //
/datum/species/feral/pokemon/ghost
	name = "Ghostly" // Feral
	id = "ghostFolder"
	sub_category = /datum/species/feral/pokemon/ghost
	default_species = /datum/species/feral/pokemon/ghost/gastly
	ordering = 92

/datum/species/feral/pokemon/ghost/gastly
	name = "Gastly" // Feral
	id = "gastly"
	simple_icon_state = "gastly"
	ordering = 92

/datum/species/feral/pokemon/ghost/haunter
	name = "Haunter" // Feral
	id = "haunter"
	simple_icon_state = "haunter"
	ordering = 93

/datum/species/feral/pokemon/ghost/gengar
	name = "Gengar" // Feral
	id = "gengar"
	simple_icon_state = "gengar"
	ordering = 94
// --- GHOST FOLDER END --- //

/datum/species/feral/pokemon/jirachi
	name = "Jirachi" // Feral
	id = "jirachi"
	simple_icon_state = "jirachi"
	ordering = 385


/datum/species/feral/pokemon/kabuto
	name = "Kabuto" // Feral
	id = "Kabuto"
	simple_icon_state = "Kabuto"
	ordering = 140
/*
/datum/species/feral/pokemon/kirlia
	name = "Kirlia" // Feral
	id = "kirlia"
	simple_icon_state = "kirlia"
*/
/datum/species/feral/pokemon/larvitar
	name = "Larvitar" // Feral
	id = "larvitar"
	simple_icon_state = "larvitar"
	ordering = 248

/datum/species/feral/pokemon/lapras
	name = "Lapras" // Feral
	id = "lapras"
	simple_icon_state = "lapras"
	ordering = 131

/datum/species/feral/pokemon/lickitung
	name = "Lickitung" // Feral
	id = "lickitung"
	simple_icon_state = "lickitung"
	ordering = 108

/datum/species/feral/pokemon/lugia
	name = "Lugia" // Feral
	id = "lugia"
	simple_icon_state = "lugia"
	ordering = 249
	simple_icon = 'modular_coyote/icons/mob/pokemon96.dmi'
	icon_width = 96

/datum/species/feral/pokemon/lycanroc
	name = "Lycanroc" // Feral
	id = "lycanroc"
	simple_icon_state = "lycanroc"
	ordering = 772

/datum/species/feral/pokemon/magicarp
	name = "Magicarp" // Feral
	id = "magicarp"
	simple_icon_state = "magicarp"
	ordering = 129

/datum/species/feral/pokemon/magmar
	name = "Magmar" // Feral
	id = "magmar"
	simple_icon_state = "magmar"
	ordering = 126

// --- MAREEP FOLDER --- //
/datum/species/feral/pokemon/mareep
	name = "Mareep" // Feral
	id = "mareepFolder"
	sub_category = /datum/species/feral/pokemon/mareep
	default_species = /datum/species/feral/pokemon/mareep/mareep
	ordering = 179

/datum/species/feral/pokemon/mareep/mareep
	name = "Mareep" // Feral
	id = "mareep"
	simple_icon_state = "mareep"
	ordering = 179

/datum/species/feral/pokemon/mareep/flaaffy
	name = "Flaaffy" // Feral
	id = "flaaffy"
	simple_icon_state = "flaaffy"
	ordering = 180

/datum/species/feral/pokemon/mareep/ampharos
	name = "Ampharos" // Feral
	id = "ampharos"
	simple_icon_state = "ampharos"
	ordering = 181
// --- MAREEP FOLDER END --- //

/datum/species/feral/pokemon/mew
	name = "Mew" // Feral
	id = "mew"
	simple_icon_state = "mew"
	ordering = 151

/datum/species/feral/pokemon/mewtwo
	name = "Mewtwo" // Feral
	id = "mewtwo"
	simple_icon_state = "mewtwo"
	ordering = 150

// --- POOCHYENA FOLDER --- //
/datum/species/feral/pokemon/poochyena
	name = "Poochyena" // Feral
	id = "poochyenaFolder"
	sub_category = /datum/species/feral/pokemon/poochyena
	default_species = /datum/species/feral/pokemon/poochyena/poochyena
	ordering = 261

/datum/species/feral/pokemon/poochyena/poochyena
	name = "Poochyena" // Feral
	id = "poochyena"
	simple_icon_state = "poochyena"
	ordering = 261

/datum/species/feral/pokemon/poochyena/mightyena
	name = "Mightyena" // Feral
	id = "mightyena"
	simple_icon_state = "mightyena"
	ordering = 262
// --- POOCHYENA FOLDER END --- //

/datum/species/feral/pokemon/miltank
	name = "Miltank" // Feral
	id = "miltank"
	simple_icon_state = "miltank"
	ordering = 241

// --- VULPIX FOLDER --- //
/datum/species/feral/pokemon/vulpix
	name = "Vulpix" // Feral
	id = "vulpixFolder"
	sub_category = /datum/species/feral/pokemon/vulpix
	default_species = /datum/species/feral/pokemon/vulpix/vulpix
	ordering = 37

/datum/species/feral/pokemon/vulpix/vulpix
	name = "Vulpix" // Feral
	id = "vulpix"
	simple_icon_state = "vulpix"
	ordering = 37

/datum/species/feral/pokemon/vulpix/alolanvulpix
	name = "Alolan Vulpix" // Feral
	id = "alolanvulpix"
	simple_icon_state = "alolanvulpix"
	ordering = 37

/datum/species/feral/pokemon/vulpix/ninetales
	name = "Ninetales" // Feral
	id = "ninetales"
	simple_icon_state = "ninetales"
	ordering = 38
// --- VULPIX FOLDER END --- //

/datum/species/feral/pokemon/omanyte
	name = "Omanyte" // Feral
	id = "omanyte"
	simple_icon_state = "omanyte"
	ordering = 138

// --- PIKACHU FOLDER --- //
/datum/species/feral/pokemon/pikachu
	name = "Pikachu" // Feral
	id = "pikachuFolder"
	sub_category = /datum/species/feral/pokemon/pikachu
	default_species = /datum/species/feral/pokemon/pikachu/pikachu
	ordering = 25

/datum/species/feral/pokemon/pikachu/pikachu
	name = "Pikachu" // Feral
	id = "pikachu"
	simple_icon_state = "pikachu"
	ordering = 25
	alt_prefixes = list("Female" = "f")
	simple_icon = 'modular_coyote/icons/mob/pmon/pikachu.dmi'

/datum/species/feral/pokemon/pikachu/raichu
	name = "Raichu" // Feral
	id = "raichu"
	simple_icon_state = "raichu"
	ordering = 26
	alt_prefixes = list("Female" = "f")
	simple_icon = 'modular_coyote/icons/mob/pmon/raichu.dmi'

/datum/species/feral/pokemon/pikachu/alolanraichu
	name = "Alolan Raichu" // Feral
	id = "alolanraichu"
	simple_icon_state = "alolanraichu"
	ordering = 27
	simple_icon = 'modular_coyote/icons/mob/pmon/raichu.dmi'
// --- PIKACHU FOLDER END --- //

/datum/species/feral/pokemon/ponyta
	name = "Ponyta" // Feral
	id = "ponyta"
	simple_icon_state = "ponyta"
	ordering = 77

// --- PURRLOIN FOLDER --- //
/datum/species/feral/pokemon/purrloin
	name = "Purrloin" // Feral
	id = "purrloinFolder"
	sub_category = /datum/species/feral/pokemon/purrloin
	default_species = /datum/species/feral/pokemon/purrloin/purrloin
	ordering = 509

/datum/species/feral/pokemon/purrloin/purrloin
	name = "Purrloin" // Feral
	id = "purrloin"
	simple_icon_state = "purrloin"
	ordering = 509

/datum/species/feral/pokemon/purrloin/liepard
	name = "Liepard" // Feral
	id = "liepard"
	simple_icon_state = "liepard"
	ordering = 510
// --- PURRLOIN FOLDER END --- //
/*
/datum/species/feral/pokemon/ralts
	name = "Ralts" // Feral
	id = "ralts"
	simple_icon_state = "ralts"
	footstep_type = FOOTSTEP_MOB_CRAWL
*/
// --- RATTATA FOLDER --- //
/datum/species/feral/pokemon/rattata
	name = "Rattata" // Feral
	id = "rattataFolder"
	sub_category = /datum/species/feral/pokemon/rattata
	default_species = /datum/species/feral/pokemon/rattata/rattata
	ordering = 19

/datum/species/feral/pokemon/rattata/rattata
	name = "Rattata" // Feral
	id = "rattata"
	simple_icon_state = "rattata"
	ordering = 19

/datum/species/feral/pokemon/rattata/raticate
	name = "Raticate" // Feral
	id = "raticate"
	simple_icon_state = "raticate"
	ordering = 20
// --- RATTATA FOLDER END --- //

/datum/species/feral/pokemon/rayquaza
	name = "Rayquaza" // Feral
	id = "rayquaza"
	simple_icon_state = "rayquaza"
	ordering = 384
	simple_icon = 'modular_coyote/icons/mob/pokemon96.dmi'
	icon_width = 96

/datum/species/feral/pokemon/salazzle
	name = "Salazzle" // Feral
	id = "salazzle"
	simple_icon_state = "salazzle"
	ordering = 758
	simple_icon = 'modular_coyote/icons/mob/pmon/salazzle.dmi'

/datum/species/feral/pokemon/skuntank
	name = "Skuntank" // Feral
	id = "skuntank"
	simple_icon_state = "skuntank"
	ordering = 435

/datum/species/feral/pokemon/snivy
	name = "Snivy" // Feral
	id = "snivy"
	simple_icon_state = "snivy"
	ordering = 495

/datum/species/feral/pokemon/snorlax
	name = "Snorlax" // Feral
	id = "snorlax"
	simple_icon_state = "snorlax"
	ordering = 143

/datum/species/feral/pokemon/sprigatito
	name = "Sprigatito" // Feral
	id = "sprigatito"
	simple_icon_state = "sprigatito"
	ordering = 909

/datum/species/feral/pokemon/tentacruel
	name = "Tentacruel" // Feral
	id = "tentacruel"
	simple_icon_state = "tentacruel"
	ordering = 73

/datum/species/feral/pokemon/thievul
	name = "Thievul" // Feral
	id = "thievul"
	simple_icon_state = "thievul"
	ordering = 828

/datum/species/feral/pokemon/zigzagoon
	name = "Zigzagoon" // Feral
	id = "zigzagoon"
	simple_icon_state = "zigzagoon"
	ordering = 263

// --- ZORUA FOLDER --- //
/datum/species/feral/pokemon/zorua
	name = "Zorua" // Feral
	id = "zoruaFolder"
	sub_category = /datum/species/feral/pokemon/zorua
	default_species = /datum/species/feral/pokemon/zorua/zorua
	ordering = 570

/datum/species/feral/pokemon/zorua/zorua
	name = "Zorua" // Feral
	id = "zorua"
	simple_icon_state = "zorua"
	ordering = 570

/datum/species/feral/pokemon/zorua/zorua_hisuian
	name = "Hisuian Zorua" // Feral
	id = "zorua_hisuian"
	simple_icon_state = "zorua_hisuian"
	ordering = 571

/datum/species/feral/pokemon/zorua/zoroark
	name = "Zoroark" // Feral
	id = "zoroark"
	simple_icon_state = "zoroark"
	ordering = 572
// --- ZORUA FOLDER END --- //

/datum/species/feral/pokemon/zubat
	name = "Zubat" // Feral
	id = "zubat"
	simple_icon_state = "zubat"
	ordering = 41
