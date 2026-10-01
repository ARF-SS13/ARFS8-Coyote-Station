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
	var/list/departmental_scoreboards = list()
	var/round_score = 0
	var/round_bank = 0
	var/bank_bonus = 0
	var/minimum_score_to_count_as_anything = 20
	/// debug stuff
	var/debug_scoring = FALSE

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
	for(var/dep_kind in SSeconomy.department_accounts)
		departmental_scoreboards[dep_kind] = new /datum/rpi_departmental_scoreboard(dep_kind, SSeconomy.department_accounts[dep_kind])

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

/datum/controller/subsystem/rpi/proc/DepartmentPaidout(score)
	round_score += score
	round_bank += score

/datum/controller/subsystem/rpi/proc/GetRoundBank()
	return round_bank

/datum/controller/subsystem/rpi/proc/GetRoundScore()
	return round_score

/datum/controller/subsystem/rpi/proc/TrySpendBank(amount)
	if(round_bank >= amount)
		round_bank -= amount
		return TRUE
	return FALSE

/datum/controller/subsystem/rpi/proc/GetMatMarketScalar()
	if(round_score + round_bank <= 0)
		return 1
	var/roundphase = get_round_phase()
	var/totalscore = (round_score + round_bank) * (1 + roundphase/3)
	var/logbase = 3
	totalscore = log(logbase, totalscore)
	totalscore += round(roundphase/3)
	totalscore = round(totalscore, 0.5)
	totalscore = max(totalscore, 1)
	return totalscore

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

//todo: all this stuff

// /proc/cmp_chat_act_dsc(datum/rpi_chat_action/a, datum/rpi_chat_action/b)
// 	return a.score < b.score

/datum/controller/subsystem/rpi/proc/RpiReportCommon()
// 	var/list/parts = list()
// 	// top 5 characters by score
// 	var/list/top_char_roundscores = list()
// 	var/list/best_char_actions = list()
// 	var/list/char_stats = list()
// 	var/list/department_rankings = list()
// 	var/list/department_best_earners = list()
// 	var/list/department_most_efficient_earners = list()
// 	for(var/dept in SSrpi.departmental_scoreboards)
// 		var/datum/rpi_departmental_scoreboard/dscore = SSrpi.departmental_scoreboards[dept]
// 		if(dscore.totalscore < minimum_score_to_count_as_anything)
// 			continue
// 		department_rankings[dscore.paykind] = dscore.totalscore
// 		department_best_earners[dscore.paykind] = dscore.get_best_earners()
// 		department_best_earners.len = max(3, department_best_earners.len)
// 		department_most_efficient_earners[dscore.paykind] = dscore.get_most_efficients()
// 		department_most_efficient_earners.len = max(3, department_most_efficient_earners.len)
// 	department_rankings = sort_list(department_rankings, /proc/cmp_numeric_dsc, TRUE)
// 	department_rankings.len = max(3, department_rankings.len)
// 	// character RPI stuff
// 	var/list/allscores = list()
// 	var/list/best_acts = list()
// 	for(var/charkey in SSrpi.accounts)
// 		var/datum/rpi_account/acc = SSrpi.accounts[charkey]
// 		if(!acc)
// 			continue
// 		for(var/slot in acc.holders)
// 			var/datum/rpi_holder/holder = acc.holders[slot]
// 			if(!holder)
// 				continue
// 			var/charname = holder.get_name()
// 			allscores[charname] = holder.get_score()
// 			best_acts[charname] = holder.get_best_act()
// 			char_stats[charname] = holder.get_statistics()
// 	top_char_roundscores = sort_list(allscores, /proc/cmp_numeric_dsc, TRUE)
// 	top_char_roundscores.len = max(3, top_char_roundscores.len)
// 	best_char_actions = sort_list(best_acts, /proc/cmp_chat_act_dsc, TRUE)
// 	best_char_actions.len = max(3, best_char_actions.len)
// 	// ok that should be enough
// 	parts += "<div class='panel stationborder'><span class='header'>Community Social Economic Report:</span><br>"
// 	parts += "<span class='service'>Departmental Leaderboard:</span><br>"
// 	for(var/dept in department_rankings)
// 		var/datum/rpi_departmental_scoreboard/dscore = SSrpi.departmental_scoreboards[dept]
// 		var/departmentname = SSeconomy.department_accounts[dept]
// 		if(!departmentname)
// 			departmentname = dept
// 		parts += "<center><b><u>[departmentname]</u></b></center>"
// 		parts += "[dept]: [department_rankings[dept]] [MONEY_NAME]<br>"
// 		parts += "Best earners:<br>"
// 		parts += "<ol>"
// 		if(!LAZYLEN(department_best_earners[dept]))
// 			parts += "<li><b>[dscore.get_random_name()]</b>: Spirit!</li>"
// 		else
// 			for(var/name in department_best_earners[dept])
// 				parts += "<li><b>[name]</b>: [department_best_earners[dept][name]] [MONEY_NAME]</li>"
// 		parts += "</ol>"
// 		parts += "Most efficient:<br>"
// 		parts += "<ol>"
// 		if(!LAZYLEN(department_most_efficient_earners[dept]))
// 			parts += "<li><b>[dscore.get_random_name()]</b>: Spirit!</li>"
// 		else
// 			for(var/name in department_most_efficient_earners[dept])
// 				parts += "<li><b>[name]</b>: [department_most_efficient_earners[dept][name]] [MONEY_NAME]</li>"
// 		parts += "</ol>"
// 		parts += "<br>"
// 		parts += "<hr>"
// 	// and now the indifivsduals
// 	parts += "<span class='service'>Crew Leaderboard:</span><br>"
// 		parts += "<ol>"
// 	if(!LAZYLEN(allscores))
// 		parts += "<li>Nobody did a damn thing!</li>"
// 	else
// 		for(var/name in allscores)
// 			if(!allscores[name])
// 				continue
// 			parts += "<li><b>[name]</b>: [allscores[name]] [MONEY_NAME]</li>"
// 	parts += "</ol>"
// 	// and the best thing
// 	parts += "<span class='service'>And the best thing:</span><br>"
// 	if(!LAZYLEN(best_char_actions))
// 		parts += "<b>Dan Kelly</b> whined like a bottom and ate cheese in her dorm.</b>"
// 	else
// 		var/bestname = best_char_actions[1]
// 		var/datum/rpi_chat_action/bestact = best_acts[bestname]
// 		parts += "<b>[bestname]</b>: [bestact.get_text()]</b>"




