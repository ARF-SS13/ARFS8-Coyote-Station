/datum/rpi_chat_rubric
	var/saymode = ""
	var/base_length = 75
	var/pay_per_point = 30
	var/mult_per_listener = 1.1
	var/optimal_distance = 4 // tiles, euclidean
	var/max_distance = 10 // tiles, also euclidean
	var/max_can_hear = 5
	var/count_listeners = TRUE
	var/check_length = TRUE

/datum/rpi_chat_rubric/default // say, ask, etc
	saymode = "default" // braixen brai!

/datum/rpi_chat_rubric/say // say, ask, etc
	saymode = SAYMODE_SAY // braixen brai!

/datum/rpi_chat_rubric/whisper
	saymode = SAYMODE_WHISPER

/datum/rpi_chat_rubric/ask
	saymode = SAYMODE_ASK

/datum/rpi_chat_rubric/yell
	saymode = SAYMODE_YELL

/datum/rpi_chat_rubric/exclaim
	saymode = SAYMODE_EXCLAIM

/datum/rpi_chat_rubric/whisper
	saymode = SAYMODE_WHISPER

/datum/rpi_chat_rubric/sing
	saymode = SAYMODE_SING

/datum/rpi_chat_rubric/radio
	saymode = SAYMODE_RADIO
	count_listeners = FALSE

/datum/rpi_chat_rubric/emote
	saymode = SAYMODE_EMOTE
	base_length = 50
	pay_per_point = 100

/datum/rpi_chat_rubric/emote_quick
	saymode = SAYMODE_EMOTE_QUICK
	pay_per_point = 5
	check_length = FALSE

/datum/rpi_chat_rubric/subtle
	saymode = SAYMODE_SUBTLE
	base_length = 50
	pay_per_point = 150 // get paid money to sex




