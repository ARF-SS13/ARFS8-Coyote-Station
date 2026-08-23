// ╔═══════════════════════════════╦═══════════════╦═══════════════════════════════╗
// ║ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ║    Builds!    ║ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ║
// ╠═══════════════════════════════╩═══════════════╩═══════════════════════════════╣
// ║ The way you physically seem to others! Kind of an elevator pitch of your      ║
// ║ character's physicality, so you dont *need* to read a huge horny wall of text ║
// ║ just to know if that characters got big boobs or and a fat ass.               ║
// ╠═══════════════════════════════════════════════════════════════════════════════╣
// ║ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ☺ ☻ ║
// ╚═══════════════════════════════════════════════════════════════════════════════╝

/datum/character_snippet/build
	category_csnip = CSNIP_BUILD
	abstract_type = /datum/character_snippet/build

/datum/character_snippet/build/buxom_1
	name = "Big Breasts"
	desc = "Your chest sports a set of large, prominent breasts, big enough to turn heads and draw attention, yet not so \
		huge as to be abnormally large. Maybe you're naturally endowed, maybe you have a lot of body fat that collects \
		in your chest, maybe you have a lot of muscle mass that makes your chest appear larger than it is. Could be \
		implants, gene-mods, or some kind of space-magic!"
	init_desc = "$THEY $SPORT | a buxom figure with a set of large, prominent breasts!"
	set_key = "boob_hugeness"
	order = 2

/datum/character_snippet/build/buxom_2
	name = "Huge Breasts"
	desc = "Your chest sports a set of exceptionally large breasts, so big that they are impossible to ignore and larger \
		than what is considered 'big' by your species' standards. Maybe you're naturally well-endowed, maybe you have a lot \
		of body fat that collects in your chest, maybe you have implants or gene-mods that grant or enhance your 'natural' \
		bust size. Could be a blessing or a curse, but either way, your chest is impossible to ignore!"
	init_desc = "$THEIR | breasts are exceptionally large, more so than what is considered 'big' by the average $SPECIES!"
	set_key = "boob_hugeness"
	order = 3

/datum/character_snippet/build/buxom_3
	name = "Ginormous Breasts"
	desc = "Your chest sports a set of enormous, pendulous breasts, exceptionally large and impossible to ignore, so huge as to \
		be an abnormality and potentially a hindrance to your daily life. Maybe your breasts are just naturally enormous, \
		maybe you have a lot of body fat that collected in your chest, maybe you got yourself some implants or gene-mods. \
		Could be a curse from some space-magic, or a blessing from the same. Either way, your chest is impossible to ignore, \
		by you or anyone else!"
	init_desc = "$THEIR | breasts are absurdly huge, far larger than what is normal for the average $SPECIES!"
	set_key = "boob_hugeness"
	order = 4

// ╔═══════════════════════════════════════════════════════════════════════════════╗
// ║ Yes I know the boob descriptions are longer and flowerier than the other ones ║
// ║ However it is my code and I can write whatever i want ╔═══════════════════════╝
// ║ just wait till i get to the fats! ╔═══════════════════╝
// ╚═══════════════════════════════════╝

/datum/character_snippet/build/broadshouldered
	name = "Broad Shouldered"
	desc = "Your shoulders are broad and sturdy, giving you a strong and imposing presence. Maybe you are a large and muscular \
		individual, maybe your stockiness emphasizes your upper body, maybe you're just wider than you are tall. \
		Either way, you appear to have a broad set of shoulders!"
	init_desc = "$THEIR | shoulders are broad and sturdy!"

/datum/character_snippet/build/extremely_short
	name = "Shortest"
	desc = "You are extremely short, far smaller than anyone would expect someone on the station to be. Maybe you're naturally small, \
		maybe you are a genetic anomaly that stunted your growth, maybe you took growth suppressants to remain tiny. Either way, you appear \
		to be an extremely short individual!"
	init_desc = "$THEY $ARE | extremely short!"
	set_key = "tallness"
	order = 3

