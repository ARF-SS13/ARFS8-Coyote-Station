/// The maximum number of stacks you can place in 1 order
#define MAX_STACK_LIMIT 20
/// The order rank for all galactic material market orders
#define GALATIC_MATERIAL_ORDER "Galactic Materials Market"

/obj/machinery/materials_market
	name = "galactic materials market"
	desc = "This machine allows the user to buy and sell sheets of minerals \
		across the system. Prices are known to fluxuate quite often,\
		sometimes even within the same minute. All transactions are final."
	circuit = /obj/item/circuitboard/machine/materials_market
	density = TRUE
	icon = 'icons/obj/economy.dmi'
	icon_state = "mat_market"
	base_icon_state = "mat_market"
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION
	light_power = 3
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	/// Are we ordering sheets from our own card balance or the cargo budget?
	var/ordering_private = TRUE

/obj/machinery/materials_market/update_icon_state()
	if(panel_open)
		icon_state = "[base_icon_state]_open"
		return ..()
	if(!is_operational || !anchored)
		icon_state = "[base_icon_state]_off"
		return ..()
	icon_state = "[base_icon_state]"
	return ..()

/obj/machinery/materials_market/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool, time = 1.5 SECONDS) == SUCCESSFUL_UNFASTEN)
		return ITEM_INTERACT_SUCCESS

/obj/machinery/materials_market/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_deconstruction_screwdriver(user, "[base_icon_state]_open", "[base_icon_state]", tool))
		return ITEM_INTERACT_SUCCESS

/obj/machinery/materials_market/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_deconstruction_crowbar(tool))
		return ITEM_INTERACT_SUCCESS

/obj/machinery/materials_market/item_interaction(mob/living/user, obj/item/thingy, list/modifiers)
	. = NONE
	if(istype(thingy, /obj/item/card/id))
		src.attack_hand(user, modifiers) // open them the window
		return ITEM_INTERACT_SUCCESS

	// if(!isstack(exportable))
	// 	return

	// BUBBER EDIT ADDITION BEGIN - GMM can't sell materials
	// balloon_alert(user, "export not available!")
	// return ITEM_INTERACT_FAILURE
	// BUBBER EDIT ADDITION END - GMM can't sell materials

	// BUBBER EDIT REMOVAL BEGIN - GMM can't sell materials
	/*
	if(!is_operational)
		balloon_alert(user, "no power!")
		return ITEM_INTERACT_FAILURE

	var/list/datum/material/materials = exportable.custom_materials
	if(materials.len != 1)
		balloon_alert(user, "alloy stacks not allowed")
		return ITEM_INTERACT_FAILURE

	var/price = SSstock_market.materials_prices[materials[1].type]
	if(!price)
		balloon_alert(user, "materials in stack are worthless")
		return ITEM_INTERACT_FAILURE

	if(!user.transferItemToLoc(exportable, src))
		to_chat(user, span_warning("[exportable] is stuck in hand!"))
		return ITEM_INTERACT_FAILURE

	var/obj/item/stock_block/new_block = new /obj/item/stock_block(drop_location())
	new_block.export_value = price
	new_block.set_custom_materials(materials)
	to_chat(user, span_notice("You have created a stock block worth [new_block.export_value * exportable.amount] [MONEY_SYMBOL]! Sell it before it becomes liquid!"))
	playsound(src, 'sound/machines/synth/synth_yes.ogg', 50, FALSE)
	qdel(exportable)
	use_energy(active_power_usage)
	return ITEM_INTERACT_SUCCESS
	*/
	// BUBBER EDIT REMOVAL END - GMM can't sell materials

/obj/machinery/materials_market/power_change()
	. = ..()
	if(!is_operational)
		set_light(0, 0)
	else
		set_light(initial(light_range), initial(light_power))

/**
 * Find the order purchased either privately or by cargo budget
 * Arguments
 * * [user][mob] - the user who placed this order
 * * is_ordering_private - is the player ordering privatly. If FALSE it means they are using cargo budget
 */
/obj/machinery/materials_market/proc/find_order(mob/user, is_ordering_private)
	for(var/datum/supply_order/order in SSshuttle.shopping_list)
		// Must be a Galactic Materials Market order and payed by the null account(if ordered via cargo budget) or by correct user for private purchase
		if(order.orderer_rank == GALATIC_MATERIAL_ORDER && ( \
			(!is_ordering_private) || \
			(is_ordering_private && !isnull(order.paying_account) && order.orderer == user) \
		))
			return order
	return null

