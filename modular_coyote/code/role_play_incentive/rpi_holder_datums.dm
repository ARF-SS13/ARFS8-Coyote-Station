// ╔══════════════════════════════╗
// ║ HOLDER                       ║
// ║ ACTUAL CHARACTER RPI HANDLER ║
// ╚══════════════════════════════╝
/datum/rpi_holder
	var/owner_ckey = ""
	var/owner_slot = 0
	var/datum/rpi_account/parent_account
	// modified stuff
	var/list/chat_actions = list()
	var/list/chat_action_history = list()
	var/list/past_chat_judgements = list()
	// scoreboardable owls
	var/datum/rpi_scoreboard/scoreboard
	// timing stuff for this holder
	var/time_created = 0
	var/time_modified = 0
	var/list/characters_tracked = list()
	// timing stuff
	var/payward_interval = 0
	var/timeleft = 0
	// savestuf for this holder
	var/durty = FALSE
	var/virgin = TRUE // you durty virgin~

/datum/rpi_holder/New(cool_ckey, cool_slot, datum/rpi_account/parent)
	owner_ckey = cool_ckey
	var/goodslot = cool_slot
	if(isnum(goodslot))
		owner_slot = goodslot
	else
		goodslot = replacetext(cool_slot, "slot_", "")
		owner_slot = text2num(goodslot)
	payward_interval = SSrpi.payout_payward_interval
	timeleft = payward_interval
	scoreboard = new /datum/rpi_scoreboard(owner_ckey, owner_slot, src)
	if(!load())
		time_created = time2text(world.realtime)
		time_modified = time_created
		durty = TRUE

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
		timeleft += payward_interval * 0.25
		return
	timeleft += payward_interval
	update_characters()
	durty = TRUE
	return TRUE

/datum/rpi_holder/proc/update_characters()
	var/mob/living/me = extract_mob(owner_ckey)
	if(!me)
		return
	characters_tracked |= me.real_name || me.name
	return TRUE

/datum/rpi_holder/proc/judge_chat(list/data, just_checking)
	if(!LAZYLEN(data))
		return
	var/mob/living/me = extract_mob(owner_ckey)
	if(!me)
		return
	var/saymode = data[SATA_SAYMODE]
	if(data[SATA_IS_RADIO])
		saymode = SAYMODE_RADIO
	if(!saymode || SSrpi.banned_saymodes[saymode])
		return

	var/datum/rpi_chat_rubric/rubric = SSrpi.GetSaymodeRubric(saymode)
	if(!rubric)
		return

	var/turf/myturf = get_turf(me)
	var/chatmsg = data[SATA_MESSAGE_SPOKEN]
	var/chatlength = LAZYLEN(chatmsg)
	var/list/listening = list() | data[SATA_RPI_LISTENERS] // copy!
	var/mult = max(rubric.check_length ? chatlength / rubric.base_length : 1, 0.5)
	var/herd = 0
	if(rubric.count_listeners)
		for(var/mob/living/L in listening)
			if(!L.ckey)
				continue
			if(!L.client)
				continue
			if(L.stat == DEAD)
				continue
			var/turf/themturf = get_turf(L)
			var/distmult = 1
			var/dist = get_dist_euclidean(themturf, myturf)
			if(dist <= rubric.optimal_distance)
				distmult = 1
			else if(dist > rubric.max_distance)
				continue
			else
				distmult = 1 - ((dist - rubric.optimal_distance) / max(rubric.max_distance - rubric.optimal_distance, 0.01))
			// add to score
			mult += max(rubric.mult_per_listener * distmult, 1)
			herd += 1
			if(herd >= rubric.max_can_hear)
				break
	var/score = mult * rubric.pay_per_point
	var/datum/rpi_chat_action/prevact = chat_actions[saymode]
	var/datum/rpi_chat_action/newact
	// is ours better?
	if(!prevact || score > prevact.score || just_checking)
		newact = new /datum/rpi_chat_action(score, mult, chatmsg, saymode, herd)
	if(newact)
		if(!just_checking)
			chat_actions[saymode] = newact
	debug_chat_act(me, saymode, chatmsg, chatlength, score, mult, herd)
	return newact

/datum/rpi_holder/proc/debug_chat_act(mob/living/me, saymode, chatmsg, chatlength, score, mult, herd)
	if(!SSrpi.debug_scoring)
		return
	var/list/log = list()
	log += "DEBUG CHAT ACT - [me.name] - [owner_ckey] - [owner_slot]"
	log += "Saymode: [saymode] SCORE: [score] MULT: [mult] HERD: [herd]"
	log += "MSG: [chatmsg]"
	to_chat(world, log.Join("\n"))

