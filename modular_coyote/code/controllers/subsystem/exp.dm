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

SUBSYSTEM_DEF(sexp)
	name = "SEXP"
	runlevels = RUNLEVEL_GAME
	wait = 2 SECONDS

	var/list/current_exp = list()
	var/list/social_modifiers = list()

/datum/controller/subsystem/sexp/fire(resumed = FALSE)

