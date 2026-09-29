
SUBSYSTEM_DEF(stock_market)
	name = "Stock Market"
	wait = 60 SECONDS
	runlevels = RUNLEVEL_GAME

	/// Associated list of market datums for each material.
	var/list/market_datums = list()
	/// max multiplier for max price
	var/price_max_mult = 10
	/// min multiplier for min price
	var/price_min_mult = 0.9
	/// max mult for quantity
	var/quantity_max_mult = 2
	/// min mult for quantity
	var/quantity_min_mult = 0.2
	/// max number of fancy items at once
	var/curr_fancy = 0
	var/max_fancy = 3
	var/min_fancy = 1
	var/ticks_to_update_fancy_count = 5
	var/curr_fancy_ticks = 0

	// a bunch of lists
	/// A list of all currently active stock market events.
	var/list/active_events = list()
	/// HTML string that is used to display the market events to the player.
	var/news_string = ""

/datum/controller/subsystem/stock_market/Initialize()
	for(var/datum/material/possible_market as anything in subtypesof(/datum/material)) // I need to make this work like this, but lets hardcode it for now
		if(possible_market.tradable || possible_market.tradable_fancy)
			market_datums[possible_market] = new /datum/stock_market_material(possible_market)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/stock_market/fire(resumed)
	update_fancy()
	for(var/datum/material/market as anything in market_datums)
		handle_trends_and_price(market)
	update_fancy()
	for(var/datum/stock_market_event/event as anything in active_events)
		event.handle()

/datum/controller/subsystem/stock_market/proc/get_market_datum(datum/material/mat)
	if(istype(mat))
		mat = mat.type
	return market_datums[mat]

/datum/controller/subsystem/stock_market/proc/get_material_price(datum/material/mat)
	var/datum/stock_market_material/market = get_market_datum(mat)
	if(!market) // ok its not in our thing, just give em the base value per
		return mat.value_per_unit * SHEET_MATERIAL_AMOUNT
	return market.current_price

///Adjust the price of a material(either through buying or selling) ensuring it stays within limits
/datum/controller/subsystem/stock_market/proc/adjust_material_price(datum/material/mat, delta)
	mat = GET_MATERIAL_REF(mat)
	var/datum/stock_market_material/market = get_market_datum(mat)
	if(!market)
		return
	market.adjust_current_price(delta)

/datum/controller/subsystem/stock_market/proc/adjust_material_price_by_fraction(datum/material/mat, fraction)
	var/datum/stock_market_material/market = get_market_datum(mat)
	if(!market)
		return
	market.adjust_current_price(market.current_price * fraction)
	return market.current_price

/datum/controller/subsystem/stock_market/proc/on_sell(datum/material/mat, sheets)
	var/datum/stock_market_material/market = get_market_datum(mat)
	if(!market)
		return
	var/decrease_by = market.current_price * (sheets / (sheets + market.current_quantity))
	//decrease the market price
	SSstock_market.adjust_material_price(mat, -decrease_by)
	//increase the stock
	SSstock_market.adjust_material_quantity(mat, sheets)

///Adjust the amount of material(either through buying or selling) ensuring it stays within limits
/datum/controller/subsystem/stock_market/proc/adjust_material_quantity(datum/material/mat, delta)
	mat = GET_MATERIAL_REF(mat)
	var/datum/stock_market_material/market = get_market_datum(mat)
	if(!market)
		return
	market.adjust_current_quantity(delta)

/**
 * Handles shifts in the cost of materials, and in what direction the material is most likely to move.
 */
