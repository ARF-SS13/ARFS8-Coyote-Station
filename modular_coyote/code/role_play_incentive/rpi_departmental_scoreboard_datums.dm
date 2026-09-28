/datum/rpi_departmental_scoreboard
	var/key
	var/name
	var/datum/bank_account/account
	var/list/paystubs = list()
	var/totalscore = 0
	var/totalactions = 0
	var/paykind = "Chatbux $$$"
	var/static/list/depkey_to_paykind = list(
		ACCOUNT_CIV   = "Community Activity Incentive",
		ACCOUNT_ENG   = "Community Building Incentive",
		ACCOUNT_SCI   = "Community Enlightenment Incentive",
		ACCOUNT_MED   = "Community Health Incentive",
		ACCOUNT_SRV   = "Community Service Incentive",
		ACCOUNT_CAR   = "Community Sales Incentive",
		ACCOUNT_CMD   = "Community Leadership Incentive",
		ACCOUNT_INT   = "Interdyne Public Relations Bonus",
		ACCOUNT_TAR   = "Tarkon Morale Incentive",
		ACCOUNT_AAD   = "All-American Diner Tipjar",
		ACCOUNT_LZGAS = "Lizard Gas Tax Credits",
		ACCOUNT_SEC   = "Community Safety Incentive",
	)

/datum/rpi_departmental_scoreboard/New(key, name)
	src.key = key
	src.name = name
	var/coolpay = depkey_to_paykind[key]
	paykind = coolpay || "Chatbux $$$"
	// dunno when the accounts will be created, so we'll attach to it when someone
	// in that department RPIs

/datum/rpi_departmental_scoreboard/proc/payout_department(mob/living/doer, score)
	if(!doer || !doer.ckey)
		return
	if(score < SSrpi.minimum_score_to_count_as_anything)
		return
	if(!account)
		bind_to_department_account()
		if(!account)
			CRASH("COULDNRT BIND TO ACCOUNT [key] [name] AAAAAAAAAAAAAA ERROR CODE: TUBBY-EXPIE")
	var/raison = "[paykind]: [doer.real_name]"
	account.adjust_money(score, raison)
	SSrpi.DepartmentPaidout(score)
	totalscore += score
	totalactions += 1

/datum/rpi_departmental_scoreboard/proc/bind_to_department_account()
	if(account)
		return
	account = SSeconomy.get_dep_account(key)

/datum/rpi_departmental_scoreboard/proc/add_paystub(mob/living/doer, score)
	if(!doer || !doer.ckey)
		return
	if(score < SSrpi.minimum_score_to_count_as_anything)
		return
	var/dokey = "[extract_ckey(doer)]"
	if(!paystubs[dokey])
		paystubs[dokey] = list()
	paystubs[dokey] += list(score)


/datum/rpi_departmental_scoreboard/proc/get_best_earners(avg_pls)
	var/list/ppl = list()
	for(var/name in paystubs)
		var/list/bitsy = paystubs[name]
		var/list/broke = splittext(name, "&&")
		var/mob/living/doer = extract_mob(broke[1])
		var/truename = doer.real_name
		if(!LAZYLEN(bitsy))
			continue
		if(!ppl[truename])
			ppl[truename] = 0
		for(var/scr in bitsy)
			ppl[truename] += scr
		if(avg_pls)
			ppl[truename] /= length(bitsy)
	ppl = sort_list(ppl, /proc/cmp_numeric_dsc, TRUE)
	return ppl

/datum/rpi_departmental_scoreboard/proc/get_most_efficients()
	return sort_list(paystubs, /proc/cmp_numeric_dsc, TRUE)








