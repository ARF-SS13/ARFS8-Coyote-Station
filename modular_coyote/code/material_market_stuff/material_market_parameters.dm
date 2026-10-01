/datum/mat_market_params
	var/uses_market_params = TRUE
	var/earliest_available = 0
	/// chance it goes from unavailable to available per tick
	var/chance_become_available = 100
	/// chance it goes from available to unavailable per tick
	var/chance_become_unavailable = 0
	// durations are the minimum time it is guaranteed to stay in that state, after which the chance vars apply again
	/// duration it stays available, min
	var/duration_available_min = 15
	/// duration it stays available, max
	var/duration_available_max = 20
	/// duration it stays unavailable, min
	var/duration_unavailable_min = 1
	/// duration it stays unavailable, max
	var/duration_unavailable_max = 2

	// prices, multipliers on top of the base price, fluctuates each tick
	// high early round, decreases over time and RPI score
	/// min price mult
	var/price_mult_min = 6
	var/price_mult_max = 8

	// quantities
	var/quantity_replenish_min = 5
	var/quantity_replenish_max = 10

	/// okay these modifiers suck
	// RPI modifiers for everything
	/// log base for RPI calc. raw RPI log This = how many bonus points
	var/rpi_log_base = 8
	/// impact of RPI on prices
	/// price = price / RPI^exp
	var/rpi_price_log = 10
	var/rpi_price_exponent = 1.5
	/// impact of RPI on quantity replenish
	/// replenish += replenish * (operand^exponent(rpi) - 1)
	var/rpi_quantity_replenish_exp = 0.3
	var/rpi_quantity_replenish_operand = 2


/datum/mat_market_params/basemat

/// usually available, becomes possible p2 on, somewhat low quantity
/datum/mat_market_params/semiprecious
	earliest_available = 2
	chance_become_available = 50
	chance_become_unavailable = 10
	duration_available_min = 5
	duration_available_max = 10
	duration_unavailable_min = 3
	duration_unavailable_max = 5
	quantity_replenish_min = 5
	quantity_replenish_max = 7
	rpi_log_base = 9
	rpi_price_exponent = 0.2
	rpi_quantity_replenish_exp = 0.2
	rpi_quantity_replenish_operand = 2

/datum/mat_market_params/precious
	earliest_available = 3
	chance_become_available = 40
	chance_become_unavailable = 15
	duration_available_min = 5
	duration_available_max = 10
	duration_unavailable_min = 3
	duration_unavailable_max = 5
	quantity_replenish_min = 3
	quantity_replenish_max = 5
	rpi_log_base = 10
	rpi_quantity_replenish_exp = 0.15
	rpi_quantity_replenish_operand = 1.5

/datum/mat_market_params/bluespace
	earliest_available = 2
	chance_become_available = 20
	chance_become_unavailable = 20
	duration_available_min = 2
	duration_available_max = 5
	duration_unavailable_min = 3
	duration_unavailable_max = 10
	quantity_replenish_min = 1
	quantity_replenish_max = 3
	rpi_log_base = 6
	rpi_price_exponent = 0.2
	rpi_quantity_replenish_exp = 0.7
	rpi_quantity_replenish_operand = 1.1

/datum/mat_market_params/diamonds
	earliest_available = 1
	chance_become_available = 10
	chance_become_unavailable = 45
	duration_available_min = 20
	duration_available_max = 25
	duration_unavailable_min = 20
	duration_unavailable_max = 25
	quantity_replenish_min = 2
	quantity_replenish_max = 4
	rpi_log_base = 9
	rpi_price_exponent = 0.2
	rpi_quantity_replenish_exp = 0.7
	rpi_quantity_replenish_operand = 1.1

/datum/mat_market_params/default
	uses_market_params = FALSE