/obj/machinery/materials_market/proc/get_accessible_budget(mob/living/user)
	// ok so like, gotta determine if its personal account, or department account
	// and then like uh, figure out which one to use for budget stuff
	. = list(
		"card" = null, // null if we didnt find anything
		"is_personal" = null,
		"account" = SSeconomy.get_dep_account(ACCOUNT_CAR), // null if personal
		"department" = ACCOUNT_CAR,
		"has_access" = FALSE,
	)
	if(!isliving(user))
		return .
	// so we're looking for which budget to display and pull from!
	var/obj/item/card/id/my_card = user.get_active_held_item()
	// we're gonna want to prefer the card in hand over other cards, if there is one
	if(!istype(my_card, /obj/item/card/id))
		my_card = user.get_inactive_held_item()
		if(!istype(my_card, /obj/item/card/id))
			my_card = user.get_idcard(TRUE)
			if(!istype(my_card, /obj/item/card/id))
				return . // okay they dont have an id card, neat! default to cargo budget. no access tho
	// ok we have a card now
	if(!my_card.registered_account)
		return . // no account, default to cargo budget... if you dare. also no access
	.["card"] = my_card
	if(ordering_private)
		.["account"] = my_card.registered_account
		.["department"] = null
		.["is_personal"] = TRUE
		.["has_access"] = TRUE // its my account
		return . // good enough!
	var/datum/job/card_job = my_card.registered_account.account_job
	if(!card_job)
		return . // get a job you bum! (or order it with ur own cash, sorry for calling you a bum, you're fine)
	var/datum/bank_account/dep = SSeconomy.get_dep_account(card_job.paycheck_department)
	if(!dep)
		.["has_access"] = (ACCESS_CARGO in my_card.GetAccess())
		return . // cargo it is!
	.["account"] = dep // found one!
	.["department"] = card_job.paycheck_department
	// now do they have access to the dept bgdt?
	var/has_access = FALSE
	if(istype(my_card, /obj/item/card/id/departmental_budget))
		.["has_access"] = TRUE // its a department card, course it has acces
		return .
	var/list/accesses = my_card.GetAccess()
	var/list/needed = list()
	switch(card_job.paycheck_department)
		if(ACCOUNT_CIV)
			needed = list(ACCESS_MAINT_TUNNELS) // tunnel snakes rule
		if(ACCOUNT_CAR)
			needed = list(ACCESS_CARGO)
		if(ACCOUNT_MED)
			needed = list(ACCESS_BUDGET,ACCESS_MEDICAL)
		if(ACCOUNT_SEC)
			needed = list(ACCESS_BUDGET,ACCESS_SECURITY)
		if(ACCOUNT_ENG)
			needed = list(ACCESS_BUDGET,ACCESS_ENGINEERING)
		if(ACCOUNT_SCI)
			needed = list(ACCESS_BUDGET,ACCESS_SCIENCE)
		if(ACCOUNT_SRV)
			needed = list(ACCESS_BUDGET,ACCESS_SERVICE)
		if(ACCOUNT_CMD)
			needed = list(ACCESS_BUDGET,ACCESS_COMMAND)
		else
			has_access = TRUE // other stuff, they can mess with it
	.["has_access"] = TRUE
	if(has_access)
		return . // yay!
	for(var/need in needed)
		if(!(need in accesses))
			.["has_access"] = FALSE
			break
	return .

/obj/machinery/materials_market/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!anchored)
		return
	if(!ui)
		ui = new(user, src, "MatMarket", name)
		ui.open()

/obj/machinery/materials_market/ui_static_data(mob/user)
	. = list()
	.["CARGO_CRATE_VALUE"] = CARGO_CRATE_VALUE

