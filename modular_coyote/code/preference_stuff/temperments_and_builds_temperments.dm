// ╔═══════════════════════════════╦═══════════════╦═══════════════════════════════╗
// ║ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ║ TEMPERAMENTS! ║ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ║
// ╠═══════════════════════════════╩═══════════════╩═══════════════════════════════╣
// ║The way you come off to others, whether that's a front or just the way you are.║
// ╠═══════════════════════════════════════════════════════════════════════════════╣
// ║ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ║
// ╚═══════════════════════════════════════════════════════════════════════════════╝

/datum/temperament_build/temperment
	tnb_category = TNB_TEMPERAMENT
	abstract_type = /datum/temperament_build/temperment

/datum/temperament_build/temperment/aggressive
	name = "Aggressive"
	desc = "You come off as kinda aggressive and forceful, whether that's a front or just the way you are. \
		Maybe you're a bit of a hothead, maybe you don't have the patience for social subtleties, maybe it's just the \
		way your culture is. To an outside observer, you come off as aggressive."
	init_desc = "$THEY $SEEM | like an aggressive, assertive sort of $SPECIES!"

/datum/temperament_build/temperment/anxious
	name = "Anxious"
	desc = "You come off to others as anxious and on edge, whether stressed, nervous, or just the way you present yourself. \
		Maybe you're a shut-in who is still new to social settings, maybe you just have a lot on your mind, maybe you're chronically \
		hopped up on caffeine (or drugs!). To an outside observer, you come off as anxious."
	init_desc = "$THEY $SEEM | kind of anxious!"

/datum/temperament_build/temperment/bratty
	name = "Bratty"
	desc = "You come off as a bratty little combative sort, whether playful or serious. \
		Maybe you like to push buttons for the reactions, or maybe you're just insecure about \
		your own feelings and hide it behind a combative front. To an outside observer, you come off as bratty."
	init_desc = "$THEY $SEEM | like a rather bratty little $SPECIES!"

/datum/temperament_build/temperment/calm
	name = "Calm"
	desc = "You come off as calm and collected, rarely rattled by the chaos around you. \
		Maybe you're a bit of a chill person, maybe you just hide your emotions well, maybe you \
		just don't really care. At any rate, you come off as calm."
	init_desc = "$THEY $SEEM | to be calm natured."

/datum/temperament_build/temperment/confident
	name = "Confident"
	desc = "You come off as confident and self-assured, whether that's a front or just the way you are. \
		Maybe you're a total pro at what you do, maybe you just pretend like you do, maybe you're just \
		comfortable in your own skin. To an outside observer, you come off as confident."
	init_desc = "$THEY | have an air of self-assured confidence in $THEIR demeanor!"

/datum/temperament_build/temperment/cuddly
	name = "Cuddly"
	desc = "You come off as a cuddly and affectionate sort, whether that's a front or just the way you are. \
		Maybe you're a tender lover and show it through physical affection, maybe you love the warmth and sensation \
		of close physical contact, maybe you have separation issues and need to be close to others. \
		To an outside observer, you come off as cuddly."
	init_desc = "$THEY $SEEM | like a cuddly, affectionate kind of $SPECIES!"

/datum/temperament_build/temperment/curious
	name = "Curious"
	desc = "You come off as curious and inquisitive, whether that's a front or just the way you are. \
		Maybe you're fascinated by the workings of the space-world around you, maybe you're interested in \
		digging into the personal lives of those around you, maybe you're just a nosy little critter. \
		To an outside observer, you come off as curious."
	init_desc = "$THEY $SEEM | like a curious and inquisitive $SPECIES!"

/datum/temperament_build/temperment/distracted
	name = "Distracted"
	desc = "You come off as distracted and preoccupied, whether that's a front or just the way you are. \
		Maybe you're a bit scatterbrained, maybe you have a lot on your mind, maybe you're just not \
		all that interested in the world around you. To an outside observer, you come off as distracted."
	init_desc = "$THEY $SEEM | distracted, like $THEIR mind tends to be elsewhere!"

