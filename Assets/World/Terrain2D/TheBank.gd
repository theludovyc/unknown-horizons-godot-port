extends Node
class_name TheBank

const money_icon = preload("res://Assets/UI/Icons/Resources/32/001.png")

@onready var event_bus := $"../EventBus"

@onready var the_market := $"../TheMarket"

var money := 0 :
	set(value):
		money = value
		event_bus.money_updated.emit(value)
		
var money_production_rate := 0:
	set(value):
		money_production_rate = value
		event_bus.money_production_rate_updated.emit(value)

var orders_cost := 0:
	set(value):
		orders_cost = value
		
		update_money_production_rate()

#in futur it will also have buildings_cost
func update_money_production_rate():
	money_production_rate = orders_cost

func try_to_buy_resource(resource_type:Resources.Types, amount:int) -> bool:
	if amount == 0 or not Resources.Levels.has(resource_type):
		return true
	
	var cost:int = the_market.get_resource_cost(resource_type) * amount
	
	if money >= cost:
		money -= cost
		return true
		
	return false

func recalculate_orders_cost():
	var market_orders = the_market.orders
	
	if market_orders.is_empty():
		orders_cost = 0
		return
	
	# do not update the orders_cost directly
	# it will be updated at each iteration of the loop
	# so it will be update money production rate at each iteration
	var tmp_orders_cost := 0
	
	for order_key in market_orders:
		var order = market_orders[order_key]
		
		if order.buy_amount == 0:
			continue
			
		tmp_orders_cost -= the_market.get_resource_cost(order_key) * order.buy_amount
		
	orders_cost = tmp_orders_cost
