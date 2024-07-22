extends Node

@onready var the_storage = $"../TheStorage"
@onready var the_bank = $"../TheBank"
@onready var event_bus:EventBus = $"../EventBus"

class Order:
	var buy_amount := 0
	var sell_amount := 0

var orders = {}

var ticks_cooldown := 2
var current_ticks = 0

func _ready():
	event_bus.ask_create_new_order.connect(_on_ask_create_new_order)
	event_bus.ask_update_order_buy.connect(_on_ask_update_order_buy)
	event_bus.ask_update_order_sell.connect(_on_ask_update_order_sell)

func get_resource_cost(resource_type:Resources.Types) -> int:
	return (Resources.Levels[resource_type] + 1)

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
	
func _on_ask_update_order_sell(resource_type:Resources.Types, sell_amount:int):
	pass

func _on_TheTicker_timeout():
	current_ticks += 1
	
	if current_ticks >= ticks_cooldown:
		current_ticks = 0
		
		for order_key in orders:
			var buy_amount = orders[order_key].buy_amount
			
			if the_bank.try_to_buy_resource(order_key, buy_amount):
				the_storage.add_resource(order_key, buy_amount)
