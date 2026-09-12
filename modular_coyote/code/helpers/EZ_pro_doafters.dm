SUBSYSTEM_DEF(ez_pro_doafters)
	name = "EzProDoafter"
	flags = SS_NO_FIRE
	var/list/easy_doings = list()

/datum/controller/subsystem/ez_pro_doafters/Initialize(start_timeofday)
	InitEasyDoafters()
	to_chat(world, span_abductor("Initialized [LAZYLEN(easy_doings)] ways of slowing you down!"))

/datum/controller/subsystem/ez_pro_doafters/proc/InitEasyDoafters()
	QDEL_LIST_ASSOC_VAL(easy_doings)
	for(var/datum/ez_pro_doafter/epda as anything in subtypesof(/datum/ez_pro_doafter))
		var/datum/ez_pro_doafter/fuzzbutt = new epda
		easy_doings[fuzzbutt::key] = fuzzbutt

/datum/controller/subsystem/ez_pro_doafters/proc/DoDoAfter(mob/doer, atom/target, mob/baroverride, kind)
	. = FALSE
	var/datum/ez_pro_doafter/doit = easy_doings[kind]
	if(!doit)
		to_chat(doer, "BAD, no such doafter: [kind]!!! youre the doer")
		to_chat(target, "BAD, no such doafter: [kind]!!! youre the target")
		return FALSE
	return doit.run_doafter(doer, target, baroverride)

/proc/ez_doafter(mob/doer, atom/target, mob/baroverride, kind)
	return SSez_pro_doafters.DoDoAfter(doer, target, baroverride, kind) // heh, dodo

/datum/ez_pro_doafter
	/// SET THIS TO A DEFINE! Look in file: [/code/__DEFINES/~~~~coyote_defines/doafter_defines.dm]
	var/key             = DOAFTER_EXAMPLE
	var/doafter_time    = 1 SECONDS
	var/progbar         = TRUE
	var/hidden_doafter  = FALSE
	var/no_text         = TRUE
	var/success_span            = "green"
	var/success_msg_self        = "You do the thing with $TARGET$!"
	var/success_msg_others      = "" // "$DOER$ does the thing with $TARGET$!"
	var/fail_span             = "alert"
	var/fail_msg_self         = "You fail to do the thing with $TARGET$!"
	var/fail_msg_others       = "" // "$DOER$ failes to do the thing with $TARGET$!"
	var/start_span          = "notice"
	var/start_msg_self      = "You start doing something with $TARGET$!"
	var/start_msg_others    = "" // "$DOER$ starts doing something with $TARGET$!"
	var/already_doing_span    = "alert"
	var/already_doing_msg     = "" // "You're already doing something!"

	// format: WEAKREF(doer) = projected time theyre done
	var/list/doers = list()

/// DOER: whos performing the action
/// TARGET: the thing they're doing it onz
/// BAROVERRIDE: optional, which mob specifically should see the progbar
/datum/ez_pro_doafter/proc/run_doafter(mob/doer, atom/target, mob/baroverride)
	. = FALSE
	var/datum/weakref/dooner = WEAKREF(target)
	if(doers[dooner] > world.time)
		to_chat(doer, format_msg(doer, target, already_doing_msg, already_doing_span))
		return FALSE
	else
		doers -= dooner
	doers[dooner] = world.time + doafter_time
	make_visible_or_self_message(doer, target, start_msg_self, start_msg_others, start_span)
	. = do_after(doer, doafter_time, target, progress = progbar, bar_override = baroverride, hidden = hidden_doafter)
	doers -= dooner
	if(.)
		make_visible_or_self_message(doer, target, success_msg_self, success_msg_others, success_span)
	else
		make_visible_or_self_message(doer, target, fail_msg_self, fail_msg_others, fail_span)
	return . // yes i know it does that anyway, its to be more clearly

/datum/ez_pro_doafter/proc/make_visible_or_self_message(mob/doer, atom/target, msg_self, msg_others, msg_span)
	if(no_text)
		return
	var/ms_me = format_msg(doer, target, msg_self, msg_span)
	if(LAZYLEN(msg_others) && !hidden_doafter)
		var/ms_notme = format_msg(doer, target, msg_others, msg_span)
		doer.visible_message(ms_notme, ms_me)
		return
	to_chat(doer, ms_me)

