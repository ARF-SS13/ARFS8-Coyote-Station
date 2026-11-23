/// normal medibot
/datum/bark_pack/medibot/wait_for_me
	barks = list(
		/datum/bark/medibot/hold_on,
		/datum/bark/medibot/want_to_help,
		/datum/bark/medibot/you_are_injured,
	)

/datum/bark_pack/medibot/finished_healing
	barks = list(
		/datum/bark/medibot/all_patched_up,
		/datum/bark/medibot/apple_a_day,
		/datum/bark/medibot/feel_better,
	)

/datum/bark_pack/medibot/patient_died
	barks = list(
		/datum/bark/medibot/stay_with_me,
		/datum/bark/medibot/live,
		/datum/bark/medibot/never_lost,
	)

/datum/bark_pack/medibot/idle_normal
	barks = list(
		/datum/bark/medibot/delicious,
		/datum/bark/medibot/plastic_surgeon,
		/datum/bark/medibot/mask_on,
		/datum/bark/medibot/always_a_catch,
		/datum/bark/medibot/like_flies,
		/datum/bark/medibot/suffer,
	)

/datum/bark_pack/medibot/idle_emagged
	barks = list(
		/datum/bark/medibot/fuck_you,
		/datum/bark/medibot/not_a_game,
		/datum/bark/medibot/im_different,
		/datum/bark/medibot/fourth_wall,
		/datum/bark/medibot/shindemashou,
	)

/datum/bark_pack/medibot/being_tipped
	barks = list(
		/datum/bark/medibot/wait,
		/datum/bark/medibot/dont,
		/datum/bark/medibot/trusted_you,
		/datum/bark/medibot/no_sad,
		/datum/bark/medibot/oh_fuck,
	)

/datum/bark_pack/medibot/was_untipped
	barks = list(
		/datum/bark/medibot/forgive,
		/datum/bark/medibot/thanks,
		/datum/bark/medibot/good_person,
	)

/datum/bark_pack/medibot/idle_tipped
	barks = list(
		/datum/bark/medibot/put_back,
		/datum/bark/medibot/im_scared,
		/datum/bark/medibot/need_help,
		/datum/bark/medibot/this_hurts,
		/datum/bark/medibot/the_end,
		/datum/bark/medibot/nooo,
	)

/datum/bark_pack/medibot/idle_chicken
	barks = list(
		/datum/bark/medibot/chicken,
	)

/// barks
/datum/bark/medibot/hold_on
	message = "Hey! Hold on, I'm coming."
	soundpath = 'sound/mobs/non-humanoids/medbot/coming.ogg'

/datum/bark/medibot/want_to_help
	message = "Wait! I want to help!"
	soundpath = 'sound/mobs/non-humanoids/medbot/help.ogg'

/datum/bark/medibot/you_are_injured
	message = "You appear to be injured!"
	soundpath = 'sound/mobs/non-humanoids/medbot/injured.ogg'

/datum/bark/medibot/all_patched_up
	message = "All patched up!"
	soundpath = 'sound/mobs/non-humanoids/medbot/patchedup.ogg'

/datum/bark/medibot/apple_a_day
	message = "An apple a day keeps me away."
	soundpath = 'sound/mobs/non-humanoids/medbot/apple.ogg'

/datum/bark/medibot/feel_better
	message = "Feel better soon!"
	soundpath = 'sound/mobs/non-humanoids/medbot/feelbetter.ogg'

/datum/bark/medibot/stay_with_me
	message = "No! Stay with me!"
	soundpath = 'sound/mobs/non-humanoids/medbot/no.ogg'

/datum/bark/medibot/live
	message = "Live, damnit! LIVE!"
	soundpath = 'sound/mobs/non-humanoids/medbot/live.ogg'

/datum/bark/medibot/never_lost
	message = "I...I've never lost a patient before. Not today, I mean."
	soundpath = 'sound/mobs/non-humanoids/medbot/lost.ogg'

/datum/bark/medibot/delicious
	message = "Delicious!"
	soundpath = 'sound/mobs/non-humanoids/medbot/delicious.ogg'

/datum/bark/medibot/plastic_surgeon
	message = "I knew it, I should've been a plastic surgeon."
	soundpath = 'sound/mobs/non-humanoids/medbot/surgeon.ogg'

