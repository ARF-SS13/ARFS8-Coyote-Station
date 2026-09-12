#define NO_MAXVOTES_CAP -1

SUBSYSTEM_DEF(autotransfer)
	name = "Autotransfer Vote"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES

	var/rigid_length = TRUE
	var/targt_round_length = 3 HOURS
	var/can_vote_to_extend = FALSE
	var/starttime
	var/targettime
	var/voteinterval = 2 MINUTES
	var/maxvotes = 0
	var/curvotes = 0

/datum/controller/subsystem/autotransfer/Initialize()
	if(!CONFIG_GET(flag/autotransfer)) //Autotransfer voting disabled.
		can_fire = FALSE
		return SS_INIT_NO_NEED

	starttime = REALTIMEOFDAY
	targettime = starttime + targt_round_length
	return SS_INIT_SUCCESS

/datum/controller/subsystem/autotransfer/Recover()
	starttime = SSautotransfer.starttime
	voteinterval = SSautotransfer.voteinterval
	curvotes = SSautotransfer.curvotes

/datum/controller/subsystem/autotransfer/fire()
	if(REALTIMEOFDAY < targettime || !SSticker.current_state == GAME_STATE_PLAYING || EMERGENCY_AT_LEAST_DOCKED)
		return
	if(!isnull(SSvote.current_vote))
		return
	if(can_vote_to_extend && (maxvotes == NO_MAXVOTES_CAP || maxvotes > curvotes))
		SSvote.initiate_vote(/datum/vote/transfer_vote, "automatic transfer", forced = TRUE)
		targettime = targettime + voteinterval
		curvotes++
	else
		SSshuttle.autoEnd()

/**
 * At shift start, pulls the autotransfer interval from config and applies
 *
 * Arguments:
 * * real_round_shift_time - World time the round left the pregame lobby
 */
/datum/controller/subsystem/autotransfer/proc/new_shift(real_round_start_time)
	if(rigid_length)
		return
	var/init_vote = CONFIG_GET(number/vote_autotransfer_initial) // Check if an admin has manually set an override in the pre-game lobby
	starttime = real_round_start_time
	targettime = starttime + init_vote
	log_game("Autotransfer enabled, first vote in [DisplayTimeText(targettime - starttime)]")
	message_admins("Autotransfer enabled, first vote in [DisplayTimeText(targettime - starttime)]")

#undef NO_MAXVOTES_CAP
