/datum/rpi_scoreboard
	// this round stuff
	var/owner_ckey = ""
	var/owner_slot = 0
	var/datum/rpi_holder/parent_holder
	// round stuff
	var/round_score = 0
	var/round_highest_score = 0
	var/list/best_chat_actions_this_round = list()
	// saved stuff, for this character
	var/alltime_score = 0
	var/alltime_highest_score = 0
	var/list/best_chat_actions_alltime = list()
	// statistics! mainlty for wallflower detections
	var/list/stat_scores = list()
	var/list/stat_actions_performed = list()
	var/list/stat_post_length_per_saymode = list()
	var/list/stat_listeners = list()
	var/list/statistical_history = list()

	var/durty = FALSE
	var/virgin = TRUE

/datum/rpi_scoreboard/New(ownKey, ownSlot, holder)
	src.owner_ckey = ownKey
	src.owner_slot = ownSlot
	src.parent_holder = holder
	setup_chat_actions()
	load_saved()

/datum/rpi_scoreboard/proc/setup_chat_actions()
	best_chat_actions_this_round = list()
	best_chat_actions_alltime = list()
	for(var/smod in SSrpi.say_rubrics)
		best_chat_actions_this_round[smod] = list()
		best_chat_actions_alltime[smod] = list()

/datum/rpi_scoreboard/proc/update_payward(datum/rpi_judgement/judge)
	if(!judge)
		return
	var/score = judge.score
	round_score += score
	alltime_score += score
	if(score > round_highest_score)
		round_highest_score = score
	if(score > alltime_highest_score)
		alltime_highest_score = score
	// now for statistics!
	var/list/last_set = parent_holder.chat_action_history
	stat_scores += score
	for(var/saymode in last_set)
		var/datum/rpi_chat_action/stat_act = last_set[saymode]
		stat_actions_performed[stat_act.saymode] += 1
		if(!stat_post_length_per_saymode[stat_act.saymode])
			stat_post_length_per_saymode[stat_act.saymode] = list()
		stat_post_length_per_saymode[stat_act.saymode] += LAZYLEN(stat_act.text)
		if(!stat_listeners[stat_act.saymode])
			stat_listeners[stat_act.saymode] = list()
		stat_listeners[stat_act.saymode] += stat_act.listeners

	for(var/smode in last_set)
		var/datum/rpi_chat_action/act = last_set[smode]
		if(LAZYLEN(best_chat_actions_this_round[smode]) < 5)
			best_chat_actions_this_round[smode] += act
			continue
		var/datum/rpi_chat_action/lowest_im_better_than
		for(var/datum/rpi_chat_action/b_smode in best_chat_actions_this_round[smode])
			if(act.score <= b_smode.score)
				continue
			if(!lowest_im_better_than || b_smode.score < lowest_im_better_than.score)
				lowest_im_better_than = b_smode
		if(lowest_im_better_than)
			best_chat_actions_this_round[smode] -= lowest_im_better_than
			best_chat_actions_this_round[smode] += act
	// then the alltime bests, compare this round's list against the saved alltime list
	for(var/smode in best_chat_actions_this_round)
		for(var/datum/rpi_chat_action/round_act in best_chat_actions_this_round[smode])
			if(LAZYLEN(best_chat_actions_alltime[smode]) < 5)
				best_chat_actions_alltime[smode] += round_act
				continue
			var/datum/rpi_chat_action/lowest_im_better_than
			for(var/datum/rpi_chat_action/all_time_act in best_chat_actions_alltime[smode])
				if(round_act.score <= all_time_act.score)
					continue
				if(!lowest_im_better_than || all_time_act.score < lowest_im_better_than.score)
					lowest_im_better_than = all_time_act
			if(lowest_im_better_than)
				best_chat_actions_alltime[smode] -= lowest_im_better_than
				best_chat_actions_alltime[smode] += round_act
	//sort
	for(var/smode in best_chat_actions_this_round)
		var/list/best_round = best_chat_actions_this_round[smode]
		if(LAZYLEN(best_round))
			best_round = sort_list(best_chat_actions_this_round[smode], /proc/cmp_chat_act)
			best_round.len = min(best_round.len, 5)
			best_chat_actions_this_round[smode] = best_round

		var/list/best_all = best_chat_actions_alltime[smode]
		if(LAZYLEN(best_all))
			best_all = sort_list(best_all, /proc/cmp_chat_act)
			best_all.len = min(best_all.len, 5)
			best_chat_actions_alltime[smode] = best_all

/datum/rpi_scoreboard/proc/serialize()
	var/list/data = list()
	data["owner_ckey"] = owner_ckey
	data["owner_slot"] = owner_slot
	data["alltime_score"] = alltime_score
	data["alltime_highest_score"] = alltime_highest_score
	data["alltime_best_chat_actions"] = list()
	for(var/smode in best_chat_actions_alltime)
		data["alltime_best_chat_actions"][smode] = list()
		for(var/datum/rpi_chat_action/act in best_chat_actions_alltime[smode])
			data["alltime_best_chat_actions"][smode] += act.serialize()
	// add statistical history!
	var/list/stats = list()
	stats["actions"] = stat_actions_performed
	stats["length"] = stat_post_length_per_saymode
	stats["heard"] = stat_listeners
	data["stat_history"] = list()
	data["stat_history"]["round_[GLOB.round_id]"] = stats
	return data

/datum/rpi_scoreboard/proc/deserialize(list/data = list())
	if(!LAZYLEN(data))
		return
	owner_ckey = data["owner_ckey"]
	owner_slot = data["owner_slot"]
	alltime_score = data["alltime_score"]
	alltime_highest_score = data["alltime_highest_score"]
	for(var/smode in data["alltime_best_chat_actions"])
		for(var/list/act_dat in data["alltime_best_chat_actions"][smode])
			best_chat_actions_alltime[smode] += new /datum/rpi_chat_action(serial = act_dat)
	// only load the stat history, the rest are current-round only
	statistical_history = data["stat_history"]

/datum/rpi_scoreboard/proc/load_saved()
	var/path = SSrpi.GetPath("scoreboard_save", owner_ckey, owner_slot)
	var/jsonifax = rustg_file_read(path)
	if(!jsonifax)
		return
	var/h_dat = json_decode(jsonifax)
	deserialize(h_dat)
	return TRUE

/datum/rpi_scoreboard/proc/save()
	var/path = SSrpi.GetPath("scoreboard_save", owner_ckey, owner_slot)
	var/h_dat = serialize()
	var/jsonifax = json_encode(h_dat, JSON_PRETTY_PRINT)
	rustg_file_write(jsonifax, path)
	return TRUE

/proc/cmp_chat_act(datum/rpi_chat_action/first, datum/rpi_chat_action/second)
	return second.score - first.score
