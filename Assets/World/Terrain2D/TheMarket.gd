extends Node

@onready var the_storage = $"../TheStorage"
@onready var event_bus:EventBus = $"../EventBus"

enum Orders{buy, sell}
var orders = {}

var ticks_cooldown := 2
var current_ticks = 0

func _ready():
	event_bus.ask_create_new_order.connect(_on_ask_create_new_order)
	event_bus.ask_update_order_buy.connect(_on_ask_update_order_buy)
	event_bus.ask_update_order_sell.connect(_on_ask_update_order_sell)

func _on_ask_create_new_order(resource_type:Resources.Types):
	if orders.has(resource_type):
		# ERROR
		return
		
	orders[resource_type] = {Orders.buy:0, Orders.sell:0}
	
	if event_bus != null:
		event_bus.send_create_new_order.emit(resource_type)

func _on_ask_update_order_buy(resource_type:Resources.Types, buy_amount:int):
	if not orders.has(resource_type):
		# ERROR
		return
	
	orders[resource_type][Orders.buy] = buy_amount
	
func _on_ask_update_order_sell(resource_type:Resources.Types, sell_amount:int):
	pass

func _on_TheTicker_timeout():
	current_ticks += 1
	
	if current_ticks >= ticks_cooldown:
		current_ticks = 0
		
		for order_key in orders:
			# TODO consume money
			var buy_amount:int = orders[order_key][Orders.buy]
			
			if buy_amount > 0:
				the_storage.add_resource(order_key, orders[order_key][Orders.buy])
