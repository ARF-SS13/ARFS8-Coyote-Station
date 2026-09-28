// ╔═════════════════════╗
// ║ CHAT ACTION         ║
// ║ A chat someone did! ║
// ╚═════════════════════╝
/datum/rpi_chat_action
	var/ckey = ""
	var/score = 0
	var/mult = 1
	var/text = ""
	var/saymode = ""
	var/listeners = 0
	var/used = FALSE

/datum/rpi_chat_action/New(who, score, mult, text, saymode, listeners, list/serial)
	if(deserialize(serial))
		return // its good!
	src.ckey = who
	src.score = score
	src.mult = mult
	src.text = text
	src.saymode = saymode
	src.listeners = listeners

/datum/rpi_chat_action/proc/serialize()
	var/list/data = list()
	data["score"] = score
	data["mult"] = mult
	data["text"] = text
	data["saymode"] = saymode
	data["listeners"] = listeners
	return data

/datum/rpi_chat_action/proc/deserialize(list/data = list())
	if(!LAZYLEN(data))
		return
	score = data["score"]
	mult = data["mult"]
	text = data["text"]
	saymode = data["saymode"]
	listeners = data["listeners"]
	used = TRUE // no double dinking!
	return TRUE

// Joe Joename said a long diatribe to 15 people, earning them 150 [MONEY_NAME]!
/datum/rpi_chat_action/proc/to_string()
	// var/mob/living/me = SSrpi.GetLikelyMob(ckey)
	// var/m_name = ""
	// if(!me)
	// 	m_name = "someone"
	// else
	// 	m_name = me.real_name
	var/smode = "whined"
	var/what = "something"
	switch(saymode)
		if(SAYMODE_SAY)
			smode = "said"
		if(SAYMODE_ASK)
			smode = "asked"
		if(SAYMODE_WHISPER)
			smode = "whispered"
		if(SAYMODE_EXCLAIM)
			smode = "exclaimed"
		if(SAYMODE_YELL)
			smode = "yelled"
		if(SAYMODE_EMOTE)
			smode = "did"
		if(SAYMODE_EMOTE_QUICK)
			smode = "did"
		if(SAYMODE_RADIO)
			smode = "radioed"
		if(SAYMODE_SING)
			smode = "sang"
		else
			smode = "whined like a bottom"
	return "[smode] [what] to [listeners] people, and made [score] [MONEY_NAME](s)!"