/obj/machinery/materials_market/ui_data(mob/user)
	. = list()

	var/list/budget_data = get_accessible_budget(user)

	//if no cargo access then force private purchase
	// var/obj/item/card/id/used_id_card = budget_data["card"]
	var/datum/bank_account/acc = budget_data["account"]
	var/ordering_department = budget_data["department"]
	var/has_access = budget_data["has_access"]
	var/is_ordering_private = budget_data["is_personal"] || !ordering_department

	//find current order based on ordering mode & player
	var/datum/supply_order/current_order = find_order(user, budget_data)

	var/material_data
	var/fancy_material_data
	var/trend_string
	var/color_string
	var/sheet_to_buy
	var/requested_amount
	var/minimum_value_threshold = 0
	var/elastic_mult = 1
	for(var/datum/material/traded_mat as anything in SSstock_market.market_datums)
		var/datum/stock_market_material/market = SSstock_market.get_market_datum(traded_mat)
		if(!market.available && !market.always_visible)
			continue // skiiiip
		//convert trend into text
		switch(market.trend)
			if(0)
				trend_string = "neutral"
			if(1)
				trend_string = "up"
			else
				trend_string = "down"

		//get mat color
		var/initial_colors = initial(traded_mat.greyscale_color) || initial(traded_mat.color)
		if(initial_colors)
			color_string = splicetext(initial_colors, 7, length(initial_colors), "") //slice it to a standard 6 char hex
		else
			initial_colors = initial(traded_mat.color)
			if(initial_colors)
				color_string = initial_colors
			else
				color_string = COLOR_CYAN

		//get sheet type from material
		sheet_to_buy = initial(traded_mat.sheet_type)
		if(!sheet_to_buy)
			CRASH("Material with no sheet type being sold on materials market!")

		//get the ordered amount from the order
		requested_amount = 0
		if(!isnull(current_order))
			requested_amount = current_order.pack.contains[sheet_to_buy]

		var/min_value_override = initial(traded_mat.minimum_value_override)
		if(min_value_override)
			minimum_value_threshold = min_value_override
		else
			minimum_value_threshold = round(initial(traded_mat.value_per_unit) * SHEET_MATERIAL_AMOUNT * 0.5)

		//Pulling elastic modifier into data.
		for(var/datum/export/material/market/export_est in GLOB.exports_list)
			if(export_est.material_id == traded_mat)
				elastic_mult = export_est.k_elasticity * 100

		var/fancy = market.fancy_weight > 0
		var/descript = SSmaterials.get_description_for(traded_mat) || "Some kind of material for some kind of use. May or may not have some kind of properties."

		var/datas = list(list(
			"name" = initial(traded_mat.name) || "Hypogen",
			"desc" = descript,
			"visible" = market.available || market.always_visible,
			"available" = market.available,
			"price" = market.current_price,
			"rarity" = initial(traded_mat.value_per_unit),
			"threshold" = minimum_value_threshold,
			"quantity" = market.current_quantity,
			"trend" = trend_string,
			"color" = color_string,
			"requested" = requested_amount,
			"elastic" = elastic_mult,
			))
		if(fancy)
			fancy_material_data += datas
		else
			material_data += datas

	//get account balance
	var/balance = 0
	if(!acc) // fallback if no dep account
		acc = SSeconomy.get_dep_account(ACCOUNT_CAR)
	balance = acc?.account_balance || 0

	// if(!is_ordering_private)
	// 	var/datum/bank_account/dept = SSeconomy.get_dep_account(ACCOUNT_CAR)
	// 	if(dept)
	// 		balance = dept.account_balance
	// else
	// 	balance = used_id_card?.registered_account?.account_balance

	//is market crashing
	var/market_crashing = FALSE
	if(HAS_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING))
		market_crashing = TRUE

	//get final order cost
	var/current_cost = 0
	if(!isnull(current_order))
		current_cost = current_order.get_final_cost()

	//pack data
	.["catastrophe"] = market_crashing
	.["materials"] = material_data || list()
	.["fancyMaterials"] = fancy_material_data || list()
	.["creditBalance"] = balance
	.["orderBalance"] = current_cost
	.["isPrivateOrder"] = is_ordering_private
	.["canOrderCargo"] = has_access
	.["whichBudgetName"] = acc ? acc.account_holder : "Dan McNealy"
	.["whichBudgetKey"] = ordering_department || "NOBODY!!!"
	.["updateTime"] = SSstock_market.next_fire - world.time