/datum/rpi_holder/proc/payout(expend)
	var/mob/living/me = extract_mob(owner_ckey)
	if(!me)
		return
	// ok actually pay them
	// gotta find the right ID card
	var/list/cards = me.get_all_contents_type(/obj/item/card/id)
	// the *right* card
	var/me_uid = me.m_uid
	var/datum/bank_account/account
	for(var/obj/item/card/id/idcard as anything in cards)
		if(idcard.registered_account)
			var/datum/bank_account/ba = idcard.registered_account
			if(ba.original_owner_uid == me_uid)
				account = ba
				break
			if(ba.account_holder)
				// do a fuzzy match with the mob's name
				var/myname = me.real_name || me.name
				for(var/i in 1 to LAZYLEN(myname) step 2)
					var/srch = copytext(myname, i, i+3)
					if(findtext(ba.account_holder, srch))
						account = ba
						break // close enough
		// for(var/cardid in SSeconomy.bank_accounts_by_id)
		// 	var/datum/bank_account/ba = SSeconomy.bank_accounts_by_id[cardid]
		// 	if(ba.original_owner_uid == me_uid)
		// 		account = ba
		// 		break
	if(!account)
		debug_payward(account, 0)
		return // just uh, ghold off i guess?
	time_modified = time2text(world.realtime)
	var/topay = 0
	var/chatpay = max(calc_chat_pay(expend), 5)
	topay += chatpay
	// other stuff later
	// judge how good the pay was

	topay = round(topay, 1)
	var/datum/rpi_clicker/clicker = SSrpi.GetClicker(topay)
	var/goodgirl = TRUE
	// if(prob(topay * 0.25))
	// 	goodgirl = TRUE
	if(clicker)
		clicker.deliver_headpats(me, topay, goodgirl)
	account.adjust_money(topay, "Incentive Payward")
	var/datum/rpi_judgement/judgement = new /datum/rpi_judgement(owner_ckey, owner_slot, topay, "Payward")
	past_chat_judgements |= judgement
	update_scores_payward(judgement)
	durty = TRUE
	debug_payward(account, topay)
	return TRUE

/datum/rpi_holder/proc/debug_payward(datum/bank_account/account, topay)
	if(!SSrpi.debug_scoring)
		return
	if(!account)
		to_chat(world, "No account found for payward: [owner_ckey] [owner_slot]")
		return
	var/mob/living/me = extract_mob(owner_ckey)
	var/list/log = list()
	log += "Payward Processed for [owner_ckey] [owner_slot] TOPAY: [topay]"
	log += "Reciever: [me.name] ([me.m_uid])"
	log += "Account: [account.account_holder] ([account.original_owner_uid])"
	to_chat(world, log.Join("\n"))

/datum/rpi_holder/proc/calc_chat_pay(expend)
	var/pay = 0
	for(var/smod in chat_actions)
		var/datum/rpi_chat_action/act = chat_actions[smod]
		if(!act)
			chat_actions -= smod
			continue
		if(act.used)
			continue
		pay += act.score
		if(expend)
			act.used = world.time
	if(expend)
		chat_action_history = chat_actions.Copy()
		chat_actions = list()
	return pay

/datum/rpi_holder/proc/check_passives()
	//? todo: auras, etc

/datum/rpi_holder/proc/update_scores_payward(datum/rpi_judgement/nujudge)
	if(!nujudge)
		return
	if(!scoreboard)
		return
	scoreboard.update_payward(nujudge)

/datum/rpi_holder/proc/serialize()
	var/list/h_dat = list()
	h_dat["owner_ckey"] = owner_ckey
	h_dat["owner_slot"] = owner_slot
	// h_dat["round_score"] = round_score
	// h_dat["round_highest_score"] = round_highest_score
	// h_dat["alltime_score"] = alltime_score
	// h_dat["alltime_highest_score"] = alltime_highest_score
	// h_dat["past_chat_judgements"] = past_chat_judgements
	return h_dat

/datum/rpi_holder/proc/deserialize(h_dat)
	owner_ckey = h_dat["owner_ckey"]
	owner_slot = h_dat["owner_slot"]
	// round_score = h_dat["round_score"]
	// round_highest_score = h_dat["round_highest_score"]
	// alltime_score = h_dat["alltime_score"]
	// alltime_highest_score = h_dat["alltime_highest_score"]
	return TRUE

/datum/rpi_holder/proc/save()
	if(!durty)
		return
	if(!owner_ckey || !owner_slot)
		return
	var/list/h_dat = serialize()
	var/jsonifax = json_encode(h_dat, JSON_PRETTY_PRINT)
	var/path = SSrpi.GetPath("holder_save", owner_ckey, owner_slot)
	rustg_file_write(jsonifax, path)
	// now the judgements...
	// for(var/datum/rpi_judgement/j in past_chat_judgements)
	// 	j.save()
	// ...and the scoreboard
	if(scoreboard)
		scoreboard.save()
	durty = FALSE
	return TRUE

/datum/rpi_holder/proc/load()
	if(!owner_ckey || !owner_slot)
		return
	if(!virgin)
		return
	var/path = SSrpi.GetPath("holder_save", owner_ckey, owner_slot)
	var/jsonifax = rustg_file_read(path)
	if(!jsonifax)
		return
	var/h_dat = json_decode(jsonifax)
	deserialize(h_dat)
	// then judgements
	// var/judge_path = SSrpi.GetPath("judgements", owner_ckey, owner_slot)
	// var/list/jfiles = flist(judge_path)
	// for(var/judge_filename in jfiles)
	// 	var/j_truepath = "[judge_path][judge_filename]"
	// 	var/datum/rpi_judgement/load_j = new /datum/rpi_judgement(load_from = j_truepath)
	// 	past_chat_judgements += load_j
	// and the scoreboard... is already loaded, neat!
	durty = FALSE
	virgin = FALSE
	return TRUE