/datum/character_snippet/build/very_short
	name = "Shorter"
	desc = "You are very short, standing well below the average height of the station. Maybe you're naturally small, \
		maybe you were underfed as a youngster and never grew to your species' average size, maybe you took growth suppressants to remain small. \
		Either way, you appear to be a very short individual!"
	init_desc = "$THEY $ARE | very short!"
	set_key = "tallness"
	order = 2

/datum/character_snippet/build/short
	name = "Short"
	desc = "You are short, standing noticeably below the average height of the station. Maybe you're naturally small, maybe you were underfed \
		as a youngster and never grew to your species' average size, maybe you took growth suppressants to remain small. Either way, you appear \
		to be a short individual!"
	init_desc = "$THEY $ARE | kinda short!"
	set_key = "tallness"
	order = 1

/datum/character_snippet/build/tall
	name = "Tall"
	desc = "You are tall, standing noticeably above the average height of the station. Maybe you're naturally tall, maybe you were well fed \
		as a youngster and grew taller than your species' average size, maybe you took growth enhancers to become taller. Either way, you appear \
		to be a tall individual!"
	init_desc = "$THEY $ARE | kinda tall!"
	set_key = "tallness"
	order = 4

/datum/character_snippet/build/very_tall
	name = "Taller"
	desc = "You are very tall, standing well above the average height of the station. Maybe you're naturally tall, maybe you are host to a genetic \
		a genetic form of gigantism, maybe you took growth enhancers to become taller. Either way, you appear \
		to be a very tall individual!"
	init_desc = "$THEY $ARE | very tall!"
	set_key = "tallness"
	order = 5

/datum/character_snippet/build/extremely_tall
	name = "Tallest"
	desc = "You are extremely tall, far above the average height of the station. Maybe your abnormal height is due to a genetic form of excessive gigantism, \
		maybe you took growth enhancers to become taller, maybe you are host to some kind of space-magic that has made you taller than anyone else. Either way, you appear \
		to be an extremely tall individual!"
	init_desc = "$THEY $ARE | extremely tall!"
	set_key = "tallness"
	order = 6

/datum/character_snippet/build/slender
	name = "Slender"
	desc = "Your body is slender, lightly built, a frame that is more delicate than imposing. Maybe you're a naturally thin \
		individual, maybe you don't get enough nutrition to bulk up, maybe you have a metabolism that burns through calories \
		faster than you can consume them, maybe you just maintain a twinkish figure for aesthetic reasons. In any case, you \
		appear to have a slender, lightly built frame!"
	init_desc = "$THEY $LOOK | like a slender, delicately built $SPECIES!"
	set_key = "fatness"

/datum/character_snippet/build/athletic
	name = "Athletic"
	desc = "You have an athletic, well-toned build, appearing quite fit and full of stamina and endurance. Maybe you work out \
		a lot and maintain a strict fitness regimen, maybe your work or lifestyle keeps you active and in shape, maybe you are \
		host to some kind of gene-therapies or medical enhancements that keep you in peak physical condition with minimal effort. \
		Either way, you appear to have an athletic, well-toned build!"
	init_desc = "$THEY $LOOK | quite athletically fit, possibly full of stamina and energy!"

/datum/character_snippet/build/stocky
	name = "Stocky"
	desc = "You have a stocky, solid build, sturdy in appearance and likely strong for your size. Maybe you're a compact yet \
		powerful individual, maybe your species tends to be more 'dwarfish' in stature, maybe you're from a high-gravity \
		world that has made you more dense and solid than your peers. Either way, you appear to have a stocky, solid build!"
	init_desc = "$THEY $LOOK like a | stocky, solidly built $SPECIES!"