/datum/controller/subsystem/stock_market/proc/handle_trends_and_price(datum/material/mat)
	if(prob(MARKET_EVENT_PROBABILITY))
		handle_market_event(mat)
	var/datum/stock_market_material/market = get_market_datum(mat)

	if(HAS_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING)) //We hardset to the worst possible price and lowest possible impact if sold
		market.set_price_to_min()
		market.set_quantity_to_max()
		market.set_trend(MARKET_TREND_DOWNWARD)
		market.set_trend(1)
		return

	if(!market.tick_trend())
		///We want to scale our trend so that if we're closer to our minimum or maximum price, we're more likely to trend the other way.
		var/direction = MARKET_TREND_STABLE
		if((market.current_price < market.initial_price))
			var/chance_swap = 100 - ((clamp((market.current_price - market.minimum_price), 1, 1000) / (market.initial_price - market.minimum_price))*100)
			if(prob(chance_swap))
				direction = MARKET_TREND_UPWARD
			else
				direction = MARKET_TREND_STABLE
		else if((market.current_price > market.initial_price))
			var/chance_swap = 100 - ((clamp((market.current_price - market.maximum_price), 1, 1000) / (market.maximum_price - market.initial_price))*100)
			if(prob(chance_swap))
				direction = MARKET_TREND_DOWNWARD
			else
				direction = MARKET_TREND_STABLE
		market.reset_trend(direction)

	var/price_base_mult = 1
	var/price_sd_mult = 1
	var/quantity_base_mult = 0
	var/quantity_sd_mult = 0
	var/sign = 1
	switch(market.trend)
		if(MARKET_TREND_UPWARD)
			sign = 1
			price_base_mult = 0.30
			price_sd_mult = 0.15
			quantity_base_mult = 0.15
			quantity_sd_mult = 0.15
		if(MARKET_TREND_STABLE)
			price_base_mult = 0
			price_sd_mult = 0.01
			quantity_base_mult = 0
			quantity_sd_mult = 0.01
			sign = pick(1,-1)
		if(MARKET_TREND_DOWNWARD)
			sign = -1
			price_base_mult = 0.3
			price_sd_mult = 0.15
			quantity_base_mult = 0.15
			quantity_sd_mult = 0.15

	market.adjust_current_price_gaussian(price_base_mult, price_sd_mult, sign)
	market.adjust_current_quantity_gaussian(quantity_base_mult, quantity_sd_mult, sign)

/**
 * Market events are a way to spice up the market and make it more interesting.
 * Randomly one will occur to a random material, and it will change the price of that material more drastically, or reset it to a stable price.
 * Events are also broadcast to the newscaster as a fun little fluff piece. Good way to tell some lore as well, or just make a joke.
 */
/datum/controller/subsystem/stock_market/proc/handle_market_event(datum/material/mat)
	var/datum/stock_market_event/event = pick(subtypesof(/datum/stock_market_event))
	event = new event
	if(event.start_event(mat))
		active_events += event

/datum/controller/subsystem/stock_market/proc/update_fancy()
	var/list/fancy_mats = list()
	var/list/current_fancy = list()
	for(var/matkey in market_datums)
		var/datum/stock_market_material/matdat = get_market_datum(matkey)
		if(!matdat.fancy_weight)
			continue
		fancy_mats[matdat] = matdat.fancy_weight // gonna be a pickweight!
		if(matdat.fancy_life > 0)
			current_fancy += matdat
	// first, tick and cleanup current fancy
	for(var/datum/stock_market_material/fancydat in current_fancy)
		if(!fancydat.tick_fancy())
			fancydat.start_fancy()
			current_fancy -= fancydat

	if(curr_fancy_ticks >= ticks_to_update_fancy_count)
		curr_fancy_ticks = 0
		curr_fancy = rand(min_fancy, max_fancy)
	else
		curr_fancy_ticks++
	if(LAZYLEN(current_fancy) < curr_fancy) // need more fancy, but dont remove fancy if too much already
		var/needed = curr_fancy - LAZYLEN(current_fancy)
		for(var/fansy in 1 to needed)
			if(!LAZYLEN(fancy_mats))
				break
			var/datum/stock_market_material/fan = pick_weight_remove(fancy_mats)
			if(!fan)
				break
			fan.end_fancy()


/datum/stock_market_material
	var/always_visible = FALSE
	var/available = TRUE
	var/datum/material/mat
	var/initial_price = 0
	var/current_price = 0
	var/minimum_price = 0
	var/maximum_price = 0
	var/initial_quantity = 0
	var/current_quantity = 0
	var/minimum_quantity = 0
	var/maximum_quantity = 0
	var/trend = 0
	var/trend_life = 0
	var/fancy_weight = 0
	var/fancy_life = 0

