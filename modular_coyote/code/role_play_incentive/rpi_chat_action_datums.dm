// ╔═════════════════════╗
// ║ CHAT ACTION         ║
// ║ A chat someone did! ║
// ╚═════════════════════╝
/datum/rpi_chat_action
	var/score = 0
	var/mult = 1
	var/text = ""
	var/saymode = ""
	var/listeners = 0
	var/used = FALSE

/datum/rpi_chat_action/New(score, mult, text, saymode, listeners, list/serial)
	if(deserialize(serial))
		return // its good!
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