/datum/character_snippet/build/lithe
	name = "Lithe"
	desc = "You have a lithe build, appearing slender, flexible, yet not necessarily weak or frail. Maybe you're simply in-shape \
	for your species, maybe you keep a slim figure for functional or aesthetic reasons, maybe you have a metabolism that prevents \
	you from gaining excess weight or muscle mass, yet still maintain a somewhat healthy physique. Either way, you appear to \
	have a lithe, flexible build!"
	init_desc = "$THEY $APPEAR | to keep a lithe, flexible physique!"

/datum/character_snippet/build/lean
	name = "Lean"
	desc = "You have a lean build, appearing fit and toned, with minimal excess body fat and muscle mass. Maybe you maintain \
		a strict diet and exercise regimen, maybe your species tends to be kinda wiry, maybe you have a metabolism that keeps \
		you from gaining excess weight or muscle mass. Either way, you appear to have a lean, toned build!"
	init_desc = "$THEY $LOOK | fairly lean, with minimal excess body fat or muscle mass!"

/datum/character_snippet/build/muscular
	name = "Muscular"
	desc = "Your muscles are well-defined and prominent, appearing strong in a sort of body-builder-esque way. Maybe you work \
		out a lot and maintain a strict fitness regimen, maybe you want to appear strong and imposing for aesthetic reasons, \
		maybe you're a typical 'meathead' who enjoys having something to 'flex' for their preferred audience. Either way, you \
		appear to have a muscular, well-defined physique!"
	init_desc = "$THEIR | muscles are very well-defined and prominent, like a body-builder!"

/datum/character_snippet/build/burly
	name = "Burly"
	desc = "Your muscles are large and powerful, built for raw brute strength, possibly looking kinda doughy and soft while \
		at rest, but clearly powerful when in use. Maybe your lifestyle or work requires you to be strong and capable, maybe you \
		have a metabolism that allows you to bulk up easily, maybe you just enjoy the aesthetic of being a big, strong, \
		bearish sort of individual. Either way, you appear to have a burly, powerful physique!"
	init_desc = "$THEIR | figure looks very burly, with large, powerful muscles!"

/datum/character_snippet/build/petite
	name = "Petite"
	desc = "You are a small, petite individual, appearing like a dainty, delicate waif of a person. Maybe you're naturally small \
		and light, maybe you were underfed as a youngster and never grew to your species' average size, maybe your species really \
		is just small and delicate like a cute little mouse. Either way, you appear to be a petite, delicate individual!"
	init_desc = "$THEY $LOOK | like a petite, delicate $SPECIES!"

/datum/character_snippet/build/willowy
	name = "Willowy"
	desc = "You have a willowy build, appearing tall and slender, with long limbs that give you a graceful, elegant appearance, \
		yet not considered 'lanky' or awkward. Maybe you're naturally tall and thin, maybe you were raised in a low-gravity \
		environment that allowed you to grow taller and longer than your peers, maybe you're host to genetic modifications \
		that give you more of a 'model-esque' physique. Either way, you appear to have a willowy, graceful build!"
	init_desc = "$THEY $HAVE | a willowy, graceful build, with long limbs and a slender frame!"

/datum/character_snippet/build/heavyset
	name = "Heavyset"
	desc = "You have a heavyset build, carrying excess body fat and muscle mass, yet not necessarily \
		to the point of being obese or unhealthy, distributed in a rather imposing manner. Maybe you're naturally a \
		big boi/girl/etc, maybe you have a metabolism that allows you to gain weight easily, maybe you just enjoy the \
		aesthetic of being a larger, more robust individual. Either way, you appear to have a heavyset, robust build!"
	init_desc = "$THEY $LOOK | quite heavyset, with a robust, well-padded frame!"

/datum/character_snippet/build/curvy
	name = "Curvy"
	desc = "You have a rather curvy build, with pronounced rounded flowing lines defining your figure, possibly somewhat \
		feminine in your general appearance. Maybe you're naturally endowed with a curvy figure, maybe your body fat \
		distributes in a way that emphasizes your curves, maybe you have implants or gene-mods that enhance your natural \
		curvaceousness. Either way, you appear to have a curvy, flowing figure!"
	init_desc = "$THEY $LOOK | quite curvaceous, with pronounced rounded flowing lines defining $THEIR figure!"

