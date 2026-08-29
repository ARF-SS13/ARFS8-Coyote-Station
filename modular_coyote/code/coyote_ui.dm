//Coyote UI functions pulled from CB/CBT

/atom/movable/screen/posebutton
	name = "Set Pose"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "pose"
	screen_loc = "EAST-1:28,SOUTH+1:35"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/posebutton/Click()
	if(isliving(usr))
		var/mob/living/user = usr
		user.set_temporary_flavor()

