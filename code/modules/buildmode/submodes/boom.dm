#define BOOM_DEVASTATION "devastation"
#define BOOM_HEAVY "heavy"
#define BOOM_LIGHT "light"
#define BOOM_FLASH "flash"
#define BOOM_FLAMES "flames"
#define BOOM_BREACH "breach"

/datum/buildmode_mode/boom
	key = "boom"

	var/list/explosions = list(
		BOOM_DEVASTATION = 0,
		BOOM_HEAVY = 0,
		BOOM_LIGHT = 0,
		BOOM_FLASH = 0,
		BOOM_FLAMES = 0,
		BOOM_BREACH = 0,
	)

/datum/buildmode_mode/boom/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		"[span_bold("Set explosion destructiveness")] -> Right Mouse Button on buildmode button\n\
		[span_bold("Kaboom")] -> Mouse Button on obj\n\n\
		[span_warning("NOTE:")] Using the \"Config/Launch Supplypod\" verb allows you to do this in an IC way (i.e., making a cruise missile come down from the sky and explode wherever you click!)"))
	)

/datum/buildmode_mode/boom/change_settings(client/c)
	var/list/explotext = list()
	explotext += "EXPLOSION CONFIG -"
	explotext += "Modify the following settings -"
	explotext += "<-- EVERY LINE NEEDS TO START WITH THAT"
	explotext += "--------------------------------"
	explotext += "DE:[explosions[BOOM_DEVASTATION]] -- Devastation Range"
	explotext += "HE:[explosions[BOOM_HEAVY]] -- Heavy Range"
	explotext += "LE:[explosions[BOOM_LIGHT]] -- Light Range"
	explotext += "FE:[explosions[BOOM_FLASH]] -- Flash Range"
	explotext += "FB:[explosions[BOOM_FLAMES]] -- Flames Range"
	var/breachtext = explosions[BOOM_BREACH] ? "YES" : "NO"
	explotext += "BE:[breachtext] -- Can breach? (YES/NO)"
	var/thetext = explotext.Join("\n")
	thetext = input(c, thetext, "Explosion Settings", thetext) as message|null
	if(thetext == null)
		return
	// ok parse that garbage
	var/devindex = findtext(thetext, "DE:")
	var/heindex = findtext(thetext, "HE:")
	var/liindex = findtext(thetext, "LE:")
	var/flindex = findtext(thetext, "FE:")
	var/fmindex = findtext(thetext, "FB:")
	var/brindex = findtext(thetext, "BE:")
	if(devindex > 0)
		var/found_num = extract_number(thetext, devindex + 3)
		if(found_num != "")
			explosions[BOOM_DEVASTATION] = text2num(found_num)
	if(heindex > 0)
		var/found_num = extract_number(thetext, heindex + 3)
		if(found_num != "")
			explosions[BOOM_HEAVY] = text2num(found_num)
	if(liindex > 0)
		var/found_num = extract_number(thetext, liindex + 3)
		if(found_num != "")
			explosions[BOOM_LIGHT] = text2num(found_num)
	if(flindex > 0)
		var/found_num = extract_number(thetext, flindex + 3)
		if(found_num != "")
			explosions[BOOM_FLASH] = text2num(found_num)
	if(fmindex > 0)
		var/found_num = extract_number(thetext, fmindex + 3)
		if(found_num != "")
			explosions[BOOM_FLAMES] = text2num(found_num)
	if(brindex > 0)
		var/relevanttext = copytext(thetext, brindex + 3, LAZYLEN(thetext))
		if(relevanttext != "")
			explosions[BOOM_BREACH] = (relevanttext == "YES")
		else
			explosions[BOOM_BREACH] = FALSE

	to_chat(c, "Explosion settings updated to DE:[explosions[BOOM_DEVASTATION]], HE:[explosions[BOOM_HEAVY]], LE:[explosions[BOOM_LIGHT]], FE:[explosions[BOOM_FLASH]], FB:[explosions[BOOM_FLAMES]], BE:[explosions[BOOM_BREACH]]")

/datum/buildmode_mode/boom/proc/extract_number(thetext, start_index)
	var/found_num = ""
	for(var/i in start_index to LAZYLEN(thetext))
		var/c = thetext[i]
		var/maybenum = text2num(c)
		if(isnum(maybenum))
			found_num += c
		else
			break
	return found_num

/datum/buildmode_mode/boom/handle_click(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	var/value_valid = FALSE
	for (var/explosion_type in explosions)
		if (explosions[explosion_type] > 0)
			value_valid = TRUE
			break
	if (!value_valid)
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		log_admin("Build Mode: [key_name(c)] caused an explosion(dev=[explosions[BOOM_DEVASTATION]], hvy=[explosions[BOOM_HEAVY]], le=[explosions[BOOM_LIGHT]], fe=[explosions[BOOM_FLASH]], fb=[explosions[BOOM_FLAMES]], no_breachies=[!explosions[BOOM_BREACH]]) at [AREACOORD(object)]")
		explosion(object, explosions[BOOM_DEVASTATION], explosions[BOOM_HEAVY], explosions[BOOM_LIGHT], explosions[BOOM_FLASH], explosions[BOOM_FLAMES], adminlog = FALSE, ignorecap = TRUE, explosion_no_breach = !explosions[BOOM_BREACH])

#undef BOOM_DEVASTATION
#undef BOOM_HEAVY
#undef BOOM_LIGHT
#undef BOOM_FLASH
#undef BOOM_FLAMES
#undef BOOM_BREACH