/datum/character_snippet/build/gangly
	name = "Gangly"
	desc = "You have a gangly build, appearing tall and lanky, with long limbs that give you a somewhat awkward appearance. \
		Maybe you're naturally tall and thin, maybe you were raised in a low-gravity environment that allowed you to grow taller \
		and longer than your peers, maybe you're an awkward, clumsy sort of individual who doesn't quite know how to carry \
		themselves. Either way, you appear to have a gangly, lanky build!"
	init_desc = "$THEY $SEEM | like a gangly, lanky $SPECIES, somewhat awkward in their movements and posture!"

/datum/character_snippet/build/husky
	name = "Husky"
	desc = "You have a husky build, appearing solid and sturdy, with a bit of extra body mass that gives you a more robust appearance. \
		Maybe you're naturally well-built, maybe you have a metabolism that allows you to gain weight easily, maybe you just enjoy \
		the aesthetic of being a larger, more robust individual. Either way, you appear to have a husky, solid build!"
	init_desc = "$THEY $LOOK | quite husky, with a solid, sturdy frame!"

/datum/character_snippet/build/compact
	name = "Compact"
	desc = "You have a compact, solid build, sturdy in appearance and likely strong for your size. Maybe you're a compact yet \
		powerful individual, maybe your species tends to be more 'dwarfish' in stature, maybe you're from a high-gravity \
		world that has made you more dense and solid than your peers. Either way, you appear to have a compact, solid build!"
	init_desc = "$THEY $LOOK | like a compact, solid $SPECIES!"

/datum/character_snippet/build/chiseled
	name = "Chiseled"
	desc = "Your features are sharply defined and angular, giving you a rather chad-like appearance. Maybe you have a strong \
		jawline and prominent cheekbones, maybe you're overworked and underfed, maybe you regularly exercise your facial muscles \
		to 'mog' your peers and impress your preferred audience. Either way, you appear to have a chiseled, \
	angular face!"
	init_desc = "$THEIR | facial features are sharply defined and angular, giving $THEM a chiseled appearance!"

/datum/character_snippet/build/softbuilt
	name = "Soft-Built"
	desc = "You have a soft, rounded build, appearing very plush and cuddly, padded with a bit of extra body mass that \
		gives you a more approachable and huggable appearance. Maybe you're naturally soft and plush, maybe you have a metabolism \
		that allows you to gain weight easily, maybe your species tends to be more 'fluffy' in stature. Either way, you appear \
		to have a soft, rounded build!"
	init_desc = "$THEY $LOOK | quite soft and plush, with a rounded, huggable frame!"

/datum/character_snippet/build/topheavy
	name = "Top Heavy"
	desc = "You have a top-heavy build, carrying more mass in your upper body than your lower body, whether that is due to muscle \
		or fat distribution. Maybe your upper body is naturally larger and more developed, maybe you have very large breasts or pecs, \
		maybe you have a metabolism that allows you to gain weight in your upper body more easily than your lower body. Either way, \
		you appear to have a top-heavy build!"
	init_desc = "$THEY $LOOK | top-heavy, carrying around more mass in their upper body than their lower body!"
	set_key = "topbottomness"

/datum/character_snippet/build/bottomheavy
	name = "Bottom Heavy"
	desc = "You have a bottom-heavy build, carrying more mass in your lower body than your upper body, whether that is due \
		to muscle or fat distribution. Maybe you focus more on lower body workouts, maybe your body fat concentrates more \
		disproportionately in your butt and thighs, maybe you've received implants or gene-mods that embiggen the junk in \
		your trunk. Either way, you appear to have a bottom-heavy build!"
	init_desc = "$THEY $LOOK | bottom-heavy, carrying around more mass in their lower body than their upper body!"
	set_key = "topbottomness"