/obj/machinery/materials_market/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	//You must have an ID to be able to do something
	var/mob/living/living_user = ui.user
	var/list/budget_data = get_accessible_budget(living_user)
	var/obj/item/card/id/used_id_card = budget_data["card"]
	var/datum/bank_account/account_payable = budget_data["account"]
	var/ordering_department = budget_data["department"]
	var/has_access = budget_data["has_access"]
	var/is_ordering_private = budget_data["is_personal"] || !ordering_department || !has_access

	if(!used_id_card || !account_payable)
		say("No ID or account!")
		return

	switch(action)
		if("buy")
			var/material_str = params["material"]
			var/quantity = text2num(params["quantity"])

			//find material from its name
			var/datum/material/material_bought
			var/obj/item/stack/sheet/sheet_to_buy
			for(var/datum/material/mat as anything in SSstock_market.market_datums)
				if(initial(mat.name) == material_str)
					material_bought = mat
					break
			if(!material_bought)
				say("Invalid material! ERROR CODE: BIG-FAT-EXPIE")
				CRASH("Invalid material name passed to materials market!")
			sheet_to_buy = initial(material_bought.sheet_type)
			if(!sheet_to_buy)
				say("No sheet for this material! ERROR CODE: TUBBY-MILKY")
				CRASH("Material with no sheet type being sold on materials market!")

			var/datum/stock_market_material/market = SSstock_market.get_market_datum(material_bought)
			//sanity checks for available quantity & budget
			if(quantity > market.current_quantity)
				quantity = market.current_quantity
				if(quantity <= 0)
					say("Not enough materials on the market to purchase!")
					return

			var/cost = market.current_price * quantity

			var/list/things_to_order = list()
			things_to_order[sheet_to_buy] = quantity

			// We want to count how many stacks of all sheets we're ordering to make sure they don't exceed the limit of 20
			// If we already have a custom order on SSshuttle, we should add the things to order to that order
			var/datum/supply_order/current_order = find_order(living_user, is_ordering_private)
			if(!isnull(current_order))
				// Check if this order exceeded the market limit
				var/prior_sheets = current_order.pack.contains[sheet_to_buy]
				if(prior_sheets + quantity > market.current_quantity)
					say("There aren't enough sheets on the market! Please wait for more sheets to be traded before adding more.")
					playsound(living_user, 'sound/machines/synth/synth_no.ogg', 35, FALSE)
					return

				// Check if the order exceeded the purchase limit
				var/prior_stacks = ROUND_UP(prior_sheets / MAX_STACK_SIZE)
				if(prior_stacks >= MAX_STACK_LIMIT)
					say("There are already 20 stacks of sheets on order! Please wait for them to arrive before ordering more.")
					playsound(living_user, 'sound/machines/synth/synth_no.ogg', 35, FALSE)
					return

				// Prevents you from ordering more than the available budget
				var/datum/bank_account/paying_account = account_payable
				if(!isnull(current_order.paying_account)) //order is already being paid by another account
					paying_account = current_order.paying_account
				if(current_order.get_final_cost() + cost > paying_account.account_balance)
					say("Order exceeds available budget! Please send it before purchasing more.")
					return

				// Finally Append to this order
				current_order.append_order(things_to_order, cost)
				return TRUE


			//Place a new order
			var/datum/supply_pack/custom/minerals/mineral_pack = new(
				purchaser = is_ordering_private ? living_user : "[living_user] ([account_payable.account_holder || "Dan McNealy"])", \
				cost = cost, \
				contains = things_to_order, \
			)
			var/datum/supply_order/disposable/materials/new_order = new(
				pack = mineral_pack,
				orderer = living_user,
				orderer_rank = GALATIC_MATERIAL_ORDER,
				orderer_ckey = living_user.ckey,
				paying_account = account_payable,
				cost_type = MONEY_SYMBOL,
				can_be_cancelled = FALSE
			)
			//first time order compute the correct cost and compare
			if(new_order.get_final_cost() > account_payable.account_balance)
				say("Not enough money to start purchase! Come back when you're a little richer!")
				qdel(new_order)
				return

			say("Thank you for your purchase! It will arrive on the next cargo shuttle!")
			SSshuttle.shopping_list += new_order
			return TRUE

		if("toggle_budget")
			if(!has_access)
				ordering_private = TRUE
				return
			ordering_private = !ordering_private
			return TRUE

		if("clear")
			var/datum/supply_order/current_order = find_order(living_user, is_ordering_private)
			if(!isnull(current_order))
				SSshuttle.shopping_list -= current_order
				qdel(current_order)
				say("Order deleted!")
				return TRUE

/obj/item/stock_block
	name = "stock block"
	desc = "A block of stock. It's worth a certain amount of money, based on a sale on the materials market. Ship it on the cargo shuttle to claim your money."
	icon = 'icons/obj/economy.dmi'
	icon_state = "stock_block"
	/// How many credits was this worth when created?
	var/export_value = 0
	/// Is this stock block currently updating its value with the market (aka fluid)?
	var/fluid = FALSE

/obj/item/stock_block/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(value_warning)), 1.5 MINUTES, TIMER_DELETE_ME)
	addtimer(CALLBACK(src, PROC_REF(update_value)), 3 MINUTES, TIMER_DELETE_ME)

/obj/item/stock_block/examine(mob/user)
	. = ..()

	var/datum/material/export_mat = custom_materials[1]
	var/quantity = custom_materials[export_mat] / SHEET_MATERIAL_AMOUNT
	. += span_notice("\The [src] is worth [quantity * export_value] [MONEY_SYMBOL], from selling [quantity] sheets of [export_mat.name].")

	if(fluid)
		. += span_warning("\The [src] is currently liquid! Its value is based on the market price.")
	else
		. += span_notice("\The [src]'s value is still [span_boldnotice("locked in")]. [span_boldnotice("Sell it")] before its value becomes liquid!")

/obj/item/stock_block/proc/value_warning()
	visible_message(span_warning("\The [src] is starting to become liquid!"))
	icon_state = "stock_block_fluid"
	update_appearance(UPDATE_ICON_STATE)

/obj/item/stock_block/proc/update_value()
	var/datum/stock_market_material/market = SSstock_market.get_market_datum(custom_materials[1])
	export_value = market.current_price
	icon_state = "stock_block_liquid"
	update_appearance(UPDATE_ICON_STATE)
	visible_message(span_warning("\The [src] becomes liquid! Not literally of course!"))
	fluid = TRUE

#undef MAX_STACK_LIMIT
#undef GALATIC_MATERIAL_ORDER