/datum/bark/medibot/mask_on
	message = "Radar, put a mask on!"
	soundpath = 'sound/mobs/non-humanoids/medbot/radar.ogg'

/datum/bark/medibot/always_a_catch
	message = "There's always a catch, and I'm the best there is."
	soundpath = 'sound/mobs/non-humanoids/medbot/catch.ogg'

/datum/bark/medibot/like_flies
	message = "What kind of medbay is this? Everyone's dropping like flies."
	soundpath = 'sound/mobs/non-humanoids/medbot/flies.ogg'

/datum/bark/medibot/suffer
	message = "Why are we still here? Just to suffer?"
	soundpath = 'sound/mobs/non-humanoids/medbot/why.ogg'

/datum/bark/medibot/fuck_you
	message = "Fuck you."
	soundpath = 'sound/mobs/non-humanoids/medbot/fuck_you.ogg'

/datum/bark/medibot/not_a_game
	message = "Turn off your computer. This is not a game."
	soundpath = 'sound/mobs/non-humanoids/medbot/turn_off.ogg'

/datum/bark/medibot/im_different
	message = "I'm different!"
	soundpath = 'sound/mobs/non-humanoids/medbot/im_different.ogg'

/datum/bark/medibot/fourth_wall
	message = "Close Dreamseeker.exe now. Or else."
	soundpath = 'sound/mobs/non-humanoids/medbot/close.ogg'

/datum/bark/medibot/shindemashou
	message = "Shindemashou."
	soundpath = 'sound/mobs/non-humanoids/medbot/shindemashou.ogg'

/datum/bark/medibot/wait
	message = "Hey, wait..."
	soundpath = 'sound/mobs/non-humanoids/medbot/hey_wait.ogg'

/datum/bark/medibot/dont
	message = "Please don't..."
	soundpath = 'sound/mobs/non-humanoids/medbot/please_dont.ogg'

/datum/bark/medibot/trusted_you
	message = "I trusted you..."
	soundpath = 'sound/mobs/non-humanoids/medbot/i_trusted_you.ogg'

/datum/bark/medibot/no_sad
	message = "Nooo..."
	soundpath = 'sound/mobs/non-humanoids/medbot/nooo.ogg'

/datum/bark/medibot/oh_fuck
	message = "Oh fuck-"
	soundpath = 'sound/mobs/non-humanoids/medbot/oh_fuck.ogg'

/datum/bark/medibot/forgive
	message = "I forgive you."
	soundpath = 'sound/mobs/non-humanoids/medbot/forgive.ogg'

/datum/bark/medibot/thanks
	message = "Thank you!"
	soundpath = 'sound/mobs/non-humanoids/medbot/thank_you.ogg'

/datum/bark/medibot/good_person
	message = "You are a good person."
	soundpath = 'sound/mobs/non-humanoids/medbot/youre_good.ogg'

/datum/bark/medibot/behaviour_reported
	message = "Your behavior has been reported, have a nice day."

/datum/bark/medibot/assistance
	message = "I require assistance."

/datum/bark/medibot/put_back
	message = "Please put me back."
	soundpath = 'sound/mobs/non-humanoids/medbot/please_put_me_back.ogg'

/datum/bark/medibot/im_scared
	message = "Please, I am scared!"
	soundpath = 'sound/mobs/non-humanoids/medbot/please_im_scared.ogg'

/datum/bark/medibot/need_help
	message = "I don't like this, I need help!"
	soundpath = 'sound/mobs/non-humanoids/medbot/dont_like.ogg'

/datum/bark/medibot/this_hurts
	message = "This hurts, my pain is real!"
	soundpath = 'sound/mobs/non-humanoids/medbot/pain_is_real.ogg'

/datum/bark/medibot/the_end
	message = "Is this the end?"
	soundpath = 'sound/mobs/non-humanoids/medbot/is_this_the_end.ogg'

/datum/bark/medibot/nooo
	message = "Nooo!"
	soundpath = 'sound/mobs/non-humanoids/medbot/nooo.ogg'

/datum/bark/medibot/chicken
	message = "LOOK AT ME?! I am a chicken."
	soundpath = 'sound/mobs/non-humanoids/medbot/i_am_chicken.ogg'