/datum/character_snippet/build/barrelchested
	name = "Barrel Chested"
	desc = "Your chest is very barrel-shaped, with a wide, deep volume that gives you a strong and imposing presence, though \
		the more medically inclined might worry about your cardiovascular health. Maybe you're exceptionally well-built \
		and muscular, maybe your species tends to have a more prominent ribcage, maybe you've suffered from a medical \
		condition that has caused your chest to expand and become more barrel-like. Either way, you appear to have a \
		barrel-chested build!"
	init_desc = "$THEIR | chest is wide and deep, giving them a barrel-chested appearance!"

/datum/character_snippet/build/narrowframed
	name = "Narrow Framed"
	desc = "You have a narrow-framed build, with a smaller, more delicate skeletal structure that gives you a more \
		fragile and less imposing appearance. Maybe you're naturally small and light, maybe you have a metabolism that \
		prevents you from gaining excess weight or muscle mass, maybe your species tends to be more 'delicate' in stature. \
		Either way, you appear to have a narrow-framed build!"
	init_desc = "$THEY $LOOK | like a narrow-framed $SPECIES, with a smaller, more delicate skeletal structure!"

/datum/character_snippet/build/widehipped
	name = "Wide Hipped"
	desc = "Your hips are wider than average, giving you a more curvaceous 'motherly' silhouette. Maybe your pelvis is \
		naturally wider than average, maybe your hips accumulate more body fat than is typical for your species, maybe you \
		have received implants or gene-mods that fatten your hips or widen your pelvis. Either way, you appear to have a \
		wide-hipped build!"
	init_desc = "$THEY $HAVE | some really wide, motherly hips!"

/datum/character_snippet/build/longtorsoed
	name = "Long Torsoed"
	desc = "Your torso is longer than average, giving you more of a swimmer's build. Maybe your spine is naturally longer \
		than average, maybe your species has aquatic adaptations that give you a longer torso, maybe you're Johnny Longtorso, \
		the man who comes in pieces. Either way, you appear to have a long-torsoed build!"
	init_desc = "$THEIR | torso is longer than average!"

/datum/character_snippet/build/longlegged
	name = "Long Legged"
	desc = "Your legs quite long in proportion to the rest of you, giving you a more elegant and graceful appearance. \
		Maybe your species has evolved to have longer legs for running or jumping, maybe your legs are naturally longer \
		than average, maybe you're a leggy maned wolf! Either way, you appear to have a long-legged build!"
	init_desc = "$THEY $HAVE | noticeably long legs!"

/datum/character_snippet/build/shortlimbed
	name = "Short Limbed"
	desc = "Your arms and legs are shorter in proportion to the rest of you, giving you a more compact and sturdy appearance. \
		Maybe your species has evolved to have shorter limbs for burrowing or climbing, maybe your limbs are naturally shorter \
		than average, maybe you're a cute ferret! Either way, you appear to have a short-limbed build!"
	init_desc = "$THEY $HAVE | short arms and legs in proportion to the rest of their body!"

/datum/character_snippet/build/hourglass
	name = "Hourglass"
	desc = "Your body has a pronounced hourglass shape, with a narrow waist and wider hips and chest. Maybe your body fat \
		distributes in a way that emphasizes your curves, maybe you have implants or gene-mods that enhance your natural \
		curvaceousness, maybe you're just naturally blessed with an hourglass figure. Either way, you appear to have an \
		hourglass-shaped build!"
	init_desc = "$THEY $HAVE | a pronounced hourglass figure that emphasizes their hips and chest!"
	set_key = "proportionality"

/datum/character_snippet/build/appleshaped
	name = "Apple Shaped"
	desc = "Your body has a pronounced apple shape, with a wider midsection and narrower hips and chest. Maybe your body fat \
		distributes in a way that emphasizes your midsection, maybe your belly accumulates more body fat than is typical for \
		your species, maybe you've got a bit of a beer belly. Either way, you appear to have an apple-shaped build!"
	init_desc = "$THEY $HAVE | a pronounced apple shape that emphasizes their midsection!"
	set_key = "proportionality"