/datum/stock_market_material/New(datum/material/good)
	mat = good
	initial_price = mat.value_per_unit * SHEET_MATERIAL_AMOUNT
	current_price = initial_price
	if(!isnull(mat.minimum_value_override))
		minimum_price = mat.minimum_value_override
	else
		minimum_price = ceil(initial_price * SSstock_market.price_min_mult)
	if(minimum_price == 0) // hey turns out you cant multiply 0 and get anything other than 0
		minimum_price = ceil(initial_price * SSstock_market.price_min_mult)
	maximum_price = ceil(initial_price * SSstock_market.price_max_mult)
	initial_quantity = mat.tradable_base_quantity
	current_quantity = initial_quantity
	minimum_quantity = ceil(initial_quantity * SSstock_market.quantity_min_mult)
	maximum_quantity = ceil(initial_quantity * SSstock_market.quantity_max_mult)
	trend = rand(MARKET_TREND_DOWNWARD,MARKET_TREND_UPWARD)
	trend_life = rand(1,3)
	var/adj_mult = rand(-500, 500) / 1000
	fancy_weight = mat.tradable_fancy ? ceil(mat.tradable_fancy * (1 - adj_mult)) : 0
	if(fancy_weight)
		available = FALSE
	if(mat.tradable && !fancy_weight)
		always_visible = TRUE

/// pricery
/datum/stock_market_material/proc/adjust_current_price(amount, sheetify)
	if(sheetify)
		amount = ceil(amount * SHEET_MATERIAL_AMOUNT)
	current_price = clamp(current_price + amount, minimum_price, maximum_price)
	current_price = ceil(current_price)
	return current_price

/datum/stock_market_material/proc/adjust_current_price_gaussian(price_mult, price_sd_mult, sign)
	var/mean = current_price * price_mult
	var/sd = current_price * price_sd_mult
	var/guss = gaussian(mean, sd)
	if(guss < 1)
		guss = 1
	return adjust_current_price(ceil(guss) * sign)

/datum/stock_market_material/proc/set_price_to_max()
	current_price = maximum_price
	return current_price

/datum/stock_market_material/proc/set_price_to_min()
	current_price = minimum_price
	return current_price

/datum/stock_market_material/proc/reset_price()
	current_price = initial_price
	return current_price

/// quantityity

/datum/stock_market_material/proc/adjust_current_quantity_gaussian(base_mult, sd_mult, sign)
	var/mean = current_quantity * base_mult
	var/sd = current_quantity * sd_mult
	return adjust_current_quantity(ceil(gaussian(mean, sd)) * sign)

/datum/stock_market_material/proc/adjust_current_quantity(amount)
	current_quantity = clamp(current_quantity + amount, minimum_quantity, maximum_quantity)
	current_quantity = ceil(current_quantity)
	return current_quantity

/datum/stock_market_material/proc/reset_quantity()
	current_quantity = initial_quantity
	return current_quantity

/datum/stock_market_material/proc/set_quantity_to_max()
	current_quantity = maximum_quantity
	return current_quantity

/datum/stock_market_material/proc/set_quantity_to_min()
	current_quantity = minimum_quantity
	return current_quantity

/// trendity
/datum/stock_market_material/proc/set_trend(val)
	trend = val
	return trend

/datum/stock_market_material/proc/reset_trend(direction)
	trend = direction
	trend_life = rand(1,3) + 1
	return trend_life

/datum/stock_market_material/proc/tick_trend()
	trend_life = max(0, trend_life - 1)
	return trend_life

/// availability
/datum/stock_market_material/proc/set_available(val)
	available = val
	return available

/// fancyity
/datum/stock_market_material/proc/tick_fancy()
	fancy_life = max(0, fancy_life - 1)
	return fancy_life

/datum/stock_market_material/proc/start_fancy()
	fancy_life = rand(1,5)
	set_available(TRUE)
	return fancy_life

/datum/stock_market_material/proc/end_fancy()
	fancy_life = 0
	set_available(FALSE)
	return fancy_life

