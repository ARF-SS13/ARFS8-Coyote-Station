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

SUBSYSTEM_DEF(rpi)
	name = "RPI"
	wait = 10 SECONDS

	/// "ckey" = /datum/rpi_account
	var/list/accounts = list()
	/// "ckey_[slot]" = /datum/rpi_holder
	var/list/holders = list()
	/// kind = /datum/rpi_action
	var/list/actions = list()
	/// for chat actions
	/// saymode = /datum/rpi_chat_rubric
	var/list/say_rubrics = list()
	var/payout_payward_interval = 20 MINUTES
	var/last_tick = 0

/datum/controller/subsystem/rpi/Initialize()
	. = ..()

/datum/controller/subsystem/rpi/fire(resumed)
	for(var/key in holders)
		var/datum/rpi_holder/holder = holders[key]
		if(!holder)
			stack_trace("OH, no holder for [key]! this is an RPI thing, ERROR CODE: THIS-BRA-FIT-YESTERDAY")
			holders -= key
			continue
		holder.tick(world.time - last_tick)
	last_tick = world.time





// ╔═══════════════════════╗
// ║ ACCOUNT               ║
// ║ CKEY-WIDE DATA STUFF  ║
// ╚═══════════════════════╝
/datum/rpi_account
	var/ckey = ""

// ╔══════════════════════════════╗
// ║ HOLDER                       ║
// ║ ACTUAL CHARACTER RPI HANDLER ║
// ╚══════════════════════════════╝
/datum/rpi_holder
	var/owner_ckey = ""
	// this round stuff
	var/list/chat_actions = list()
	var/list/past_chat_judgements = list()
	var/round_score = 0
	var/round_highest_score = 0
	// saved stuff
	var/alltime_score = 0
	var/alltime_highest_score = 0
	// timing stuff
	var/payward_interval = 0
	var/timeleft = 0

/datum/rpi_holder/New(owner_ckey)
	src.owner_ckey = owner_ckey
	payward_interval = SSrpi.payout_payward_interval
	timeleft = payward_interval

/datum/rpi_holder/proc/tick(deltatime)
	if(deltatime <= 0)
		return
	var/mob/living/me = extract_mob(owner_ckey)
	if(!me || !me.client)
		return // gotta be online, dork
	timeleft -= deltatime
	check_passives()
	if(timeleft > 0)
		return
	if(!payout(TRUE))
		return
	timeleft += payward_interval

/datum/rpi_holder/proc/record_action(kind, list/data)
	switch(kind)
		if("rpi_chat")
			judge_chat(data)

/datum/rpi_holder/proc/judge_chat(list/data)
	if(!LAZYLEN(data))
		return
	var/datum/rpi_chat_rubric/rubric = SSrpi.GetSaymodeRubric(data[SATA_SAYMODE])
	if(!rubric)
		return
	var/mob/living/me = extract_mob(owner_ckey)
	if(!me)
		return
	var/saymode = data[SATA_RPI_SAYMODE]
	if(!saymode || SSrpi.banned_saymodes[saymode])
		return
	var/turf/myturf = get_turf(me)
	var/chatlength = LAZYLEN(data[SATA_RPI_TEXT])
	var/list/listening = list() | data[SATA_RPI_LISTENERS] // copy!
	var/mult = rubric.check_length ? chatlength / rubric.base_length : 1
	if(rubric.count_listeners)
		var/herd = 0
		for(var/mob/living/L in listening)
			if(!L.ckey)
				continue
			if(!L.client)
				continue
			if(L.stat == DEAD)
				continue
			var/turf/themturf = get_turf(L)
			var/distmult = 1
			var/dist = get_dist_euclidean(themturf.loc)
			if(dist <= rubric.optimal_distance)
				distmult = 1
			else if(dist > rubric.max_distance)
				continue
			else
				distmult = 1 - (dist - rubric.optimal_distance) / (rubric.max_distance - rubric.optimal_distance)
			// add to score
			mult += max(rubric.mult_per_listener * distmult, 1)
			herd += 1
			if(herd >= rubric.max_can_hear)
				break
	var/score = mult * rubric.pay_per_point
	var/datum/rpi_chat_action/prevact = chat_actions[saymode]
	// is ours better?
	if(!prevact || score > prevact.score)
		chat_actions[saymode] = new datum/rpi_chat_action(score, mult, data[SATA_RPI_TEXT], saymode)

/datum/rpi_holder/proc/payout(expend)
	var/mob/living/me = extract_mob(owner_ckey)
	if(!me)
		return
	var/datum/rpi_paystub/stub = new datum/rpi_paystub()
	var/chatpay = calc_chat_pay(expend)




/datum/rpi_holder/proc/calc_chat_pay(expend)
	var/pay = 0
	for(var/smod in chat_actions)
		var/datum/rpi_chat_action/act = smod
		if(!act)
			chat_actions -= smod
			continue
		if(act.used)
			continue
		pay += act.score
		if(expend)
			act.used = world.time
	return pay


/datum/rpi_holder/proc/check_passives()
	//? todo: auras, etc

/datum/rpi_paystub
	var/pay = 0
	var/text = ""


/datum/rpi_chat_rubric
	var/saymode = ""
	var/base_length = 75
	var/pay_per_point = 10
	var/mult_per_listener = 1.1
	var/optimal_distance = 4 // tiles, euclidean
	var/max_distance = 10 // tiles, also euclidean
	var/max_can_hear = 5
	var/count_listeners = TRUE
	var/check_length = TRUE

// ╔═══════════════════╗
// ║ JUDGEMENT         ║
// ║ A PAST RPI PAYOUT ║
// ╚═══════════════════╝
/datum/rpi_judgement
	var/date_done = 0
	var/roundtime_done = 0
	var/round_done = 0
	var/score = 0
	var/what = ""

/datum/rpi_judgement/New(score, what)
	src.score = score
	src.what = what
	date_done = time2text(world.realtime, " YYYY MM DD hh:mm", TIMEZONE_PST)
	roundtime_done = DisplayTimeText(world.time)
	round_done = GLOB.round_id

// ╔═════════════════════╗
// ║ CHAT ACTION         ║
// ║ A chat someone did! ║
// ╚═════════════════════╝
/datum/rpi_chat_action
	var/saymode = ""
	var/score = 0
	var/mult = 1
	var/text = ""
	var/used = 0

/datum/rpi_chat_action/New(score, mult, text, saymode)
	src.score = score
	src.mult = mult
	src.text = text
	src.saymode = saymode




