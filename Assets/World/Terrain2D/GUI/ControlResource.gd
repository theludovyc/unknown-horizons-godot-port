extends PanelContainer

@export var resource_type : Resources.Types

@onready var label_amount := $HBoxContainer/PanelContainer/HBoxContainer/LabelAmount
@onready var label_production_rate := $HBoxContainer/PanelContainer/HBoxContainer/LabelProductionRate

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_node = get_tree().current_scene
	
	if current_node.has_node("EventBus"):
		var event_bus = current_node.get_node("EventBus")
		
		event_bus.connect("resource_updated", _on_EventBus_resource_updated)
		event_bus.connect("resource_prodution_rate_updated", _on_EventBus_resource_production_rate_updated)

func _on_EventBus_resource_updated(type, amount):
	if type == resource_type:
		label_amount.text = str(amount)
		
func _on_EventBus_resource_production_rate_updated(type, rate):
	if type == resource_type:
		var text_sign = "+" if rate >= 0 else "-"
		
		label_production_rate.text = "(" + text_sign + str(rate) + ")"
