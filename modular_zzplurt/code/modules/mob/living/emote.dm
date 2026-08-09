

/datum/emote/living/ruffle
	key = "ruffle"
	key_third_person = "ruffles"
	message = "ruffles their wings for a moment."

/datum/emote/living/ruffle/run_emote(mob/user, params, type_override, intentional)
	message = "ruffles [user.p_their()] wings for a moment."
	. = ..()

/datum/emote/living/mew
	key = "mew"
	key_third_person = "mews"
	message = "mews hysterically!"
	message_mime = "makes a cat face!"
	sound = 'modular_zzplurt/sound/voice/meow_meme.ogg'
	cooldown = 1 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/bleat
	key = "bleat"
	key_third_person = "bleats"
	message = "bleats loudly!"
	message_mime = "bleats silently!"
	sound = 'modular_zzplurt/sound/voice/bleat.ogg'
	cooldown = 0.7 SECONDS

/datum/emote/living/carbon/moan/get_sound(mob/living/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return

	var/timbre
	if(H.gender == FEMALE || H.gender == MALE)
		timbre = H.gender
	else
		// Nonbinary uses physique instead
		timbre = H.physique

	if(timbre == FEMALE)
		if(H.arousal >= 50)
			sound = pick('modular_zzplurt/sound/voice/moan_fsex (8).ogg','modular_zzplurt/sound/voice/moan_fsex (9).ogg','modular_zzplurt/sound/voice/moan_fsex (10).ogg','modular_zzplurt/sound/voice/moan_fsex (11).ogg','modular_zzplurt/sound/voice/moan_fsex (12).ogg','modular_zzplurt/sound/voice/moan_fsex (13).ogg','modular_zzplurt/sound/voice/moan_fsex (14).ogg','modular_zzplurt/sound/voice/moan_fsex (15).ogg')
		else
			sound = pick('modular_zzplurt/sound/voice/moan_f1.ogg','modular_zzplurt/sound/voice/moan_f2.ogg','modular_zzplurt/sound/voice/moan_f3.ogg','modular_zzplurt/sound/voice/moan_f4.ogg','modular_zzplurt/sound/voice/moan_f5.ogg','modular_zzplurt/sound/voice/moan_f6.ogg','modular_zzplurt/sound/voice/moan_f7.ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (7).ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (8).ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (9).ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (10).ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (11).ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (12).ogg', 'modular_zzplurt/sound/voice/moan_fsexlight (13).ogg')
	else
		sound = pick('modular_zzplurt/sound/voice/moan_m1.ogg','modular_zzplurt/sound/voice/moan_m2.ogg','modular_zzplurt/sound/voice/moan_m3.ogg')
	return sound

/datum/emote/living/chitter2
	key = "chitter2"
	key_third_person = "chitters2"
	message = "chitters."
	message_mime = "chitters silently!"
	sound = 'modular_zzplurt/sound/voice/moth/mothchitter2.ogg'
	specific_emote_audio_cooldown = 0.3 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/boowomp
	key = "boowomp"
	key_third_person = "boowomps"
	message = "produces a sad boowomp."
	message_mime = "produces a silent boowomp."
	sound = 'modular_zzplurt/sound/voice/boowomp.ogg'
	specific_emote_audio_cooldown = 0.4 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/blink3
	key = "blink3"
	key_third_person = "blinks3"
	message = "blinks."
	message_mime = "blinks expressively."
	sound = 'modular_zzplurt/sound/voice/blink.ogg'
	specific_emote_audio_cooldown = 0.25 SECONDS
	emote_type = EMOTE_VISIBLE

/datum/emote/living/laugh3
	key = "laugh3"
	key_third_person = "laughs3"
	message = "laughs silly."
	message_mime = "acts out laughing silly."
	sound = 'modular_zzplurt/sound/voice/lol.ogg'
	specific_emote_audio_cooldown = 6.1 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/laugh4
	key = "laugh4"
	key_third_person = "laughs4"
	message = "burst into laughter!"
	message_mime = "acts out bursting into laughter."
	sound = 'modular_zzplurt/sound/voice/laugh_muta.ogg'
	specific_emote_audio_cooldown = 3 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/wtune
	key = "whistletune"
	key_third_person = "whistletunes"
	message = "whistles a tune."
	message_mime = "makes an expression as if whistling."
	sound = 'modular_zzplurt/sound/voice/wtune1.ogg'
	specific_emote_audio_cooldown = 4.55 SECONDS // Uses longest sound's time.
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/wtune/get_sound(mob/living/user)
	. = ..()
	return pick('modular_zzplurt/sound/voice/wtune1.ogg', 'modular_zzplurt/sound/voice/wtune2.ogg')

/datum/emote/living/fiufiu
	key = "wolfwhistle"
	key_third_person = "wolfwhistles"
	message = "wolf-whistles!" // i am not creative
	message_param = "audibly approves %t's appearance."
	message_mime = "makes an expression as if <i>inappropriately</i> whistling."
	sound = 'modular_zzplurt/sound/voice/wolfwhistle.ogg'
	specific_emote_audio_cooldown = 0.78 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/chill
	key = "chill"
	key_third_person = "chills"
	message = "feels a chill running down their spine..."
	message_mime = "acts out a chill running down their spine..."
	sound = 'modular_zzplurt/sound/voice/waterphone.ogg'
	specific_emote_audio_cooldown = 3.4 SECONDS
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/taunt
	key = "tt"
	key_third_person = "taunts"
	message = "strikes a pose!"
	message_param = "taunts %t!"
	sound = 'modular_zzplurt/sound/voice/phillyhit.ogg'
	emote_type = EMOTE_VISIBLE
	//is_muzzled = FALSE

/datum/emote/living/taunt/alt
	key = "tt2"
	key_third_person = "taunts2"
	sound_volume = 100
	sound = 'modular_zzplurt/sound/voice/orchestrahit.ogg'
	emote_type = EMOTE_VISIBLE

/datum/emote/living/weh2
	key = "weh2"
	key_third_person = "wehs2"
	message = "let out a weh!"
	message_mime = "acts out a weh!"
	sound = 'modular_zzplurt/sound/voice/weh2.ogg'
	specific_emote_audio_cooldown = 0.25 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/weh3
	key = "weh3"
	key_third_person = "wehs3"
	message = "let out a weh!"
	message_mime = "acts out a weh!"
	sound = 'modular_zzplurt/sound/voice/weh3.ogg'
	specific_emote_audio_cooldown = 0.25 SECONDS
	emote_type = EMOTE_AUDIBLE


/datum/emote/living/weh4
	key = "weh4"
	key_third_person = "wehs4"
	message = "let out a surprised weh!"
	message_mime = "acts out a surprised weh!"
	sound = 'modular_zzplurt/sound/voice/weh_s.ogg'
	specific_emote_audio_cooldown = 0.35 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/waa
	key = "waa"
	key_third_person = "waas"
	message = "let out a waa!"
	message_mime = "acts out a waa!"
	sound = 'modular_zzplurt/sound/voice/waa.ogg'
	specific_emote_audio_cooldown = 3.5 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/bark2
	key = "bark2"
	key_third_person = "barks2"
	message = "barks!"
	message_mime = "acts out a bark!"
	sound = 'modular_zzplurt/sound/voice/bark_alt.ogg'
	specific_emote_audio_cooldown = 0.35 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/yap
	key = "yap"
	key_third_person = "yaps"
	message = "yaps!"
	message_mime = "acts out a yap!"
	sound = 'modular_zzplurt/sound/voice/yap.ogg'
	specific_emote_audio_cooldown = 0.28 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/yip
	key = "yip"
	key_third_person = "yips"
	message = "yips!"
	message_mime = "acts out a yip!"
	sound = 'modular_zzplurt/sound/voice/yip.ogg'
	specific_emote_audio_cooldown = 0.2 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/woof/alt
	key = "woof2"
	key_third_person = "woofs2"
	sound = 'modular_zzplurt/sound/voice/woof2.ogg'
	specific_emote_audio_cooldown = 0.3 SECONDS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/coyhowl
	key = "coyhowl"
	key_third_person = "coyhowls"
	message = "howls like coyote!"
	message_mime = "acts out a coyote's howl!"
	sound = 'modular_zzplurt/sound/voice/coyotehowl.ogg'
	specific_emote_audio_cooldown = 2.94 SECONDS // Uses longest sound's time
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/coyhowl/get_sound(mob/living/user)
	. = ..()
	return pick('modular_zzplurt/sound/voice/coyotehowl.ogg', 'modular_zzplurt/sound/voice/coyotehowl2.ogg', 'modular_zzplurt/sound/voice/coyotehowl3.ogg', 'modular_zzplurt/sound/voice/coyotehowl4.ogg', 'modular_zzplurt/sound/voice/coyotehowl5.ogg')

/datum/emote/living/mlem
	key = "mlem"
	key_third_person = "mlems"
	message = "sticks their tongue for a moment. Mlem!"
	emote_type = EMOTE_VISIBLE

/datum/emote/living/snore/snore2/run_emote(mob/user, params)
	var/obj/item/organ/tongue/tongue = user.get_organ_slot(ORGAN_SLOT_TONGUE)
	var/say_mod = (tongue ? tongue.say_mod : "says")
	var/list/aaauughh = list(
		"lets out an <b>earthshaking</b> snore.",
		"lets out what sounds like a <b>painful</b> snore.",
		"[say_mod], <b>\"AAAAAAUUUUUUGGGHHHHH!!!\"</b>"
	)
	message = pick(aaauughh)

	// Set random emote sound
	sound = pick('modular_zzplurt/sound/voice/aauugghh1.ogg', 'modular_zzplurt/sound/voice/aauugghh2.ogg')

	// Return normally
	. = ..()

/datum/emote/living/pant
	key = "pant"
	key_third_person = "pants"
	message = "pants!"

/datum/emote/living/pant/run_emote(mob/user, params, type_override, intentional)
	var/list/pants = list(
				"pants!",
		"pants like a dog.",
		"lets out soft pants.",
		"pulls [user.p_their()] tongue out, panting."
	)
	message = pick(pants)
	. = ..()

/datum/emote/living/mewo
	key = "mewo"
	key_third_person = "mewos"
	message = "mewos!"
	message_mime = "mewos silently!"
	sound = 'modular_zzplurt/sound/voice/mewo.ogg'
	cooldown = 0.7 SECONDS

/datum/emote/living/facemetacarpus
	key = "facehand"
	key_third_person = "facepalms"
	message = "creates an error in the code."
	//muzzle_ignore = TRUE
//	restraint_check = TRUE
	sound = 'modular_zzplurt/sound/effects/slap.ogg'
	var/metacarpus_type = "palm"
	cooldown = 0.25 SECONDS

/datum/emote/living/facemetacarpus/run_emote(mob/user, params, type_override, intentional)
	message = pick(list(
		"places [usr.p_their()] [metacarpus_type] across [usr.p_their()] face.",
			"lowers [usr.p_their()] face into [usr.p_their()] [metacarpus_type].",
			"face[metacarpus_type]s",
	))
	. = ..()

/datum/emote/living/facemetacarpus/paw
	key = "facepaw"
	key_third_person = "facepaws"
	metacarpus_type = "paw"

/datum/emote/living/facemetacarpus/claw
	key = "faceclaw"
	key_third_person = "faceclaws"
	metacarpus_type = "claw"

/datum/emote/living/facemetacarpus/wing
	key = "facewing"
	key_third_person = "facewings"
	metacarpus_type = "wing"

/datum/emote/living/facemetacarpus/hoof
	key = "facehoof"
	key_third_person = "facehoofs"
	metacarpus_type = "hoof"

/datum/emote/living/merowr
	key = "merowr"
	key_third_person = "merowrs"
	message = "merowrs!"
	message_mime = "acts out a merowr!"
	sound = 'modular_zzplurt/sound/voice/merowr.ogg'
	cooldown = 1.2 SECONDS

/datum/emote/living/untitledgoose
	key = "goosehonk"
	key_third_person = "honks"
	message = "honks!"
	message_mime = "looks like a duck from hell!"
	sound = 'modular_zzplurt/sound/voice/goosehonk/sfx_goose_honk_b_01.ogg'
	cooldown = 0.8 SECONDS

/datum/emote/living/untitledgoose/get_sound(mob/living/user)
	. = ..()
	return pick('modular_zzplurt/sound/voice/goosehonk/sfx_goose_honk_b_01.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_goose_honk_b_02.ogg','modular_zzplurt/sound/voice/goosehonk/sfx_goose_honk_b_03.ogg','modular_zzplurt/sound/voice/goosehonk/sfx_goose_honk_b_06.ogg')

/datum/emote/living/untitledgooseB
	key = "goosehonkb"
	key_third_person = "honks differently!"
	message_mime = "looks like a duck from hell!"
	sound = 'modular_zzplurt/sound/voice/goosehonk/sfx_goose_honk_b_01.ogg'
	cooldown = 0.8 SECONDS

/datum/emote/untitledgooseB/get_sound(mob/living/user)
	. = ..()
	return pick('modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_02.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_03.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_04.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_06.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_07.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_08.ogg', 'modular_zzplurt/sound/voice/goosehonk/sfx_gooseB_honk_09.ogg')

/datum/emote/living/scream2
	key = "scream2"
	key_third_person = "screams2"
	message = "screams!"
	message_mime = "acts out a rather silly scream!"
	sound = 'modular_zzplurt/sound/voice/cscream1.ogg'
//	vary = FALSE

/datum/emote/living/scream2/get_sound(mob/living/user)
	. = ..()
	return pick('modular_zzplurt/sound/voice/cscream1.ogg', 'modular_zzplurt/sound/voice/cscream2.ogg', 'modular_zzplurt/sound/voice/cscream3.ogg', 'modular_zzplurt/sound/voice/cscream4.ogg', 'modular_zzplurt/sound/voice/cscream5.ogg', 'modular_zzplurt/sound/voice/cscream6.ogg', 'modular_zzplurt/sound/voice/cscream7.ogg', 'modular_zzplurt/sound/voice/cscream8.ogg', 'modular_zzplurt/sound/voice/cscream9.ogg', 'modular_zzplurt/sound/voice/cscream10.ogg', 'modular_zzplurt/sound/voice/cscream11.ogg', 'modular_zzplurt/sound/voice/cscream12.ogg')

/datum/emote/living/meow2/get_sound(mob/living/user)
	. = ..()
	return  pick('modular_zzplurt/sound/voice/catpeople/cat_meow1.ogg', 'modular_zzplurt/sound/voice/catpeople/cat_meow2.ogg', 'modular_zzplurt/sound/voice/catpeople/cat_meow3.ogg')


/datum/emote/living/meow2
	key = "meow2"
	key_third_person = "meows"
	message = "meows!"
	sound = 'modular_zzplurt/sound/voice/catpeople/cat_meow1.ogg'
	cooldowns = 0.8 SECONDS
	vary = FALSE

/datum/emote/living/meow2/get_sound(mob/living/user)
	. = ..()
	return pick('modular_zzplurt/sound/voice/catpeople/cat_mew1.ogg', 'modular_zzplurt/sound/voice/catpeople/cat_mew2.ogg')

/datum/emote/living/meow3
	key = "meow3"
	key_third_person = "mews!"
	message = "mews!"
	sound = 'modular_zzplurt/sound/voice/catpeople/cat_mew1.ogg'
	cooldowns = 0.8 SECONDS
	vary = FALSE

/datum/emote/living/cattrill
	key = "cattrill"
	key_third_person = "cattrills"
	message = "trills like a cat!"
	sound = 'modular_zzplurt/sound/voice/catpeople/cat_mrrp1.ogg'
	cooldowns = 0.8 SECONDS
	vary = FALSE

/datum/emote/living/cattrill2
	key = "cattrill2"
	key_third_person = "cattrills"
	message = "trills like a cat!"
	sound = 'modular_zzplurt/sound/voice/catpeople/cat_mrrp2.ogg'
	cooldowns = 0.8 SECONDS
	vary = FALSE

/datum/emote/living/shiss
	key = "shiss"
	key_third_person = "hisses"
	message = "hisses!"
	sound = 'modular_zzplurt/sound/voice/snake_hiss.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/hiss/get_sound(mob/living/user)
	return pick('modular_zzplurt/sound/voice/catpeople/cat_hiss1.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_hiss2.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_hiss3.ogg')

/datum/emote/living/coo
	key = "coo"
	key_third_person ="coos"
	message = "coos."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_zzplurt/sound/voice/coo.ogg'

/datum/emote/living/huh
	key = "huh"
	key_third_person = "huh's"
	message = "seems confused."
	sound = 'modular_zzplurt/sound/voice/huh.ogg'

/datum/emote/living/whine
	key = "whine"
	key_third_person = "whines"
	message = "whines."
	sound = 'modular_zzplurt/sound/voice/whine.ogg'

/datum/emote/living/meow4
	key = "meow4"
	key_third_person = "meows"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/meow4/get_sound(mob/living/user)
	return pick('modular_zzplurt/sound/voice/catpeople/cat_meow4.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_meow5.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_meow6.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_meow7.ogg')

/datum/emote/living/pain
	key = "pain"
	key_third_person = "cries out in pain!"
	message = "cries out in pain!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/pain/get_sound(mob/living/user)
	var/timbre
	if(user.gender == FEMALE || user.gender == MALE)
		timbre = user.gender
	else
		var/mob/living/carbon/human/H = user
		if(istype(H))
			// Nonbinary try to use physique instead
			timbre = H.physique
		else
			timbre = user.gender

	if(timbre == MALE)
		return pick('modular_zzplurt/sound/voice/human_male_pain_1.ogg', 'modular_zzplurt/sound/voice/human_male_pain_2.ogg', 'modular_zzplurt/sound/voice/human_male_pain_3.ogg', 'modular_zzplurt/sound/voice/human_male_pain_rare.ogg', 'modular_zzplurt/sound/voice/human_male_scream_1.ogg', 'modular_zzplurt/sound/voice/human_male_scream_2.ogg', 'modular_zzplurt/sound/voice/human_male_scream_3.ogg', 'modular_zzplurt/sound/voice/human_male_scream_4.ogg')
	return pick('modular_zzplurt/sound/voice/human_female_pain_1.ogg', 'modular_zzplurt/sound/voice/human_female_pain_2.ogg', 'modular_zzplurt/sound/voice/human_female_pain_3.ogg', 'modular_zzplurt/sound/voice/human_female_scream_2.ogg', 'modular_zzplurt/sound/voice/human_female_scream_3.ogg', 'modular_zzplurt/sound/voice/human_female_scream_4.ogg')

/datum/emote/living/wchoo
	key = "wachoo"
	key_third_person = "sneezes!"
	message = "sneezes!"
	sound = 'modular_zzplurt/sound/voice/wawa_achoo.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wchatter
	key = "wachat"
	key_third_person = "waa's"
	message = "waa's!"
	sound = 'modular_zzplurt/sound/voice/wawa_chatter.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wchillin
	key = "wachillin"
	key_third_person = "waa's happily!"
	message = "waa's happily!"
	sound = 'modular_zzplurt/sound/voice/wawa_chillin.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wdepression
	key = "wasad"
	key_third_person = "waa's sadly."
	message = "waa's sadly.."
	sound = 'modular_zzplurt/sound/voice/wawa_depression.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wdespair
	key = "wadespair"
	key_third_person = "waa's sadly."
	message = "waa's sadly.."
	sound = 'modular_zzplurt/sound/voice/wawa_despair.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wexclaim
	key = "waexclaim"
	key_third_person = "waa's curiously."
	message = "waa's!"
	sound = 'modular_zzplurt/sound/voice/wawa_exclaim.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wprotest
	key = "waprotest"
	key_third_person = "waa's in protest!"
	message = "waa's in protest!"
	sound = 'modular_zzplurt/sound/voice/wawa_protest.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wmock
	key = "wamock"
	key_third_person = "mocks in waa's"
	message = "mocks in waa's!"
	sound = 'modular_zzplurt/sound/voice/wawa_mock.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wquestion
	key = "waquestion"
	key_third_person = "curiously waa's"
	message = "curiously waa's."
	sound = 'modular_zzplurt/sound/voice/wawa_question.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wstate
	key = "wastate"
	key_third_person = "waa's!"
	message = "waa's!"
	sound = 'modular_zzplurt/sound/voice/wawa_statement.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wend
	key = "waend"
	key_third_person = "lets out their final waa!"
	message = "lets out their final waa!"
	sound = 'modular_zzplurt/sound/voice/wawa_the_end.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/datum/emote/living/wyawn
	key = "wayawn"
	key_third_person = "waa'awns!"
	message = "waa'awns!"
	sound = 'modular_zzplurt/sound/voice/wawa_yawn.ogg'
	emote_type = EMOTE_AUDIBLE
	sound_volume = 30

/particles/smoke/steam/billow
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("steam_1" = 1)
	width = 100
	height = 100
	count = 1
	spawning = 1
	friction = 0.25
	fade = 1 SECONDS
	lifespan = 1 SECONDS
	gravity = list(0, 0.3)
	drift = generator(GEN_SPHERE, 0, 1, NORMAL_RAND)

/particles/smoke/steam/billow/north
	position = list(1, 10, 0)
	velocity = list(0, 2, 0)

/particles/smoke/steam/billow/east
	position = list(8, 6, 0)
	velocity = list(2, 0, 0)

/particles/smoke/steam/billow/south
	position = list(1, 5, 0)
	velocity = list(0, -2, 0)

/particles/smoke/steam/billow/west
	position = list(-6, 6, 0)
	velocity = list(-2, 0, 0)

/datum/emote/living/bsmoke
	key = "bsmoke"
	key_third_person = "bellows smoke"
	message = "bellows smoke."
	sound = 'modular_zzplurt/sound/voice/bsmoke.ogg'
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/bsmoke/run_emote(mob/user, type_override = null, intentional = FALSE)
	. = ..()
	var/obj/effect/abstract/particle_holder/particle_effect = null
	if(user.dir & NORTH)
		particle_effect = new(user, /particles/smoke/steam/billow/north)
		if(particle_effect)
			particle_effect.layer = BELOW_MOB_LAYER
	else if(user.dir & EAST)
		particle_effect = new(user, /particles/smoke/steam/billow/east)
	else if(user.dir & SOUTH)
		particle_effect = new(user, /particles/smoke/steam/billow/south)
	else if(user.dir & WEST)
		particle_effect = new(user, /particles/smoke/steam/billow/west)
	if(particle_effect)
		QDEL_IN(particle_effect, particle_effect.particles.lifespan)
		if(ishuman(user))
			var/mob/living/carbon/human/smoker = user
			smoker.adjust_oxy_loss(1)
			particle_effect.particles.position[1] += smoker.mob_height - HUMAN_HEIGHT_MEDIUM