/datum/temperament_build/temperment/dopey
	name = "Dopey"
	desc = "You come off as a bit dopey and not all there, whether that's a front or just the way you are. \
		Maybe you're a bit slow on the uptake, maybe your demeanor makes others underestimate your intelligence, \
		maybe you pretend to be a bit dopey to hide your true intentions. To an outside observer, you come off as a bit dopey."
	init_desc = "$THEY $SEEM | quite dopey, like $THEY don't have all $THEIR wits about $THEM!"

/datum/temperament_build/temperment/dorky
	name = "Dorky"
	desc = "You come off as a bit dorky and awkward, whether that's a front or just the way you are. \
		Maybe you're more proficient in your own interests than in social situations, maybe you just have \
		a quirky personality, maybe you put on a dorky front to hide your true self. To an outside observer, \
		you come off as a bit dorky."
	init_desc = "$THEY $SEEM | like a dorky, awkward sort of $SPECIES!"

/datum/temperament_build/temperment/eager
	name = "Eager"
	desc = "You come off as eager and enthusiastic, whether that's a front or just the way you are. \
		Maybe you're excited about the world around you, maybe you're a bit naive and easily impressed, \
		maybe you put on an eager front to hide your insecurities. (or maybe you're just an excitable dog =3) \
		To an outside observer, you come off as eager."
	init_desc = "$THEY $SEEM | eager, enthusiastic, and ready to take on the world!"

/datum/temperament_build/temperment/easygoing
	name = "Easygoing"
	desc = "You come off as easygoing and relaxed, whether that's a front or just the way you are. \
		Maybe you're a laid-back sort who doesn't sweat the small stuff, maybe your approach to hardship \
		is to just let it go, maybe you put on an easygoing front to hide your true feelings. Maybe you had a lobotomy? \
		To an outside observer, you come off as easygoing."
	init_desc = "$THEY $SEEM | very easygoing, like the world's annoyances just come and go!"

/datum/temperament_build/temperment/flighty
	name = "Flighty"
	desc = "You come off as flighty and unpredictable, whether that's a front or just the way you are. \
		Maybe you react to the world around you in a way that seems antsy and easily panicked, maybe \
		you have a lot of energy and can't sit still, maybe you just enjoy the thrill of being chased \
		around. Maybe you're some kind of skittery critter and your instincts are just to run away from danger. \
		To an outside observer, you come off as flighty."
	init_desc = "$THEY $SEEM | very flighty, prone to bolting and running away from danger (or just for fun)!"

/datum/temperament_build/temperment/flirty
	name = "Flirty"
	desc = "You come off as flirty and playful, whether that's a front or just the way you are. \
		Maybe you enjoy the tender thrill of teasing and being teased, maybe you long for the intimate connection \
		of romance, maybe your tone and actions come off as flirtatious even when you don't mean to. \
		To an outside observer, you come off as flirty."
	init_desc = "$THEY $SEEM | very flirtatious and playfully teasing!"

/datum/temperament_build/temperment/forward
	name = "Forward"
	desc = "You come off as forward and assertive, whether that's a front or just the way you are. \
		Maybe you're confident in your desires and don't shy away from expressing them, maybe you have a \
		direct approach to social interactions, maybe your demeanor comes off as forward even when you don't mean it. \
		To an outside observer, you come off as forward."
	init_desc = "$THEY $SEEM | very forward and assertive in $THEIR own demeanor!"

/datum/temperament_build/temperment/friendly
	name = "Friendly"
	desc = "You come off as friendly and approachable, whether that's a front or just the way you are. \
		Maybe you're genuinely welcoming to others, maybe put on a friendly front to make new acquaintances feel at ease, \
		maybe you're a total door-mat and you just want to be liked by everyone. To an outside observer, you come off as friendly."
	init_desc = "$THEY $SEEM | like a friendly and approachable sort of $SPECIES!"

/datum/temperament_build/temperment/gentle
	name = "Gentle"
	desc = "You come off as gentle and kind, whether that's a front or just the way you are. \
		Maybe you're a tender soul who cares deeply for others, maybe you are kind of a total pushover, \
		maybe you're incapable of being mean to anyone and just want to be liked. To an outside observer, you come off as gentle."
	init_desc = "$THEY $SEEM | very gentle and kind, very pleasant to be around!"

