// ╔═════════╤═════════════════════════════╗
// ║ File    │ rpi_subsystem.dm            ║
// ║ Date    │ 1888-12-25                  ║
// ║ Author  │ Daniel "CheckPlease" Kelly  ║
// ║ License │ CMYK-Pubic-Domain-1.0       ║
// ║ Quote   │ "Its a clicker for bottoms" ║
// ╟─────────┼─────────────────────────────╨──────────────────────────────────────────╖
// ║         │                                                                        ║
// ║  ####   │ Welcome to Role Play Incentive, a way to train bottoms to interact     ║
// ║  ####   │                                                                        ║
// ║  ####   │ How it works:                                                          ║
// ║  ####   │ - Player says somethin (or emotes, or something else we like)          ║
// ║  ####   │ - It calculates how many people heard it, how long it is, other stuff  ║
// ║  ####   │ - Judges the hell out of your message like an animal crossing villager ║
// ║  ####   │ - Youre paid for it later, and a sound if you did good!                ║
// ║  ####   │ - Do really good and you get a better sound                            ║
// ║  ####   │                                                                        ║
// ║  ####   │ Its like clicker-training your dog, but all the dogs are people        ║
// ║         │                                                                        ║
// ╟─────────┼────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ====================================================================  ║
// ╚═════════╧════════════════════════════════════════════════════════════════════════╝

// thots for the future:
// - leaderboard, both intra-round and inter-round
// - wallflower detection and rewarding for intedracting wirth wallflowers
// - combo system for consistently good rpi rewards

// savestructure:
// data/rpi/saves/ckey/account.json
// data/rpi/saves/ckey/holders/slot_1.json

SUBSYSTEM_DEF(rpi)
	name = "RPI"
	wait = 10 SECONDS

	/// "ckey" = /datum/rpi_account
	var/list/accounts = list()
	/// "ckey_[slot]" = /datum/rpi_holder
	var/list/clickers = list()
	/// for chat actions
	/// saymode = /datum/rpi_chat_rubric
	var/list/say_rubrics = list()
	var/list/banned_saymodes = list()
	var/payout_payward_interval = 20 MINUTES
	var/last_tick = 0
	/// debug stuff
	var/debug_scoring = TRUE

/datum/controller/subsystem/rpi/Initialize()
	InitDatumsAndSuch()
	. = ..()

/datum/controller/subsystem/rpi/fire(resumed)
	for(var/key in accounts)
		var/datum/rpi_account/acc = accounts[key]
		if(acc)
			acc.tick(world.time - last_tick)
			acc.save()
	last_tick = world.time

/datum/controller/subsystem/rpi/proc/InitDatumsAndSuch()
	// init stuff for rpi, like accounts and holders
	for(var/datum/rpi_chat_rubric/rub as anything in subtypesof(/datum/rpi_chat_rubric))
		say_rubrics[rub::saymode] = new rub()
	for(var/datum/rpi_clicker/cliq as anything in subtypesof(/datum/rpi_clicker))
		clickers += new cliq()

/datum/controller/subsystem/rpi/proc/SayAction(mob/living/doer, list/message_data)
	if(!istype(doer) || !doer.client || !LAZYLEN(message_data))
		return
	var/datum/rpi_account/acc = GetRPIAccount(doer)
	if(!acc)
		return
	acc.say_action(doer, message_data)
	return acc.durty

/datum/controller/subsystem/rpi/proc/GetSaymodeRubric(saymode)
	var/datum/rpi_chat_rubric/rub = say_rubrics[saymode]
	if(!rub)
		rub = say_rubrics["default"]
		if(!rub)
			CRASH("no default rubric!!!")
	return rub

/datum/controller/subsystem/rpi/proc/GetClicker(score)
	var/datum/rpi_clicker/lowest_click
	for(var/datum/rpi_clicker/cliq in clickers)
		if(!lowest_click || (cliq.min_pay > lowest_click.min_pay && score >= cliq.min_pay))
			lowest_click = cliq
	return lowest_click

/datum/controller/subsystem/rpi/proc/LoadAllRPI()
	var/path = GetPath("accounts")
	var/list/keys = flist(path)
	for(var/keyname in keys)
		Load(keyname)

/datum/controller/subsystem/rpi/proc/Load(ckey)
	return GetRPIAccount(ckey)

/datum/controller/subsystem/rpi/proc/SaveAllRPI()
	for(var/key in accounts)
		var/datum/rpi_account/acc = accounts[key]
		if(acc)
			acc.save()

/datum/controller/subsystem/rpi/proc/GetRPIAccount(something)
	var/ckey = extract_ckey(something)
	if(!ckey)
		CRASH("[something] PASSED TO GetRPIAccount WITHOUT A CKEY!!!")
	var/datum/rpi_account/acc = accounts[ckey]
	if(!acc)
		acc = new /datum/rpi_account(ckey)
		accounts[ckey] = acc
		if(!acc)
			CRASH("NO ACCOUNT FOR [ckey]!!! even after trying to load it!! ewhivh should make one!!!")
	return acc

/datum/controller/subsystem/rpi/proc/GetRPIHolder(ckey, slot)
	var/datum/rpi_account/acc = GetRPIAccount(ckey)
	if(!acc)
		return
	return acc.holders[slot]

/datum/controller/subsystem/rpi/proc/Slot2Text(slot)
	if(!istext(slot))
		slot = Text2Slot(slot)
	return "slot_[slot]"

/datum/controller/subsystem/rpi/proc/Text2Slot(slot)
	return text2num(replacetext(slot, "slot_", ""))

/datum/controller/subsystem/rpi/proc/GetPath(kind, ckey, slot = 1, judnum, filename)
	if(istext(slot))
		slot = text2num(replacetext(slot, "slot_", ""))
	switch(kind)
		if("accounts")
			return "data/rpi/saves/"
		if("account_save")
			return "data/rpi/saves/[ckey]/account.json"

		if("holders")
			return "data/rpi/saves/[ckey]/holders/"
		if("holder_save")
			return "data/rpi/saves/[ckey]/holders/slot_[slot].json"

		if("scoreboards")
			return "data/rpi/saves/[ckey]/scoreboards/"
		if("scoreboard_save")
			return "data/rpi/saves/[ckey]/scoreboards/slot_[slot].json"

		if("judgements")
			return "data/rpi/saves/[ckey]/judgements/slot_[slot]/"
		if("judgement_save")
			return "data/rpi/saves/[ckey]/judgements/slot_[slot]/j_[judnum].json"
	CRASH("unknown kind for GetPath: [kind]")



