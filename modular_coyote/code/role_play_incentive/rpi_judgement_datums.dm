// ╔═══════════════════╗
// ║ JUDGEMENT         ║
// ║ A PAST RPI PAYOUT ║
// ╚═══════════════════╝
/datum/rpi_judgement
	var/time_done = 0
	var/roundtime_done = 0
	var/round_done = 0
	var/score = 0
	var/what = ""
	var/owner_ckey = ""
	var/owner_slot = 0

/datum/rpi_judgement/New(ownerkey, ownerslot, score, what, load_from)
	if(load_from)
		load(load_from)
		return
	src.score = score
	src.what = what
	owner_ckey = ownerkey
	owner_slot = ownerslot
	time_done = world.realtime
	roundtime_done = DisplayTimeText(world.time)
	round_done = GLOB.round_id

/datum/rpi_judgement/proc/serialize()
	var/h_dat = list()
	h_dat["owner_ckey"] = owner_ckey
	h_dat["owner_slot"] = owner_slot
	h_dat["time_done"] = time_done
	h_dat["roundtime_done"] = roundtime_done
	h_dat["round_done"] = round_done
	h_dat["score"] = score
	h_dat["what"] = what
	return h_dat

/datum/rpi_judgement/proc/deserialize(list/h_dat = list())
	if(!LAZYLEN(h_dat))
		return
	owner_ckey = h_dat["owner_ckey"]
	owner_slot = h_dat["owner_slot"]
	time_done = h_dat["time_done"]
	roundtime_done = h_dat["roundtime_done"]
	round_done = h_dat["round_done"]
	score = h_dat["score"]
	what = h_dat["what"]

/datum/rpi_judgement/proc/load(filepath)
	if(!rustg_file_exists(filepath))
		return
	var/j_savestring = rustg_file_read(filepath)
	var/list/j_savejson = json_decode(j_savestring)
	deserialize(j_savejson)

/datum/rpi_judgement/proc/save()
	var/filepath = SSrpi.GetPath("judgement_save", owner_ckey, owner_slot, time_done)
	var/list/j_dat = serialize()
	var/j_json = json_encode(j_dat, JSON_PRETTY_PRINT)
	rustg_file_write(j_json, filepath)