/datum/temperament_build/temperment/extroverted
	name = "Extroverted"
	desc = "You come off as extroverted and sociable, whether that's a front or just the way you are. \
		Maybe you're a social butterfly who thrives in group settings, maybe you enjoy being the center of attention, \
		maybe you just have a lot of friends and acquaintances. To an outside observer, you come off as extroverted."
	init_desc = "$THEY $SEEM | very extroverted and sociable, like they thrive in group settings!"

/datum/temperament_build/temperment/indifferent
	name = "Indifferent"
	desc = "You come off as indifferent and detached, whether that's a front or just the way you are. \
		Maybe you don't care much about the world around you, maybe you have a lot on your mind and can't focus on others, \
		maybe you're just hard to read. To an outside observer, you come off as indifferent."
	init_desc = "$THEY $SEEM | kind of indifferent, aloof, detached, like they don't really care about much!"

/datum/temperament_build/temperment/innocent
	name = "Innocent"
	desc = "You come off as innocent and naive, whether that's a front or just the way you are. \
		Maybe you've been sheltered and inexperienced in the ways of space's darker sides, maybe you have a \
		bright and optimistic outlook on life, maybe you're just holding on to your beliefs and ideals that \
		the world has tried and failed to crush. To an outside observer, you come off as innocent."
	init_desc = "$THEY $SEEM | like a very innocent and naive sort of $SPECIES!"

/datum/temperament_build/temperment/lazy
	name = "Lazy"
	desc = "You come off as lazy and unmotivated, whether that's a front or just the way you are. \
		Maybe you have a laid-back approach to life, maybe you're conserving your energy for something more important, \
		maybe you've just been through a lot and wonder if it's even worth it to keep going. \
		To an outside observer, you come off as lazy."
	init_desc = "$THEY $SEEM | rather lazy, like they don't have much motivation to do anything at all!"

/datum/temperament_build/temperment/lonely
	name = "Lonely"
	desc = "You come off as lonely and isolated, whether that's a front or just the way you are. \
		Maybe you long for companionship and connection, maybe you've been hurt in the past and need someone to to fill the void, \
		maybe you just can't function without someone to be there for you. To an outside observer, you come off as lonely."
	init_desc = "$THEY $SEEM | lonely, as though longing for companionship and/or connection!"

/datum/temperament_build/temperment/mature // mtndew
	name = "Mature"
	desc = "You come off as mature and responsible, whether that's a front or just the way you are. \
		Maybe you're a bit of a parent figure to those around you, maybe you have a lot of life experience and wisdom, \
		maybe you just take your responsibilities seriously. Maybe you're the station's mom/dad/bigger-sibling. \
		To an outside observer, you come off as mature."
	init_desc = "$THEY $SEEM | like a mature and responsible sort of $SPECIES!"

/datum/temperament_build/temperment/melancholic
	name = "Melancholic"
	desc = "You come off as melancholic and introspective, whether that's a front or just the way you are. \
		Maybe you have a lot of deep thoughts and feelings, maybe you're a bit of a pessimist, maybe you just have a \
		lot of emotional baggage that weighs on you. To an outside observer, you come off as melancholic."
	init_desc = "$THEY $SEEM | melancholic, down and in need of some love, like they have a lot on their mind!"

/datum/temperament_build/temperment/modest
	name = "Modest"
	desc = "You come off as modest and unassuming, whether that's a front or just the way you are. \
		Maybe you don't like to draw attention to yourself, maybe you have a humble and unpretentious nature, \
		maybe you know that if you do draw attention to yourself, it will reveal things you don't want others to know. \
		To an outside observer, you come off as modest."
	init_desc = "$THEY $SEEM | like a modest and unassuming sort of $SPECIES!"

/datum/temperament_build/temperment/rebellious
	name = "Rebellious"
	desc = "You come off as rebellious and defiant, whether that's a front or just the way you are. \
		Maybe you have a strong sense of individuality and don't like to be told what to do, maybe you have an \
		intense sense of justice and don't like to see others oppressed, maybe you just like to push buttons and \
		stir the pot. To an outside observer, you come off as rebellious."
	init_desc = "$THEY $SEEM | to have a rebellious and defiant sort of air to $THEM!"

