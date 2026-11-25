SUBSYSTEM_DEF(autotransfer)
	name = "Autotransfer Vote"
	flags = SS_KEEP_TIMING | SS_BACKGROUND | SS_NO_INIT // ticker does it
	runlevels = RUNLEVEL_GAME
	wait = 1 MINUTES

	var/time_round_started
	var/target_end_time
	var/voteinterval
	var/maxvotes
	var/curvotes = 0
	var/blanktries = 3

	var/can_has_transfer_vote = FALSE

	var/desired_round_length = 3 HOURS // no more no less

	// if(!CONFIG_GET(flag/autotransfer)) //Autotransfer voting disabled.
	// 	can_fire = FALSE
	// 	return SS_INIT_NO_NEED

	// var/init_vote = CONFIG_GET(number/vote_autotransfer_initial)
	// starttime = REALTIMEOFDAY
	// targettime = starttime + init_vote
	// voteinterval = CONFIG_GET(number/vote_autotransfer_interval)
	// maxvotes = CONFIG_GET(number/vote_autotransfer_maximum)
	// return SS_INIT_SUCCESS

/datum/controller/subsystem/autotransfer/Recover()
	time_round_started    = SSautotransfer.time_round_started
	target_end_time       = SSautotransfer.target_end_time
	voteinterval          = SSautotransfer.voteinterval
	maxvotes              = SSautotransfer.maxvotes
	curvotes              = SSautotransfer.curvotes
	desired_round_length  = SSautotransfer.desired_round_length

/datum/controller/subsystem/autotransfer/fire()
	if(!time_round_started)
		blanktries--
		message_admins("Ticker didnt set autotransfer, trying [blanktries] more times!")
		if(blanktries < 1)
			message_admins("Ticker didnt set autotransfer, doing it anyway!!")
			new_shift(SSticker.real_round_start_time)
		return
	if(REALTIMEOFDAY < target_end_time || !SSticker.current_state == GAME_STATE_PLAYING || EMERGENCY_AT_LEAST_DOCKED)
		return
	if(!isnull(SSvote.current_vote))
		return
	SSshuttle.autoEnd()

/**
 * At shift start, pulls the autotransfer interval from config and applies
 *
 * Arguments:
 * * real_round_shift_time - World time the round left the pregame lobby
 */
/datum/controller/subsystem/autotransfer/proc/new_shift(real_round_start_time, you_tell_em = TRUE)
	// var/init_vote = CONFIG_GET(number/vote_autotransfer_initial) // Check if an admin has manually set an override in the pre-game lobby
	time_round_started = real_round_start_time
	target_end_time = time_round_started + desired_round_length
	var/timestart_cute = GetRoundStartTime()
	var/timeend_cute = GetProjectedRoundEndTime()
	var/roundlength_cute = GetDesiredRoundLength() // minutes i think
	var/list/msg = list(
		"Round started on [span_abductor(timestart_cute)]",
		"Round should last around [span_abductor(roundlength_cute)]",
		"Shuttle will be called at [span_abductor(timeend_cute)]",
	)
	if(you_tell_em)
		to_chat(world, span_notice(msg.Join("\n")))
	log_game("Autotransfer updated! [msg.Join("\n")]")
	message_admins("Autotransfer updated! [msg.Join("\n")]")

/datum/controller/subsystem/autotransfer/proc/GetProjectedRoundEndTime()
	return "[time2text(target_end_time, "DDD MMM DD hh:mm", -8)], [CURRENT_STATION_YEAR]"

/datum/controller/subsystem/autotransfer/proc/GetDesiredRoundLength()
	return "[DisplayTimeText(desired_round_length, 6)]"

/datum/controller/subsystem/autotransfer/proc/GetRoundStartTime()
	return "[time2text(time_round_started, "DDD MMM DD hh:mm", -8)], [CURRENT_STATION_YEAR]" // wait is pst + or -8? might be 6 nope its -8
