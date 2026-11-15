
SUBSYSTEM_DEF(barks)
	name = "Barks"
	flags = SS_NO_FIRE
	// cats -> things tracked
	var/list/bark_packs = list()

/datum/controller/subsystem/barks/Initialize()
	for(var/datum/bark_pack/pack as anything in typesof(/datum/bark_pack))
		bark_packs[pack::type] = new pack()

/datum/controller/subsystem/barks/proc/get_barks(datum/bark_pack/pak) as /list
	if(istype(pak))
		pak = pak.type
	if(!ispath(pak))
		return list()
	var/datum/bark_pack/outpack = bark_packs[pak]
	if(!istype(outpack))
		return list()
	var/list/retbundle = outpack.get_loadable_list()
	return retbundle

/datum/bark_pack
	var/list/barks = list()
	var/list/cached

/datum/bark_pack/New()
	. = ..()
	var/list/inited = list()
	for(var/datum/bark as anything in barks)
		inited += new bark()
	barks = inited.Copy()

/datum/bark_pack/proc/get_loadable_list()
	if(LAZYLEN(cached))
		return cached.Copy()
	cached = list()
	for(var/datum/bark/yap in barks)
		cached[yap.message] = yap.soundpath
	return cached.Copy()

/datum/bark
	var/message
	var/soundpath