/datum/temperament_build/temperment/relaxed
	name = "Relaxed"
	desc = "You come off as relaxed and easygoing, whether that's a front or just the way you are. \
		Maybe you have a laid-back approach to life, maybe you don't sweat the small stuff, maybe you just \
		have a lot of confidence in your own abilities. To an outside observer, you come off as relaxed."
	init_desc = "$THEY $SEEM | fairly relaxed, like $THEY don't worry too much about the world around $THEM!"

/datum/temperament_build/temperment/ruffled
	name = "Ruffled"
	desc = "You come off as ruffled and flustered, whether that's a front or just the way you are. \
		Maybe you have a lot on your mind and can't focus on the world around you, maybe you're easily \
		flustered by social interactions, maybe you just have a lot of energy and can't sit still. To an outside observer, \
		you come off as ruffled."
	init_desc = "$THEY $SEEM | a bit ruffled, like $THEY have a lot on $THEIR mind and can't focus on the world around $THEM!"

/datum/temperament_build/temperment/shy
	name = "Shy"
	desc = "You come off as shy and reserved, whether that's a front or just the way you are. \
		Maybe you're a bit of an introvert who prefers to keep to yourself, maybe you have a lot of social anxiety, \
		maybe you just don't like to draw attention to yourself. Maybe you're a total bottom and want someone to \
		push your boundaries. To an outside observer, you come off as shy."
	init_desc = "$THEY $SEEM | shy and reserved, but perhaps approachable if you try to get to know $THEM!"

/datum/temperament_build/temperment/silly
	name = "Silly"
	desc = "You come off as silly and playful, whether that's a front or just the way you are. \
		Maybe you have a playful sense of whimsy and enjoy making others laugh, maybe you don't take yourself \
		too seriously, maybe you just have a lot of energy and like to have fun. To an outside observer, you come off as silly."
	init_desc = "$THEY $SEEM | like a silly, playful sort of $SPECIES, always ready to have a bit of fun!"

/datum/temperament_build/temperment/smart
	name = "Smart"
	desc = "You come off as a smart little cookie, whether that's a front or just the way you are. \
		Maybe you're a bit of a bookworm who enjoys learning, maybe you have a lot of life experience and wisdom, \
		maybe you just know enough big words and trivia to make others think you're smarter than you really are. \
		To an outside observer, you come off as smart."
	init_desc = "$THEY $SEEM | like a smart cookie, in a bookish kind of way!"

/datum/temperament_build/temperment/timid
	name = "Timid"
	desc = "You come off as timid and hesitant, whether that's a front or just the way you are. \
		Maybe you're a bit of a wallflower who prefers to stay in the background, maybe you have a lot of social anxiety \
		that makes it hard to assert yourself, maybe you lack the self-confidence to believe you're worthy of attention \
		or respect. To an outside observer, you come off as timid."
	init_desc = "$THEY $SEEM | like a timid, hesitant sort of $SPECIES!"

/datum/temperament_build/temperment/tired
	name = "Tired"
	desc = "You come off as tired and weary, whether that's a front or just the way you are. \
		Maybe you have a lot on your mind and can't focus on the world around you, maybe you work far harder than you have \
		the energy for, maybe you have a very active night life and don't get enough sleep. \
		To an outside observer, you come off as tired."
	init_desc = "$THEY $SEEM | kinda tired, kinda eepy, like $THEY could use a nap!"

/datum/temperament_build/temperment/trustworthy
	name = "Trustworthy"
	desc = "You come off as trustworthy and reliable, whether that's a front or just the way you are. \
		Maybe you're a bit of a rock for those around you, maybe you have a strong moral compass and always try to do the right thing, \
		maybe you just know better than to betray the trust of those who rely on you. \
		To an outside observer, you come off as trustworthy."
	init_desc = "$THEY $SEEM | quite trustworthy, like the sort of $SPECIES you could rely on in a pinch!"

/datum/temperament_build/temperment/warm
	name = "Warm"
	desc = "You come off as warm and loving, whether that's a front or just the way you are. \
		Maybe you're a bit of a caregiver who enjoys nurturing those around you, maybe you have a lot of empathy and compassion, \
		maybe you've been burned in the past and want to make sure others don't feel the same pain. \
		To an outside observer, you come off as warm."
	init_desc = "$THEY $SEEM | warm and caring, like the sort of $SPECIES who makes others feel at ease!"