/datum/character_snippet/build/pearshaped
	name = "Pear Shaped"
	desc = "Your body has a pronounced pear shape, with wider hips and thighs and a narrower waist and chest. Maybe your \
		butt and thighs accumulate more body fat than is typical for your species, maybe you've got a thick, juicy ass, \
		maybe you're host to some kind of gene-therapy or implants that embiggen your behind. Either way, you appear \
		to have a pear-shaped build!"
	init_desc = "$THEY $HAVE | a pronounced pear shape that emphasizes their hips and thighs!"
	set_key = "proportionality"

/datum/character_snippet/build/invertedtriangle
	name = "Inverted Triangle"
	desc = "Your body has a pronounced inverted triangle shape, with broader shoulders and chest and narrower hips and waist. \
		Maybe your upper body is naturally larger and more developed, maybe you have very large pecs or delts, maybe you've \
		received implants or gene-mods that embiggen your upper body. Either way, you appear to have an inverted triangle-shaped build!"
	init_desc = "$THEY $HAVE | a pronounced inverted triangle shape!"

/datum/character_snippet/build/thickthighed
	name = "Thick Thighed"
	desc = "Your thighs are thick and heavy, be that from muscle or fat, giving you a strong or curvaceous lower body. Maybe \
		you work out your legs a lot and have developed strong, muscular thighs, maybe your body fat distributes in a way that \
		emphasizes your thighs, maybe you've eaten a lot of space-cake and your thighs have grown thick and heavy. Either way, \
		you appear to have thick, heavy thighs!"
	init_desc = "$THEY $HAVE | thick, heavy thighs!"

/datum/character_snippet/build/ruggedlybuilt
	name = "Ruggedly Built"
	desc = "You have a ruggedly built physique, appearing solid and durable. Maybe you're naturally well-built, maybe you have \
		a metabolism that allows you to gain weight easily, maybe you just enjoy the aesthetic of being a larger, more robust \
		individual. Either way, you appear to have a ruggedly built physique!"
	init_desc = "$THEY $LOOK | ruggedly built, with a solid and durable frame!"

/datum/character_snippet/build/average
	name = "Average"
	desc = "You have an average build, with no extreme features or proportions. Maybe you're naturally average in size and \
	shape, maybe you were engineered to be a 'baseline' specimen for your species, maybe you're just a regular, everyday sort \
	of individual. Either way, you appear to have an average build!"
	init_desc = "$THEY $LOOK | like a fairly average $SPECIES, with no extreme features or proportions!"

/datum/character_snippet/build/plush
	name = "Plush"
	desc = "You have a plush build, appearing soft and cuddly, with a bit of extra body mass that gives you a more \
		approachable and huggable appearance. Maybe you're naturally soft and plush, maybe you have a metabolism that allows \
		you to gain weight easily, maybe your species tends to be more 'fluffy' in stature. Either way, you appear to have a \
		plush, cuddly build!"
	init_desc = "$THEY $LOOK | pleasantly plump and soft around the edges!"
	set_key = "fatness"

/datum/character_snippet/build/chubby
	name = "Chubby"
	desc = "You are somewhat chubby, carrying around a fair bit of extra body fat on your frame. Maybe your body naturally \
		accumulates fat more easily than others, maybe you enjoy indulging in rich foods and treats, maybe you enjoy the \
		aesthetic of being a bit more rounded and soft. Either way, you appear to be somewhat chubby!"
	init_desc = "$THEY $LOOK | a bit chubby, carrying around some extra body fat!"
	set_key = "fatness"

/datum/character_snippet/build/fat
	name = "Fat"
	desc = "You are quite fat, carrying around a significant amount of extra body fat on your frame. Maybe your body naturally \
		accumulates fat more easily than others, maybe your species tends to be more well-padded, maybe you enjoy the aesthetic \
		of being big and soft. Either way, you appear to be quite fat!"
	init_desc = "$THEY $LOOK | quite fat, carrying around a significant amount of extra body fat!"
	set_key = "fatness"

