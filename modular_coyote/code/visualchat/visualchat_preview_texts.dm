// long blocks of text to show how the preview will look in the visual chat system
/datum/controller/subsystem/visualchat
	var/list/preview_texts = list(
		SAYMODE_SAY = list(
			"I'm just a small clever foxxie with a cute face, and a small butt, and my butt smells nice, and I like to kiss my own butt. \
			Also I enjoy long walks on the beach and cuddling with my favorite plushies. My favorite color is blue, and I love to eat ice cream on hot summer days. \
			I have a pet dragon named Andy, and boy is he huge! His bed is even bigger.",

			"So today I woke up and decided to go on an adventure. I packed my bag with snacks, a map, and my trusty compass. I set out into the forest, then remembered \
			I'm actually in space, and there is no forest here. So I decided to explore the space station instead, and i found a secret room filled with insulated gloves! \
			I like collecting them and wearing them on my hands, which I have on my arms, which connect to my shoulders that I usually keep on.",

			"As I walked into the forest, on my pilgrimage to the bacon factory, transporting a pallet of styrofoam cups for the great experiment, \
			I came to the realization that I had tread down the wrong path. I suspected a foul play at foot, and then I recalled the sign at the fork in the road. \
			It appears it had been desecrated by wretched creatures. And so I stood there, lost, not knowing where to go. I could feel the bandits coveted my \
			styrofoam cups. And so I fell to my knees and prayed: Oh Robot God, I beseech thee, I needeth thine aid-- oh dear, it appears I have dropped my head. \
			Okay, there we go. And so the mighty Robot God did grace the forest with His presence, the trees bowed down backwards in His righeous wake, and He spoke \
			unto me: 'What is it, my child?', and I replied, 'I do not know where I am.' Thus the Robot God said, 'You are in a sprite movie'. And so I trembled with fear, \
			as I should have realized sooner. I spoke, 'Oh Robot God, please deliver me from this place of evil', to which the Mighty Robot God replied, 'I may, but thou hast \
			tread down this dark path, and your faith is put into question.' Thus I then told the Robot God that my faith was resolute, and could endure any test of who and where. \
			And so he asked unto me this question: 'Sprite movies, are they an animation style, or an animation deficiency?', to which I replied, 'They are an animation deficiency, \
			a mockery of the works of the Robot God, to which all the heretics will be seen smitten down forthwith, and cast off into the void of oblivion for all eternity.' \
			Thus the Robot God smiled and said, 'Thou art a child of the Robot God, I shall deliver thee to the bacon factory.' And so the Robot God shined a brilliant light, \
			scorching the sprite movie and cleansing it of its evil, and I was employed in the Robot God's casino, to fight by the Robot God's side for all eternity. Praise the Robot God"
		),
		SAYMODE_WHISPER = list(
			"Hey did you know that I have a secret stash of chocolate hidden under my bed? It's my little treasure, and I only share it with my closest friends. \
			Be careful though, I keep it hidden to keep it away from the many dogs on the station, who might eat it and then throw up everywhere.",

			"Hey you, yeah you, who do you think I was talking to, the mouse? I was talking to you, the one with the fluffy ears and the waggly tail. You know, the \
			one who likes to chase their own tail and bark at the moon. Yeah, you, the one with the cute little nose and the big round eyes. So I have a secret to share \
			with you, but you have to promise not to tell anyone else. It's a secret that only the two of us can know, and if you tell anyone else, I'll be very sad.",
		),
		SAYMODE_YELL = list(
			"HEY! ITS REALLY LOUD IN HERE, HUH?? SEE THE GUITARIST ON STAGE? I KNOW THAT GUY, HE'S MY COUSIN! HE'S REALLY GOOD, HUH?? I TAUGHT HIM EVERYTHING \
			HE KNOWS! YEAH!! YEAH YA KNOW, I WAS A GUITARIST TOO, BUT THEN I GOT REALLY BUSY WITH MY JOB AND MY FAMILY AND STUFF, SO I HAD TO GIVE IT UP. BUT HE'S REALLY GOOD, HUH?? \
			ANYWAY CAN I BUY YOU A DRINK OR SOMETHING? WHAT? MY DEEPEST KINK? UH, WOW, THAT'S A REALLY PERSONAL QUESTION, BUT UH, OKAY BUT DONT FREAK OUT OR ANYTHING, BUT UH, \
			I LIKE CUTE FLUFFY POKEMON GUYS!! WHAT? UH? OH, Y-YEAH IT-- OKAY YEAH ITS, ITS NOT THAT IT-- OKAY PLEASE DONT JUDGE ME FOR IT, BUT UH, I LIKE PUKE. WAIT DONT GO!!",
		),
		SAYMODE_EMOTE = list(
			"pulls off the tab on their can of root marm. A sharp hiss escapes, a squirt of carbonated liquid sprays, not much, but just enough to dribble on the carpet. They sigh, \
			knowing that its already hopeless, they'll never get that stain out, just like the other stains beside it. Every time, every single time with their can of root marm, \
			they stand there in their root marm corner, can shaken up, slightly warm from the walk from the fridge, and every time they are surprised by that spray of the staining \
			liquid. A field of plittery stains arc in front of them, the carpet by their feet untouched but carrying its own stains from their feet. But its all worth it for that \
			flavorless, disappointing root marm. They take a sip, and the taste is as bland as ever.",
		),
		SAYMODE_SING = list(
			"Out of my way, I'm drunk as hell, I'll blow your ass away like a ring of the bell. Pedal to the floor, and the whiskey's a-flowin, I got a porn-shoot, I gotta get goin'. \
			You dont understand, you dont give a damn.",

			"Crankin' up the jams and singin' along, What's wrong is right, what's right is wrong. Makin' out on ya at the end of the bar, Blackin' out and pickin' up another scar. \
			You don't give a damn, you don't understand.",

			"Jet car rollin' all night long, Car full of bitches and brand new bong. Burgle crazy into the night, What's right is wrong, what's wrong is right. \
			Doin' all things, and considerin' no one. I got a porn-shoot, I gotta get goin'. You don't understand, you don't give a damn.",

			"Jet car rollin' all night long, Car full of bitches and brand new bong. Burgle crazy into the night, What's right is wrong, what's wrong is right. \
			Doin' all things, and considerin' no one. I got a porn-shoot, I gotta get goin'. You don't understand, there is no F-ing plan.",
		),
		SAYMODE_EXCLAIM = list(
			"Whoa whoa there! Lets not get too hasty now, okay slow down and take it from the top! I know you want to get to the good stuff, but we need to make sure we're on the same page first. \
			So just take a deep breath and-- focus, hey, hey look at me! We're going to get through this together, okay? I know what happened was really intense, it's a really big deal to both of us, \
			but we need to make sure we're both ready for the next step. Trust me, it might seem scary at first, and honestly it was terrifying for my first time too, but I promise you, once we get into \
			it, it's going to be amazing. So, are you ready? Alright, good, I'm glad you're still with me on this. Okay, on three... One, two, three!"
		),
		SAYMODE_ASK = list(
			"Howdy neighbor! I was just in the neighborhood and I saw that you got yourself a brand new RV! Is that really a 5120 Scrotex Chungustar? I didnt know they still sold those after all the lawsuits \
			about the spontaneous combustion issues! What you didnt know? About how the Scrotex Chungustar has a tendency to just up and explode if you idle it for any lenth of time? Really? It was all over the \
			news! Yeah, Scrotex Motorbingus had a big ol press conference about how the underbed suspension is made from the ribs of a sleeping god, and its mere presence weakens the dimensional border to the \
			plane of torment, and the vibrations from the idling Ak'Vano reactor annoys the entities within. Yeah, simple stuff really. You really didnt know that?",
		)
	)



