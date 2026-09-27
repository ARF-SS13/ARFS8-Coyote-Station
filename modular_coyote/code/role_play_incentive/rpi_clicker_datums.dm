// compare-against datums for how good you were at doing an RPI

/datum/rpi_clicker
	var/min_pay = 0
	var/clicker_sound = ""
	var/list/goodgirl_texts = list()
	var/goodgirl_span = "notice"

/datum/rpi_clicker/proc/deliver_headpats(mob/living/gg, paid, do_good_n_clicker)
	var/msgs = span_notice("Incentive Payward Processed: +[paid] [MONEY_NAME]!")
	if(do_good_n_clicker && LAZYLEN(goodgirl_texts))
		msgs += "\n<span class='[goodgirl_span]'>[pick(goodgirl_texts)]</span>"
	to_chat(gg, msgs)
	if(do_good_n_clicker && clicker_sound)
		gg.playsound_local(gg, clicker_sound, 35)

// no clicker, no sound, you put your pants on, good for you man
/datum/rpi_clicker/bare_minimum
	min_pay = 15

/datum/rpi_clicker/low
	min_pay = 40
	clicker_sound = "modular_coyote/sounds/clickers/clicker_low.ogg"
	goodgirl_texts = list(
		"Not bad! Keep it up!",
		"Nice work! Keep going!")

/datum/rpi_clicker/medium
	min_pay = 80
	clicker_sound = "modular_coyote/sounds/clickers/clicker_mid.ogg"
	goodgirl_texts = list(
		"Good job! You did well!",
		"Keep it up!")
	goodgirl_span = "nicegreen"

/datum/rpi_clicker/high
	min_pay = 120
	clicker_sound = "modular_coyote/sounds/clickers/clicker_high.ogg"
	goodgirl_texts = list(
		"You're amazing!",
		"Fantastic!")
	goodgirl_span = "boldnicegreen"





