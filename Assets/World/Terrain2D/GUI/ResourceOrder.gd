extends HBoxContainer

var event_bus:EventBus = null

@onready var _resource_texture = $VBoxContainer/TextureRect

@onready var buy_spin_box = $BuySpinBox

var _resource_type:Resources.Types:
	set(value):
		_resource_type = value
		
		if is_instance_valid(_resource_texture):
			if Resources.Icons.has(value):
				_resource_texture.texture = Resources.Icons[value]

func _ready():
	var current_scene = get_tree().current_scene
	
	if current_scene.has_node("EventBus"):
		event_bus = current_scene.get_node("EventBus") as EventBus

func _on_BuySpinBox_value_changed(value):
	if event_bus != null:
		event_bus.ask_update_order_buy.emit(_resource_type, value)
	
func force_buy_value(buy_amount):
	buy_spin_box.set_value_no_signal(buy_amount)

func _on_SellSpinBox_value_changed(value):
	if event_bus != null:
		event_bus.ask_update_order_sell.emit(_resource_type, value)