/datum/ez_pro_doafter/proc/format_msg(mob/doer, atom/target, message, spam)
	message = replacetext(message, "$DOER$", "[doer]")
	message = replacetext(message, "$TARGET$", "[target]")
	message = "<span class='[spam]'>[message]</span>"
	return message

/// THE ACTUAL ONES
/datum/ez_pro_doafter/lay_cable
	key = DOAFTER_LAY_CABLE
	doafter_time = 1 SECONDS
	progbar = TRUE
	hidden_doafter = FALSE
	// success_msg_self = "You place down some cable!"
	// fail_msg_self = "You were interrupted!"
	// start_msg_self = "You start laying some cable..."
	already_doing_msg = "You're already laying some cable!"

/// THE ACTUAL ONES
/datum/ez_pro_doafter/cutting_cable
	key = DOAFTER_CUTTING_CABLE
	doafter_time = 0.4 SECONDS
	progbar = TRUE
	hidden_doafter = TRUE
	// success_msg_self =  "You snip the cable!"
	// fail_msg_self =     "You were interrupted!"
	// start_msg_self =    "You start snipping the cable..."
	already_doing_msg = "You're already snipping some cable!"

/// THE ACTUAL ONES
/datum/ez_pro_doafter/cutting_cable
	key = DOAFTER_PRYING_FLOORTILE
	doafter_time = 0.4 SECONDS
	progbar = TRUE
	hidden_doafter = TRUE
	// success_msg_self =  "You pry up the floor!"
	// fail_msg_self =     "You were interrupted!"
	// start_msg_self =    "You start prying up the floor..."
	already_doing_msg = "You're already prying up the floor!"

/// THE ACTUAL ONES
/datum/ez_pro_doafter/disrobe
	key = DOAFTER_TAKE_CLOTHES_OFF
	doafter_time = 1.5 SECONDS
	progbar = TRUE
	hidden_doafter = TRUE
	// success_msg_self =  "You pry up the floor!"
	// fail_msg_self =     "You were interrupted!"
	// start_msg_self =    "You start prying up the floor..."
	already_doing_msg = "You're putting something on!"

/// THE ACTUAL ONES
/datum/ez_pro_doafter/health_analyzer
	key = DOAFTER_USE_HEALTH_ANALYZER
	doafter_time = 2 SECONDS
	progbar = TRUE
	hidden_doafter = FALSE
	no_text = FALSE
	success_span            = "green"
	success_msg_self        = "You analyze $TARGET$'s health status!"
	success_msg_others      = "$DOER$ analyzes $TARGET$'s health status!"
	fail_span             = "alert"
	fail_msg_self         = "You were interrupted!"
	fail_msg_others       = "$DOER$ was interrupted analyzing $TARGET$'s health status!"
	start_span          = "notice"
	start_msg_self      = "You start analyzing $TARGET$'s health status!"
	start_msg_others    = "$DOER$ starts analyzing $TARGET$'s health status!"
	already_doing_span    = "alert"
	already_doing_msg     = "You're already analyzing $TARGET$'s health status!"

/datum/ez_pro_doafter/health_analyzer_chem
	key = DOAFTER_USE_HEALTH_ANALYZER_CHEM
	doafter_time = 2 SECONDS
	progbar = TRUE
	hidden_doafter = FALSE
	no_text = FALSE
	success_span            = "green"
	success_msg_self        = "You analyze $TARGET$'s chemicals!"
	success_msg_others      = "$DOER$ analyzes $TARGET$'s chemicals!"
	fail_span             = "alert"
	fail_msg_self         = "You were interrupted!"
	fail_msg_others       = "$DOER$ was interrupted analyzing $TARGET$'s chemicals!"
	start_span          = "notice"
	start_msg_self      = "You start analyzing $TARGET$'s chemicals!"
	start_msg_others    = "$DOER$ starts analyzing $TARGET$'s chemicals!"
	already_doing_span    = "alert"
	already_doing_msg     = "You're already analyzing $TARGET$'s chemicals!"


