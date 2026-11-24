

SUBSYSTEM_DEF(mail)
	name = "Mail"
	wait = 10 SECONDS
	flags = SS_NO_INIT

	var/list/mailboxes = list()

/datum/controller/subsystem/mail/fire(resumed)
	for(var/obj/structure/mailbox/box as anything in mailboxes)
		if(QDELETED(box))
			mailboxes -= box
			continue












