extends Node

@onready var the_storage = $"../TheStorage"
@onready var the_bank = $"../TheBank"
@onready var event_bus:EventBus = $"../EventBus"

class Order:
	var buy_amount := 0
	var sell_amount := 0

var orders = {}

func _ready():
	event_bus.ask_create_new_order.connect(_on_ask_create_new_order)
	event_bus.ask_update_order_buy.connect(_on_ask_update_order_buy)
	event_bus.ask_update_order_sell.connect(_on_ask_update_order_sell)

func get_resource_cost(resource_type:Resources.Types) -> int:
	if not Resources.Levels.has(resource_type):
		# ERROR
		return 0
	
	return (Resources.Levels[resource_type] + 1)

func get_production_rate_per_cycle(resource_type:Resources.Types) -> int:
	if not orders.has(resource_type):
		return 0
		
	var order = orders[resource_type]
	
	return order.buy_amount - order.sell_amount

func _on_ask_create_new_order(resource_type:Resources.Types):
	if orders.has(resource_type):
		# ERROR
		return
		
	orders[resource_type] = Order.new()
	
	if event_bus != null:
		event_bus.send_create_new_order.emit(resource_type)

func _on_ask_update_order_buy(resource_type:Resources.Types, buy_amount:int):
	if not orders.has(resource_type):
		# ERROR
		return
	
	if buy_amount < 0:
		# ERROR
		return
	
	orders[resource_type].buy_amount = buy_amount
	
	the_bank.recalculate_orders_cost()
	
	the_storage.update_global_production_rate(resource_type)
	
func _on_ask_update_order_sell(resource_type:Resources.Types, sell_amount:int):
	if not orders.has(resource_type):
		# ERROR
		return
	
	if sell_amount < 0:
		# ERROR
		return
		
	orders[resource_type].sell_amount = sell_amount
	
	the_bank.recalculate_orders_cost()
	
	the_storage.update_global_production_rate(resource_type)

func _on_TheTicker_cycle():
	for order_key in orders:
		var order = orders[order_key]

		if the_bank.try_to_buy_resource(order_key, order.buy_amount):
			the_storage.add_resource(order_key, order.buy_amount)
		
		if the_storage.try_to_sell_resource(order_key, order.sell_amount):
			the_bank.conclude_sale(order_key, order.sell_amount)
