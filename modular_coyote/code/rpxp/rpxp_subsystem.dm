/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * File: modular_coyote/code/controllers/subsystem/exp.dm
 * Author: Funjob
 * Date: 2024-06-06 (Thursday, 10:00 AM, GMT+0, ISO 8601, YYYY-MM-DDTHH:MM:SSZ)
 * License: COOLDAN-3.2
 * Operation: Sleepy Weasel
 *
 * Welcome to the Coyote ARFS-13 Roleplay Experience Headquarters!
 * Where your actions and whatnot translate into numbers, and those
 * numbers into levels and jobs and quirks and stuff!
 *
 * It expands upon the ideas in Coyote Sector's Roleplay Incentive System.
 *
 * Certain actions are tracked, judged, and rewarded with SEXP (Superlagg's Experience Points) (name pending)
 * actions such as:
 * - Interacting with other people
 * - Doing things in a job that we want you to do
 *   - calling the cargo shuttle (rewards whole department, more exp for bigger orders)
 * - Doing horny (or platonic) scenes with other people
 * - Having a fleshed out character or something
 * - Hangin out with ppl
 * - Achieving personal quests and goals
 * - Being Comfy
 *
 * Levels are gained as you accumulate SEXP, unlocking new stuff, like:
 * - New quirks
 * - Quirk points
 * - Better jobs
 * - Spacebux?
 * - I dunno we'll figure it out
 *
 * So how it work, everyones got a folder full of json files, cus thats the only way i know how to database
 * theyll never come up with a better way to store sensitive data than a bunch of json files!
 * they are tied to your CKEY, which means i guess that your progress is linked to your account.
 *
 * Welcome to SEXP! May I take your order?
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

SUBSYSTEM_DEF(rpxp)
	name = "RPXP"
	runlevels = RUNLEVEL_GAME
	wait = 2 SECONDS

	var/social_exp_interval = 20 MINUTES
	var/list/exp_datums = list()
	var/list/social_modifiers = list()
	var/list/queud_for_loading = list() //ckeys
	var/ready

/datum/controller/subsystem/rpxp/Initialize()

/datum/controller/subsystem/rpxp/fire(resumed = FALSE)

/datum/controller/subsystem/rpxp/proc/load_rpxp(ckey)
	// Implementation for loading RPXP data for a given ckey would go here.
	if(!am_ready())
		queue(ckey)
		return
	// Proceed with loading RPXP data for the ckey since the subsystem is ready.





/datum/rpxp_manager
	var/ckey = ""
	var/savekey = ""
	var/datum/weakref/curr_owner
	var/list/levels = list()
	var/list/social_actions = list()
	var/last_updated
	var/last_tick
	var/next_tick_timeleft

/datum/rpxp_holder
	var/ckey = ""
	var/level_kind = ""
	var/current_level = 0
	var/current_exp = 0

/datum/rpxp_level/proc/xp2lvl()
	/*
	 * put some kind of cool maths thing here to convert XP to level
	 */





/// Its a record of a social action, to later be judged and potentially rewarded with SEXP
/datum/rpxp_social_action
	var/action_kind
	var/list/recipients = list() // ckeys
	var/timestamp = 0
	var/text = ""
	var/comfy = FALSE

/*
 * Lagg's notes
 * Lets say that the max level should be... oh, 100. or 60, i like eq
 * How long should it take a player to reach the max level?
 * rather, breakpoints for certain level values that determine jobs unlocked and such
 * like, lvl up to 5 to unlock actual jobs, 30 for senior jobs, 45 for heads, 50 for captain
 *
 * cargo:
 * - XP from mail
 *   - opener, deliverer, and whole department gets XP + cash
 *
 *
 *
 */