/datum/character_snippet/build/obese
	name = "Obese"
	desc = "You are very obese, weighed down by an excessive amount of body fat. Maybe your body's metabolism makes it very \
		easy for you to gain weight, maybe you habitually overeat and indulge in fattening foods, maybe you seek to grow larger \
		for personal or aesthetic reasons. Either way, you appear to be very obese!"
	init_desc = "$THEY $LOOK | very obese, weighed down by an excessive amount of body fat!"
	set_key = "fatness"

/datum/character_snippet/build/morbidlyobese
	name = "Morbidly Obese"
	desc = "You are morbidly obese, overburdened by a tremendous amount of excess body fat. Maybe your body's metabolism \
		makes it extremely easy for you to gain weight and impossible to lose it, maybe you habitually overeat and indulge \
		in fattening foods, maybe you seek to grow larger for personal or aesthetic reasons. Either way, you appear to be \
		morbidly obese!"
	init_desc = "$THEY $LOOK | morbidly obese, overburdened by a tremendous amount of excess body fat!"
	set_key = "fatness"

/datum/character_snippet/build/extremelyobese
	name = "Extremely Obese"
	desc = "You are extremely obese, carrying an overwhelming amount of excess body fat. Maybe your body's metabolism \
		causes uncontrollable weight gain and makes it nigh-impossible to lose it, maybe you habitually overeat and indulge \
		in fattening foods, maybe you seek to grow ever larger for personal or aesthetic reasons. Either way, you appear to be \
		extremely obese!"
	init_desc = "$THEY $LOOK | extremely obese, carrying an overwhelming amount of excess body fat!"
	set_key = "fatness"

/datum/character_snippet/build/morphable
	name = "Morphable"
	desc = "Your body is morphable, somewhat amorphous, possibly able to change shape and size at will. Maybe you have a \
		gelatinous or malleable body, maybe you are host to some kind of bio-engineered or nanotech enhancements that allow \
		you to alter your form, maybe you are a shapeshifter or have some other kind of supernatural ability. Either way, \
		you appear to have a morphable, amorphous body!"
	init_desc = "$THEY $LOOK | like they have a morphable, amorphous body!"

/datum/character_snippet/build/androgynous
	name = "Androgynous"
	desc = "You have an androgynous appearance, with features that are not distinctly male or female. Maybe your body \
		is naturally androgynous, maybe you have undergone hormone therapy or surgery to achieve a more gender-neutral \
		appearance, maybe you are a non-binary or genderqueer individual who prefers to present in a more androgynous manner. \
		Either way, you appear to have an androgynous appearance!"
	init_desc = "$THEY | present as androgynous!"
	set_key = "genderiality"

/datum/character_snippet/build/masculinepresenting
	name = "Masculine Presenting"
	desc = "You present as masculine, with features and characteristics that are typically associated with masculinity. Maybe \
		you have a more traditionally masculine body shape, maybe you consistently present yourself in a masculine manner, \
		maybe you have undergone hormone therapy or surgery to achieve a more masculine appearance. Either way, you appear \
		to present as masculine!"
	init_desc = "$THEY | present as masculine!"
	set_key = "genderiality"

/datum/character_snippet/build/femininepresenting
	name = "Feminine Presenting"
	desc = "You present as feminine, with features and characteristics that are typically associated with femininity. Maybe \
		you have a more traditionally feminine body shape, maybe you consistently present yourself in a feminine manner, \
		maybe you have undergone hormone therapy or surgery to achieve a more feminine appearance. Either way, you appear \
		to present as feminine!"
	init_desc = "$THEY | present as feminine!"
	set_key = "genderiality"

