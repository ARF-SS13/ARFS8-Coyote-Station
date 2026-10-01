
SUBSYSTEM_DEF(stock_market)
	name = "Stock Market"
	wait = 60 SECONDS
	runlevels = RUNLEVEL_GAME

	/// Associated list of market datums for each material.
	var/list/market_datums = list()
	/// max multiplier for max price
	var/price_max_mult = 5
	/// min multiplier for min price
	var/price_min_mult = 2
	/// max mult for quantity
	var/quantity_max_mult = 5
	/// min mult for quantity
	var/quantity_min_mult = 0.2
	/// max number of fancy items at once
	var/max_fancy = 4
	var/new_fancy_chance = 50

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
	// for(var/datum/material/market as anything in market_datums)
	// 	handle_trends_and_price(market)
	update_market()
	// for(var/datum/stock_market_event/event as anything in active_events)
	// 	event.handle()

/datum/controller/subsystem/stock_market/proc/get_market_datum(datum/material/mat)
	if(istype(mat))
		mat = mat.type
	return market_datums[mat]

/datum/controller/subsystem/stock_market/proc/get_material_price(datum/material/mat, selling)
	var/datum/stock_market_material/market = get_market_datum(mat)
	if(!market) // ok its not in our thing, just give em the base value per
		return mat.value_per_unit * SHEET_MATERIAL_AMOUNT
	return market.get_price(selling)

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
	// var/decrease_by = market.current_price * (sheets / (sheets + market.current_quantity))
	// //decrease the market price
	// SSstock_market.adjust_material_price(mat, -decrease_by)
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
	var/datum/stock_market_material/matdat = get_market_datum(mat)
	if(event.start_event(matdat))
		active_events += event
	else
		qdel(event)

/datum/controller/subsystem/stock_market/proc/update_fancy()
	var/list/fancy_mats = list()
	var/list/current_fancy = list()
	for(var/matkey in market_datums)
		var/datum/stock_market_material/matdat = get_market_datum(matkey)
		if(!matdat.fancy_weight)
			continue
		if(!matdat.mat::sheet_type)
			continue
		if(matdat.fancy_life > 0)
			current_fancy += matdat
		else
			fancy_mats[matdat] = matdat.fancy_weight // gonna be a pickweight!
	// first, tick and cleanup current fancy
	for(var/datum/stock_market_material/fancydat in current_fancy)
		if(!fancydat.tick_fancy())
			fancydat.end_fancy()
			current_fancy -= fancydat

	// try to add more fancies
	if(prob(new_fancy_chance)) // try to add a new fancy
		var/datum/stock_market_material/fan = pick_weight(fancy_mats)
		if(fan)
			fan.start_fancy()


/*
 * Does most of the heavy lifting and math and such
 * Adjusts prices and quantities for all (base) materials based on chance, RPI, and round phase
 *  */
/datum/controller/subsystem/stock_market/proc/update_market()
	var/roundphase = get_round_phase()
	var/rpi_score = SSrpi.GetMatMarketScalar()
	var/rpimaxeff = 10
	var/rpi_eff = rpi_score/rpimaxeff
	var/pricemult = LERP(price_max_mult, price_min_mult, rpi_eff)

	for(var/matkey in market_datums)
		var/datum/stock_market_material/matdat = get_market_datum(matkey)
		var/datum/mat_market_params/params = matdat.params
		if(!params || !params.uses_market_params)
			continue
		var/replenish = rand(params.quantity_replenish_min, params.quantity_replenish_max)
		matdat.price_mult = pricemult // some kind of sine nonesnee
		replenish += rpi_score
		matdat.adjust_current_quantity(replenish)
		if(roundphase < params.earliest_available)
			matdat.available = FALSE
		else
			matdat.available = TRUE
			// if(matdat.available)
			// 	if(matdat.avail_lock_ticks_left > 0)
			// 		matdat.avail_lock_ticks_left--
			// 	else if(prob(params.chance_become_unavailable))
			// 		matdat.available = FALSE
			// 		matdat.avail_lock_ticks_left = rand(params.duration_unavailable_min, params.duration_unavailable_max)
			// else
			// 	if(matdat.avail_lock_ticks_left > 0)
			// 		matdat.avail_lock_ticks_left--
			// 	else if(prob(params.chance_become_available))
			// 		matdat.available = TRUE
			// 		matdat.avail_lock_ticks_left = rand(params.duration_available_min, params.duration_available_max)

/datum/stock_market_material
	var/always_visible = FALSE
	var/available = TRUE
	var/avail_lock_ticks_left = 0
	var/datum/material/mat
	var/datum/mat_market_params/params

	var/price_mult = 1

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
	price_mult = SSstock_market.price_max_mult
	params = mat.smmp
	if(ispath(params))
		params = new params()
	if(!isnull(mat.minimum_value_override))
		minimum_price = mat.minimum_value_override
	else
		minimum_price = ceil(initial_price * SSstock_market.price_min_mult)
	if(minimum_price == 0) // hey turns out you cant multiply 0 and get anything other than 0
		minimum_price = ceil(initial_price * SSstock_market.price_min_mult)
	maximum_price = ceil(initial_price * SSstock_market.price_max_mult)
	initial_quantity = mat.tradable_base_quantity
	minimum_quantity = ceil(initial_quantity * SSstock_market.quantity_min_mult)
	maximum_quantity = ceil(initial_quantity * SSstock_market.quantity_max_mult)
	current_quantity = minimum_quantity
	trend = rand(MARKET_TREND_DOWNWARD,MARKET_TREND_UPWARD)
	trend_life = rand(1,3)
	var/adj_mult = rand(-500, 500) / 1000
	fancy_weight = mat.tradable_fancy ? ceil(mat.tradable_fancy * (1 - adj_mult)) : 0
	if(fancy_weight)
		available = FALSE
	if(mat.tradable && !fancy_weight)
		always_visible = TRUE

/datum/stock_market_material/proc/get_price(selling)
	if(selling)
		return round(current_price)
	return round(current_price * price_mult)

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