/datum/character_snippet/build/fluffy
	name = "Fluffy"
	desc = "You are fluffy! Fur, bugfluff, sasquatch hair, whatever - you are covered in the stuff to the point of appearing \
		soft and cuddly. Maybe your species is naturally fluffy, maybe you have an excess of body hair, maybe you have been \
		genetically modified to produce (more) fluff. Either way, you appear to be quite fluffy!"
	init_desc = "$THEY $APPEAR to be | quite fluffy, covered in soft, cuddly fluff!"
	set_key = "fluffiness"

/datum/character_snippet/build/extremelyfluffy
	name = "Extremely Fluffy"
	desc = "You are extremely fluffy! Fur, bugfluff, sasquatch hair, whatever - you are covered in the stuff to the point of \
		comedy, so thick and dense that it is difficult to see your actual body underneath, like a bamboo pillow turned inside out. \
		Maybe your species is naturally extremely fluffy, maybe you have a condition that causes excessive fur growth, maybe you \
		have been genetically modified to produce (more) fluff. Either way, you appear to be extremely fluffy!"
	init_desc = "$THEY $APPEAR to be | VERY fluffy - like - overwhelmingly so."
	set_key = "fluffiness"

/datum/character_snippet/build/jacked
	name = "Jacked"
	desc = "You're jacked. Absolutely ripped. Naturally or from personal effort - the end result is the same. \
		Rippling muscles cover your frame - you likey didn't even skip leg day - heck you likely have muscles \
		in places most people didn't even think you could have muscles."
	init_desc = "$THEY | got muscles for $THEIR muscles."

/datum/character_snippet/build/shortstack
	name = "Shortstack"
	desc = "Your frame is short, and stacked.  With either a combination of heavy - for your frame - breasts, wide hips or a more than average backside. Be thee \
		hourglass in build, some kind of creature, or a daydream of someone who has forgotten modesty one thing remains certain. \
		You are built like a little brick house.  Warning: May or may not come with Bratty by default."
	init_desc = "$THEY $ARE built | short, curvy, and well rounded. Like a strawberry shortcake - or a short... stack..."

/datum/character_snippet/build/buttsum
	name = "Buttsome"
	desc = "You have been blessed with a particularly protruding postierer. A rotundly rambling rump. The better backside. \
		Seats are easy prey for your cheeks, built plush in ways that make wearing tight fitting clothing a bit difficult or uncomfortable. \
		The price was worth it though (probably) because when the infamous 'they' start talking about you then you know they mean it when \
		they say 'baby got back.' "
	init_desc = "$THEY $ARE | pretty caked up - with a more than average backside."
	set_key = "butt_largeness"
	order = 2

/datum/character_snippet/build/extremelybuttsum
	name = "EXTREMELY Buttsome"
	desc = "Your backside is a thing of legends.  In ancient days in human space it was said that those like you would have been the center of primitive cultures sexual practices. \
		The thing hanging off your backside stands prepared in ways that those lesser buttsome companions can not even begin to consider - \
		such as the ability to 'back that ass up' in ways that could be considered a weapon of m-ass destruction."
	init_desc = "$THEIR | rear end is massive, it might be a moon.  It's certainly not a space station."
	set_key = "butt_largeness"
	order = 3

/datum/character_snippet/build/flatchested
	name = "Flat Chested"
	desc = "You have been blessed (or cursed, your choice) with a flat chest. Your cup size is small, and your figure is shaped accordingly. \
		The good news is you don't have to worry about smacking yourself in the face with your breasts when you run. \
		Other upsides include readily available bra sizes, less back pain as you age and - very importantly - a petite silhouette."
	init_desc = "$THEIR | chest is flat, built for high speed tactical operations."
	set_key = "boob_hugeness"
	order = 1

/datum/character_snippet/build/flatassed
	name = "Flat Assed"
	desc = "Your backside is flatter than a washboard.  It likely makes sitting in chairs uncomfortable after a certain \
		amount of time and god knows you throw it back much like a 2x4 would.  On the plus side you can wear the skinniest \
		of skinny jeans without even needing a belt."
	init_desc = "$THEY $APPEAR | pretty flat bottomed."
	set_key = "butt_largeness"
	order = 1
